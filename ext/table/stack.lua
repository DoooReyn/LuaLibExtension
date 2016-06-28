--
-- Author: Reyn
-- Date: 2016-06-18 14:49:28
-- Comment: A simple implentation of stack
--

local Stack = class('Stack', Array)

local _pop	= Stack.shift
local _push	= Stack.unshift
Stack:unset('insert')
Stack:unset('remove')
Stack:unset('shift')
Stack:unset('unshift')
Stack:unset('push')
Stack:unset('pop')

local __space__ = nil

function Stack:ctor(space)
	self:setSpace(space)
	self:empty()
end

function Stack:setSpace(space)
	if not space or type(space) ~= 'number' then
		space = 0
	end
	__space__ = space
end

function Stack:stack()
	return self:array()
end

function Stack:space()
	return __space__
end

function Stack:push(element)
	local space = self:space()
	if space == 0 or space == self:len() then
		return false
	end
	return _push(self, element)
end

function Stack:pop()
	return _pop(self)
end

return Stack