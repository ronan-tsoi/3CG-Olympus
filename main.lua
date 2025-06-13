-- Ronan Tsoi
-- CMPM 121 - 3CG
-- 5-26-25

io.stdout:setvbuf("no")
require "grabber"
require "titleMenu"
require "creditsMenu"
require "deckPicker"
require "gameManager"

SCENE_ID = 1

WIDTH = 1080
HEIGHT = 780

SCENES = {}

function love.load()
  love.window.setTitle("3CG Olympus")
  love.window.setMode(WIDTH, HEIGHT)
  love.graphics.setBackgroundColor(0.4, 0.6, 0.8, 1)
  
  table.insert(SCENES, TitleMenu:new())
  table.insert(SCENES, CreditsMenu:new())
  table.insert(SCENES, DeckPicker:new())
  
  
  grabber = GrabberClass:new()
end

function love.update()
  grabber:update()
  SCENES[SCENE_ID]:update(grabber)
end

function love.draw()
  SCENES[SCENE_ID]:draw()
  grabber:draw()
end

