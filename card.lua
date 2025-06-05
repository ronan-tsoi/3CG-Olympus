require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

WHITE = {1, 1, 1, 1}
BLACK = {0, 0, 0, 1}

function CardClass:new(name, cost, power, description)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(80, 112)
  card.state = CARD_STATE.IDLE
  card.isMouseOver = false
  card.isFaceUp = true
  
  card.currentLocation = nil
  card.side = nil
  
  card.name = name
  card.description = description
  
  card.cost = cost
  card.power = power
  
  return card
end

function CardClass:draw()

  love.graphics.setColor(WHITE)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  
  love.graphics.setColor(BLACK)
  if self.isFaceUp then
    love.graphics.print(self.cost, self.position.x + 10, self.position.y + 10)
    love.graphics.print(self.power, self.position.x + 60, self.position.y + 10)
    love.graphics.print(self.name, self.position.x + 2, self.position.y + 25)
    love.graphics.print(self.description, self.position.x + 2, self.position.y + 40)
  else
    love.graphics.print('+', self.position.x + 35, self.position.y + 48)
  end

  love.graphics.rectangle("line", self.position.x - 1, self.position.y - 1, self.size.x + 2, self.size.y + 2, 6, 6)
  
  -- DEBUG
  --[[ love.graphics.print(
    tostring(self.state),
    self.position.x + 20, self.position.y - 20
    ) ]]--
end

function CardClass:addPower(value)
  self.power = self.power + value
end

function CardClass:setPower(value)
  self.power = value
end

function CardClass:addCost(value)
  self.cost = self.cost + value
end

function CardClass:setPosition(x, y)
  self.position.x = x
  self.position.y = y
end

function CardClass:flip()
  --self.isFaceUp = self.isFaceUp and 0 or 1
  self.isFaceUp = self.isFaceUp and false or true
end

function CardClass:discard(manager)
  print("test")
  local i = 1
  for ind, card in ipairs(self.currentLocation) do
    if card == self then
      i = ind
      break
    end
  end
  table.remove(self.currentLocation.side1cards, i)
  table.insert(manager.playerDiscard, self)
end

function CardClass:checkForMouseOver(grabber)  
  local mousePos = grabber.currentMousePos
  
  self.isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  if grabber.grabPos ~= nil and #grabber.cards == 0 then
    if self.isMouseOver then
      self.state = CARD_STATE.GRABBED
      table.insert(grabber.cards, self)
      end
  else
    if self.isMouseOver then
      self.state = CARD_STATE.MOUSE_OVER
    else
      self.state = CARD_STATE.IDLE
    end
  end
  
  if self.state == CARD_STATE.GRABBED then
    self.position.x =  mousePos.x - (self.size.x / 2)
    self.position.y =  mousePos.y - (self.size.y / 2)
    grabber.grabbing = true
  elseif self.state == CARD_STATE.MOUSE_OVER and grabber.state ~= 1 then
    grabber.grabbing = false
  end

end