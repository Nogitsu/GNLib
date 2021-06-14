local PANEL = {}

AccessorFunc( PANEL, "hovered_color", "HoveredColor" )
AccessorFunc( PANEL, "clicked_color", "ClickedColor" )
AccessorFunc( PANEL, "default_circle_color", "DefaultCircleColor" )
AccessorFunc( PANEL, "circle_color", "CircleColor" )

function PANEL:Init()
    self:SetBarTall( 7 )
    self:SetCursor( "sizewe" )
    self:SetFillColor( GNLib.Colors.Asbestos )

    self:SetDefaultCircleColor( GNLib.Colors.Silver )
    self:SetHoveredColor( GNLib.Colors.Concrete )
    self:SetClickedColor( GNLib.Colors.Concrete )

    self.circle_hover = false
    self.clicking = false
    
    self.value = 0
    self.max_value = 1

    self:SetPercentage( self.value / self.max_value )
end

--  > Value functions
function PANEL:SetDefaultCircleColor( color )
    self.default_circle_color = color
    if not self.circle_hover and not self.clicking then
        self:SetCircleColor( self.default_circle_color )
    end
end

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
    local x, y = self:LocalCursorPos()

    --  > Hover
    local circle_x, circle_y = self:GetCirclePos()
    local last_hover = self.circle_hover
    self.circle_hover = GNLib.IsInCircle( x, y, circle_x, circle_y, self.circle_radius )

    --  > Color
    self:SetCircleColor( self.clicking and self.clicked_color or self.circle_hover and self.hovered_color or self.default_circle_color )

    --  > Events
    if not ( self.circle_hover == last_hover ) then
        if last_hover == false then
            self:OnCircleEntered()
        elseif last_hover == true then
            self:OnCircleExited()
        end
    end

    if self.clicking then
        --  > Release
        if not input.IsMouseDown( MOUSE_LEFT ) then
            self.clicking = false
            self.circle_hover = false
            return
        end

        --  > Slider Move
        self:SetPercentage( math.Clamp( x + self.circle_radius, 0, self:GetWide() ) / self:GetWide() )
        self.shown_percentage = self:GetPercentage()

        self:OnValueChanged( self.shown_percentage * self.max_value, self.shown_percentage )
    end
end

function PANEL:OnValueChanged( value, percent )
end

function PANEL:OnMousePressed( key_code )
    local x, y = self:LocalCursorPos()
    if key_code == MOUSE_LEFT then
        if self.circle_hover then
            self.clicking = true
        else
            self:SetPercentage( math.Clamp( x, 0, self:GetWide() ) / self:GetWide() )
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