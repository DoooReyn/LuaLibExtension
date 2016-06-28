--
-- Author: Reyn
-- Date: 2016-06-18 14:49:22
-- Comment: A simple implentation of queue
--

local Queue = class('Queue', Array)
local _dequeue	= Queue.pop	
local _enquene	= Queue.unshift
Queue:unset('insert')
Queue:unset('remove')
Queue:unset('shift')
Queue:unset('unshift')
Queue:unset('push')
Queue:unset('pop')

local __space__ = nil

------------------ __queue__ begin ------------------
function Queue:ctor(space)
	self:setSpace(space)
	self:empty()
end

function Queue:setSpace(space)
	if not space or type(space) ~= 'number' then
		space = 0
	end
	__space__ = space
end

function Queue:queue()
	return self:array()
end

function Queue:space()
	return __space__
end

function Queue:enqueue(element)
	if self:space() == 0 then return false end
	if self:len() == self:space() then
		self:dequeue()
	end
	return _enquene(self, element)
end

function Queue:dequeue()
	return _dequeue(self)
end


return Queue 