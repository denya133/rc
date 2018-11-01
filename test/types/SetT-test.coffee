{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  SetT
} = RC::

describe 'SetT', ->
  describe 'checking Set', ->
    it 'check Set', ->
      expect ->
        SetT new Set()
      .to.not.throw TypeError
  describe 'throw when check not Set', ->
    it 'throw when check new Error', ->
      expect ->
        SetT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        SetT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        SetT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        SetT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        SetT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        SetT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        SetT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        SetT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        SetT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        SetT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        SetT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        SetT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        SetT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        SetT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        SetT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        SetT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        SetT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        SetT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        SetT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        SetT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        SetT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        SetT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        SetT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        SetT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        SetT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        SetT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        SetT do -> yield
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        SetT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        SetT new Readable()
        SetT new Writable()
        SetT new Duplex()
        SetT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        SetT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        SetT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        SetT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        SetT new Cucumber
      .to.throw TypeError
