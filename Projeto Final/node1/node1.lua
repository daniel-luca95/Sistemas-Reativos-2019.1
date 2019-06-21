local ledVermelho = 3
local ledVerde = 6
local sw1 = 1
local sw2 = 2
local correctPassword= {true,false,false,true,true}
local seqentrada = {}
local tolerance = 250000
local accept = true
--Inicializando LEDs e botões
gpio.mode(ledVermelho, gpio.OUTPUT)
gpio.mode(ledVerde, gpio.OUTPUT)
gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)
gpio.write(ledVermelho, gpio.LOW);
gpio.write(ledVerde, gpio.LOW);

local IP


function askForPassword()
	
end 
function publish(string)
    print("Publishing answer "..string)
    m:publish(
    "Authentication",string,
    0, 0, function (c) print ("Answer \""..string.."\" published.") end
    )
end
function connect_to_()
    m = mqtt.Client("Servidor"..IP, 120)
    -- conecta com servidor mqtt na mÃ¡quina 'ipbroker' e porta 1883:
    m:connect("85.119.83.194", 1883, 0,
      -- callback em caso de sucesso 
      function(client) 
            m:subscribe("Detection",0,  
                   -- fÃ§ chamada qdo inscriÃ§Ã£o ok:
                   function (client) 
                     print("Succesfully listening to client.") 
                   end
                   )

            m:on("message", 
                function(client, topic, data)   
                  print(topic .. ":" )   
                  if data ~= nil then 
                    if data == "Someone got in" then
					if accept then
                        print("Please provide password:")
                        askForPassword();
						gpio.write(ledVermelho, gpio.LOW);
						gpio.write(ledVerde, gpio.LOW);
                    end
                    end
                  end
                end
            )
      end, 
      -- callback em caso de falha 
      function(client, reason) 
        print("failed reason: "..reason) 
      end
    )
end

wificonf = {  
  -- verificar ssid e senha  
  ssid = "",  
  pwd = "",  
  got_ip_cb = function (con)
                IP = con.IP
                print ("meu IP: ", con.IP)
                connect_to_()
              end,
  save = false
}


wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)

