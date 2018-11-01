{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  ListT
  ListG
} = RC::

describe 'ListT', ->
  describe 'checking ListT', ->
    it 'check Array< String >', ->
      expect ->
        ListT ListG String
      .to.not.throw TypeError
  describe 'throw when check not ListT', ->
    it 'throw when check new Error', ->
      expect ->
        ListT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        ListT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        ListT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        ListT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        ListT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        ListT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        ListT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        ListT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        ListT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        ListT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        ListT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        ListT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        ListT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        ListT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        ListT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        ListT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        ListT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        ListT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        ListT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        ListT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        ListT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        ListT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        ListT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        ListT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        ListT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        ListT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        ListT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        ListT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        ListT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        ListT new Readable()
        ListT new Writable()
        ListT new Duplex()
        ListT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        ListT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        ListT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        ListT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        ListT new Cucumber
      .to.throw TypeError
