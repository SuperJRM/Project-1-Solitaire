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
  
  winCheck = false
  grabber = GrabberClass:new()
  setUpBoard()
end

function love.draw()
  if winCheck == true then
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("You Win!", 400, 400)
  end
  for i, card in ipairs(cardDeck) do
    card:draw()
  end
    
  for _, tableau in ipairs(gameTable) do
    for i, card in ipairs(tableau.cardList) do
      card:draw()
    end
  end
  if grabber.heldObject ~= nil then
    for i, card in ipairs(grabber.heldObject) do
      card:draw()
    end
  end
end

function isOverTarget(origin, targetCard, offset)
  return (origin.x > targetCard.position.x and 
  origin.x < (targetCard.position.x + targetCard.size.x*2) and
  origin.y > targetCard.position.y and 
  origin.y < targetCard.position.y + targetCard.size.y)
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  for _, tableau in ipairs(gameTable) do
    tableau:checkForMouseOver(grabber, gameTable)
    --grabber:checkForMouseOver(grabber, gameTable)
  end
end

function setUpBoard()
  winCheck = false
  cardDeck = {} 
  gameTable = {}
  
  -- Fills the deck with cards + deck outline
  deckOutline = CardClass:new(100, 125)
  deckOutline.state = CARD_STATE.OUTLINE
  fillDeck(cardDeck)
  
  -- Creates draw and tableau pile tables, filling the tableaus only
  for i = 1, 8 do
    -- Builds draw pile
    if i == 1 then
      drawnCards = newPile(100, 225)
      drawnCards.pileType = PILE_TYPE.DRAW
      for j = 1, 3 do
        tempCard = table.remove(cardDeck)
        tempCard.position = Vector(100, (225 + 30 * (j-1)))
        tempCard.flipped = true
        table.insert(drawnCards.cardList, tempCard)
      end
      -- Adds Draw and Tableau Piles into the gameTable
      table.insert(gameTable, drawnCards)
  
    -- Builds standard tableau piles, beginning with an outline     
    else
      tableau = newPile((100 * i), 125)
      tableau.pileType = PILE_TYPE.PLAY
      for j = 2, i do
        tempCard = table.remove(cardDeck)
        tempCard.position = Vector(((100 * i)), (125 + 30 * (j-2)))
        if j == i then
          tempCard.flipped = true
        end
        table.insert(tableau.cardList, tempCard)
      end
      -- Adds Tableau Piles into the gameTable
      table.insert(gameTable, tableau)
    end
  end
  
  -- Creates suit pile table, adding it to the gameTable
  for i = 1, 4 do
    suit = newPile((350 + 100 * i), 25)
    suit.pileType = PILE_TYPE.SUIT
    table.insert(gameTable, suit)
  end
end

-- Fills deck with cards, may shuffle cards later
function fillDeck(deck)
  for i = 1, 52 do
    table.insert(deck, CardClass:new(100, 125))
  end
end

-- Creates new card piles with outlines
function newPile(x, y)
  local newPile = PileClass:new(x, y)
  pileOutline = CardClass:new(x, y)
  pileOutline.state = CARD_STATE.OUTLINE
  table.insert(newPile.cardList, pileOutline)
  return newPile
end

function love.update()
  endCheck = 0
  for _, tableau in ipairs(gameTable) do
    for _, card in ipairs(tableau.cardList) do
      card:update()
    end
    if tableau.pileType == PILE_TYPE.SUIT and #tableau.cardList > 12 then
      endCheck = endCheck + 1
    end
    if endCheck > 3 then
      winCheck = true
    end
  end
  grabber:update()
end

