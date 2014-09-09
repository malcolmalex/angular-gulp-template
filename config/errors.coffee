# Error handling setup
# See: http://www.artandlogic.com/blog/2014/05/error-handling-in-gulp/

fatalLevel = require('yargs').argv.fatal

ERROR_LEVELS = ['error', 'warning']

module.exports =

  # Convenience handlers to be used in gulp .on('error', callback)
  onError: (error) -> handleError.call(this, 'error', error)
  onWarning: (error) -> handleError.call(this, 'warning', error)

# Log error and kill process
handleError = (level, error) ->
  console.log error.message
  console.log "Level: " + level + " isFatal" + isFatal(level)
  process.exit(1) if isFatal(level)

# Determine if the error is fatal. Returns true if the given level is
# equal to or more severe than the given fatality level (via cli arg).
# Defaults to fatality level to error if not set by user or some task default
isFatal = (level) ->
  ERROR_LEVELS.indexOf(level) <= ERROR_LEVELS.indexOf(fatalLevel || 'error')

