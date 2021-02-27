
local function create_error_object( err )
    --  > match error path, line and message
    local path, line, message = err:match( "^([%w/_-]+.lua):(%d+):%s?(.+)" )
    
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
--- 	GNLib.Try: <function> Must be called before a call to the 'catch' function. Allow to execute code with error handling. See 'GNLib.Catch' function for more details.
--- @note:
--- 	Similar to 'try-catch' blocks from other languages like C#, JavaScript, etc.
--- @params:
--- 	tbl: <table> Should contain a function in the first index which will be called
--- @example:
--- 	#prompt: Try to perform arithmetic on a string value and catch the error.
--- 	#code: GNLib.Try {\n\tfunction()\n\t\tlocal lol = "hello mek" + 5\n\t\tprint( "lol = " .. lol )\n\tend\n}\nGNLib.Catch {\n\tfunction( e )\n\t\tprint( "Error at line " .. e.line .. " : " .. e.message .. "\\n" )\n\n\t\tprint( "Error structure :" )\n\t\tPrintTable( e )\n\tend\n}
--- 	#output: https://cdn.discordapp.com/attachments/638822462431166495/702491514445496360/unknown.png
local func
function GNLib.Try( tbl )
    func = ( istable( tbl ) and ( isfunction( tbl[1] ) and tbl[1] ) ) or isfunction( tbl ) and tbl
end

--- @title:
--- 	GNLib.Catch: <function> Must be called after a call to the 'GNLib.Try' function. Allow to handle error from the given function in the 'GNLib.Try' in a function.
--- @note:
--- 	Similar to 'try-catch' blocks from other languages like C#, JavaScript, etc. Errors from a 'return' statement from the given function in 'GNLib.Try' can return a weird error object.
--- @params:
--- 	tbl: <table> Should contain a function in the first index which will be called with the error object.
--- @example:
--- 	#prompt: See example from 'GNLib.Try' function.
--- 	#code:
--- 	#output:
function GNLib.Catch( tbl )
    if not func then return error( "you must call 'GNLib.Try' before calling 'GNLib.Catch'", 2 ) end

    local callback = ( istable( tbl ) and ( isfunction( tbl[1] ) and tbl[1] ) ) or isfunction( tbl ) and tbl

    local suc, err = pcall( func )
    if not suc then callback( create_error_object( err ) ) end

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