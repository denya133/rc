{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'

describe 'Transition', ->
  describe '.new()', ->
    it 'should create new Transition instance', ->
      expect ->
        transition = RC::Transition.new 'newTransition'
        assert.instanceOf transition, RC::Transition, 'Cannot instantiate class Transition'
        assert.equal transition.name, 'newTransition'
      .to.not.throw Error
  describe '#testGuard', ->
    it 'should get guard without rejects', ->
      expect ->
        anchor =
          testGuard: ->
        spyTestGuard = sinon.spy anchor, 'testGuard'
        transition = RC::Transition.new 'newTransition', anchor,
          guard: 'testGuard'
        transition.testGuard()
        .then ->
          assert spyTestGuard.called, 'Guard method not called'
      .to.not.throw Error
    it 'should get guard with rejects', ->
      expect ->
        anchor =
          testGuard1: ->
        spyTestGuard = sinon.spy anchor, 'testGuard1'
        transition = RC::Transition.new 'newTransition', anchor,
          guard: 'testGuard'
        transition.testGuard()
        .then ->
          throw new Error 'Found unexpected guard'
        .catch (e) ->
          assert.equal e.message, 'Specified guard not found', e.message
        .then ->
          assert.isFalse spyTestGuard.called, 'Guard method was called'
      .to.not.throw Error
  describe '#doAfter', ->
    it 'should get after without rejects', ->
      expect ->
        anchor =
          testAfter: ->
        spyTestAfter = sinon.spy anchor, 'testAfter'
        transition = RC::Transition.new 'newTransition', anchor,
          after: 'testAfter'
        transition.doAfter()
        .then ->
          assert spyTestAfter.called, 'After method not called'
      .to.not.throw Error
    it 'should get after with rejects', ->
      expect ->
        anchor =
          testAfter1: ->
        spyTestAfter = sinon.spy anchor, 'testAfter1'
        transition = RC::Transition.new 'newTransition', anchor,
          after: 'testAfter'
        transition.doAfter()
        .then ->
          throw new Error 'Found unexpected after'
        .catch (e) ->
          assert.equal e.message, 'Specified after not found', e.message
        .then ->
          assert.isFalse spyTestAfter.called, 'After method was called'
      .to.not.throw Error
  describe '#doSuccess', ->
    it 'should get success without rejects', ->
      expect ->
        anchor =
          testSuccess: ->
        spyTestAfter = sinon.spy anchor, 'testSuccess'
        transition = RC::Transition.new 'newTransition', anchor,
          success: 'testSuccess'
        transition.doSuccess()
        .then ->
          assert spyTestAfter.called, 'After method not called'
      .to.not.throw Error
    it 'should get success with rejects', ->
      expect ->
        anchor =
          testSuccess1: ->
        spyTestAfter = sinon.spy anchor, 'testSuccess1'
        transition = RC::Transition.new 'newTransition', anchor,
          success: 'testSuccess'
        transition.doSuccess()
        .then ->
          throw new Error 'Found unexpected success'
        .catch (e) ->
          assert.equal e.message, 'Specified success not found', e.message
        .then ->
          assert.isFalse spyTestAfter.called, 'Success method was called'
      .to.not.throw Error
