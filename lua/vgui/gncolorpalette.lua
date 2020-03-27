local PANEL = {}

AccessorFunc( PANEL, "selected", "Selected" )
AccessorFunc( PANEL, "color_size", "ColorSize" )
AccessorFunc( PANEL, "palette_type", "PaletteType" )

function PANEL:Init()
    self:SetSpaceX( 5 )
    self:SetSpaceY( 5 )

    self.selected = nil
    self.color_size = 30
    self.palette_type = "Circle"
    
    self:ResetColors()
    self:AddColors( GNLib.Colors )
end

local palette_types = {
    ["Circle"] = function( button, w, h )
        GNLib.DrawCircle( w / 2, w / 2, w / 2, 0, 360, button.color )
    end,
    ["Square"] = function( button, w, h )
        draw.RoundedBox( 4, 0, 0, w, h, button.color )
    end,
}

function PANEL:SetColorSize( size )
    self.color_size = size

    for i, v in ipairs( self.colors ) do
        v:SetSize( self.color_size, self.color_size )
    end

    if #self.colors > 0 then self:InvalidateLayout() end
end

function PANEL:GetSelectedColor()
    return self.selected and self.selected.color
end

function PANEL:ResetColors()
    self:Clear()
    self.colors = {}
end

function PANEL:AddColors( colors )
    for k, v in pairs( colors ) do
        local button = self:Add( "DButton" )
            button:SetSize( self.color_size, self.color_size )
            button.color = v
            function button.Paint( button, w, h )
                palette_types[self.palette_type]( button, w, h )
                return true
            end
            function button.DoClick()
                self.selected = button
                self:OnColorSelected( button.color )
            end

        self.colors[#self.colors + 1] = button 
    end
end

--[[ function PANEL:PerformLayout( w, h )
    for i, v in ipairs( self.colors ) do
        v:SetSize( w * self.color_size_factor, w * self.color_size_factor )
    end
end ]]

function PANEL:OnColorSelected( color )
    --  > overwrite purpose
end

vgui.Register( "GNColorPalette", PANEL, "DIconLayout" )