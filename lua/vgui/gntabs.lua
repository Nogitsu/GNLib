local PANEL = {}

function PANEL:Init()
    self.scroll_tabs = self:Add( "DHorizontalScroller" )
    self.scroll_tabs:Dock( TOP )
    self.scroll_tabs:SetTall( 32 )
    self.scroll_tabs:SetOverlap( -5 )
    function self.scroll_tabs.btnLeft:Paint( w, h )
        draw.RoundedBoxEx( h / 3, 0, 0, w, h, GNLib.Colors.MidnightBlue, true, false, true, false )

        draw.SimpleText( "<", "GNLFontB13", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    function self.scroll_tabs.btnRight:Paint( w, h )
        draw.RoundedBoxEx( h / 3, 0, 0, w, h, GNLib.Colors.MidnightBlue, false, true, false, true )

        draw.SimpleText( ">", "GNLFontB13", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    self.tab_render = self:Add( "DPanel" )
    self.tab_render:Dock( FILL )
    function self.tab_render:Paint( w, h )
        draw.RoundedBoxEx( 5, 0, 0, w, h, GNLib.Colors.WetAsphalt, true, true )
    end

    self.tabs = {}

    self.tab_color = GNLib.Colors.WetAsphalt
    self.selected_tab_color = GNLib.Colors.PeterRiver
end

function PANEL:Paint( w, h )
    
end

function PANEL:OnTabClicked( tab_name )
end

local function add_tab( self, name )
    if not self.tabs[ name ] then return error( "No tab entitled '" .. name .. "'." ) end

    local button = self.scroll_tabs:Add( "DButton" )
    button:SetTall( self.scroll_tabs:GetTall() )
    button:SetText( name )
    function button.Paint( _, w, h )
        draw.RoundedBoxEx( 5, 0, 0, w, h, (self.selected_tab and self.selected_tab == name) and self.selected_tab_color or self.tab_color, true, true )

        draw.SimpleText( name, "GNLFontB13", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        return true
    end
    function button.DoClick()
        self:SetTab( name )
        self:OnTabClicked( name )
    end
    self.scroll_tabs:AddPanel( button )
end

function PANEL:AddTab( name, creating )
    if not name then return error( "Attempt to index 'name' a nil value." ) end
    if not isstring( name ) then return error( "Attempt to index 'name' a non-string value." ) end

    if not creating then return error( "Attempt to index 'creating' a nil value." ) end
    if not isfunction( creating ) then return error( "Attempt to index 'creating' a non-function value." ) end

    self.tabs[ name ] = creating

    add_tab( self, name )
end

function PANEL:SetTab( name )
    if not self.tabs[ name ] then return error( "No tab entitled '" .. name .. "'." ) end

    self.tab_render:Clear()

    self.tabs[ name ]( self.tab_render )

    self.selected_tab = name
end

vgui.Register( "GNTabs", PANEL, "DPanel" )