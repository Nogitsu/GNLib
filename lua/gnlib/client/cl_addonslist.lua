local mats = {
    Accept = Material( "icon16/accept.png" ),
    NotAccept = Material( "icon16/cancel.png" ),
    Update = Material( "icon16/wrench_orange.png" ),
    Certified = Material( "icon16/rosette.png", "smooth" ),
    DefaultPic = Material( "vgui/avatar_default", "smooth" ),
    Bug = Material( "icon16/bug.png" ),
    BugWarning = Material( "icon16/bug_error.png" ),
    Reload = Material( "icon16/arrow_refresh.png" ),
    Remove = Material( "icon16/cross.png" ),
    GitHub = Material( "materials/gnlib/GitHub-Logo.png" ),
    Steam = Material( "materials/gnlib/Steam-Logo.png" )
}

function GNLib.OpenAddonsList()
    local W, H = math.max( ScrW() * .75, 1024 ), math.max( ScrH() * .75, 720 )

    local main = GNLib.CreateFrame( "GNLib Addons List - " .. GNLib.Version )

    local refresh = vgui.Create( "DButton", main )
    refresh:SetPos( W - 55, 5 )
    refresh:SetSize( 20, 20 )
    refresh:SetText( "" )
    function refresh.DoClick()
        main:Remove()
        GNLib.OpenAddonsList()
    end
    function refresh:Paint( w, h )
        local c1 = GNLib.Colors.Concrete
        if self:IsHovered() then
            local t = math.abs( math.sin( CurTime() ) / w ) * 100 * 2
            c1 = GNLib.LerpColor( t, c1, GNLib.Colors.Nephritis )
        end
        GNLib.DrawRectGradient( 0, 0, w, h, GNLib.Colors.Asbestos, c1, true )

        surface.SetMaterial( mats.Reload )
        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect( 2, 2, 16, 16 )
    end

    local addons_list = vgui.Create( "DScrollPanel", main )
    addons_list:SetSize( W * 0.25, H - 40 )
    addons_list:SetPos( 10, 30 )
    addons_list:DockPadding( 0, 15, 0, 15 )

    local selected_addon

    local addon_infos = vgui.Create( "DPanel", main )
    addon_infos:SetSize( W * 0.75 - 30, H - 40 )
    addon_infos:SetPos( W * 0.25 + 20, 30 )

    --  > WIP Material alpha Lerp
    local bug_alpha = 0
    local bug_target = 255

    function addon_infos:Paint( w, h )
        GNLib.DrawRectGradient( 0, 0, w, h, GNLib.Colors.Concrete, GNLib.Colors.Silver, true )

        --GNLib.DrawTriangle( w / 2, h / 2, 50, 50, 50, Color( 255, 0, 0 ) )

        if selected_addon then
            --  > Draw icon
            local iconSize = h / 2
            surface.SetDrawColor( color_white )
            if selected_addon.logoURL then
                surface.SetMaterial( selected_addon.mat )
            else
                surface.SetMaterial( mats.DefaultPic )
            end
            surface.DrawTexturedRect( 25, 25, iconSize, iconSize )

            --  > Draw name
            GNLib.SimpleTextShadowed( selected_addon.name ..  " - " .. ( selected_addon.version or "N/A" ), "GNLFontB40", 25 * 1.5 + iconSize, 25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, 2, _ )

            --  > Draw certification
            surface.SetFont( "GNLFontB40" )
            local name_w, name_h = surface.GetTextSize( selected_addon.name .. " - " .. ( selected_addon.version or "N/A" ) )
            surface.SetDrawColor( color_white )
            if selected_addon.certified then
                surface.SetMaterial( mats.Certified )
                surface.DrawTexturedRect( 25 * 1.5 + iconSize + name_w + 8, 25 + name_h/2 - 10, 20, 20 )
            end

            --  > Draw Install status
            GNLib.DrawIconTextOutlined( selected_addon.installed and "Installed" or "Not Installed", "GNLFontB17", 25 * 1.5 + iconSize, 25 + name_h, selected_addon.installed and GNLib.Colors.Emerald or GNLib.Colors.Alizarin, selected_addon.installed and mats.Accept or mats.NotAccept, 16, 16, _, _, 1 )

            --  > Draw lib update status
            GNLib.DrawIconTextOutlined( GNLib.IsOutdatedLib( selected_addon.id ) and "Different version of the library (" .. string.Trim( selected_addon.lib_version ) .. ")" or "Similar version of the library", "GNLFontB17", 25 * 1.5 + iconSize, 25 + name_h + 20, GNLib.IsOutdatedLib( selected_addon.id ) and GNLib.Colors.Orange or GNLib.Colors.Emerald, GNLib.IsOutdatedLib( selected_addon.id ) and mats.Update or mats.Accept, 16, 16, _, _, 1 )

            --  > Draw addon update status
            GNLib.DrawIconTextOutlined( GNLib.IsOutdated( selected_addon.id ) and "Different version of this addon (" .. string.Trim( selected_addon.last_version ) .. ")" or "Similar version of this addon", "GNLFontB17", 25 * 1.5 + iconSize, 25 + name_h + 40, GNLib.IsOutdated( selected_addon.id ) and GNLib.Colors.Orange or GNLib.Colors.Emerald, GNLib.IsOutdated( selected_addon.id ) and mats.Update or mats.Accept, 16, 16, _, _, 1 )

            --  > Draw WIP
            surface.SetDrawColor( color_white )
            surface.SetMaterial( selected_addon.wip and mats.Bug or mats.Accept )
            surface.DrawTexturedRect( 25 * 1.5 + iconSize, 25 + name_h + 60, 16, 16 )

            surface.SetDrawColor( Color( 255, 255, 255, 255 - bug_alpha ) )
            surface.SetMaterial( selected_addon.wip and mats.BugWarning or mats.Accept )
            surface.DrawTexturedRect( 25 * 1.5 + iconSize, 25 + name_h + 60, 16, 16 )

            if bug_alpha >= 250 then
                bug_target = 1
            elseif bug_alpha <= 5 then
                bug_target = 255
            end
            bug_alpha = Lerp( FrameTime() * 3, bug_alpha, bug_target )

            draw.SimpleTextOutlined( selected_addon.wip and "Warning ! This addon may create errors or may not work properly !" or "This addon is currently stable.", "GNLFontB17", 25 * 1.5 + iconSize + 20, 25 + name_h + 60, selected_addon.wip and GNLib.Colors.SunFlower or GNLib.Colors.Emerald, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black )
        end
    end

    function addAddon( k, v )
        GNLib.CheckVersion( k, function( data, url )
            v.last_version = data
        end )

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
            if selected_addon and k == selected_addon.id then
                x = Lerp( FrameTime() * 5, x, w * .25 )
            else
                x = Lerp( FrameTime() * 5, x, w / 2 )
            end
            GNLib.DrawRectGradient( x, 0, w, h, GNLib.Colors.MidnightBlue, second_col )

            draw.SimpleText( ( v.name or "N/A" ), "GNLFontB15", 5, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            draw.SimpleText( ( v.author or "N/A" ) .. " | " .. ( v.lib_version or "N/A" ), "GNLFont15", 5, h - 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

            if v.certified then
                surface.SetDrawColor( color_white )
                surface.SetMaterial( mats.Certified )
                surface.DrawTexturedRect( w - 30, h / 2 - 7, 16, 16 )
            end
        end

        function addon_line:DoClick()
            sound.Play( "ui/buttonclick.wav", LocalPlayer():GetPos(), 75, 100, .80 ) -- want to control the volume

            selected_addon = v
            selected_addon.id = k

            if v.logoURL then
                file.CreateDir( "downloaded/gnlib_addons" )

                GNLib.DownloadFromURL( v.logoURL, "gnlib_addons/" .. k .. ".jpg", function()
                    selected_addon.mat = GNLib.CreateMaterial( "gnlib_addons/" .. k .. ".jpg", "noclamp smooth" )
                end )
            end

            addon_infos:Clear()

            --  > Addon Description
            local addon_desc = vgui.Create( "DLabel", addon_infos )
            addon_desc:SetSize( addon_infos:GetWide() - 30, addon_infos:GetTall() / 2 - 25 - 20 )
            addon_desc:SetPos( 25, 25 + addon_infos:GetTall() / 2 + 10 )
            addon_desc:SetFont( "GNLFontB17" )
            addon_desc:SetText( selected_addon.desc )
            addon_desc:SetTextColor( color_white )
            addon_desc:SetAutoStretchVertical( true )

            local icons_percent = 0.4

            local x, y = 40 + addon_infos:GetTall() / 2, 175
            if selected_addon.github_link then
                local github_button = vgui.Create( "DButton", addon_infos )
                github_button:SetPos( 40 + addon_infos:GetTall() / 2, y )
                github_button:SetSize( addon_infos:GetTall()/4, addon_infos:GetTall()/4)
                github_button:SetText( "" )
                function github_button:Paint( w, h )
                    local color = GNLib.Colors.MidnightBlue
                    if self:IsHovered() then
                        local t = math.abs( math.sin( CurTime() ) / w ) * 100 * 2
                        color = GNLib.LerpColor( t, color, GNLib.Colors.Wisteria )
                    end
                    surface.SetDrawColor( color )
                    surface.SetMaterial( mats.GitHub )
                    surface.DrawTexturedRect( 0, 0, w, h )
                end
                function github_button:DoClick()
                    gui.OpenURL( selected_addon.github_link )
                end
                x = github_button.x + github_button:GetWide() + 10
            end

            if selected_addon.workshop_link then
                local steam_button = vgui.Create( "DButton", addon_infos )
                steam_button:SetPos( x, y )
                steam_button:SetSize( addon_infos:GetTall()/4, addon_infos:GetTall()/4)
                steam_button:SetText( "" )
                function steam_button:Paint( w, h )
                    local color = GNLib.Colors.MidnightBlue
                    if self:IsHovered() then
                        local t = math.abs( math.sin( CurTime() ) / w ) * 100 * 2
                        color = GNLib.LerpColor( t, color, GNLib.Colors.BelizeHole )
                    end
                    surface.SetDrawColor( color )
                    surface.SetMaterial( mats.Steam )
                    surface.DrawTexturedRect( 0, 0, w, h )
                end
                function steam_button:DoClick()
                    gui.OpenURL( selected_addon.workshop_link )
                end
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
