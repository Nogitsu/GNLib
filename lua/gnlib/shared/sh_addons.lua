local gn_addons = {}

--  > Setter Functions
http.Fetch( "https://raw.githubusercontent.com/Nogitsu/GNLib/master/certified_addons.json", function( data )
    local certified = util.JSONToTable( data ) or {}
    for k, v in pairs( certified ) do
        v.certified = true
        gn_addons[ k ] = v
    end
end )

if SERVER then
    util.AddNetworkString( "GNLib:RegisterAddons" )

    hook.Add( "PlayerInitialSpawn", "GNLib:RegisterAddons", function( ply )
        GNLib.RefreshAddonsList( ply )
    end )

    function GNLib.RegisterAddon( id, name, desc, author, wip, lib_version, version, version_check, logoURL, workshop_link, github_link, timeStamp )
        if not isstring( id ) then return GNLib.Error( "Invalid ID, should be a string and not empty !" ) end

        local newAddon = {
            name = name,
            author = author,
            desc = desc,
            lib_version = lib_version,
            version = version,
            version_check = version_check,
            workshop_link = workshop_link,
            github_link = github_link,
            installed = true,
            wip = wip or false,
            timeStamp = timeStamp,
            logoURL = logoURL
        }

        if gn_addons[ id ] then
            GNLib.Error( "ID already taken for '" .. gn_addons[ id ].name .. "' addon." )
        else
            gn_addons[ id ] = newAddon
        end
    end

    function GNLib.EnableAddon( id, lib_version, version )
        if not isstring( id ) or not gn_addons[ id ] then return GNLib.Error( "Invalid ID !" ) end

        gn_addons[ id ].installed = true
        gn_addons[ id ].lib_version = lib_version
        gn_addons[ id ].version = version
    end

    function GNLib.RefreshAddonsList( ply )
        for k, v in pairs( gn_addons ) do
            if v.certified then
                gn_addons[ k ] = nil
            end
        end

        http.Fetch( "https://raw.githubusercontent.com/Nogitsu/GNLib/master/certified_addons.json", function( data )
            local certified = util.JSONToTable( data ) or {}
            for k, v in pairs( certified ) do
                v.certified = true
                gn_addons[ k ] = v
            end

            local compressed = util.Compress( util.TableToJSON( GNLib.GetAddons() ) )
            net.Start( "GNLib:RegisterAddons" )
                net.WriteData( compressed, #compressed )
            net.Send( ply )
        end )
    end
    concommand.Add( "gnlib_refreshaddons", GNLib.RefreshAddonsList )
end

--  > Getter Functions

function GNLib.GetAddon( id )
    return gn_addons[ id ]
end

function GNLib.IsInstalled( id )
    return GNLib.GetAddon( id ) and GNLib.GetAddon( id ).installed or false
end

function GNLib.CheckVersion( id, callback )
    if not GNLib.GetAddon( id ) then return GNLib.Error( "Addon not installed or bad ID." ) end
    if not GNLib.GetAddon( id ).version_check then
        GNLib.GetAddon( id ).last_version = GNLib.GetAddon( id ).version
    end
  
    http.Fetch( GNLib.GetAddon( id ).version_check, function( data )
        GNLib.GetAddon( id ).last_version = data

        if callback then
            callback( data, GNLib.GetAddon( id ).version_check )
        end
    end )
end

function GNLib.IsOutdated( id )
    return (GNLib.GetAddon( id ) and GNLib.GetAddon( id ).last_version ~= GNLib.GetAddon( id ).version) or false
end

function GNLib.IsOutdatedLib( id )
    if not GNLib.GetAddon( id ) then return GNLib.Error( "Addon not installed or bad ID." ) end

    return GNLib.GetAddon( id ).lib_version ~= GNLib.Version
end

function GNLib.IsCertified( id )
    return gn_addons[ id ] and gn_addons[ id ].certified or false
end

function GNLib.GetAddons()
    return table.Copy( gn_addons )
end

-- > Clientside registering

if CLIENT then
    net.Receive( "GNLib:RegisterAddons", function( len )
        local decompressed = util.Decompress( net.ReadData( len ) )
        gn_addons = util.JSONToTable( decompressed )
    end )
end