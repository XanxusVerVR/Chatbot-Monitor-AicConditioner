print("Ready to Set up wifi mode")

wifi.setmode(wifi.STATION)

station_cfg={}
station_cfg.ssid="SOSELab-G"
--station_cfg.ssid="ntou-albert"
station_cfg.pwd="soselab401"
--station_cfg.pwd="662566256625"
station_cfg.save=true
wifi.sta.config(station_cfg)
wifi.sta.connect()
local cnt = 0
tmr.alarm(3, 1000, 1, function()
    if (wifi.sta.getip() == nil) and (cnt < 20) then
        print("Trying Connect to Router, Waiting...")
        cnt = cnt + 1
    else
        tmr.stop(3)
    if (cnt < 20) then
        print("Config done, IP is "..wifi.sta.getip())
    else print("Wifi setup time more than 20s, Please verify wifi.sta.config() function. Then re-download the file.")
    end
        cnt = nil;
        collectgarbage();
    end
end)
