require "cardData"

DeckLoaderClass = {}

function DeckLoaderClass:new()
  local deckLoader = {}
  local metadata = {__index = DeckLoaderClass}
  setmetatable(deckLoader, metadata)
  
  return deckLoader
end

function DeckLoaderClass:loadDefaultDeck() -- 20 cards
  local newDeck = {}
  
  for i = 1, 2, 1 do
    table.insert(newDeck, WoodenCow:new())
    table.insert(newDeck, Pegasus:new())
    table.insert(newDeck, Minotaur:new())
    table.insert(newDeck, Titan:new())
    
    table.insert(newDeck, Ares:new())
    table.insert(newDeck, Dionysus:new())
  end
  table.insert(newDeck, Zeus:new())
  table.insert(newDeck, Cyclops:new())
  table.insert(newDeck, Hades:new())
  table.insert(newDeck, Hercules:new())
  table.insert(newDeck, ShipOfTheseus:new())
  table.insert(newDeck, Midas:new())
  table.insert(newDeck, Hephaestus:new())
  table.insert(newDeck, Nyx:new())

  self:shuffle(newDeck)
  return newDeck
end

-- TO DO: add more decks

function DeckLoaderClass:shuffle(deck)
  --math.randomseed(os.time())
  for i = 1, #deck, 1 do
    local rand = math.random(1, #deck)
    deck[i], deck[rand] = deck[rand], deck[i]
  end
end