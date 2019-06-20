local mqtt = require("mqtt_library")

function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-------------------------------------------------------------------------

local function taskManager(equipment, nome, hotPoints)
  local newTask = {}
  newTask["equipment"] = equipment
  newTask["nome"] = nome
  
  local function getChannels()
    local channels = {}
    channels["started"] = "started__"+nome
    channels["finished"] = "finished__"+nome
    channels["progress"] = "progress__"+nome
    for k, v in ipairs(hotPoints) do
      channels[k] = "hotpoint__" + nome + "__" + v
    end
    return channels
  end
  
  newTask["subscribeAll"] =
    function ()
      mqtt_client:subscribe(getChannels())
    end
  newTask["status"] = "idle"
  newTask["percentage"] = 0 
end

function mqttcb(topic, message)
  local res = split(topic, "__")
  status = res[1]
  name = res[2]
  tasks[name].status = status
end

function love.load()
  equipments = {100, 200 , 300}
  tasks = {}
  tasks["melt_chocolate"] = taskManager( 1, "melt_chocolate", {50})
  tasks["warm_milk"] = taskManager( 2, "warm_milk", {} )
  tasks["mix_it_up"] = taskManager( 1, "mix_it_up", {} )
  tasks["cool_down"] = taskManager( 3, "cool_down", {} )
end

function love.draw()
  for task, taskHandler in pairs() do
    if taskHandler.status ~= "idle" then
      love.graphics.rectangle("fill", equipments[taskHandler.equipment], 300, 50, 50)
    end
  end
end

function love.update(dt)
--  mqtt_client:handler()
end