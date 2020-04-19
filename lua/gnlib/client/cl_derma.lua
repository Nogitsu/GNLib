--  > Main GNLib frame styled
--- @title:
--- 	GNLib.CreateFrame: <function> Create a centered GNFrame VGUI
--- @params:
--- 	title: <string> Title of the frame
--- 	W: <number> (optional) Width
--- 	H: <number> (optional) Height
--- 	main_color: <Color> (optional) Main color
--- 	second_color: <Color> (optional) Second color
--- @return:
--- 	main: <GNFrame> Main frame
--- 	header: <DPanel> Header of the main frame
--- 	close: <DButton> Close button parented to the header
--- @example:
--- 	#prompt: Code from `lua/gnlib/client/cl_addonslist.lua` line 18
--- 	#code: local main, header, close = GNLib.CreateFrame( "GNLib Addons List - " .. GNLib.Version )
--- 	#output: Create a basic GNFrame and put return values in local variables
function GNLib.CreateFrame( title, W, H, main_color, second_color )
    local W, H = W or math.max( ScrW() * .75, 1024 ), H or math.max( ScrH() * .75, 720 )

    local frame = vgui.Create( "GNFrame" )
        frame:SetTitle( title )
        frame:SetSize( W, H )
        frame:Center()
        if main_color then frame:SetColor( main_color ) end
        if second_color then frame.header.color = second_color end

    return frame, frame.header, frame.close
end

function GNLib.GetPanelAbsoluteBounds( panel )
    --  > add bounds from parents
    local x, y, w, h = panel:GetBounds()

    local parent = panel:GetParent()
    while parent do
        parent_x, parent_y = parent:GetPos()
        x, y = x + parent_x, y + parent_y
        parent = parent:GetParent()
    end

    return x, y, w, h
end

function GNLib.DermaMessage( title, text, affirmative_text, callback, negative_text )
    title = title or "Title"
    text = text or "Text"
    affirmative_text = affirmative_text or "OK"

    local frame, close = GNLib.CreateFrame( title, ScrW() * .2, ScrH() * .2 )

    local W, H = frame:GetSize()
    close:SetPos( W - 30, 5 )

    local label = vgui.Create( "DLabel", frame )
        label:Dock( TOP )
        label:DockMargin( 10, 10, 10, 10 )
        label:SetText( text )
        label:SetFont( "GNLFontB15" )
        label:SetAutoStretchVertical( true )
        label:SetWrap( true )

    --  > buttons
    local container = frame:Add( "DPanel" )
        container:Dock( TOP )
        container:DockMargin( 10, 0, 10, 0 )
        container.Paint = function() end

    local affirmative_button = container:Add( "GNButton" )
        affirmative_button:Dock( LEFT )
        --affirmative_button:DockMargin( 10, 10, 10, 10 )
        affirmative_button:SetText( affirmative_text )
        affirmative_button:SetColor( GNLib.Colors.Emerald )
        affirmative_button:SetHoveredColor( GNLib.Colors.Nephritis )
        affirmative_button:SetTextColor( GNLib.Colors.Clouds )
        affirmative_button:SetHoveredTextColor( GNLib.Colors.Silver )
        function affirmative_button:DoClick()
            frame:Remove()
            if callback then callback( true ) end
        end

    local negative_button
    if negative_text then
        negative_button = container:Add( "GNButton" )
            negative_button:Dock( LEFT )
            negative_button:DockMargin( 10, 0, 0, 0 )
            negative_button:SetText( negative_text )
            negative_button:SetColor( GNLib.Colors.Alizarin )
            negative_button:SetHoveredColor( GNLib.Colors.Pomegranate )
            negative_button:SetTextColor( GNLib.Colors.Clouds )
            negative_button:SetHoveredTextColor( GNLib.Colors.Silver )
            function negative_button:DoClick()
                frame:Remove()
                if callback then callback( false ) end
            end
    end

    timer.Simple( 0, function()
        frame:SizeToChildren( false, true )
        frame:SetTall( frame:GetTall() + 10 )

        if negative_button then
            affirmative_button:SetWide( container:GetWide() / 2 - 5 )
            negative_button:SetWide( affirmative_button:GetWide() )
        else
            affirmative_button:SetWide( container:GetWide() )
        end
    end )

    return frame
