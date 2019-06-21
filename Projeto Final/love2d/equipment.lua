local Equipment
Equipment = {}

local colorMax, font
colorMax = 1
font = love.graphics.newFont(16)

-------------------------------------------------------------

local function newEquipment(x, y, w, h)
  local equipment, tasks, currentTask
  equipment = {}
  equipment["x"] = x
  equipment["y"] = y
  equipment["w"] = w
  equipment["h"] = h
  
  tasks = {}
  currentTask = "idle"
  
  equipment["addTask"] =
    function (taskHandler)
      tasks[taskHandler.name] = taskHandler
    end
  
  equipment["subscribeAllTasks"] =
    function ()
      for i, task in pairs(tasks) do
        task.subscribeAll()
      end
    end
  
  equipment["setTask"] = 
    function (taskName)
      currentTask = taskName
    end
  
  equipment["draw"] =
    function ()
      r, g, b, a = love.graphics.getColor()
      if currentTask == "idle" then
        love.graphics.setColor(colorMax * 0.5, colorMax * 0.5, colorMax * 0.5, colorMax * 0.5)
        love.graphics.rectangle("fill", equipment.x, equipment.y, equipment.w, equipment.h)
        love.graphics.setColor(colorMax, colorMax, colorMax, colorMax* 0.5)
      else
        love.graphics.setColor(colorMax * 0.5, colorMax * 0.5, colorMax * 0.5, colorMax * 1.0)
        love.graphics.rectangle("fill", equipment.x, equipment.y, equipment.w, equipment.h)
        love.graphics.setColor(colorMax * 0.0, colorMax * 0.8, colorMax * 0.0, colorMax * 1.0)
        love.graphics.rectangle("fill", equipment.x, 
                                        equipment.y + equipment.h * (100 - tasks[currentTask].percentage), 
                                        equipment.w, 
                                        equipment.h * tasks[currentTask].percentage/100)
        
        love.graphics.setColor(colorMax * 1.0, colorMax * 1.0, colorMax * 0.0, colorMax * 1.0)
      end
      
      local textW, textH, centerX, centerY
      textW = font:getWidth(currentTask)
      textH = font:getHeight(currentTask)
      centerX = equipment.x + equipment.w/2
      centerY = equipment.y + equipment.h/2
      love.graphics.print(currentTask, font, centerX - textW/2, centerY - textH/2)
      
      love.graphics.setColor(r, g, b, a)
    end
  
  return equipment
end

-------------------------------------------------------------

Equipment["new"] = 
  function (x, y, w, h)
    return newEquipment(x, y, w, h)
  end

return Equipment