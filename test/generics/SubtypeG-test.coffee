{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  TypeT
  SymbolT
  SubtypeG
  NotSampleG
} = RC::

describe 'SubtypeG', ->
  describe 'create new subtype', ->
    cucumber = Symbol 'cucumber'
    predicate = (x)-> x is cucumber
    name = 'CucumberT'
    displayName = "{SymbolT | #{name}}"
    CucumberT = SubtypeG SymbolT, name, predicate
    it 'check unique symbol', ->
      expect ->
        CucumberT cucumber
      .to.not.throw TypeError
    it 'check type of new Type', ->
      expect ->
        TypeT CucumberT
      .to.not.throw TypeError
    it 'check name of new Type', ->
      expect CucumberT.name
      .to.equal name
    it 'check displayName of new Type', ->
      expect CucumberT.displayName
      .to.equal displayName
    it 'check meta of new Type', ->
      expect CucumberT.meta
      .to.deep.equal {
        kind: 'subtype'
        type: SymbolT
        name: displayName
        predicate: predicate
        identity: yes
      }
    it 'check isNotSample of new Type', ->
      expect CucumberT.isNotSample
      .to.deep.equal NotSampleG CucumberT
