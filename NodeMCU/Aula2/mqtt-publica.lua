local sw1 = 1
gpio.mode(sw1,gpio.INT,gpio.PULLUP)
tolerance =250000
last = 0

function publish(level, timestamp)
    print("Am I gonna publish?")
    if timestamp - last > tolerance then
        print("Sending")
        m:publish(
            "botao_pressionado", "a",
            0, 0, function (c) print ("enviou!") end
        )
    end
    last = timestamp
end

gpio.trig(sw1, "down", publish)
