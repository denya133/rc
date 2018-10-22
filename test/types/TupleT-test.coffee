{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  TupleT
  TupleG
} = RC::

describe 'TupleT', ->
  describe 'checking TupleT', ->
    it 'check [String, Number]', ->
      expect ->
        TupleT TupleG String, Number
      .to.not.throw TypeError
  describe 'throw when check not TupleT', ->
    it 'throw when check new Error', ->
      expect ->
        TupleT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        TupleT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        TupleT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        TupleT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        TupleT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        TupleT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        TupleT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        TupleT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        TupleT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        TupleT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        TupleT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        TupleT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        TupleT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        TupleT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        TupleT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        TupleT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        TupleT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        TupleT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        TupleT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        TupleT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        TupleT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        TupleT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        TupleT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        TupleT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        TupleT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        TupleT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        TupleT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        TupleT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        TupleT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        TupleT new Readable()
        TupleT new Writable()
        TupleT new Duplex()
        TupleT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        TupleT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        TupleT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        TupleT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        TupleT new Cucumber
      .to.throw TypeError
