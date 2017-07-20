{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ jsonStringify, co } = RC::Utils

describe 'Utils.jsonStringify', ->
  describe 'jsonStringify(object, options)', ->
    it 'should stringify flat object', ->
      co ->
        object = {}
        object.x = 'test'
        object.a = 42
        object.test = no
        result = jsonStringify object
        assert.equal result, '{"a":42,"test":false,"x":"test"}'
        yield return
    it 'should stringify nested object', ->
      co ->
        object = {}
        object.x = 'test'
        object.a = 42
        object.test = no
        object.nested = {}
        object.nested.c = 1
        object.nested.b = 2
        object.nested.a = 3
        result = jsonStringify object
        assert.equal result, '{"a":42,"nested":{"a":3,"b":2,"c":1},"test":false,"x":"test"}'
        yield return
