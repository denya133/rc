{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  AnyT
} = RC::

describe 'AnyT', ->
  describe 'throw when check Nil', ->
    it 'throw when check null', ->
      expect ->
        AnyT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        AnyT undefined
      .to.throw TypeError
  describe 'checking different values', ->
    it 'check number', ->
      expect ->
        AnyT 1
      .to.not.throw TypeError
    it 'check float', ->
      expect ->
        AnyT 1/6
      .to.not.throw TypeError
    it 'check new Number', ->
      expect ->
        AnyT new Number 10
      .to.not.throw TypeError
    it 'check Number 11', ->
      expect ->
        AnyT Number 11
      .to.not.throw TypeError
    it 'check string', ->
      expect ->
        AnyT 'string'
      .to.not.throw TypeError
    it 'check empty string', ->
      expect ->
        AnyT ''
      .to.not.throw TypeError
    it 'check new String', ->
      expect ->
        AnyT new String 'string'
      .to.not.throw TypeError
    it 'check String 11', ->
      expect ->
        AnyT String 'string'
      .to.not.throw TypeError
    it 'check true boolean', ->
      expect ->
        AnyT yes
      .to.not.throw TypeError
    it 'check false boolean', ->
      expect ->
        AnyT no
      .to.not.throw TypeError
    it 'check new Boolean no', ->
      expect ->
        AnyT new Boolean no
      .to.not.throw TypeError
    it 'check Boolean yes', ->
      expect ->
        AnyT Boolean yes
      .to.not.throw TypeError
    it 'check date', ->
      expect ->
        AnyT new Date()
      .to.not.throw TypeError
    it 'check symbol', ->
      expect ->
        AnyT Symbol()
      .to.not.throw TypeError
    it 'check RegExp', ->
      expect ->
        AnyT new RegExp '.*'
      .to.not.throw TypeError
    it 'check plain object', ->
      expect ->
        AnyT {}
      .to.not.throw TypeError
    it 'check object', ->
      expect ->
        AnyT new Object({})
      .to.not.throw TypeError
    it 'check object casting', ->
      expect ->
        AnyT Object({})
      .to.not.throw TypeError
    it 'check plain array', ->
      expect ->
        AnyT []
      .to.not.throw TypeError
    it 'check array', ->
      expect ->
        AnyT new Array([])
      .to.not.throw TypeError
    it 'check function', ->
      expect ->
        AnyT ->
      .to.not.throw TypeError
    it 'check generator function', ->
      expect ->
        AnyT -> yield
      .to.not.throw TypeError
    it 'check generator', ->
      expect ->
        AnyT do -> yield
      .to.not.throw TypeError
    it 'check Set', ->
      expect ->
        AnyT new Set()
      .to.not.throw TypeError
    it 'check Map', ->
      expect ->
        AnyT new Map()
      .to.not.throw TypeError
    it 'check Buffer.alloc(0)', ->
      expect ->
        AnyT Buffer.alloc(0)
      .to.not.throw TypeError
    it 'check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        AnyT new Readable()
        AnyT new Writable()
        AnyT new Duplex()
        AnyT new Transform()
      .to.not.throw TypeError
    it 'check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        AnyT new EventEmitter()
      .to.not.throw TypeError
    it 'check promise', ->
      expect ->
        AnyT Promise.resolve yes
      .to.not.throw TypeError
    it 'check error', ->
      expect ->
        AnyT new Error 'Error'
        return
      .to.not.throw TypeError
    it 'check class', ->
      expect ->
        AnyT class Cucumber
      .to.not.throw TypeError
    it 'check instance of some class', ->
      expect ->
        class Cucumber
        AnyT new Cucumber
      .to.not.throw TypeError
