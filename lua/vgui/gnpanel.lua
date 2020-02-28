local PANEL = {}

AccessorFunc( PANEL, "color", "Color" )
AccessorFunc( PANEL, "default_cursor", "DefaultCursor" )

function PANEL:Init()
    self:SetSize( 500, 500 )
    self:Center()

    self:ShowCloseButton( false )
    self:SetDraggable( false )
    self:SetTitle( "" )

    self.color = GNLib.Colors.MidnightBlue
    
    self:SetDefaultCursor()

    self.enabled = true
    self.clicking = false
    self.hovered = false

    self.last_click_x = 0
    self.last_click_y = 0
end

function PANEL:SetDefaultCursor( cursor )
    self.default_cursor = cursor or "none"
    self:SetCursor( self.default_cursor )
end

function PANEL:IsClicking()
    return self.clicking
end

function PANEL:IsHovered()
    return self.hovered
end

function PANEL:GetLastClickPos()
    return self.last_click_x, self.last_click_y
end

--  > Enable
function PANEL:SetEnabled( bool )
    self.enabled = bool
    self:SetCursor( bool and self.default_cursor or "none" )
end

function PANEL:IsEnabled()
    return self.enabled
end

--  > Events
function PANEL:DoClick()
end

function PANEL:OnPressed()
end

function PANEL:OnReleased()
end

function PANEL:OnMousePressed( key_code )
    if not self.enabled then return end
    if MOUSE_LEFT == key_code then
        self.last_click_x, self.last_click_y = self:ScreenToLocal( gui.MousePos() )
        
        self.clicking = true
        self:OnPressed()
    end
end

function PANEL:OnMouseReleased( key_code )
    if self.clicking then
        self:DoClick()
        
        self.clicking = false
        self:OnReleased()
    end
end

function PANEL:OnMousePassed( hovered )
    self.hovered = hovered
end

function PANEL:OnCursorExited()
    self:OnMousePassed( false )
    self.clicking = false
end

function PANEL:OnCursorEntered()
    self:OnMousePassed( true )
end

vgui.Register( "GNPanel", PANEL, "DFrame" )
