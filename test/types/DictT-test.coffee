{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  DictT
  DictG
} = RC::

describe 'DictT', ->
  describe 'checking DictT', ->
    it 'check {[String]: String}', ->
      expect ->
        DictT DictG String, String
      .to.not.throw TypeError
  describe 'throw when check not DictT', ->
    it 'throw when check new Error', ->
      expect ->
        DictT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        DictT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        DictT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        DictT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        DictT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        DictT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        DictT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        DictT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        DictT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        DictT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        DictT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        DictT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        DictT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        DictT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        DictT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        DictT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        DictT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        DictT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        DictT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        DictT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        DictT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        DictT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        DictT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        DictT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        DictT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        DictT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        DictT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        DictT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        DictT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        DictT new Readable()
        DictT new Writable()
        DictT new Duplex()
        DictT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        DictT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        DictT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        DictT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        DictT new Cucumber
      .to.throw TypeError
