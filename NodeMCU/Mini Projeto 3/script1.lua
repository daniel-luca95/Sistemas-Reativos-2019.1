local sensor = 0
local sw1 = 1
local led1 = 3

gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(led1, gpio.OUTPUT)

gpio.write(led1, gpio.LOW)

local function cbchave1 (_,contador)
 for i=1,10 do
  print(adc.read(sensor) )
 end
end


gpio.trig(sw1, "down", cbchave1)
