--
-- Author: Reyn
-- Date: 2016-06-18 10:34:03
--
local Array = class('Array')

--------------------- __lookup__  ---------------------
local __lookup__ = nil

local function _set(var)
	if type(var) ~= 'table' then 
		return false
	end
	__lookup__ = var
	return true
end

local function _get()
	return __lookup__
end

local function _empty()
	__lookup__ = {}
end

local function _serial()
	local serial = '[%s] : '
	local format = string.format
	for i,v in ipairs(__lookup__) do
		print(format(serial, i), v)
	end
end

local function _len()
	return #__lookup__
end

--------------------- Array begin ---------------------

function Array:ctor(...)
	self:empty()
	self:set({...})
end

function Array:empty()
	_empty()
end

function Array:set(arr)
	return _set(arr)
end

function Array:array()
	return clone(_get())
end

function Array.serial()
	_serial()
end

-- length
function Array:len()
	return _len()
end

-- push / insert
function Array:push (val)
	local index = self:len() + 1
	_get()[index] = val
	return index, val
end

function Array:insert (val, at)
	if not at then
		self:push(val)
		return self:len(), val
	end
	table.insert(_get(), at, val)
	return at, val
end

-- pop / remove
function Array:pop()
	local len = self:len()
	local popValue = _get()[len]
	if len > 0 then
		_get()[len] = nil
		return popValue, len
	end
	return false
end

function Array:remove(at)
	if not at then return false end
	if self:len() < at then return false end

	local removeValue = _get()[at]
	table.remove(_get(), at)
	return removeValue, at
end

-- index / value
function Array:valueOf(at)
	return _get()[at]
end

function Array:indexOf(val)
	for i,v in ipairs(_get()) do
		if v == val then
			return i
		end
	end
	return nil
end

-- method
function Array:foreach(func, interrupt)
	if interrupt then
		for i,v in ipairs(_get()) do
			local ret = func(i,v)
			if ret then
				break
			end
		end
	else
		for i,v in ipairs(_get()) do
			func(i,v)
		end
	end
end

function Array:exist(val)
	for i,v in ipairs(_get()) do
		if v == val then 
			return true 
		end
	end
	return false
end

-- Remove from the front of an array
function Array:shift()
	if self:len() == 0 then return false end
	local shiftValue = _get()[1]
	table.remove(_get(), 1)
	return shiftValue
end

-- Add to the front of an array
function Array:unshift(val)
	table.insert(_get(), 1, val)
	return val
end

return Array