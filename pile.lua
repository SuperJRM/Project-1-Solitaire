
require "vector"

PileClass = {}

PILE_TYPE = {
  DRAW = 0,
  PLAT = 1,
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
function PileClass:checkForMouseOver(grabber, cardTable)
  if self.cardList ~= nil and #self.cardList > 0 then
    endCard = self.cardList[#self.cardList]
    
    -- Code for card being grabbed
    if endCard.state == CARD_STATE.GRABBED then
      -- If grabber is no longer holding said card
      if grabber.grabbing == false then
        endCard.state = CARD_STATE.IDLE
        newPile = self:checkForPile(cardTable)
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
      local isMouseOver = 
      mousePos.x > endCard.position.x and 
      mousePos.x < endCard.position.x + endCard.size.x and
      mousePos.y > endCard.position.y and 
      mousePos.y < endCard.position.y + endCard.size.y
      
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
function PileClass:checkForPile(cardTable)
  cardOverlap = false
  for _, tableau in ipairs(cardTable) do
    if #tableau.cardList > 0 and self.cardList ~= tableau.cardList then
      heldCardPos = self.cardList[#self.cardList].position
      checkedPile = tableau.cardList
      -- pilePos = tableau.cardList[#tableau.cardList]
      pilePos = checkedPile[#checkedPile]
      local isCardOver = 
        heldCardPos.x > pilePos.position.x and 
        heldCardPos.x < pilePos.position.x + pilePos.size.x and
        heldCardPos.y > pilePos.position.y and 
        heldCardPos.y < pilePos.position.y + pilePos.size.y
      if isCardOver == true then
        return checkedPile
      end
    end
  end
  return self.cardList
end
