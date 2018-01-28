LED_PIN = 1

-- wifi connect and set wifi state
connect_state = false
wifi.setmode(wifi.STATION)
wifi.sta.sethostname("Node-Fan-3406")
station_cfg={}
station_cfg.ssid="Girls"
station_cfg.pwd="553347880"
wifi.sta.config(station_cfg)

wifi.sta.autoconnect(1)

-- create a mqtt object
m = mqtt.Client("3406", 60, "mqtt", "mqttmqtt") 

-- use alarm api to connect route and mqtt server
tmr.alarm(0, 1000, 1, 
    function()
        if wifi.sta.getip() == nil then
            print("Wifi Connecting...")
        else
            tmr.stop(0)
            m:connect("120.25.57.31",1883,0, 
                function(client)
                    print("connect success")   
                    connect_state = true
                    -- subscribe the kitchen room led message
                    m:subscribe("Fan/3406",2)
                end,
                function(client, reason)
                    print("connect failed: "..reason)
                    connect_state = false
                    node.restart()
                end
            )

        print("Wifi Connected, IP is "..wifi.sta.getip())
    end
end)

-- if NodeMCU get a mqtt json message it will decode this data and do some function
m:on("message", function(client, topic, data) 
    if data ~= nil then
        t = sjson.decode(data)
        print(t["state"])
        print(t["home"])
        if t["state"] == "1" and t["home"] == "3406" then
            LED_OPEN()

        elseif t["state"] == "0" and t["home"] == "3406" then
            LED_CLOSE()
        end
    end
end)

-- if NodeMCU offline it will send a die message to server
m:on("offline", function(client) node.restart();end)
m:lwt("lwt", "{\"home\": \"150\", \"state\": -1}", 2, 0) 

-- open and close led. The relay is low level and effective
function LED_OPEN()
    gpio.mode(LED_PIN, gpio.OUTPUT)
    gpio.write(LED_PIN, gpio.LOW)
end

function LED_CLOSE()
    gpio.mode(LED_PIN, gpio.OUTPUT)
    gpio.write(LED_PIN, gpio.HIGH)
end
