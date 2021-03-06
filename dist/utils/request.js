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
  module.exports = function(RC) {
    var request;
    RC.util({
      request: request = function(asMethod, asUrl, ahOptions = {}) {
        var _, isArangoDB;
        ({_, isArangoDB} = RC.prototype.Utils);
        if (!asUrl) {
          asUrl = asMethod;
          asMethod = 'GET';
        }
        return RC.prototype.Promise.new(function(resolve, reject) {
          var arangoRequest, needle, ref, ref1, ref2, result, vhOptions;
          if (ahOptions.headers == null) {
            ahOptions.headers = {};
          }
          if (!((ahOptions.headers['Accept'] != null) || (ahOptions.headers['accept'] != null))) {
            ahOptions.headers['Accept'] = '*/*';
          }
          if (isArangoDB()) {
            // Is ArangoDB !!!
            arangoRequest = require('@arangodb/request');
            vhOptions = _.assign({}, ahOptions, {
              method: asMethod,
              url: asUrl
            });
            if (vhOptions.follow > 0 || vhOptions.follow_max > 0) {
              if (vhOptions.followRedirect == null) {
                vhOptions.followRedirect = true;
              }
              if (vhOptions.maxRedirects == null) {
                vhOptions.maxRedirects = Number((ref = vhOptions.follow) != null ? ref : vhOptions.follow_max);
              }
            } else {
              if (vhOptions.followRedirect == null) {
                vhOptions.followRedirect = false;
              }
            }
            delete vhOptions.follow;
            delete vhOptions.follow_max;
            result = arangoRequest(vhOptions);
            resolve({
              body: result.body,
              headers: result.headers,
              status: result.statusCode,
              message: result.message
            });
          } else {
            // Is Node.js !!!
            needle = require('needle');
            vhOptions = _.assign({}, ahOptions, {
              method: asMethod,
              url: asUrl
            });
            if (vhOptions.followRedirect) {
              if (vhOptions.follow_max == null) {
                vhOptions.follow_max = (ref1 = vhOptions.maxRedirects) != null ? ref1 : 10;
              }
            }
            delete vhOptions.maxRedirects;
            delete vhOptions.followRedirect;
            needle.request(asMethod, asUrl, (ref2 = vhOptions.body) != null ? ref2 : vhOptions.form, vhOptions, function(err, res) {
              if (err != null) {
                resolve({
                  body: void 0,
                  headers: {},
                  status: 500,
                  message: err.message
                });
              } else {
                resolve({
                  body: res.body,
                  headers: res.headers,
                  status: res.statusCode,
                  message: res.statusMessage
                });
              }
            });
          }
        });
      }
    });
    request.head = function(asUrl, ahOptions = {}) {
      return request('HEAD', asUrl, ahOptions);
    };
    request.options = function(asUrl, ahOptions = {}) {
      return request('OPTIONS', asUrl, ahOptions);
    };
    request.get = function(asUrl, ahOptions = {}) {
      return request('GET', asUrl, ahOptions);
    };
    request.post = function(asUrl, ahOptions = {}) {
      return request('POST', asUrl, ahOptions);
    };
    request.put = function(asUrl, ahOptions = {}) {
      return request('PUT', asUrl, ahOptions);
    };
    request.patch = function(asUrl, ahOptions = {}) {
      return request('PATCH', asUrl, ahOptions);
    };
    request.delete = function(asUrl, ahOptions = {}) {
      return request('DELETE', asUrl, ahOptions);
    };
    return request;
  };

}).call(this);
