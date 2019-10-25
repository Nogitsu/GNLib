local PANEL = {}

AccessorFunc( PANEL, "hovered_color", "HoveredColor" )

AccessorFunc( PANEL, "text_color", "TextColor" )

AccessorFunc( PANEL, "font", "Font", FORCE_STRING )

function PANEL:Init()
    self:SetSize( 150, 25 )
    self:SetText( "" )
    self.self_h = 25

    self.selected = nil
    self.choices = {}

    self.font = "GNLFontB15"
    self.color = GNLib.Colors.Clouds
    self.hovered_color = GNLib.Colors.Silver
    self.text_color = GNLib.Colors.WetAsphalt
end

function PANEL:Paint( w, h )
    GNLib.DrawElipse( 0, 0, w, self.self_h, self:IsHovered() and self.hovered_color or self.color )
    GNLib.DrawTriangle( w - 15, self.self_h / 2, 8, CurTime(), self:IsHovered() and GNLib.Colors.MidnightBlue or GNLib.Colors.WetAsphalt )

    draw.SimpleText( self:GetSelected() and self:GetSelected().text, self.font, 10, self.self_h / 2, self.text_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

function PANEL:AddChoice( text, data )
    self.choices[#self.choices + 1] = { text = text, data = data }
    self.selected = #self.choices

    self:SetTall( self:GetTall() + 30 )
end

function PANEL:IsHovered()
    local x, y = self:LocalCursorPos()
    return x <= self:GetWide() and y <= self.self_h and 0 <= x and 0 <= y
end

function PANEL:Think()
    if self:IsHovered() then
        self:SetCursor( "hand" ) 
    else
        self:SetCursor( "none" )
    end
end

function PANEL:GetSelected()
    return self.choices[self.selected]
end

function PANEL:SetSelected( id )
    self.selected = math.Clamp( id, 1, #self.choices )
end

function PANEL:DoClick()
    if self:IsMenuOpen() then 
        self:CloseMenu()
    else
        self:OpenMenu()
    end
end

function PANEL:OpenMenu()
    local W, H = self:GetSize()

    self.Menu = self:Add( "DPanel" )
        self.Menu:SetPos( 0, self.self_h )
        self.Menu:SetSize( W, #self.choices * 30 )
        self.Menu.Paint = function() end

    local button_space = 10
    for i, v in ipairs( self.choices ) do
        local choice = self.Menu:Add( "DButton" )
            choice:SetPos( button_space, 5 + ( i - 1 ) * self.self_h )
            choice:SetSize( W - button_space * 2, self.self_h )
            choice:SetText( "" )
            choice.Paint = function( _self, w, h ) 
                draw.RoundedBoxEx( 8, 0, 0, w, h, _self:IsHovered() and self.hovered_color or self.color, i == 1, i == 1, i == #self.choices, i == #self.choices )

                draw.SimpleText( v.text, self.font, 10, h / 2, self.text_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )                
            end
            choice.DoClick = function()
                self:SetSelected( i )
                self:CloseMenu()
            end
    end
end

function PANEL:CloseMenu()
    self.Menu:Remove()
    self.Menu = nil
end

function PANEL:IsMenuOpen()
    return self.Menu and true or false
end

vgui.Register( "GNComboBox", PANEL, "DButton" )