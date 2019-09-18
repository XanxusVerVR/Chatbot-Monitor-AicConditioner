--PublishMQTT2.lua
local topic,message=...
m = mqtt.Client("clientid", 120, "XanxusMQTT", "jhqc69977623")
m:on("connect", function(client)
--    print ("connected")
end)
m:on("offline", function(client)
--    print ("offline")
end)
m:on("message", function(client, topic, data)
    print(topic .. ":" )
    if data ~= nil then
        print(data)
    end
end)
m:connect("140.121.197.131", 1912, 0, function(client)
    client:publish(topic,message, 0, 0, function(client) print("sent") end)
    end,
    function(client, reason) print("failed reason: " .. reason)
end)
m:close();
