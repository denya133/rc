{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co, filter } = RC::Utils

describe 'Utils.filter', ->
  describe 'filter(array, generator)', ->
    it 'should filter list by async condition', ->
      co ->
        array = [
          RC::Promise.resolve 1
          RC::Promise.resolve 5
          RC::Promise.resolve 3
          RC::Promise.resolve 7
          RC::Promise.resolve 2
        ]
        context = condition: (value) -> 3 < (yield value) < 7
        result = yield filter array, (item, index) ->
          yield @condition item
        , context
        assert.lengthOf result, 1
        assert.equal (yield result[0]), 5
        yield return
    it 'should filter list by sync condition', ->
      co ->
        array = [
          RC::Promise.resolve 1
          RC::Promise.resolve 5
          RC::Promise.resolve 3
          RC::Promise.resolve 7
          RC::Promise.resolve 2
        ]
        context = condition: (value) -> 3 < value < 7
        result = yield filter array, (item, index) ->
          @condition yield item
        , context
        assert.lengthOf result, 1
        assert.equal (yield result[0]), 5
        yield return
