local sensor
sensor = 0
local led_manager
led_manager = require "client_led_manager"

local monitoring_timer

-- Configuration loads file with ssid key and password
local network_settings
network_settings = require "network_settings"

local IP
local waiting_validation    

local function detected()
    print("Someone was detected")
    waiting_validation = true
    m:publish(
        network_settings.Report_Exclusive_Channel(IP), "Someone got in", 0, 0,
        function (client)
            print("Report sent to "..network_settings.Report_Exclusive_Channel(IP))
        end
    )
    led_manager.suspend_activities()
end


local step, sum
step = 0
sum = 0

local function monitor()
    if not waiting_validation then
        --- logic to monitor 
        value = adc.read(sensor)
        step = step + 1
        sum = sum + value
        if step == 10 then
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
    print("Client Name: "..network_settings.Generate_ID(IP))
    m = mqtt.Client(network_settings.Generate_ID(IP), 120)
    print("Connecting...")
    
    local function failure_callback (client, reason)
        print("Not possible to connect for reason "..reason..".")
    end
    
    local function success_callback(client)
        print("Connected succesfully")
        m:subscribe(network_settings.Authentication_Exclusive_Channel(IP), 0,
                function (client)
                    print("Listening to "..network_settings.Authentication_Exclusive_Channel(IP))
                end
        )

        m:publish(network_settings.Subscription_Channel, IP, 0, 0,
            function (client) 
                print("Server notified.")
                monitoring_timer = tmr.create()
                if not monitoring_timer then
                    print("Error creating timer.")
                end
                monitoring_timer:alarm(50, tmr.ALARM_AUTO, monitor)
            end        
        )

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


