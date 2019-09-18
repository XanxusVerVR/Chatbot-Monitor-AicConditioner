--adcPhotoresistorMQTT.lua
airConditionerStatus = false
sendStatus = false

airConditionerStatus2 = false
sendStatus2 = false

tmr.alarm(2,800,1,function()
    adcValue = adc.read(0)
    if adcValue<500 then
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

    if adcValue>500 then
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

    print(adcValue)
end)
