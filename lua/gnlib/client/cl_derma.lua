--  > Main GNLib frame styled
local remove_icon = Material( "icon16/cross.png" )
function GNLib.CreateFrame( title )
    local W, H = math.max( ScrW() * .75, 1024 ), math.max( ScrH() * .75, 720 )

    local main = vgui.Create( "GNPanel" )
    main:SetSize( W, H )
    main:Center()
    main:MakePopup()
    main.color = GNLib.Colors.MidnightBlue
    main.color2 = GNLib.Colors.WetAsphalt
    function main:Paint( w, h )
        GNLib.DrawRectGradient( 0, 0, w, h, self.color, self.color2, true )

        draw.SimpleText( title, "GNLFontB20", 15, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    local close = vgui.Create( "DButton", main )
    close:SetPos( W - 30, 5 )
    close:SetSize( 20, 20 )
    close:SetText( "" )
    close:SetTextColor( color_white )
    function close.DoClick()
        main:Remove()
    end
    function close:Paint( w, h )
        local c1 = GNLib.Colors.Concrete
        if self:IsHovered() then
            local t = math.abs( math.sin( CurTime() ) / w ) * 100 * 2
            c1 = GNLib.LerpColor( t, c1, GNLib.Colors.Pomegranate )
        end
        GNLib.DrawRectGradient( 0, 0, w, h, GNLib.Colors.Asbestos, c1, true )

        surface.SetMaterial( remove_icon )
        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect( 2, 2, 16, 16 )
    end

    return main, close
end

function GNLib.DermaMessage( title, text, button_text, callback )
    title = title or "Title"
    text = text or "Text"
    button_text = button_text or "OK"

    local frame, close = GNLib.CreateFrame( title )
    frame:SetSize( ScrW() / 7, ScrH() / 7 )
    frame:Center()

    local W, H = frame:GetSize()
    close:SetPos( W - 30, 5 )

    local label = vgui.Create( "DLabel", frame )
    label:SetSize( W - 30, H - H / 4 )
    label:SetPos( 15, 30 )
    label:SetText( text )
    label:SetFont( "GNLFontB15" )
    label:SetAutoStretchVertical( true )
    label:SetWrap( true )

    local button = vgui.Create( "GNButton", frame )
    button:SetPos( W / 2 - button:GetWide() / 2, H / 2 - button:GetTall() / 2 + H / 2.8 )
    button:SetText( button_text )
    button:SetColor( GNLib.Colors.Clouds )
    button:SetHoveredColor( GNLib.Colors.Silver )
    function button:DoClick()
        frame:Remove()
        if callback then callback() end
    end

    return frame
end

function GNLib.DermaStringRequest( title, confirm_text, cancel_text, callback, ... )
    title = title or "Title"
    text = text or "Text"
    confirm_text = confirm_text or "OK"
    cancel_text = cancel_text or "Cancel"

    local frame, close = GNLib.CreateFrame( title )
    frame:SetSize( ScrW() / 3, 50 * #{ ... } + 15 * (#{ ... } - 1) )
    frame:Center()

    local W, H = frame:GetSize()
    close:SetPos( W - 30, 5 )

    local textentries = {}
    if ... then 
        for k, v in pairs( { ... } ) do
            local textentry = vgui.Create( "GNTextEntry", frame )
            textentry:SetPos( 15, 30 * k + 15 * (k - 1) )
            textentry:SetWide( W - 30 )
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

    local button = vgui.Create( "GNButton", frame )
    button:SetPos( W / 2 - button:GetWide() - 15, H / 2 - button:GetTall() / 2 + H / 2.45 )
    button:SetText( confirm_text )
    button:SetColor( GNLib.Colors.Clouds )
    button:SetHoveredColor( GNLib.Colors.Silver )
    function button:DoClick()
        frame:Remove()
        
        local values = {}
        for k, v in pairs( textentries ) do 
            if #v:GetValue() > 0 then table.insert( values, v:GetValue() ) else table.insert( values, v:GetPlaceholder() ) end
        end
        if callback then callback( unpack( values ) ) end
    end

    local cancel_button = vgui.Create( "GNButton", frame )
    cancel_button:SetPos( W / 2 + 15, H / 2 - cancel_button:GetTall() / 2 + H / 2.45 )
    cancel_button:SetText( cancel_text )
    cancel_button:SetColor( GNLib.Colors.Clouds )
    cancel_button:SetHoveredColor( GNLib.Colors.Silver )
    function cancel_button:DoClick()
        frame:Remove()
    end

    return frame
end