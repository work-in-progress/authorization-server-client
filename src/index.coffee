_ = require 'underscore'

require('pkginfo')(module,'version')

Client = require('./client')

module.exports = 
  Client: Client
  client: (endpoint,options = {}) ->
    new Client endpoint,options
    