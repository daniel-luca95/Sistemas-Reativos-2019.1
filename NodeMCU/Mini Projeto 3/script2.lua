local led1 = 3
local ledState = false

gpio.mode(led1, gpio.OUTPUT)
gpio.write(led1, gpio.LOW);

local IP

function connect_to_()
    m = mqtt.Client("prefixo_qualquer_"..IP, 120)
    -- conecta com servidor mqtt na mÃ¡quina 'ipbroker' e porta 1883:
    m:connect("85.119.83.194", 1883, 0,
      -- callback em caso de sucesso  
      function(client) 
        
            m:subscribe("cecinestpasunchannel",0,  
                   -- fÃ§ chamada qdo inscriÃ§Ã£o ok:
                   function (client) 
                     print("subscribe success") 
                   end
                   )


            m:on("message", 
                function(client, topic, data)   
                  print(topic .. ":" )   
                  if data ~= nil then print(data) end
                  ledState = not ledState
                  if ledState then
                    gpio.write(led1, gpio.HIGH)
                  else
                    gpio.write(led1, gpio.LOW)
                  end
                end
            )


            local sw1 = 1
            gpio.mode(sw1,gpio.INT,gpio.PULLUP)
            tolerance =250000
            last = 0
            
            function publish(level, timestamp)
                print("Am I gonna publish?")
                if timestamp - last > tolerance then
                    print("Sending")
                    m:publish(
                        "cecinestpasunchannel", "ceci n est pas une message",
                        0, 0, function (c) print ("enviou!") end
                    )
                end
                last = timestamp
            end
            
            gpio.trig(sw1, "down", publish)



            
      end, 
      -- callback em caso de falha 
      function(client, reason) 
        print("failed reason: "..reason) 
      end
    )
end

wificonf = {  
  -- verificar ssid e senha  
  ssid = "iPhone de Bianca",  
  pwd = "biancalinda",  
  got_ip_cb = function (con)
                IP = con.IP
                print ("meu IP: ", con.IP)
                connect_to_()
              end,
  save = false
}


wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)
