local green_led, red_led, sensor
red_led = 3
green_led = 6
sensor = 0


gpio.mode(red_led, gpio.OUTPUT)
gpio.mode(green_led, gpio.OUTPUT)
gpio.write(red_led, gpio.LOW);
gpio.write(green_led, gpio.LOW);

local monitoring_timer

-- ConfigurationLoads file with ssid key and password
local network_settings
network_settings = require "network_settings"

local IP
local waiting_validation


local function detected()
    print("Someone was detected")
    m:publish(
        network_settings.Report_Exclusive_Channel(IP), "Someone got in", 0, 0,
        function (client)
            print("Report sent to "..network_settings.Report_Exclusive_Channel(IP))
        end
    )
end


local step, sum
step = 0
sum = 0

local function monitor()
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


local function fire_alarm()
    print("Alarm fired!")
    gpio.write(red_led, gpio.HIGH)
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
                --if topic == ""
                if waiting_validation then
                    if data == "Authorized" then
                        print("Person authorized")
                    elseif data == "Denied" then
                        fire_alarm()
                    end
                    waiting_validation = false
                --else publish error report
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


print("ssid", network_settings.ssid, "pwd", network_settings.pwd)

wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)


