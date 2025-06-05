require "vector"

ButtonClass = {} 

BLACK = {0, 0, 0, 1}
WHITE = {1, 1, 1, 1}

function ButtonClass:new(xPos, yPos, xSize, ySize, label, offset)
  local button = {}
  local metadata = {__index = ButtonClass}
  setmetatable(button, metadata)
  
  button.size = Vector(xSize, ySize)
  button.position = Vector(xPos, yPos)
  button.isMouseOver = false
  
  button.label = label
  button.offset = offset
  
  button.fillColor = WHITE
  button.textColor = BLACK
  
  return button
end

function ButtonClass:draw()
  love.graphics.setColor(self.fillColor)
  love.graphics.rectangle("fill", self.position.x - 5, self.position.y - 5, self.size.x + 10, self.size.y + 10, 6, 6)
  
  love.graphics.setColor(self.textColor)
  love.graphics.print(self.label, self.position.x + (self.size.x / self.offset), self.position.y + (self.size.y / 3))
end

function ButtonClass:checkForMouseOver(manager)
  local mousePos = grabber.currentMousePos

  self.isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  if self.isMouseOver then
    self.fillColor = BLACK
    self.textColor = WHITE
    
    -- Click (just the first frame)
    if love.mouse.isDown(1) and self.clicked == nil then
      self:click(manager)
      self.clicked = true
    end
    -- Release
    if not love.mouse.isDown(1) and self.clicked ~= nil then
      self.clicked = nil
    end
  else
    self.fillColor = WHITE
    self.textColor = BLACK
  end
  
end

function ButtonClass:setPosition(x, y)
  self.position.x = x
  self.position.y = y
end

-- button definitions (technically a subclass sandbox)

SubmitButton = ButtonClass:new(
  920,
  320,
  120,
  35,
  "SUBMIT",
  3
)
function SubmitButton:new()
  return SubmitButton
end
function SubmitButton:click(manager)
  manager:toPlaying()
end 

RestartButton = ButtonClass:new(
  20,
  800,
  120,
  35,
  "NEW GAME",
  4
)
function RestartButton:new()
  return RestartButton
end
function RestartButton:click(manager)
  self:setPosition(20, 800)
  love.load()
end

