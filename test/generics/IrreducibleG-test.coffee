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
      expect TomatoT.is tomato
      .to.be.true
    it 'check meta of new Type', ->
      tomato = Symbol 'tomato'
      predicate = (x)-> x is tomato
      TomatoT = IrreducibleG 'TomatoT', predicate
      expect TomatoT.meta.kind
      .to.equal 'irreducible'
      expect TomatoT.meta.name
      .to.equal 'TomatoT'
      expect TomatoT.meta.identity
      .to.be.true
    it 'check isNotSample of new Type', ->
      tomato = Symbol 'tomato'
      predicate = (x)-> x is tomato
      TomatoT = IrreducibleG 'TomatoT', predicate
      expect isSubsetOf(TomatoT.isNotSample, NotSampleG TomatoT)
      .to.be.true
