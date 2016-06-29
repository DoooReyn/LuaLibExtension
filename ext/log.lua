-----------------------------------
-- Author       : Reyn
-- Date         : 2016-06-29
-- Comment      : 日志记录
-----------------------------------

local Log = {}

local level_tab   = {'LOG_DEBUG', 'LOG_INFO', 'LOG_WARNING', 'LOG_ERROR'}
Log.LEVEL         = table.readOnly(table.enum(1, table.unpack(level_tab)))
local LOG_HEARDER = '@@@@@ LOG HEADER @@@@@'
local LOG_FOOTER  = '@@@@@ LOG FOOTER @@@@@'
local LOG_TEXT    = {
    [Log.LEVEL.LOG_DEBUG  ] = 'DEBUG',
    [Log.LEVEL.LOG_INFO   ] = 'INFO',
    [Log.LEVEL.LOG_WARNING] = 'WARNING',
    [Log.LEVEL.LOG_ERROR  ] = 'ERROR',
}

local function checkLevel(log_level)
    local LOG_LEVEL = Log.LEVEL
    log_level = math.max(log_level, LOG_LEVEL.LOG_DEBUG)
    log_level = math.min(log_level, LOG_LEVEL.LOG_ERROR)
    return log_level
end

function Log:setLogPath(log_path)
    self.log_path = log_path or cc.FileUtils:getInstance():getWritablePath()
end

function Log:setLogLevel(log_level)
    self.log_level = checkLevel(log_level)
end

function Log:writeLog(text, log_level)
    log_level = log_level or self.log_level

    -- organize content
    local LOG_DATE    = Date.ymd()
    local LOG_TIME    = Date.hms()
    local FULLPATH    = self.log_path .. LOG_DATE .. '.log'
    local LOG_FORMAT  = {
        {'HEADER', LOG_HEARDER},
        {'LEVEL', LOG_TEXT[log_level] or tostring(log_level)},
        {'DATE', LOG_DATE},
        {'TIME', LOG_TIME},
        {'MSG', text},
        {'FOOTER', LOG_FOOTER},
    }
    local LOG_CONTENT = {}
    for i=1, #LOG_FORMAT do
        local item = LOG_FORMAT[i]
        local str = string.format('[%-6s] : %s ', item[1], item[2])
        LOG_CONTENT[#LOG_CONTENT+1] = str
    end
    local content = table.concat(LOG_CONTENT, '\n') .. '\n\n\n'

    -- write content
    local fp = io.open(FULLPATH, 'a+')
    fp:write(content)
    fp:flush()
    fp:close()
end

function Log:info(text)
    self:writeLog(text, Log.LEVEL.LOG_INFO)
end

function Log:debug(text)
    self:writeLog(text, Log.LEVEL.LOG_DEBUG)
end

function Log:warning(text)
    self:writeLog(text, Log.LEVEL.LOG_WARNING)
end

function Log:error(text)
    self:writeLog(text, Log.LEVEL.LOG_ERROR)
end


return Log
