-- Ronan Tsoi
-- CMPM 121 - 3CG
-- 5-26-25

-- main
-- handles cursor input
-- game is handled in gameManager

io.stdout:setvbuf("no")
require "grabber"
require "gameManager"

function love.load()
  love.window.setTitle("3CG Olympus")
  love.window.setMode(1080, 780)
  love.graphics.setBackgroundColor(0.4, 0.6, 0.8, 1)
  
  grabber = GrabberClass:new()
  
  manager = GameManager:new(nil, nil, 25)
  
end

function love.update()
  grabber:update()
  manager:stateHandler(grabber)
end

function love.draw()
  manager:draw()
  grabber:draw()
end

