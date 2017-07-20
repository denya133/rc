{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co, forEach } = RC::Utils

describe 'Utils.forEach', ->
  describe 'forEach(array, generator)', ->
    it 'should iterate over list', ->
      co ->
        array = [
          RC::Promise.resolve 1
          RC::Promise.resolve 5
          RC::Promise.resolve 3
          RC::Promise.resolve 7
          RC::Promise.resolve 2
        ]
        result = []
        yield forEach array, (item, index) ->
          @push "key_#{index}": yield item
          yield return
        , result
        assert.deepEqual result, [
          { key_0: 1 }, { key_1: 5 }, { key_2: 3 }, { key_3: 7 }, { key_4: 2 }
        ]
        yield return
