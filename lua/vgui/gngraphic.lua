local PANEL = {}

function PANEL:Init()
    self:SetSize( 350, 150 )
end

vgui.Register( "GNGraphic", PANEL, "GNPanel" )