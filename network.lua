local module = {}

function wifi_wait_ip()
    print('Connecting wifi..')
    print("configuring wifi...")
    wifi.setmode(wifi.STATION)
    wifi.sta.sethostname("Node-TestWIFI")
    station_cfg={}
    station_cfg.ssid="Girls"
    station_cfg.pwd="553347880"
    wifi.sta.config(station_cfg)
    wifi.sta.autoconnect(1)
    tmr.alarm(0, 1000, tmr.ALARM_AUTO,
        function()
            if wifi.sta.getip() == nil then
                print('IP unavailable')
            else
                print('Connected to wifi as:' .. wifi.sta.getip())
                tmr.stop(1)
                mosquitto.start()
                tmr.stop(0)
            end
        end
    )
end

function module.start()
    wifi_wait_ip()
end

return module
