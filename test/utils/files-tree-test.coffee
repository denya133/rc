{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co, filesTree } = RC::Utils

describe 'Utils.filesTree', ->
  describe 'filesTree(folder, options)', ->
    it 'should get simple files/directories tree', ->
      co ->
        dirName = "#{__dirname}/files-tree"
        files = yield filesTree dirName
        assert.lengthOf files, 5
        assert.deepEqual files, [
          'sub-folder', 'sub-folder/test3.txt', 'test.txt', 'test1.txt', 'test2.txt'
        ]
        files = yield filesTree dirName, filesOnly: yes
        assert.lengthOf files, 4
        assert.deepEqual files, [
          'sub-folder/test3.txt', 'test.txt', 'test1.txt', 'test2.txt'
        ]
        yield return
