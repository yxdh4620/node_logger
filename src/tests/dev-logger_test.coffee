#require 'mocha'
#should = require('chai').should()
should = require "should"
path = require 'path'
os = require 'os'
Logger = require "../dev-logger"

logger = null

describe "this is a test", ()->

  before (done) ->
    console.dir Logger
    #console.log "log : #{Logger.LOG}"
    options =
      isDebug : true
      level : Logger.LOG
      path = DOWNLOAD_TEMP_DIR = path.join os.tmpdir(), "node-logger-test"
      #resetInterval = options.resetInterval
      #flushInterval = options.flushInterval

    logger = new Logger(options)
    console.dir logger
    done()

  it "logger.log", (done) ->
    logger.log "Logger.log aaaa "
    #console.dir logger._cache['log']
    done()

