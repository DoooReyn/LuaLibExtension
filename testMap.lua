--
-- Author: Reyn
-- Date: 2016-06-18 18:17:56
--

require('init')

console_colorful('m1 start')
local m1 = Map()
print(m1:map('a', 1))
print(m1:replace('a', 10))
m1.serial()
print(m1:map('b', 2))
print(m1:unmap('a'))
m1.serial()
print(m1:map('b', 10))
print(m1:unmap('a'))
print("m1.map() = ", m1:get())
print(m1:get().b)
m1:get().b = 'b'
print(m1:get().b)
-- console_colorful('m2 start')
-- local m2 = Map({a=1, b=2})
-- m2.serial()
-- print(m2:replace('a', 10))
-- m2.serial()
-- print(m2:map('b', 2))
-- print(m2:unmap('a'))
-- m2.serial()
-- print(m2:map('b', 10))
-- print(m2:unmap('a'))