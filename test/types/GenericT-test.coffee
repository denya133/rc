{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  GenericT
  Generic
} = RC::

describe 'GenericT', ->
  describe 'checking GenericT', ->
    it 'check Generic(String, Function) => TypeT', ->
      expect ->
        GenericT Generic 'PromiseG', (ValueT)-> (value, path)->
          return value.then (data)->
            throw new Error 'Invalid' unless ValueT.is value
            return data
      .to.not.throw TypeError
  describe 'throw when check not GenericT', ->
    it 'throw when check new Error', ->
      expect ->
        GenericT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        GenericT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        GenericT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        GenericT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        GenericT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        GenericT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        GenericT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        GenericT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        GenericT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        GenericT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        GenericT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        GenericT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        GenericT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        GenericT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        GenericT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        GenericT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        GenericT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        GenericT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        GenericT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        GenericT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        GenericT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        GenericT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        GenericT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        GenericT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        GenericT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        GenericT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        GenericT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        GenericT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        GenericT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        GenericT new Readable()
        GenericT new Writable()
        GenericT new Duplex()
        GenericT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        GenericT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        GenericT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        GenericT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        GenericT new Cucumber
      .to.throw TypeError
