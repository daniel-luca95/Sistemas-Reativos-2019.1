local Task
Task = {}

-------------------------------------------------------------------------


-------------------------------------------------------------------------

Task["new"] = 
  function (name, hotPoints)
    local task
    task = {}
    
    local function getChannels()
    local channels = {}
    table.insert(channels, "started__"..name)
    table.insert(channels, "finished__"..name)
    table.insert(channels, "progress__"..name)
    for k, v in ipairs(hotPoints) do
      table.insert(channels, "hotpoint__"..name.."__"..v)
    end
    return channels
  end

    
    task["name"] = name
      
    task["subscribeAll"] =
      function ()
        mqtt_client:subscribe(getChannels(name))
      end
    
    task["percentage"] = 0 
    
    return task
  end

-------------------------------------------------------------------------

return Task