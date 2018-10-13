{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  ObjectT
} = RC::

describe 'ObjectT', ->
  describe 'checking Object', ->
    it 'check plain object', ->
      expect ->
        ObjectT {}
      .to.not.throw TypeError
    it 'check object', ->
      expect ->
        ObjectT new Object({})
      .to.not.throw TypeError
    it 'check object casting', ->
      expect ->
        ObjectT Object({})
      .to.not.throw TypeError
    it 'check new Error', ->
      expect ->
        ObjectT new Error 'Error'
        return
      .to.not.throw TypeError
    it 'check generator', ->
      expect ->
        ObjectT do -> yield
      .to.not.throw TypeError
    it 'check Set', ->
      expect ->
        ObjectT new Set()
      .to.not.throw TypeError
    it 'check Map', ->
      expect ->
        ObjectT new Map()
      .to.not.throw TypeError
    it 'check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        ObjectT new Readable()
        ObjectT new Writable()
        ObjectT new Duplex()
        ObjectT new Transform()
      .to.not.throw TypeError
    it 'check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        ObjectT new EventEmitter()
      .to.not.throw TypeError
    it 'check promise', ->
      expect ->
        ObjectT Promise.resolve yes
      .to.not.throw TypeError
    it 'check instance of some class', ->
      expect ->
        class Cucumber
        ObjectT new Cucumber
      .to.not.throw TypeError
    it 'check new Number', ->
      expect ->
        ObjectT new Number 10
      .to.not.throw TypeError
    it 'check new String', ->
      expect ->
        ObjectT new String 'string'
      .to.not.throw TypeError
    it 'check RegExp', ->
      expect ->
        ObjectT new RegExp '.*'
      .to.not.throw TypeError
    it 'check new Date()', ->
      expect ->
        ObjectT new Date()
      .to.not.throw TypeError
    it 'check Buffer.alloc(0)', ->
      expect ->
        ObjectT Buffer.alloc(0)
      .to.not.throw TypeError
    it 'check new Boolean no', ->
      expect ->
        ObjectT new Boolean no
      .to.not.throw TypeError
  describe 'throw when check not Object', ->
    it 'throw when check true boolean', ->
      expect ->
        ObjectT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        ObjectT no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        ObjectT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        ObjectT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        ObjectT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        ObjectT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        ObjectT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        ObjectT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        ObjectT 1/6
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        ObjectT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        ObjectT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        ObjectT ''
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        ObjectT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        ObjectT Symbol()
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        ObjectT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        ObjectT -> yield
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        ObjectT class Cucumber
      .to.throw TypeError
