{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  NilT
} = RC::

describe 'NilT', ->
  describe 'checking Nil', ->
    it 'check null', ->
      expect ->
        NilT null
      .to.not.throw TypeError
    it 'check undefined', ->
      expect ->
        NilT undefined
      .to.not.throw TypeError
  describe 'throw when check not Nil', ->
    it 'throw when check new Error', ->
      expect ->
        NilT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        NilT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        NilT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        NilT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        NilT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        NilT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        NilT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        NilT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        NilT new Array([])
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        NilT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        NilT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        NilT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        NilT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        NilT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        NilT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        NilT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        NilT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        NilT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        NilT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        NilT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        NilT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        NilT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        NilT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        NilT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        NilT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        NilT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        NilT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        NilT new Readable()
        NilT new Writable()
        NilT new Duplex()
        NilT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        NilT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        NilT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        NilT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        NilT new Cucumber
      .to.throw TypeError
