local PANEL = {}

AccessorFunc( PANEL, "speed", "Speed", FORCE_NUMBER )
AccessorFunc( PANEL, "show_circle", "ShowCircle", FORCE_BOOL )
AccessorFunc( PANEL, "circle_radius", "CircleRadius", FORCE_NUMBER )

AccessorFunc( PANEL, "bar_tall", "BarTall", FORCE_NUMBER )
AccessorFunc( PANEL, "circle_color", "CircleColor" )
AccessorFunc( PANEL, "fill_color", "FillColor" )
AccessorFunc( PANEL, "text_color", "TextColor" )
AccessorFunc( PANEL, "color", "Color" )

AccessorFunc( PANEL, "font", "Font" )

Derma_Hook( PANEL, "Panel", hookName, typeName)

function PANEL:Init()
    self:SetSize( 200, 25 )
    self.percentage = 0
    self.shown_percentage = 0

    self.speed = 2

    self.show_circle = true
    self.circle_radius = self:GetTall() / 2

    self.bar_tall = self:GetTall()

    self:SetColor( GNLib.Colors.Clouds )

    self.circle_color = GNLib.Colors.Turquoise
    self.fill_color = GNLib.Colors.GreenSea
end

function PANEL:SetPercentage( percent )
    self.percentage = math.Clamp( percent, 0, 1 )
end

function PANEL:GetPercentage()
    return self.percentage
end

function PANEL:Paint( w, h )
    if self.percentage ~= self.shown_percentage then
        self.shown_percentage = Lerp( FrameTime() * self.speed, self.shown_percentage, self.percentage )
    end

    GNLib.DrawElipse( 0, h / 2 - self.bar_tall / 2, w, self.bar_tall, self.color )
    GNLib.DrawElipse( 0, h / 2 - self.bar_tall / 2, math.Clamp( self.shown_percentage * w, h, w ), self.bar_tall, self.fill_color )

    if self.show_circle then
        local x, y = math.Clamp( self.shown_percentage * w, h, w ) - self.circle_radius, h / 2
        GNLib.DrawCircle( x, y, self.circle_radius, _, _, self.circle_color )
        draw.SimpleText( math.Round( self.shown_percentage * 100 ) .. "%", font or "GNLFontB10", x, y, self.text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    else
        local x, y = math.Clamp( self.shown_percentage * w / 2, h / 3 * 1.5, w ), h / 2
        draw.SimpleText( math.Round( self.shown_percentage * 100 ) .. "%", font or "GNLFontB10", x, y, self.text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )        
    end
end

vgui.Register( "GNProgress", PANEL, "GNPanel" )
