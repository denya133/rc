{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  ErrorT
} = RC::

describe 'ErrorT', ->
  describe 'checking error', ->
    it 'check new Error', ->
      expect ->
        ErrorT new Error 'Error'
        return
      .to.not.throw TypeError
  describe 'throw when check not error', ->
    it 'throw when check new Date()', ->
      expect ->
        ErrorT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        ErrorT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        ErrorT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        ErrorT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        ErrorT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        ErrorT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        ErrorT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        ErrorT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        ErrorT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        ErrorT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        ErrorT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        ErrorT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        ErrorT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        ErrorT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        ErrorT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        ErrorT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        ErrorT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        ErrorT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        ErrorT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        ErrorT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        ErrorT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        ErrorT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        ErrorT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        ErrorT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        ErrorT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        ErrorT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        ErrorT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        ErrorT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        ErrorT new Readable()
        ErrorT new Writable()
        ErrorT new Duplex()
        ErrorT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        ErrorT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        ErrorT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        ErrorT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        ErrorT new Cucumber
      .to.throw TypeError
