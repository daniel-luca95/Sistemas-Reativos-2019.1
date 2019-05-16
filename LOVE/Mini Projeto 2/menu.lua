local Menu = {}

local function newButton(text, fn)
  return
  {
    text = text,
    fn = fn
  }
end
  local buttons = {}
  local font = nil
  Menu["loadMenu"] =
  
  function()
    font = love.graphics.newFont(32)
    table.insert(buttons,newButton(
        "Start Game",
        function ()
          print("Starting Game")
        end))
    
    table.insert(buttons,newButton(
        "Exit",
        function ()
          love.event.quit(0)
        end))
    end
    
    Menu["draw"] =
    function()
      local widthCanvas = love.graphics.getWidth()
      local heightCanvas = love.graphics.getHeight()
      
      local button_width = widthCanvas * (1/3)
      local button_height = 64
      local total_height = button_height * #buttons
      local margin = 16
      local cursory = 0
      for i, button in ipairs(buttons) do
        love.graphics.setColor(0.4,0.4,0.5,1)
        love.graphics.rectangle(
          "fill",
          (widthCanvas * 0.5) - (button_width * 0.5), 
          (heightCanvas * 0.5) - (button_width * 0.5) - (total_height * 0.5) * cursory,
          button_width,
          button_height 
        )
        love.graphics.setColor(0,0,0,1)
        love.graphics.print(
          button.text,
          font,
          (widthCanvas * 0.5) - (button_width * 0.5), 
          (heightCanvas * 0.5) - (button_width * 0.5) - (total_height * 0.5) * cursory
          )
      cursory = cursory + (button_height * margin)
      end
  end
  
      Menu["update"] =
    function()
    end
return Menu    