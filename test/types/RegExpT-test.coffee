{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  RegExpT
} = RC::

describe 'RegExpT', ->
  describe 'checking RegExp', ->
    it 'check RegExp', ->
      expect ->
        RegExpT new RegExp '.*'
      .to.not.throw TypeError
  describe 'throw when check not RegExp', ->
    it 'throw when check new Error', ->
      expect ->
        RegExpT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        RegExpT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        RegExpT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        RegExpT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        RegExpT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        RegExpT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        RegExpT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        RegExpT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        RegExpT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        RegExpT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        RegExpT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        RegExpT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        RegExpT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        RegExpT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        RegExpT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        RegExpT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        RegExpT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        RegExpT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        RegExpT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        RegExpT Symbol()
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        RegExpT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        RegExpT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        RegExpT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        RegExpT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        RegExpT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        RegExpT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        RegExpT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        RegExpT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        RegExpT new Readable()
        RegExpT new Writable()
        RegExpT new Duplex()
        RegExpT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        RegExpT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        RegExpT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        RegExpT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        RegExpT new Cucumber
      .to.throw TypeError
