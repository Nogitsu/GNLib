local PANEL = {}

AccessorFunc( PANEL, "padding", "Padding", FORCE_NUMBER )
AccessorFunc( PANEL, "grid_size", "GridSize", FORCE_NUMBER )

function PANEL:Init()
    self.padding = 5

    self.grid_size = 1
    self.grid_sizes = {}
end

function PANEL:PerformLayout( w, h )
    local children = self:GetChildren()

    local max = math.max( #children, GNLib.ArrayReduce( self.grid_sizes, function( acc, v ) return acc + v end ) )

    for i, v in ipairs( children ) do
        v:SetTall( ( self.grid_sizes[i] or 1 ) / max * ( h - self.padding * #children ) - self.padding / #children )
    end
end

function PANEL:Add( class )
    local panel

    if isstring( class ) then
        panel = vgui.Create( class, self )
    else
        panel = class
        panel:SetParent( self )
    end

    panel:Dock( TOP )
    panel:DockMargin( self.padding, self.padding, self.padding, 0 )

    return panel
end

local GNGrid = vgui.GetControlTable( "GNGrid" )
PANEL.SetGridSizes = GNGrid.SetGridSizes
function PANEL:AddRow()
    return GNGrid.AddRow( self, self )
end

vgui.Register( "GNGridColumn", PANEL, "DPanel" )