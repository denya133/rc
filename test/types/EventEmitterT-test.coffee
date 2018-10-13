{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  EventEmitterT
} = RC::

describe 'EventEmitterT', ->
  describe 'checking EventEmitter', ->
    it 'check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        EventEmitterT new EventEmitter()
      .to.not.throw TypeError
    it 'check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        EventEmitterT new Readable()
        EventEmitterT new Writable()
        EventEmitterT new Duplex()
        EventEmitterT new Transform()
      .to.not.throw TypeError
  describe 'throw when check not EventEmitter', ->
    it 'throw when check new Error', ->
      expect ->
        EventEmitterT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        EventEmitterT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        EventEmitterT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        EventEmitterT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        EventEmitterT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        EventEmitterT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        EventEmitterT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        EventEmitterT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        EventEmitterT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        EventEmitterT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        EventEmitterT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        EventEmitterT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        EventEmitterT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        EventEmitterT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        EventEmitterT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        EventEmitterT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        EventEmitterT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        EventEmitterT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        EventEmitterT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        EventEmitterT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        EventEmitterT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        EventEmitterT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        EventEmitterT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        EventEmitterT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        EventEmitterT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        EventEmitterT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        EventEmitterT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        EventEmitterT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        EventEmitterT new Map()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        EventEmitterT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        EventEmitterT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        EventEmitterT new Cucumber
      .to.throw TypeError
