module.exports = (env) ->

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require sensors.js library (https://www.npmjs.com/package/sensors.js).
  sensorsjs = require 'sensors.js'


  class LmSensorsPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("LmSensor", {
        configDef: deviceConfigDef.LmSensor,
        createCallback: (config) => return new LmSensor(config)
      })


  class LmSensor extends env.devices.TemperatureSensor
    temperature: null

    constructor: (@config) ->
      @name = @config.name
      @id = @config.id

      # update the temperature every 'interval' from config, or 5 seconds by
      # default.
      @readDataIntervalId = setInterval( ( =>
        @readNewTemp()
      ), @config.attributes.interval or 5000)

      super()

    destroy: () ->
      clearInterval @readDataIntervalId if @readDataIntervalId?
      super()

    readNewTemp: () ->
      sensorsjs.sensors( (data, error) =>
        newtemp = data[@config.attributes.sensor_name]['PCI adapter'].temp1.value
        if newtemp != @temperature
          @temperature = newtemp
          @emit "temperature", newtemp
      )

    getTemperature: -> Promise.resolve(@temperature)

  # ###Finally
  # Create a instance of my plugin
  lmSensorsPlugin = new LmSensorsPlugin
  # and return it to the framework.
  return lmSensorsPlugin
