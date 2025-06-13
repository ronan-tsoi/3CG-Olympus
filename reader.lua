require "vector"

ReaderClass = {} 

BLACK = {0, 0, 0, 1}

function ReaderClass:new(xPos, yPos)
  local reader = {}
  local metadata = {__index = ReaderClass}
  setmetatable(reader, metadata)
  
  reader.size = Vector(80, 140)
  reader.position = Vector(xPos, yPos)
  reader.reading = nil
  
  return reader
end

function ReaderClass:draw()
  love.graphics.print("DESCRIPTION", self.position.x + 1, self.position.y - 35)
  love.graphics.rectangle("line", self.position.x - 4, self.position.y - 4, self.size.x + 8, self.size.y + 8, 6, 6)
  if self.reading ~= nil then
    love.graphics.print(self.reading.name, self.position.x, self.position.y)
    love.graphics.print(self.reading.description, self.position.x, self.position.y + 35)
  end
end

function ReaderClass:set(card)
  if card ~= nil then
    self.reading = card
  else
    self.reading = nil
  end
end
