require "cardData"

DeckLoaderClass = {}

function DeckLoaderClass:new()
  local deckLoader = {}
  local metadata = {__index = DeckLoaderClass}
  setmetatable(deckLoader, metadata)
  
  return deckLoader
end

function DeckLoaderClass:DefaultDeck()
  local newDeck = {}
  
    for i = 1, 2, 1 do
    table.insert(newDeck, WoodenCow:new())
    table.insert(newDeck, Pegasus:new())
    table.insert(newDeck, Minotaur:new())
    table.insert(newDeck, Titan:new())
  end
  
  table.insert(newDeck, Zeus:new())
  table.insert(newDeck, Ares:new())
  table.insert(newDeck, Hera:new())
  table.insert(newDeck, Demeter:new())
  table.insert(newDeck, Hercules:new())
  table.insert(newDeck, Dionysus:new())
  table.insert(newDeck, SwordOfDamocles:new())
  table.insert(newDeck, Midas:new())
  table.insert(newDeck, Athena:new())
  table.insert(newDeck, Hephaestus:new())
  table.insert(newDeck, Prometheus:new())
  table.insert(newDeck, Nyx:new())

  self:shuffle(newDeck)
  return newDeck
end

function DeckLoaderClass:OlympianDeck()
  local newDeck = {}
  
  for i = 1, 2, 1 do
    table.insert(newDeck, Zeus:new())
    table.insert(newDeck, Ares:new())
    table.insert(newDeck, Artemis:new())
    table.insert(newDeck, Hera:new())
    table.insert(newDeck, Demeter:new())
    table.insert(newDeck, Hades:new())
    table.insert(newDeck, Dionysus:new())
    table.insert(newDeck, Hermes:new())
    table.insert(newDeck, Athena:new())
    table.insert(newDeck, Hephaestus:new())
  end
  
  self:shuffle(newDeck)
  return newDeck
end

function DeckLoaderClass:CthonicDeck()
  local newDeck = {}
  
  for i = 1, 2, 1 do
    table.insert(newDeck, Hades:new())
    table.insert(newDeck, Persephone:new())
    table.insert(newDeck, Demeter:new())
    table.insert(newDeck, Hermes:new())
    table.insert(newDeck, Zeus:new())
    table.insert(newDeck, Nyx:new())
    table.insert(newDeck, Titan:new())
    table.insert(newDeck, Cyclops:new())
    table.insert(newDeck, Hydra:new())
    table.insert(newDeck, WoodenCow:new())
  end
  
  self:shuffle(newDeck)
  return newDeck
end

function DeckLoaderClass:HeroesAndMonsters()
  local newDeck = {}
  
  for i = 1, 2, 1 do
    table.insert(newDeck, Pegasus:new())
    table.insert(newDeck, Minotaur:new())
    table.insert(newDeck, Medusa:new())
    table.insert(newDeck, Cyclops:new())
    table.insert(newDeck, Hercules:new())
    table.insert(newDeck, Hydra:new())
    table.insert(newDeck, ShipOfTheseus:new())
    table.insert(newDeck, SwordOfDamocles:new())
    table.insert(newDeck, Midas:new())
    table.insert(newDeck, Prometheus:new())
  end
  
  self:shuffle(newDeck)
  return newDeck
end

function DeckLoaderClass:Charcuterie()
  local newDeck = {}
  
  table.insert(newDeck, Zeus:new())
  table.insert(newDeck, Ares:new())
  table.insert(newDeck, Medusa:new())
  table.insert(newDeck, Cyclops:new())
  table.insert(newDeck, Artemis:new())
  table.insert(newDeck, Hera:new())
  table.insert(newDeck, Demeter:new())
  table.insert(newDeck, Hades:new())
  table.insert(newDeck, Hercules:new())
  table.insert(newDeck, Dionysus:new())
  table.insert(newDeck, Hermes:new())
  table.insert(newDeck, Hydra:new())
  table.insert(newDeck, ShipOfTheseus:new())
  table.insert(newDeck, SwordOfDamocles:new())
  table.insert(newDeck, Midas:new())
  table.insert(newDeck, Athena:new())
  table.insert(newDeck, Hephaestus:new())
  table.insert(newDeck, Persephone:new())
  table.insert(newDeck, Prometheus:new())
  table.insert(newDeck, Nyx:new())

  self:shuffle(newDeck)
  return newDeck
end

function DeckLoaderClass:ShipsOfTheseus()
  local newDeck = {}
  
  for i = 1, 20, 1 do
    table.insert(newDeck, ShipOfTheseus:new())
  end
  
  return newDeck
end


function DeckLoaderClass:shuffle(deck)
  for i = 1, #deck, 1 do
    local rand = math.random(1, #deck)
    deck[i], deck[rand] = deck[rand], deck[i]
  end
end