ws2812.init()

g = 230
r = 230
b = 230

connect_state = false
 
wifi.setmode(wifi.STATION)
wifi.sta.sethostname("Node-RGB")
station_cfg={}
station_cfg.ssid="WIFI SSID"
station_cfg.pwd="WIFI PASSWORD"
wifi.sta.config(station_cfg)
wifi.sta.autoconnect(1)

local i, buffer = 0, ws2812.newBuffer(灯珠数量, 3)
buffer:fill(0, 0, 0)
ws2812.write(buffer)
 
m = mqtt.Client("NodeRGB", 60, "mqtt用户名", "mqtt密码") 
 

tmr.alarm(0, 1000, 1, function()
        if wifi.sta.getip() == nil then
            print("Wifi Connecting...")
        else
            init_mqtt()
            tmr.stop(0)
            print("Wifi Connected, IP is "..wifi.sta.getip())
        end
end)


tmr.alarm(1, 50000, 1, function()
     m:publish("BedRoomRGBAvailability","online",0,1)
end)


function init_mqtt()
    m:connect("mqtt服务地址",1883,0, 
               function(client)
                   print("connect success")   
                   connect_state = true
                   m:subscribe("BedRoom/rgb/set",0)
                   m:publish("BedRoomRGBAvailability","online",0,1)
                   
               end,
               function(client, reason)
                   print("connect failed: "..reason)
                   node.restart()
               end)
end
 
m:on("message", function(client, topic, data) 
    if data ~= nil then
        t = sjson.decode(data)
        if t["state"] == "ON" and t["color"] == nil and t["brightness"] == nil and t["effect"] == nil then 
            white()
            m:publish("BedRoom/rgb","{\"state\":\"ON\"}",0,1)
        elseif t["state"] == "OFF" and t["color"] == nil and t["brightness"] == nil and t["effect"] == nil then
            if tmr.state() == true then
                tmr.stop(2)
            end
            close()
            m:publish("BedRoom/rgb","{\"state\":\"OFF\"}",0,1)
        elseif t["color"] ~= nil and t["brightness"] == nil and t["effect"] == nil then
            g = t["color"]["g"]
            r = t["color"]["r"]
            b = t["color"]["b"]
            change_color(g, r, b)
        elseif t["color"] == nil and t["brightness"] == nil and t["effect"] ~= nil and t["effect"] == "flash" then
            tmr.alarm(2, 50, 1, flash)
        elseif t["effect"] ~= nil and t["effect"] == "close effect" then
            tmr.stop(2)
            white()
        end
    end
end)

m:on("offline", function(client)
    init_mqtt()
end)

m:lwt("BedRoomRGBAvailability", "offline", 0, 0)

 
function white()
    buffer:fill(230, 230, 230)
    ws2812.write(buffer)
end
 
function change_color(g, r, b)
    buffer:fill(g, r, b)
    ws2812.write(buffer)
end
 
function close()
    buffer:fill(0, 0, 0)
    ws2812.write(buffer)
end

function flash()
    i = i + 1
    buffer:fade(2)
    buffer:set(i%buffer:size() + 1, g, r, b)
    ws2812.write(buffer)
end