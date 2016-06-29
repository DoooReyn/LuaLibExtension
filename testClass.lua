--
-- Author: Reyn
-- Date: 2016-06-18 10:13:29
--
require('init')

local base = class()

local obj = class('OBJ', base)
obj:output()
console_colorful("below are property methods")
print(obj:classname())				-- obj
print(obj:property('a'))			-- nil
print(obj:addProperty('a', 0))  	-- true
print(obj:addProperty('b', 1))  	-- true
obj:outputProperties()
print(obj:addProperty('a', 0))		-- false
print(obj:addProperty('b', 2))		-- false
print(obj:addProperty('c', 3))		-- true
print(obj:property('a'))			-- 0
print(obj:replaceProperty('a', 1))	-- 0 => 1
print(obj:property('a'))			-- 1
print(obj:removeProperty('a'))		-- true
print(obj:property('a'))			-- nil
console_colorful("set obj.removeProperty to nil")
obj.removeProperty = nil
print(obj:removeProperty('a'))		-- false
console_colorful("set obj.property to nil")
obj.property = nil
console_colorful("but get obj.property " .. tostring(obj.property))
console_colorful("unset property")
obj:unset('property')
console_colorful("and get obj.property " .. tostring(obj.property))
-- print(obj:property('a'))			-- `prperty` has been removed from self and supers, so it will raise error here.

print('\n\n')
local obj = proto_class({__cname='Obj'}, base)
obj:output()
console_colorful("below are property methods")
print(obj:classname())				-- obj
print(obj:property('a'))			-- nil
print(obj:addProperty('a', 0))  	-- true
print(obj:addProperty('b', 1))  	-- true
obj:outputProperties()
print(obj:addProperty('a', 0))		-- false
print(obj:addProperty('b', 2))		-- false
print(obj:addProperty('c', 3))		-- true
print(obj:property('a'))			-- 0
print(obj:replaceProperty('a', 1))	-- 0 => 1
print(obj:property('a'))			-- 1
print(obj:removeProperty('a'))		-- true
print(obj:property('a'))			-- nil
print(obj.removeProperty)
obj.removeProperty = nil            -- this is not safe if you want to remove it from self and supers, pls use `unset`
print(obj:removeProperty('a'))		-- false
