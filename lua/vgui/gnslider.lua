local PANEL = {}

AccessorFunc( PANEL, "hovered_color", "HoveredColor" )
AccessorFunc( PANEL, "clicked_color", "ClickedColor" )
AccessorFunc( PANEL, "circle_color", "CircleColor" )

function PANEL:Init()
    self:SetBarTall( 8 )
    self:SetCursor( "sizewe" )
    self:SetFillColor( GNLib.Colors.Silver )

    self.circle_color = GNLib.Colors.Silver
    self.hovered_color = GNLib.Colors.Concrete
    self.clicked_color = GNLib.Colors.Asbestos

    self.circle_hover = false
    
    self.max_value = 1
    
    self.value = 0

    self:SetPercentage( self.value / self.max_value )
end

--  > Value functions
function PANEL:SetValue( value )
    self:SetPercentage( math.Clamp( value, 0, self.max_value) / self.max_value )
end

function PANEL:SetMaxValue( max_value )
    self.max_value = max_value
end

function PANEL:GetValue()
    return self.max_value * self.percentage
end

--  > PANEL Base
function PANEL:Think()
    local x, y = self:GetParent():LocalToScreen( self:GetPos() )
    local last_hover = self.circle_hover
    self.circle_hover = GNLib.IsInCircle( gui.MouseX(), gui.MouseY(), x + self.shown_percentage * self:GetWide() - self.circle_radius, y + self:GetTall() / 2, self.circle_radius )

    if not ( self.circle_hover == last_hover ) then
        if last_hover == false then
            self:OnCircleEntered()
        elseif last_hover == true then
            self:OnCircleExited()
        end
    end
    self:SetCircleColor( (self.circle_hover and self.clicking) and self.clicked_color or self.circle_hover and self.hovered_color or self.circle_color )
end

function PANEL:OnValueChanged( value, percent )
end

function PANEL:OnCursorMoved( x )
    if self.clicking and self.circle_hover then
        self:SetPercentage( ( x + self:GetTall() / 2 ) / self:GetWide() )
        self.shown_percentage = self:GetPercentage()

        self:OnValueChanged( self.shown_percentage * self.max_value, self.shown_percentage )
    end
end

function PANEL:OnMousePressed( key_code )
    local x, y = self:GetParent():LocalToScreen( self:GetPos() )
    if key_code == MOUSE_LEFT then
        if self.circle_hover then
            self.clicking = true
        else
            self:SetPercentage( self.shown_percentage + (gui.MouseX() - x - self:GetWide() * self.shown_percentage + self.circle_radius) / self:GetWide() )
            self:OnValueChanged( self.percentage * self.max_value, self.percentage )
        end
    end
end

--  > Use that
function PANEL:OnCircleEntered()
end

function PANEL:OnCircleExited()
end

vgui.Register( "GNSlider", PANEL, "GNProgress" )