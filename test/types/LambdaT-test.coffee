{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  LambdaT
} = RC::

describe 'LambdaT', ->
  describe 'checking function', ->
    it 'check function', ->
      expect ->
        LambdaT ->
      .to.not.throw TypeError
    it 'check generator function', ->
      expect ->
        LambdaT -> yield
      .to.not.throw TypeError
    it 'check class', ->
      expect ->
        LambdaT class Cucumber
      .to.not.throw TypeError
  describe 'throw when check not function', ->
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        LambdaT new EventEmitter()
      .to.throw TypeError
    it 'throw when check new Error', ->
      expect ->
        LambdaT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        LambdaT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        LambdaT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        LambdaT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        LambdaT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        LambdaT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        LambdaT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        LambdaT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        LambdaT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        LambdaT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        LambdaT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        LambdaT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        LambdaT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        LambdaT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        LambdaT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        LambdaT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        LambdaT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        LambdaT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        LambdaT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        LambdaT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        LambdaT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        LambdaT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        LambdaT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        LambdaT Object({})
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        LambdaT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        LambdaT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        LambdaT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        LambdaT new Readable()
        LambdaT new Writable()
        LambdaT new Duplex()
        LambdaT new Transform()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        LambdaT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        LambdaT new Cucumber
      .to.throw TypeError
