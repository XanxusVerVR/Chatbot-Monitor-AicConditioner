--SmartConfig.lua
wifi.setmode(wifi.STATION)
wifi.startsmart(0,
    function(ssid, password)
        print(string.format("Success. SSID:%s ; PASSWORD:%s", ssid, password))
    end
)
wifi.setphymode(wifi.PHYMODE_N)
print(wifi.getphymode())
