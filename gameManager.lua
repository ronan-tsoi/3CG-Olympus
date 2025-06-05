require "location"
require "hand"
require "deckLoader"
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

function GameManager:new(player1, player2, goalScore)
  local manager = {}
  local metadata = {__index = GameManager}
  setmetatable(manager, metadata)
  manager.state = GAME_STATE.STANDBY
  
  manager.goalScore = goalScore
  manager.roundNum = 1
  manager.winningPlayer = nil
  manager.winner = nil
  
  manager.deckLoader = DeckLoaderClass:new()
  
  -- Player
  manager.playerDeck = manager.deckLoader:loadDefaultDeck()
  manager.playerHand = HandClass:new(240, 660)
  manager.playerDiscard = {}
  manager.playerPoints = 0
  manager.playerMana = 1
  
  for i = 1, 3, 1 do
    manager.playerHand:addCard(manager.playerDeck)
  end
  
  -- CPU
  math.randomseed(os.time())
  manager.cpuDeck = manager.deckLoader:loadDefaultDeck()
  manager.cpuHand = HandClass:new(240, 10)
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
  manager.submitButton = SubmitButton:new()
  manager.restartButton = RestartButton:new()
  
  manager.cpuFlag = 0
  manager.revealFlag = 0
  manager.scoringFlag = 0
  manager.completionFlag = 0
  
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
  
  self.submitButton:draw()
  self.restartButton:draw()
end

function GameManager:stateHandler(grabber)
  if self.state == GAME_STATE.STANDBY then
    -- respond to player input: dragging cards deck -> locations -> add to queue for revealing cards
    -- state is set to playing when player presses submit
    
    self.playerHand:checkForMouseOver(grabber)
    self.submitButton:checkForMouseOver(manager)
    for _, loc in ipairs(self.locations) do
      loc:checkForMouseOver(grabber, self)
    end
    
  elseif self.state == GAME_STATE.PLAYING then
    -- handled in location class- returns updated scores
    --    reveal cards -> play On Reveal abilities
    --    calculate points at locations -> sum to player point count -> update winning player
    --    check for game completion requirement- if players have reached goalScore
    
    self.cpuFlag = self:cpuBehavior()
    
    if self.cpuFlag == 1 then
      self.cpuFlag = 0
      self.revealFlag = self:revealCards()
    end
    
    if self.revealFlag == 1 then
      self.revealFlag = 0
      self.scoringFlag = self:checkScores()
    end
    
    if self.scoringFlag == 1 then
      self.scoringFlag = 0
      self.completionFlag = self:checkGameCompletion()
    end
    
    if self.completionFlag == 1 then
      self.completionFlag = 0
      if self.winner == nil then
        self.state = GAME_STATE.NEW_TURN
      else
        self.restartButton:setPosition(20, 720)
        self.state = GAME_STATE.COMPLETE
      end
    end
    
  elseif self.state == GAME_STATE.NEW_TURN then
    -- initialize new turn- increase mana +1, draw cards from decks
    
    self.roundNum = self.roundNum + 1
    self.playerMana = self.roundNum
    self.cpuMana = self.roundNum
    
    -- draw cards from decks
    self.playerHand:addCard(manager.playerDeck)
    
    self.cpuHand:addCard(manager.cpuDeck)
    self.cpuHand.cards[#manager.cpuHand.cards].isFaceUp = false
    
    self.state = GAME_STATE.STANDBY
    
  elseif self.state == GAME_STATE.COMPLETE then
    self.restartButton:checkForMouseOver(manager)
    return
  end
end

function GameManager:cpuBehavior()
    -- Tries to play every card once to a random location
    for i = 1, #self.cpuHand.cards, 1 do
      math.randomseed(os.time())
      self.locations[math.random(1, 3)]:evaluateDropInput(self.cpuHand, self, 2)
    end
    return 1
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
    return 1
end

function GameManager:checkScores()
  -- which player currently has more points
    if self.playerPoints > self.cpuPoints then
      self.winningPlayer = SIDE.PLAYER
    elseif self.cpuPoints > self.playerPoints then
      self.winningPlayer = SIDE.CPU
    else
      self.winningPlayer = 0
    end
    return 1
end

function GameManager:checkGameCompletion()
  -- check game completion
    if self.playerPoints >= manager.goalScore and self.cpuPoints < manager.goalScore then -- player reaches goal first
      self.winner = SIDE.PLAYER
    elseif self.playerPoints < manager.goalScore and self.cpuPoints >= manager.goalScore then -- cpu reaches goal first
      self.winner = SIDE.CPU 
    elseif self.playerPoints >= manager.goalScore and self.cpuPoints >= manager.goalScore then -- both sides reach the goal on the same round
      if self.playerPoints > self.cpuPoints then
        self.winner = SIDE.PLAYER
      elseif self.playerPoints < self.cpuPoints then
        self.winner = SIDE.CPU 
      else
        self.winner = SIDE.TIE 
      end
    end
    return 1
end

function GameManager:toPlaying()
  self.state = GAME_STATE.PLAYING
end

