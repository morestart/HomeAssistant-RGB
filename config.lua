local module = {}
module.ID = node.chipid()
module.HOST = "192.168.0.102"
module.PORT = 1883
module.USER = "ctl"
module.PWD = "971603"
module.ENDPOINT = "/nodemcu/"
module.DELAY = 1000
module.DHTPIN = 5
moudle.LEDNUM = 20

return module
