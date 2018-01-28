# HomeAssistant RGB Light

## 使用说明

- 修改代码中的WIFI设置以及MQTT服务器信息
- ws2812.newBuffer(20, 3) 此处修改你的灯珠数量

## 支持功能

- RGB调色
- 灯带特效
- 亮度调节(即将支持)

## HomeAssisatnt配置

```yaml

light:
  - platform: mqtt_json
    name: Bed_Room_Light
    state_topic: "BedRoom/rgb"
    command_topic: "BedRoom/rgb/set"
    availability_topic: "BedRoomRGBAvailability"
    rgb: true
    effect: true
    effect_list: [flash, close effect]
```
