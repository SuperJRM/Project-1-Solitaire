-- Jason Rangle-Martinez
-- CMPM 121 - Solitaire Project
-- 4/11/25
io.stdout:setvbuf("no")

require "card"
require "vector"
require "grabber"
require "pile"

function love.load()
  love.window.setMode(960,640)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  cardDeck = {} 
  gameTable = {}
  setUpBoard()
end

function love.draw()
  
  for i, card in ipairs(cardDeck) do
    card:draw()
  end
    
  for _, tableau in ipairs(gameTable) do
    for i, card in ipairs(tableau.cardList) do
      card:draw()
    
      love.graphics.setColor(1,1,1,1)
      love.graphics.print("Mouse " .. tostring(grabber.currentMousePos.x) .. 
      ", " .. tostring(grabber.currentMousePos.y))
    end
  end
end

function isOverTarget(origin, targetCard, offset)
  return ((origin.x + offset / 2) > targetCard.position.x and 
  (origin.x + offset / 2) < targetCard.position.x + targetCard.size.x and
  origin.y > targetCard.position.y and 
  origin.y < targetCard.position.y + targetCard.size.y)
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  for _, tableau in ipairs(gameTable) do
    tableau:checkForMouseOver(grabber, gameTable)
  end
end

function setUpBoard()
    -- Fills the deck with cards
  for i = 1, 53 do
    table.insert(cardDeck, CardClass:new(100,0))
  end
  
  -- Creates draw and tableau pile tables, filling the tableaus only
  for i = 1, 8 do
    tableau = PileClass:new((100 * i), 100)
    if i == 1 then
      for j = 1, 3 do
        tempCard = table.remove(cardDeck)
        tempCard.position = Vector(100, (100 + 80 * (j-1)))
        tempCard.flipped = true
        table.insert(tableau.cardList, tempCard)
      end
    else
      for j = 2, i do
        tempCard = table.remove(cardDeck)
        tempCard.position = Vector(((100 * i)), (0 + 80 * (j-2)))
        --Until Pile swapping is fully added
        if j == i then
          tempCard.flipped = true
        end
        table.insert(tableau.cardList, tempCard)
      end
    end
    table.insert(gameTable, tableau)
  end
  -- Creates suit pile table
  for i = 1, 4 do
    suit = PileClass:new((900 + 100 * i), 0)
    table.insert(gameTable, suit)
  end
end

function love.update()
  grabber:update()
  checkForMouseMoving()
  
  for _, tableau in ipairs(gameTable) do
    for _, card in ipairs(tableau.cardList) do
      card:update()
    end
  end
end

