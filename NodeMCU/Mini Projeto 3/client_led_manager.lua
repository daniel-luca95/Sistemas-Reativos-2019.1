local led_manager 
led_manager = {}

local green_led, red_led, state
local timer

red_led = 3
green_led = 6
state = false

gpio.mode(red_led, gpio.OUTPUT)
gpio.mode(green_led, gpio.OUTPUT)
gpio.write(red_led, gpio.LOW)
gpio.write(green_led, gpio.LOW)

local function blink()
    if state then
        gpio.write(green_led, gpio.HIGH)
    else
        gpio.write(green_led, gpio.LOW)
    end
    state = not state
end


led_manager["suspend_activities"] =
    function ()
        timer = tmr.create()
        gpio.write(red_led, gpio.LOW)
        timer:alarm(500, tmr.ALARM_AUTO, blink)
    end

led_manager["lock_station"] =
    function ()
        if timer then timer:stop(); timer = nil end
        gpio.write(red_led, gpio.HIGH)
        gpio.write(green_led, gpio.LOW)
    end

led_manager["free_station"] =
    function ()
        if timer then timer:stop(); timer = nil end
        gpio.write(red_led, gpio.LOW)
        gpio.write(green_led, gpio.LOW)
    end


return led_manager