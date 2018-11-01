{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  MaybeT
  MaybeG
} = RC::

describe 'MaybeT', ->
  describe 'checking MaybeT', ->
    it 'check ?String', ->
      expect ->
        MaybeT MaybeG String
      .to.not.throw TypeError
  describe 'throw when check not MaybeT', ->
    it 'throw when check new Error', ->
      expect ->
        MaybeT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        MaybeT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        MaybeT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        MaybeT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        MaybeT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        MaybeT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        MaybeT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        MaybeT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        MaybeT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        MaybeT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        MaybeT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        MaybeT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        MaybeT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        MaybeT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        MaybeT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        MaybeT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        MaybeT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        MaybeT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        MaybeT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        MaybeT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        MaybeT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        MaybeT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        MaybeT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        MaybeT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        MaybeT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        MaybeT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        MaybeT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        MaybeT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        MaybeT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        MaybeT new Readable()
        MaybeT new Writable()
        MaybeT new Duplex()
        MaybeT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        MaybeT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        MaybeT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        MaybeT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        MaybeT new Cucumber
      .to.throw TypeError
