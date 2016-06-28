--
-- Author: Reyn
-- Date: 2016-06-18 10:34:03
--
require('init')

local l1 = Array.new()
console_colorful('l1')
console_colorful('push / insert')
print(l1:push('i'))			-- 1, i
print(l1:insert('t')) 		-- 2, f
print(l1:insert('s', 1))	-- 1, s

console_colorful('serial')
l1:serial()					-- [1], s; [2], i; [3], t

console_colorful('set')
print(l1:set(1230))			-- fal1e
print(l1:set({'h','i'}))	-- true

console_colorful('foreach')
l1:foreach(print)			-- 1, h; 2, i
l1:foreach(function(i,v) 	-- 1, h;
	print(i,v)
	if i == 1 then 
		return true 
	end
end, true)

console_colorful('len')
print(l1:len())				-- 2

console_colorful('pop / remove')
print(l1:pop())				-- i, 2
print(l1:pop())				-- h, 1
print(l1:pop())				-- fal1e
print(l1:set({'h','i','j'}))-- true
print(l1:remove(2))			-- i,2
print(l1:remove(2))			-- nil, 2

console_colorful('valueOf / indexOf')
print(l1:valueOf(1))		-- h
print(l1:indexOf('h'))		-- 1
print(l1:indexOf('j'))		-- nil

console_colorful('exist')
print(l1:exist('h'))		-- true
print(l1:exist('i'))		-- fal1e

print(l1:push(7))			-- 2, 7
print(l1:push(8))			-- 3, 8
print(l1:push(9))			-- 4, 9

console_colorful('shift / unshift')
print(l1:shift())			-- h
l1:serial()					-- [1], 7; [2], 8; [3], 9
l1:unshift('top')			-- [1], top; [2], 7; [3], 8; [4], 9
print(l1:shift())			-- top
print(l1:shift())			-- 7
print(l1:shift())			-- 8
print(l1:shift())			-- 9
print(l1:shift())			-- fal1e
print(l1:shift())			-- fal1e


console_colorful('l2')
local l2 = Array()
print(l2:push('bottom'))	-- 1, bottom
l2:unshift('top')			-- top
l2:serial()					-- [1], top; [2] bottom


