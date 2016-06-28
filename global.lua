--
-- Author: Your Name
-- Date: 2016-06-20 13:38:55
--
function console_colorful(out)
	local outcolor	= '\x1b\x5b0;0;32m'
	local outstr	= outcolor .. "-----> [ %s ]"
	local default	= '\x1b\x5b0;40;0m'
	print(string.format(outstr, out), default)
end
