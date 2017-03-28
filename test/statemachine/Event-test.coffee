{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co } = RC::Utils

describe 'Event', ->
  describe '.new()', ->
    it 'should create new Event instance', ->
      expect ->
        event = RC::Event.new 'newEvent'
        assert.instanceOf event, RC::Event, 'Cannot instantiate class Event'
        assert.equal event.name, 'newEvent'
      .to.not.throw Error
  describe '#testGuard', ->
    it 'should get "guard" without rejects', ->
      expect ->
        anchor =
          testGuard: ->
        spyTestGuard = sinon.spy anchor, 'testGuard'
        event = RC::Event.new 'newEvent', anchor,
          guard: 'testGuard'
        event.testGuard()
        .then ->
          assert.isTrue spyTestGuard.called, '"guard" method not called'
      .to.not.throw Error
    it 'should get "guard" with rejects', ->
      expect ->
        anchor =
          testGuard1: ->
        spyTestGuard = sinon.spy anchor, 'testGuard1'
        event = RC::Event.new 'newEvent', anchor,
          guard: 'testGuard'
        event.testGuard()
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
        event = RC::Event.new 'newEvent', anchor,
          if: 'testIf'
        event.testIf()
        .then ->
          assert spyTestGuard.called, '"if" method not called'
      .to.not.throw Error
    it 'should get "if" with rejects', ->
      expect ->
        anchor =
          testIf1: ->
        spyTestGuard = sinon.spy anchor, 'testIf1'
        event = RC::Event.new 'newEvent', anchor,
          if: 'testIf'
        event.testIf()
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
        event = RC::Event.new 'newEvent', anchor,
          unless: 'testUnless'
        event.testUnless()
        .then ->
          assert spyTestGuard.called, '"unless" method not called'
      .to.not.throw Error
    it 'should get "unless" with rejects', ->
      expect ->
        anchor =
          testUnless1: ->
        spyTestGuard = sinon.spy anchor, 'testUnless1'
        event = RC::Event.new 'newEvent', anchor,
          unless: 'testUnless'
        event.testUnless()
        .then ->
          throw new Error 'Found unexpected "unless"'
        .catch (e) ->
          assert.equal e.message, 'Specified "unless" not found', e.message
        .then ->
          assert.isFalse spyTestGuard.called, '"unless" method was called'
      .to.not.throw Error
  describe '#doAfter', ->
    it 'should get "after" without rejects', ->
      expect ->
        anchor =
          testAfter: ->
        spyTestAfter = sinon.spy anchor, 'testAfter'
        event = RC::Event.new 'newEvent', anchor,
          after: 'testAfter'
        event.doAfter()
        .then ->
          assert spyTestAfter.called, '"after" method not called'
      .to.not.throw Error
    it 'should get "after" with rejects', ->
      expect ->
        anchor =
          testAfter1: ->
        spyTestAfter = sinon.spy anchor, 'testAfter1'
        event = RC::Event.new 'newEvent', anchor,
          after: 'testAfter'
        event.doAfter()
        .then ->
          throw new Error 'Found unexpected after'
        .catch (e) ->
          assert.equal e.message, 'Specified "after" not found', e.message
        .then ->
          assert.isFalse spyTestAfter.called, '"after" method was called'
      .to.not.throw Error
  describe '#doBefore', ->
    it 'should get "before" without rejects', ->
      expect ->
        anchor =
          testBefore: ->
        spyTestBefore = sinon.spy anchor, 'testBefore'
        event = RC::Event.new 'newEvent', anchor,
          before: 'testBefore'
        event.doBefore()
        .then ->
          assert.isTrue spyTestBefore.called, '"before" method not called'
      .to.not.throw Error
    it 'should get "before" with rejects', ->
      expect ->
        anchor =
          testBefore1: ->
        spyTestBefore = sinon.spy anchor, 'testBefore1'
        event = RC::Event.new 'newEvent', anchor,
          before: 'testBefore'
        event.doBefore()
        .then ->
          throw new Error 'Found unexpected before'
        .catch (e) ->
          assert.equal e.message, 'Specified "before" not found', e.message
        .then ->
          assert.isFalse spyTestBefore.called, '"before" method was called'
      .to.not.throw Error
  describe '#doBefore, #doAfter', ->
    it 'should run "before" before "after"', ->
      expect ->
        anchor =
          testBefore: ->
          testAfter: ->
        spyTestBefore = sinon.spy anchor, 'testBefore'
        spyTestAfter = sinon.spy anchor, 'testAfter'
        event = RC::Event.new 'newEvent', anchor,
          before: 'testBefore'
          after: 'testAfter'
        co ->
          yield event.doBefore()
          yield event.doAfter()
        .then ->
          assert.isTrue spyTestBefore.called, '"before" method not called'
          assert.isTrue spyTestAfter.calledAfter(spyTestBefore), '"after" not called after "before"'
      .to.not.throw Error
  describe '#testGuard, #doAfter, #doError', ->
    it 'should run "after" only if "guard" resolved as true', ->
      expect ->
        anchor =
          test: 'test'
          testGuard: ->
            @test is 'test'
          testAfter: ->
          testError: ->
        spyTestAfter = sinon.spy anchor, 'testAfter'
        spyTestError = sinon.spy anchor, 'testError'
        event = RC::Event.new 'newEvent', anchor,
          guard: 'testGuard'
          after: 'testAfter'
          error: 'testError'
        co ->
          try
            if yield event.testGuard()
              yield event.doAfter()
            throw new Error 'test'
          catch e
            yield event.doError e
        .then ->
          assert.isTrue spyTestAfter.called, '"after" method not called'
          assert.isTrue spyTestError.called, '"error" method not called'
      .to.not.throw Error
    it 'should run "after" only if "unless" resolved as false', ->
      expect ->
        anchor =
          test: 'test'
          testUnless: ->
            @test isnt 'test'
          testAfter: ->
          testError: ->
        spyTestAfter = sinon.spy anchor, 'testAfter'
        spyTestError = sinon.spy anchor, 'testError'
        event = RC::Event.new 'newEvent', anchor,
          unless: 'testUnless'
          after: 'testAfter'
          error: 'testError'
        co ->
          try
            unless yield event.testUnless()
              yield event.doAfter()
            throw new Error 'test'
          catch e
            yield event.doError e
        .then ->
          assert.isTrue spyTestAfter.called, '"after" method not called'
          assert.isTrue spyTestError.called, '"error" method not called'
      .to.not.throw Error
