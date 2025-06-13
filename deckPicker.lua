require "deckLoader"
require "button"

DeckPicker = {}

DECKS = {
  "Default Deck",
  "Charcuterie",
  "Olympian Deck",
  "Cthonic Deck",
  "Heroes and Monsters",
  "Ships of Theseus" -- hidden
}

PLAYER_DECK = {}
CPU_DECK = {}

WIDTH = 1080
HEIGHT = 780

-- deck picker scene

function DeckPicker:new()
  local picker = {}
  local metadata = {__index = DeckPicker}
  setmetatable(picker, metadata)
  
  picker.loader = DeckLoaderClass:new()
  
  picker.playerInd = 1
  picker.cpuInd = 1
  
  -- buttons
  picker.playerSelect = PlayerNext:new()
  picker.cpuSelect = CpuNext:new()
  
  picker.begin = PickerBegin:new()
  picker.title = PickerTitle:new()
  
  picker.lists = {
    "x2\nWooden Cow\nPegasus\nMinotaur\nTitan\n\nx1\nZeus\nAres\nHera\nDemeter\nHercules\nDionysus\nSword Of Damocles\nMidas\nAthena\nHephaestus\nPrometheus\nNyx",
    "x1\nZeus\nAres\nMedusa\nCyclops\nArtemis\nHera\nDemeter\nHades\nHercules\nDionysus\nHermes\nHydra\nShip Of Theseus\nSword Of Damocles\nMidas\nAthena\nHephaestus\nPersephone\nPrometheus\nNyx",
    "x2\nZeus\nAres\nArtemis\nHera\nDemeter\nHades\nDionysus\nHermes\nAthena\nHephaestus",
    "x2\nWooden Cow\nTitan\nZeus\nCyclops\nDemeter\nHades\nHermes\nHydra\nPersephone\nNyx",
    "x2\nPegasus\nMinotaur\nMedusa\nCyclops\nHercules\nHydra\nShip Of Theseus\nSword Of Damocles\nMidas\nPrometheus",
    "???"
  }
  
  return picker
end

function DeckPicker:draw()
  love.graphics.setColor(BLACK)
  
  love.graphics.print("PLAYER", (WIDTH / 3) - 35, 100, 0, 1.25)
  for ind, name in ipairs(DECKS) do
    if ind ~= 6 or self.playerInd == 6 then
      love.graphics.print(name, (WIDTH / 3) - 60, 165 + (65 * (ind - 1)))
    end
    
    if ind == self.playerInd then
      love.graphics.rectangle("line", (WIDTH / 3) - 80, 165 + (65 * (ind - 1)) - 20, 170, 60, 6, 6)
    end
  end
  love.graphics.print(self.lists[self.playerInd], 100, 165 + (65 * (self.playerInd - 1)) - 20)
  
  love.graphics.print("CPU", 2 * (WIDTH / 3) - 15, 100, 0, 1.25)
  for ind, name in ipairs(DECKS) do
    if ind ~= 6 or self.cpuInd == 6 then
      love.graphics.print(name, 2 * (WIDTH / 3) - 60, 165 + (65 * (ind - 1)))
    end
    
    if ind == self.cpuInd then
      love.graphics.rectangle("line", 2 * (WIDTH / 3) - 80, 165 + (65 * (ind - 1)) - 20, 170, 60, 6, 6)
    end
  end
  love.graphics.print(self.lists[self.cpuInd], 875, 165 + (65 * (self.cpuInd - 1)) - 20)
  
  self.playerSelect:draw()
  self.cpuSelect:draw()
  
  self.begin:draw()
  self.title:draw()
end

function DeckPicker:update(grabber)
  self.playerSelect:checkForMouseOver(self)
  self.cpuSelect:checkForMouseOver(self)
  self.begin:checkForMouseOver(self)
  self.title:checkForMouseOver(self)
end

function DeckPicker:setDecks()
  for i = 1, 2, 1 do
    math.randomseed(os.time())
    local decks = {
      self.loader:DefaultDeck(),
      self.loader:Charcuterie(),
      self.loader:OlympianDeck(),
      self.loader:CthonicDeck(),
      self.loader:HeroesAndMonsters(),
      self.loader:ShipsOfTheseus(),
    }
    if i == 1 then
      PLAYER_DECK = decks[self.playerInd]
    else
      CPU_DECK = decks[self.cpuInd]
    end
  end
end

