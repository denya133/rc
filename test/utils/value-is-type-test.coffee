{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  valueIsType
  NilT
  IntegerT
  GeneratorFunctionT
  GeneratorT
  StreamT
  ClassT
  SampleG
  _
} = RC::

describe 'Utils.valueIsType', ->
  describe 'checking types', ->
    it 'check string', ->
      expect valueIsType 'string', String
      .to.equal yes
    it 'check empty string', ->
      expect valueIsType '', String
      .to.equal yes
    it 'check new String', ->
      expect valueIsType new String('string'), String
      .to.equal yes
    it 'check String 11', ->
      expect valueIsType String('string'), String
      .to.equal yes
    it 'check new Error', ->
      expect valueIsType new Error('Error'), Error
      .to.equal yes
    it 'check new Date()', ->
      expect valueIsType new Date(), Date
      .to.equal yes
    it 'check Buffer.alloc(0)', ->
      expect valueIsType Buffer.alloc(0), Buffer
      .to.equal yes
    it 'check true boolean', ->
      expect valueIsType yes, Boolean
      .to.equal yes
    it 'check false boolean', ->
      expect valueIsType no, Boolean
      .to.equal yes
    it 'check new Boolean no', ->
      expect valueIsType new Boolean(no), Boolean
      .to.equal yes
    it 'check Boolean yes', ->
      expect valueIsType Boolean(yes), Boolean
      .to.equal yes
    it 'check plain array', ->
      expect valueIsType [], Array
      .to.equal yes
    it 'check array', ->
      expect valueIsType new Array([]), Array
      .to.equal yes
    it 'check null', ->
      expect valueIsType null, NilT
      .to.equal yes
    it 'check undefined', ->
      expect valueIsType undefined, NilT
      .to.equal yes
    it 'check number', ->
      expect valueIsType 1, IntegerT
      .to.equal yes
    it 'check float', ->
      expect valueIsType 1/6, Number
      .to.equal yes
    it 'check new Number', ->
      expect valueIsType new Number(10), Number
      .to.equal yes
    it 'check Number 11', ->
      expect valueIsType Number(11), Number
      .to.equal yes
    it 'check symbol', ->
      expect valueIsType Symbol(), Symbol
      .to.equal yes
    it 'check RegExp', ->
      expect valueIsType new RegExp('.*'), RegExp
      .to.equal yes
    it 'check plain object', ->
      expect valueIsType {}, Object
      .to.equal yes
    it 'check object', ->
      expect valueIsType new Object({}), Object
      .to.equal yes
    it 'check object casting', ->
      expect valueIsType Object({}), Object
      .to.equal yes
    it 'check function', ->
      expect valueIsType (->), Function
      .to.equal yes
    it 'check generator function', ->
      expect valueIsType (-> yield), GeneratorFunctionT
      .to.equal yes
    it 'check generator', ->
      expect valueIsType (do -> yield), GeneratorT
      .to.equal yes
    it 'check Set', ->
      expect valueIsType new Set(), Set
      .to.equal yes
    it 'check Map', ->
      expect valueIsType new Map(), Map
      .to.equal yes
    it 'check Stream', ->
      {Readable} = require 'stream'
      expect valueIsType new Readable(), StreamT
      .to.equal yes
    it 'check EventEmitter', ->
      EventEmitter = require 'events'
      expect valueIsType new EventEmitter(), EventEmitter
      .to.equal yes
    it 'check promise', ->
      expect valueIsType Promise.resolve(yes), Promise
      .to.equal yes
    it 'check class', ->
      expect valueIsType (RC::CoreObject), ClassT
      .to.equal yes
    it 'check instance of some class', ->
      class Tomato
      expect valueIsType (new Tomato), SampleG Tomato
      .to.equal yes

      # c = new Map
      # RC::CACHE.forEach (value, key)->
      #   c.set key, value unless _.isFunction key
      console.log '>>??????? CACHE', RC::STRONG_CACHE
