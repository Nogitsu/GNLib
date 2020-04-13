
--- @title:
---     GNLib.LerpColor: <function> Linear interpolation between two colors
--- @params:
---     t: <number> Fraction for finding the result (between 0 and 1)
---     c1: <Color> First color
---     c2: <Color> Second color
--- @return:
---     lerped_color: <Color> Lerped color
function GNLib.LerpColor( t, c1, c2 )
    return Color( Lerp( t, c1.r, c2.r ), Lerp( t, c1.g, c2.g ), Lerp( t, c1.b, c2.b ), c1.a == c2.a and c1.a or Lerp( t, c1.a, c2.a ) )
end

--- @title:
---     GNLib.EncodeURL: <function> Replace each space letters by '%20'
--- @params:
---     url: <string> URL to perform encode
--- @return:
---     url: <string> URL edited
function GNLib.EncodeURL( url )
    return string.Replace( url, " ", "%20" )
end

--- @title:
---     GNLib.AutoTranslate: <function> Translate automatically a text to target language
--- @params:
---     target: <string> Translation language
---     text: <string> Text to translate
---     callback: <function> (optional) Function called when translation is received
local apikey = "trnsl.1.1.20190822T114859Z.8b4909373dc0b830.cf06aab555bbefc0acd710f07f8d6903105fe7ff"
function GNLib.AutoTranslate( target, text, callback )
    local url = string.format( "https://translate.yandex.net/api/v1.5/tr.json/translate?key=%s&text=%s&lang=%s", apikey, text, target )

    http.Fetch( GNLib.EncodeURL( url ), function( body )
        local reception = util.JSONToTable( body )

        if callback then
            callback( table.concat( reception.text or {}, " " ) or "", reception )
        end
    end )
end

--- @title:
---     GNLib.Translate: <function> Translate a text to target language from source language
--- @params:
---     source: <string> Original text language
---     target: <string> Translation language
---     text: <string> Text to translate
---     callback: <function> (optional) Function called when translation is received
function GNLib.Translate( source, target, text, callback )
    local url = string.format( "https://translate.yandex.net/api/v1.5/tr.json/translate?key=%s&text=%s&lang=%s-%s", apikey, text, source, target )

    http.Fetch( GNLib.EncodeURL( url ), function( body )
        local reception = util.JSONToTable( body )

        if callback then
            callback( table.concat( reception.text, " " ), reception )
        end
    end )
end

--- @title:
---     GNLib.SendDiscordMessage: <function> Send a message on a Discord webhook 
--- @params:
---     webhook: <string> Discord webhook to send the message
---     msg: <table> Contain `content` and optionally `username`, `avatar_url` and `tts` 
---     embed: <table> (optional) Contain all embed informations : https://discordapp.com/developers/docs/resources/channel#embed-object
---     verbose: <bool> (optional) Show or not the response of the web side
function GNLib.SendDiscordMessage( webhook, msg, embed, verbose )
    http.Post( "https://guthen.000webhostapp.com/discord/index.php", { json = util.TableToJSON( { 
        url = webhook, 
        message = { 
            content = msg.content,
            username = msg.username,
            avatar_url = msg.avatar_url,
            tts = msg.tts,
        },
        embed = embed,
    } ) }, function( response ) 
        if verbose then print( "GNLib.SendDiscordMessage' response: " .. response ) end
    end )
end

