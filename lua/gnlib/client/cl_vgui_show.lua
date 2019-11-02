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

        --GNLib.DrawOutlinedElipse( 50, 250, 200, 24, 5, GNLib.Colors.Pomegranate )

        --GNLib.DrawOutlinedRoundedRect( 8, 350, 75, 200, 200, 15, GNLib.Colors.Alizarin )
        --GNLib.DrawOutlinedRoundedRect( 4, 650, 250, 200, 24, 5, GNLib.Colors.Emerald )
    end

    local iconbutton = vgui.Create( "GNIconButton", main )
    iconbutton:SetPos( 350, 300 )
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

    local combobox = vgui.Create( "GNComboBox", main )
        combobox:SetPos( 500, 450 )
        combobox:SetWide( 150 )
        combobox:SetValue( "Get a fruit" )
        combobox:AddChoice( "Banana", 55 )
        combobox:AddChoice( "Potato", 42 )
        combobox:AddChoice( "Ducker", 1 )
        --combobox:AddChoice( "Bad Duck", -1 )
        --combobox:AddChoice( "Bad Duck 2", -1 )
        combobox:SetReseter( true )
        combobox.OnSelect = function( self, id, txt, data )
            print( id, txt, data )
        end

    local groupbox = vgui.Create( "GNGroupBox", main )
        groupbox:SetPos( 700, 450 )
        groupbox:SetSize( 400, 250 )
        groupbox:SetColor( GNLib.Colors.Clouds )
        groupbox:SetTitle( "Hey Hey, I am a GroupBox" )
        groupbox:SetFont( "Default" )

    local button = vgui.Create( "GNButton", groupbox )
        button:Dock( TOP )
        button:SetText( "Bouton ovale tout beau avec un auto update size" )

    local taglist = vgui.Create( "GNTagList", groupbox )
        taglist:SetPos( 25, 75 )
        taglist:SetTitle( "Supported internet explorers" )
        taglist:SetFont( "GNLFontB15" )
        taglist:AddTag( "Google", GNLib.Colors.Alizarin, GNLib.Colors.Clouds )
        taglist:AddTag( "Firefox", GNLib.Colors.Pumpkin, GNLib.Colors.Clouds )
        taglist:AddTag( "Internet Explorer", GNLib.Colors.PeterRiver, GNLib.Colors.Clouds )
        taglist:AddTag( "Exploducker", GNLib.Colors.SunFlower, GNLib.Colors.Clouds )

    local numentry = vgui.Create( "GNNumEntry", groupbox )
        numentry:SetPos( 25, 150 )
        numentry:SetSize( 125, 35 )
        numentry:SetTitle( "Your Age" )
        numentry:SetMin( 0 )
        numentry:SetMax( 20 )
        numentry:SetValue( 13 )
        numentry:SetHoveredColor( GNLib.Colors.Silver )
        numentry:SetColor( GNLib.Colors.Clouds )

    local colorpicker = vgui.Create( "GNColorPicker", groupbox )
        colorpicker:SetPos( 175, 125 )
        colorpicker:SetSize( 100, 100 )
        colorpicker.OnColorChanged = function( self, clr )
            numentry:SetColor( clr )
        end

    local carousel = vgui.Create( "GNCarousel", main )
        carousel:SetPos( 750, 50 )
        --carousel:AddImage( "miitw.png", "Medieval Total War II" )
        --carousel:AddImage( "rometw.png", "Rome Total War" )
        --carousel:AddImage( "rometw2.png", "Rome Total War : Julii vs. Greeks" )
end
concommand.Add( "gnlib_vgui", GNLib.OpenVGUIPanel )
