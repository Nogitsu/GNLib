if SERVER then
    util.AddNetworkString( "GNLib:PrintChat" )
    
    local PLAYER = FindMetaTable( "Player" )
    function PLAYER:PrintChat( ... )
        local args = { ... }
        local compressed = util.Compress( util.TableToJSON( args ) )

        net.Start( "GNLib:PrintChat" )
            net.WriteData( compressed, #compressed )
        net.Send( self )
    end
else
    net.Receive( "GNLib:PrintChat", function( len )
        local data = net.ReadData( len )
        local args = util.JSONToTable( util.Decompress( data ) )

        chat.AddText( unpack( args ) )
    end )
end