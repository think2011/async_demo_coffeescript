###
  对集合中的每一个元素都执行异步操作，得到结果，所以结果汇集到callback。
  与each不同的是，each关心过程，而map关系结果。

  提供两种方式：
  1. 并行执行。对所有元素进行操作，结果汇集到callback，出错则停止，返回已完成，未执行的占据空位。
  2. 顺序执行。对集合中的元素一个个执行，结果汇集到callback，出错则停止，返回已完成，未执行的忽略。
###
async  = require 'async'
helper = require './helper'
log    = helper.log
arr    = [
  {name: 'Jack', delay: 300}
  {name: 'Mike', delay: 200}
  {name: 'jason', delay: 100}
  {name: 'lisa', delay: 50}
]


# 所有操作均正常执行，未出错，所有结果按元素顺序汇集到callback
# 1.1
async.map arr, (item, callback) ->
  log "1.1 enter: #{item.name}"
  setTimeout ->
    log "1.1 handle：#{item.name}"
    callback null, "#{item.name}!!!"
  , item.delay
, (err, results) ->
  log '1.1 err:', err
  log '1.1 results:', results


# 如果出错，终止并将已执行完的结果汇集给callback，未执行的占据空位。
# 1.2
async.map arr, (item, callback) ->
  log "1.2 enter: #{item.name}"
  setTimeout ->
    log "1.2 handle：#{item.name}"

    if item.name is 'jason'
      callback 'err'
    else
      callback null, "#{item.name}!!!"
  , item.delay
, (err, results) ->
  log '1.2 err:', err
  log '1.2 results:', results


# 顺序执行完一个，下一个才执行。
# 1.3
async.mapSeries arr, (item, callback) ->
  log "1.3 enter: #{item.name}"
  setTimeout ->
    log "1.3 handle：#{item.name}"
    callback null, "#{item.name}!!!"
  , item.delay
, (err, results) ->
  log '1.3 err:', err
  log '1.3 results:', results


# 顺序执行出错，将错误和执行完的结果传到callback，未执行的忽略。
# 1.4
async.mapSeries arr, (item, callback) ->
  log "1.4 enter: #{item.name}"
  setTimeout ->
    log "1.4 handle：#{item.name}"

    if item.name is 'jason'
      callback 'err'
    else
      callback null, "#{item.name}!!!"
  , item.delay
, (err, results) ->
  log '1.4 err:', err
  log '1.4 results:', results


# 并行执行，最多同时2条，传给最终callback
# 1.5
async.mapLimit arr, 2, (item, callback) ->
  log "1.5 enter: #{item.name}"
  setTimeout ->
    log "1.5 handle：#{item.name}"

    if item.name is 'jason'
      callback 'err'
    else
      callback null, "#{item.name}!!!"
  , item.delay
, (err, results) ->
  log '1.5 err:', err
  log '1.5 results:', results

