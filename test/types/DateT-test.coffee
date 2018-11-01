{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  DateT
} = RC::

describe 'DateT', ->
  describe 'checking date', ->
    it 'check new Date()', ->
      expect ->
        DateT new Date()
      .to.not.throw TypeError
  describe 'throw when check not date', ->
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        DateT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        DateT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        DateT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        DateT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        DateT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        DateT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        DateT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        DateT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        DateT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        DateT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        DateT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        DateT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        DateT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        DateT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        DateT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        DateT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        DateT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        DateT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        DateT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        DateT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        DateT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        DateT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        DateT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        DateT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        DateT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        DateT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        DateT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        DateT new Readable()
        DateT new Writable()
        DateT new Duplex()
        DateT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        DateT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        DateT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check error', ->
      expect ->
        DateT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        DateT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        DateT new Cucumber
      .to.throw TypeError
