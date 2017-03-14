{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
NativePromise = global.Promise
{ co, readFile: read } = RC::Utils

cleanNativePromise = -> global.Promise = undefined
restoreNativePromise = -> global.Promise = NativePromise

describe 'RC::Utils.co', ->
  describe 'co(gen, args)', ->
    beforeEach cleanNativePromise
    afterEach restoreNativePromise
    it 'should pass the rest of the arguments', ->
      co (num, str, arr, obj, fun) ->
        assert.equal num,  42
        assert.equal str, 'forty-two'
        assert.equal arr[0], 42
        assert.equal obj.value, 42
        assert.instanceOf fun, Function
        return
      , 42, 'forty-two', [ 42 ], { value: 42 }, ->
    return
  describe 'co(* -> yield [])', ->
    beforeEach cleanNativePromise
    afterEach restoreNativePromise
    it 'should aggregate several promises', ->
      co ->
        a = read __dirname + '/../../lib/index.coffee'
        b = read __dirname + '/../../LICENSE'
        c = read __dirname + '/../../package.json'
        res = yield [ a, b, c ]
        assert.equal 3, res.length
        assert.include res[0], 'exports'
        assert.include res[1], 'Apache'
        assert.include res[2], 'devDependencies'
        return
    it 'should noop with no args', ->
      co ->
        res = yield []
        assert.equal 0, res.length
        return
    it 'should support an array of generators', ->
      co ->
        val = yield [ do -> 1 ]
        assert.deepEqual val, [ 1 ]
        return
    return
