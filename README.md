# HomeAssistant RGB Light

## 使用说明

- 修改`config.lua`文件的配置信息

## 支持功能

- RGB调色
- 灯带特效(多种灯带特效)
- 亮度调节

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
    brightness: true
    effect_list: [flash, close effect]
```
