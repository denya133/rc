{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  ModuleT
  Module
  CoreObject
} = RC::

describe 'ModuleT', ->
  describe 'checking RC::Module', ->
    it 'check inheritance of RC::Module', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        ModuleT TestModule
        return
      .to.not.throw TypeError
  describe 'throw when check not RC::Module', ->
    it 'throw when check new Error', ->
      expect ->
        ModuleT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        ModuleT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        ModuleT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        ModuleT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        ModuleT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        ModuleT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        ModuleT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        ModuleT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        ModuleT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        ModuleT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        ModuleT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        ModuleT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        ModuleT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        ModuleT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        ModuleT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        ModuleT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        ModuleT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        ModuleT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        ModuleT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        ModuleT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        ModuleT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        ModuleT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        ModuleT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        ModuleT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        ModuleT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        ModuleT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        ModuleT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        ModuleT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        ModuleT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        ModuleT new Readable()
        ModuleT new Writable()
        ModuleT new Duplex()
        ModuleT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        ModuleT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        ModuleT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        ModuleT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        ModuleT new Cucumber
      .to.throw TypeError
