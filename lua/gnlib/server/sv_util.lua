
--- @title:
--- 	GNLib.SendHook: <function> Run a hook from server to the client
--- @params:
--- 	ply: <player> Player to send the hook to
--- 	name: <string> Name of the hook to run
--- 	args: <varargs> Arguments of the hook
--- @example:
--- 	#prompt: Calls the PlayerSpawn hook on the client
--- 	#code: --  > Server\nhook.Add( "PlayerSpawn", "NetHooks Example", function( ply, from_map )\n\tGNLib.SendHook( ply, "MyPlayerSpawn", from_map )\nend )\n\n--  > Client\nhook.Add( "MyPlayerSpawn", "Client result", function( from_map )\n\tchat.AddText( "You just spawned" )\nend )
util.AddNetworkString( "GNLib:NetHooks" )

function GNLib.SendHook( ply, name, ... )
    net.Start( "GNLib:NetHooks" )
        net.WriteString( name )
        GNLib.WriteTable( {...} )
    net.Send( ply or player.GetAll() )
end