require "button"

CreditsMenu = {}

function CreditsMenu:new()
  local credits = {}
  local metadata = {__index = CreditsMenu}
  setmetatable(credits, metadata)
  
  credits.bodyText = "PROGRAMMING - Ronan Tsoi"
  
  -- buttons
  credits.title = CreditsTitle:new()
  
  return credits
end

function CreditsMenu:draw()
  love.graphics.setColor(BLACK)
  love.graphics.print("CREDITS", (WIDTH / 2) - 30, 100, 0, 1.25)
  
  love.graphics.print(self.bodyText, (WIDTH / 2) - 80, (HEIGHT / 2) - 20)
  
  self.title:draw()
end

function CreditsMenu:update(grabber)
  self.title:checkForMouseOver(self)
end
