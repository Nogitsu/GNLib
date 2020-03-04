local PANEL = {}

AccessorFunc( PANEL, "hovered_color", "HoveredColor" )
AccessorFunc( PANEL, "text_color", "TextColor" )

AccessorFunc( PANEL, "max_menu_tall", "MaxMenuTall", FORCE_NUMBER )

AccessorFunc( PANEL, "font", "Font", FORCE_STRING )
AccessorFunc( PANEL, "value", "Value", FORCE_STRING )

AccessorFunc( PANEL, "reseter", "Reseter", FORCE_BOOL )

--  > Base functions

function PANEL:Init()
    self.menu_offset = 5

    self:SetSize( 100, 25 )
    self:SetText( "" )
    self:SetCursor( "hand" ) 

    self.value = ""
    self.selected = nil
    self.reseter = false
    self.menu_tall = 0
    self.max_menu_tall = 200
    self.choices = {}

    self.font = "GNLFontB15"
    self.color = GNLib.Colors.Clouds
    self.hovered_color = GNLib.Colors.Silver
    self.text_color = GNLib.Colors.WetAsphalt
end

function PANEL:Paint( w, h )
    GNLib.DrawElipse( 0, 0, w, h, self:IsHovered() and self.hovered_color or self.color )
    GNLib.DrawTriangle( w - 15, h / 2, 8, self:IsHovered() and GNLib.Colors.MidnightBlue or GNLib.Colors.WetAsphalt, self:IsMenuOpen() and 2 or 0 )

    draw.SimpleText( self:GetSelected() and self:GetSelected().text or self:GetValue(), self.font, 10, h / 2, self.text_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

function PANEL:IsHovered()
    local x, y = self:LocalCursorPos()
    return x <= self:GetWide() and y <= self:GetTall() and 0 <= x and 0 <= y
end

function PANEL:DoClick()
    if self:IsMenuOpen() then 
        self:CloseMenu()
    else
        self:OpenMenu()
    end
end

function PANEL:OnRemove()
    self:CloseMenu()
end

--  > Custom functions

function PANEL:OnSelect( id, value, data )
    --  > Overwrite this func
end

function PANEL:OnReset()
    --  > Overwrite this func
end

function PANEL:AddChoice( text, data, auto_select )
    self.choices[#self.choices + 1] = { text = text, data = data }
    if auto_select then self.selected = #self.choices end

    self:CalcTall()
end

function PANEL:CalcTall()
    self.menu_tall = math.min( self:GetTall() + self.menu_offset + ( #self.choices + ( self.reseter and 1 or 0 ) ) * self:GetTall(), self.max_menu_tall )
end

function PANEL:SetReseter( bool )
    if bool == self:GetReseter() then return end

    self.reseter = bool

    self:CalcTall()
end

function PANEL:GetValue()
    local selected = self:GetSelected()
    return selected and selected.text or self.value
end

function PANEL:GetSelected()
    return self.choices[self.selected]
end

function PANEL:SetSelected( id )
    self.selected = math.Clamp( id, 1, #self.choices )
end

function PANEL:OpenMenu()
    local W, H = self:GetSize()

    local parent_x, parent_y = 0, 0
    do 
        local parent = self:GetParent()
        while parent do
            local x, y = parent:GetPos()
            parent_x, parent_y = parent_x + x, parent_y + y

            parent = parent:GetParent()
        end
    end

    --  > Set good choice width
    local choice_w = W

    surface.SetFont( self.font )
    for i, v in ipairs( self.choices ) do
        choice_w = math.max( choice_w, surface.GetTextSize( v.text ) )
    end

    local button_space = 10
    local menu_w = choice_w + button_space * 2
    --  > Create Menu scrollpanel
    local x, y = self:GetPos()
    self.Menu = vgui.Create( "DScrollPanel" )
        self.Menu:SetSize( menu_w, self.menu_tall - self:GetTall() )
        self.Menu:SetPos( x + parent_x + self:GetWide() / 2 - self.Menu:GetWide() / 2, y + parent_y + self:GetTall() + self.menu_offset )
        self.Menu.Paint = function() end
        self.Menu:MakePopup()

        local vbar = self.Menu:GetVBar()
        vbar:SetHideButtons( true )
        vbar:SetWide( 0 )

    --  > Create choices
    local y = 0
    local function add_choice( id, is_first, is_last, text, data, reseter )
        local hovered_color = reseter and GNLib.Colors.Pomegranate or self.hovered_color
        local default_color = reseter and GNLib.Colors.Alizarin or self.color

        local choice = self.Menu:Add( "DButton" )
            choice:SetPos( 0, y * self:GetTall() )
            choice:SetWide( menu_w ) 
            choice:SetTall( self:GetTall() )
            choice:SetText( "" )
            choice.Paint = function( _self, w, h ) 
                draw.RoundedBoxEx( 8, 0, 0, w, h, _self:IsHovered() and hovered_color or default_color, is_first, is_first, is_last, is_last )

                draw.SimpleText( text, self.font, reseter and w / 2 or 10, h / 2, reseter and GNLib.Colors.Clouds or self.text_color, reseter and TEXT_ALIGN_CENTER or TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )                
            end
            choice.DoClick = function()
                if not reseter then
                    self:SetSelected( id )
                    self:OnSelect( id, text, data )
                else
                    self:OnReset()
                    self.selected = nil
                end

                self:CloseMenu()
            end

        y = y + 1
    end

    for i, v in ipairs( self.choices ) do
        add_choice( i, i == 1, not self:GetReseter() and i == #self.choices or false, v.text, v.data, false )
    end

    if self:GetReseter() then
        add_choice( _, #self.choices == 0, true, "x", 0, true )
    end
end

function PANEL:CloseMenu()
    if not IsValid( self.Menu ) then return end

    self.Menu:Remove()
    self.Menu = nil
end

function PANEL:IsMenuOpen()
    return self.Menu and true or false
end

vgui.Register( "GNComboBox", PANEL, "DButton" )