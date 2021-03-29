GNLib = GNLib or {}
GNLib.Version = "v0.10.3"
GNLib.Author = "Guthen & Nogitsu"
GNLib.Desc = "Shared library for frequent uses."

--  > Micro-Optimisation
local file = file
local concommand = concommand
local error = error
local include = include
local AddCSLuaFile = AddCSLuaFile

--  > Declaration

function GNLib.Error( ... )
	return error( "[GNLib] " .. ..., 2 )
end

local function include_sh( path )
	local search = path .. "/"
	local files, folders = file.Find( search .. "*", "LUA" )

	for k, v in pairs( files ) do
		include( search .. v )
		AddCSLuaFile( search .. v )
	end

	for k, v in pairs( folders ) do
		include_sh( search .. v )
	end
end


local function include_sv( path )
	local search = path .. "/"
	local files, folders = file.Find( search .. "*", "LUA" )

	for k, v in pairs( files ) do
		include( search .. v )
	end

	for k, v in pairs( folders ) do
		include_sv( search .. v )
	end
end


local function include_cl( path )
	local search = path .. "/"
	local files, folders = file.Find( search .. "*", "LUA" )

	for k, v in pairs( files ) do
		if CLIENT then
			include( search .. v )
		else
			AddCSLuaFile( search .. v )
		end
	end

	for k, v in pairs( folders ) do
		include_cl( search .. v )
	end
end

--  > Using

local function load()
	if SERVER then
		include_sv( "gnlib/server" )
	end
	include_sh( "gnlib/shared" )
	include_cl( "gnlib/client" )
end
concommand.Add( "gnlib_reload", load )

load()

--	> fetch version
http.Fetch( "https://raw.githubusercontent.com/Nogitsu/GNLib/master/lua/autorun/!0_gnlib.lua", function( body )
	local lines = body:Split( "\n" )
	local version = ( lines[2] or "error" ):match( "(%b\"\")" ):gsub( '"', "" )

	if not ( version == GNLib.Version ) then
		print( ( "GNLib: Not at the last version (%s => %s), please update GNLib via the Github : https://github.com/Nogitsu/GNLib" ):format( GNLib.Version, version ) )
	else
		print( ( "GNLib: Everything is okay, GNLib is at the last version (%s)" ):format( version ) )
	end
end )
