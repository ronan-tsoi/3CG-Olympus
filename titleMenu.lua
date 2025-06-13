require "button"

TitleMenu = {}

function TitleMenu:new()
  local title = {}
  local metadata = {__index = TitleMenu}
  setmetatable(title, metadata)
  
  -- buttons
  title.play = TitlePlay:new()
  title.credits = TitleCredits:new()
  title.quit = TitleQuit:new()
  
  return title
end

function TitleMenu:draw()
  love.graphics.setColor(BLACK)
  love.graphics.print("3CG OLYMPUS \n\n   CMPM 121", (WIDTH / 2) - 55, (HEIGHT / 3), 0, 1.25)
  
  self.play:draw()
  self.credits:draw()
  self.quit:draw()
end

function TitleMenu:update(grabber)
  self.play:checkForMouseOver(self)
  self.credits:checkForMouseOver(self)
  self.quit:checkForMouseOver(self)
end
