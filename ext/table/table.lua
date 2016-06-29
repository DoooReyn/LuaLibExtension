local table = table

function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

function table.keys(hashtable)
    local keys = {}
    for k, v in pairs(hashtable) do
        keys[#keys + 1] = k
    end
    return keys
end

function table.values(hashtable)
    local values = {}
    for k, v in pairs(hashtable) do
        values[#values + 1] = v
    end
    return values
end

function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

function table.insertto(dest, src, begin)
    begin = checkint(begin)
    if begin <= 0 then
        begin = #dest + 1
    end

    local len = #src
    for i = 0, len - 1 do
        dest[i + begin] = src[i + 1]
    end
end

function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then return i end
    end
    return false
end

function table.keyof(hashtable, value)
    for k, v in pairs(hashtable) do
        if v == value then return k end
    end
    return nil
end

function table.removebyvalue(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then break end
        end
        i = i + 1
    end
    return c
end

function table.map(t, fn)
    for k, v in pairs(t) do
        t[k] = fn(v, k)
    end
end

function table.walk(t, fn)
    for k,v in pairs(t) do
        fn(v, k)
    end
end

function table.filter(t, fn)
    for k, v in pairs(t) do
        if not fn(v, k) then t[k] = nil end
    end
end

function table.unique(t, bArray)
    local check = {}
    local n = {}
    local idx = 1
    for k, v in pairs(t) do
        if not check[v] then
            if bArray then
                n[idx] = v
                idx = idx + 1
            else
                n[k] = v
            end
            check[v] = true
        end
    end
    return n
end

--[[判断table中是否存在某个值]]
function table.isContain(tab,value)
    local ret,idx = false, 0
    for key, val in pairs(checktable(tab)) do
        if val == value then
            ret = true
            idx = key
            break
        end
    end
    return ret,idx
end

--[[从table中随机一个值]]
function table.randomValue(tab)
    if #tab == 0 then
        return nil
    end
    local idx = math.randomFrom1(#tab)
    return tab[idx]
end

--[[从table中随机一堆值]]
function table.mulRandomValue(tab,num,isUnique)
    tab = isUnique and tab or table.unique(tab)
    if #tab == 0 or num <= 0 or (not isUnique and #tab < num) then
        return nil
    end
    local ret = {}
    while #ret < num do
        ret[#ret+1] = tab[math.randomFrom1(#tab)]
        if not isUnique then
            ret = table.unique(ret)
        end
    end
    return ret
end

--[[
-- 打乱数组中的顺序返回新的数组
-- ]]
function table.shuffle(t)
    local keys = table.keys(t)
    local randomKeys = {}
    local count = #t
    for i = 1, count do
        local rand = math.randomFrom1(#keys)
        randomKeys[i] = keys[rand]
        table.remove(keys,rand)
    end

    local newTable = {}
    for k, v in pairs(randomKeys) do
        newTable[k] = t[v]
    end

    for k,v in pairs(newTable) do
        t[k] = v
    end
    return t
end

--[[比较两个table中不同的键,并返回对应的值]]
function table.diffKeys(tab1,tab2)
    local ret = {}
    for key, val in pairs(tab1) do
        if not tab2[key] then
            ret[key] = val
        end
    end
    return ret
end

--[[合并多个table到某个table中
--  XXX noraml and simply merge, not a deep copy version
-- for safety, this method will clone table1
-- @function table_merge
-- @return #table
-- ]]
function table.mulMerge(table1, ...)
    local function merge_table(tab1, tab2)
        if type(tab2) ~= 'table' then
            return
        end
        for key, val in pairs(tab2) do
            tab1[key] = val
        end
    end

    local ret = clone(table1)
    for _, tab in ipairs{...} do
        for key, val in pairs(tab) do
            merge_table(ret,tab)
        end
    end
    return ret
end

--[[合并table并重建索引]]
function table.mulMergeAndReIndex(table1,...)
    local function merge_table(tab1, tab2)
        if type(tab2) ~= 'table' then
            return
        end
        for key, val in pairs(tab2) do
            if type(key) == 'number' then
                tab1[#tab1 + 1] = val
            else
                tab1[key] = val
            end
        end
    end

    local ret = clone(table1)
    for _, tab in ipairs{...} do
        merge_table(ret,tab)
    end
    return ret
end

--[[将table中的键值翻转]]
function table.flipKeyValue(tab)
    local newTab = {}
    if type(tab) == 'table' then
        for key, val in pairs(tab) do
            newTab[val] = key
        end
    end
    return newTab
end

--[[将键值对以从大到小的自然数重建索引,
--TODO 但我不知道该怎么取名容易让人理解
-- ]]
function table.iflip(tab)
    local ret = {}
    local count = table.maxn(tab)
    for i,v in ipairs(tab) do
        ret[count-i+1] = v
    end
    return ret
end

--[[add two table, if key exist then add two values]]
function table.add(table1, table2, ...)
    local ret = clone(table1)
    local function addition(tab1, tab2, ...)
        if not tab2 then
            return tab1
        end
        for key, val in pairs(tab2) do
            if type(val) == "number" then
                local oldVal = tab1[key] or 0
                tab1[key] = oldVal + val
            end
        end
        local varList = {...}
        return addition(tab1, select(1,...), unpack(varList,2))
    end
    return addition(ret,table2,...)
end

-- math sub two table's value
-- XXX if result equals to 0, the value will be asign to nil not 0
-- maye it's too particular
function table.sub(table1, table2)
    local ret = clone(table1)
    for key, val in pairs(table1) do
        if type(val) == "number" then
            local newVal = val - table2[key]

            if newVal == 0 then
                newVal = nil
            end
            ret[key] = newVal
        end
    end
    return ret
end

--[[重建索引,并返回新的数组]]
function table.reIndex(tab,loop)
    if loop == nil then loop = pairs end
    local index =1
    local ret   ={}
    for _,data in loop(tab) do
        ret[index] =data
        index =index+1
    end
    return ret
end

function table.randomOne(tab)
    local ret = {}
    for _,v in pairs(tab) do
        ret[#ret+1] = v
    end
    return table.randomValue(ret)
end

function table.iloop(tab, callF)
    for i=1, #tab do
        callF(i, tab[i])
    end
end

function table.itrim(tab)
    local ret = {}
    table.iloop(tab, function(i, v)
        if nil ~= v then
            ret[#ret+1] = v
        end
    end)
    return ret
end

--[[创建枚举，默认从1开始]]
function table.enum(from, ...)
    local enum = {}
    local tab  = {...}
    local from = from or 1

    for i=1, #tab do
        local key = tab[i]
        enum[key] = from
        from = from + 1
    end

    return enum
end

--[[使用表创建枚举]]
function table.enumTab(tab, from)
    return table.enum(from, unpack(tab))
end

--[[移除符合的值]]
function table.removeArrayItemWithChecker(arr, checker)
    local indexes = {}

    for i, v in ipairs(arr) do
        if checker(i, v) then
            indexes[#indexes + 1] = i
        end
    end

    for i = #indexes, 1, -1 do
        table.remove(arr, indexes[i])
    end
end

--[[克隆]]
function table.clone(t)
    local tmp = {}
    for k,v in pairs(t) do
        tmp[k] = v
    end

    return tmp
end

function table.weak(mt)
    mt = mt or "v"
    return setmetatable({}, {
        __mode = mt
    })
end

-- 移除表的第一个元素
function table.arrayShift(t)
    if #t == 0 then return false end
    local shift_v = t[1]
    table.remove(t, 1)
    return shift_v
end

-- 添加为表的第一个元素
function table.arrayUnshift(t, v)
    table.insert(t, 1, v)
    return v
end

--从table中随机一个值，Array、HashTable 通用
function table.random(tab)
	local keys = table.keys(tab)
	local kId  = math.randomFrom1(#keys)
	local key  = keys[kId]
    return tab[key], key
end

-- 键作为值
function table.keyAsValue(...)
    local t = {...}
    local ret = {}
    for k,v in pairs(t) do
        ret[v] = v
    end
    return ret
end

-- 根据索引取数组片段
function table.slice(tab, from, to)
	local segment = {}
    from = from or 1
    to   = to or #tab
	for i=from, to do
		segment[#segment+1] = tab[i]
	end
	return segment
end

-- 反转数组索引
function table.reverse(tab)
	local ret = {}
	for i=#tab, 1, -1 do
		ret[#ret+1] = tab[i]
	end
	return ret
end

function table.getFirstKey(tab)
	local k, v = next(tab)
	return k
end

function table.getFirstValue(tab)
	local k, v = next(tab)
	return v
end

function table.getLastKey(tab)
	local k, v = next(tbl, table.nums(tab) - 1)
	return k
end

function table.getLastValue(tab)
	local k, v = next(tbl, table.nums(tab) - 1)
	return v
end
