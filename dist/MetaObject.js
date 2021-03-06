// Generated by CoffeeScript 2.5.1
(function() {
  // This file is part of RC.

  // RC is free software: you can redistribute it and/or modify
  // it under the terms of the GNU Lesser General Public License as published by
  // the Free Software Foundation, either version 3 of the License, or
  // (at your option) any later version.

  // RC is distributed in the hope that it will be useful,
  // but WITHOUT ANY WARRANTY; without even the implied warranty of
  // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  // GNU Lesser General Public License for more details.

  // You should have received a copy of the GNU Lesser General Public License
  // along with RC.  If not, see <https://www.gnu.org/licenses/>.
  var hasProp = {}.hasOwnProperty;

  module.exports = function(RC) {
    RC.prototype.MetaObject = (function() {
      var iphData, ipoParent, ipoTarget;

      class MetaObject {
        constructor(target, parent) {
          var key, ref;
          this[ipoTarget] = target;
          this[ipoParent] = parent;
          this[iphData] = {};
          ref = parent != null ? parent.data : void 0;
          for (key in ref) {
            if (!hasProp.call(ref, key)) continue;
            this[iphData][key] = {};
          }
        }

      };

      iphData = Symbol.for('~data');

      ipoParent = Symbol.for('~parent');

      ipoTarget = Symbol.for('~target');

      Reflect.defineProperty(MetaObject.prototype, 'data', {
        get: function() {
          return this[iphData];
        }
      });

      Reflect.defineProperty(MetaObject.prototype, 'parent', {
        get: function() {
          return this[ipoParent];
        },
        set: function(newParent) {
          this[ipoParent] = newParent;
          return newParent;
        }
      });

      Reflect.defineProperty(MetaObject.prototype, 'target', {
        get: function() {
          return this[ipoTarget];
        }
      });

      Reflect.defineProperty(MetaObject.prototype, 'addMetaData', {
        value: function(asGroup, asKey, ahMetaData) {
          var base;
          if ((base = this[iphData])[asGroup] == null) {
            base[asGroup] = {};
          }
          Reflect.defineProperty(this[iphData][asGroup], asKey, {
            configurable: true,
            enumerable: true,
            value: ahMetaData
          });
        }
      });

      Reflect.defineProperty(MetaObject.prototype, 'appendMetaData', {
        value: function(asGroup, asKey, ahMetaData) {
          var base, list;
          if ((base = this[iphData])[asGroup] == null) {
            base[asGroup] = {};
          }
          if ((list = this[iphData][asGroup][asKey]) != null) {
            list.push(ahMetaData);
          } else {
            list = [ahMetaData];
            Reflect.defineProperty(this[iphData][asGroup], asKey, {
              configurable: true,
              enumerable: true,
              value: list
            });
          }
        }
      });

      Reflect.defineProperty(MetaObject.prototype, 'removeMetaData', {
        value: function(asGroup, asKey) {
          if (this[iphData][asGroup] != null) {
            Reflect.deleteProperty(this[iphData][asGroup], asKey);
          }
        }
      });

      Reflect.defineProperty(MetaObject.prototype, 'collectGroup', {
        value: function(asGroup, collector = []) {
          var ref, ref1, ref2;
          collector = collector.concat((ref = (ref1 = this[ipoParent]) != null ? typeof ref1.collectGroup === "function" ? ref1.collectGroup(asGroup, collector) : void 0 : void 0) != null ? ref : []);
          collector.push((ref2 = this[iphData][asGroup]) != null ? ref2 : {});
          return collector;
        }
      });

      Reflect.defineProperty(MetaObject.prototype, 'getGroup', {
        value: function(asGroup, abDeep = true) {
          var assign, vhGroup;
          assign = abDeep ? RC.prototype.assign : Object.assign;
          vhGroup = assign({}, ...(this.collectGroup(asGroup)));
          return vhGroup;
        }
      });

      Reflect.defineProperty(MetaObject.prototype, 'getOwnGroup', {
        value: function(asGroup) {
          var ref;
          return (ref = this[iphData][asGroup]) != null ? ref : {};
        }
      });

      return MetaObject;

    }).call(this);
    return RC.prototype.MetaObject;
  };

}).call(this);
