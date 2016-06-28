--
-- Author: Your Name
-- Date: 2016-06-21 10:22:02
--
local EventListener = class('EventListener')
local Constant = {
	EventPool = 'EventPool',
}

-- 事件池产生器
local function pool_generator()
	local pool = require('ext.event.EventPool').new()
	return function()
		return pool
	end
end
local _pool = pool_generator()()


function EventListener:ctor()
	_pool:empty()
end

-- 获得事件池的拷贝
function EventListener:eventPool()
	return _pool:get()
end

-- 注册方法，不会替换已存在的方法
function EventListener:register(eventname, func)
	return _pool:map(eventname, func)
end

-- 注册方法，但会替换已存在的方法
function EventListener:subregister(eventname, func)
	return _pool:replace(eventname, func)
end

-- 注销已注册的方法
function EventListener:unregister(eventname)
	return _pool:unmap(eventname)
end

-- 激活已注册的方法
function EventListener:activate(eventname, ...)
	local func  = _pool.valueof(eventname)
	if func then
		return func(...)
	else
		local str = 'EventListener [%s] not registered or has been removed.'
		print(string.format(str, eventname))
	end
end

-- 清空事件池
function EventListener:cleanup()
	_pool:empty()
end

return EventListener