
require "vector"

PileClass = {}

PILE_TYPE = {
  DRAW = 0,
  PLAY = 1,
  SUIT = 2
}

listoCards = {}

function PileClass:new(xPos, yPos)
  local pile = {}
  local metadata = {__index = PileClass}
  setmetatable(pile, metadata)
  
  pile.position = Vector(xPos, yPos)
  pile.cardList = {}
  pile.pileType = PILE_TYPE.DRAW
  
  return pile
end

function PileClass:update()
  -- Flips last card
  if self.cardList ~= nil and #self.cardList > 1 then
    endCard = self.cardList[#self.cardList]
    endCard.flipped = true
  end
end

-- Returns pile below location, for grabber
function PileClass:checkPileOverlap(currentPos)
  checkedPile = self.cardList
  endCard = checkedPile[#checkedPile]
  
  -- Checks if grabber's position.x matches pile
  local isOverPile = ((currentPos.x) > endCard.position.x and 
  (currentPos.x) < endCard.position.x + endCard.size.x)

  -- Returns pile if overlaps
  if isOverPile == true then
    return self
  else
    return nil
  end
end

-- Grabs valid cards from pile
function PileClass:grabCards(currentPos)
  if #self.cardList > 1 then
    grabbedCards = {}
    if self.pileType == PILE_TYPE.DRAW or self.pileType == PILE_TYPE.SUIT then
      -- Single card
      if isOverTarget(currentPos, self.cardList[#self.cardList], 0) then
        endCard = table.remove(self.cardList)
        endCard.state = CARD_STATE.GRABBED
        table.insert(grabbedCards, endCard)
        return grabbedCards
      end
    else
      highlightIndex = nil
      -- Finds highest valid card index
      for i = 2, #self.cardList do
        if self.cardList[i].flipped == true and isOverTarget(currentPos, self.cardList[i], 0) then
          highlightIndex = i
        end
      end
      
      -- Returns table of all grabbed cards
      if highlightIndex == nil then
        return nil
      else
        for i = #self.cardList, highlightIndex, -1 do
          endCard = table.remove(self.cardList)
          endCard.state = CARD_STATE.GRABBED
          table.insert(grabbedCards, endCard)
        end
        return grabbedCards
      end
    end
  end
end

function PileClass:updateCards(currentPos)
  -- Changes card states
  if #self.cardList > 1 then
    for i = #self.cardList, 2, -1 do
      if self.cardList[i].flipped == true and isOverTarget(currentPos, self.cardList[i], self.cardList[i].size.x) then
        self.cardList[i].state = CARD_STATE.MOUSE_OVER
      else
        self.cardList[i].state = CARD_STATE.IDLE
      end
    end
  end
end
