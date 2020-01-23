local PANEL = {}

AccessorFunc( PANEL, "color", "Color" )
AccessorFunc( PANEL, "cur_color", "CurColor" )
AccessorFunc( PANEL, "cur_hovered_color", "CurHoveredColor" )
AccessorFunc( PANEL, "hovered_color", "HoveredColor" )
AccessorFunc( PANEL, "clicked_color", "ClickedColor" )

AccessorFunc( PANEL, "pages", "Pages" )
AccessorFunc( PANEL, "max_pages", "MaxPages" )
AccessorFunc( PANEL, "cur_page", "CurPage" )

function PANEL:Init()
    self:SetSize( 150, 20 )

    self:SetColor( GNLib.Colors.PeterRiver )
    self:SetCurColor( GNLib.Colors.Turquoise )
    self:SetHoveredColor( GNLib.Colors.BelizeHole )
    self:SetCurHoveredColor( GNLib.Colors.GreenSea )
    self:SetClickedColor( GNLib.Colors.Concrete )

    self.cur_page = 1
    self.max_pages = 5
    self:SetPages( 5 )
end

function PANEL:Paint()
end

function PANEL:CreateButtons()
    self:Clear()

    local but_wide = 0
    local max_range = math.min( self:GetPages(), self:GetMaxPages() )

    self.buts = {}
    for i = 0, max_range + 1 do
        local is_left, is_right = i == 0, i == max_range + 1
        local is_page = not ( is_left or is_right )

        local but = self:Add( "GNCharButton" )
            but:SetActiveChar( false )
            but:SetText( is_left and "<" or is_right and ">" or i )
            but:SetPos( ( but:GetWide() + 5 ) * i, 0 )
            but.DoClick = function()
                if is_page then
                    self:SetCurPage( i )
                else
                    if is_left then
                        self:SetCurPage( self:GetCurPage() - 1 )
                    else
                        self:SetCurPage( self:GetCurPage() + 1 )
                    end
                end
            end
            but.RefreshColors = function()
                but:SetHoveredColor( self:GetCurPage() == i and self:GetCurHoveredColor() or self:GetHoveredColor() )
                but:SetColor( self:GetCurPage() == i and self:GetCurColor() or self:GetColor() )
                but:SetClickedColor( self:GetClickedColor() )
            end
            but:RefreshColors()

        but_wide = but:GetWide()

        self.buts[i] = but
    end

    self:SetWide( ( max_range + 2 ) * ( but_wide + 5 ) )
end

function PANEL:SetPages( pages )
    self.pages = pages

    self:CreateButtons()
end

function PANEL:SetMaxPages( pages )
    self.max_pages = max_pages

    self:CreateButtons()
end

function PANEL:SetCurPage( page )
    local old_page = self:GetCurPage()

    self.cur_page = math.Clamp( page % ( self:GetMaxPages() + 1 ), 0, self:GetMaxPages() + 1 )

    self.buts[old_page]:RefreshColors()
    self.buts[self.cur_page]:RefreshColors()
end

vgui.Register( "GNPagination", PANEL, "DPanel" )