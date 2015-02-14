# #Plugin template

# This is an plugin template and mini tutorial for creating pimatic plugins. It will explain the 
# basics of how the plugin system works and how a plugin should look like.

# ##The plugin code

# Your plugin must export a single function, that takes one argument and returns a instance of
# your plugin class. The parameter is an envirement object containing all pimatic related functions
# and classes. See the [startup.coffee](http://sweetpi.de/pimatic/docs/startup.html) for details.
module.exports = (env) ->

  # ###require modules included in pimatic
  # To require modules that are included in pimatic use `env.require`. For available packages take 
  # a look at the dependencies section in pimatics package.json

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  # Include you own depencies with nodes global require function:
  #  
  #     someThing = require 'someThing'
  #  

  sensorsjs = require 'sensors.js'

  # ###MyPlugin class
  # Create a class that extends the Plugin class and implements the following functions:
  class LmSensorsPlugin extends env.plugins.Plugin

    # ####init()
    # The `init` function is called by the framework to ask your plugin to initialise.
    #  
    # #####params:
    #  * `app` is the [express] instance the framework is using.
    #  * `framework` the framework itself
    #  * `config` the properties the user specified as config for your plugin in the `plugins` 
    #     section of the config.json file 
    #     
    # 
    init: (app, @framework, @config) =>
      deviceConfigDef = require("./device-config-schema")

      env.logger.info("Hello World")

      @framework.deviceManager.registerDeviceClass("LmSensor", {
        configDef: deviceConfigDef.LmSensor,
        createCallback: (config) => return new LmSensor(config)
      })

  class LmSensor extends env.devices.TemperatureSensor
    temperature: null

    constructor: (@config) ->
      @name = config.name
      @id = config.id

      # update the temperature every 5 seconds
      setInterval( ( =>
        @doYourStuff()
      ), config.attributes.interval or 5000)

      super()

    doYourStuff: () ->
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
