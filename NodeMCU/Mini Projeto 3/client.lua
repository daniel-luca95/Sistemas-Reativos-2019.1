local led_manager
led_manager = require "client_led_manager"

-- This file contains network's ssid and password
local network_settings
network_settings = require "network_settings"


local monitoring_timer
local IP
local waiting_validation

local light_sensor
light_sensor = 0

local function detected()
    print("Someone was detected")
    waiting_validation = true
    m:publish(
        "Detection", "Someone got in", 0, 0,
        function (client)
            print("Report sent to ".."Detection")
        end
    )
    led_manager.suspend_activities()
end

local step, sum
step = 0
sum = 0

-- Function called repeatedly by monitoring timer
local function monitor()
    if not waiting_validation then
        --- Light sensor
        value = adc.read(light_sensor)
        step = step + 1
        sum = sum + value
        if step == 10 then
			-- Manually calibrated value for high luminosity
            if sum/step < 500 then
                detected()
            end
            sum = 0
            step = 0
        end
    end
end

local function fire_alarm()
    print("Alarm fired!")
    led_manager.lock_station()
end

local function connect()
    local client_name
	client_name = network_settings.Generate_ID(IP)
    print("Client Name: "..client_name)
    m = mqtt.Client(client_name, 120)
    print("Connecting...")
    
    local function failure_callback (client, reason)
        print("Not possible to connect for reason "..reason..".")
    end
    
    local function success_callback(client)
	
        print("Connected succesfully")
		-- Channel in which Server answers
        m:subscribe("Authentication", 0,
                function (client)
                    print("Listening to Authentication")
                end
        )
        
		-- Definition on how to handle the server answers
        m:on("message", 
            function (client, topic, data)
                if waiting_validation then
                    if data == "Authorized" then
                        print("Person authorized")
                        led_manager.free_station()
                        waiting_validation = false
                    elseif data == "Denied" then
                        fire_alarm()
                    end
                end
            end
        )
		
		-- Creation of timer that monitors the lgight sensor
		monitoring_timer = tmr.create()
		if not monitoring_timer then
			print("Error creating timer.")
		end
		monitoring_timer:alarm(50, tmr.ALARM_AUTO, monitor)
    end

    m:connect("85.119.83.194", 1883, 0, success_callback, failure_callback)
end


wificonf = {  
  -- verificar ssid e senha  
  ssid = network_settings.ssid,  
  pwd = network_settings.pwd,  
  got_ip_cb = function (con)
                IP = con.IP
                print ("meu IP: ", IP)
                connect()
              end,
  save = false
}


led_manager.free_station()
print("ssid", network_settings.ssid, "pwd", network_settings.pwd)

wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)
