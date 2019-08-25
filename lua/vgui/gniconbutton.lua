local PANEL = {}

AccessorFunc( PANEL, "hovered_color", "HoveredColor" )
AccessorFunc( PANEL, "icon", "Icon" )
AccessorFunc( PANEL, "icon_radius", "IconRadius" )
AccessorFunc( PANEL, "clicked_color", "ClickedColor" )

function PANEL:Init()
    self:SetSize( 20, 20 )
    self:SetCursor( "hand" )
    self:SetColor( GNLib.Colors.Pomegranate )

    self.icon = Material( "icon16/error.png" )

    self.icon_radius = 16
    self.radius = 10

    self.hovered_color = GNLib.Colors.Pumpkin
    self.clicked_color = GNLib.Colors.Alizarin
end

function PANEL:SetRadius( radius )
    self.radius = radius
    self:SetSize( radius*2, radius*2 )
end

--  > Override existing
function PANEL:Paint( w, h )
    GNLib.DrawCircle( w/2, h/2, self.radius, _, _, self.clicking and self.clicked_color or self:IsHovered() and self.hovered_color or self.color )

    surface.SetDrawColor( color_white )
    surface.SetMaterial( self.icon )
    surface.DrawTexturedRect( w / 2 - self.icon_radius / 2, h / 2 - self.icon_radius / 2, self.icon_radius, self.icon_radius )
end

vgui.Register( "GNIconButton", PANEL, "GNPanel" )
