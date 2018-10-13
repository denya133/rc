{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  BooleanT
} = RC::

describe 'BooleanT', ->
  describe 'checking boolean', ->
    it 'check true boolean', ->
      expect ->
        BooleanT yes
      .to.not.throw TypeError
    it 'check false boolean', ->
      expect ->
        BooleanT no
      .to.not.throw TypeError
    it 'check new Boolean no', ->
      expect ->
        BooleanT new Boolean no
      .to.not.throw TypeError
    it 'check Boolean yes', ->
      expect ->
        BooleanT Boolean yes
      .to.not.throw TypeError
  describe 'throw when check not boolean', ->
    it 'throw when check plain array', ->
      expect ->
        BooleanT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        BooleanT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        BooleanT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        BooleanT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        BooleanT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        BooleanT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        BooleanT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        BooleanT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        BooleanT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        BooleanT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        BooleanT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        BooleanT String 'string'
      .to.throw TypeError
    it 'throw when check date', ->
      expect ->
        BooleanT new Date()
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        BooleanT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        BooleanT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        BooleanT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        BooleanT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        BooleanT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        BooleanT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        BooleanT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        BooleanT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        BooleanT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        BooleanT new Map()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        BooleanT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        BooleanT new Readable()
        BooleanT new Writable()
        BooleanT new Duplex()
        BooleanT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        BooleanT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        BooleanT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check error', ->
      expect ->
        BooleanT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        BooleanT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        BooleanT new Cucumber
      .to.throw TypeError
