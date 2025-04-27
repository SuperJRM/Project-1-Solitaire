
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousCardPos = nil
  grabber.currentMousePos = nil
  grabber.grabPos = nil
  
  grabber.grabbing = false
  grabber.heldObject = nil
  
  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(), 
    love.mouse.getY())
  -- click
  if love.mouse.isDown(1) then
    self:grab()
  end
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end
end

function GrabberClass:grab()
 if (self.grabbing == false) then
   self.grabbing = true
 end
 self.grabPos = self.currentMousePos
end

function GrabberClass:release()
  self.grabPos = nil
  self.heldObject = nil
  self.grabbing = false
end
