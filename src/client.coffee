request = require 'request'
_ = require 'underscore'

module.exports = class Client
  constructor: (@endpoint, @options = {}) ->
    @endpoint = @_cleanEndpoint(@endpoint)
    throw new Error("Endpoint required") unless endpoint && endpoint.length > 0
    
    _.defaults @options, 
            maxCacheItems: 1000
            maxTokenCache: 60 * 10
            bearerToken: null # If present will be added to the request header as a 
                              # bearer token (using current draft)
            headers: {}
    @cache = {}
    
  validate: (token,cb) => 
    @.get "#{@endpoint}/#{id}", (err,body, statusCode) =>
      return cb err if err
      
      result =
        isValid : body.actor && body.actorId && body.expiresIn
        actor : body.actor || {}
        expiresIn : body.expiresIn || 0
        scopes : body.scopes || []
      
      cb null,result

  _cleanEndpoint: (endpoint) =>
    return null unless endpoint
    endpoint.replace /\/+$/, ""
    

  _handleResult: (res, bodyBeforeJson, callback) =>
      return callback new Error("Forbidden") if res.statusCode is 401 or res.statusCode is 403
      
      body = null
      
      if bodyBeforeJson and bodyBeforeJson.length > 0
        try
          body = JSON.parse(bodyBeforeJson)
        catch e
          return callback( new Error("Invalid Body Content"),bodyBeforeJson,res.statusCode)
        
      return callback(new Error(body.message)) unless res.statusCode >= 200 && res.statusCode < 300
      callback null, body, res.statusCode

  get: (path, callback) =>
    headers = 
      'Content-Type': 'application/json'

    headers['authorization'] = "Bearer #{@options.bearerToken}" if @options.bearerToken
    
    _.extend headers, @options.headers
    
    request
      uri: path
      headers: headers
      method: 'GET'
     ,(err, res, body) =>
      return callback(err) if err
      @_handleResult res, body, callback

