require "location"
require "hand"
require "deckLoader"
require "deckPicker"
require "button"

GameManager = {}

GAME_STATE = {
  STANDBY = 0,
  PLAYING = 1,
  NEW_TURN = 2,
  COMPLETE = 3
}

SIDE = {
  PLAYER = 1,
  CPU = 2,
  TIE = 3
}

-- gameManager
-- singleton 
-- initialize game -- 3 locations, fresh decks for players

function GameManager:new(goalScore)
  local manager = {}
  local metadata = {__index = GameManager}
  setmetatable(manager, metadata)
  manager.state = GAME_STATE.STANDBY
  
  manager.goalScore = goalScore
  manager.roundNum = 1
  manager.winningPlayer = SIDE.TIE
  manager.winner = nil
  
  manager.deckLoader = DeckLoaderClass:new()
  
  -- Player
  manager.playerDeck = PLAYER_DECK
  manager.playerHand = HandClass:new(240, 660, 1)
  manager.playerDiscard = {}
  manager.playerPoints = 0
  manager.playerMana = 1
  
  for i = 1, 3, 1 do
    manager.playerHand:addCard(manager.playerDeck)
  end
  
  -- CPU
  manager.cpuDeck = CPU_DECK
  manager.cpuHand = HandClass:new(240, 10, 2)
  manager.cpuDiscard = {}
  manager.cpuPoints = 0
  manager.cpuMana = 1
  
  for i = 1, 3, 1 do
    manager.cpuHand:addCard(manager.cpuDeck)
    manager.cpuHand.cards[#manager.cpuHand.cards].isFaceUp = false
  end
  
  manager.locations = {}
  table.insert(manager.locations, LocationClass:new("ITHACA", 200, 140))
  table.insert(manager.locations, LocationClass:new("TROY", 450, 140))
  table.insert(manager.locations, LocationClass:new("SPARTA", 700, 140))
  
  -- buttons
  manager.submit = SubmitButton:new()
  manager.restart = RestartButton:new()
  manager.picker = PickerButton:new()
  
  return manager
end

function GameManager:draw()
  love.graphics.setColor(BLACK)
  love.graphics.print("ROUND " .. self.roundNum, 55, 350)
  love.graphics.print(self.goalScore .. " TO WIN", 50, 380)
  
  for _, loc in ipairs(self.locations) do
    loc:draw()
  end
  self.playerHand:draw()
  self.cpuHand:draw()
  
  love.graphics.print("TOTAL POINTS: " .. self.cpuPoints, 860, 30)
  
  love.graphics.print("MANA: " .. self.playerMana, 860, 660)
  love.graphics.print("TOTAL POINTS: " .. self.playerPoints, 860, 690)
  
  if self.state == GAME_STATE.COMPLETE then
    if self.winner == SIDE.PLAYER then
      love.graphics.print("PLAYER 1 \nWINS", 960, 390)
    elseif self.winner == SIDE.CPU then
      love.graphics.print("CPU \nWINS", 960, 390)
    else
      love.graphics.print("DRAW \nNO WINNER", 960, 390)
    end
  end
  
  self.submit:draw()
  if self.state == GAME_STATE.COMPLETE then
    self.restart:draw()
    self.picker:draw()
  end
end

function GameManager:update(grabber)
  if self.state == GAME_STATE.STANDBY then
    -- respond to player input: dragging cards deck -> locations -> add to queue for revealing cards
    -- state is set to playing when player presses submit
    
    self.playerHand:checkForMouseOver(grabber)
    self.submit:checkForMouseOver(self)
    for _, loc in ipairs(self.locations) do
      loc:checkForMouseOver(grabber, self)
    end
    
  elseif self.state == GAME_STATE.PLAYING then
    -- handled in location class- returns updated scores
    --    reveal cards -> play On Reveal abilities
    --    calculate points at locations -> sum to player point count -> update winning player
    --    check for game completion requirement- if players have reached goalScore

    self.cpuFlag = self:cpuBehavior()
    
  elseif self.state == GAME_STATE.NEW_TURN then
    -- initialize new turn- increase mana +1, draw cards from decks
    
    self.roundNum = self.roundNum + 1
    self.playerMana = self.roundNum
    self.cpuMana = self.roundNum
    
    -- draw cards from decks
    self.playerHand:addCard(self.playerDeck)
    
    self.cpuHand:addCard(self.cpuDeck)
    self.cpuHand.cards[#self.cpuHand.cards].isFaceUp = false
    
    self.state = GAME_STATE.STANDBY
    
  elseif self.state == GAME_STATE.COMPLETE then
    self.restart:checkForMouseOver(self)
    self.picker:checkForMouseOver(self)
    return
  end
end

function GameManager:cpuBehavior()
    -- Tries to play every card once to a random location
    for i = 1, #self.cpuHand.cards, 1 do
      math.randomseed(os.time())
      self.locations[math.random(1, 3)]:evaluateDropInput(self.cpuHand, self, 2)
    end
    
    self:revealCards()
end

function GameManager:revealCards()
  -- reveal cards and add points from every location to player scores
    for _, loc in ipairs(self.locations) do
      loc:refreshCardPos()
      loc:revealCards(self.winningPlayer, self)
      local addToScore = loc:updatePoints()
      
      if loc.currentWinner == SIDE.PLAYER then
        self.playerPoints = self.playerPoints + addToScore
      else
        self.cpuPoints = self.cpuPoints + addToScore
      end
      loc:allFaceUp()
    end

    
    for _, loc in ipairs(self.locations) do
        for _, card in ipairs(loc.side1cards) do
          card:abilityEndOfTurn(self)
        end
        for _, card in ipairs(loc.side2cards) do
          card:abilityEndOfTurn(self)
        end
      end

    self:checkScores()
end

function GameManager:checkScores()
  -- which player currently has more points
    if self.playerPoints > self.cpuPoints then
      self.winningPlayer = SIDE.PLAYER
    elseif self.cpuPoints > self.playerPoints then
      self.winningPlayer = SIDE.CPU
    else
      self.winningPlayer = 3
    end

    self:checkGameCompletion()
end

function GameManager:checkGameCompletion()
  -- check game completion
    if self.playerPoints >= self.goalScore and self.cpuPoints < self.goalScore then -- player reaches goal first
      self.winner = SIDE.PLAYER
    elseif self.playerPoints < self.goalScore and self.cpuPoints >= self.goalScore then -- cpu reaches goal first
      self.winner = SIDE.CPU 
    elseif self.playerPoints >= self.goalScore and self.cpuPoints >= self.goalScore then -- both sides reach the goal on the same round
      if self.playerPoints > self.cpuPoints then
        self.winner = SIDE.PLAYER
      elseif self.playerPoints < self.cpuPoints then
        self.winner = SIDE.CPU 
      else
        self.winner = SIDE.TIE 
      end
    end
    
    if self.winner == nil then
        self.state = GAME_STATE.NEW_TURN
    else
        self.restart:setPosition(20, 20)
        self.picker:setPosition(20, 75)
        self.state = GAME_STATE.COMPLETE
    end
end

function GameManager:toPlaying()
  self.state = GAME_STATE.PLAYING
end

