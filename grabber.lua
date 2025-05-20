
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.currentMousePos = Vector(0,0)
  grabber.heldObject = nil
  grabber.currentPile = nil
  grabber.pastPile = nil
  grabber.onCooldown = false
  
  return grabber
end

function GrabberClass:update()
  -- Update mouse pos
  checkPos = Vector(
    love.mouse.getX(), 
    love.mouse.getY())
  if checkPos ~= nil then
    self.currentMousePos = checkPos
  end
  
  -- Find pile currently below grabber
  self.currentPile = nil
  for _, tableau in ipairs(gameTable) do
    pileCheck = tableau:checkPileOverlap(self.currentMousePos)
    if pileCheck ~= nil then
      self.currentPile = pileCheck
      break
    end
  end
  
  -- Mouse inputs
  if love.mouse.isDown(1) then
    self:grab()
    self.onCooldown = true
  end
  if not love.mouse.isDown(1) then
    self:release()
    self.onCooldown = false
  end
end

-- On mouse click
function GrabberClass:grab()
  -- Moves already grabbed cards
  if self.heldObject ~= nil then
    for i = 1, #self.heldObject do
      self.heldObject[i].position = self.currentMousePos - (self.heldObject[i].size / 2)
      self.heldObject[i].position.y = self.heldObject[i].position.y + (30 * (i - 1))
    end
  
  -- Mouse is over a pile
  else
    if self.currentPile ~= nil then
      -- Replaces Draw Pile
      if (self.currentMousePos.x > 100 and self.currentMousePos.x < 150) and
      (self.currentMousePos.y > 125 and self.currentMousePos.y < 195) and self.onCooldown == false then
        for i = 2, #self.currentPile.cardList do
          endCard = table.remove(self.currentPile.cardList)
          endCard.state = CARD_STATE.IDLE
          endCard.flipped = false
          endCard.position = Vector(100, 125)
          table.insert(cardDeck, endCard)
        end
        -- Insert Shuffle
        maxDeck = 3
        if maxDeck > #cardDeck then
          maxDeck = #cardDeck
        end
        for i = 1, maxDeck do
          endCard = table.remove(cardDeck)
          endCard.state = CARD_STATE.IDLE
          endCard.flipped = true
          endCard.position.x = self.currentPile.cardList[1].position.x
          endCard.position.y = self.currentPile.cardList[1].position.y + (30 * i - 3)
          table.insert(self.currentPile.cardList, endCard)
        end
        return
      end
      
      -- Grabs cards from piles
      hand = self.currentPile:grabCards(self.currentMousePos)
      if hand ~= nil then
        self.pastPile = self.currentPile
        self.heldObject = hand
      end
      
    -- If no pile is selected
    else
      -- Reset Button
      if (self.currentMousePos.x > 50 and self.currentMousePos.x < 100) and
      (self.currentMousePos.y > 50 and self.currentMousePos.y < 75) and self.onCooldown == false then
        setUpBoard()
        return
      end
    end
  end
end

-- On mouse release
function GrabberClass:release()
  if self.heldObject ~= nil then
    -- Places gabbed cards into current or old piles
    if self.currentPile ~= nil and self.currentPile.pileType ~= PILE_TYPE.DRAW then
      for i = #self.heldObject, 1, -1 do
        endCard = table.remove(self.heldObject)
        endCard.state = CARD_STATE.IDLE
        endCard.position.x = self.currentPile.cardList[#self.currentPile.cardList].position.x
        if #self.currentPile.cardList == 1 or self.currentPile.pileType == PILE_TYPE.SUIT then
          endCard.position.y = self.currentPile.cardList[#self.currentPile.cardList].position.y
        else
          endCard.position.y = self.currentPile.cardList[#self.currentPile.cardList].position.y + 30
        end
        table.insert(self.currentPile.cardList, endCard)
      end
      self.pastPile:update()
      self.heldObject = nil

    -- Returns held cards to previous position if new one is invalid
    else
      for i = #self.heldObject, 1, -1 do
        endCard = table.remove(self.heldObject)
        endCard.state = CARD_STATE.IDLE
        endCard.position.x = self.pastPile.cardList[#self.pastPile.cardList].position.x
        if #self.pastPile.cardList == 1 or self.pastPile.pileType == PILE_TYPE.SUIT then
          endCard.position.y = self.pastPile.cardList[#self.pastPile.cardList].position.y
        else
          endCard.position.y = self.pastPile.cardList[#self.pastPile.cardList].position.y + 30
        end
        table.insert(self.pastPile.cardList, endCard)
      end
      self.heldObject = nil
    end

  -- Changes card states within current pile
  else
    if self.currentPile ~= nil then
      for _, tableau in ipairs(gameTable) do
        for i, card in ipairs(tableau.cardList) do
          if i ~= 1 then
            card.state = CARD_STATE.IDLE
          end
        end
      end
      self.currentPile:updateCards(self.currentMousePos)
    end
  end
end
