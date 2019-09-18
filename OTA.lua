print('Wait link to wifi')
wifi.setmode(wifi.STATION)
wifi.sta.config('SSID', 'PASSWORD')
wifi.sta.connect()

function GetWiFiStage()
    if wifi.sta.getip() == nil then
        print('Waiting for IP ...')
    else
        print('IP is ' .. wifi.sta.getip())
        print('WIFI LINK OK')
        tmr.stop(1)
        --當連接上WIFI後，直接調用HTTPGET來加載遠程腳本
        HttpGet_Script()
    end
end

function HttpGet_Script()
    http.get("http://10.0.0.104/Lua/init_Server.lua",
    nil,
    function(code, data)
        if (code < 0) then
            print("HTTP request failed")
        else
            print("Code:" .. code)
            --加載遠程腳本，注意，後面的"()"很重要
            loadstring(data)()
            --調用init_Server.lua 中的 Main 函數
            Main()
        end
    end)
end

tmr.alarm(1, 1000, 1, GetWiFiStage)

--這個很重要，標誌本腳本的版本號
local local_var = 1

function CHECK_FOR_UPDATES()
    http.get("http://10.0.0.104/lua/var.txt",
    nil,
    function(code, data)
        if (code < 0) then
            print("HTTP request failed")
        else
            print("Code:" .. code)
            --開始檢查服務器上的腳本版本，如果大於本地版本號，則開始更新
        if tonumber(data) > local_var then
            --注意：更新前需要將正在運行的邏輯代碼全部停止
            tmr.stop(3)
            tmr.stop(6)
            --再次調用init中的獲取遠程代碼函數
            HttpGet_Script()
        end
        end
    end)
end

function Main()
    --這邊是你需要的腳本邏輯代碼
    tmr.alarm(3, 5*1000, 1, MQTT_EVENT)
    --結束

    --這邊是定時檢查腳本是否需要更新的代碼
    tmr.alarm(6, 60*1000, 1, CHECK_FOR_UPDATES)
end

--http://bit.ly/2oHa9UF