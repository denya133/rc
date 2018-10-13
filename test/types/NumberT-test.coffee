{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  NumberT
} = RC::

describe 'NumberT', ->
  describe 'checking Number', ->
    it 'check number', ->
      expect ->
        NumberT 1
      .to.not.throw TypeError
    it 'check float', ->
      expect ->
        NumberT 1/6
      .to.not.throw TypeError
    it 'check new Number', ->
      expect ->
        NumberT new Number 10
      .to.not.throw TypeError
    it 'check Number 11', ->
      expect ->
        NumberT Number 11
      .to.not.throw TypeError
  describe 'throw when check not Number', ->
    it 'throw when check new Error', ->
      expect ->
        NumberT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        NumberT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        NumberT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        NumberT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        NumberT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        NumberT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        NumberT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        NumberT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        NumberT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        NumberT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        NumberT undefined
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        NumberT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        NumberT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        NumberT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        NumberT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        NumberT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        NumberT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        NumberT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        NumberT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        NumberT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        NumberT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        NumberT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        NumberT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        NumberT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        NumberT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        NumberT new Readable()
        NumberT new Writable()
        NumberT new Duplex()
        NumberT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        NumberT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        NumberT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        NumberT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        NumberT new Cucumber
      .to.throw TypeError
