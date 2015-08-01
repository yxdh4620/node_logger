## Module dependencies
fs = require "fs"
util = require "util"
LoggerLevel = require './enums/logger_level'

PID = "[#{process.pid}]"


# A `Logger` supports basic debugging level controlling
#
# Usage:
#
#   logger = require("./util/logger")
#   logger.setLevel(logger.ERROR)
#   logger.error "msg"
class Logger

  constructor: (options={}) ->
    @_isDebug = options.isDebug || false
    @_level = options.level || LoggerLevel.LOG
    @_path = options.level
    @_resetInterval = options.resetInterval
    @_flushInterval = options.flushInterval
    @setLevel @_level
    @setPath @_path
    @_cache = {}
    for key in LoggerLevel.LEVELS
      @_cache[key] = []
    #@_async()

  # 执行一个异步的加载日志的过程
  _async: ->
    @_flushInterval = setInterval =>
      for key, value of @_cache
        continue if value.length == 0
        logs = value.join("")
        if @_flushLog(key, logs)
          value.length = 0
    , 5 * 1000

  # Set log path
  setPath: (path) ->
    if path
      @_path = path
      @_resetStream()
      unless @_resetInterval
        @_resetInterval = setInterval (=> @_resetStream()), ROTATION_INTERVAL
      @_flushLog = @_flushLogToFile
    else
      @_flushLog = @_flushLogToConsole
    this

  # Set debugging level
  setLevel: (level=0) ->
    for method, i in LoggerLevel.LEVELS
      if i < level then @_defineNoopMethod(method) else @_defineMethod(method)
    @_level = level
    this

  _defineMethod: (name) ->
    tag = LoggerLevel.NAME_TAG[name]
    if @_isDebug
      # 如果是在调试环境下，实时输出日志
      @[name] = ->
        console[name](PID, (new Date).toLocaleString(), tag, util.format.apply(null, arguments))
    else
      # 如果在生产环境下，异步输出日志
      @[name] = =>
        @_cache[name].push "#{PID} #{new Date().toLocaleString()} #{tag} #{util.format.apply(null, arguments)}\r\n"
        return

  _defineNoopMethod: (name) ->
    @[name] = NOOP_FN


  # 把日志写入文件
  _flushLogToFile: (level, logs) ->
    # 如果写入的文件不可用的话，输出日志到 Console
    unless @_stream and @_stream.writable
      @_flushLogToConsole(level, logs)
      return true
    @_stream.write logs
    return true

  # 把日志输出到 Console
  _flushLogToConsole: (level, logs) ->
    console[level](logs)
    return true

  # 重置文件句柄
  _resetStream: ->
    return unless @_path
    today = new Date()
    year = "#{today.getFullYear()}"
    month = "#{today.getMonth() + 1}"
    month = "0#{month}" unless month[1]
    day = "#{today.getDate()}"
    day = "0#{day}" unless day[1]
    logPath = @_path
      .replace("%Y", year)
      .replace("%m", month)
      .replace("%d", day)
      # .replace("%t", today.toLocaleTimeString())
    # 仅当日志路径发生变化时才重置日志文件
    return if logPath == @_realPath
    @_realPath = logPath
    options =
      flags: 'a'
      encoding: 'utf-8'
      mode: '0644'
    # 关闭之前的 Stream
    if @_stream
      try
        @_stream.destroySoon()
      catch error
        @error "[logger:_resetStream] Failed to close stream. Error: #{error}"
    try
      @_stream = fs.createWriteStream logPath, options
      logger.info "[logger:_resetStream] Rotate to new log path: #{logPath}"
    catch error
      @error "[logger:_resetStream] Failed to create stream. Error: #{error}"
      @_stream = null
    return

# Default logger for all modules
#logger = new Logger()
#logger.ERROR = ERROR
#logger.WARN = WARN
#logger.INFO = INFO
#logger.LOG = LOG
#
#
#module.exports = logger

Logger.ERROR = LoggerLevel.ERROR
Logger.WARN = LoggerLevel.WARN
Logger.INFO = LoggerLevel.INFO
Logger.LOG = LoggerLevel.LOG

module.exports = Logger