end

function GNLib.DermaStringRequest( title, confirm_text, cancel_text, callback, ... )
    title = title or "Title"
    text = text or "Text"
    confirm_text = confirm_text or "OK"
    cancel_text = cancel_text or "Cancel"

    local args = { ... }

    local frame, header, close = GNLib.CreateFrame( title, ScrW() / 5, 50 * #args + 30 * #args + 25 )
        close:Remove()

    local W, H = frame:GetSize()
    local textentries = {}
    if ... then 
        for i, v in ipairs( args ) do
            local textentry = vgui.Create( "GNTextEntry", frame )
            textentry:SetPos( 15, 30 * i + 15 * ( i - 1 ) )
            textentry:SetWide( W / 1.5 )
            textentry:CenterHorizontal()
            textentry:SetColor( GNLib.Colors.Silver )
            textentry:SetHoveredColor( GNLib.Colors.Clouds )

            if string.find( v:lower(), "url" ) then textentry.AllowInput = function() return false end end -- don't delete characters if you pass the size of the textentry
            if string.find( v:lower(), "::" ) then
                local args = string.Split( v, "::" )
                local placeholder = args[2]
                if placeholder then textentry:SetPlaceholder( placeholder ) end
            end

            local start = v:find( "::" )
            textentry:SetTitle( start and v:sub( 1, start - 1 ) or v )

            table.insert( textentries, textentry )
        end
    end

    local accept_button = vgui.Create( "GNButton", frame )
        accept_button:SetPos( W / 2 - accept_button:GetWide() - 15, H - accept_button:GetTall() - 7 )
        accept_button:SetText( confirm_text )
        accept_button:SetTextColor( color_white )
        accept_button:SetHoveredTextColor( color_white )
        accept_button:SetColor( GNLib.Colors.Emerald )
        accept_button:SetHoveredColor( GNLib.Colors.Nephritis )
        function accept_button:DoClick()
            frame:Remove()
            
            local values = {}
            for k, v in pairs( textentries ) do 
                if #v:GetValue() > 0 then table.insert( values, v:GetValue() ) else table.insert( values, v:GetPlaceholder() ) end
            end
            if callback then callback( unpack( values ) ) end
        end

    local cancel_button = vgui.Create( "GNButton", frame )
        cancel_button:SetPos( W / 2 + 15, H - cancel_button:GetTall() - 7 )
        cancel_button:SetText( cancel_text )
        cancel_button:SetTextColor( color_white )
        cancel_button:SetHoveredTextColor( color_white )
        cancel_button:SetColor( GNLib.Colors.Alizarin )
        cancel_button:SetHoveredColor( GNLib.Colors.Pomegranate )
        function cancel_button:DoClick()
            frame:Remove()
        end

    return frame
end

function GNLib.OpenURL( url )
    local frame = GNLib.CreateFrame( url )

    local controller = frame:Add( "DHTMLControls" )
    controller:Dock( TOP )
    controller:DockMargin( 5, 5, 5, 0 )

    local browser = frame:Add( "DHTML" )
    browser:Dock( FILL )
    browser:DockMargin( 5, 0, 5, 5 )
    browser:OpenURL( url )
    function browser:OnChangeTitle( title )
        frame:SetTitle( title )
    end

    controller:SetHTML( browser )
end

concommand.Add( "gnlib_resetpanels", function() 
    for i, v in ipairs( vgui.GetWorldPanel():GetChildren() ) do
        if v:IsVisible() then
            v:Remove()
        end
    end
end )

--  > Make VGUI functions chaining

--[[ local function chaining( tbl )
    for k, v in pairs( tbl ) do
        if k:StartWith( "Get" ) then return end
        if isfunction( v ) then return end 

        tbl[k] = function( self, ... )
            v( ... )
            return self
        end
    end
end ]]

--[[ local PANEL = FindMetaTable( "Panel" )
GNLib.AddChaining( PANEL ) ]]

--[[ local vgui_Register = vgui.Register
function vgui.Register( class, tbl, base )
    GNLib.AddChaining( tbl )
    return vgui_Register( class, tbl, base )
end  ]]