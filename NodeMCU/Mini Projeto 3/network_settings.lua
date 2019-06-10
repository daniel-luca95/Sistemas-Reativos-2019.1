local network_settings
network_settings = {}

network_settings["ssid"] = "iPhone de Bianca"
network_settings["pwd"] = "biancalinda"

local function filter(str)
    str = str:gsub("%.","")
    return str
end

network_settings["Generate_ID"] =
    function (IP)
        return filter("prefixo_qualquer_"..IP)
    end

network_settings["Report_Exclusive_Channel"] =
    function (IP)
        return filter("report_channel_"..IP)
    end

network_settings["Authentication_Exclusive_Channel"] =
    function (IP)
        return filter("authentication_channel_"..IP)
    end


network_settings["Subscription_Channel"] = "subscription_channel"

return network_settings
