Report = {}

Report["new"] = 
  function (name, x, y, width, fontSize)
    report = {}
    local text, font
    font = love.graphics.newFont(fontSize)
    text = ""
    
    report["save"] =
      function ()
        file = io.open(name.."_log.txt", "a")
        local lines
        lines = {}
        for line in text:gmatch("([^\n]*)\n?") do
          table.insert(lines, line)
        end
        for i = #lines, 1, -1 do
          file:write(lines[i].."\n")
        end
        file:close()
      end
        
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