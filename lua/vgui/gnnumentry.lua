local PANEL = {}

AccessorFunc( PANEL, "min_value", "Min", FORCE_NUMBER )
AccessorFunc( PANEL, "max_value", "Max", FORCE_NUMBER )

local function initButtons( self )
    local h, text_h = self:GetPaintTall()

    self:Clear()

    self.plusButton = self:Add( "Button" )
    self.plusButton:SetSize( 25, h / 2 + 1 )
    self.plusButton:SetPos( self:GetWide() - 25, text_h )
    self.plusButton:SetText( "" )
    self.plusButton:SetActionFunction( function()
        self:SetValue( self:GetValue() + 1 )
        self:OnChange()
    end )
    self.plusButton.Paint = function( _self, w, h )
        draw.RoundedBoxEx( 4, 0, 0, w, h, _self:IsHovered() and self:GetHoveredColor() or self:GetColor(), _, true )
        
        draw.SimpleText( "+", self:GetFont(), w / 2 - 1, h / 2 - 1, GNLib.Colors.WetAsphalt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end 

    self.minusButton = self:Add( "Button" )
    self.minusButton:SetSize( self.plusButton:GetSize() )
    self.minusButton:SetPos( self:GetWide() - 25, text_h + h / 2 )
    self.minusButton:SetText( "" )
    self.minusButton:SetActionFunction( function()
        self:SetValue( self:GetValue() - 1 )
        self:OnChange()
    end )
    self.minusButton.Paint = function( _self, w, h )      
        draw.RoundedBoxEx( 4, 0, 0, w, h, _self:IsHovered() and self:GetHoveredColor() or self:GetColor(), _, _, _, true )

        draw.SimpleText( "-", self:GetFont(), w / 2 - 1, h / 2 - 1, GNLib.Colors.WetAsphalt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end 
end

function PANEL:Init()
    self:SetTitle( "NumEntry" )
    
    self:SetValue( 0 )
    self:SetMin( -math.huge )
    self:SetMax( math.huge )

    self:SetNumeric( true )

    initButtons( self )
end

function PANEL:AllowInput( char )
    if self:CheckNumeric( char ) then return true end

    surface.SetFont( self.font_value )
    local _, h = surface.GetTextSize( char )

    return surface.GetTextSize( self:GetText() ) > self:GetWide() - h - 25
end

function PANEL:OnChange()
    if #self:GetValue() == 0 then return self:SetValue( 0 ) end

    self:SetValue( math.Clamp( self:GetValue(), self:GetMin(), self:GetMax() ) )
end

function PANEL:OnSizeChanged( w, h )
    initButtons( self )
end

vgui.Register( "GNNumEntry", PANEL, "GNTextEntry" )