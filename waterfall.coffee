###
  按顺序依次执行函数，每个函数产生的值，都传个下一个。
  如果出错，中断操作，错误信息传到最终的callback，之前的结果也一并被丢弃。
###
async  = require 'async'
helper = require './helper'
log    = helper.log

# 1.1
async.waterfall [
  (callback) -> callback null, 10
  (data, callback) -> helper.inc data, callback
  (data, callback) -> helper.inc data, callback
], (err, result) ->
  log '1.1 err:', err
  log '1.1 result:', result


# 如果中途出错，直接传送err，结果被丢弃，后续的函数也终止
# 1.2
async.waterfall [
  (callback) -> callback null, 10
  (data, callback) -> helper.inc data, callback
  (data, callback) -> helper.err '出错了', callback
  (data, callback) -> helper.fire data, callback
], (err, result) ->
  log '1.2 err:', err
  log '1.2 result:', result


# 不支持json形式传入到tasks,结果无法执行
# 1.3
async.waterfall
  a: (callback) -> callback null, 10
  b: (data, callback) -> helper.inc data, callback
  c: (data, callback) -> helper.err '出错了', callback
, (err, result) ->
  log '1.3 err:', err
  log '1.3 result:', result


#35.385>1.1 err:
#35.385>1.1 result:12
#
#35.385>1.2 err:出错了
#35.386>1.2 result:
#
#34.979>1.3 err:[Error: First argument to waterfall must be an array of functions]
#34.984>1.3 result: