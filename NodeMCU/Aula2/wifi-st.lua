

wificonf = {  
  -- verificar ssid e senha  
  ssid = "iPhone de Bianca",  
  pwd = "biancalinda",  
  got_ip_cb = function (con)
                print ("meu IP: ", con.IP)
              end,
  save = false
}

print("Whatever")
wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)
