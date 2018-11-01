{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  IntegerT
} = RC::

describe 'IntegerT', ->
  describe 'checking integer', ->
    it 'check number', ->
      expect ->
        IntegerT 1
      .to.not.throw TypeError
    it 'check new Number', ->
      expect ->
        IntegerT new Number 10
      .to.not.throw TypeError
    it 'check Number 11', ->
      expect ->
        IntegerT Number 11
      .to.not.throw TypeError
  describe 'throw when check not integer', ->
    it 'throw when check new Error', ->
      expect ->
        IntegerT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        IntegerT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        IntegerT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        IntegerT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        IntegerT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        IntegerT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        IntegerT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        IntegerT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        IntegerT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        IntegerT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        IntegerT undefined
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        IntegerT 1/6
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        IntegerT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        IntegerT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        IntegerT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        IntegerT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        IntegerT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        IntegerT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        IntegerT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        IntegerT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        IntegerT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        IntegerT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        IntegerT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        IntegerT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        IntegerT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        IntegerT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        IntegerT new Readable()
        IntegerT new Writable()
        IntegerT new Duplex()
        IntegerT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        IntegerT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        IntegerT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        IntegerT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        IntegerT new Cucumber
      .to.throw TypeError
