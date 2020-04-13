GNLib = GNLib or {}
GNLib.Version = "v0.8.4"
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
