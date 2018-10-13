{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  GeneratorT
} = RC::

describe 'GeneratorT', ->
  describe 'checking generator', ->
    it 'throw when check generator', ->
      expect ->
        GeneratorT do -> yield
      .to.not.throw TypeError
  describe 'throw when check not generator', ->
    it 'throw when check new Error', ->
      expect ->
        GeneratorT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        GeneratorT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        GeneratorT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        GeneratorT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        GeneratorT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        GeneratorT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        GeneratorT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        GeneratorT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        GeneratorT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        GeneratorT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        GeneratorT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        GeneratorT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        GeneratorT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        GeneratorT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        GeneratorT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        GeneratorT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        GeneratorT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        GeneratorT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        GeneratorT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        GeneratorT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        GeneratorT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        GeneratorT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        GeneratorT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        GeneratorT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        GeneratorT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        GeneratorT -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        GeneratorT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        GeneratorT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        GeneratorT new Readable()
        GeneratorT new Writable()
        GeneratorT new Duplex()
        GeneratorT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        GeneratorT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        GeneratorT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        GeneratorT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        GeneratorT new Cucumber
      .to.throw TypeError
