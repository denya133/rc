{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  MixinT
  Module
  CoreObject
} = RC::

describe 'MixinT', ->
  describe 'checking Mixin', ->
    it 'check some custom mixin', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        TestModule.defineMixin RC::Mixin 'TomatoMixin', (BaseClass = CoreObject)->
          class extends BaseClass
            @inheritProtected()
            @module TestModule
            @initializeMixin()
        MixinT TestModule::TomatoMixin
        return
      .to.not.throw TypeError
    it 'check StateMachineMixin type', ->
      expect ->
        MixinT RC::StateMachineMixin
        return
      .to.not.throw TypeError
    it 'check ChainsMixin type', ->
      expect ->
        MixinT RC::ChainsMixin
        return
      .to.not.throw TypeError
  describe 'throw when check not Mixin', ->
    it 'throw when check new Error', ->
      expect ->
        MixinT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        MixinT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        MixinT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        MixinT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        MixinT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        MixinT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        MixinT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        MixinT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        MixinT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        MixinT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        MixinT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        MixinT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        MixinT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        MixinT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        MixinT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        MixinT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        MixinT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        MixinT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        MixinT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        MixinT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        MixinT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        MixinT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        MixinT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        MixinT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        MixinT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        MixinT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        MixinT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        MixinT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        MixinT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        MixinT new Readable()
        MixinT new Writable()
        MixinT new Duplex()
        MixinT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        MixinT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        MixinT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        MixinT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        MixinT new Cucumber
      .to.throw TypeError
