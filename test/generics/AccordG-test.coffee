{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  AccordG
} = RC::

describe 'AccordG', ->
  describe 'checking correspondence', ->
    it 'correspond Function', ->
      expect AccordG Function
      .to.equal RC::FunctionT
    it 'correspond FunctionT', ->
      expect AccordG RC::FunctionT
      .to.equal RC::FunctionT
    it 'correspond String', ->
      expect AccordG String
      .to.equal RC::StringT
    it 'correspond StringT', ->
      expect AccordG RC::StringT
      .to.equal RC::StringT
    it 'correspond Number', ->
      expect AccordG Number
      .to.equal RC::NumberT
    it 'correspond NumberT', ->
      expect AccordG RC::NumberT
      .to.equal RC::NumberT
    it 'correspond Boolean', ->
      expect AccordG Boolean
      .to.equal RC::BooleanT
    it 'correspond BooleanT', ->
      expect AccordG RC::BooleanT
      .to.equal RC::BooleanT
    it 'correspond Date', ->
      expect AccordG Date
      .to.equal RC::DateT
    it 'correspond DateT', ->
      expect AccordG RC::DateT
      .to.equal RC::DateT
    it 'correspond Object', ->
      expect AccordG Object
      .to.equal RC::ObjectT
    it 'correspond ObjectT', ->
      expect AccordG RC::ObjectT
      .to.equal RC::ObjectT
    it 'correspond Array', ->
      expect AccordG Array
      .to.equal RC::ArrayT
    it 'correspond ArrayT', ->
      expect AccordG RC::ArrayT
      .to.equal RC::ArrayT
    it 'correspond Map', ->
      expect AccordG Map
      .to.equal RC::MapT
    it 'correspond MapT', ->
      expect AccordG RC::MapT
      .to.equal RC::MapT
    it 'correspond Set', ->
      expect AccordG Set
      .to.equal RC::SetT
    it 'correspond SetT', ->
      expect AccordG RC::SetT
      .to.equal RC::SetT
    it 'correspond RegExp', ->
      expect AccordG RegExp
      .to.equal RC::RegExpT
    it 'correspond RegExpT', ->
      expect AccordG RC::RegExpT
      .to.equal RC::RegExpT
    it 'correspond Symbol', ->
      expect AccordG Symbol
      .to.equal RC::SymbolT
    it 'correspond SymbolT', ->
      expect AccordG RC::SymbolT
      .to.equal RC::SymbolT
    it 'correspond Error', ->
      expect AccordG Error
      .to.equal RC::ErrorT
    it 'correspond ErrorT', ->
      expect AccordG RC::ErrorT
      .to.equal RC::ErrorT
    it 'correspond Promise', ->
      expect AccordG Promise
      .to.equal RC::PromiseT
    it 'correspond RC::Promise', ->
      expect AccordG RC::Promise
      .to.equal RC::PromiseT
    it 'correspond PromiseT', ->
      expect AccordG RC::PromiseT
      .to.equal RC::PromiseT
    it 'correspond Buffer', ->
      expect AccordG Buffer
      .to.equal RC::BufferT
    it 'correspond BufferT', ->
      expect AccordG RC::BufferT
      .to.equal RC::BufferT
    it 'correspond Stream', ->
      expect AccordG (require 'stream')
      .to.equal RC::StreamT
    it 'correspond StreamT', ->
      expect AccordG RC::StreamT
      .to.equal RC::StreamT
    it 'correspond Generic', ->
      expect AccordG RC::Generic
      .to.equal RC::GenericT
    it 'correspond GenericT', ->
      expect AccordG RC::GenericT
      .to.equal RC::GenericT
    it 'correspond EventEmitter', ->
      expect AccordG (require 'events')
      .to.equal RC::EventEmitterT
    it 'correspond EventEmitterT', ->
      expect AccordG RC::EventEmitterT
      .to.equal RC::EventEmitterT
    it 'correspond ANY', ->
      expect AccordG RC::ANY
      .to.equal RC::AnyT
    it 'correspond AnyT', ->
      expect AccordG RC::AnyT
      .to.equal RC::AnyT
    it 'correspond NILL', ->
      expect AccordG RC::NILL
      .to.equal RC::NilT
    it 'correspond NilT', ->
      expect AccordG RC::NilT
      .to.equal RC::NilT
    it 'correspond LAMBDA', ->
      expect AccordG RC::LAMBDA
      .to.equal RC::LambdaT
    it 'correspond LambdaT', ->
      expect AccordG RC::LambdaT
      .to.equal RC::LambdaT
    it 'correspond Class', ->
      expect AccordG RC::Class
      .to.equal RC::ClassT
    it 'correspond ClassT', ->
      expect AccordG RC::ClassT
      .to.equal RC::ClassT
    it 'correspond Mixin', ->
      expect AccordG RC::Mixin
      .to.equal RC::MixinT
    it 'correspond MixinT', ->
      expect AccordG RC::MixinT
      .to.equal RC::MixinT
    it 'correspond Module', ->
      expect AccordG RC::Module
      .to.equal RC::ModuleT
    it 'correspond ModuleT', ->
      expect AccordG RC::ModuleT
      .to.equal RC::ModuleT
    it 'correspond Interface', ->
      expect AccordG RC::Interface
      .to.equal RC::InterfaceT
    it 'correspond InterfaceT', ->
      expect AccordG RC::InterfaceT
      .to.equal RC::InterfaceT
  describe 'checking correspondence non standart', ->
    it 'correspond Buffer.alloc(0)', ->
      b = Buffer.alloc(0)
      expect ->
        AccordG b
      .to.throw TypeError
    it 'correspond true boolean', ->
      y = yes
      expect ->
        AccordG y
      .to.throw TypeError
    it 'correspond false boolean', ->
      n = no
      expect ->
        AccordG n
      .to.throw TypeError
    it 'correspond new Boolean no', ->
      n = new Boolean no
      expect ->
        AccordG n
      .to.throw TypeError
    it 'correspond Boolean yes', ->
      y = Boolean yes
      expect ->
        AccordG y
      .to.throw TypeError
    it 'correspond plain array', ->
      a = []
      expect ->
        AccordG a
      .to.throw TypeError
    it 'correspond array', ->
      a = new Array([])
      expect ->
        AccordG a
      .to.throw TypeError
    it 'correspond null', ->
      nl = null
      expect ->
        AccordG nl
      .to.throw TypeError
    it 'correspond undefined', ->
      u = undefined
      expect ->
        AccordG u
      .to.throw TypeError
    it 'correspond number', ->
      n = 1
      expect ->
        AccordG n
      .to.throw TypeError
    it 'correspond float', ->
      n = 1/6
      expect ->
        AccordG n
      .to.throw TypeError
    it 'correspond new Number', ->
      n = new Number 10
      expect ->
        AccordG n
      .to.throw TypeError
    it 'correspond Number 11', ->
      n = Number 11
      expect ->
        AccordG n
      .to.throw TypeError
    it 'correspond string', ->
      s = 'string'
      expect ->
        AccordG s
      .to.throw TypeError
    it 'correspond empty string', ->
      empty = ''
      expect ->
        AccordG empty
      .to.throw TypeError
    it 'correspond new String', ->
      s = new String 'string'
      expect ->
        AccordG s
      .to.throw TypeError
    it 'correspond String 11', ->
      s = String 'string'
      expect ->
        AccordG s
      .to.throw TypeError
    it 'correspond symbol', ->
      symbol = Symbol()
      expect ->
        AccordG symbol
      .to.throw TypeError
    it 'correspond RegExp', ->
      r = new RegExp '.*'
      expect ->
        AccordG r
      .to.throw TypeError
    it 'correspond plain object', ->
      o = {}
      expect ->
        AccordG o
      .to.throw TypeError
    it 'correspond object', ->
      o = new Object({})
      expect ->
        AccordG o
      .to.throw TypeError
    it 'correspond object casting', ->
      o = Object({})
      expect ->
        AccordG o
      .to.throw TypeError
    it 'correspond function', ->
      f = ->
      expect AccordG f
      .to.equal f
    it 'correspond generator function', ->
      gf = -> yield
      expect AccordG gf
      .to.equal gf
    it 'correspond generator', ->
      g = do -> yield
      expect ->
        AccordG g
      .to.throw TypeError
    it 'correspond Set', ->
      st = new Set()
      expect ->
        AccordG st
      .to.throw TypeError
    it 'correspond Map', ->
      mp = new Map()
      expect ->
        AccordG mp
      .to.throw TypeError
    it 'correspond Readable Stream', ->
      expect ->
        {Readable} = require 'stream'
        AccordG new Readable()
      .to.throw TypeError
    it 'correspond Writable Stream', ->
      expect ->
        {Writable} = require 'stream'
        w = new Writable()
        AccordG new Writable()
      .to.throw TypeError
    it 'correspond Duplex Stream', ->
      expect ->
        {Duplex} = require 'stream'
        AccordG new Duplex()
      .to.throw TypeError
    it 'correspond Transform Stream', ->
      expect ->
        {Transform} = require 'stream'
        AccordG new Transform()
      .to.throw TypeError
    it 'correspond EventEmitter', ->
      EventEmitter = require 'events'
      e = new EventEmitter()
      expect ->
        AccordG e
      .to.throw TypeError
    it 'correspond promise', ->
      p = Promise.resolve yes
      expect ->
        AccordG p
      .to.throw TypeError
    it 'correspond class', ->
      c = class Cucumber
      expect AccordG c
      .to.equal c
    it 'correspond instance of some class', ->
      class Cucumber
      i = new Cucumber
      expect ->
        AccordG i
      .to.throw TypeError
