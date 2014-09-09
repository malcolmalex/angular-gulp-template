###
-----------------------------------
  Express Server setup
-----------------------------------
###
express = require 'express'

# Configuration
EXPRESS_PORT = 4000

# default livereload port is 35729
LIVERELOAD_PORT = 35729   

livereload = require('connect-livereload')

# TODO: Handle the movement of config files more gracefully
EXPRESS_ROOT = __dirname + '/../../agt-build'

module.exports =
  startExpress: ->
    console.log "Configuring Express"

    app = express()
    app.use livereload {port: LIVERELOAD_PORT }
    app.use express.static EXPRESS_ROOT
    app.listen EXPRESS_PORT

    setupProxyAPIs app

setupProxyAPIs = (app) ->

  # Import JSON objects from .json files
  books = require __dirname + '/../data/books'
  todos = require __dirname + '/../data/todos'
  chartExampleData = require __dirname + '/../data/chartExampleData'

  # Define URIs for the imported objects, and serve them
  # TODO: Doc: note that if you change the json stub data, you need to
  # restart the server at the moment
  app.get '/books', (req, res) ->
    res.json books

  app.get '/todos', (req, res) ->
    res.json todos

  app.get '/chartData', (req, res) ->
    res.json chartExampleData

