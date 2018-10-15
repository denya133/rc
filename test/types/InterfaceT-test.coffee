{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  InterfaceT
  Module
  Interface
} = RC::

describe 'InterfaceT', ->
  describe 'checking RC::Interface', ->
    it 'check some custom interface', ->
      expect ->
        class TestModule extends RC
          @inheritProtected()
          @root __dirname
          @initialize()
        class TomatoInterface extends Interface
          @inheritProtected()
          @module TestModule
          @initialize()
        InterfaceT TomatoInterface
        return
      .to.not.throw TypeError
    it 'check EventInterface type', ->
      expect ->
        InterfaceT RC::EventInterface
        return
      .to.not.throw TypeError
    it 'check HookedObjectInterface type', ->
      expect ->
        InterfaceT RC::HookedObjectInterface
        return
      .to.not.throw TypeError
    it 'check PromiseInterface type', ->
      expect ->
        InterfaceT RC::PromiseInterface
        return
      .to.not.throw TypeError
    it 'check StateInterface type', ->
      expect ->
        InterfaceT RC::StateInterface
        return
      .to.not.throw TypeError
    it 'check StateMachineInterface type', ->
      expect ->
        InterfaceT RC::StateMachineInterface
        return
      .to.not.throw TypeError
    it 'check TransitionInterface type', ->
      expect ->
        InterfaceT RC::TransitionInterface
        return
      .to.not.throw TypeError
  describe 'throw when check not RC::Interface', ->
    it 'throw when check new Error', ->
      expect ->
        InterfaceT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        InterfaceT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        InterfaceT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        InterfaceT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        InterfaceT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        InterfaceT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        InterfaceT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        InterfaceT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        InterfaceT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        InterfaceT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        InterfaceT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        InterfaceT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        InterfaceT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        InterfaceT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        InterfaceT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        InterfaceT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        InterfaceT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        InterfaceT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        InterfaceT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        InterfaceT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        InterfaceT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        InterfaceT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        InterfaceT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        InterfaceT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        InterfaceT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        InterfaceT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        InterfaceT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        InterfaceT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        InterfaceT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        InterfaceT new Readable()
        InterfaceT new Writable()
        InterfaceT new Duplex()
        InterfaceT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        InterfaceT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        InterfaceT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        InterfaceT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        InterfaceT new Cucumber
      .to.throw TypeError
