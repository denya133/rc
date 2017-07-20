{ expect, assert } = require 'chai'
RC = require '../lib'
MetaObject = RC::MetaObject

describe 'MetaObject', ->
  describe '.new', ->
    it 'should create new meta-object', ->
      expect ->
        target = {}
        myInstance = new RC::MetaObject target
        assert.instanceOf myInstance, RC::MetaObject, 'Cannot instantiate class MetaObject'
      .to.not.throw Error
  describe '#addMetaData', ->
    it 'should add key with data', ->
      expect ->
        target = {}
        myInstance = new RC::MetaObject target
        myInstance.addMetaData 'testGroup', 'testProp', { 'test': 'test1' }
        assert.deepEqual myInstance.data.testGroup.testProp, { 'test': 'test1' }, 'Data not added'
      .to.not.throw Error
  describe '#addMetaData', ->
    it 'should remove key with data', ->
      expect ->
        target = {}
        myInstance = new RC::MetaObject target
        myInstance.addMetaData 'testGroup', 'testProp', { 'test': 'test1' }
        myInstance.removeMetaData 'testGroup', 'testProp'
        assert.isUndefined myInstance.data.testGroup.testProp, 'Data not removed'
      .to.not.throw Error
  describe '#parent', ->
    it 'should create meta-data with parent', ->
      expect ->
        target = {}
        target2 = {}
        myParentInstance = new RC::MetaObject target
        myInstance = new RC::MetaObject target2, myParentInstance
        assert.equal myInstance.parent, myParentInstance, 'Parent is incorrect'
      .to.not.throw Error
  describe '#getGroup', ->
    it 'should retrieve data group from meta-object', ->
      expect ->
        target = {}
        myInstance = new RC::MetaObject target
        myInstance.addMetaData 'testGroup', 'testProp1', { 'test': 'test1' }
        myInstance.addMetaData 'testGroup', 'testProp2', { 'test': 'test2' }
        assert.deepEqual myInstance.getGroup('testGroup'),
          testProp1:
            test: 'test1'
          testProp2:
            test: 'test2'
        , 'Group is incorrect'
      .to.not.throw Error
    it 'should retrieve data group from meta-object with parent', ->
      expect ->
        target = {}
        target2 = {}
        myParentInstance = new RC::MetaObject target
        myParentInstance.addMetaData 'testGroup', 'testProp0', { 'test': 'test0' }
        myInstance = new RC::MetaObject target2, myParentInstance
        myInstance.addMetaData 'testGroup', 'testProp1', { 'test': 'test1' }
        myInstance.addMetaData 'testGroup', 'testProp2', { 'test': 'test2' }
        assert.deepEqual myInstance.getGroup('testGroup'),
          testProp0:
            test: 'test0'
          testProp1:
            test: 'test1'
          testProp2:
            test: 'test2'
        , 'Group is incorrect'
      .to.not.throw Error
