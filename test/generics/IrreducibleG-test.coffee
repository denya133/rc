{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  TypeT
  IrreducibleG
  NotSampleG
  Utils: { isSubsetOf }
} = RC::

describe 'IrreducibleG', ->
  describe 'create new Type', ->
    it 'check unique symbol', ->
      expect ->
        tomato = Symbol 'tomato'
        TomatoT = IrreducibleG 'TomatoT', (x)-> x is tomato
        TomatoT tomato
      .to.not.throw TypeError
    it 'check type of new Type', ->
      expect ->
        tomato = Symbol 'tomato'
        TomatoT = IrreducibleG 'TomatoT', (x)-> x is tomato
        TypeT TomatoT
      .to.not.throw TypeError
    it 'check name of new Type', ->
      tomato = Symbol 'tomato'
      TomatoT = IrreducibleG 'TomatoT', (x)-> x is tomato
      expect TomatoT.name
      .to.equal 'TomatoT'
    it 'check displayName of new Type', ->
      tomato = Symbol 'tomato'
      TomatoT = IrreducibleG 'TomatoT', (x)-> x is tomato
      expect TomatoT.displayName
      .to.equal 'TomatoT'
    it 'check is of new Type', ->
      tomato = Symbol 'tomato'
      predicate = (x)-> x is tomato
      TomatoT = IrreducibleG 'TomatoT', predicate
      expect TomatoT.is
      .to.equal predicate
    it 'check meta of new Type', ->
      tomato = Symbol 'tomato'
      predicate = (x)-> x is tomato
      TomatoT = IrreducibleG 'TomatoT', predicate
      expect TomatoT.meta
      .to.deep.equal {
        kind: 'irreducible'
        name: 'TomatoT'
        predicate: predicate
        identity: yes
      }
    it 'check isNotSample of new Type', ->
      tomato = Symbol 'tomato'
      predicate = (x)-> x is tomato
      TomatoT = IrreducibleG 'TomatoT', predicate
      expect isSubsetOf(TomatoT.isNotSample, NotSampleG TomatoT)
      .to.be.true
