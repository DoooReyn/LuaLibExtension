--
-- Author: Reyn
-- Date: 2016-06-18 17:52:27
-- Comment: A simple implentation of map
--

local Map = class('Map')

------------------ __Map__ begin ------------------
local function closure()
	local __Map__ = nil

	local function _filter(map)
		local temp = {}
		for k,v in pairs(map) do
			if type(k) == 'string' then
				temp[k] = v
			end
		end
		return temp
	end

	local function _set(map)
		if type(map) ~= 'table' then return false end
		__Map__ = _filter(map)
		return true
	end

	local function _get()
		return __Map__
	end

	local function _empty()
		__Map__ = {}
	end

	local function _map(key, val, force)
		if type(key) ~= 'string' then return false end
		local mapKey = __Map__[key]
		if mapKey then 
			if not force then
				print(string.format('[%s] key exists in map.', key))
				return false
			end
		end
		__Map__[key] = val
		return true
	end

	local function _replace(key, val)
		return _Map(key,val,true)
	end

	local function _unmap(key)
		local err = function ()
			print(string.format('[%s] key not exists in map.', key))
		end
		if type(key) ~= 'string' then 
			err()
			return false 
		end
		local mapKey = __Map__[key]
		if not mapKey then 
			err()
			return false 
		end
		__Map__[key] = nil
		return true
	end

	local function _len()
		local len = 0
		for k,v in pairs(__Map__) do
			len = len + 1
		end
		return len
	end

	local function _serial()
		local serial = '[%s] : '
		local format = string.format
		for k,v in pairs(__Map__) do
			print(format(serial, k), v)
		end
	end

	local function _keyof(val)
		for key,v in pairs(__Map__) do
			if v == val then
				return key
			end
		end
		return nil
	end

	local function _valueof(key)
		return __Map__[key]
	end

	return function() 
		return {
			set		= _set, 
			get		= _get,
			empty	= _empty, 
			replace	= _replace,
			map		= _map,
			unmap	= _unmap,
			len		= _len,
			serial	= _serial,
			keyof   = _keyof,
			valueof = _valueof
		}
	end
end

local _Map = closure()()


------------------ Map begin ------------------

function Map:ctor(map)
	self:empty()
	self:set(map)
end

function Map:empty()
	_Map.empty()
end

function Map:set(map)
	return _Map.set(map)
end

function Map:get()
	return clone(_Map.get())
end

function Map.serial()
	_Map.serial()
end

function Map.keyof(val)
	return _Map.keyof(val)
end

function Map.valueof(key)
	return _Map.valueof(key)
end

-- length
function Map:len()
	return _Map.len()
end

-- map
function Map:map(key, val)
	return _Map.map(key, val, false)
end

function Map:replace(key, val)
	return _Map.map(key, val, true)
end

function Map:unmap(key, val)
	return _Map.unmap(key, val)
end

return Map