--- @title:
---     GNLib.Benchmark: <function> Calculate the time taken by CPU to execute callback
--- @note: 
---     This function come from GMod Creators Area (https://g-ca.fr)
--- @params:
---     callback: <function> Function to perform timestamp
---     name: <string> (optional) Display name in `verbose` mode 
---     verbose: <bool> (optional) Show or not the time elapsed
--- @return:
---     total_time: <number> Time took by CPU to execute callback
--- @example:
---     #prompt: Benchmarking du `ipairs` vs. `pairs` :
---     #code: local tab = {}\n\nfor i = 0, 1000000 do\n\ttab[i] = true\nend\n\nlocal _pairs = GNLib.Benchmark( function()\n\tfor k, v in pairs( tab ) do\n\tend\nend, "pairs" )\n\nlocal _ipairs = GNLib.Benchmark( function()\n\tfor i, v in ipairs( tab ) do\n\tend\nend, "ipairs" )\n\nprint( "Fastest is: " .. ( _ipairs < _pairs and "ipairs" or "pairs" ) )
---     #output: https://cdn.discordapp.com/attachments/630800979880706107/637606229585166347/unknown.png
function GNLib.Benchmark( callback, name, verbose )
    local start = SysTime()
    verbose = verbose == nil and true or verbose

    callback()

    local total_time = ( SysTime() - start ) * 1000
    local end_time = tostring( total_time ) .. 'ms'
    if verbose then print( name or '', 'Time elapsed: ', end_time ) end

    return total_time
end

--- @title:
---     GNLib.GetCurrentFilename: <function> Get the filename where this function is called
--- @params:
---     extension: <bool> (optional) Remove or not the extension of the filename
---     stack_index: <number> (optional) Stack index from this function (`2` is default and will return the filename where you call this function)
--- @return:
---     filename: <string> Filename with or not extension
function GNLib.GetCurrentFilename( extension, stack_index )
    local filename = string.GetFileFromFilename( debug.getinfo( stack_index or 2, "S" ).source )
    return extension and filename or filename:gsub( "%.%w+$", "" )
end

--- @title:
---     GNLib.WriteTable: <function> Used for net sending, send a compressed JSON table
--- @params:
---     tab: <table> Table to send
function GNLib.WriteTable( tab )
    local compressed = util.Compress( util.TableToJSON( tab ) )

    net.WriteData( compressed, #compressed )
end

--- @title:
---     GNLib.ReadTable: <function> Used for net receving, receive a compressed JSON table
--- @params:
---     len: <number> Bytes lenght of the received net minus all datas lenght
--- @return:
---     compressed_table: <table> Read table which was writing by GNLib.WriteTable 
function GNLib.ReadTable( len )
    return util.JSONToTable( util.Decompress( net.ReadData( len ) ) )
end

--- @title:
---     GNLib.MakeDocumentation: <function> Make a documentation from code comments
--- @params:
---     target_file: <string> Path to the file (from `lua/`)
---     code_path: <string> Link from your GitHub repository where will be added the file path
function GNLib.MakeDocumentation( target_file, code_path )
    local content = file.Read( target_file, "LUA" )

    local side = target_file:find( "cl_" ) and "iconclient" or target_file:find( "sv_" ) and "iconserver" or "iconshared"
    local code_path = ( code_path or "https://github.com/Nogitsu/GNLib/blob/master/lua/" ) .. target_file

    local output
    local function makeOutput( ... )
        return ( ":%s: **%s :** %s\n• Code source : %s%s\n\n:pencil2: **Description :** %s\n\n:bulb: **Utilisation :** `%s( %s )`\n\n:card_box: **Arguments :**\n%s" ):format( side, ... )
    end

    local param_pattern = "(%@%w+):"
    local value_pattern = "([%w+%.%:?]+):"

    local trad = {
        ["function"] = "Fonction",
    }

    local function table_concat_name( tbl, concat ) 
        local output = ""

        for i, v in ipairs( tbl ) do
            output = output .. v.name .. ( tbl[i + 1] and concat or "" )
        end

        return output
    end

    local function make_args_list( tbl )
        local output = ""

        for i, v in ipairs( tbl ) do
            output = output .. ( "• **%s** `%s` : %s" .. ( tbl[i + 1] and "\n" or "" ) ):format( v.tpe, v.name, v.desc )
        end

        return output
    end

    local doc_type
    local name, tpe, desc, params, note
    local function refresh()
        doc_type, name, tpe, desc, params, note = nil, "", "", "", {}, ""
    end
    refresh()

    for line in GNLib.IterateLines( content ) do
        if not line:StartWith( "---" ) then 
            if not ( doc_type == nil ) then 
                print( "\n[[NEW DOCUMENTATION]]\n" )
                print( makeOutput( trad[tpe], name, code_path, note, desc, name, table_concat_name( params, ", " ), make_args_list( params ) ) )
                refresh()
            end
            continue 
        end
        --print( line )

        if line:find( "%@%w+" ) then doc_type = line:match( "%@(%w+)" ) continue end
        
        if doc_type == "title" then 
            name, tpe, desc = line:match( "([%w+%.%:%_?]+): <(%w+)> (.+)" )
        elseif doc_type == "note" then
            note = "\n• Note: " .. line:gsub( "-", "" ):TrimLeft() 
        elseif doc_type == "params" then
            local var, tpe, desc = line:match( "([%w+%.%:%_?]+): <(%w+)> (.+)" )
            params[#params + 1] = { name = var, tpe = tpe, desc = desc }
        end
    end
end

--- @title:
--- 	GNLib.MakeSnippet: <function> Make a VSCode snippet in JSON format from code comments
--- @params:
--- 	target_file: <string> Path to the file (from `lua/`)
--- @example:
--- 	#prompt: Make snippet from the GNLib' recursive file
--- 	#code: GNLib.MakeSnippet( "gnlib/shared/sh_recursive.lua" )
--- 	#output: https://cdn.discordapp.com/attachments/638822462431166495/677135810952429568/unknown.png
function GNLib.MakeSnippet( target_file )
    local doc = file.Read( target_file, "LUA" )

    local snippets = {}

    local tpe, n_param = 0, 1
    for l in doc:gmatch( "[^\n]+" ) do
        if not l:StartWith( "---" ) then
            if tpe then 
                if snippets[#snippets] then
                    snippets[#snippets].body[1] = snippets[#snippets].body[1]:gsub( "%,$", "" ) .. " )"
                end
                snippets[#snippets + 1] = {} 
                tpe, n_param = nil, 1
            end
            continue
        end

        if not snippets[#snippets] then continue end

        local new_tpe = l:match( "%@(%w+)" )
        if new_tpe then
            tpe = new_tpe 
        else
            if tpe == "title" then
                local name, _, desc = l:match( "([%w+%.%:%_?]+): <(%w+)> (.+)" )
                snippets[#snippets].prefix = { name }
                snippets[#snippets].body = { name .. "(" }
                snippets[#snippets].description = desc
            elseif tpe == "params" then
                local name, tpe = l:match( "([%w+%_?]+): <(%w+)>" )
                snippets[#snippets].body[1] = snippets[#snippets].body[1] .. ( " ${%d:%s %s}," ):format( n_param, tpe, name )

                n_param = n_param + 1
            end
        end
    end

    local _snippets = snippets
    snippets = {}

    for k, v in pairs( _snippets ) do
        if not v.prefix then continue end
        snippets[v.prefix[1]] = v
    end

    print( util.TableToJSON( snippets, true ) )
end

--- @title:
--- 	GNLib.Format: <function> Format a text by index of argument. Brackets (`{}`) will be used to format the text and should contain the index of the argument.
--- @params:
--- 	str: <string> Text to format
--- 	args: <varargs> Args used to format
--- @return:
--- 	str: <string> Formated text
--- @example:
--- 	#prompt:
--- 	#code: print( GNLib.Format( "I will {2} from your {1} !", "skull", "drink" ) )
--- 	#output: "I will drink from your skull !"
function GNLib.Format( str, ... )
    local args = { ... }

    for arg in str:gmatch( "%b{}" ) do
        local id = tonumber( arg:match( "%d+" ) )
        str = str:gsub( arg, args[id] or "nil" )
    end

    return str
end

--- @title:
--- 	GNLib.FormatWithTable: <function> Format a text by index of the argument in the given table. Like `GNLib.Format`, brackets (`{}`) will be used to format the text and should contain the index of the argument.
--- @params:
--- 	str: <string> Text to format
--- 	tbl: <table> Table with indexed arguments
--- @return:
--- 	str: <string> Formated text
--- @example:
--- 	#prompt: 
--- 	#code: print( GNLib.FormatWithTable( "you are a {name} and a {gender} or {1}", { "a noob", name = "thicc boy", gender = "bOy" } ) )\n
--- 	#output: "you are a thicc boy and a bOy or a noob"
function GNLib.FormatWithTable( str, tbl )
    for k in str:gmatch( "%b{}" ) do
        local v = tbl[tonumber( k:match( "%d+" ) ) or k:gsub( "[{}]", "" )] or "nil"
        str = str:gsub( k, v )
    end

    return str
end

--- @title:
--- 	GNLib.TableShuffle: <function> Shuffle a numerical indexed table
--- @params:
--- 	tbl: <table> Table to shuffle
--- @return:
--- 	shuffled_table: <table> Shuffled table
--- @example:
--- 	#prompt: Shuffle a numerical table
--- 	#code: PrintTable( GNLib.TableShuffle( { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 } ) )
--- 	#output: https://cdn.discordapp.com/attachments/638822462431166495/678566089411788820/unknown.png
function GNLib.TableShuffle( tbl )
    math.randomseed( os.time() )

    --  > set tempory sorting order and value
    local new_tbl = {}
    for i, v in ipairs( tbl ) do
        new_tbl[i] = { _value = v, _sort_order = math.random( 0, 2 ) }
    end

    --  > sort randomly
    table.sort( new_tbl, function( a, b ) 
        return a._sort_order > b._sort_order
    end )

    --  > remove tempory variables
    for i, v in ipairs( new_tbl ) do 
        tbl[i] = v._value
    end

    return tbl
end

function GNLib.TableInsert( tab, value )
    tab[ #tab + 1 ] = value

    return tab
end

function GNLib.TableToColor( tab )
    return Color( tab.r or 255, tab.g or 255, tab.b or 255, tab.a or 255 )
end

--- @title:
--- 	GNLib.ArrayReduce: <function> Reduces an array to a number
--- @note:
--- 	Similary to Array.prototype.reduce in JavaScript
--- @params:
--- 	tbl: <table> Array to reduce : should be a numeracly indexed table
--- 	reducer: <function> Reducer function, called on each element with arguments : (accumulator: <number> Initial value or last computed value; value: <number> Current value; index: <number> Current value index
--- 	start_value=0: <number> Optional, start value of the accumulator
--- @return:
--- 	accumulator: <number> Last computed value from the reducer
--- @example:
--- 	#prompt: Compute sum of elements in an array
--- 	#code: local array = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }\n\nlocal sum = GNLib.ArrayReduce( array, function( acc, value ) \n\treturn acc + value\nend )\n\nprint( "Sum of elements in the array : " .. sum )
--- 	#output: Sum of elements in the array : 45
function GNLib.ArrayReduce( tbl, reducer, start_value )
    local accumulator = start_value or 0

    for index, value in ipairs( tbl ) do
        accumulator = reducer( accumulator, value, index )
    end

    return accumulator
end

function GNLib.ArrayRandomValues( tbl, n_values )
    local values = {}

    local max_iterations, iterations = n_values * #tbl, 0
    while #values < n_values do
        local value = table.Random( tbl )
        if not table.HasValue( values, value ) then values[#values + 1] = value end

        iterations = iterations + 1
        if iterations > max_iterations then break end
    end

    return values
end
