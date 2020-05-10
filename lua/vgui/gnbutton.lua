--- @title:
--- 	GNButton: <VGUI> Create a button
--- @note:
--- 	Parent: GNPanel
--- @params:
--- 	GNButton/SetPos( Position ): <function> Set the position of the button
--- 	GNButton/SetSize( Size ): <function> Set the size of the button
--- 	GNButton/SetText( Text ): <function> Set the text of the button
--- 	GNButton/SetFont( Font name ): <function> Add the font name of the button
--- 	GNButton/SetTextColor( Color ): <function> Add the text color of the button
--- 	GNButton/SetColor( Color ): <function> Set the color of the button
--- 	GNButton/SetHoveredColor( Color ): <function> Set the color of the button hovered
--- 	GNButton/SetClickedColor( Color ): <function> Set the color of the button clicked
--- 	GNButton/SetHoveredTextColor( Color ): <function> Set the color of the button text hovered
--- 	GNButton/SetClickedTextColor( Color ): <function> Set the color of the button text clicked
--- 	GNButton/SetHideLeft( Bool ): <function> Add the hide left of the button
--- 	GNButton/SetHideRight( Bool ): <function> Add the hide right of the button
--- @example:
--- 	#prompt: Code from ...
--- 	#code:  local join = vgui.Create("GNButton", main)\n	join:SetSize(ScrW()*0.1, ScrH()*0.05)\n	join:SetPos(ScrW()*0.04,ScrH()*0.07)\n	join:SetText("Yes")\n	join:SetFont("GNLFontB17")\n	join:SetTextColor(Color(255, 255, 255))\n	join:SetColor(GNLib.Colors.GreenSea)\n	join:SetHoveredColor(GNLib.Colors.GreenSea)\n	join:SetClickedColor(GNLib.Colors.GreenSea)\n	join:SetHoveredTextColor(GNLib.Colors.Clouds)\n	join:SetClickedTextColor(GNLib.Colors.Clouds)\n	join:SetHideLeft(true)\n	join:SetHideRight(false)
--- 	#output: https://cdn.discordapp.com/attachments/644279406176501770/709065392152379462/unknown.png
local PANEL = {}

AccessorFunc( PANEL, "hovered_color", "HoveredColor" )
AccessorFunc( PANEL, "clicked_color", "ClickedColor" )

AccessorFunc( PANEL, "default_textcolor", "TextColor" )
AccessorFunc( PANEL, "hovered_textcolor", "HoveredTextColor" )
AccessorFunc( PANEL, "clicked_textcolor", "ClickedTextColor" )

AccessorFunc( PANEL, "hide_left", "HideLeft" )
AccessorFunc( PANEL, "hide_right", "HideRight" )

function PANEL:Init()
    self:SetSize( 100, 25 )
    self:SetCursor( "hand" )
    self:SetColor( GNLib.Colors.Wisteria )

    self.text = "Label"
    self.font = "GNLFontB15"

    self.clicktime = 0

    self.hovered_color = GNLib.Colors.Amethyst
    --self.clicked_color = GNLib.Colors.Wisteria

    self.hide_left = false
    self.hide_right = false

    self.default_textcolor = GNLib.Colors.WetAsphalt
    self.hovered_textcolor = GNLib.Colors.MidnightBlue
    --self.clicked_textcolor = GNLib.Colors.WetAsphalt
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
        GNLib.DrawElipse( 0, 0, w, h, self:IsHovered() and self.hovered_color or self.color, self.hide_left, self.hide_right )
        if self.hide_left then
            draw.RoundedBoxEx( 0, 0, 0, h, h, self:IsHovered() and self.hovered_color or self.color )
        end
        if self.hide_right then
            draw.RoundedBoxEx( 0, w - h, 0, h, h, self:IsHovered() and self.hovered_color or self.color )
        end
    end, function()
        draw.RoundedBoxEx( 0, 0, 0, w, h, self:IsHovered() and self.hovered_color or self.color )
        if self:IsClicking() then
            local x, y = self:GetLastClickPos()
            GNLib.DrawCircle( x, y, self.clicktime, 0, 360, self.clicked_color or self.color )
            self.clicktime = math.min( self.clicktime + FrameTime() * 1000, w )
        else
            self.clicktime = 0
        end
    end )
    
    draw.SimpleText( self.text, self.font, w / 2, h / 2, self:IsClicking() and ( self.clicked_textcolor or self.default_textcolor ) or self:IsHovered() and self.hovered_textcolor or self.default_textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

vgui.Register( "GNButton", PANEL, "GNPanel" )
