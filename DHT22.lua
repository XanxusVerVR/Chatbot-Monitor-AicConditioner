--DHT22.lua
airConditionerStatus = false
sendStatus = false
airConditionerStatus2 = false
sendStatus2 = false

tmr.alarm(3,5000,1,function()
    pin = 4
    status, temp, humi, temp_dec, humi_dec = dht.read(pin)
    if status == dht.OK then
        --print("DHT Temperature:"..temp..";".."Humidity:"..humi)
        dht22 = {}
        dht22.Humidity=humi
        dht22.Temperature=temp
        ok, json = pcall(sjson.encode, dht22)
        assert(loadfile("PublishMQTT2.lua"))("lab401/NodeMCUv2/DHT22",json)
        
        if temp<=21 then
            airConditionerStatus = true
            while airConditionerStatus do
                if airConditionerStatus and sendStatus~=true then
                    airStatus = {}
                    airStatus.switch = "on"
                    ok, json = pcall(sjson.encode, airStatus)
                    assert(loadfile("PublishMQTT2.lua"))("lab401/NodeMCUv2/DHT22/switch",json)
                    sendStatus = true
                    print("on")
                else break
                end
            end
        else
            airConditionerStatus = false
            sendStatus = false
        end
        --on

        if temp>21 then
        while not airConditionerStatus2 do
            if not airConditionerStatus2 and not sendStatus2 then
                airStatus = {}
                airStatus.switch = "off"
                ok, json = pcall(sjson.encode, airStatus)
                assert(loadfile("PublishMQTT2.lua"))("lab401/NodeMCUv2/DHT22/switch",json)
                sendStatus2 = true
                print("off")
            else break
            end
        end
        else
            airConditionerStatus2 = false
            sendStatus2 = false
        end
        --off
        
    elseif status == dht.ERROR_CHECKSUM then
        --print( "DHT Checksum error." )
    elseif status == dht.ERROR_TIMEOUT then
        --print( "DHT timed out." )
    end
end)
