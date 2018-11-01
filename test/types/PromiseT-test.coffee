{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  PromiseT
} = RC::

describe 'PromiseT', ->
  describe 'checking Promise', ->
    it 'check Promise', ->
      expect ->
        PromiseT Promise.resolve yes
      .to.not.throw TypeError
    it 'check RC::Promise', ->
      expect ->
        PromiseT RC::Promise.resolve yes
      .to.not.throw TypeError
  describe 'throw when check not Promise', ->
    it 'check new Error', ->
      expect ->
        PromiseT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        PromiseT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        PromiseT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        PromiseT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        PromiseT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        PromiseT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        PromiseT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        PromiseT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        PromiseT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        PromiseT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        PromiseT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        PromiseT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        PromiseT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        PromiseT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        PromiseT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        PromiseT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        PromiseT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        PromiseT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        PromiseT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        PromiseT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        PromiseT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        PromiseT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        PromiseT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        PromiseT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        PromiseT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        PromiseT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        PromiseT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        PromiseT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        PromiseT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        PromiseT new Readable()
        PromiseT new Writable()
        PromiseT new Duplex()
        PromiseT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        PromiseT new EventEmitter()
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        PromiseT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        PromiseT new Cucumber
      .to.throw TypeError
