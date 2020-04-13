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
        v:SetWide( ( self.grid_sizes[i] or 1 ) / max * ( w - self.padding * #children ) - self.padding / #children )
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

    panel:Dock( LEFT )
    panel:DockMargin( self.padding, self.padding, 0, self.padding )

    return panel
end

local GNGrid = vgui.GetControlTable( "GNGrid" )
PANEL.SetGridSizes = GNGrid.SetGridSizes
function PANEL:AddColumn()
    return GNGrid.AddColumn( self, self )
end

vgui.Register( "GNGridRow", PANEL, "DPanel" )