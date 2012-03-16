(function() {
  var Client, _;

  _ = require('underscore');

  require('pkginfo')(module, 'version');

  Client = require('./client');

  module.exports = {
    Client: Client,
    client: function(endpoint, options) {
      if (options == null) options = {};
      return new Client(endpoint, options);
    }
  };

}).call(this);
