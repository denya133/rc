{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  UnionT
  UnionG
} = RC::

describe 'UnionT', ->
  describe 'checking UnionT', ->
    it 'check union(Number | String)', ->
      expect ->
        UnionT UnionG Number, String
      .to.not.throw TypeError
  describe 'throw when check not UnionT', ->
    it 'throw when check new Error', ->
      expect ->
        UnionT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        UnionT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        UnionT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        UnionT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        UnionT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        UnionT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        UnionT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        UnionT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        UnionT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        UnionT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        UnionT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        UnionT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        UnionT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        UnionT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        UnionT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        UnionT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        UnionT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        UnionT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        UnionT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        UnionT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        UnionT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        UnionT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        UnionT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        UnionT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        UnionT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        UnionT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        UnionT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        UnionT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        UnionT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        UnionT new Readable()
        UnionT new Writable()
        UnionT new Duplex()
        UnionT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        UnionT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        UnionT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        UnionT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        UnionT new Cucumber
      .to.throw TypeError
