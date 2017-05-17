{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ filesTreeSync } = RC::Utils

describe 'Utils.filesTreeSync', ->
  describe 'filesTreeSync(folder, options)', ->
    it 'should get simple files/directories tree', ->
      dirName = "#{__dirname}/files-tree"
      files = filesTreeSync dirName
      assert.lengthOf files, 5
      assert.deepEqual files, [
        'sub-folder', 'sub-folder/test3.txt', 'test.txt', 'test1.txt', 'test2.txt'
      ]
      files = filesTreeSync dirName, filesOnly: yes
      assert.lengthOf files, 4
      assert.deepEqual files, [
        'sub-folder/test3.txt', 'test.txt', 'test1.txt', 'test2.txt'
      ]
      return
