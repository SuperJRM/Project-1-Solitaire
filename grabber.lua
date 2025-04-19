
require "vector"
require "card"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  
  grabber.grabPos = nil
  
  grabber.heldObject = nil
  
  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(), 
    love.mouse.getY())
  -- click
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab()
  end
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end
end

function GrabberClass:grab()
  self.grabPos = self.currentMousePosition
  
  print("Grabbed at " .. tostring(self.grabPos))
end

function GrabberClass:release()
  print("Released at " .. tostring(self.grabPos))
  self.grabPos = nil
  self.heldObject = nil
end
