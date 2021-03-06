local Equipment
Equipment = {}

local font
if colorMax == nil then colorMax = 1 end
font = love.graphics.newFont(16)

-------------------------------------------------------------

local function newEquipment(name, x, y, w, h)
  local equipment, tasks, currentTask
  equipment = {}
  
  equipment["name"] = name
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
      local r, g, b, a 
      local textW, textH, centerX, centerY
      
      r, g, b, a = love.graphics.getColor()
      
      love.graphics.setColor(colorMax * 1, colorMax * 0, colorMax * 0, colorMax * 1)
      textW = font:getWidth(equipment.name)
      textH = font:getHeight(equipment.name)
      centerX = equipment.x + equipment.w/2
      centerY = equipment.y - 10
      love.graphics.print(equipment.name, font, centerX - textW/2, centerY - textH/2)
      
      if currentTask == "idle" then
        love.graphics.setColor(colorMax * 0.5, colorMax * 0.5, colorMax * 0.5, colorMax * 0.5)
        love.graphics.rectangle("fill", equipment.x, equipment.y, equipment.w, equipment.h)
        love.graphics.setColor(colorMax, colorMax, colorMax, colorMax* 0.5)
      else
        love.graphics.setColor(colorMax * 0.5, colorMax * 0.5, colorMax * 0.5, colorMax * 1.0)
        love.graphics.rectangle("fill", equipment.x, equipment.y, equipment.w, equipment.h)
        love.graphics.setColor(colorMax * 0.0, colorMax * 0.8, colorMax * 0.0, colorMax * 1.0)
        love.graphics.rectangle("fill", equipment.x, 
                                        equipment.y + equipment.h * (100 - tasks[currentTask].percentage)/100.0, 
                                        equipment.w, 
                                        equipment.h * tasks[currentTask].percentage/100.0)
        
        love.graphics.setColor(colorMax * 1.0, colorMax * 1.0, colorMax * 0.0, colorMax * 1.0)
      end
      
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
  function (name, x, y, w, h)
    return newEquipment(name, x, y, w, h)
  end

return Equipment