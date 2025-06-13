require "vector"

ButtonClass = {} 

BLACK = {0, 0, 0, 1}
WHITE = {1, 1, 1, 1}

WIDTH = 1080
HEIGHT = 780

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

-- titleMenu
TitlePlay = ButtonClass:new((WIDTH / 2) - 60, (HEIGHT / 2), 120, 35, " PLAY", 3)
function TitlePlay:new() return TitlePlay end
function TitlePlay:click(scene)
  SCENE_ID = 3
end

TitleCredits = ButtonClass:new((WIDTH / 2) - 60, (HEIGHT / 2) + 80, 120, 35, " CREDITS", 4)
function TitleCredits:new() return TitleCredits end
function TitleCredits:click(scene)
  SCENE_ID = 2
end

TitleQuit = ButtonClass:new(40, 680, 160, 35, " QUIT GAME", 4)
function TitleQuit:new() return TitleQuit end
function TitleQuit:click(scene)
  love.event.quit()
end

-- creditsMenu
CreditsTitle = ButtonClass:new((WIDTH / 2) - 80, 680, 160, 35, " BACK TO TITLE", 5)
function CreditsTitle:new() return CreditsTitle end
function CreditsTitle:click(scene)
  SCENE_ID = 1
end

-- deckLoader
PlayerNext = ButtonClass:new((WIDTH / 3) - 60, 575, 120, 35, "NEXT", 3)
function PlayerNext:new() return PlayerNext end
function PlayerNext:click(scene)
  if scene.playerInd ~= 6 then
    scene.playerInd = scene.playerInd + 1
  else
    scene.playerInd = 1
  end
end

CpuNext = ButtonClass:new(2 * (WIDTH / 3) - 60, 575, 120, 35, "NEXT", 3)
function CpuNext:new() return CpuNext end
function CpuNext:click(scene)
  if scene.cpuInd ~= 6 then
    scene.cpuInd = scene.cpuInd + 1
  else
    scene.cpuInd = 1
  end
end

PickerBegin = ButtonClass:new((WIDTH / 2) - 60, 680, 120, 35, "BEGIN", 3)
function PickerBegin:new() return PickerBegin end
function PickerBegin:click(scene)
  scene:setDecks()
  SCENE_ID = SCENE_ID + 1

  table.insert(SCENES, GameManager:new(25))
end

PickerTitle = ButtonClass:new(20, 720, 160, 35, " BACK TO TITLE", 5) 
function PickerTitle:new() return PickerTitle end
function PickerTitle:click(scene)
  SCENE_ID = 1
end

-- gameManager
SubmitButton = ButtonClass:new(920, 320, 120, 35, "SUBMIT", 3)
function SubmitButton:new() return SubmitButton end
function SubmitButton:click(manager)
  manager:toPlaying()
end 

RestartButton = ButtonClass:new(20, 800, 120, 35, "  RETRY", 4)
function RestartButton:new() return RestartButton end
function RestartButton:click(manager)
  self:setPosition(20, 800)
  SCENE_ID = 4
  table.remove(SCENES, 4)
  table.insert(SCENES, GameManager:new(25))
end

PickerButton = ButtonClass:new(20, 800, 120, 35, "CHANGE DECKS", 11)
function PickerButton:new() return PickerButton end
function PickerButton:click(manager)
  self:setPosition(20, 800)
  SCENE_ID = 3
  table.remove(SCENES, 4)
end

