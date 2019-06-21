local mqtt = require("mqtt_library")
local Task = require "task"
local Equipment = require "equipment"

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
  elseif status == "finished" then
    equipments[eqNo].setTask("idle")
  elseif status == "progress" then
    tasks[name].percentage = tonumber(message)
  end
end

-------------------------------------------------------------------------

function love.load()
  
  mqtt_client = mqtt.client.create("85.119.83.194", 1883, mqttcb)
  mqtt_client:connect("eng1412984cecinestpasunematricule")
  
  equipments = {}
  tasks = {}
  l = love.graphics.getWidth()/10
  for i=1, 3 do
    table.insert(equipments, Equipment.new( (3*i-2)*l,love.graphics.getHeight()/2 - 75, 2*l, 150))
  end
  
  local function createTaskRegistry(equipment, taskName, hotPoints)
    local newTask = Task.new(taskName, hotPoints)
    newTask["equipment"] = equipment
    equipments[equipment].addTask(newTask)
    return newTask
  end
  
  tasks["melt_chocolate"] = createTaskRegistry( 1, "melt_chocolate", {50})
  tasks["warm_milk"] = createTaskRegistry( 2, "warm_milk", {} )
  tasks["mix_it_up"] = createTaskRegistry( 1, "mix_it_up", {} )
  tasks["cool_down"] = createTaskRegistry( 3, "cool_down", {} )
  
  for i, equipment in pairs(equipments) do
    equipment.subscribeAllTasks()
  end

end

function love.draw()
  for i, equipment in pairs(equipments) do
    equipment.draw()
  end
end

function love.update(dt)
  mqtt_client:handler()
end