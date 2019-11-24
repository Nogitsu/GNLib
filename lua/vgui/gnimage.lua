local PANEL = {}
AccessorFunc( PANEL, "material", "Material" )
AccessorFunc( PANEL, "color", "Color" )

AccessorFunc( PANEL, "outline", "Outline", FORCE_BOOL )
AccessorFunc( PANEL, "outline_color", "OutlineColor" )
AccessorFunc( PANEL, "outline_thick", "OutlineThick" )

AccessorFunc( PANEL, "circle", "Circle", FORCE_BOOL )
AccessorFunc( PANEL, "rounded", "Rounded", FORCE_NUMBER )

function PANEL:Init()
    self:SetSize( 100, 100 )

    self:SetImage( "vgui/avatar_default.vmt" )

    self.circle = false
    self.rounded = nil

    self.outline_thick = 2
end

local function drawMat( self, w, h )
    GNLib.DrawMaterial( self.material, 0, 0, w, h, self.color )
end

function PANEL:Paint( w, h )
    if not self.material then
        return
    end

    if self.circle then
        GNLib.DrawStencil( function() 
            GNLib.DrawCircle( w / 2, h / 2, h / 2, 0, 360, color_white )            
        end, function() 
            drawMat( self, w, h )
            if self.outline then
                GNLib.DrawOutlinedCircle( w / 2, h / 2, h / 2 - self.outline_thick, self.outline_thick * 2, 0, 360, self.outline_color )
            end
        end )
        return
    elseif self.rounded then
        GNLib.DrawStencil( function()
            GNLib.DrawRoundedRect( self.rounded, 0, 0, w, h, color_white )
        end, function()
            drawMat( self, w, h )
            if self.outline then
                GNLib.DrawOutlinedRoundedRect( self.rounded, 0, 0, w, h, self.outline_thick, self.outline_color )
            end
        end )
        return
    end

    drawMat( self, w, h )           
    if self.outline then
        GNLib.DrawOutlinedBox( 0, 0, w, h, self.outline_thick, self.outline_color )
    end
end

function PANEL:SetImage( image, backup )
    image = image:find( "%.%./" ) and image:gsub( "%.%./", "" ) or "materials/" .. image
    if not file.Exists( image, "GAME" ) then
        if not backup then return end
        self:SetMaterial( Material( backup ) )
    else
        self:SetMaterial( Material( image ) )
    end
end

function PANEL:GetImage() 
    return self.image
end

vgui.Register( "GNImage", PANEL, "DPanel" )