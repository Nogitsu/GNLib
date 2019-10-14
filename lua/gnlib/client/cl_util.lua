
function GNLib.IsInCircle( x, y, circle_x, circle_y, circle_radius )
    return math.Distance( x, y, circle_x, circle_y ) <= circle_radius
end

--[[ Waiting for valid api key
function GNLib.PlaySoundCloud( url, callback )
    if not string.find( url, "soundcloud.com") then return GNLib.Error( "Bad URL provided, please use a SoundCloud URL.") end
    local api_key = "831fdf2953440ea6e18c24717406f6b2"
    
    http.Fetch( "http://api.soundcloud.com/resolve.json?url=".. url .."?client_id=" .. api_key, function( body, sc_error_id, sc_error_name )
        local infos = util.JSONToTable( body )
        if not infos or not infos.id then 
            GNLib.Error("Invalid URL (%d: %s)"):format( sc_error_id, sc_error_name )
            if callback then callback( _, _, error_id, error_name ) end
        end

        sound.PlayURL( "http://api.soundcloud.com/tracks/" .. infos.id .."/stream?client_id=" .. api_key, "", function( station, error_id, error_name )
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
]]

function GNLib.CreatePicture( filename, format, w, h, render_function ) -- Made by Wabel to integrate the Team
    file.CreateDir( "downloaded" )

    hook.Add( "HUDPaint", "GNLib:DrawPicture", function()
        hook.Remove( "HUDPaint", "GNLib:DrawPicture" )
        
        render_function( w, h )
    end )
    
    hook.Add( "PostRender", "GNLib:CreatePicture", function()
        hook.Remove( "PostRender", "GNLib:CreatePicture" )
        
        local gncapture = render.Capture({
            format = (format == "jpg") and "jpeg" or format,
            quality = 100,
            w = w,
            h = h,
            x = 0,
            y = 0,
            alpha = false
        })

        file.Write( string.format( "downloaded/%s.%s", filename, format ), gncapture )
    end )
end

function GNLib.AdjustColor( col, fraction )
    if not isnumber(fraction) then return GNLib.Error( "The fraction isn't a number" ) end

    col = Color(col.r + col.r * fraction, col.g + col.g * fraction, col.b + col.b * fraction)
    return col
end