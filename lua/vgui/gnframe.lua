local PANEL = {}

AccessorFunc( PANEL, "color", "Color" )
AccessorFunc( PANEL, "title", "Title" )
AccessorFunc( PANEL, "rounded_radius", "RoundedRadius" )
AccessorFunc( PANEL, "show_top_bar", "ShowTopBar" )

function PANEL:Init()
    self:ShowCloseButton( false )
    self:MakePopup()

    self:SetColor( GNLib.Colors.MidnightBlue )
    self:SetTitle( "GNLib - Your title here" )

    self:SetShowTopBar( true )
    self:SetRoundedRadius( 6 )

    self.lblTitle:Remove()

    local header = self:Add( "DPanel" )
        --header:DockPadding( 0, 0, 0, H * .02 )
        header:Dock( TOP )
        header.color = GNLib.Colors.WetAsphalt
        header.Paint = function( _self, w, h )
            if self:GetShowTopBar() then 
                draw.RoundedBoxEx( self.rounded_radius, 0, 0, w, h, _self.color, true, true ) 
            else 
                surface.SetDrawColor( _self.color )
                surface.DrawLine( 0, h - 1, w, h - 1 )
            end

            draw.SimpleText( self.title, "GNLFontB17", 10, 3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
        end

    local close = header:Add( "DButton" )
        close:SetSize( header:GetTall(), header:GetTall() )
        close:SetText( "" )
        close.DoClick = function()
            self:Remove()
        end 
        close.Paint = function( _self, w, h )
            draw.RoundedBoxEx( self.rounded_radius, 0, 0, w, h, _self:IsHovered() and GNLib.Colors.Alizarin or GNLib.Colors.Pomegranate, false, true )
        
            draw.SimpleText( "x", "GNLFontB15", w / 2 - 1, h / 2 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

    self.header = header
    self.close = close
end

function PANEL:PerformLayout( w, h )
    self.close:SetPos( w - self.close:GetWide(), self.header:GetTall() / 2 - self.close:GetTall() / 2 )
end

function PANEL:Paint( w, h )
    draw.RoundedBox( self.rounded_radius + 2, 0, 0, w, h, self.color )
end

vgui.Register( "GNFrame", PANEL, "DFrame" )