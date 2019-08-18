local mats = {
    Accept = Material( "icon16/accept.png" ),
    NotAccept = Material( "icon16/cancel.png" ),
    Update = Material( "icon16/wrench_orange.png" ),
    Certified = Material( "icon16/rosette.png", "smooth" ),
    DefaultPic = Material( "vgui/avatar_default", "smooth" ),
    Bug = Material( "icon16/bug.png" ),
    BugWarning = Material( "icon16/bug_error.png" )
}

GNLib.CreateFonts( "GNLFont", "Caviar Dreams", { 10, 15, 20 } )
GNLib.CreateFonts( "GNLFontB", "Caviar Dreams Bold", { 15, 20, 40 } )

function GNLib.OpenAddonsList()
    local W, H = ScrW() * .75, ScrH() * .75

    local main = vgui.Create( "DPanel" )
    main:SetSize( W, H )
    main:Center()
    main:MakePopup()
    function main:Paint( w, h )
        GNLib.DrawRectGradient( 0, 0, w, h, GNLib.Colors.MidnightBlue, GNLib.Colors.WetAsphalt, true )

        draw.SimpleText( "GNLib Addons List - " .. GNLib.Version, "GNLFontB20", 15, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    local close = vgui.Create( "DButton", main )
    close:SetPos( W - 30, 5 )
    close:SetSize( 20, 20 )
    close:SetText( "x" )
    close:SetTextColor( color_white )
    function close.DoClick()
        main:Remove()
    end
    function close:Paint( w, h )
        local c1 = GNLib.Colors.Alizarin
        if self:IsHovered() then
            local t = math.abs( math.sin( CurTime() ) / w ) * 100 * 2
            c1 = GNLib.LerpColor( t, c1, GNLib.Colors.Pomegranate )
        end
        GNLib.DrawRectGradient( 0, 0, w, h, c1, GNLib.Colors.Pomegranate, true )
    end

    local refresh = vgui.Create( "DButton", main )
    refresh:SetPos( W - 55, 5 )
    refresh:SetSize( 20, 20 )
    refresh:SetText( "­­r" )
    function refresh.DoClick()
        main:Remove()
        GNLib.OpenAddonsList()
    end
    function refresh:Paint( w, h )
        local c1 = GNLib.Colors.Emerald
        if self:IsHovered() then
            local t = math.abs( math.sin( CurTime() ) / w ) * 100 * 2
            c1 = GNLib.LerpColor( t, c1, GNLib.Colors.Nephritis )
        end
        GNLib.DrawRectGradient( 0, 0, w, h, c1, GNLib.Colors.Nephritis, true )
    end

    local addons_list = vgui.Create( "DScrollPanel", main )
    addons_list:SetSize( W * 0.25, H - 40 )
    addons_list:SetPos( 10, 30 )
    addons_list:DockPadding( 0, 15, 0, 15 )

    local selected_addon
    local selected_addon_id
    local selected_addon_mat

    local addon_infos = vgui.Create( "DPanel", main )
    addon_infos:SetSize( W * 0.75 - 30, H - 40 )
    addon_infos:SetPos( W * 0.25 + 20, 30 )

    local bug_alpha = 0
    local bug_target = 255
    function addon_infos:Paint( w, h )
        
        GNLib.DrawRectGradient( 0, 0, w, h, GNLib.Colors.Concrete, GNLib.Colors.Silver, true )

        if selected_addon then
            --  > Draw icon
            local iconSize = h / 2
            surface.SetDrawColor( color_white )
            if selected_addon.logoURL then
                surface.SetMaterial( selected_addon_mat )
            else
                surface.SetMaterial( mats.DefaultPic )
            end
            surface.DrawTexturedRect( 25, 25, iconSize, iconSize )

            --  > Draw name
            draw.SimpleText( selected_addon.name ..  " - " .. ( selected_addon.version or "N/A" ), "GNLFontB40", 25 * 1.5 + iconSize, 25, color_white )

            --  > Draw certification
            surface.SetFont( "GNLFontB40" )
            local name_w, name_h = surface.GetTextSize( selected_addon.name .. " - " .. ( selected_addon.version or "N/A" ) )
            surface.SetDrawColor( color_white )
            if selected_addon.certified then
                surface.SetMaterial( mats.Certified )
                surface.DrawTexturedRect( 25 * 1.5 + iconSize + name_w + 8, 25 + name_h/2 - 10, 20, 20 )
            end
            
            --  > Draw Install status
            surface.SetDrawColor( color_white )
            surface.SetMaterial( selected_addon.installed and mats.Accept or mats.NotAccept )
            surface.DrawTexturedRect( 25 * 1.5 + iconSize, 25 + name_h, 16, 16 )

            draw.SimpleText( selected_addon.installed and "Installed" or "Not Installed", "GNLFontB15", 25 * 1.5 + iconSize + 20, 25 + name_h, selected_addon.installed and GNLib.Colors.Emerald or GNLib.Colors.Alizarin )
                 
            --  > Draw lib update status
            surface.SetDrawColor( color_white )
            surface.SetMaterial( not GNLib.IsOutdatedLib( selected_addon_id ) and mats.Accept or mats.Update )
            surface.DrawTexturedRect( 25 * 1.5 + iconSize, 25 + name_h + 20, 16, 16 )

            draw.SimpleText( not GNLib.IsOutdatedLib( selected_addon_id ) and "Similar version of the library" or "Different version of the library", "GNLFontB15", 25 * 1.5 + iconSize + 20, 25 + name_h + 20, not GNLib.IsOutdatedLib( selected_addon_id ) and GNLib.Colors.Emerald or GNLib.Colors.Orange )
        
            --  > Draw addon update status
            surface.SetDrawColor( color_white )
            surface.SetMaterial( not GNLib.IsOutdated( selected_addon_id ) and mats.Accept or mats.Update )
            surface.DrawTexturedRect( 25 * 1.5 + iconSize, 25 + name_h + 40, 16, 16 )

            draw.SimpleText( not GNLib.IsOutdated( selected_addon_id ) and "Similar version of this addon" or "Different version of this addon", "GNLFontB15", 25 * 1.5 + iconSize + 20, 25 + name_h + 40, not GNLib.IsOutdated( selected_addon_id ) and GNLib.Colors.Emerald or GNLib.Colors.Orange )
            
            --  > Draw WIP
            surface.SetDrawColor( Color( 255, 255, 255, bug_alpha ) )
            surface.SetMaterial( selected_addon.wip and mats.Bug or mats.Accept )
            surface.DrawTexturedRect( 25 * 1.5 + iconSize, 25 + name_h + 60, 16, 16 )

            surface.SetDrawColor( Color( 255, 255, 255, 255 - bug_alpha ) )
            surface.SetMaterial( selected_addon.wip and mats.BugWarning or mats.Accept )
            surface.DrawTexturedRect( 25 * 1.5 + iconSize, 25 + name_h + 60, 16, 16 )

            if bug_alpha >= 250 then
                bug_target = 0
            elseif bug_alpha <= 5 then
                bug_target = 255
            end
            bug_alpha = Lerp( FrameTime() * 3, bug_alpha, bug_target )

            draw.SimpleText( selected_addon.wip and "Warning ! This addon may create errors or may not working properly !" or "This addon is currently stable.", "GNLFontB15", 25 * 1.5 + iconSize + 20, 25 + name_h + 60, selected_addon.wip and GNLib.Colors.SunFlower or GNLib.Colors.Emerald )
        end
    end
            
    function addAddon( k, v )
        local addon_line = addons_list:Add( "DButton" )
        addon_line:Dock( TOP )
        addon_line:SetTall( 35 )
        addon_line:SetText( "" )

        local x = addon_line:GetWide()
        function addon_line:Paint( w, h )
            local second_col = GNLib.Colors.Pomegranate

            if v.installed then
                second_col = GNLib.Colors.Nephritis

                if not ( v.lib_version == GNLib.Version ) then
                    second_col = GNLib.Colors.Carrot 
                end
            end

            surface.SetDrawColor( GNLib.Colors.MidnightBlue )
            surface.DrawRect( 0, 0, w, h )
            if k == selected_addon_id then
                x = Lerp( FrameTime() * 5, x, w * .25 )
                GNLib.DrawRectGradient( x, 0, w, h, GNLib.Colors.MidnightBlue, second_col )
            else
                x = Lerp( FrameTime() * 5, x, w / 2 )
                GNLib.DrawRectGradient( x, 0, w, h, GNLib.Colors.MidnightBlue, second_col )
            end
            
            draw.SimpleText( ( v.name or "N/A" ), "GNLFontB15", 5, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            draw.SimpleText( ( v.author or "N/A" ) .. " | " .. ( v.lib_version or "N/A" ), "GNLFont15", 5, h - 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        
            if v.certified then
                surface.SetDrawColor( color_white )
                surface.SetMaterial( mats.Certified )
                surface.DrawTexturedRect( w - 30, h / 2 - 7, 16, 16 )
            end
        end
        
        function addon_line:DoClick()
            sound.Play( "ui/buttonclick.wav", LocalPlayer():GetPos(), 75, 100, .80 )
            
            if v.logoURL then
                file.CreateDir( "downloaded/gnlib_addons" )

                GNLib.DownloadFromURL( v.logoURL, "gnlib_addons/" .. k .. ".jpg", function()
                    selected_addon = v
                    selected_addon_id = k
                    selected_addon_mat = GNLib.CreateMaterial( "gnlib_addons/" .. k .. ".jpg", "noclamp smooth" )
                end )
            else
                selected_addon = v
                selected_addon_id = k
            end
        end
        function addon_line:OnCursorEntered()
            sound.Play( "ui/buttonrollover.wav", LocalPlayer():GetPos(), 75, 100, .80 )
        end
    end
    
    local notCertified = {}
    for k, v in pairs( GNLib.GetAddons() ) do
        if v.certified then addAddon( k, v ) else notCertified[k] = v end
    end
    for k, v in pairs( notCertified ) do
        addAddon( k, v )
    end
    
end
concommand.Add( "gnlib_list", GNLib.OpenAddonsList )