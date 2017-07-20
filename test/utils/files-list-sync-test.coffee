{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ filesListSync } = RC::Utils

describe 'Utils.filesListSync', ->
  describe 'filesListSync(folder, options)', ->
    it 'should get simple files/directories list', ->
      dirName = "#{__dirname}/files-list"
      files = filesListSync dirName
      assert.lengthOf files, 4
      assert.deepEqual files, [ 'sub-folder', 'test.txt', 'test1.txt', 'test2.txt' ]
      return
