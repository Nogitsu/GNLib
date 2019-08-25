function GNLib.OpenVGUIPanel()
    --if not LocalPlayer():IsAdmin() then return end
    local main = GNLib.CreateFrame( "GNLib - VGui Display" )

    --  > Toggle credits mod
    local toggleButton = vgui.Create( "GNToggleButton", main )
    toggleButton:SetPos( 50, 50 )
    toggleButton:SetColor( GNLib.Colors.MidnightBlue )
    toggleButton:SetColorBack( GNLib.Colors.Asbestos )
    function toggleButton:OnToggled( toggled )
        main.color = toggled and GNLib.Colors.Asbestos or GNLib.Colors.MidnightBlue
        main.color2 = toggled and GNLib.Colors.Concrete or GNLib.Colors.WetAsphalt

        self.color_on = GNLib.Colors.Asbestos
        self.color_off = GNLib.Colors.MidnightBlue

        self.color_back_on = GNLib.Colors.MidnightBlue
        self.color_back_off = GNLib.Colors.Asbestos
    end

    local progress = vgui.Create( "GNProgress", main )
    progress:SetPos( 50, 100 )
    progress:SetPercentage( 0 )
    progress:SetBarTall( 9 )

    local progressn = vgui.Create( "GNProgress", main )
    progressn:SetPos( 50, 150 )
    progressn:SetShowCircle( false )
    progressn:SetPercentage( 1 )
    progressn:SetSpeed( 1 )

    local slider = vgui.Create( "GNSlider", main )
    slider:SetPos( 50, 200 )
    function slider:OnValueChanged( _, percent )
        progress:SetPercentage( 1 - percent )
    end

    timer.Simple( 5, function()
        if not IsValid( main ) then return end
        progress:SetPercentage( 1 )
        progressn:SetPercentage( 0 )
    end )

    main.oldPaint = main.Paint

    function main:Paint( w, h )
        self:oldPaint( w, h )

        GNLib.DrawOutlinedElipse( 50, 250, 200, 24, 5, GNLib.Colors.Pomegranate )

        GNLib.DrawOutlinedRoundedRect( 8, 350, 75, 200, 200, 15, GNLib.Colors.Alizarin )
        GNLib.DrawOutlinedRoundedRect( 4, 650, 250, 200, 24, 5, GNLib.Colors.Emerald )
    end

    local button = vgui.Create( "GNButton", main )
    button:SetPos( 50, 300 )
    button:SetText( "Bouton ovale tout beau avec un auto update size, wow, amazing :kappa:" )

    local iconbutton = vgui.Create( "GNIconButton", main )
    iconbutton:SetPos( button.x + button:GetWide() + 50, 300 )
    iconbutton:SetRadius( 45 )
    iconbutton:SetIconRadius( 45 )
    iconbutton:SetIcon( Material("icon32/tool.png","smooth") )
    function iconbutton:DoClick()
        surface.PlaySound("garrysmod/save_load" .. math.random( 1, 4) .. ".wav")
    end

    local textentry = vgui.Create( "GNTextEntry", main )
    textentry:SetPos( 50, 350 )
    textentry:SetSize( 250, 35  )
    textentry:SetTitle( "Your name" )

    local searchentry = vgui.Create( "GNIconTextEntry", main )
    searchentry:SetPos( 50, 400 )

    local graphic = vgui.Create( "GNGraphic", main )
    graphic:SetPos( 50, 450 )
end
concommand.Add( "gnlib_vgui", GNLib.OpenVGUIPanel )
