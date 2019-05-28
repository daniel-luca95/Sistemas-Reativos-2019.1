local led1 = 3
local ledState = false

gpio.mode(led1, gpio.OUTPUT)
gpio.write(led1, gpio.LOW);


m:subscribe("tecla_pressionada",0,  
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
