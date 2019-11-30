local PANEL = {}

AccessorFunc( PANEL, "hovered_color", "HoveredColor" )
AccessorFunc( PANEL, "clicked_color", "ClickedColor" )

AccessorFunc( PANEL, "default_textcolor", "TextColor" )
AccessorFunc( PANEL, "hovered_textcolor", "HoveredTextColor" )
AccessorFunc( PANEL, "clicked_textcolor", "ClickedTextColor" )

function PANEL:Init()
    self:SetSize( 100, 25 )
    self:SetCursor( "hand" )
    self:SetColor( GNLib.Colors.Wisteria )

    self.text = "Label"
    self.font = "GNLFontB15"

    self.clicktime = 0

    self.hovered_color = GNLib.Colors.Wisteria
    self.clicked_color = GNLib.Colors.Amethyst

    self.default_textcolor = GNLib.Colors.MidnightBlue
    self.hovered_textcolor = GNLib.Colors.WetAsphalt
    self.clicked_textcolor = GNLib.Colors.WetAsphalt
end

function PANEL:UpdateSize()
    surface.SetFont( self.font or "GNLFontB15" )
    local tw, th = surface.GetTextSize( self.text or "" )
    self:SetSize( math.max( self:GetWide(), tw + 25 ), math.max( self:GetTall(), th + 4 ) )
end    
--  > Change size on font and text update

function PANEL:SetText( text )
    self.text = text

    self:UpdateSize()
end

function PANEL:GetText()
    return self.text
end

function PANEL:SetFont( font )
    self.font = font

    self:UpdateSize()
end

function PANEL:GetFont()
    return self.font
end

--  > Override existing
function PANEL:Paint( w, h )
    GNLib.DrawStencil( function()
        GNLib.DrawElipse( 0, 0, w, h, self:IsHovered() and self.hovered_color or self.color )
    end, function()
        draw.RoundedBoxEx( 0, 0, 0, w, h, self:IsHovered() and self.hovered_color or self.color )
        if self:IsClicking() then
            local x, y = self:GetLastClickPos()
            GNLib.DrawCircle( x, y, self.clicktime, 0, 360, self.clicked_color )
            self.clicktime = math.min( self.clicktime + FrameTime() * 1000, w )
        else
            self.clicktime = 0
        end
    end )
    
    draw.SimpleText( self.text, self.font, w / 2, h / 2, self:IsClicking() and self.clicked_textcolor or self:IsHovered() and self.hovered_textcolor or self.default_textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

vgui.Register( "GNButton", PANEL, "GNPanel" )
