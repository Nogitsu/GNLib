--- @title:
--- 	GNButton: <Panel> Standard GNLib button in a rounded rectangle shape and animated on click. It also has an auto-size update on text and font change. 
--- @note:
--- 	Parent: GNPanel
--- @params:
--- 	GNButton/SetText( string text ): <function> Set button's text
--- 	GNButton/GetText(): <function> Get button's text
--- 	GNButton/SetFont( string font ): <function> Set button's font
--- 	GNButton/GetFont(): <function> Get button's font
--- 	GNButton/SetHoveredColor( Color color ): <function> Set color when hovered
--- 	GNButton/GetHoveredColor(): <function> Get color when hovered 
--- 	GNButton/SetClickedColor( Color color ): <function> Set color when clicked
--- 	GNButton/GetClickedColor(): <function> Get color when clicked
--- 	GNButton/SetTextColor( Color color ): <function> Set text color
--- 	GNButton/GetTextColor(): <function> Get text color
--- 	GNButton/SetHoveredTextColor( Color color ): <function> Set text color when hovered
--- 	GNButton/GetHoveredTextColor(): <function> Get text color when hovered
--- 	GNButton/SetClickedTextColor( Color color ): <function> Set text color when clicked
--- 	GNButton/GetClickedTextColor( Color color ): <function> Get text color when clicked
--- 	GNButton/SetHideLeft( boolean hide ): <function> Set if the left rounded part is to be shown.
--- 	GNButton/GetHideLeft(): <function> Get if the left rounded part is to be shown.
--- 	GNButton/SetHideRight( boolean hide ): <function> Set if the right rounded part is to be shown.
--- 	GNButton/GetHideRight(): <function> Get if the right rounded part is to be shown.
--- @example:
--- 	#prompt: Code from gngames/matchmaking/cl_matchmaking.lua
--- 	#code: local open = panel:Add( "GNButton" )\nopen:SetText( "Friends" )\nopen:SetTextColor( color_white )\nopen:SetHoveredTextColor( color_white )\nopen:SetColor( GNLib.Colors.Turquoise )\nopen:SetHoveredColor( GNLib.Colors.GreenSea )\nopen:SetHideLeft( true )\nfunction open:DoClick()\n\t-- some code here\nend
--- 	#output: https://media.discordapp.net/attachments/638822462431166495/815226165555101756/unknown.png
local PANEL = {}

AccessorFunc( PANEL, "hovered_color", "HoveredColor" )
AccessorFunc( PANEL, "clicked_color", "ClickedColor" )

AccessorFunc( PANEL, "default_textcolor", "TextColor" )
AccessorFunc( PANEL, "hovered_textcolor", "HoveredTextColor" )
AccessorFunc( PANEL, "clicked_textcolor", "ClickedTextColor" )

AccessorFunc( PANEL, "hide_left", "HideLeft", FORCE_BOOL )
AccessorFunc( PANEL, "hide_right", "HideRight", FORCE_BOOL )

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
