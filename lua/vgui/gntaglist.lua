--  > Voir pour l'espacement en fonction de la taille de la font entre le titre et les tags

local PANEL = {}

AccessorFunc( PANEL, "title_color", "TitleColor" )

AccessorFunc( PANEL, "title", "Title", FORCE_STRING )
AccessorFunc( PANEL, "font", "Font", FORCE_STRING )

AccessorFunc( PANEL, "offset", "Offset", FORCE_NUMBER )

function PANEL:Init()
    self:SetSize( 150, 35 )

    self.title = "Tags"
    self.font = "GNLFontB15"

    self.title_color = GNLib.Colors.Clouds
    self.tags = {}

    self.x_offset = 5
    self.y_offset = 15
end

function PANEL:Paint( w, h )
    surface.SetFont( self.font )
    local W, H = surface.GetTextSize( self.title )

    self.y_offset = H

    surface.SetTextColor( self.title_color )
    surface.SetTextPos( self.x_offset + 2, 0 )
    surface.DrawText( self.title )

    surface.SetDrawColor( self.title_color )
    surface.DrawLine( 0, H / 2, self.x_offset, H / 2 )
    surface.DrawLine( W + 8, H / 2, w, H / 2 )
end

function PANEL:SizeToContents()
    self:SetWide( self:GetNextTagX() - self.x_offset )
    
    local first_child = self:GetChild( 0 )
    if first_child then
        self:SetTall( first_child:GetTall() + self.y_offset * 2 )
    end
end

function PANEL:GetNextTagX()
    local x = 0
    
    for k, v in pairs( self.tags ) do
        x = x + v:GetWide() + self.x_offset
    end

    if self.adder then
        x = x + self.adder:GetTall() + self.x_offset
    end

    return x
end

--[[
function PANEL:SetAdder( bool )
    if bool and self.adder then return end
    if not bool and self.adder then return self.adder:Remove() end

    local x = self:GetNextTagX()

    self.adder = self:Add( "DButton" )
    self.adder:SetPos( x, 0 )
    self.adder:SetSize( self:GetTall(), self:GetTall() )
    self.adder:SetText( "" )
    self.adder.Paint = function( _self, w, h )
        GNLib.DrawElipse( 0, 0, w, h, _self:IsHovered() and GNLib.Colors.Concrete or GNLib.Colors.Silver )

        draw.SimpleText( "+", self.font, h / 2, h / 2, GNLib.Colors.Clouds, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    self.adder.DoClick = function()
        self.adder:Remove()
        self.adder = nil

        self:AddTag( "Tag" )

        self:SetAdder( true )
    end

    self:SizeToContents()
end

function PANEL:GetAdder()
    return self.adder
end
]]

function PANEL:AddTag( text, color, text_color )
    local tag = self:Add( "GNTag" )
        tag:SetPos( self:GetNextTagX(), self.y_offset + 3 )
        tag:SetText( text or "Tag" )
        tag:SetFont( self.font )
        tag:SizeToContents()
        if color then tag:SetColor( color ) end
        if text_color then tag:SetTextColor( text_color ) end

    self.tags[#self.tags + 1] = tag

    self:SizeToContents()

    return tag
end

vgui.Register( "GNTagList", PANEL, "DPanel" )