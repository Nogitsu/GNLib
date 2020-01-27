PANEL = {}

AccessorFunc( PANEL, "char_tall", "CharTall", FORCE_FLOAT )
function PANEL:Init()
    self.inputs = {}

    self.scroll = self:Add( "DScrollPanel" )
    self.scroll:Dock( FILL )

    self.canvas = self:Add( "DPanel" )
    self.canvas:Dock( FILL )

    self.char_tall = 20

    self.canvas.Paint = function( _, w, h )
        self.last_x = 0
        self.last_y = 0

        surface.SetFont( "DermaDefault" )
        surface.SetDrawColor( color_white )

        for _, obj in ipairs( self.inputs ) do
            if obj.type == "text" then
                print( "Inserting text:" .. obj.value )
                if self.last_x > self:GetWide() - surface.GetTextSize( obj.value ) then
                    self.last_x = 0
                    self.last_y = self.last_y + self.char_tall
                end

                surface.SetTextPos( self.last_x, self.last_y )
                surface.DrawText( obj.value )

                self.last_x = self.last_x + surface.GetTextSize( obj.value )
            elseif obj.type == "color" then
                MsgC( color_white, "Inserting new ", obj.value, "color", color_white, "\n" )
                surface.SetTextColor( obj.value )
            elseif obj.type == "font" then
                print( "Inserting font:" .. obj.value )
                surface.SetFont( obj.value )
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

function PANEL:Paint( w, h ) end

vgui.Register( "GNRichText", PANEL )