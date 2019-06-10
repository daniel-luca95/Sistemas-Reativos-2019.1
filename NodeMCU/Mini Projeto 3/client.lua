local green_led, red_led, sensor
red_led = 3
green_led = 6
sensor = 0


gpio.mode(red_led, gpio.OUTPUT)
gpio.mode(green_led, gpio.OUTPUT)
gpio.write(red_led, gpio.LOW);
gpio.write(green_led, gpio.LOW);


-- ConfigurationLoads file with ssid key and password
local netword_settings
netword_settings = require "network_settings"

local IP
local waiting_validation
local unlocked
unlocked = true

local function monitor()
    print("Monitoring")
    local step, sum
    step = 0
    sum = 0
    while unlocked do
        --- logic to monitor 
        value = adc.read(sensor)
        step = step + 1
        sum = sum + value
        if step == 1000 then
            print("Medium value:", value/step)
            if value/step > 500 then
                detected()
            end
            step = 0
        end
    end
end



local function detected()
    print("Someone was detected")
    m:publish(
        netword_settings.Report_Exclusive_Channel(IP), "Someone got in", 0, 0,
        function (client)
            waiting_validation = true
        end
    )
end


local function fire_alarm()
    print("Alarm fired!")
    gpio.write(red_led, gpio.HIGH)
    unlocked = false
end


local function connect()
    print("Client Name: "..netword_settings.Generate_ID(IP))
    m = mqtt.Client(netword_settings.Generate_ID(IP), 120)
    print("Connecting...")
    
    local function failure_callback (client, reason)
        print("Not possible to connect for reason "..reason..".")
    end
    
    local function success_callback(client)
        print("Connected succesfully")
        m:subscribe(netword_settings.Authentication_Exclusive_Channel(IP), 0,
                function (client)
                    print("Subscription success")
                end
        )

        m:publish(netword_settings.Subscription_Channel, IP, 0, 0,
            function (client) 
                print("Subscription done.")
            end        
        )

        m:on("message", 
            function (client, topic, data)
                if waiting_validation then
                    if data == "Authorized" then

                    elseif data == "Denied" then
                        fire_alarm()
                    end
                    waiting_validation = false
                --else publish error report
                end
            end
        )

        monitor()
    end

    m:connect("85.119.83.194", 1883, 0, success_callback, failure_callback)
end


wificonf = {  
  -- verificar ssid e senha  
  ssid = netword_settings.ssid,  
  pwd = netword_settings.pwd,  
  got_ip_cb = function (con)
                IP = con.IP
                print ("meu IP: ", IP)
                connect()
              end,
  save = false
}


print("ssid", netword_settings.ssid, "pwd", netword_settings.pwd)

wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)
