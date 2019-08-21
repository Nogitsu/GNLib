--  > Main GNLib frame styled
local remove_icon = Material( "icon16/cross.png" )
function GNLib.CreateFrame( title )
    local W, H = math.max( ScrW() * .75, 1024 ), math.max( ScrH() * .75, 720 )

    local main = vgui.Create( "GNPanel" )
    main:SetSize( W, H )
    main:Center()
    main:MakePopup()
    function main:Paint( w, h )
        GNLib.DrawRectGradient( 0, 0, w, h, GNLib.Colors.MidnightBlue, GNLib.Colors.WetAsphalt, true )

        draw.SimpleText( title, "GNLFontB20", 15, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    local close = vgui.Create( "DButton", main )
    close:SetPos( W - 30, 5 )
    close:SetSize( 20, 20 )
    close:SetText( "" )
    close:SetTextColor( color_white )
    function close.DoClick()
        main:Remove()
    end
    function close:Paint( w, h )
        local c1 = GNLib.Colors.Concrete
        if self:IsHovered() then
            local t = math.abs( math.sin( CurTime() ) / w ) * 100 * 2
            c1 = GNLib.LerpColor( t, c1, GNLib.Colors.Pomegranate )
        end
        GNLib.DrawRectGradient( 0, 0, w, h, GNLib.Colors.Asbestos, c1, true )

        surface.SetMaterial( remove_icon )
        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect( 2, 2, 16, 16 )
    end

    return main
end