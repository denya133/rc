{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  MapT
} = RC::

describe 'MapT', ->
  describe 'checking Map', ->
    it 'check Map', ->
      expect ->
        MapT new Map()
      .to.not.throw TypeError
  describe 'throw when check not Map', ->
    it 'throw when check new Error', ->
      expect ->
        MapT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        MapT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        MapT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        MapT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        MapT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        MapT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        MapT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        MapT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        MapT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        MapT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        MapT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        MapT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        MapT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        MapT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        MapT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        MapT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        MapT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        MapT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        MapT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        MapT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        MapT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        MapT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        MapT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        MapT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        MapT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        MapT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        MapT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        MapT new Set()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        MapT new Readable()
        MapT new Writable()
        MapT new Duplex()
        MapT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        MapT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        MapT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        MapT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        MapT new Cucumber
      .to.throw TypeError
