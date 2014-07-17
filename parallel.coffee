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


# 如果中途有个函数出错，则将该err和已经完成的函数值汇成一个数组，传给最终的callback。
# 1.2
async.parallel [
  (callback) -> helper.fire 'a400', callback, 400
  (callback) -> helper.err 'a200', callback, 200
  (callback) -> helper.fire 'a100', callback, 100
], (err, results) ->
  log '1.2 err:', err
  log '1.2 results:', results


# 以json的形式传入tasks，results也会是json
# 1.3
async.parallel
  a: (callback) -> helper.fire 'a400', callback, 400
  b: (callback) -> helper.fire 'a300', callback, 300
, (err, results) ->
  log '1.3 err:', err
  log '1.3 results:', results


# 如果中途出错，未完成的不会出现在results中。
# 1.4
async.parallel
  a: (callback) -> helper.fire 'a400', callback, 400
  b: (callback) -> helper.err 'a300', callback, 300
  c: (callback) -> helper.fire 'a100', callback, 100
, (err, results) ->
  log '1.4 err:', err
  log '1.4 results:', results


# 并行执行，但设置最多 N 个函数并行。
# 1.5
async.parallelLimit
  a: (callback) -> helper.fire 'a400', callback, 400
  b: (callback) -> helper.fire 'a300', callback, 300
  c: (callback) -> helper.fire 'a100', callback, 100
  d: (callback) -> helper.fire 'a200', callback, 200
, 2, (err, results) ->
  log '1.5 err:', err
  log '1.5 results:', results


#54.557>1.1 err:
#54.557>1.1 results:[ 'a400', 'a200', 'a300' ]

#54.363>1.2 err:a200
#54.368>1.2 results:[ , undefined, 'a100' ]

#54.557>1.3 err:
#54.557>1.3 results:{ b: 'a300', a: 'a400' }

#54.464>1.4 err:a300
#54.464>1.4 results:{ c: 'a100', b: undefined }

#54.769>1.5 err:
#54.769>1.5 results:{ b: 'a300', a: 'a400', c: 'a100', d: 'a200' }