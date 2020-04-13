--- @title:
--- 	GNGrid: <Panel> Similary to Grids in CSS, allow you to add rows and lines proportionnaly sized.
--- @note:
--- 	Parent: DPanel
--- @params:
--- 	GNGrid/AddRow( Panel parent=self ): <function> Add a row on the grid
--- 	GNGrid/AddColumn( Panel parent=self ): <function> Add a column on the grid
--- 	GNGrid/SetGridSizes( varags fractional_units ): <function> Set respectively and proportionnaly the size of elements
--- @example:
--- 	#prompt: Code from gnlib/client/cl_vgui_show.lua
--- 	#code: local grid = main:Add( "GNGrid" )\n\tgrid:SetPos( 100, 500 )\n\tgrid:SetSize( 300, 200 )\n\tgrid:SetGridSizes( 2, 6, 2 )\n\nlocal function panel_paint_color( color )\n\treturn function( self, w, h )\n\t\tdraw.RoundedBox( 0, 0, 0, w, h, color )\n\tend\nend\n\nlocal first_column = grid:AddColumn()\n\tfirst_column:SetPadding( 5 )\n\tfirst_column:SetGridSizes( .5, 3, 1, 2 )\n\tfirst_column.Paint = panel_paint_color( GNLib.Colors.Carrot )\n\tfirst_column:Add( "DPanel" ).Paint = panel_paint_color( GNLib.Colors.Alizarin )\n\tfirst_column:Add( "DPanel" ).Paint = panel_paint_color( GNLib.Colors.Amethyst )\n\tfirst_column:Add( "DPanel" ).Paint = panel_paint_color( GNLib.Colors.Emerald )\n\tfirst_column:Add( "DPanel" ).Paint = panel_paint_color( GNLib.Colors.BelizeHole )\n\nlocal second_column = grid:AddColumn()\n\tsecond_column:SetGridSizes( 2, 8 )\n\tsecond_column.Paint = panel_paint_color( GNLib.Colors.Concrete )\n\tlocal first_row = second_column:AddRow()\n\t\tfirst_row:SetGridSizes( 1, 5, 1 )\n\t\tfirst_row.Paint = panel_paint_color( GNLib.Colors.Carrot )\n\t\tfirst_row:Add( "DPanel" ).Paint = panel_paint_color( GNLib.Colors.Alizarin )\n\t\tfirst_row:Add( "DPanel" ).Paint = panel_paint_color( GNLib.Colors.Amethyst )\n\t\tfirst_row:Add( "DPanel" ).Paint = panel_paint_color( GNLib.Colors.BelizeHole )\n\n\tlocal second_row = second_column:AddRow()\n\t\tsecond_row.Paint = panel_paint_color( GNLib.Colors.BelizeHole )\n\t\tsecond_row:Add( "DPanel" ).Paint = panel_paint_color( GNLib.Colors.Amethyst )\n\n\t\tlocal second_row_column = second_row:AddColumn()\n\t\t\tsecond_row_column:SetGridSizes( 8, 2 )\n\t\t\tsecond_row_column.Paint = panel_paint_color( GNLib.Colors.Emerald )\n\t\t\tsecond_row_column:Add( "DPanel" ).Paint = panel_paint_color( GNLib.Colors.MidnightBlue )\n\t\t\tsecond_row_column:Add( "DPanel" ).Paint = panel_paint_color( GNLib.Colors.Alizarin )\n\nlocal third_column = grid:AddColumn()\n\tthird_column:SetGridSizes( 3, 1 )\n\tthird_column.Paint = panel_paint_color( GNLib.Colors.Carrot )\n\tthird_column:Add( "DPanel" ).Paint = panel_paint_color( GNLib.Colors.Alizarin )\n\tthird_column:Add( "DPanel" ).Paint = panel_paint_color( GNLib.Colors.Amethyst )
--- 	#output: https://cdn.discordapp.com/attachments/638822462431166495/699240888332714075/unknown.png
local PANEL = {}

function PANEL:Init()
    self.rows = {}
    self.columns = {}

    self.grid_sizes = {}
end

function PANEL:Paint()
end

function PANEL:PerformLayout( w, h )
    local max = GNLib.ArrayReduce( self.grid_sizes, function( acc, v ) return acc + v end )

    --  > rows
    for i, v in ipairs( self.rows ) do
        v:SetTall( v:GetGridSize() / max * h )
    end

    --  > columns
    for i, v in ipairs( self.columns ) do
        v:SetWide( v:GetGridSize() / max * w )
    end
end

function PANEL:AddRow( parent )
    local row = ( parent or self ):Add( "GNGridRow" )
        row:Dock( TOP )

    local size = self.grid_sizes[#self:GetChildren()]
    if size then row:SetGridSize( size ) end

    if not parent then self.rows[#self.rows + 1] = row end
    return row
end

function PANEL:AddColumn( parent )
    local column = ( parent or self ):Add( "GNGridColumn" )
        column:Dock( LEFT )

    local size = self.grid_sizes[#self:GetChildren()]
    if size then column:SetGridSize( size ) end

    if not parent then self.columns[#self.columns + 1] = column end
    return column
end

function PANEL:SetGridSizes( ... )
    self.grid_sizes = {}
    for i, v in ipairs( { ... } ) do
        self.grid_sizes[i] = v
    end
end

vgui.Register( "GNGrid", PANEL, "DPanel" )