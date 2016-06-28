--
-- Author: Your Name
-- Date: 2016-06-21 10:32:09
--
require('init')

local event = {print=function( ... )
	print(...)
end}
local register_eventname = 'Print'
local args = {1, 2, 'one', 'two'}
local sub_func = function(...)
	local args = {...}
	for i,v in ipairs(args) do
		print(i,v)
	end
end

local listener = EventListener.new()
console_colorful('normal register')
print(listener:register(register_eventname, event.print))
console_colorful('active register')
listener:activate(register_eventname, table.unpack(args))

console_colorful('normal register will fail for duplicated key')
print(listener:register(register_eventname, event.print))
console_colorful('force register will success anyway')
print(listener:subregister(register_eventname, sub_func))
console_colorful('active register')
listener:activate(register_eventname, table.unpack(args))

console_colorful('unregister')
print(listener:unregister(register_eventname))
console_colorful('unregister will fail for key not found')
print(listener:unregister(register_eventname))
console_colorful('active register will fail for key not found')
listener:activate(register_eventname, table.unpack(args))

console_colorful('force register')
print(listener:subregister(register_eventname, sub_func))
console_colorful('active register')
listener:activate(register_eventname, table.unpack(args))

console_colorful('cleanup register')
listener:cleanup()
console_colorful('active register will fail for key not found')
listener:activate(register_eventname, table.unpack(args))