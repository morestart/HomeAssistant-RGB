local module = {}

m = nil


local function register_device()
    m:subscribe("BedRoom/rgb/set",0)
end

local function push_availablitity()
    m:publish("BedRoomRGBAvailability","online",1,0)
end


local function mqtt_start()
    m = mqtt.Client(config.ID, 120, config.USER,config.PWD)

    m:on("message", 
        function(client, topic, data)
            t = sjson.decode(data)
            if t["state"] == "ON" and t["color"] == nil and t["brightness"] == nil and t["effect"] == nil then 
                rgb.white()
                m:publish("BedRoom/rgb","{\"state\":\"ON\"}",0,1)
            elseif t["state"] == "OFF" and t["color"] == nil and t["brightness"] == nil and t["effect"] == nil then
                rgb.close()
                m:publish("BedRoom/rgb","{\"state\":\"OFF\"}",0,1)
            elseif t["color"] ~= nil and t["brightness"] == nil and t["effect"] == nil then
                g = t["color"]["g"]
                r = t["color"]["r"]
                b = t["color"]["b"]
                rgb.change_color(g, r, b)
            elseif t["color"] == nil and t["brightness"] == nil and t["effect"] ~= nil then
                print(t["effect"])
                rgb.change_effects(t["effect"])
            elseif t["effect"] ~= nil and t["effect"] == "static" then
                rgb.close_effect()
            elseif t["color"] == nil and t["brightness"] ~= nil and t["effect"] == nil then
                print(t["brightness"])
                brightness = t["brightness"]
                rgb.set_brightness(brightness)
            end
        end
    )

    m:on("offline",
        function(client)
            mqtt_start()
        end
    )

    m:lwt("BedRoomRGBAvailability", "offline")

    m:connect(config.HOST, config.PORT, 0, 0,
        function(client)
            register_device()
            tmr.alarm(4, config.DELAY, tmr.ALARM_AUTO, push_availablitity)
        end,
        function(client, reason)
            print("MQTT Connect Failed" .. reason)
            node.restart()
        end
    )
end


function module.start()
    mqtt_start()
end

return module
