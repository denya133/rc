{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
NativePromise = global.Promise
EPromise = RC::EPromise

cleanNativePromise = -> global.Promise = undefined
restoreNativePromise = -> global.Promise = NativePromise

describe 'EPromise', ->
  before cleanNativePromise
  after restoreNativePromise
  describe '.new', ->
    it 'should create new promise (resolving)', ->
      EPromise.new (resolve, reject) ->
        console.log '!!!!!!!!!!!!!!!!!'
        resolve 'RESOLVE'
      .then (value) ->
        assert.equal value, 'RESOLVE'
    it 'should create new promise (rejecting)', ->
      EPromise.new (resolve, reject) ->
        reject new Error 'REJECT'
      .catch (err) ->
        assert.instanceOf err, Error
  describe '#then', ->
    it 'should call `test` 4 times', ->
      test = sinon.spy ->
      EPromise.new (resolve, reject) ->
        resolve 'RESOLVE'
      .then test
      .then test
      .then test
      .then test
      .then ->
        assert.equal test.callCount, 4, 'Not every `test` called'
    it 'should call `test` 2 times and then fall with error', ->
      test = sinon.spy ->
      EPromise.new (resolve, reject) ->
        resolve 'RESOLVE'
      .then test
      .then test
      .then ->
        throw new Error 'ERROR'
      .then test
      .then test
      .then null, (err) ->
        assert.equal err.message, 'ERROR', 'No error message'
        assert.equal test.callCount, 2, 'Wrong count of `test` called'
    it 'should call `test` 1 time, then fall with error, and continue 2 times', ->
      test = sinon.spy ->
      EPromise.new (resolve, reject) ->
        resolve 'RESOLVE'
      .then test
      .then ->
        throw new Error 'ERROR'
      .then test
      .then test
      .then null, (err) ->
        assert.equal err.message, 'ERROR', 'No error message'
      .then test
      .then test
      .then ->
        assert.equal test.callCount, 3, 'Wrong count of `test` called'
  describe '#catch', ->
    it 'should call fail immediately', ->
      test = sinon.spy ->
      EPromise.new (resolve, reject) ->
        resolve 'RESOLVE'
      .then ->
        throw new Error 'ERROR'
      .then test
      .then test
      .then test
      .then test
      .catch (err) ->
        assert.equal err.message, 'ERROR', 'No error message'
        assert.isFalse test.called, 'Not every `test` called'
  describe '.resolve', ->
    it 'should create resolve promise', ->
      EPromise.resolve 'TEST'
      .then (value) ->
        assert.equal value, 'TEST', 'No resolved value'
    it 'should create resolve promise without object', ->
      EPromise.resolve()
      .then (value) ->
        assert.isUndefined value
  describe '.reject', ->
    it 'should create reject promise', ->
      test = sinon.spy (err) -> assert.instanceOf err, Error
      EPromise.reject new Error 'TEST'
      .catch test
      .then (value) ->
        assert test.called, '`test` not called'
    it 'should create reject promise without error object', ->
      test = sinon.spy (err) ->
      EPromise.reject()
      .catch test
      .then (value) ->
        assert test.called, '`test` not called'
    it 'should return reject promise in promise chain', ->
      test = sinon.spy (err) ->
      EPromise.resolve()
      .then ->
        EPromise.reject()
      .catch test
      .then (value) ->
        assert test.called, '`test` not called'
  describe '.all', ->
    it 'should resolve list of promises', ->
      test = sinon.spy ->
      COUNT = 10
      promises = for i in [1 .. COUNT]
        EPromise.resolve().then test
      EPromise.all promises
      .then (value) ->
        assert.equal test.callCount, COUNT, '`test` not called enough'
    it 'should resolve list of promises with exception in last one', ->
      test = sinon.spy ->
      COUNT = 99
      promises = for i in [1 .. COUNT]
        EPromise.resolve().then test
      promises.push EPromise.reject(new Error).then test
      EPromise.all promises
      .catch (err) ->
        assert.instanceOf err, Error
      .then (value) ->
        assert.equal test.callCount, COUNT, '`test` not called enough'
