local Task
Task = {}

-------------------------------------------------------------------------

local function getChannels()
  local channels = {}
  table.insert(channels, "started__" + nome)
  table.insert(channels, "finished__" + nome)
  table.insert(channels, "progress__" + nome)
  for k, v in ipairs(hotPoints) do
    table.insert(channels, "hotpoint__" + nome + "__" + v)
  end
  return channels
end

-------------------------------------------------------------------------

Task["new"] = 
  function (nome, hotPoints)
    local task
    task = {}
    
    task["nome"] = nome
      
    task["subscribeAll"] =
      function ()
        mqtt_client:subscribe(getChannels())
      end
    
    task["percentage"] = 0 
    
    return task
  end

-------------------------------------------------------------------------

return Task