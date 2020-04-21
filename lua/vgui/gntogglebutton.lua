local PANEL = {}

AccessorFunc( PANEL, "color_on", "ColorOn" )
AccessorFunc( PANEL, "color_off", "ColorOff" )

AccessorFunc( PANEL, "color_back_on", "ColorBackOn" )
AccessorFunc( PANEL, "color_back_off", "ColorBackOff" )

AccessorFunc( PANEL, "text_color", "TextColor" )

AccessorFunc( PANEL, "toggle", "Toggle" )
AccessorFunc( PANEL, "speed", "Speed", FORCE_NUMBER )

AccessorFunc( PANEL, "circle_r", "CircleRadius", FORCE_NUMBER )
AccessorFunc( PANEL, "bar_tall", "BarTall", FORCE_NUMBER )

AccessorFunc( PANEL, "show_text", "ShowText", FORCE_BOOL )
AccessorFunc( PANEL, "font", "Font", FORCE_STRING )

function PANEL:Init()
    self:SetSize( 50, 25 )
    --self:SetCursor( "hand" )
    self.first_time = true

    self.toggle = false
    self.speed = 5

    self.show_text = false
    self.font = "GNLFontB10"
    self.text_color = GNLib.Colors.Clouds

    self.bar_tall = self:GetTall()

    self.circle_x = self:GetWide() * 0.25
    self.circle_r = self:GetTall() / 2 - 2

    self.color_on = GNLib.Colors.Emerald
    self.color_off = GNLib.Colors.Alizarin

    self.color_back_on = GNLib.Colors.Nephritis
    self.color_back_off = GNLib.Colors.Pomegranate

    self.color_back = self.color_back_off
    self.color = self.color_off
end

function PANEL:Paint( w, h )
    local left_pos, right_pos = self:GetWide() * 0.25, self:GetWide() * 0.75
    
    local spd = FrameTime() * self.speed
    if self.toggle and self.circle_x < right_pos then

        self.circle_x = Lerp( spd, self.circle_x, right_pos )
        self.color = GNLib.LerpColor( spd, self.color, self.color_on )
        self.color_back = GNLib.LerpColor( spd, self.color_back, self.color_back_on )

        self.first_time = false
    elseif not self.toggle and self.circle_x > left_pos then

        self.circle_x = Lerp( spd, self.circle_x, left_pos )
        self.color = GNLib.LerpColor( spd, self.color, self.color_off )
        self.color_back = GNLib.LerpColor( spd, self.color_back, self.color_back_off )

        self.first_time = false
    end

    if self.first_time then
        self.color = self.color_off
        self.color_back = self.color_back_off
    end

    GNLib.DrawElipse( 0, h / 2 - self.bar_tall / 2, w, self.bar_tall, self.color_back )

    if self:GetShowText() then
        draw.SimpleText( "ON", self.font, left_pos, h / 2, self.text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( "OFF", self.font, right_pos, h / 2, self.text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    GNLib.DrawCircle( self.circle_x, h / 2, self.circle_r, nil, nil, self.color )

    return true
end

function PANEL:DoClick()
    self.toggle = not self.toggle
    self:OnToggled( self.toggle )
end

function PANEL:SetToggle( toggle )
    if not ( self.toggle == toggle ) then
        self.toggle = toggle
        self:OnToggled( toggle )
    end
end

function PANEL:OnToggled( toggle )
    --  > For overwrite
end

PANEL.SetColor = nil
PANEL.GetColor = nil

vgui.Register( "GNToggleButton", PANEL, "DButton" )
