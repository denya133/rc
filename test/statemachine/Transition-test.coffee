{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co } = RC::Utils

describe 'Transition', ->
  describe '.new()', ->
    it 'should create new Transition instance', ->
      expect ->
        transition = RC::Transition.new 'newTransition', {}, {}
        assert.instanceOf transition, RC::Transition, 'Cannot instantiate class Transition'
        assert.equal transition.name, 'newTransition'
      .to.not.throw Error
  describe '#testGuard', ->
    it 'should get "guard" without rejects', ->
      expect ->
        anchor =
          testGuard: ->
        spyTestGuard = sinon.spy anchor, 'testGuard'
        transition = RC::Transition.new 'newTransition', anchor,
          guard: 'testGuard'
        transition.testGuard()
        .then ->
          assert.isTrue spyTestGuard.called, '"guard" method not called'
      .to.not.throw Error
    it 'should get "guard" with rejects', ->
      expect ->
        anchor =
          testGuard1: ->
        spyTestGuard = sinon.spy anchor, 'testGuard1'
        transition = RC::Transition.new 'newTransition', anchor,
          guard: 'testGuard'
        transition.testGuard()
        .then ->
          throw new Error 'Found unexpected "guard"'
        .catch (e) ->
          assert.equal e.message, 'Specified "guard" not found', e.message
        .then ->
          assert.isFalse spyTestGuard.called, '"guard" method was called'
      .to.not.throw Error
  describe '#testIf', ->
    it 'should get "if" without rejects', ->
      expect ->
        anchor =
          testIf: ->
        spyTestGuard = sinon.spy anchor, 'testIf'
        transition = RC::Transition.new 'newTransition', anchor,
          if: 'testIf'
        transition.testIf()
        .then ->
          assert spyTestGuard.called, '"if" method not called'
      .to.not.throw Error
    it 'should get "if" with rejects', ->
      expect ->
        anchor =
          testIf1: ->
        spyTestGuard = sinon.spy anchor, 'testIf1'
        transition = RC::Transition.new 'newTransition', anchor,
          if: 'testIf'
        transition.testIf()
        .then ->
          throw new Error 'Found unexpected "if"'
        .catch (e) ->
          assert.equal e.message, 'Specified "if" not found', e.message
        .then ->
          assert.isFalse spyTestGuard.called, '"if" method was called'
      .to.not.throw Error
  describe '#testUnless', ->
    it 'should get "unless" without rejects', ->
      expect ->
        anchor =
          testUnless: ->
        spyTestGuard = sinon.spy anchor, 'testUnless'
        transition = RC::Transition.new 'newTransition', anchor,
          unless: 'testUnless'
        transition.testUnless()
        .then ->
          assert spyTestGuard.called, '"unless" method not called'
      .to.not.throw Error
    it 'should get "unless" with rejects', ->
      expect ->
        anchor =
          testUnless1: ->
        spyTestGuard = sinon.spy anchor, 'testUnless1'
        transition = RC::Transition.new 'newTransition', anchor,
          unless: 'testUnless'
        transition.testUnless()
        .then ->
          throw new Error 'Found unexpected "unless"'
        .catch (e) ->
          assert.equal e.message, 'Specified "unless" not found', e.message
        .then ->
          assert.isFalse spyTestGuard.called, '"unless" method was called'
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
          assert spyTestAfter.called, '"after" method not called'
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
          assert.equal e.message, 'Specified "after" not found', e.message
        .then ->
          assert.isFalse spyTestAfter.called, '"after" method was called'
      .to.not.throw Error
  describe '#doSuccess', ->
    it 'should get success without rejects', ->
      expect ->
        anchor =
          testSuccess: ->
        spyTestSuccess = sinon.spy anchor, 'testSuccess'
        transition = RC::Transition.new 'newTransition', anchor,
          success: 'testSuccess'
        transition.doSuccess()
        .then ->
          assert.isTrue spyTestSuccess.called, '"success" method not called'
      .to.not.throw Error
    it 'should get success with rejects', ->
      expect ->
        anchor =
          testSuccess1: ->
        spyTestSuccess = sinon.spy anchor, 'testSuccess1'
        transition = RC::Transition.new 'newTransition', anchor,
          success: 'testSuccess'
        transition.doSuccess()
        .then ->
          throw new Error 'Found unexpected success'
        .catch (e) ->
          assert.equal e.message, 'Specified "success" not found', e.message
        .then ->
          assert.isFalse spyTestSuccess.called, '"success" method was called'
      .to.not.throw Error
  describe '#doAfter, #doSuccess', ->
    it 'should run "after" before "success"', ->
      expect ->
        anchor =
          testAfter: ->
          testSuccess: ->
        spyTestAfter = sinon.spy anchor, 'testAfter'
        spyTestSuccess = sinon.spy anchor, 'testSuccess'
        transition = RC::Transition.new 'newTransition', anchor,
          after: 'testAfter'
          success: 'testSuccess'
        co ->
          yield transition.doAfter()
          yield transition.doSuccess()
        .then ->
          assert.isTrue spyTestAfter.called, '"after" method not called'
          assert.isTrue spyTestSuccess.calledAfter(spyTestAfter), '"success" not called after "after"'
      .to.not.throw Error
  describe '#testGuard, #doAfter', ->
    it 'should run "after" only if "guard" resolved as true', ->
      expect ->
        anchor =
          test: 'test'
          testGuard: ->
            @test is 'test'
          testAfter: ->
        spyTestAfter = sinon.spy anchor, 'testAfter'
        transition = RC::Transition.new 'newTransition', anchor,
          guard: 'testGuard'
          after: 'testAfter'
        co ->
          if yield transition.testGuard()
            yield transition.doAfter()
        .then ->
          assert.isTrue spyTestAfter.called, '"after" method not called'
      .to.not.throw Error
    it 'should run "after" only if "unless" resolved as false', ->
      expect ->
        anchor =
          test: 'test'
          testUnless: ->
            @test isnt 'test'
          testAfter: ->
        spyTestAfter = sinon.spy anchor, 'testAfter'
        transition = RC::Transition.new 'newTransition', anchor,
          unless: 'testUnless'
          after: 'testAfter'
        co ->
          unless yield transition.testUnless()
            yield transition.doAfter()
        .then ->
          assert.isTrue spyTestAfter.called, '"after" method not called'
      .to.not.throw Error
