---------------------------------
-- Author: Reyn
-- Date: 2016-06-27
-- Comment: 日期
---------------------------------

local date = {}
local OSDate = os.date
local function __call(self, ...)
    return OSDate(...)
end
local __mt__ = {__call = __call}
setmetatable(date, __mt__)

-------- 日期信息数组 -----------
function date.toarray(stamp)
    return date('*t', stamp)
end

-------- 年月日，时分秒 ---------
function date.year(stamp)
    return date('%Y', stamp)
end

function date.month(stamp)
    return date('%m', stamp)
end

function date.abbrMonth(stamp)
	return date('%b', stamp)
end

function date.fullMonth(stamp)
	return date('%B', stamp)
end

function date.day(stamp)
    return tonumber(date('%d', stamp))
end

function date.hour(stamp)
	return tonumber(date.hour24(stamp))
end

function date.minute(stamp)
	return tonumber(date('%M', stamp))
end

function date.second(stamp)
	return tonumber(date('%S', stamp))
end

------------ 世界格式 -------------
function date.universal(format, stamp)
	return date('!'..format, stamp)
end

------------ 本地格式 -------------
function date.localize(format, stamp)
	return date(format, stamp)
end

------------ 早上 -------------
function date.am()
	return string.upper(date.meridiem()) == 'AM'
end

------------ 下午 -------------
function date.pm()
	return string.upper(date.meridiem()) == 'PM'
end

------------ 12小时制 -------------
function date.hour12(stamp)
	return date('%I', stamp)
end

------------ 24小时制 -------------
function date.hour24(stamp)
	return date('%H', stamp)
end

------------ 年月日 -------------
function date.ymd(stamp)
	return date('%F',stamp)
end

function date.dmy(stamp)
	return date('%D', stamp)
end

------------ 时分秒 -------------
function date.hm(stamp)
	return date('%R', stamp)
end

function date.hms(stamp)
	return date('%T', stamp)
end

---- 年-月-日 时:分:秒 上下午------
function date.all()
	return table.concat({date.ymd(), date.hms(), date.meridiem()}, ' ')
end

------- 年-月-日 时:分:秒 --------
function date.exceptMeridiem()
	return table.concat({date.ymd(), date.hms()}, ' ')
end

------------ 上午下午 -------------
function date.meridiem(stamp)
	return date('%p', stamp)
end

-------------- 时区 --------------
function date.offsetTimezone()
	return date('%z')	-- offset from UTC
end

function date.timezone()
	return date('%Z')
end

------------ 时间戳 --------------
function date.timestamp()
	return os.time()
end

------------- 时间点 ------------------
function date.weekOfYearFromSunday(stamp)
	return date('%U', stamp)
end

function date.weekOfYearFromMonday(stamp)
	return date('%W', stamp)
end

function date.dayOfYear(stamp)
	return date('%j', stamp)
end

function date.dayOfMonth(stamp)
	return date('%e', stamp)
end

function date.abbrDayOfWeek(stamp)
	return date('%a', stamp)
end

function date.fullDayOfWeek(stamp)
	return date('%A', stamp)
end

function date.dayOfWeekFromSunday(stamp)
	return date('%w', stamp) 	-- [0,6]
end

function date.dayOfWeekFromMonday(stamp)
	return date('%u', stamp)	-- [1,7]
end

function date.offsetFrom(stamp)
	local current = os.time()
	local offset  = current - stamp

	local function cmpYear()
		return math.floor(date.year(current) - date.year(stamp))
	end
	local function cmpMonth()
		return math.floor(date.month(current) - date.month(stamp))
	end
	local function cmpWeek()
		return math.floor(date.weekOfYearFromMonday(current) - date.weekOfYearFromMonday(stamp))
	end
	local function cmpDay()
		return math.floor(date.day(current) - date.day(stamp))
	end
	local function cmpHour()
		return math.floor(date.hour(current) - date.hour(stamp))
	end
	local function cmpMinute()
		return math.floor(date.minute(current) - date.minute(stamp))
	end
	local function cmpSecond()
		return math.floor(date.second(current) - date.second(stamp))
	end


    local ret = cmpYear()
    if ret > 0 then return ret .. '年前' end

    local ret = cmpMonth()
    if ret > 0 then return ret .. '月前' end

    local ret = cmpWeek()
    if ret > 0 then return ret .. '周前' end

    local ret = cmpDay()
    if ret > 0 then return ret .. '天前' end

    local ret = cmpHour()
    if ret > 0 then return ret .. '小时前' end

    local ret = cmpMinute()
    if ret > 0 then return ret .. '分钟前' end

    local ret = cmpSecond()
    if ret > 0 then return ret .. '秒前' end
end

---------- testcases ------------
-- math.randomseed(os.time() * os.time())
-- local randnum = math.random(1, 1024*102400)
-- local stamp = os.time() - randnum
-- print(date.universal('%Y-%m-%d %H:%M:%S', stamp))
-- print(date.localize('%Y-%m-%d %H:%M:%S',  stamp))
-- print(date.toarray(stamp))
-- print(date.year(stamp))
-- print(date.month(stamp))
-- print(date.day(stamp))
-- print(date.hour(stamp))
-- print(date.minute(stamp))
-- print(date.second(stamp))
-- print(date.am(stamp))
-- print(date.pm(stamp))
-- print(date.hour12(stamp))
-- print(date.hour24(stamp))
-- print(date.ymd(stamp))
-- print(date.dmy(stamp))
-- print(date.hms(stamp))
-- print(date.hm(stamp))
-- print(date.abbrMonth(stamp))
-- print(date.fullMonth(stamp))
-- print(date.weekOfYearFromSunday(stamp))
-- print(date.weekOfYearFromMonday(stamp))
-- print(date.dayOfYear(stamp))
-- print(date.dayOfMonth(stamp))
-- print(date.abbrDayOfWeek(stamp))
-- print(date.fullDayOfWeek(stamp))
-- print(date.dayOfWeekFromSunday(stamp))
-- print(date.dayOfWeekFromMonday(stamp))
-- print(date.offsetFrom(stamp))

return date
