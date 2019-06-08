local network_settings
network_settings = {}

network_settings["ssid"] = "iPhone de Bianca"
network_settings["pwd"] = "biancalinda"

network_settings["Generate_ID"] =
    function (IP)
        return "prefixo_qualquer_"..IP
    end

network_settings["Exclusive_Channel_Name"] =
    function (IP)
        return "exclusive_channel_"..IP
    end

network_settings["Subscription_Channel"] = "subscription_channel"

return network_settings
