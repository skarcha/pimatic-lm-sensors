module.exports = {
  title: "pimatic-lm-sensors device config schemas"
  LmSensor: {
    title: "LmSensor config options"
    type: "object"
    properties:
      attributes:
        description: "Attributes of the device"
        type: "object"
        properties:
          sensor_name:
            type: "string"
            description: "The name of the sensor showed by sensors program"
          interval:
            type: "number"
            description: "The update interval in ms"
            default: 5000
  }
}
