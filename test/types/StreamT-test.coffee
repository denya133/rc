{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  StreamT
} = RC::

describe 'StreamT', ->
  describe 'checking Stream', ->
    it 'check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        StreamT new Readable()
        StreamT new Writable()
        StreamT new Duplex()
        StreamT new Transform()
      .to.not.throw TypeError
  describe 'throw when check not Stream', ->
    it 'throw when check new Error', ->
      expect ->
        StreamT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        StreamT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        StreamT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        StreamT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        StreamT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        StreamT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        StreamT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        StreamT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        StreamT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        StreamT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        StreamT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        StreamT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        StreamT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        StreamT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        StreamT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        StreamT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        StreamT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        StreamT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        StreamT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        StreamT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        StreamT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        StreamT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        StreamT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        StreamT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        StreamT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        StreamT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        StreamT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        StreamT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        StreamT new Map()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        StreamT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        StreamT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        StreamT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        StreamT new Cucumber
      .to.throw TypeError
