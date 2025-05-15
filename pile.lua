
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


---- Checks if mouse is over a card, grabbing it or otherwise
--function PileClass:checkForMouseOver(grabber, gameTable)
--  -- If grabber already grabbing card(s)
--  if grabber.heldObject ~= nil and grabber.grabbing == true then
--    if self.pileType == PILE_TYPE.DRAW or self.pileType == PILE_TYPE.SUIT then
--      self:singleCardHeld(grabber, gameTable)
--    else
--      self:multiCardHeld(grabber, gameTable)
--    end
--    return
--  -- If pile has cards
--  if self.cardList ~= nil and #self.cardList > 1 then
--    endCard = self.cardList[#self.cardList]
--    -- If grabber is over pile
--    if ((grabber.currentMousePos.x > endCard.position.x) and 
--    (grabber.currentMousePos.x < (endCard.position.x + endCard.size.x))) then
--      if self.pileType == PILE_TYPE.DRAW or self.pileType == PILE_TYPE.SUIT then
--        self:singleCardGrab(grabber, gameTable)
--      else
--        self:multiCardGrab(grabber, gameTable)
--      end

--    else
--      for i = 2, #self.cardList do
--        resetCard = self.cardList[i]
--        resetCard.state = CARD_STATE.IDLE
--      end
--    end
--  end
--end

--function PileClass:singleCardHeld

--function PileClass:singleCardGrab(grabber, gameTable)
--  endCard = self.cardList[#self.cardList]
--  -- Code for grabbed endCard
--  if endCard.state == CARD_STATE.GRABBED then
--    -- If grabber is no longer holding said card
--    if grabber.grabbing == false then
--      endCard.state = CARD_STATE.IDLE
--      newPile = self:checkForPile(gameTable, endCard)
--      -- Card is in new pile
--      if newPile[#newPile] ~= endCard then
--        endCard.position.x = newPile[#newPile].position.x
--        endCard.position.y = newPile[#newPile].position.y + 30
--        table.insert(newPile, endCard)
--        table.remove(self.cardList)
--        self:update()
--      -- Card returns tooriginal position
--      else
--        endCard.position = grabber.previousCardPos
--      end
--      return
      
--    -- Card is being held, follows grabber
--    else
--      endCard.position = grabber.grabPos - (endCard.size/2)
--      return
--    end
--  -- Code for unchanged endCard
--  else
--    -- If grabber is not holding a card, changes highlighted card's state
--    if grabber.heldObject == nil then
--      local mousePos = grabber.currentMousePos
--      local isMouseOver = isOverTarget(mousePos, endCard, 0)
--      endCard.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
      
--      -- Grabber grabs card
--      if endCard.state == CARD_STATE.MOUSE_OVER and grabber.grabbing == true then
--        endCard.state = CARD_STATE.GRABBED
--        grabber.heldObject = self -- Endcard?
--        grabber.previousCardPos = endCard.position
--      end
--    end
--  end
--end

--function PileClass:multiCardGrab(grabber, gameTable)
--  -- Check each card in tableau piles
--  for i = #self.cardList, 2, -1 do
--    checkedCard = self.cardList[i]
--    if checkedCard.flipped == true then
--      -- If the checked card reads as already grabbed
--      if checkedCard.state == CARD_STATE.GRABBED then
--        -- If grabber is no longer holding object
--        if grabber.grabbing == false then
--          checkedCard.state = CARD_STATE.IDLE
          
--          -- Checks if card is dropped in new or original pile
--          checkedPile = self:checkForPile(gameTable, checkedCard)
--          -- If card's position is over a new pile
--          if checkedPile ~= self.cardList then
--            for j = 1, #grabber.heldObject do
--              grabbed = grabber.heldObject[j]
--              grabbed.position.x = checkedPile[#checkedPile].position.x -- FIX new cards positions
--              grabbed.position.y = checkedPile[#checkedPile].position.y + (30 * j)
--              table.insert(checkedPile, grabbed)
--            end
--            for j = 1, #grabber.heldObject do
--              table.remove(self.cardList)
--            end
--            self:update()
--          else
--            print(grabber.heldObject)
--            for j = 1, #grabber.heldObject do
--              grabbed = grabber.heldObject[j]
--              grabbed.position.x = grabber.previousCardPos.x
--              grabbed.position.y = grabber.previousCardPos.y + (30 * (j-1))
--            end
--          end
--          return
          
--        -- Card IS held by grabber, change positions to follow
--        else
--          -- for j, grabbed in ipairs(grabber.heldObject) do
--          for j = 1, #grabber.heldObject do
--            grabbed = grabber.heldObject[j]
--            grabbed.position = grabber.grabPos - (endCard.size/2)
--            grabbed.position.y = grabbed.position.y + (30 * (j - 1))
--          end
--          return
--        end
--      end
      
--      -- Checks empty grabber hovers over/grabs new card
--      if grabber.heldObject == nil then
--        local mousePos = grabber.currentMousePos
--        local isMouseOver = isOverTarget(mousePos, checkedCard, 0)
--        checkedCard.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
        
--        -- If grabber grabs checked card
--        if checkedCard.state == CARD_STATE.MOUSE_OVER and grabber.grabbing == true then
--          -- If card is at end, grabs singular card
--          grabber.heldObject = {}
--          if i == #self.cardList then
--            checkedCard.state = CARD_STATE.GRABBED
--            table.insert(grabber.heldObject, checkedCard)
--            print(grabber.heldObject)
--            grabber.previousCardPos = checkedCard.position
--            return
--          else
--            local cardStack = {}
--            for j = i, #self.cardList do
--              print(i)
--              grabbedCard = self.cardList[i]
--              grabbedCard.state = CARD_STATE.GRABBED
--              table.insert(grabber.heldObject, grabbedCard)
--            end
--            print(grabber.heldObject[1])
--            grabber.previousCardPos = checkedCard.position
--          end
--        end
--      end
--    end
--  end
--end

---- Checks if grabbed card overlaps a new pile upon release
--function PileClass:checkForPile(gameTable, checkedCard)
--  for _, tableau in ipairs(gameTable) do
--    if #tableau.cardList > 1 and self.cardList ~= tableau.cardList then
--      heldCardPos = checkedCard.position
--      heldCardSize = checkedCard.size.x

--      checkedPile = tableau.cardList
--      pilePos = checkedPile[#checkedPile]
      
--      local isCardOver = isOverTarget(heldCardPos, pilePos, heldCardSize)
--      if isCardOver == true then
--        return checkedPile
--      end
--    end
--  end
--  return self.cardList
--end
