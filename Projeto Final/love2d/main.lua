local mqtt = require("mqtt_library")
local Task = require "task"
local Equipment = require "equipment"
local Report = require "report"
local Button = require "button"

colorMax = 1

io.stdout:setvbuf("no") 

-------------------------------------------------------------------------

function split(s, delimiter)
    local result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

-------------------------------------------------------------------------

function mqttcb(topic, message)
  print("topic: "..topic, "message: "..message)
  local res = split(topic, "__")
  status = res[1]
  name = res[2]
  eqNo = tasks[name].equipment
  if status == "started" then
    equipments[eqNo].setTask(name)
    reports[eqNo].append(os.date("started "..name.." at ".."%c"))
  elseif status == "finished" then
    equipments[eqNo].setTask("idle")
    reports[eqNo].append(os.date("finished "..name.." at ".."%c"))
  elseif status == "progress" then
    tasks[name].percentage = tonumber(message)
  end
end

-------------------------------------------------------------------------

function love.load()
  
  mqtt_client = mqtt.client.create("85.119.83.194", 1883, mqttcb)
  mqtt_client:connect("engdiosmiocecinestpasunematricule")
  
  equipments = {}
  reports = {}
  tasks = {}

  l = love.graphics.getWidth()/10
  for i, name in ipairs({"Equipamento 1", "Equipamento 2", "Equipamento 3"}) do
    table.insert(equipments, Equipment.new(name, (3*i-2)*l, 75, 2*l, 150))
    table.insert(reports, Report.new(name, (3*i-2)*l, 75 + 150, 2*l, 14))
  end
  
  local function saveLog()
    for i, report in pairs(reports) do
      report.save()
    end
  end
  
  saveLogButton = Button.new(love.graphics.getWidth() - 90, 20, 70, 20, "Save Log", saveLog)
  
  local function createTaskRegistry(equipment, taskName, hotPoints)
    local newTask = Task.new(taskName, hotPoints)
    newTask["equipment"] = equipment
    equipments[equipment].addTask(newTask)
    return newTask
  end
  
  tasks["melt_chocolate"] = createTaskRegistry( 1, "melt_chocolate", {50})
  tasks["warm_milk"] = createTaskRegistry( 2, "warm_milk", {} )
  tasks["mix_up"] = createTaskRegistry( 1, "mix_up", {} )
  tasks["cool_down"] = createTaskRegistry( 3, "cool_down", {} )
  
  for i, equipment in pairs(equipments) do
    equipment.subscribeAllTasks()
  end

end

function love.mousepressed(x, y, button)
  if button == 1 then
    saveLogButton.clicked(x, y)
  end
end

function love.mousereleased(x, y, button)
  if button == 1 then
    saveLogButton.released()
  end
end

function love.draw()
  for i, equipment in pairs(equipments) do
    equipment.draw()
  end
  for i, report in pairs(reports) do
    report.draw()
  end
  saveLogButton.draw()
end

function love.update(dt)
  mqtt_client:handler()
end