{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  AsyncFunctionT
  Utils: { co }
} = RC::

describe 'AsyncFunctionT', ->
  describe 'checking async function', ->
    it 'check co.wrap -> function', ->
      expect ->
        AsyncFunctionT co.wrap -> yield return
      .to.not.throw TypeError
  describe 'throw when check not function', ->
    it 'throw when check simple function', ->
      expect ->
        AsyncFunctionT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        AsyncFunctionT -> yield
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        AsyncFunctionT class Cucumber
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        AsyncFunctionT new EventEmitter()
      .to.throw TypeError
    it 'throw when check new Error', ->
      expect ->
        AsyncFunctionT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        AsyncFunctionT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        AsyncFunctionT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        AsyncFunctionT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        AsyncFunctionT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        AsyncFunctionT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        AsyncFunctionT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        AsyncFunctionT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        AsyncFunctionT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        AsyncFunctionT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        AsyncFunctionT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        AsyncFunctionT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        AsyncFunctionT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        AsyncFunctionT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        AsyncFunctionT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        AsyncFunctionT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        AsyncFunctionT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        AsyncFunctionT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        AsyncFunctionT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        AsyncFunctionT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        AsyncFunctionT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        AsyncFunctionT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        AsyncFunctionT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        AsyncFunctionT Object({})
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        AsyncFunctionT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        AsyncFunctionT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        AsyncFunctionT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        AsyncFunctionT new Readable()
        AsyncFunctionT new Writable()
        AsyncFunctionT new Duplex()
        AsyncFunctionT new Transform()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        AsyncFunctionT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        AsyncFunctionT new Cucumber
      .to.throw TypeError
