fs = require 'fs'
_ = require 'underscore'
async = require 'async'
nock = require 'nock'

class Helper
  testUrl: "http://someservice.com"
  testPath: "/v1/token-infos"
  testEndpoint: "http://someservice.com/v1/token-infos"
      
  fixturePath: (fileName) =>
    "#{__dirname}/../fixtures/#{fileName}"

  tmpPath: (fileName) =>
    "#{__dirname}/../tmp/#{fileName}"

  cleanTmpFiles: (fileNames) =>
    for file in fileNames
      try
        fs.unlinkSync @tmpPath(file)
      catch ignore

  loadJsonFixture: (fixtureName) =>
    data = fs.readFileSync @fixturePath(fixtureName), "utf-8"
    JSON.parse data


  setupRequestMock : (cb) =>
    goodTokenResult =
      actor :
        actorId : "1234"
      scopes : ["read","write"]
      isValid : true
      expiresIn : 9876
      
    scope = nock(@testUrl)
                    .defaultReplyHeaders('Content-Type': 'application/json')
                    .get("#{@testPath}/goodtoken")
                    .reply(200, JSON.stringify(goodTokenResult))
                    .get("#{@testPath}/badtoken")
                    .reply(404, null)
                    
    return cb(null) # Stupid cleaner not working, bypassing
      
  start: (obj = {}, done) =>
    _.defaults obj, {setupRequestMock : true  }
    obj.setupRequestMock = true if obj.setupRequestMock

    stuff = []

    if obj.setupRequestMock
      stuff.push (cb) => 
        @setupRequestMock(cb)
    
    async.series stuff, () => done()
    
        
  stop: (done) =>
    # Should probably drop database here
    done()

module.exports = new Helper()

