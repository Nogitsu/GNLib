local PANEL = {}

AccessorFunc( PANEL, "color", "Color" )

local ColorWheel = Material( "gnlib/colorwheel.png" )

function PANEL:Init()
    self:SetSize( 150, 150 )

    self.Knob:NoClipping( false )
    self.Knob.Paint = function( _self, w, h )
        --GNLib.DrawOutlinedCircle( w / 2, h / 2, h / 2 - 2, 2, 0, 360, GNLib.Colors.Clouds )
        surface.DrawCircle( h / 2, h / 2, h / 2 - 3, self:IsEditing() and GNLib.Colors.Concrete or GNLib.Colors.Silver )
    end

    self:SetLockX()
    self:SetLockY()
end

--[[
function PANEL:PerformLayout( w, h )
    DSlider.PerformLayout( self )
end
]]

function PANEL:Paint( w, h )
    surface.SetDrawColor( color_white )
    surface.SetMaterial( ColorWheel )
    surface.DrawTexturedRect( 0, 0, w, h )
end

function PANEL:GetPosColor( x, y )
    local x, y = x * ColorWheel:Width(), y * ColorWheel:Height()

    local clr = ColorWheel:GetColor( x, y ) 

    return Color( clr.r, clr.g, clr.b )
end

function PANEL:OnColorChanged( clr )
    --  > Overwrite
end

function PANEL:TranslateValues( x, y )
    local clr = self:GetPosColor( x, y )

    self:SetColor( clr )
    self:OnColorChanged( clr )

    return math.min( x, self:GetWide() ), math.min( y, self:GetTall() ) 
end

vgui.Register( "GNColorPicker", PANEL, "DSlider" )