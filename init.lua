--init.lua
dofile("sta.lua")
lighton=0
pin=4
gpio.mode(pin,gpio.OUTPUT)
tmr.alarm(1,5500,1,function()
    if lighton==0 then
       lighton=1
        gpio.write(pin,gpio.HIGH)
    else
        lighton=0
        gpio.write(pin,gpio.LOW)
    end
end)
dofile("DHT22.lua")
