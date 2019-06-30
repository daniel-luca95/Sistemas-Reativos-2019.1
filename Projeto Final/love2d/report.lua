Report = {}

Report["new"] = 
  function (x, y, width, fontSize)
    report = {}
    local text, font
    font = love.graphics.newFont(fontSize)
    text = ""
    
    report["append"] =
      function (newEntry)
        text = "- "..newEntry.."\n"..text
      end
      
    report["draw"] = 
      function ()
        love.graphics.printf( text, font, x, y, width, "left")
      end
    
    return report
  end

return Report