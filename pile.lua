
require "vector"

PileClass = {}

PILE_TYPE = {
  DRAW = 0,
  PLATEAU = 1,
  SUIT = 2
}

listoCards = {}

function PileClass:new(xPos, yPos)
  local pile = {}
  local metadata = {__index = PileClass}
  setmetatable(pile, metadata)
  
  pile.position = Vector(xPos, yPos)
  pile.cardList = {}
  pile.pType = 0
  
  return pile
end

function PileClass:update()
  --a
end

-- Checks if mouse is over a card, grabbing it or otherwise
function PileClass:checkForMouseOver(grabber, gameTable)
  if self.cardList ~= nil and #self.cardList > 0 then
    endCard = self.cardList[#self.cardList]
    
    -- Code for card being grabbed
    if endCard.state == CARD_STATE.GRABBED then
      -- If grabber is no longer holding said card
      if grabber.grabbing == false then
        endCard.state = CARD_STATE.IDLE
        newPile = self:checkForPile(gameTable)
        if newPile[#newPile] ~= endCard then
          print(newPile[#newPile].position.x)
          print(endCard.position.x)
          endCard.position.x = newPile[#newPile].position.x
          endCard.position.y = newPile[#newPile].position.y + 80
        else
          endCard.position = grabber.previousCardPos
        end
        return
        
      -- Held card follows grabber
      else
        endCard.position = grabber.grabPos - (endCard.size/2)
        return
      end
    end
    
    -- If grabber is not holding card, change card state/become grabbed 
    if grabber.heldObject == nil then
      local mousePos = grabber.currentMousePos
      local isMouseOver = isOverTarget(mousePos, endCard, 0)
      endCard.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
      
      if endCard.state == CARD_STATE.MOUSE_OVER and grabber.grabbing == true then
        endCard.state = CARD_STATE.GRABBED
        grabber.heldObject = self
        grabber.previousCardPos = endCard.position
      end
    end
  end
end

-- Checks if grabbed card overlaps a new pile upon release
function PileClass:checkForPile(gameTable)
  for _, tableau in ipairs(gameTable) do
    if #tableau.cardList > 0 and self.cardList ~= tableau.cardList then
      heldCardPos = self.cardList[#self.cardList].position
      heldCardSize = self.cardList[#self.cardList].size.x
      checkedPile = tableau.cardList
      pilePos = checkedPile[#checkedPile]
      
      local isCardOver = isOverTarget(heldCardPos, pilePos, heldCardSize)
      if isCardOver == true then
        return checkedPile
      end
    end
  end
  return self.cardList
end
