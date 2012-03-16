(function() {
  var Client, request, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  request = require('request');

  _ = require('underscore');

  module.exports = Client = (function() {

    function Client(endpoint, options) {
      this.endpoint = endpoint;
      this.options = options != null ? options : {};
      this.get = __bind(this.get, this);
      this._handleResult = __bind(this._handleResult, this);
      this._cleanEndpoint = __bind(this._cleanEndpoint, this);
      this.validate = __bind(this.validate, this);
      this.endpoint = this._cleanEndpoint(this.endpoint);
      if (!(endpoint && endpoint.length > 0)) throw new Error("Endpoint required");
      _.defaults(this.options, {
        maxCacheItems: 1000,
        maxTokenCache: 60 * 10,
        bearerToken: null,
        headers: {}
      });
      this.cache = {};
    }

    Client.prototype.validate = function(token, cb) {
      var _this = this;
      return this.get("" + this.endpoint + "/" + id, function(err, body, statusCode) {
        var result;
        if (err) return cb(err);
        result = {
          isValid: body.actor && body.actorId && body.expiresIn,
          actor: body.actor || {},
          expiresIn: body.expiresIn || 0,
          scopes: body.scopes || []
        };
        return cb(null, result);
      });
    };

    Client.prototype._cleanEndpoint = function(endpoint) {
      if (!endpoint) return null;
      return endpoint.replace(/\/+$/, "");
    };

    Client.prototype._handleResult = function(res, bodyBeforeJson, callback) {
      var body;
      if (res.statusCode === 401 || res.statusCode === 403) {
        return callback(new Error("Forbidden"));
      }
      body = null;
      if (bodyBeforeJson && bodyBeforeJson.length > 0) {
        try {
          body = JSON.parse(bodyBeforeJson);
        } catch (e) {
          return callback(new Error("Invalid Body Content"), bodyBeforeJson, res.statusCode);
        }
      }
      if (!(res.statusCode >= 200 && res.statusCode < 300)) {
        return callback(new Error(body.message));
      }
      return callback(null, body, res.statusCode);
    };

    Client.prototype.get = function(path, callback) {
      var headers,
        _this = this;
      headers = {
        'Content-Type': 'application/json'
      };
      if (this.options.bearerToken) {
        headers['authorization'] = "Bearer " + this.options.bearerToken;
      }
      _.extend(headers, this.options.headers);
      return request({
        uri: path,
        headers: headers,
        method: 'GET'
      }, function(err, res, body) {
        if (err) return callback(err);
        return _this._handleResult(res, body, callback);
      });
    };

    return Client;

  })();

}).call(this);
