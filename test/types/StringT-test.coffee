{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  StringT
} = RC::

describe 'StringT', ->
  describe 'checking String', ->
    it 'check string', ->
      expect ->
        StringT 'string'
      .to.not.throw TypeError
    it 'check empty string', ->
      expect ->
        StringT ''
      .to.not.throw TypeError
    it 'check new String', ->
      expect ->
        StringT new String 'string'
      .to.not.throw TypeError
    it 'check String 11', ->
      expect ->
        StringT String 'string'
      .to.not.throw TypeError
  describe 'throw when check not String', ->
    it 'throw when check new Error', ->
      expect ->
        StringT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        StringT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        StringT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        StringT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        StringT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        StringT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        StringT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        StringT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        StringT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        StringT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        StringT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        StringT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        StringT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        StringT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        StringT Number 11
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        StringT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        StringT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        StringT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        StringT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        StringT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        StringT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        StringT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        StringT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        StringT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        StringT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        StringT new Readable()
        StringT new Writable()
        StringT new Duplex()
        StringT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        StringT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        StringT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        StringT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        StringT new Cucumber
      .to.throw TypeError
