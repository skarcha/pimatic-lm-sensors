pimatic-lm-sensors
=======================

A pimatic plugin for [lm-sensors](http://www.lm-sensors.org/).

Example
-------

    {
      "class": "LmSensor",
      "id": "CPUTemp",
      "name": "CPU Temp.",
      "attributes": {
        "sensor_name": "k10temp-pci-00c3",
        "interval": 30000
      }
    }

`sensor_name` is the name of the device returned by `sensors` program. Example:

    $ sensors
    radeon-pci-0008
    Adapter: PCI adapter
    temp1:        +56.0°C  (crit = +120.0°C, hyst = +90.0°C)

    k10temp-pci-00c3
    Adapter: PCI adapter
    temp1:        +56.5°C  (high = +70.0°C)
                           (crit = +100.0°C, hyst = +97.0°C)

`interval` is the "refresh" interval (in milliseconds) between temperature reads. Default: 50000 (5 seconds)
