###
  此文件用于配合async demo测试。
###
moment = require 'moment'

exports.inc = (n, callback, timeout = 200) ->
  # 将 参数n 自增1后，返回给async
  setTimeout ->
    callback null, n+1
  , timeout


exports.fire = (obj, callback, timeout = 200) ->
  # 将 obj 返回给async
  setTimeout ->
    callback null, obj
  , timeout


exports.err = (errMsg, callback, timeout = 200) ->
  # 模拟一个错误，返回给async
  setTimeout ->
    callback errMsg
  , timeout


# utils
exports.log = (msg, obj) ->
  # 对console.log的封装，增加了秒钟的输出，通过秒数的差值方便大家对async的理解。
  process.stdout.write "#{moment().format('ss.SSS')}>"
  if obj?
    process.stdout.write msg
    console.log obj
  else
    console.log msg


exports.wait = (mils) ->
  #刻意等待mils的时间，mils的单位是毫秒。
  now = new Date
  return while new Date - now <= mils


