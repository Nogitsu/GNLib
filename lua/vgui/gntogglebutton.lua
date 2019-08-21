local PANEL = {}

AccessorFunc( PANEL, "color_on", "ColorOn" )
AccessorFunc( PANEL, "color_off", "ColorOff" )

AccessorFunc( PANEL, "color_back_on", "ColorBackOn" )
AccessorFunc( PANEL, "color_back_off", "ColorBackOff" )

AccessorFunc( PANEL, "color_back", "ColorBack" )

AccessorFunc( PANEL, "toggled", "Toggled" )
AccessorFunc( PANEL, "speed", "Speed" )
AccessorFunc( PANEL, "circle_r", "CircleRadius" )


function PANEL:Init()
    self:SetSize( 50, 25 )
    self:SetDefaultCursor( "hand" )
    self:SetCursor( "hand" )

    self.toggled = false
    self.speed = 5

    self.circle_x = self:GetWide() * 0.25
    self.circle_r = self:GetTall() / 2 - 2

    self.color_on = GNLib.Colors.Emerald
    self.color_off = GNLib.Colors.Alizarin

    self.color_back_on = GNLib.Colors.Nephritis
    self.color_back_off = GNLib.Colors.Pomegranate

    self.color_back = self.color_back_off
    self.color = self.color_off
end

function PANEL:OnToggled()
end

--  > Override existing
function PANEL:Paint( w, h )
    local left_pos, right_pos = self:GetWide()*0.25, self:GetWide()*0.75
    
    if self.toggled and self.circle_x < right_pos then

        self.circle_x = Lerp( FrameTime() * self.speed, self.circle_x, right_pos )
        self.color = GNLib.LerpColor( FrameTime() * self.speed, self.color, self.color_on )
        self.color_back = GNLib.LerpColor( FrameTime() * self.speed, self.color_back, self.color_back_on )

    elseif not self.toggled and self.circle_x > left_pos then

        self.circle_x = Lerp( FrameTime() * self.speed, self.circle_x, left_pos )
        self.color = GNLib.LerpColor( FrameTime() * self.speed, self.color, self.color_off )
        self.color_back = GNLib.LerpColor( FrameTime() * self.speed, self.color_back, self.color_back_off )

    end

    GNLib.DrawElipse( 0, 0, w, h, self.color_back )
    GNLib.DrawCircle( self.circle_x, h/2, self.circle_r, _, _, self.color )
end

function PANEL:DoClick()
    self.toggled = not self.toggled
    self:OnToggled( self.toggled )
end

vgui.Register( "GNToggleButton", PANEL, "GNPanel" )
