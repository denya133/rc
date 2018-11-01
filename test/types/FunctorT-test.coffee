{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  FunctorT
  FuncG
  AsyncFuncG
} = RC::

describe 'FunctorT', ->
  describe 'checking FunctorT', ->
    it 'check type of func (String, Number) => Object', ->
      expect ->
        FunctorT FuncG [String, Number], Object
      .to.not.throw TypeError
    it 'check type of async (String, Number) => Object', ->
      expect ->
        FunctorT AsyncFuncG [String, Number], Object
      .to.not.throw TypeError
  describe 'throw when check not FunctorT', ->
    it 'throw when check new Error', ->
      expect ->
        FunctorT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        FunctorT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        FunctorT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        FunctorT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        FunctorT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        FunctorT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        FunctorT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        FunctorT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        FunctorT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        FunctorT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        FunctorT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        FunctorT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        FunctorT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        FunctorT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        FunctorT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        FunctorT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        FunctorT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        FunctorT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        FunctorT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        FunctorT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        FunctorT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        FunctorT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        FunctorT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        FunctorT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        FunctorT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        FunctorT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        FunctorT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        FunctorT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        FunctorT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        FunctorT new Readable()
        FunctorT new Writable()
        FunctorT new Duplex()
        FunctorT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        FunctorT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        FunctorT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        FunctorT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        FunctorT new Cucumber
      .to.throw TypeError
