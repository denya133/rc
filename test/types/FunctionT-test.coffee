{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  FunctionT
} = RC::

describe 'FunctionT', ->
  describe 'checking function', ->
    it 'check function', ->
      expect ->
        FunctionT ->
      .to.not.throw TypeError
    it 'check generator function', ->
      expect ->
        FunctionT -> yield
      .to.not.throw TypeError
    it 'check class', ->
      expect ->
        FunctionT class Cucumber
      .to.not.throw TypeError
  describe 'throw when check not function', ->
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        FunctionT new EventEmitter()
      .to.throw TypeError
    it 'throw when check new Error', ->
      expect ->
        FunctionT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        FunctionT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        FunctionT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        FunctionT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        FunctionT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        FunctionT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        FunctionT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        FunctionT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        FunctionT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        FunctionT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        FunctionT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        FunctionT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        FunctionT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        FunctionT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        FunctionT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        FunctionT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        FunctionT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        FunctionT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        FunctionT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        FunctionT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        FunctionT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        FunctionT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        FunctionT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        FunctionT Object({})
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        FunctionT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        FunctionT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        FunctionT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        FunctionT new Readable()
        FunctionT new Writable()
        FunctionT new Duplex()
        FunctionT new Transform()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        FunctionT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        FunctionT new Cucumber
      .to.throw TypeError
