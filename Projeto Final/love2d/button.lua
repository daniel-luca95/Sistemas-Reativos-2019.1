Button = {}

if colorMax == nil then colorMax = 1 end

local font
font = love.graphics.newFont(14)

Button["new"] = 
  function (x, y, width, height, text, callback)
    local button
    local pressed
    button = {}
    
    local function isInside(mouseX, mouseY)
      return mouseX >=x and mouseX <= x+ width and mouseY >= y and mouseY <= y + height 
    end
    
    button["clicked"] = 
      function(clickedX, clickedY)
        if isInside(clickedX, clickedY) then
          pressed = true
          callback()
        end
      end
      
    button["released"] =
      function()
        pressed = false
      end
    
    button["draw"] =
      function ()
        local r, g, b, a
        local textW, textH, centerX, centerY
        
        r, g, b, a  = love.graphics.getColor()
        
        if not pressed then
          love.graphics.setColor(colorMax * 0, colorMax * 0, colorMax * 1, colorMax * 1)
        else
          love.graphics.setColor(colorMax * 0, colorMax * 0, colorMax * 0.5, colorMax * 1)
        end
        love.graphics.rectangle("fill", x, y, width, height)
        
        love.graphics.setColor(colorMax * 1, colorMax * 1, colorMax * 1, colorMax * 1)
        textW = font:getWidth(text)
        textH = font:getHeight(text)
        centerX = x + width/2
        centerY = y + height/2
        love.graphics.print(text, font, centerX - textW/2, centerY - textH/2)
        
        if isInside(love.mouse.getX(), love.mouse.getY()) then
          love.graphics.setColor(colorMax * 0, colorMax * 1, colorMax * 1, colorMax * 0.8)
          love.graphics.rectangle("line", x, y, width, height)
        end
        love.graphics.setColor(r, g, b, a)
      end
    
    return button
  end


return Button