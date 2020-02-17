function GNLib.IsInCircle( x, y, circle_x, circle_y, circle_radius )
    return math.Distance( x, y, circle_x, circle_y ) <= circle_radius
end

function GNLib.CalculateF( f, x )
  local fx = string.Replace( f, "x", x )
  local result = CompileString( "return " .. fx, "CalculatingF(x)" )

  return result and result() or "error"
end

function GNLib.PlaySoundCloud( url, callback )
    if not string.find( url, "soundcloud.com") then return GNLib.Error( "Bad URL provided, please use a SoundCloud URL.") end

    http.Fetch( "http://api.soundcloud.com/resolve.json?url=".. url .."&client_id=831fdf2953440ea6e18c24717406f6b2", function( body, sc_error_id, sc_error_name )
        local infos = util.JSONToTable( body )
        if not infos then
            GNLib.Error("Invalid URL (%d: %s)"):format( sc_error_id, sc_error_name )
            if callback then callback( _, _, error_id, error_name ) end
        end

        sound.PlayURL( "http://api.soundcloud.com/tracks/" .. infos.id .."/stream?client_id=831fdf2953440ea6e18c24717406f6b2", "", function( station, error_id, error_name )
            if station then
                station:Play()
                if callback then callback( infos, station, error_id, error_name ) end
            else
                GNLib.Error( ("Invalid Streaming URL (%d: %s)"):format( error_id, error_name ) )
                if callback then callback( infos, _, error_id, error_name ) end
            end
        end )
    end )
end

--  > Net receive for GNLib.SendHook server-side function
net.Receive( "GNLib:NetHooks", function( len )
    local name = net.ReadString()
    local args = GNLib.ReadTable( len - #name )

    hook.Run( name, unpack( args ) )
end )