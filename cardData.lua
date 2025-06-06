require "card"
require "hand"

-- subclass sandbox for cards

WoodenCow = CardClass:new()
function WoodenCow:new()
  return CardClass:new(
    "Wooden Cow",
    1,
    1,
    "Vanilla"
  )
end

Pegasus = CardClass:new()
function Pegasus:new()
  return CardClass:new(
  "Pegasus",
  3,
  5,
  "Vanilla"
)
end

Minotaur = CardClass:new()
function Minotaur:new()
  return CardClass:new(
    "Minotaur",
    5,
    9,
    "Vanilla"
  )
end
Titan = CardClass:new()
function Titan:new()
  return CardClass:new(
    "Titan",
    6,
    12,
    "Vanilla"
  )
end
Zeus = CardClass:new()
function Zeus:new()
  return CardClass:new(
    "Zeus",
    2,
    3,
    "ON REVEAL: \nPower -1 for \neach card in \nenemy hand"
  )
end

Ares = CardClass:new()
function Ares:new()
  return CardClass:new(
    "Ares",
    3,
    3,
    "ON REVEAL: \nPower +2 for \neach enemy \ncard here"
  )
end
Cyclops = CardClass:new()
function Cyclops:new()
  return CardClass:new(
    "Cyclops",
    6,
    8,
    "ON REVEAL: \nDiscard other \ncards here, \n+2 power \nfor each"
  )
end
Hades = CardClass:new()
function Hades:new()
  return CardClass:new(
    "Hades",
    2,
    3,
    "ON REVEAL: \nPower +2 for \neach card in \ndiscard pile"
  )
end
Hercules = CardClass:new()
function Hercules:new()
  return CardClass:new("Hercules",
    4,
    7,
    "ON REVEAL: \nPower x2 if \nthe strongest \ncard here"
  )
end

Dionysus = CardClass:new()
function Dionysus:new()
  return CardClass:new(
    "Dionysus",
    3,
    3,
    "ON REVEAL: \nPower +2 for \neach of your \ncards here"
  )
end
ShipOfTheseus = CardClass:new()
function ShipOfTheseus:new(givenPower)
  local power = (givenPower ~= nil) and givenPower or 8 -- default to 8
  return CardClass:new(
    "Ship of",
    5,
    power,
    "Theseus \nON REVEAL: \nAdd a copy \n+1 power \nto your hand"
  )
end
Midas = CardClass:new()
function Midas:new()
  return CardClass:new(
    "Midas",
    3,
    5,
    "ON REVEAL: \nSet ALL \ncards here \nto 3 power"
  )
end
Hephaestus = CardClass:new()
function Hephaestus:new()
  return CardClass:new(
    "Hephaestus",
    2,
    2,
    "ON REVEAL: \nCost -1 for \neach card in \nyour hand"
  )
end
Nyx = CardClass:new()
function Nyx:new()
  return CardClass:new(
    "Nyx",
    3,
    3,
    "ON REVEAL: \nDiscard your \ncards here, \nadd power \nto this"
  )
end

function CardClass:ability(manager) 
  if self.name == "Zeus" then -- power -1 enemy hand
    if self.side == 1 then
      for _, card in ipairs(manager.cpuHand.cards) do
        card:addPower(-1)
      end
    else
      for _, card in ipairs(manager.playerHand.cards) do
        card:addPower(-1)
      end
    end
  
  elseif self.name == "Ares" then -- gain +2 power for each enemy card here
    if self.side == 1 then
      self:addPower(2 * #self.currentLocation.side2cards)
    else
      self:addPower(2 * #self.currentLocation.side1cards)
    end

  
  elseif self.name == "Cyclops" then -- discard other player cards here, +2 per discard
    local toDiscard = {}
    if self.side == 1 then
      for _, card in ipairs(self.currentLocation.side1cards) do
        if card ~= self then
          table.insert(toDiscard, card)
        end
      end
    else
      for _, card in ipairs(self.currentLocation.side1cards) do
        if card ~= self then
          table.insert(toDiscard, card)
        end
      end
    end
    for _, card in ipairs(toDiscard) do
      self:addPower(2)
      card:discard(manager)
    end
    
  
  elseif self.name == "Hades" then -- power +2 for each card in player discard
    if self.side == 1 then
      self:addPower(2 * #manager.playerDiscard)
    else
      self:addPower(2 * #manager.cpuDiscard)
    end
  
  elseif self.name == "Hercules" then -- double power if it is the strongest card here
    for _, card in ipairs(self.currentLocation.side1cards) do
      if card.power >= self.power and card ~= self then
        return
      end
    end
    for _, card in ipairs(self.currentLocation.side2cards) do
      if card.power >= self.power then
        return
      end
    end
    self:setPower(self.power * 2)
  
  elseif self.name == "Dionysus" then -- gain +2 power for each player card here
    if self.side == 1 then
      for _, card in ipairs(self.currentLocation.side1cards) do
        if card ~= self then
          self:addPower(2)
        end
      end
    else
        for _, card in ipairs(self.currentLocation.side2cards) do
        if card ~= self then
          self:addPower(2)
        end
      end
    end

  elseif self.name == "Ship of" then -- add a copy with +1 power to player hand
    if self.side == 1 then
      manager.playerHand:addCard(ShipOfTheseus:new(self.power + 1))
    else
      manager.cpuHand:addCard(ShipOfTheseus:new(self.power + 1))
    end
  
  elseif self.name == "Midas" then -- set all cards here to 3 power
    for _, card in ipairs(self.currentLocation.side1cards) do
      if card ~= self then
        card:setPower(3)
      end
    end
    for _, card in ipairs(self.currentLocation.side2cards) do
      if card ~= self then
        card:setPower(3)
      end
    end
  
  elseif self.name == "Hephaestus" then -- cost -1 for all cards in your hand
    if self.side == 1 then
      for _, card in ipairs(manager.playerHand.cards) do
        card:addCost(-1)
      end
    else
        for _, card in ipairs(manager.cpuHand.cards) do
        card:addCost(-1)
      end
    end
  
  elseif self.name == "Nyx" then -- discard other player cards here, add power to this card
    local toDiscard = {}
    if self.side == 1 then
      for _, card in ipairs(self.currentLocation.side1cards) do
        if card ~= self then
          table.insert(toDiscard, card)
        end
      end
    else
        for _, card in ipairs(self.currentLocation.side2cards) do
        if card ~= self then
          table.insert(toDiscard, card)
        end
      end
    end
    for _, card in ipairs(toDiscard) do
      self:addPower(card.power)
      card:discard(manager)
    end
  
  end
end
