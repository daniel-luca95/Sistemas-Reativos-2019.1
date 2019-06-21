function publish(channel,string)
    print("Publishing answer "..string)
    m:publish(
    channel,string,
    0, 0, function (c) print ("Answer \""..string.."\" published.") end
    )
end

publish("started__melt_chocolate","")
publish("progress__melt_chocolate","10")
publish("progress__melt_chocolate","20")
publish("progress__melt_chocolate","30")
publish("progress__melt_chocolate","40")
publish("progress__melt_chocolate","50")
publish("progress__melt_chocolate","60")
publish("progress__melt_chocolate","70")
publish("progress__melt_chocolate","80")
publish("progress__melt_chocolate","90")
publish("progress__melt_chocolate","100")
publish("finished__melt_chocolate","100")
--publish("finished__melt_chocolate","120")
publish("started__warm_milk","10")
publish("progress__warm_milk","30")
publish("progress__warm_milk","70")
publish("started__cool_down","10")
publish("progress__cool_down","5")
--publish("finished__melt_chocolate","100")