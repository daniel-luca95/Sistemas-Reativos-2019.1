local function Generate_ID(IP)
    return "prefixo_qualquer_"..IP
end

local function Generate_Exclusive_Channel_Name(IP)
    return "exclusive_channel_"..IP
end

local Subscription_Channel = "subscription_channel"

-- ConfigurationLoads file with ssid key and password
netword_settings = require "wifi"

local IP

local function monitor()

end


local function detect()

end


local function fire_alarm()

end


local function connect()
    m = mqtt.Client(Generate_ID(IP), 120)
    m:publish()
    
    local function failure_callback (client, reason)
        print("Not possible to connect client "..client.."for reason "..reason)
    end
    local function success_callback()
        m:subscribe(Generate_Exclusive_Channel_Name(IP), 0,
                function ()
                    print("Subscription success")
                end
        )

        m:publish(Subscription_Channel, IP, 0, 0,
            function () 
                print("Subscription ")
            end        
        )

        monitor()
    end
    

    m:connect("85.119.83.194", 1883, 0, sucess_callback, failure_callback)
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


wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)
