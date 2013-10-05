# dev-logger

A logger utility can be easily swiched between dev development and production mode.
This tool supports:
  * built-in log rotation
  * colorized log message
  * 4 log levels and custom log level output
  * caching log messages

## Install
Install the module with:

```bash
npm install dev-logger
```

## Usage
```javascript
var logger = require('dev-logger');
logger.log("normal log message")
logger.warn("warning message")
logger.error(bad error  message")
logger.info("success message")

// output realtime message
logger.isDebug = true

// output cached log message in an interval and turn on log rotation
logger.isDebug = false

// custom log level,  logger.LOG < logger.INFO < logger.WARN  < logger.ERROR
logger.setLevel(logger.INFO);

// custom log output path
logger.setPath(pathToLogFile);

```

## Contributing
mostly written by @wuyuntao

## License
Copyright (c) 2013 yi
Licensed under the MIT license.
