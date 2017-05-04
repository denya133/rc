{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co, map } = RC::Utils

describe 'Utils.map', ->
  describe 'map(array, generator)', ->
    it 'should map list', ->
      co ->
        array = [
          RC::Promise.resolve 1
          RC::Promise.resolve 5
          RC::Promise.resolve 3
          RC::Promise.resolve 7
          RC::Promise.resolve 2
        ]
        context = name: 'context'
        result = yield map array, (item, index) ->
          "item_#{yield item}_#{@name}"
        , context
        assert.deepEqual result, [
          'item_1_context'
          'item_5_context'
          'item_3_context'
          'item_7_context'
          'item_2_context'
        ]
        yield return
