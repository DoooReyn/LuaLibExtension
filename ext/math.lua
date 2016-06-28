local math = math

--[[随机种子]]
function math.newrandomseed()
    local ok, socket = pcall(function()
        return require("socket")
    end)

    if ok then
        math.randomseed(socket.gettime() * 1000)
    else
        math.randomseed(os.time())
    end
    math.random()
    math.random()
    math.random()
    math.random()
end

--[[四舍五入]]
function math.round(value)
    value = checknumber(value)
    return math.floor(value + 0.5)
end

--[[角度转弧度]]
local pi_div_180 = math.pi / 180
function math.angle2radian(angle)
    return angle * pi_div_180
end

--[[弧度转角度]]
local pi_mul_180 = math.pi * 180
function math.radian2angle(radian)
    return radian / pi_mul_180
end

--[[从1-Max随机一个数]]
function math.randomFrom1(max)
    math.newrandomseed()
    return math.random(1,max)
end

--[[从0-1随机一个数]]
function math.random01()
    math.newrandomseed()
    return math.random()
end

--[[交换两个数据]]
function math.swap(a,b)
    a,b = b,a
    return a,b
end

--[[万格式]]
function math.convertThreshold(num)
    local THRESHOLD = 10000
    if num > THRESHOLD then
        return string.numberFormat(num / THRESHOLD,1)..'w'
    end
    return num
end

-- 已经椭圆长轴和短轴以及夹角，求椭圆上点的坐标
function math.ellipseDot(axis_long, axis_short, angle)
    local px,py = 0,0
    local tanA  = math.tan(angle)
    local squareLong  = math.pow(axis_long, 2)
    local squareShort = math.pow(axis_short, 2)
    local squareTanA  = math.pow(tanA, 2)
    local square = squareLong  + squareShort
    local divide = squareShort + squareLong * squareTanA
    local px = math.sqrt(square / divide)
    local py = px * tanA
    return px, py
end
