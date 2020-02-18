local PANEL = {}

AccessorFunc( PANEL, "hovered_color", "HoveredColor" )
AccessorFunc( PANEL, "text_color", "TextColor" )

AccessorFunc( PANEL, "max_menu_tall", "MaxMenuTall", FORCE_NUMBER )

AccessorFunc( PANEL, "font", "Font", FORCE_STRING )
AccessorFunc( PANEL, "value", "Value", FORCE_STRING )

AccessorFunc( PANEL, "reseter", "Reseter", FORCE_BOOL )

function PANEL:Init()
    self.self_h = 25
    self.menu_offset = 5

    self:SetSize( 100, self.self_h )
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

function PANEL:OnSelect( id, value, data )
    --  > Overwrite this func
end

function PANEL:OnReset()
    --  > Overwrite this func
end

function PANEL:Paint( w, h )
    GNLib.DrawElipse( 0, 0, w, h, self:IsHovered() and self.hovered_color or self.color )
    GNLib.DrawTriangle( w - 15, h / 2, 8, self:IsHovered() and GNLib.Colors.MidnightBlue or GNLib.Colors.WetAsphalt, self:IsMenuOpen() and 2 or 0 )

    draw.SimpleText( self:GetSelected() and self:GetSelected().text or self:GetValue(), self.font, 10, h / 2, self.text_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

function PANEL:AddChoice( text, data, auto_select )
    self.choices[#self.choices + 1] = { text = text, data = data }
    if auto_select then self.selected = #self.choices end

    self:CalcTall()
end

function PANEL:CalcTall()
    self.menu_tall = math.min( self.self_h + self.menu_offset + ( #self.choices + ( self.reseter and 1 or 0 ) ) * self.self_h, self.max_menu_tall )
end

function PANEL:SetReseter( bool )
    if bool == self:GetReseter() then return end

    self.reseter = bool

    self:CalcTall()
end

function PANEL:IsHovered()
    local x, y = self:LocalCursorPos()
    return x <= self:GetWide() and y <= self.self_h and 0 <= x and 0 <= y
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

    local parent_x, parent_y = 0, 0
    do 
        local parent = self:GetParent()
        while parent do
            local x, y = parent:GetPos()
            parent_x, parent_y = parent_x + x, parent_y + y

            parent = parent:GetParent()
        end
    end

    local x, y = self:GetPos()
    self.Menu = vgui.Create( "DScrollPanel" )
        self.Menu:SetPos( x + parent_x, y + parent_y + self:GetTall() + self.menu_offset )
        self.Menu:SetSize( W, self.menu_tall - self:GetTall() )
        self.Menu.Paint = function() end
        self.Menu:MakePopup()

        local vbar = self.Menu:GetVBar()
        vbar:SetHideButtons( true )
        vbar:SetWide( 0 )

    local y = 0
    local button_space = 10
    local function add_choice( id, is_first, is_last, text, data, reseter )
        local hovered_color = reseter and GNLib.Colors.Pomegranate or self.hovered_color
        local default_color = reseter and GNLib.Colors.Alizarin or self.color

        local choice = self.Menu:Add( "DButton" )
            choice:SetPos( button_space, y * self.self_h )
            choice:SetWide( W - button_space * 2 ) 
            choice:SetTall( self.self_h )
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

function PANEL:OnRemove()
    self:CloseMenu()
end

vgui.Register( "GNComboBox", PANEL, "DButton" )