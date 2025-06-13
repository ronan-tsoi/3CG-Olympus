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
  local power = (givenPower ~= nil) and givenPower or 2 -- default to 2
  return CardClass:new(
    "Ship of\nTheseus",
    2,
    power,
    "ON REVEAL: \nAdd a copy \n+1 power \nto your hand"
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
Medusa = CardClass:new()
function Medusa:new()
  return CardClass:new(
    "Medusa",
    1,
    3,
    "If ANY card \nis played \nhere, \nPower -1 \nfor that card"
  )
end
Artemis = CardClass:new()
function Artemis:new()
  return CardClass:new(
    "Artemis",
    2,
    3,
    "ON REVEAL: \nPower +5 if \nthere is ONE \nenemy card \nhere"
  )
end
Demeter = CardClass:new()
function Demeter:new()
  return CardClass:new(
    "Demeter",
    2,
    4,
    "ON REVEAL: \nBoth players \ndraw a card"
  )
end
Hermes = CardClass:new()
function Hermes:new()
  return CardClass:new(
    "Hermes",
    2,
    4,
    "ON REVEAL: \nMoves to \na random \nlocation"
  )
end
SwordOfDamocles = CardClass:new()
function SwordOfDamocles:new()
  return CardClass:new(
    "Sword of\nDamocles",
    2,
    5,
    "END OF TURN: \nPower -1 if \nnot winning \nthis location"
  )
end
Hydra = CardClass:new()
function Hydra:new()
  return CardClass:new(
    "Hydra",
    2,
    3,
    "ON DISCARD: \nAdd 2 \ncopies to \nyour hand"
  )
end
Athena = CardClass:new()
function Athena:new()
  return CardClass:new(
    "Athena",
    3,
    3,
    "Power +1 \nwhen you \nplay \nanother \ncard here"
  )
end
Persephone =  CardClass:new()
function Persephone:new()
  return CardClass:new(
    "Persephone",
    2,
    4,
    "ON REVEAL: \nDiscard the \nlowest power \ncard in \nyour hand"
  )
end
Prometheus = CardClass:new()
function Prometheus:new()
  return CardClass:new(
    "Prometheus",
    2,
    3,
    "ON REVEAL: \nDraw a \ncard from \nthe enemy \ndeck"
  )
end
Hera = CardClass:new()
function Hera:new()
  return CardClass:new(
    "Hera",
    3,
    3,
    "ON REVEAL: \nPower +1 for \neach card in \nyour hand"
  )
end


function CardClass:abilityOnCardPlay(manager, newCard)
  if self.name == "Medusa" then -- -1 power to any card played on either side
    if newCard ~= self then
      newCard:addPower(-1)
    end
    
  elseif self.name == "Athena" then -- +1 power to self when card is played on the same side
    if newCard.currentLocation == self.currentLocation and newCard.side == self.side then
      self:addPower(1)
    end
  end
  
end

function CardClass:abilityEndOfTurn(manager)
  if self.name == "Sword of\nDamocles" then -- -1 power if the side is not currently winning
    if self.side == 1 then
      if self.currentLocation.side1power <= self.currentLocation.side2power then
        self:addPower(-1)
      end
    else
      if self.currentLocation.side2power <= self.currentLocation.side1power then
        self:addPower(-1)
      end
    end
    
  end
  
end

function CardClass:abilityOnDiscard(manager)
  if self.name == "Hydra" then -- add 2 copies to own hand
    local copies = {}
    table.insert(copies, Hydra:new())
    table.insert(copies, Hydra:new())
    
    if self.side == 1 then
      manager.playerHand:addCard(copies)
      manager.playerHand:addCard(copies)
    else
      manager.cpuHand:addCard(copies)
      manager.cpuHand:addCard(copies)
    end
  end
end

function CardClass:abilityOnReveal(manager) 
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
      for _, card in ipairs(self.currentLocation.side2cards) do
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
      if card.power >= self.power and card ~= self then
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

elseif self.name == "Ship of\nTheseus" then -- add a copy with +1 power to player hand
    local copy = {ShipOfTheseus:new(self.power + 1)}
    if self.side == 1 then
      manager.playerHand:addCard(copy)
    else
      copy[1].isFaceUp = false
      manager.cpuHand:addCard(copy)
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
    
  elseif self.name == "Artemis" then -- +5 power if there is exactly one opposing card
    if self.side == 1 then
      if #self.currentLocation.side2cards == 1 then
        self:addPower(5)
      end
    else
      if #self.currentLocation.side1cards == 1 then
        self:addPower(5)
      end
      
    end
    
  elseif self.name == "Demeter" then -- both sides draw a card
    manager.playerHand:addCard(manager.playerDeck)
    
    manager.cpuHand:addCard(manager.cpuDeck)
    manager.cpuHand.cards[#manager.cpuHand.cards].isFaceUp = false
    
  elseif self.name == "Hermes" then -- moves to a random (not full) location
    local rand = math.random(1, 3)
    
    if self.side == 1 then
      while #manager.locations[rand].side1cards == LOCATION_MAX do
        rand = math.random(1, 3) -- re-roll if the side is full
      end
      local i = 1
      for ind, card in ipairs(self.currentLocation) do
        if card == self then
          i = ind
          break
        end
      end
      table.remove(self.currentLocation.side1cards, i)
      
      manager.locations[rand]:moveCard(self, manager, 1)
    else
      while #manager.locations[rand].side2cards == LOCATION_MAX do
        rand = math.random(1, 3) -- re-roll if the side is full
      end
      local i = 1
      for ind, card in ipairs(self.currentLocation) do
        if card == self then
          i = ind
          break
        end
      end
      table.remove(self.currentLocation.side2cards, i)
      
      manager.locations[rand]:moveCard(self, manager, 2)
      
    end
    self.currentLocation:refreshCardPos()
    
  elseif self.name == "Persephone" then -- discards a random card of the lowest power
    if self.side == 1 then
      local lowest = manager.playerHand.cards[math.random(1, #manager.playerHand.cards)]
      
      for _, card in ipairs(manager.playerHand.cards) do
        if card.power < lowest.power then
          lowest = card
        end
      end
      lowest:discard(manager)
    else
      local lowest = manager.cpuHand.cards[math.random(1, #manager.cpuHand.cards)]
      
      for _, card in ipairs(manager.cpuHand.cards) do
        if card.power < lowest.power then
          lowest = card
        end
      end
      lowest:discard(manager)
      for index, card in ipairs(manager.cpuHand.cards) do
        card.position.x = manager.cpuHand.position.x + (OFFSET * (index-1))
      end
    end
    
  elseif self.name == "Prometheus" then -- draw from opposing deck
    if self.side == 1 then
      manager.playerHand:addCard(manager.cpuDeck)
    else
      manager.cpuHand:addCard(manager.playerDeck)
    end
  elseif self.name == "Hera" then -- +1 power for cards in own hand
    if self.side == 1 then
      for _, card in ipairs(manager.playerHand.cards) do
        if card ~= self then
          card:addPower(1)
        end
      end
    else
      for _, card in ipairs(manager.cpuHand.cards) do
        if card ~= self then
          card:addPower(1)
        end
      end
    end
  
  end
end
