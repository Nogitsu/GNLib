PANEL = {}

AccessorFunc( PANEL, "char_tall", "CharTall", FORCE_FLOAT )
function PANEL:Init()
    self.inputs = {}

    self.scroll = self:Add( "DScrollPanel" )
    self.scroll:Dock( FILL )

    self.canvas = self:Add( "DPanel" )
    self.canvas:Dock( TOP )

    self.char_tall = 20

    self.canvas.Paint = function( _, w, h )
        self.last_x = 0
        self.last_y = 0

        surface.SetFont( "GNLFont20" )
        surface.SetDrawColor( color_white )
        surface.SetTextColor( color_white )

        for _, obj in ipairs( self.inputs ) do
            if obj.type == "text" then
                local text_w = surface.GetTextSize( obj.value )

                if self.last_x > self:GetWide() - text_w then
                    self.last_x = 0
                    self.last_y = self.last_y + self.char_tall

                    if self.last_y > self.canvas:GetTall() - self.char_tall then
                        self.canvas:SetTall( self.last_y + self.char_tall )
                    end
                end

                surface.SetTextPos( self.last_x, self.last_y )
                surface.DrawText( obj.value )

                self.last_x = self.last_x + text_w
            elseif obj.type == "color" then
                surface.SetTextColor( obj.value )
                surface.SetDrawColor( obj.value )
            elseif obj.type == "font" then
                surface.SetFont( obj.value )
            elseif obj.type == "image" then
                surface.SetMaterial( obj.value )
                surface.DrawTexturedRect( self.last_x, self.last_y, obj.w, obj.h )

                if self.last_x > self:GetWide() then
                    self.last_x = 0
                    self.last_y = self.last_y + obj.h
                end

                self.last_x = self.last_x + obj.w
            end
        end
    end
end

function PANEL:AppendText( txt )
    self.inputs[ #self.inputs + 1 ] = { type = "text", value = txt }
end
PANEL.InsertText = PANEL.AppendText

function PANEL:InsertColorChange( r, g, b, a )
    self.inputs[ #self.inputs + 1 ] = { type = "color", value = type( r ) == "table" and r or Color( r, g, b, a ) }
end

function PANEL:InsertFontChange( font )
    self.inputs[ #self.inputs + 1 ] = { type = "font", value = font }
end

function PANEL:InsertImage( mat, w, h )
    self.inputs[ #self.inputs + 1 ] = { type = "image", value = mat, w = w or 16, h = h or 16 }
end

function PANEL:Clear()
    self.inputs = {}
end

function PANEL:Paint( w, h ) end

vgui.Register( "GNRichText", PANEL )