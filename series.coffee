###
  串行执行，每个函数执行完毕后才执行下一个函数。

  任何一个函数出错，后面的将不再执行，错误和已执行完完毕的函数会传到最终callback
  支持json方式传入tasks，最终callback的结果也会是对应callback形式。
###
async  = require 'async'
helper = require './helper'
log    = helper.log


# 每个函数依次执行执行后，结果会传到最终callback
# 1.1
async.series [
  (callback) -> helper.inc 10, callback
  (callback) -> helper.inc 20, callback
  (callback) -> helper.inc 30, callback
], (err, results) ->
  log '1.1 err:', err
  log '1.1 results:', results


# 中途有函数出错，之后的不再执行，已完成的会随错误一起传到最终callback
# 1.2
async.series [
  (callback) -> helper.inc 10, callback
  (callback) -> helper.inc 20, callback
  (callback) -> helper.err '出错了', callback
  (callback) -> helper.inc 40, callback
], (err, results) ->
  log '1.2 err:', err
  log '1.2 results:', results


# 如果某个函数传的是undefined，null,{},[]等，也依旧会按原样传给最终callback
# 1.3
async.series [
  (callback) -> helper.fire 10, callback
  (callback) -> helper.fire undefined, callback
  (callback) -> helper.fire null, callback
  (callback) -> helper.fire {}, callback
  (callback) -> helper.fire [], callback
  (callback) -> helper.fire 'abc', callback
], (err, results) ->
  log '1.3 err:', err
  log '1.3 results:', results


# 已json的形式传入tasks，结果会保持一致的形式。
# 1.4
async.series
  a: (callback) -> helper.fire 10, callback
  b: (callback) -> helper.fire 20, callback
  c: (callback) -> helper.fire 30, callback
  d: (callback) -> helper.fire 40, callback
  e: (callback) -> helper.fire 50, callback
, (err, results) ->
  log '1.4 err:', err
  log '1.4 results:', results


# 当json形式的函数出错时，终止其他函数，失败的传入undefined，其他忽略。
# 1.5
async.series
  a: (callback) -> helper.fire 10, callback
  b: (callback) -> helper.err '出错了', callback
  c: (callback) -> helper.err '出错了', callback
  d: (callback) -> helper.err '出错了', callback
  e: (callback) -> helper.err '出错了', callback
  f: (callback) -> helper.fire 60, callback
, (err, results) ->
  log '1.5 err:', err
  log '1.5 results:', results



#07.238>1.1 err:
#07.238>1.1 results:[ 11, 21, 31 ]

#07.239>1.2 err:出错了
#07.239>1.2 results:[ 11, 21, undefined ]

#07.841>1.3 err:
#07.841>1.3 results:[ 10, undefined, null, {}, [], 'abc' ]

#07.641>1.4 err:
#07.641>1.4 results:{ a: 10, b: 20, c: 30, d: 40, e: 50 }

#07.032>1.5 err:出错了
#07.037>1.5 results:{ a: 10, b: undefined }