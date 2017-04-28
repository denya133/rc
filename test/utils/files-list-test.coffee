{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co, filesList } = RC::Utils

describe 'Utils.filesList', ->
  describe 'filesList(folder, options)', ->
    it 'should get simple files/directories list', ->
      co ->
        dirName = "#{__dirname}/files-list"
        files = yield filesList dirName
        assert.lengthOf files, 4
        assert.deepEqual files, [ 'sub-folder', 'test.txt', 'test1.txt', 'test2.txt' ]
        yield return
