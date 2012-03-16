should = require 'should'

helper = require './support/helper'
index = require '../lib/index'

describe 'WHEN working with the plugin', ->
  before (done) ->
    helper.start null, done
  after ( done) ->
    helper.stop done

  describe 'index', ->
    it 'should exist', (done) ->
      should.exist index
      done()

  describe 'client', ->
    it 'should be createable', (done) ->
      should.exist index.client(helper.testEndpoint)
      done()

    it 'should be validate a good request', (done) ->
      client = index.client(helper.testEndpoint)
      client.validate "goodtoken", (err,res) ->
        return done err if err
        should.exist res
        res.should.have.property "isValid",true
        res.should.have.property "actor"
        res.actor.should.have.property "actorId","1234"
        res.should.have.property "scopes"
        res.scopes.should.have.length 2
        res.scopes[0].should.equal "read"
        res.scopes[1].should.equal "write"
        res.should.have.property "expiresIn",9876
        done()

    it 'should be fail on a bad request', (done) ->
      client = index.client(helper.testEndpoint)
      client.validate "badtoken", (err,res) ->
        should.exist err
        should.not.exist res
        done()

