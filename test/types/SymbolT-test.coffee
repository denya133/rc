{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  SymbolT
} = RC::

describe 'SymbolT', ->
  describe 'checking Symbol', ->
    it 'check symbol', ->
      expect ->
        SymbolT Symbol()
      .to.not.throw TypeError
  describe 'throw when check not Symbol', ->
    it 'throw when check new Error', ->
      expect ->
        SymbolT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        SymbolT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        SymbolT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        SymbolT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        SymbolT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        SymbolT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        SymbolT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        SymbolT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        SymbolT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        SymbolT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        SymbolT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        SymbolT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        SymbolT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        SymbolT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        SymbolT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        SymbolT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        SymbolT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        SymbolT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        SymbolT String 'string'
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        SymbolT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        SymbolT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        SymbolT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        SymbolT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        SymbolT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        SymbolT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        SymbolT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        SymbolT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        SymbolT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        SymbolT new Readable()
        SymbolT new Writable()
        SymbolT new Duplex()
        SymbolT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        SymbolT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        SymbolT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        SymbolT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        SymbolT new Cucumber
      .to.throw TypeError
