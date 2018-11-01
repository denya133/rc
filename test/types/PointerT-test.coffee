{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  PointerT
} = RC::

describe 'PointerT', ->
  describe 'checking Pointer', ->
    it 'check string', ->
      expect ->
        PointerT 'string'
      .to.not.throw TypeError
    it 'check empty string', ->
      expect ->
        PointerT ''
      .to.not.throw TypeError
    it 'check new String', ->
      expect ->
        PointerT new String 'string'
      .to.not.throw TypeError
    it 'check String 11', ->
      expect ->
        PointerT String 'string'
      .to.not.throw TypeError
    it 'check symbol', ->
      expect ->
        PointerT Symbol()
      .to.not.throw TypeError
  describe 'throw when check not Pointer', ->
    it 'throw when check new Error', ->
      expect ->
        PointerT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        PointerT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        PointerT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        PointerT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        PointerT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        PointerT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        PointerT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        PointerT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        PointerT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        PointerT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        PointerT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        PointerT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        PointerT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        PointerT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        PointerT Number 11
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        PointerT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        PointerT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        PointerT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        PointerT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        PointerT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        PointerT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        PointerT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        PointerT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        PointerT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        PointerT new Readable()
        PointerT new Writable()
        PointerT new Duplex()
        PointerT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        PointerT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        PointerT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        PointerT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        PointerT new Cucumber
      .to.throw TypeError
