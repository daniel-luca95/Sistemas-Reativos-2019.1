local mqtt = require("mqtt_library")

function mqttcb(topic, message)
   print("Received from topic: " .. topic .. " - message:" .. message)
   controle = not controle
   print(message)
end

function love.keypressed(key)
  if key == 'a' then
    mqtt_client:publish("tecla_pressionada", "aa")
  end
end

function love.load()
  controle = false
  mqtt_client = mqtt.client.create("test.mosquitto.org", 1883, mqttcb)
  mqtt_client:connect("eng1420333")
  mqtt_client:subscribe({"botao_pressionado"})
end

function love.draw()
   if controle then
     love.graphics.rectangle("fill", 10, 10, 200, 150)
   end
end

function love.update(dt)
  mqtt_client:handler()
end