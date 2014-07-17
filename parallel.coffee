###
  并行执行多个函数，每个函数都是立即执行的，最终传给callback的数组中的数据按照tasks中声明的顺序，而不是执行完成的顺序。

  如果某个函数出错，则立即将 err 和 执行完的函数结果传给callback，未执行完的函数则占据对应的位置，无结果。
  同时支持json形式的tasks，所以对应callback也会是json。
###
async  = require 'async'
helper = require './helper'
log    = helper.log


# 并行执行函数，每个函数的返回值按声明顺序汇成数组，传给callback
# 1.1
async.parallel [
  (callback) -> helper.fire 'a400', callback, 400
  (callback) -> helper.fire 'a200', callback, 200
  (callback) -> helper.fire 'a300', callback, 300
], (err, results) ->
  log '1.1 err:', err
  log '1.1 results:', results