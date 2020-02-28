local _origin, _ang, _scale
local _key, _dist = KEY_E, 2.9 ^ 10
local panel_list = {}

--  > Overwrite hovered function
local PANEL = FindMetaTable( "Panel" )

panel_is_hovered = panel_is_hovered or PANEL.IsHovered
--[[ function PANEL:IsHovered()
    --  > 3D2D support
    if panel_list[self] then 
        return self.Hovered 
    end
    --  > default hovered
    return panel_is_hovered()
end ]]
PANEL.IsHovered = panel_is_hovered

--  > locals functions
local function get_absolute_bounds( panel )
    --  > get absolute bounds (cause of Dock)
    --[[ local dock = panel:GetDock()
    if not ( dock == NODOCK ) then
        local parent = panel:GetParent()

        --  > calculate space with dock margin and padding
        local space_left, space_top, space_right, space_bottom
        do
            local margin_left, margin_top, margin_right, margin_bottom = panel:GetDockMargin()
            local padding_left, padding_top, padding_right, padding_bottom = parent:GetDockPadding() 
            space_left, space_top, space_right, space_bottom = margin_left + padding_left, margin_top + padding_top, margin_right + padding_right, margin_bottom + padding_bottom
        end

        --  > calculate position and size
        --  > TODO: fix x and width for LEFT and RIGHT docks
        local parent_x, parent_y, parent_w, parent_h = get_absolute_bounds( parent )
        local x, y, w, h

        w = parent:GetWide() - space_left - space_right
        h = ( dock == FILL and parent:GetTall() - space_top - space_bottom or panel:GetTall() )
        x = parent_x + space_left
        y = parent_y + ( dock == BOTTOM and parent_h - space_bottom - h or space_top )

        return x, y, w, h
    else
        return panel:GetBounds()
    end ]]
    --  > add bounds from parents
    local x, y, w, h = panel:GetBounds()

    local parent = panel:GetParent()
    while parent do
        parent_x, parent_y = parent:GetPos()
        x, y = x + parent_x, y + parent_y
        parent = parent:GetParent()
    end

    return x, y, w, h
end

local function get_children( panel, add_self )
    local children = {}
    
    --  > add himself if asked
    if add_self then
        children[#children + 1] = panel
    end
    
    --  > get every children
    for i, pnl in ipairs( panel:GetChildren() ) do
        children[#children + 1] = pnl
        for i, pnl_child in ipairs( get_children( pnl ) ) do
            children[#children + 1] = pnl_child
        end
    end

    return children
end

local function prepare_panel( panel )
    --  > Disallow MakePopup
    panel:SetMouseInputEnabled( false )
    panel:SetKeyboardInputEnabled( false )

    --  > Set pos (fix center)
    panel:SetPos( 0, 0 )

    --  > add its children and it to panel list
    for i, pnl in ipairs( get_children( panel, true ) ) do
        panel_list[pnl] = true
    end
end

local function check_hover( panel, cursor_x, cursor_y )
    --  > check about children
    local can_hover = true
    for i, v in ipairs( panel:GetChildren() ) do
        local hover = check_hover( v, cursor_x, cursor_y ) 
        if hover then can_hover = false end
    end

    --  > hover panel
    if can_hover then
        local is_hover = GNLib.Is3D2DCursorInPanel( panel, x, y )
        if is_hover then
            if not panel.Hovered and LocalPlayer():GetPos():DistToSqr( _origin ) <= _dist then
                panel.Hovered = true
                if panel.OnCursorEntered then panel:OnCursorEntered() end

                return true
            end
        else
            if panel.Hovered then
                panel.Hovered = false
                if panel.OnCursorExited then panel:OnCursorExited() end
            end
        end
    end

    return false
end

local function check_click( panel )
    for i, v in ipairs( get_children( panel ) ) do
        check_click( v )
    end

    if not panel.DoClick or not panel.Hovered then return end

    local is_click = input.IsKeyDown( _key )
    if is_click then
        if not panel.Clicked then
            panel.Clicked = true
            if panel.DoClick then panel:DoClick() end
        end
    else
        if panel.Clicked then
            panel.Clicked = false
        end
    end
end

function GNLib.Get3D2DCursorPos()
    local pos = util.IntersectRayWithPlane( LocalPlayer():EyePos(), LocalPlayer():GetAimVector(), _origin, _ang:Up() )
    if not pos then return end

    --  > get pos
    pos = WorldToLocal( pos, Angle(), _origin, _ang )
    --  > set the pos to the good scale and invert y 
    pos.x, pos.y = pos.x * 1 / _scale, -pos.y * 1 / _scale 

    return pos.x, pos.y
end

function GNLib.Is3D2DCursorInPanel( panel, cursor_x, cursor_y )
    --  > Make sure we get cursor position
    if not cursor_x or not cursor_y then 
        cursor_x, cursor_y = GNLib.Get3D2DCursorPos()
    end
    if not cursor_x or not cursor_y then return end
    
    --  > Collision check
    local x, y, w, h = get_absolute_bounds( panel )
    return x < cursor_x and y < cursor_y and cursor_x < x + w and cursor_y < y + h
end

function GNLib.Render3D2D( pos, ang, scale, func, key, dist )
    _origin = pos
    _ang = ang
    _scale = scale
    _key = key or _key
    _dist = dist or _dist

    cam.Start3D2D( pos, ang, scale )
        func()
    cam.End3D2D()
end

--[[ local show = true ]]
function GNLib.Draw3D2DPanel( panel )
    --  > make it some preparations
    if not panel_list[panel] then
        prepare_panel( panel )
    end

    --  > set hover
    check_hover( panel )

    --  > set clicked
    check_click( panel )

    --[[ if show then 
        show = false 
        print( "--")
        for i, v in ipairs( get_children( panel ) ) do
            print( v )
            print( "\tParent:", v:GetParent():GetName() )
            print( "\tAbs Bounds:", get_absolute_bounds( v ) )
            print( "\tBounds:", v:GetBounds() )
        end
    end ]]

    --  > paint it
    panel:SetPaintedManually( false )
        panel:PaintManual()
    panel:SetPaintedManually( true )
end

function GNLib.Draw3D2DCursor( panel, draw_func )
    if LocalPlayer():GetPos():DistToSqr( _origin ) > _dist then return end
    local cursor_x, cursor_y = GNLib.Get3D2DCursorPos()

    if GNLib.Is3D2DCursorInPanel( panel, cursor_x, cursor_y ) then
        if draw_func then
            draw_func( cursor_x, cursor_y )
        else
            GNLib.DrawCircle( cursor_x or 0, cursor_y or 0, 5 )
        end
    end
end