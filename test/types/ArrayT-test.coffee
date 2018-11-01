{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  ArrayT
} = RC::

describe 'ArrayT', ->
  describe 'checking array', ->
    it 'check plain array', ->
      expect ->
        ArrayT []
      .to.not.throw TypeError
    it 'check array', ->
      expect ->
        ArrayT new Array([])
      .to.not.throw TypeError
  describe 'throw when check not array', ->
    it 'throw when check null', ->
      expect ->
        ArrayT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        ArrayT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        ArrayT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        ArrayT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        ArrayT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        ArrayT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        ArrayT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        ArrayT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        ArrayT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        ArrayT String 'string'
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        ArrayT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        ArrayT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        ArrayT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        ArrayT Boolean yes
      .to.throw TypeError
    it 'throw when check date', ->
      expect ->
        ArrayT new Date()
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        ArrayT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        ArrayT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        ArrayT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        ArrayT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        ArrayT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        ArrayT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        ArrayT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        ArrayT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        ArrayT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        ArrayT new Map()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        ArrayT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        ArrayT new Readable()
        ArrayT new Writable()
        ArrayT new Duplex()
        ArrayT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        ArrayT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        ArrayT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check error', ->
      expect ->
        ArrayT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        ArrayT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        ArrayT new Cucumber
      .to.throw TypeError
