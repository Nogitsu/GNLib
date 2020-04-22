--  > create an enum table
--[[ local function enum( ... )
    local tbl = {}

    for i, v in ipairs( { ... } ) do
        tbl[v] = i
    end

    return tbl
end

local Exception = enum( "BAD_ARGUMENT", "NULL_ENTITY", "ARITHMETIC", "CONCATENATE" ) ]]
local function create_error_object( err )
    --  > match error path, line and message
    local path, line, message = err:match( "^([%w/_-]+.lua):(%d+):%s?(.+)" )

    --  > get error type from enum (if exists of course)
    --[[ local tpe
    for k, v in pairs( Exception ) do
        if err:lower():find( k:lower():gsub( "_", " " ) ) then tpe = v end
    end ]]
    
    --  > sometimes, the error is different from what we waited, so :
    local tip
    if not path then
        local info = debug.getinfo( 3, "S" )
        path = info.short_src
        tip = "The lack of informations are potentially caused by the 'return' statement, check it."
    end
    
    --  > return exception 'object'
    return {
        path = path,
        line = tonumber( line ) or -1,
        message = message or err,
        error = err,
        type = tpe,
        tip = tip,
    }
end

--  > try-catch functions
--- @title:
--- 	try: <function> Must be called before a call to the 'catch' function. Allow to execute code with error handling. See 'catch' function for more details.
--- @note:
--- 	Similar to 'try-catch' blocks from other languages like C#, JavaScript, etc.
--- @params:
--- 	tbl: <table> Should contain a function in the first index which will be called
--- @example:
--- 	#prompt: Try to perform arithmetic on a string value and catch the error.
--- 	#code: try {\n\tfunction()\n\t\tlocal lol = "hello mek" + 5\n\t\tprint( "lol = " .. lol )\n\tend\n}\ncatch {\n\tfunction( e )\n\t\tprint( "Error at line " .. e.line .. " : " .. e.message .. "\\n" )\n\n\t\tprint( "Error structure :" )\n\t\tPrintTable( e )\n\tend\n}
--- 	#output: https://cdn.discordapp.com/attachments/638822462431166495/702491514445496360/unknown.png
local func
function try( tbl )
    func = isfunction( tbl[1] ) and tbl[1]
end

--- @title:
--- 	catch: <function> Must be called after a call to the 'try' function. Allow to handle error from the given function in the 'try' in a function.
--- @note:
--- 	Similar to 'try-catch' blocks from other languages like C#, JavaScript, etc. Errors from a 'return' statement from the given function in 'try' can return a weird error object.
--- @params:
--- 	tbl: <table> Should contain a function in the first index which will be called with the error object.
--- @example:
--- 	#prompt: See example from 'try' function.
--- 	#code:
--- 	#output:
function catch( tbl )
    if not func then return error( "you must call 'try' before calling 'catch'", 2 ) end

    local suc, err = pcall( func )
    if not suc then tbl[1]( create_error_object( err ) ) end

    func = nil
end

--  > testing area
--[[ if not CLIENT then return end
try {
    function()
        return Entity()--:GetModel()
    end
}
catch {
    function( e )
        print( "Error at line " .. e.line .. " : " .. e.message .. "\n" )

        print( "Error structure :" )
        PrintTable( e )
    end
} ]]