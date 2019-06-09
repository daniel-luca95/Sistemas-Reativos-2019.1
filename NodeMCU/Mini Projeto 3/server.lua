local ledVermelho = 3
local ledVerde = 6
local sw1 = 1
local sw2 = 2
local correctPassword= {true,false,false,true,true}
local seqentrada = {}
local tolerance = 250000
local accept = nil

--Inicializando LEDs e botões
gpio.mode(ledVermelho, gpio.OUTPUT)
gpio.mode(ledVerde, gpio.OUTPUT)
gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)
gpio.write(ledVermelho, gpio.LOW);
gpio.write(ledVerde, gpio.LOW);

local IP

local function contabilizaResultado()
    local equal
    equal = true
    for indice, entrada in pairs(seqentrada) do
        if correctPassword[indice] ~= entrada then
            equal = false
            break
        end
    end
    if equal then
        print("Acertou a senha")
        gpio.write(ledVerde, gpio.HIGH)
        publish("Athorized")
    else
        print("Nao acertou a senha")
        gpio.write(ledVermelho, gpio.HIGH)
        publish("Denied")
    end
    seqentrada = {}
end

function askForPassword()
	local function registerButton(button)
        local digit
		local ultimoAperto
		ultimoAperto = 0
		gpio.trig(button, "down",   function (level, timestamp)
										if timestamp > ultimoAperto + tolerance  then
											ultimoAperto = timestamp
                                           if button == 1 then
                                                print(1)
                                                digit = true
                                           else
                                                print(0)
                                                digit = false
                                           end
											seqentrada[#seqentrada+1] = digit
											if #seqentrada == 5 then
												contabilizaResultado()
                                                
											end
										end
									end
		)
	end
  registerButton(1)
  registerButton(2)
	
end 
function publish(string)
    print("Am I gonna publish?")
    print("Sending")
    m:publish(
    "Detection",string,
    0, 0, function (c) print ("enviou!") end
    )
end
function connect_to_()
    m = mqtt.Client("Servidor"..IP, 120)
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
                        askForPassword();
                            
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
  ssid = "MDF",  
  pwd = "e09f5bb2bb",  
  got_ip_cb = function (con)
                IP = con.IP
                print ("meu IP: ", con.IP)
                connect_to_()
              end,
  save = false
}


wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)
