require "vector"
require "reader"

HandClass = {} 

BLACK = {0, 0, 0, 1}

OFFSET = 85

function HandClass:new(xPos, yPos, side)
  local hand = {}
  local metadata = {__index = HandClass}
  setmetatable(hand, metadata)
  
  hand.size = Vector(590, 112)
  hand.position = Vector(xPos, yPos)
  hand.cards = {}
  hand.isMouseOver = false
  hand.side = side
  
  hand.reader = ReaderClass:new(50, 500)
  
  return hand
end

function HandClass:draw()
  love.graphics.setColor(BLACK)
  love.graphics.rectangle("line", self.position.x - 5, self.position.y - 5, self.size.x + 10, self.size.y + 10, 6, 6)

  for _, card in ipairs(self.cards) do
    card:draw()
  end
  
  self.reader:draw()

end


function HandClass:addCard(source)
  if self.cards ~= nil and #source > 0 then
    if #self.cards < 7 then
      local topCard = table.remove(source)
      table.insert(self.cards, topCard)
      topCard:setPosition(self.position.x + (OFFSET * (#self.cards-1)), self.position.y)
      topCard.currentLocation = self.cards
      topCard.side = self.side
    else
      return 0 -- could not add card: hand is full
    end
  elseif #source > 0 then
    local topCard = table.remove(source)
    self.cards = {topCard}
    topCard:setPosition(self.position.x + (OFFSET * (#self.cards-1)), self.position.y)
    topCard.currentLocation = self.cards
    topCard.side = self.side
  end
  return 1
end

function HandClass:checkForMouseOver(grabber)  -- other: pass other stacks through the function- mainly used to link up the deck/draw piles
  local mousePos = grabber.currentMousePos

  self.isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  --drag input
  self:evaluateDragInput(grabber, other)
  -- drop input-- cards can only be dropped into locations, no click/drag
  if self.isMouseOver and #grabber.cards ~= 0 and grabber.state == 2 then
    self:evaluateDropInput(grabber)  
  end
end

function HandClass:evaluateDragInput(grabber)
  if grabber.state == 1 and #grabber.cards == 0 and #self.cards ~= 0 then
    if self.isMouseOver then
      grabber.grabbing = true
      local cursorInd = math.floor((grabber.currentMousePos.x - self.position.x) / OFFSET) + 1
      if cursorInd < 1 then cursorInd = 1 end
        
      if self.cards[cursorInd] ~= nil then
          local topCard = table.remove(self.cards, cursorInd)
          table.insert(grabber.cards, topCard)
          for index, card in ipairs(self.cards) do
            card.position.x = self.position.x + (OFFSET * (index-1))
          end
      end
        
    end
  elseif grabber.state ~= 1 and #grabber.cards == 0 and #self.cards ~= 0 and self.isMouseOver then
    local cursorInd = math.floor((grabber.currentMousePos.x - self.position.x) / OFFSET) + 1
    if self.cards[cursorInd] ~= nil then
      --print(self.cards[cursorInd].name)
      self.reader:set(self.cards[cursorInd])
    else
      self.reader:set(nil)
    end
    
  end
end

function HandClass:evaluateDropInput(grabber)
  local topCard = table.remove(grabber.cards)
  table.insert(self.cards, topCard)
  for index, card in ipairs(self.cards) do
    card.position.x = self.position.x + (OFFSET * (index-1))
  end
  topCard.position.y = self.position.y
end

