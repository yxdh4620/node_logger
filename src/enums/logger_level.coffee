# Debugging levels
ERROR = 3
WARN = 2
INFO = 1
LOG = 0

# A list of debugging levels
LEVELS = ["log", "info", "warn", "error"]

NAME_TAG =
  "log": "LOG -"
  "info": "\u001b[32mINFO\u001b[0m -"
  "warn": "\u001b[33mWARNING\u001b[0m -"
  "error": "\u001b[31mERROR\u001b[0m -"

# 更新日志位置的时间间隔（4小时）
ROTATION_INTERVAL = 4 * 60 * 60 * 1000
# 刷新日志的间隔（5秒钟）
FLUSH_INTERVAL = 5 * 1000

module.exports =
  ERROR: ERROR
  WARN: WARN
  INFO: INFO
  LOG: LOG

  LEVELS: LEVELS
  NAME_TAG: NAME_TAG

  ROTATION_INTERVAL: ROTATION_INTERVAL
  FLUSH_INTERVAL: FLUSH_INTERVAL

  # Empty function
  NOOP_FN: ->
