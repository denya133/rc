{ expect, assert } = require 'chai'
RC = require '../../lib'
{
  Mixin
} = RC::

describe 'Mixin', ->
  describe 'create new mixin', ->
    TomatoMixin = Mixin 'TomatoMixin', (x)-> x
    it 'check mixin definition', ->
      s = Symbol('s')
      expect TomatoMixin(s)
      .to.equal s
    it 'check name of new mixin', ->
      expect TomatoMixin.name
      .to.equal 'TomatoMixin'
    it 'check displayName of new mixin', ->
      expect TomatoMixin.displayName
      .to.equal 'TomatoMixin'
    it 'check meta of new mixin', ->
      expect TomatoMixin.meta
      .to.deep.equal {
        kind: 'mixin'
        name: 'TomatoMixin'
        identity: yes
      }
    it 'check meta of Mixin', ->
      expect Mixin.meta
      .to.deep.equal {
        kind: 'generic'
        name: 'Mixin'
        identity: yes
      }
