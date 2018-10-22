{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  NumberT
  IntegerT
  IntersectionT
  IntersectionG
} = RC::

describe 'IntersectionT', ->
  describe 'checking IntersectionT', ->
    it 'check intersection(NumberT & IntegerT)', ->
      expect ->
        IntersectionT IntersectionG NumberT, IntegerT
      .to.not.throw TypeError
  describe 'throw when check not IntersectionT', ->
    it 'throw when check new Error', ->
      expect ->
        IntersectionT new Error 'Error'
        return
      .to.throw TypeError
    it 'throw when check new Date()', ->
      expect ->
        IntersectionT new Date()
      .to.throw TypeError
    it 'throw when check Buffer.alloc(0)', ->
      expect ->
        IntersectionT Buffer.alloc(0)
      .to.throw TypeError
    it 'throw when check true boolean', ->
      expect ->
        IntersectionT yes
      .to.throw TypeError
    it 'throw when check false boolean', ->
      expect ->
        IntersectionT no
      .to.throw TypeError
    it 'throw when check new Boolean no', ->
      expect ->
        IntersectionT new Boolean no
      .to.throw TypeError
    it 'throw when check Boolean yes', ->
      expect ->
        IntersectionT Boolean yes
      .to.throw TypeError
    it 'throw when check plain array', ->
      expect ->
        IntersectionT []
      .to.throw TypeError
    it 'throw when check array', ->
      expect ->
        IntersectionT new Array([])
      .to.throw TypeError
    it 'throw when check null', ->
      expect ->
        IntersectionT null
      .to.throw TypeError
    it 'throw when check undefined', ->
      expect ->
        IntersectionT undefined
      .to.throw TypeError
    it 'throw when check number', ->
      expect ->
        IntersectionT 1
      .to.throw TypeError
    it 'throw when check float', ->
      expect ->
        IntersectionT 1/6
      .to.throw TypeError
    it 'throw when check new Number', ->
      expect ->
        IntersectionT new Number 10
      .to.throw TypeError
    it 'throw when check Number 11', ->
      expect ->
        IntersectionT Number 11
      .to.throw TypeError
    it 'throw when check string', ->
      expect ->
        IntersectionT 'string'
      .to.throw TypeError
    it 'throw when check empty string', ->
      expect ->
        IntersectionT ''
      .to.throw TypeError
    it 'throw when check new String', ->
      expect ->
        IntersectionT new String 'string'
      .to.throw TypeError
    it 'throw when check String 11', ->
      expect ->
        IntersectionT String 'string'
      .to.throw TypeError
    it 'throw when check symbol', ->
      expect ->
        IntersectionT Symbol()
      .to.throw TypeError
    it 'throw when check RegExp', ->
      expect ->
        IntersectionT new RegExp '.*'
      .to.throw TypeError
    it 'throw when check plain object', ->
      expect ->
        IntersectionT {}
      .to.throw TypeError
    it 'throw when check object', ->
      expect ->
        IntersectionT new Object({})
      .to.throw TypeError
    it 'throw when check object casting', ->
      expect ->
        IntersectionT Object({})
      .to.throw TypeError
    it 'throw when check function', ->
      expect ->
        IntersectionT ->
      .to.throw TypeError
    it 'throw when check generator function', ->
      expect ->
        IntersectionT -> yield
      .to.throw TypeError
    it 'throw when check generator', ->
      expect ->
        IntersectionT do -> yield
      .to.throw TypeError
    it 'throw when check Set', ->
      expect ->
        IntersectionT new Set()
      .to.throw TypeError
    it 'throw when check Map', ->
      expect ->
        IntersectionT new Map()
      .to.throw TypeError
    it 'throw when check Stream', ->
      expect ->
        {Readable, Writable, Duplex, Transform} = require 'stream'
        IntersectionT new Readable()
        IntersectionT new Writable()
        IntersectionT new Duplex()
        IntersectionT new Transform()
      .to.throw TypeError
    it 'throw when check EventEmitter', ->
      expect ->
        EventEmitter = require 'events'
        IntersectionT new EventEmitter()
      .to.throw TypeError
    it 'throw when check promise', ->
      expect ->
        IntersectionT Promise.resolve yes
      .to.throw TypeError
    it 'throw when check class', ->
      expect ->
        IntersectionT class Cucumber
      .to.throw TypeError
    it 'throw when check instance of some class', ->
      expect ->
        class Cucumber
        IntersectionT new Cucumber
      .to.throw TypeError
