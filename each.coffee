###
  对同一个集合中的所有元素都执行同一个异步操作

  async提供了三种方式
  1. 集合中所有的元素并行执行
  2. 一个一个顺序执行
  3. 分批执行，同一批内并行，批与批之间按顺序

  如果出错，错误将传到最终callback，其他已经启动的任务继续执行，未启动的忽略。
###
async  = require 'async'
helper = require './helper'
log    = helper.log


arr = [
  {name: '小明', delay: 100}
  {name: '小华', delay: 200}
  {name: '小红', delay: 300}
]


# 所有操作并行，最终callback的err为undefined，注意：最终callback仅有err一个参数
# 1.1
async.each arr, (item, callback) ->
  log "1.1 enter: #{item.name}"
  setTimeout ->
    log "1.1 handle: #{item.name}"
    callback null, item.name
  , item.delay
, (err) ->
  log '1.1 err:', err


# 如果出错，则出错后马上调用最终callback，其他未执行完的任务继续执行
# 1.2
async.each arr, (item, callback) ->
  log "1.2 enter: #{item.name}"
  setTimeout ->
    log "1.2 handle: #{item.name}"
    callback 'err' if item.name is '小华'

  , item.delay
, (err) ->
  log '1.2 err:', err


# 与each类似，但不是并行，而是一个一个按顺序执行
# 1.3
async.eachSeries arr, (item, callback) ->
  log "1.3 enter: #{item.name}"
  setTimeout ->
    log "1.3 handle: #{item.name}"
    callback null, item.name

  , item.delay
, (err) ->
  log '1.3 err:', err


# 如果出错，则马上将错误传给最终callback，未执行的不再执行。
# 1.4
async.eachSeries arr, (item, callback) ->
  log "1.4 enter: #{item.name}"
  setTimeout ->
    log "1.4 handle: #{item.name}"
    callback 'err' if item.name is '小华'

  , item.delay
, (err) ->
  log '1.4 err:', err


# 分批执行，第二个参数是每一批的个数，每一批内并行执行，但批与批之间按顺序。
# 1.5
async.eachLimit arr, 2, (item, callback) ->
  log "1.5 enter: #{item.name}"
  setTimeout ->
    log "1.5 handle: #{item.name}"
    callback null ,item.name

  , item.delay
, (err) ->
  log '1.5 err:', err


# 如果中途出错，错误马上传给最终callba，同一批中未完成的继续，但下一批不再执行。
# 1.6
async.eachLimit arr, 2, (item, callback) ->
  log "1.6 enter: #{item.name}"
  setTimeout ->
    log "1.6 handle: #{item.name}"
    callback 'err' if item.name is '小华'

  , item.delay
, (err) ->
  log '1.6 err:', err



#38.762>1.1 enter: 小明
#38.765>1.1 enter: 小华
#38.765>1.1 enter: 小红
#38.877>1.1 handle: 小明
#38.967>1.1 handle: 小华
#39.079>1.1 handle: 小红
#39.079>1.1 err:

#21.457>1.2 enter: 小明
#21.461>1.2 enter: 小华
#21.461>1.2 enter: 小红
#21.568>1.2 handle: 小明
#21.675>1.2 handle: 小华
#21.675>1.2 err:err
#21.771>1.2 handle: 小红

#03.528>1.3 enter: 小明
#03.645>1.3 handle: 小明
#03.645>1.3 enter: 小华
#03.847>1.3 handle: 小华
#03.847>1.3 enter: 小红
#04.156>1.3 handle: 小红
#04.156>1.3 err:

#50.077>1.4 enter: 小明
#50.193>1.4 handle: 小明

#34.382>1.5 enter: 小明
#34.386>1.5 enter: 小华
#34.487>1.5 handle: 小明
#34.487>1.5 enter: 小红
#34.594>1.5 handle: 小华
#34.799>1.5 handle: 小红
#34.799>1.5 err:

#56.609>1.6 enter: 小明
#56.612>1.6 enter: 小华
#56.720>1.6 handle: 小明
#56.814>1.6 handle: 小华
#56.814>1.6 err:err