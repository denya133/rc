{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  BufferT
} = RC::

describe 'BufferT', ->
  describe 'checking buffer', ->
    it 'check Buffer.alloc(0)', ->
      expect ->
        BufferT Buffer.alloc(0)
      .to.not.throw TypeError
  describe 'throw when check not buffer', ->
    it 'throw when check true boolean', ->
      expect ->
        BufferT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        BufferT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        BufferT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        BufferT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        BufferT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        BufferT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        BufferT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        BufferT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        BufferT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        BufferT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        BufferT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        BufferT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        BufferT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        BufferT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        BufferT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        BufferT String 'string'
      .to.throw TypeError
    it 'throw when check date', ->
      expect ->
        BufferT new Date()
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        BufferT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        BufferT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        BufferT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        BufferT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        BufferT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        BufferT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        BufferT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        BufferT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        BufferT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        BufferT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        BufferT new Readable()
        BufferT new Writable()
        BufferT new Duplex()
        BufferT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        BufferT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        BufferT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check error', ->
      expect ->
        BufferT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        BufferT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        BufferT new Cucumber
      .to.throw TypeError
