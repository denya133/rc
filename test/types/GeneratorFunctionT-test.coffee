{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  GeneratorFunctionT
} = RC::

describe 'GeneratorFunctionT', ->
  describe 'checking generator function', ->
    it 'check generator function', ->
      expect ->
        GeneratorFunctionT -> yield
      .to.not.throw TypeError
  describe 'throw when check not generator function', ->
    it 'throw when check function', ->
      expect ->
        GeneratorFunctionT ->
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        GeneratorFunctionT class Cucumber
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        GeneratorFunctionT new EventEmitter()
      .to.throw TypeError
    it 'throw when check new Error', ->
      expect ->
        GeneratorFunctionT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        GeneratorFunctionT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        GeneratorFunctionT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        GeneratorFunctionT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        GeneratorFunctionT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        GeneratorFunctionT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        GeneratorFunctionT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        GeneratorFunctionT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        GeneratorFunctionT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        GeneratorFunctionT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        GeneratorFunctionT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        GeneratorFunctionT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        GeneratorFunctionT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        GeneratorFunctionT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        GeneratorFunctionT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        GeneratorFunctionT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        GeneratorFunctionT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        GeneratorFunctionT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        GeneratorFunctionT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        GeneratorFunctionT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        GeneratorFunctionT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        GeneratorFunctionT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        GeneratorFunctionT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        GeneratorFunctionT Object({})
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        GeneratorFunctionT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        GeneratorFunctionT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        GeneratorFunctionT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        GeneratorFunctionT new Readable()
        GeneratorFunctionT new Writable()
        GeneratorFunctionT new Duplex()
        GeneratorFunctionT new Transform()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        GeneratorFunctionT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        GeneratorFunctionT new Cucumber
      .to.throw TypeError
