{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  StructT
  StructG
} = RC::

describe 'StructT', ->
  describe 'checking StructT', ->
    it 'check struct {name: String}', ->
      expect ->
        StructT StructG name: String
      .to.not.throw TypeError
  describe 'throw when check not StructT', ->
    it 'throw when check new Error', ->
      expect ->
        StructT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        StructT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        StructT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        StructT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        StructT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        StructT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        StructT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        StructT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        StructT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        StructT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        StructT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        StructT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        StructT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        StructT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        StructT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        StructT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        StructT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        StructT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        StructT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        StructT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        StructT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        StructT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        StructT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        StructT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        StructT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        StructT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        StructT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        StructT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        StructT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        StructT new Readable()
        StructT new Writable()
        StructT new Duplex()
        StructT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        StructT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        StructT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        StructT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        StructT new Cucumber
      .to.throw TypeError
