require "vector"
require "cardData"

LocationClass = {} 

BLACK = {0, 0, 0, 1}

LOCATION_MAX = 4

SIDE = {
  PLAYER = 1,
  CPU = 2,
  TIE = 3
}

function LocationClass:new(name, xPos, yPos)
  local location = {}
  local metadata = {__index = LocationClass}
  setmetatable(location, metadata)
  
  location.name = name
  location.size = Vector(160, 224) -- size of one side
  location.position = Vector(xPos, yPos)
  location.currentWinner = 0
  
  location.side1pos = Vector(xPos - 5, yPos - 5 + 270)
  location.side1cards = {}
  location.side1power = 0
  
  location.side2pos = Vector(xPos - 5, yPos - 5)
  location.side2cards = {}
  location.side2power = 0
  
  location.isMouseOver = false
  
  return location
end

function LocationClass:draw()
  love.graphics.setColor(BLACK)
  -- side 2 (CPU)
  love.graphics.rectangle("line", self.side2pos.x, self.side2pos.y, self.size.x + 15, self.size.y + 15, 6, 6)
  for index, card in ipairs(self.side2cards) do
    card:draw()
  end
  -- name
  love.graphics.print(self.side1power, self.position.x + 5, self.position.y + 242)
  love.graphics.print(self.name, self.position.x + 60, self.position.y + 242)
  love.graphics.print(self.side2power, self.position.x + 150, self.position.y + 242)
  -- side 1 (PLAYER)
  love.graphics.rectangle("line", self.side1pos.x, self.side1pos.y, self.size.x + 15, self.size.y + 15, 6, 6)
  for index, card in ipairs(self.side1cards) do
    card:draw()
  end
end

function LocationClass:checkForMouseOver(grabber, manager)
  local mousePos = grabber.currentMousePos

  self.isMouseOver =
    mousePos.x > self.side1pos.x and
    mousePos.x < self.side1pos.x + self.size.x and
    mousePos.y > self.side1pos.y and
    mousePos.y < self.side1pos.y + self.size.y
  
  -- drop input-- cards can only be dropped into locations, no click/drag
  if self.isMouseOver and #grabber.cards ~= 0 and grabber.state == 2 then
    self:evaluateDropInput(grabber, manager, SIDE.PLAYER)  
  end
end

function LocationClass:evaluateDropInput(source, manager, side)
  if side == SIDE.PLAYER then
    if #self.side1cards == LOCATION_MAX then return 0 end -- location is full
    if source.cards[1].cost > manager.playerMana then return 0 end -- not enough mana

    local topCard = table.remove(source.cards)
    table.insert(self.side1cards, topCard)
    topCard.currentLocation = self
    topCard.isFaceUp = false
    if self.position ~= nil then
      local rowOffset = ( (#self.side1cards + 1) % 2 ) * 85
      local colOffset = ( (#self.side1cards > 2) and 1 or 0 ) * 117
      topCard:setPosition(self.side1pos.x + rowOffset + 5, self.side1pos.y + colOffset + 5)
    end
    manager.playerMana = manager.playerMana - topCard.cost
    return 1
  
  elseif side == SIDE.CPU then -- plays the first possible card in source e.g. cpu deck
    if #self.side2cards == LOCATION_MAX then return 0 end -- location is full
    
    for index, card in ipairs(source.cards) do
      if card.cost > manager.cpuMana then break end -- not enough mana
      
      table.insert(self.side2cards, card)
      card.currentLocation = self
      if self.position ~= nil then
        local rowOffset = ( (#self.side2cards + 1) % 2 ) * 85
        local colOffset = ( (#self.side2cards > 2) and 1 or 0 ) * 117
      end
      manager.cpuMana = manager.cpuMana - card.cost
      
      table.remove(source.cards, index)
      break
    end
    
    for index, card in ipairs(source.cards) do
            card.position.x = source.position.x + (OFFSET * (index-1))
          end
    
    return 1
  end
end

function LocationClass:refreshCardPos()
  for index, card in ipairs(self.side1cards) do
    local rowOffset = ( (index + 1) % 2 ) * 85
    local colOffset = ( (index > 2) and 1 or 0 ) * 117
    card:setPosition(self.side1pos.x + rowOffset + 5, self.side1pos.y + colOffset + 5)
  end
  for index, card in ipairs(self.side2cards) do
    local rowOffset = ( (index + 1) % 2 ) * 85
    local colOffset = ( (index > 2) and 1 or 0 ) * 117
    card:setPosition(self.side2pos.x + rowOffset + 5, self.side2pos.y + colOffset + 5)
  end
end

function LocationClass:revealCards(winningPlayer, manager) -- flips every card in the queue + use on reveal abilities
  if winningPlayer ~= nil then
    first = winningPlayer
  else
    first = math.random(1, 2) -- currently reproducible
  end
  
  if first == 1 then
    self:revealSide1(manager)
    self:revealSide2(manager)
  elseif first == 2 then
    self:revealSide2(manager)
    self:revealSide1(manager)
  end
end
function LocationClass:revealSide1(manager)
  if self.side1cards ~= nil then
    for _, card in ipairs(self.side1cards) do
      card.side = 1
      if card.isFaceUp == false then
        card:flip()
        card:ability(manager)
      end
    end
  end
end
function LocationClass:revealSide2(manager)
  if self.side2cards ~= nil then
    for _, card in ipairs(self.side2cards) do
      card.side = 2
      if card.isFaceUp == false then
        card:flip()
        card:ability(manager)
      end
    end
  end
end

function LocationClass:allFaceUp() --hard coding this for a bug.. oops
  for _, card in ipairs(self.side1cards) do
    card.isFaceUp = true
  end
  for _, card in ipairs(self.side2cards) do
    card.isFaceUp = true
  end
end

function LocationClass:updatePoints() -- sum powers for each side, return difference
  self.side1power = 0
  for _, card in ipairs(self.side1cards) do
    self.side1power = self.side1power + card.power
  end
  self.side2power = 0
  for _, card in ipairs(self.side2cards) do
    self.side2power = self.side2power + card.power
  end
  if self.side1power > self.side2power then
    self.currentWinner = 1
    return self.side1power - self.side2power
  elseif self.side2power > self.side1power then
    self.currentWinner = 2
    return self.side2power - self.side1power
  else
    self.currentWinner = nil
    return 0
  end
end

