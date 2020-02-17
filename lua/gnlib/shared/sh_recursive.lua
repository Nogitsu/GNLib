function GNLib.RecursiveFind( path, game_path, filter ) --GNLib.RecursiveFind("models/weapons", "GAME", "mdl")
	filter = filter or "lua"
	game_path = game_path or "GAME"
	local search = path .. "/"
	
	local files, _ = file.Find( search .. "*." .. filter, game_path )
	local _, folders = file.Find( search .. "*", game_path )

	local tbl = {}

	for k, v in pairs( folders ) do
		for sk, sv in pairs( GNLib.RecursiveFind( search .. v, game_path, filter ) ) do
			tbl[#tbl + 1] = sv
		end
	end
	
	for k, v in pairs( files ) do
		tbl[#tbl + 1] = search .. v
	end

	return tbl
end

function GNLib.GetFolder( path, game_path, extension )
	path = (path and ( path:EndsWith( "/" ) and path or ( path .. "/" ) ) or "")
	extension = extension or "*"
	game_path = game_path or "DATA"

	local files, _ = file.Find( path .. "*." .. extension, game_path )
	local _, folders = file.Find( path .. "*" .. extension, game_path )

    local found = {}

	for _, v in ipairs( files ) do
        table.insert( found, v )
	end
	
	for _, v in ipairs( folders ) do
		found[ v ] = GNLib.GetFolder( path .. v .. "/", game_path, extension )
	end

    return found
end

--	> Allow you to require your addon folder easily
--- @title:
--- 	GNLib.RequireFolder: <function> Require an addon recursively (folders, sub-folders, etc.) by side (shared, server and client)
--- @note:
--- 	Files named with `cl_` will be client-side, `sv_` server-side and `sh_` server and client side (shared). Files with any of theses prefixes won't be executed.
--- @params:
--- 	path: <string> Path to the addon, from `lua/`
--- 	should_print: <boolean> (optional) Verbose mode, print or not each files included and/or sent to clients
--- 	indent: <string> (optional) Indentation of the verbose mode (you shouln't touch to this)
--- @return:
--- 	files: <table> Files found
--- 	folders: <table> Folders found
--- @example:
--- 	#prompt: Include GNLib with verbose mode (following code will be executed client-side, so the output is different from server)
--- 	#code: GNLib.RequireFolder( "gnlib", true )
--- 	#output: https://cdn.discordapp.com/attachments/638822462431166495/670668557176274955/unknown.png
function GNLib.RequireFolder( path, should_print, indent )
	local files, folders = file.Find( path .. "/*", "LUA" )
	local indent = indent or ""

	if should_print then print( indent:gsub( "\t", "" ) .. path ) end	
    for _, v in pairs( files ) do
        if not v:EndsWith( ".lua" ) then continue end
        if v:StartWith( "cl_" ) then
            if SERVER then
                AddCSLuaFile( path .. "/" .. v )
                if should_print then print( indent .. "AddCSLuaFile : " .. path .. "/" .. v ) end
            else
                include( path .. "/" .. v )
                if should_print then print( indent .. "include : " .. path .. "/" .. v ) end
            end
        elseif v:StartWith( "sv_" ) then
            include( path .. "/" .. v )
            if should_print then print( indent .. "include : " .. path .. "/" .. v ) end
		elseif v:StartWith( "sh_" ) then
            if SERVER then
                AddCSLuaFile( path .. "/" .. v )
                if should_print then print( indent .. "AddCSLuaFile : " .. path .. "/" .. v ) end
            end
            include( path .. "/" .. v )
            if should_print then print( indent .. "include : " .. path .. "/" .. v ) end
		end
    end

    for _, f in pairs( folders ) do table.Add( folders, GNLib.RequireFolder( path .. "/" .. f, should_print, indent .. "\t" ) ) end

    return files, folders
end