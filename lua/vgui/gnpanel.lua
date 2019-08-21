local PANEL = {}

AccessorFunc( PANEL, "color", "Color" )
AccessorFunc( PANEL, "default_cursor", "DefaultCursor", FORCE_STRING )

function PANEL:Init()
    self:SetSize( 50, 25 )
    self:SetPos( 0, 0 )

    self:ShowCloseButton( false )
    self:SetDraggable( false )
    self:SetTitle( "" )

    self.color = GNLib.Colors.MidnightBlue
    self.default_cursor = "none"

    self:SetCursor( self.default_cursor )

    self.enabled = true
    self.clicking = false
end

--  > Enable
function PANEL:SetEnabled( bool )
    self.enabled = bool
    self:SetCursor( bool and self.default_cursor or "no" )
end

function PANEL:IsEnabled()
    return self.enabled
end

--  > Events
function PANEL:DoClick()
end

function PANEL:OnMousePressed( key_code )
    if not self.enabled then return end
    if MOUSE_LEFT == key_code then
        self.clicking = true
    end
end

function PANEL:OnMouseReleased( key_code )
    if self.clicking then
        self:DoClick()

        self.clicking = false
    end
end

function PANEL:OnCursorExited()
    self.clicking = false
end

vgui.Register( "GNPanel", PANEL, "DFrame" )
