local led1 = 3
local led2 = 6
local sw1 = 1
local sw2 = 2
local correctPassword= {}
local seqentrada = {true,false,false,}
tolerance = 250000

gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
gpio.mode(sw1,gpio.PULLUP)
gpio.mode(sw2,gpio.PULLUP)
gpio.write(led1, gpio.LOW);
gpio.write(led2, gpio.LOW);

local IP

local function exibeResultado()
    local equal
    equal = true
    for indice, entrada in pairs(seqentrada) do
        if correctPassword[indice] ~= entrada then
            equal = false
            break
        end
    end
    if equal then
        return true
    else
        return false
    end
    gpio.trig(sw1)
    gpio.trig(sw2)
end

function askForPassword()
	local function registerButton(button)
		local ultimoAperto
		ultimoAperto = 0
		gpio.trig(button, "down",   function (level, timestamp)
										if timestamp > ultimoAperto + tolerance  then
											ultimoAperto = timestamp
											print(button)
											seqentrada[#seqentrada+1] = button
											if #seqentrada == 5 then
												exibeResultado()
											end
										end
									end
		)
	end
  registerButton(sw1)
  registerButton(sw2)
	
end 
	
function connect_to_()
    m = mqtt.Client("prefixo_qualquer_"..IP, 120)
    -- conecta com servidor mqtt na mÃ¡quina 'ipbroker' e porta 1883:
    m:connect("85.119.83.194", 1883, 0,
      -- callback em caso de sucesso  
      function(client) 
        
            m:subscribe("Authentication",0,  
                   -- fÃ§ chamada qdo inscriÃ§Ã£o ok:
                   function (client) 
                     print("subscribe success") 
                   end
                   )


            m:on("message", 
                function(client, topic, data)   
                  print(topic .. ":" )   
                  if data ~= nil then 
                    if data == "Someone got in" then
                        print("Password")
                        answer = askForPassword();
                        if(answer) then
                            gpio.write(led1, gpio.HIGH)
                            publish("Athorized")
						else
							gpio.write(led2, gpio.HIGH)
                            publish(string)
                            publish("Denied")
                        end
                            
                    end
                  end
                end
            )
            
            function publish(string)
                print("Am I gonna publish?")
                print("Sending")
                m:publish(
                    "Detection",string,
                    0, 0, function (c) print ("enviou!") end
                )
            end
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
