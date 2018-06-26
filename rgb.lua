local module = {}

ws2812.init()

 
g = 230
r = 230
b = 230
brightness = 255

local i, buffer = 0, ws2812.newBuffer(config.LEDNUM, 3)
ws2812_effects.init(buffer)
buffer:fill(0, 0, 0)
ws2812.write(buffer)


function module.white()
    buffer:fill(230, 230, 230)
    ws2812.write(buffer)
end
 
function module.change_color(g, r, b)
    ws2812_effects.set_brightness(brightness)
    ws2812_effects.set_color(g,r,b)
    ws2812_effects.set_mode("static")
    ws2812_effects.start()
end
 
function module.close()
    buffer:fill(0, 0, 0)
    ws2812.write(buffer)
    ws2812_effects.stop()
end

function module.set_brightness(brightness)
    ws2812_effects.set_brightness(brightness)
    ws2812_effects.set_color(g,r,b)
    ws2812_effects.set_mode("static")
    ws2812_effects.start()
end

function module.change_effects(effect)
    ws2812_effects.set_brightness(brightness)
    ws2812_effects.set_color(g,r,b)
    if effect == "blink" then
        ws2812_effects.set_mode("blink")
    elseif effect == "rainbow_cycle" then
        ws2812_effects.set_mode("rainbow_cycle", 3)
    elseif effect == "static" then
        ws2812_effects.set_mode("static")
    elseif effect == "fire" then
        ws2812_effects.set_mode("fire")
    elseif effect == "fire_soft" then
        ws2812_effects.set_mode("fire_soft")
    elseif effect == "fire_intense" then
        ws2812_effects.set_mode("fire_intense")
    elseif effect == "halloween" then
        ws2812_effects.set_mode("halloween")
    elseif effect == "circus_combustus" then
        ws2812_effects.set_mode("circus_combustus")
    elseif effect == "larson_scanner" then
        ws2812_effects.set_mode("larson_scanner")
    elseif effect == "random_dot" then
        ws2812_effects.set_mode("random_dot", 3)
    end
    ws2812_effects.start()
end

function module.close_effect()
    ws2812_effects.set_brightness(brightness)
    ws2812_effects.set_color(g,r,b)
    ws2812_effects.set_mode("static")
    ws2812_effects.start()
end


return module