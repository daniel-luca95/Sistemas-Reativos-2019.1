package.path = package.path .. ";../?.lua"
network_settings = require "network_settings"

local IP

local current_task
local message_handlers
message_handlers = {}
local timer

local taskPercentage = 0

local function percent_update()
	taskPercentage = taskPercentage + 1
	publish("progress__melt_chocolate",taskPercentage)
	if taskPercentage == 50 then
		publish("hotpoint__melt_chocolate__50", "")
	elseif taskPercentage == 100 then
		publish("finished__melt_chocolate","")
		taskPercentage = 0
		timer:stop()
	end
end
	
	

local function enable_begin()
	button1 = 1
	gpio.mode(button1,gpio.INT,gpio.PULLUP)
	gpio.trig(button1, "down", 
		function (level, timestamp)
				taskPercentage = 0
				publish("progress__melt_chocolate", taskPercentage)
				publish("started__melt_chocolate","")
				timer = tmr.create()
				timer:alarm(1000,tmr.ALARM_AUTO,percent_update)	
				gpio.trig(button1)
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

	-- para cada task que este nó executa deve haver um código que permita ela ser iniciada
	enable_begin()
	m:on("message", 
		function (client, topic, data)
			print("client: "..client, "topic: "..topic, "data: "..data)
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
