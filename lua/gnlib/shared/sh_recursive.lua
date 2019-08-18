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

PrintTable( GNLib.RecursiveFind( "resources/fonts", "ttf" ) )

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