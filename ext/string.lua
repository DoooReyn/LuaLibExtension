local string = string

string._htmlspecialchars_set = {}
string._htmlspecialchars_set["&"] = "&amp;"
string._htmlspecialchars_set["\""] = "&quot;"
string._htmlspecialchars_set["'"] = "&#039;"
string._htmlspecialchars_set["<"] = "&lt;"
string._htmlspecialchars_set[">"] = "&gt;"

function string.htmlspecialchars(input)
    for k, v in pairs(string._htmlspecialchars_set) do
        input = string.gsub(input, k, v)
    end
    return input
end

function string.restorehtmlspecialchars(input)
    for k, v in pairs(string._htmlspecialchars_set) do
        input = string.gsub(input, v, k)
    end
    return input
end

function string.nl2br(input)
    return string.gsub(input, "\n", "<br />")
end

function string.text2html(input)
    input = string.gsub(input, "\t", "    ")
    input = string.htmlspecialchars(input)
    input = string.gsub(input, " ", "&nbsp;")
    input = string.nl2br(input)
    return input
end

function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

function string.ltrim(input)
    return string.gsub(input, "^[ \t\n\r]+", "")
end

function string.rtrim(input)
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function string.ucfirst(input)
    return string.upper(string.sub(input, 1, 1)) .. string.sub(input, 2)
end

local function urlencodechar(char)
    return "%" .. string.format("%02X", string.byte(char))
end

--[[url编码]]
function string.urlencode(input)
    -- convert line endings
    input = string.gsub(tostring(input), "\n", "\r\n")
    -- escape all characters but alphanumeric, '.' and '-'
    input = string.gsub(input, "([^%w%.%- ])", urlencodechar)
    -- convert spaces to "+" symbols
    return string.gsub(input, " ", "+")
end

--[[url解码]]
function string.urldecode(input)
    input = string.gsub (input, "+", " ")
    input = string.gsub (input, "%%(%x%x)", function(h) return string.char(checknumber(h,16)) end)
    input = string.gsub (input, "\r\n", "\n")
    return input
end

--[[utf8字符串长度]]
function string.utf8len(input)
    local len  = string.len(input)
    local left = len
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    local crx  = 0
    local chars = {}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
        crx = crx + i
        local char = string.sub(input, crx-i+1, crx)
        chars[#chars+1] = char
    end
    return cnt, chars
end

function string.formatnumberthousands(num)
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

--[[格式化数字
--  将number转成string
 e.g    1  => '1'    (不管fcount设置多少)
 e.g    1.0=> "1"    (不管fcount设置多少)
 e.g    2.22222 => '2.22' (fcount = 2)
@params
 num: 传入的数值
 fcount 传入需要保留几位小数,如果本身是一个整数 那么fcount不起作用]]
function string.numberFormat(num,fcount)
    if fcount == 0 then
        return string.format('%d',num)
    end
    local fstr = '%.'..fcount..'f'
    local numstr = string.format(fstr,num)
    local num_temp = tonumber(numstr)
    local i ,f = math.modf(num_temp)
    --没有小数部位
    if f == 0 then
        return string.format('%d',i)
    elseif f > 0 then
        return string.format('%s',num_temp)
    end
    return ''
end

--[[获取时间,时，分，秒]]
function string.cdHMSStr(cdSec)
    local hour
    local SEC_EACH_HOUR = 3600
    if cdSec > SEC_EACH_HOUR then
        hour = math.floor(cdSec / SEC_EACH_HOUR)
        cdSec = cdSec % SEC_EACH_HOUR
    end
    local sec = cdSec % 60
    local min = math.floor(cdSec / 60)
    hour = hour or 0
    local hourStr =string.format('%02d',hour)
    local minStr  =string.format('%02d',min)
    local secStr  =string.format('%02d',sec)
    return {hourStr,minStr,secStr}
end

--[[格式化倒计时时间戳]]
function string.cdDateFormat(cdSec)
    local dateStr =string.cdHMSStr(cdSec)
    local timeStr =string.format("%s:%s:%s",dateStr[1]
        ,dateStr[2]
        ,dateStr[3])
    return timeStr
end

--[[格式化倒计时的秒数]]
function string.cdSecFormat(cdSec,isShowHour)
    local hour
    local SEC_EACH_HOUR = 3600
    if cdSec > SEC_EACH_HOUR then
        hour = math.floor(cdSec / SEC_EACH_HOUR)
        cdSec = cdSec % SEC_EACH_HOUR
    end
    local sec = cdSec % 60
    local min = math.floor(cdSec / 60)
    if isShowHour then
        hour = hour or 0
    end
    return hour and string.format("%02d:%02d:%02d", hour, min, sec)
            or string.format("%02d:%02d", min, sec)
end

--[[获取月日]]
function string.YMDFormat(formatStr ,time)
    local year  = os.date('%Y',time)
    local month = os.date('%m',time)
    local day   = os.date('%d',time)
    local str   = string.format(formatStr,year,month,day)
    return str
end

--[[获取UTF8字符数组]]
function string.UTF8Chars(str)
    local tab = {}
    for uchar in string.gfind(str, "[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(tab,uchar)
    end
    return tab
end

--[[获取UTF8字符串长度]]
function string.UTF8Length(str)
    local f = '[%z\1-\127\194-\244][\128-\191]*';
    local count = 0
    for v in str:gfind(f) do
        count=count+1
    end
    return count
end

--[[过滤 div 标签]]
function string.trimdiv(input)
    input = string.gsub(input, "<(%w+)[^>]*>", "")
    input = string.gsub(input, "</div>", "")
    return input
end

--[[游戏钱格式化]]
function string.gameMoneyFormat(num)
    local THRESHOLD = 10000
    local LIMIT_NUM = 1000000
    if num > LIMIT_NUM then
        return string.numberFormat(num/ THRESHOLD,1)..'w'
    else
        return string.formatnumberthousands(num)
    end
    return num
end

-- 将字符串转换为数组存储
function string.toarray(input)
	local _, chars = string.utf8len(input)
	return chars
end

-- 根据索引从字符串数组中取出字符串片段
function string.slice(strArr, from, to)
	local segment = table.slice(strArr, from, to)
	return string.array2string(segment)
end

-- 将字符串数组还原为字符串
function string.array2string(strArr)
	return table.concat(strArr, '')
end

-- 反转字符串，原生的 string.reverse 中文反转后是乱码
function string.utf8reverse(input)
	local strArr  = string.toarray(input)
	local reverse = table.reverse(strArr)
	return string.slice(reverse)
end

-- [[字符串首字母大写]]
function string.upperFirst(str)
    return (str:gsub("^%l", string.upper))
end

--[[字符串每个单词首字母大写]]
function string.upperWords(str, sep)
    sep = sep or ' '
    local split = string.split(str, sep)
    local upper = {}
    for i,v in ipairs(split) do
        upper[#upper+1] = string.upperFirst(string.lower(v))
    end
    return table.concat(upper, sep), upper
end

--[[字符串每个单词首字母大写,且过滤空白符]]
function string.upperWordsExceptSpace(str, sep)
	sep = sep or ' '
	local upper = {}
	for k in str:gmatch('%S+') do
		upper[#upper+1] = string.upperFirst(string.lower(k))
	end
	return table.concat(upper, sep)
end
