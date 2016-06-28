--
-- Author: Reyn
-- Date: 2016-06-18 09:48:10
--

require('global')

local setmetatableindex_
setmetatableindex_ = function(t, index)
    local mt = getmetatable(t)
    if not mt then mt = {} end
    if not mt.__index then
        mt.__index = index
        setmetatable(t, mt)
    elseif mt.__index ~= index then
        setmetatableindex_(mt, index)
    end
end
setmetatableindex = setmetatableindex_

function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local newObject = {}
        lookup_table[object] = newObject
        for key, value in pairs(object) do
            newObject[_copy(key)] = _copy(value)
        end
        return setmetatable(newObject, getmetatable(object))
    end
    return _copy(object)
end

local class_generator = function (args)
    local __property__ = {}

    local __proto__ = {}

    __proto__.properties = function()
        return clone(__property__)
    end
    __proto__.addProperty = function(_, key, value)
        if __property__[key] then 
            return false 
        end
        __property__[key] = value
        return true
    end
    __proto__.removeProperty = function(_, key)
        if __property__[key] then 
            __property__[key] = nil 
            return true
        end
        return false
    end
    __proto__.replaceProperty = function(_, key, value)
        local ori = __property__[key]
        __property__[key] = value
        return ori, value
    end
    __proto__.property = function(_, key)
        return __property__[key]
    end
    __proto__.outputProperties = function ()
        local format = string.format
        local properties = __proto__.properties()
        for k,v in pairs(properties) do
            print(format("[%s] => ", k), v)
        end
    end
    __proto__.disableProperty = function ()
        __proto__.properties         = nil
        __proto__.addProperty        = nil
        __proto__.removeProperty     = nil
        __proto__.replaceProperty    = nil
        __proto__.property           = nil
        __proto__.outputProperties   = nil
    end
    __proto__.unset = function(class, key)
        if __proto__[key] then 
            __proto__[key] = nil
        end
        local supers = class.__supers or class.super
        if not supers then return end
        for i = 1, #supers do
            local super = supers[i]
            if super[key] then 
                super[key] = nil 
            end
        end
    end

    local args = args
    local __cname
    for k,v in pairs(args) do
        if k == '__cname' then
            __cname = v
        elseif not __proto__[k] then
            __proto__[k] = v
        end
    end
    __cname = __cname or '__prototype__'
    __proto__.classname = function()
        return __cname
    end

    __proto__.output = function (class)
        console_colorful('below is the struct of class ' .. __cname)
        local format = string.format
        local temp  = class.class or class
        for k,v in pairs(temp) do
            local len = string.len(k) + 2
            if len > 20 then k = string.sub(k, 1, 20) end
            print(format("[%s]", k) .. string.rep(" ", 20-len), v)
        end
    end

    return function()
        return __proto__
    end
end

local function anoymous_class(args, ...)
    if type(args) ~= 'table' then args = {} end
    local cls = class_generator(args)()

    local supers = clone({...})
    for _, super in ipairs(supers) do
        local superType = type(super)
        assert(superType == "nil" or superType == "table" or superType == "function",
            string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                classname, superType))

        if superType == "function" then
            assert(cls.__create == nil,
                string.format("class() - create class \"%s\" with more than one creating function",
                    classname));
            -- if super is function, set it to __create
            cls.__create = super
        elseif superType == "table" then
            if super[".isclass"] then
                -- super is native class
                assert(cls.__create == nil,
                    string.format("class() - create class \"%s\" with more than one creating function or native class",
                        classname));
                cls.__create = function() return super:create() end
            else
                -- super is pure lua class
                cls.__supers = cls.__supers or {}
                cls.__supers[#cls.__supers + 1] = super
                if not cls.super then
                    -- set first super pure lua class as class.super
                    cls.super = super
                end
            end
        else
            error(string.format("class() - create class \"%s\" with invalid super type",
                        classname), 0)
        end
    end

    cls.__index = cls
    if not cls.__supers or #cls.__supers == 1 then
        setmetatable(cls, {__index = cls.super})
    else
        setmetatable(cls, {__index = function(_, key)
            local supers = cls.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then return super[key] end
            end
        end})
    end

    if not cls.ctor then
        cls.ctor = function() end
    end
    cls.new = function(...)
        local instance
        if cls.__create then
            instance = cls.__create(...)
        else
            instance = {}
        end
        setmetatableindex(instance, cls)
        instance.class = cls
        instance:ctor(...)
        return instance
    end
    cls.create = function(_, ...)
        return cls.new(...)
    end
    getmetatable(cls).__call = cls.create
    setmetatable(cls, getmetatable(cls))

    return cls
end

function class(classname, ...)
    return anoymous_class({__cname=classname}, ...)
end

function proto_class(args, ...)
    return anoymous_class(args, ...)
end

local iskindof_
iskindof_ = function(cls, name)
    local __index = rawget(cls, "__index")
    if type(__index) == "table" and rawget(__index, "__cname") == name then return true end

    if rawget(cls, "__cname") == name then return true end
    local __supers = rawget(cls, "__supers")
    if not __supers then return false end
    for _, super in ipairs(__supers) do
        if iskindof_(super, name) then return true end
    end
    return false
end

function iskindof(obj, classname)
    local t = type(obj)
    if t ~= "table" and t ~= "userdata" then return false end
	local mt = getmetatable(obj)
    if mt then
        return iskindof_(mt, classname)
    end
    return false
end