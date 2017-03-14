{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
NativePromise = global.Promise
NativeSetTimeout = global.setTimeout
{ co, readFile: read, setTimeout: customSetTimeout } = RC::Utils


clock = null
cleanNativePromise = ->
  global.Promise = undefined
  global.setTimeout = customSetTimeout
restoreNativePromise = ->
  global.Promise = NativePromise
  global.setTimeout = NativeSetTimeout

context = some: 'thing'

sleep = (ms) ->
  (done) ->
    setTimeout done, ms
    return

work = ->
  yield sleep 50
  return 'yay'

class Pet
  constructor: (name) ->
    @name = name
  something: ->

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
        assert.equal res.length, 0
        return
    it 'should support an array of generators', ->
      co ->
        val = yield [ do -> 1 ]
        assert.deepEqual val, [ 1 ]
        return
    return
  describe 'co.call(this)', ->
    beforeEach cleanNativePromise
    afterEach restoreNativePromise
    it 'should pass the context', ->
      co.call context, ->
        assert.equal context, @
        return
    return
  describe 'co(fn*)', ->
    describe 'with a generator function', ->
      beforeEach cleanNativePromise
      afterEach restoreNativePromise
      it 'should wrap with co()', ->
        co ->
          a = yield work
          b = yield work
          c = yield work
          assert.equal a, 'yay'
          assert.equal b, 'yay'
          assert.equal c, 'yay'
          res = yield [ work, work, work ]
          assert.deepEqual res, [ 'yay', 'yay', 'yay' ]
      it 'should catch errors', ->
        co ->
          yield ->
            throw new Error 'boom'
            yield return
          return
        .then ->
          throw new Error 'wtf'
        .catch (err) ->
          assert.instanceOf err, Error
          assert.equal err.message, 'boom'
          return
    return
  describe 'yield <invalid>', ->
    beforeEach cleanNativePromise
    afterEach restoreNativePromise
    it 'should throw an error', ->
      co ->
        try
          yield null
          throw new Error 'lol'
        catch err
          assert.instanceOf err, TypeError
          assert.include err.message, 'You may only yield'
        return
    return
  describe 'co(* -> yield {})', ->
    beforeEach cleanNativePromise
    afterEach restoreNativePromise
    it 'should aggregate several promises', ->
      co ->
        a = read __dirname + '/../../lib/index.coffee'
        b = read __dirname + '/../../LICENSE'
        c = read __dirname + '/../../package.json'
        res = yield { a, b, c }
        assert.equal Object.keys(res).length, 3
        assert.include res.a, 'exports'
        assert.include res.b, 'Apache'
        assert.include res.c, 'devDependencies'
        return
    it 'should noop with no args', ->
      co ->
        res = yield {}
        assert.equal Object.keys(res).length, 0
        return
    it 'should ignore non-thunkable properties', ->
      co ->
        foo =
          name: first: 'tobi'
          age: 2
          address: read __dirname + '/../../lib/index.coffee'
          tobi: new Pet 'tobi'
          now: new Date()
          falsey: no
          nully: null
          undefinely: undefined
        res = yield foo
        assert.equal res.name.first, 'tobi'
        assert.equal res.age, 2
        assert.equal res.tobi.name, 'tobi'
        assert.equal res.name.first, 'tobi'
        assert.equal res.now, foo.now
        assert.equal res.falsey, no
        assert.equal res.nully, null
        assert.equal res.undefinely, undefined
        assert.include "#{res.address}", 'exports'
        return
    it 'should preserve key order', ->
      co ->
        before =
          sun: sleep 30
          rain: sleep 20
          moon: sleep 10
        after = yield before
        orderBefore = Object.keys(before).join ','
        orderAfter = Object.keys(after).join ','
        assert.equal orderBefore, orderAfter
        return
    return
