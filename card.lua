
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2,
  OUTLINE = 3
}

function CardClass:new(xPos, yPos)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(50, 70)
  card.state = CARD_STATE.IDLE
  card.flipped = false
  
  return card
end

function CardClass:update()
  --a
end

function CardClass:draw()
  -- Draws shadow if hovered over or grabbed
  if self.state ~= CARD_STATE.IDLE and self.state ~= CARD_STATE.OUTLINE then
    love.graphics.setColor(0, 0, 0, 0.8) -- color values [0, 1]
    local offset = 8 * (self.state == CARD_STATE.GRABBED and 2 or 1)
    love.graphics.rectangle("fill", self.position.x + offset, self.position.y + offset, self.size.x, self.size.y, 6, 6)
  end
  
  -- Draws outline card design for empty piles
  if self.state == CARD_STATE.OUTLINE then
    love.graphics.setColor(0, 0.7, 0.2, 1)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    return
  end
  
  -- Draws cards designs
  if self.flipped == false then
    love.graphics.setColor(0,0,150,1)
  else
    love.graphics.setColor(1,1,1,1)
  end
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
end