
# Debugging levels
ERROR = 3
WARN = 2
INFO = 1
LOG = 0

# Empty function
NOOP_FN = ->

# A list of debugging levels
LEVELS = ["log", "info", "warn", "error"]

PID = "[#{process.pid}]"

NAME_TAG =
  "log": "LOG -"
  "info": "\u001b[32mINFO\u001b[0m -"
  "warn": "\u001b[33mWARNING\u001b[0m -"
  "error": "\u001b[31mERROR\u001b[0m -"

# Local reference of Array join() method
join = Array.prototype.join

# A `Logger` supports basic debugging level controlling
#
# Usage:
#
#   logger = require("./util/logger")
#   logger.setLevel(logger.ERROR)
#   logger.error "msg"
class Logger

  constructor: ->
    @_level = LOG
    @setLevel(@_level)
    @_async()

  # Set debugging level
  setLevel: (level=0) ->
    for method, i in LEVELS
      if i < level then @_defineNoopMethod(method) else @_defineMethod(method)
    @_level = level
    this

  _defineMethod: (name) ->
    tag = NAME_TAG[name]
    @[name] = ->
      console[name](PID, (new Date).toISOString(), tag, join.call(arguments))

  _defineNoopMethod: (name) ->
    @[name] = NOOP_FN

  # 执行一个异步的加载日志的过程
  _async: ->
    @_cache =
      log: []
      info: []
      warn: []
      error: []
    setInterval =>
      for key, value of @_cache
        continue if value.length == 0
        logs = value.join("\r\n")
        console[key](logs)
        value.length = 0   # 清空日志
    , 5 * 1000


# Default logger for all modules
logger = new Logger()
logger.ERROR = ERROR
logger.WARN = WARN
logger.INFO = INFO
logger.LOG = LOG

module.exports = logger
