--WCS1700.lua
local refreshInterval = 2

local mVperAmp = 33 --33mV on 1A,WCS1700
local Voltage = 0
local VRMS = 0
local AmpsRMS = 0
local maxErr = 0
local avgErr = 0
local totalMeasurement = 0
local TotalPwr = 0

airConditionerStatus = false
sendStatus = false

airConditionerStatus2 = false
sendStatus2 = false

tmr.alarm(0, refreshInterval*1000, tmr.ALARM_AUTO, function()

    totalMeasurement = totalMeasurement + 1
    Voltage = getVPP()
    VRMS = (Voltage/2.0) * 0.707
    AmpsRMS = (VRMS * 1000) / mVperAmp

    if AmpsRMS>10 then
        airConditionerStatus = true
        while airConditionerStatus do
            if airConditionerStatus and sendStatus~=true then
                --sendHttpRequest()
                --dofile("mqttTest.lua")
                tmpA = "on"
                publishMqttMessage(tmpA)
                sendStatus = true
                print(airConditionerStatus)
            else break
            end
        end
    else
        airConditionerStatus = false
        sendStatus = false
    end
    --on

    if AmpsRMS<10 then
        while not airConditionerStatus2 do
            if not airConditionerStatus2 and not sendStatus2 then
                tmpA = "off"
                publishMqttMessage(tmpA)
                sendStatus2 = true
                print(airConditionerStatus2)
            else break
            end
        end
    else
        airConditionerStatus2 = false
        sendStatus2 = false
    end
    --off

    --Pwr = AmpsRMS * 220 /10
    --TotalPwr = TotalPwr + Pwr
    --print("AvrPwr: "..string.format("%.2f",TotalPwr * 10/totalMeasurement).."W - "..string.format("%.2f",AmpsRMS).."A - "..string.format("%.2f",Pwr * 10).."W")
    print(string.format("%.2f",AmpsRMS).."A")
    print(" ")
end)


function publishMqttMessage(data)
    m = mqtt.Client("clientid", 120, "XanxusLabPC", "jhqc69977623")
    m:on("connect", function(client)
        --print ("connected")
    end)
    m:on("offline", function(client)
        --print ("offline")
    end)
    m:on("message", function(client, topic, data)
      print(topic .. ":" )
      if data ~= nil then
        print(data)
      end
    end)
    m:connect("140.121.197.131", 1912, 0, function(client)
      --print("connected")
      switchStatus = {}
      switchStatus.status=data
      ok, json = pcall(sjson.encode, switchStatus)
      client:publish("lab401/NodeMCU/ACS712/airConStatus",json, 0, 0, function(client) print("sent") end)
    end,
    function(client, reason)
      print("failed reason: " .. reason)
    end)
    m:close();
end

function getVPP()
    local result = 0
    local readValue = 0
    local maxValue = 0
    local minValue = 1024
    local nbrReadings = 0
    while (nbrReadings<1000) do
        readValue = adc.read(0)
        if (readValue > maxValue) then
            maxValue = readValue
        elseif (readValue < minValue) then
            minValue = readValue
        end
        nbrReadings = nbrReadings + 1
    end
    print("Max: "..maxValue.." - Min: "..minValue)
    result = (math.abs(maxValue - minValue - 6) * 5)/1024
    if (maxValue - minValue > maxErr) then
        maxErr = maxValue - minValue
    end
    avgErr = avgErr + (maxValue - minValue) / 10

    --print("Err: "..maxValue - minValue.." maxErr: "..maxErr.. " AvgErr: "..string.format("%.2f", avgErr * 10/totalMeasurement))
    print("ADC Value:"..readValue)
    return result
end
--http://bit.ly/2x4yyFR
