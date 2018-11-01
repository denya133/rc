{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  ClassT
  Module
  CoreObject
} = RC::

describe 'ClassT', ->
  describe 'checking RC::Class', ->
    it 'check instance of RC::Class', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class Tomato extends CoreObject
          @inheritProtected()
          @module TestModule
          @initialize()
        ClassT Tomato
        return
      .to.not.throw TypeError
  describe 'throw when check not RC::Class', ->
    it 'throw when check new Error', ->
      expect ->
        ClassT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        ClassT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        ClassT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        ClassT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        ClassT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        ClassT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        ClassT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        ClassT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        ClassT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        ClassT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        ClassT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        ClassT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        ClassT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        ClassT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        ClassT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        ClassT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        ClassT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        ClassT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        ClassT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        ClassT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        ClassT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        ClassT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        ClassT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        ClassT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        ClassT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        ClassT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        ClassT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        ClassT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        ClassT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        ClassT new Readable()
        ClassT new Writable()
        ClassT new Duplex()
        ClassT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        ClassT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        ClassT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        ClassT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        ClassT new Cucumber
      .to.throw TypeError
