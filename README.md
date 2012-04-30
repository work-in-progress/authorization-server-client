## About authorization-server-client

Client to access an authorization server for oauth2 token validation in a distributed environment.

In an oauth2 scenario it is quite likely that your authorization server is not the same as your
resource server. In this case the resource server needs to be able to validate tokens against the
authorization server. There are several ways to do this. One is to use public/private key encrypted long token that contains all the relevant information as part of the token. This requires
sharing keys between authorization server and resource server. While fast this suffers 2 drawbacks: Long tokens and the necessity to work with very short lived tokens.

Another approach is to have the resource server contact the authorization server and ask the 
authorization server to validate a token. This is the path taken by this module, which implements the client side. An authorization server needs to implement an endpoint (for example /v1/token-infos/:token) that returns either a 404 (there is no valid token info for the token) or a 200 with the following format:

	actor:
		actorId (string uniquely identifying the actor)
		... additional actor information, optional
	scopes: ["scope1",...] (An array of scopes)
	expiresIn: 1234  (number of seconds this token is still valid)

## NOTE

Caching is not yet enabled.

## Install

npm install authorization-server-client



## Usage (Coffeescript)
  
	authorizationServerClient = require 'authorization-server-client'
	client = authorizationServerClient.client "https://yourauthorizationserver.com/v1/token-infos",
						maxTokenCache: 60 * 10 # Number of seconds a token is kept in a local cache. Keep this rather short.
		
		
	client.validate tokenToValidate, (err,result) =>
		# err is set if something happened that was unexpected, including an unreachable client. 
		# It is probably a good idea to return a 502 (bad gateway) if an err is present
		# If err is not set, then result contains the following:
		# isValid: true/false
		# if it is valid in addition 
		# actor: 
		#   actorId
		#   ...
		# expiresIn: 13324
		# scopes: []

## Advertising :)

Check out 

* http://scottyapp.com

Follow us on Twitter at 

* @getscottyapp
* @martin_sunset

and like us on Facebook please. Every mention is welcome and we follow back.


## Release Notes


### 0.0.1

* First version

## Internal Stuff

* npm run-script watch

## Publish new version

* git tag -a v0.0.3 -m 'version 0.0.3'
* git push --tags
* npm publish
* update version in package.json and here

## Contributing to authorization-server-client
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the package.json, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 ScottyApp, Inc. See LICENSE for
further details.


