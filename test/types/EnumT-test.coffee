{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  EnumT
  EnumG
} = RC::

describe 'EnumT', ->
  describe 'checking EnumT', ->
    it 'check type of enum 1 | 2 | 3', ->
      expect ->
        EnumT EnumG [1, 2, 3]
      .to.not.throw TypeError
  describe 'throw when check not EnumT', ->
    it 'throw when check new Error', ->
      expect ->
        EnumT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        EnumT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        EnumT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        EnumT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        EnumT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        EnumT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        EnumT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        EnumT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        EnumT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        EnumT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        EnumT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        EnumT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        EnumT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        EnumT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        EnumT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        EnumT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        EnumT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        EnumT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        EnumT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        EnumT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        EnumT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        EnumT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        EnumT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        EnumT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        EnumT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        EnumT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        EnumT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        EnumT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        EnumT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        EnumT new Readable()
        EnumT new Writable()
        EnumT new Duplex()
        EnumT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        EnumT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        EnumT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        EnumT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        EnumT new Cucumber
      .to.throw TypeError
