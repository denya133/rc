{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
NativePromise = global.Promise
Promise = RC::Promise

cleanNativePromise = -> global.Promise = undefined
restoreNativePromise = -> global.Promise = NativePromise

describe 'Promise', ->
  describe '.new', ->
    beforeEach cleanNativePromise
    afterEach restoreNativePromise
    it 'should create new promise (resolving)', ->
      Promise.new (resolve, reject) ->
        resolve 'RESOLVE'
      .then (value) ->
        assert.equal value, 'RESOLVE'
    it 'should create new promise (rejecting)', ->
      Promise.new (resolve, reject) ->
        reject new Error 'REJECT'
      .catch (err) ->
        assert.instanceOf err, Error
  describe '#then', ->
    beforeEach cleanNativePromise
    afterEach restoreNativePromise
    it 'should call `test` 4 times', ->
      test = sinon.spy ->
      Promise.new (resolve, reject) ->
        resolve 'RESOLVE'
      .then test
      .then test
      .then test
      .then test
      .then ->
        assert.equal test.callCount, 4, 'Not every `test` called'
    it 'should call `test` 2 times and then fall with error', ->
      test = sinon.spy ->
      Promise.new (resolve, reject) ->
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
      Promise.new (resolve, reject) ->
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
    beforeEach cleanNativePromise
    afterEach restoreNativePromise
    it 'should call fail immediately', ->
      test = sinon.spy ->
      Promise.new (resolve, reject) ->
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
    beforeEach cleanNativePromise
    afterEach restoreNativePromise
    it 'should create resolve promise', ->
      Promise.resolve 'TEST'
      .then (value) ->
        assert.equal value, 'TEST', 'No resolved value'
    it 'should create resolve promise without object', ->
      Promise.resolve()
      .then (value) ->
        assert.isUndefined value
  describe '.reject', ->
    beforeEach cleanNativePromise
    afterEach restoreNativePromise
    it 'should create reject promise', ->
      test = sinon.spy (err) -> assert.instanceOf err, Error
      Promise.reject new Error 'TEST'
      .catch test
      .then (value) ->
        assert test.called, '`test` not called'
    it 'should create reject promise without error object', ->
      test = sinon.spy (err) ->
      Promise.reject()
      .catch test
      .then (value) ->
        assert test.called, '`test` not called'
    it 'should return reject promise in promise chain', ->
      test = sinon.spy (err) ->
      Promise.resolve()
      .then ->
        Promise.reject()
      .catch test
      .then (value) ->
        assert test.called, '`test` not called'
  describe '.all', ->
    beforeEach cleanNativePromise
    afterEach restoreNativePromise
    it 'should resolve list of promises', ->
      test = sinon.spy ->
      COUNT = 10
      promises = for i in [1 .. COUNT]
        Promise.resolve().then test
      Promise.all promises
      .then (value) ->
        assert.equal test.callCount, COUNT, '`test` not called enough'
    it 'should resolve list of promises with exception in last one', ->
      test = sinon.spy ->
      COUNT = 9
      promises = for i in [1 .. COUNT]
        Promise.resolve().then test
      promises.push Promise.reject(new Error).then test
      Promise.all promises
      .catch (err) ->
        assert.instanceOf err, Error
      .then (value) ->
        assert.equal test.callCount, COUNT, '`test` not called enough'
