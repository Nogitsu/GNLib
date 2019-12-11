GNLib = GNLib or {}
GNLib.Version = "v0.6.3"
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

local function IncludeSH( path )
	local search = path .. "/"
	local files, folders = file.Find( search .. "*", "LUA" )

	for k, v in pairs( files ) do
		include( search .. v )
		AddCSLuaFile( search .. v )
	end

	for k, v in pairs( folders ) do
		IncludeSH( search .. v )
	end
end


local function IncludeSV( path )
	local search = path .. "/"
	local files, folders = file.Find( search .. "*", "LUA" )

	for k, v in pairs( files ) do
		include( search .. v )
	end

	for k, v in pairs( folders ) do
		IncludeSV( search .. v )
	end
end


local function IncludeCL( path )
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
		IncludeCL( search .. v )
	end
end

--  > Using

local function load()
	if SERVER then 
		IncludeSV( "gnlib/server" ) 
	end
    IncludeCL( "gnlib/client" )
    IncludeSH( "gnlib/shared" )
end

concommand.Add( "gnlib_reload", load )
load()