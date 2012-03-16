fs = require 'fs'
_ = require 'underscore'
async = require 'async'

class Helper
      
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

