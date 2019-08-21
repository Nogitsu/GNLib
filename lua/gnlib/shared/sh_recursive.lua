
function GNLib.RecursiveFind( path, filter ) --GNLib.RecursiveFind("models/weapons", "mdl")
	filter = filter or ""
	local search = path .. "/"
	
	local files, _ = file.Find( search .. "*." .. filter, "GAME" )
	local _, folders = file.Find( search .. "*", "GAME" )
	local tbl = {}
	
	for k, v in pairs( folders ) do
		for sk, sv in pairs( GNLib.RecursiveFind(search .. v, filter) ) do
			if not tbl[path] then tbl[path] = {} end
			tbl[path][v] = sv
		end
	end
	
	for k, v in pairs( files ) do
		tbl[path] = search .. v
	end
	
	return tbl
end

function GNLib.RequireFolder( path )
	local files, folders = file.Find( path .. "/*", "LUA" )
    for _, v in pairs( files ) do
        if not v:EndsWith( ".lua" ) then continue end
        if v:StartWith( "cl_" ) then
            if SERVER then
                AddCSLuaFile( path .. "/" .. v )
                --print( "AddCSLuaFile : " .. path .. "/" .. v )
            else
                include( path .. "/" .. v )
                --print( "include : " .. path .. "/" .. v )
            end
        elseif v:StartWith( "sv_" ) then
            include( path .. "/" .. v )
            --print( "include : " .. path .. "/" .. v )
		elseif v:StartWith( "sh_" ) then
            if SERVER then
                AddCSLuaFile( path .. "/" .. v )
                --print( "AddCSLuaFile : " .. path .. "/" .. v )
            end
            include( path .. "/" .. v )
            --print( "include : " .. path .. "/" .. v )
		end
    end

    for _, f in pairs( folders ) do table.Add( folders, GNLib.RequireFolder( path .. "/" .. f ) ) end

    return files, folders
end

/*
{
	gnlib = {
		lua = {
			autorun = {
				"gnlib.lua"
			},
			gnlib = {
				client = {
					"cl_addonslist.lua",
					"cl_downloader.lua",
					"cl_draw.lua",
					"cl_font.lua"
				},
				server = {
					"sv_resources_dl.lua"
				},
				shared = {
					"sh_addons.lua",
					"sh_colors.lua",
					"sh_recursive.lua",
					"sh_util.lua"
				},
			}
		},
		resource = {
			fonts = {
				"CaviarDreams.ttf",
				"CaviarDreams_Bold.ttf",
				"CaviarDreams_BoldItalic.ttf",
				"CaviarDreams_Italic.ttf"
			}
		}
	}
}
*/