local PANEL = {}

AccessorFunc( PANEL, "icon", "Icon" )

AccessorFunc( PANEL, "outline_color", "OutlineColor" )
AccessorFunc( PANEL, "hovered_outline_color", "HoveredOutlineColor" )

function PANEL:Init()
    self:SetSize( 250, 32 )

    self:SetColor( GNLib.Colors.Silver )
    self:SetHoveredColor( GNLib.Colors.Clouds )
    self:SetOutlineColor( GNLib.Colors.Concrete )
    self:SetHoveredOutlineColor( GNLib.Colors.Asbestos )

    self.icon = Material( "icon16/zoom.png", "smooth" )
end

function PANEL:Paint( w, h )
    GNLib.DrawElipse( 0, 0, w, h, self:IsHovered() and self:GetHoveredColor() or self:GetColor() )
    --GNLib.DrawOutlinedElipse( 1, 1, w - 1, h - 1, 1, self:IsHovered() and self:GetHoveredOutlineColor() or self:GetOutlineColor() )

    surface.SetDrawColor( color_white )
    surface.SetMaterial( self.icon )
    surface.DrawTexturedRect( 10, 4, h - 6, h - 6 )
end

vgui.Register( "GNIconTextEntry", PANEL, "GNTextEntry" )