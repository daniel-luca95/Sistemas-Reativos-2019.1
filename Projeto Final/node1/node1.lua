package.path = package.path .. ";../?.lua"
network_settings = require "network_settings"

local IP

local current_task
local message_handlers
message_handlers = {}
local timer
local taskPercentage = 0
local button1, button2
button1 = 1
button2 = 2
light_sensor = 0

local queue = {}

local function percent_update()
	taskPercentage = taskPercentage + 5
	publish("progress__melt_chocolate",taskPercentage)
	if taskPercentage == 75 then
		publish("hotpoint__melt_chocolate__75", "")
	elseif taskPercentage == 100 then
		publish("finished__melt_chocolate","")
		gpio.trig(button2)
		if #queue > 0 then
			nextInQueue = queue[1]
			queue[1] = nil
			local newQueue
			newQueue = {}
			for i, entry in ipairs(queue) do
				newQueue[i-1] = entry
			end
			queue = newQueue
			nextInQueue()
		end
	end
end

local function enable_begin()
	gpio.mode(button1,gpio.INT,gpio.PULLUP)
	gpio.trig(button1, "down", 
		function (level, timestamp)
				taskPercentage = 0
				publish("progress__melt_chocolate", taskPercentage)
				publish("started__melt_chocolate","")
				
				local last_pressed
				last_pressed = 0
				gpio.mode(button2, gpio.INT, gpio.PULLUP)
				gpio.trig(button2, "down", 	function (level, timestamp)
												if timestamp - last_pressed > 250000 then
													last_pressed = timestamp
													percent_update()
												end
											end
				)
				gpio.trig(button1)
		end
	)
	
end


local step, sum
step = 0
sum = 0

local function mix_percent_update()
    value = adc.read(light_sensor)
	step = step + 1
	sum = sum + value
	if step == 10 then
		-- Manually calibrated value for high luminosity
		if sum/step < 500 then
			taskPercentage = taskPercentage + 20
			
			publish("progress__mix_up",taskPercentage)
		end
		sum = 0
		step = 0
	end

	
	if taskPercentage == 100 then
		publish("finished__mix_up","")
		timer:stop()
		enable_begin()
	end
end

	
local function listen_to_mix_up()
	m:subscribe("finished__warm_milk", 0,
       function (client) 
         print("subscribe success to warm milk.") 
       end
	)
	table.insert(message_handlers, 
		function (client, topic, data)
			if topic == "finished__warm_milk" then
				local start_mix_up 
				start_mix_up = 	function ()
									taskPercentage = 0
									publish("progress__mix_up", taskPercentage)
									publish("started__mix_up", "")
									timer = tmr.create()
									timer:alarm(25,tmr.ALARM_AUTO, mix_percent_update)
								end
				if taskPercentage == 100 then 
					start_mix_up()
				else
					table.insert(queue, start_mix_up)
				end
			end
		end
	)
end


function publish(channel,string)
    print("Publishing answer "..string)
    m:publish(
    channel,string,
    0, 0, function (c) print ("Answer \""..string.."\" published.") end
    )
end

local function set_up( client )

	enable_begin()
	listen_to_mix_up()
	
	m:on("message", 
		function (client, topic, data)
			for i, handler in pairs(message_handlers) do
				if handler(client, topic, data) then
					break
				end
			end
		end
	)
end

local function connect_to_mqtt()
    m = mqtt.Client("Servidor"..IP, 120)
    -- conecta com servidor mqtt na mÃ¡quina 'ipbroker' e porta 1883:
    m:connect("85.119.83.194", 1883, 0,
      -- callback em caso de sucesso 
      set_up, 
      -- callback em caso de falha 
      function(client, reason) 
        print("failed reason: "..reason) 
      end
    )
end

wificonf = {  
  -- verificar ssid e senha  
  ssid = network_settings.ssid,  
  pwd = network_settings.pwd,  
  got_ip_cb = function (con)
                IP = con.IP
                print ("meu IP: ", IP)
                connect_to_mqtt()
              end,
  save = false
}

wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)
