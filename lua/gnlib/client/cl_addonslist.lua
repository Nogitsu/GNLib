local mats = 
{
    Installed = Material( "icon16/accept.png" ),
    NotInstalled = Material( "icon16/cancel.png" ),
    Update = Material( "icon16/wrench_orange.png" ),
    Certified = Material( "icon16/rosette.png", "smooth" ),
    DefaultPic = Material( "vgui/avatar_default", "smooth" ),
}

function GNLib.OpenAddonsList()
    local W, H = ScrW() * .75, ScrH() * .75

    local main = vgui.Create( "DPanel" )
    main:SetSize( W, H )
    main:Center()
    main:MakePopup()
    function main:Paint( w, h )
        GNLib.DrawRectGradient( 0, 0, w, h, GNLib.Colors.MidnightBlue, GNLib.Colors.WetAsphalt, true )

        draw.SimpleText( "GNLib Addons List - " .. GNLib.Version, "DermaDefaultBold", 15, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
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

            -- > Draw certification
            surface.SetFont( "DermaLarge" )
            surface.SetDrawColor( color_white )
            if selected_addon.certified then
                surface.SetMaterial( mats.Certified )
                surface.DrawTexturedRect( 25 * 1.5 + iconSize + surface.GetTextSize( selected_addon.name ) + 8, 30, 20, 20 )
            end
            
            --  > Draw name
            draw.SimpleText( selected_addon.name, "DermaLarge", 25 * 1.5 + iconSize, 25, color_white )
            
            --  > Draw installed status
            surface.SetDrawColor( color_white )
            surface.SetMaterial( selected_addon.installed and mats.Installed or mats.NotInstalled )
            surface.DrawTexturedRect( 25 * 1.5 + iconSize, 25 + 35, 16, 16 )

            draw.SimpleText( selected_addon.installed and "Installed" or "Not installed", "DermaDefaultBold", 25 * 1.5 + iconSize + 20, 25 + 35, selected_addon.installed and GNLib.Colors.Emerald or GNLib.Colors.Alizarin )
            
            --  > Draw lib update status
            surface.SetDrawColor( color_white )
            surface.SetMaterial( not GNLib.IsOutdatedLib( selected_addon_id ) and mats.Installed or mats.Update )
            surface.DrawTexturedRect( 25 * 1.5 + iconSize, 25 + 35 + 20, 16, 16 )

            draw.SimpleText( not GNLib.IsOutdatedLib( selected_addon_id ) and "Newest version of the library" or "Old version of the library", "DermaDefaultBold", 25 * 1.5 + iconSize + 20, 25 + 35 + 20, not GNLib.IsOutdatedLib( selected_addon_id ) and GNLib.Colors.Emerald or GNLib.Colors.Orange )
        end
    end

    --  > Completing list
    local function addAddon( k, v )
        local addon_line = addons_list:Add( "DButton" )
        addon_line:Dock( TOP )
        addon_line:SetText( "" )
        addon_line:SetTall( 35 )
        function addon_line:Paint( w, h )
            local second_col = GNLib.Colors.Pomegranate

            if v.installed then
                second_col = GNLib.Colors.Nephritis

                if not ( v.lib_version == GNLib.Version ) then
                    second_col = GNLib.Colors.Carrot 
                end
            end

            surface.SetDrawColor( GNLib.Colors.MidnightBlue )
            surface.DrawRect( 0, 0, w/2, h )
            GNLib.DrawRectGradient( w/2, 0, w, h, GNLib.Colors.MidnightBlue, second_col )
            
            draw.SimpleText( ( v.name or "N/A" ), "DermaDefaultBold", 5, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            draw.SimpleText( ( v.author or "N/A" ) .. " | " .. ( v.lib_version or "N/A" ), "DermaDefault", 5, h - 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        
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
                    selected_addon_mat = Material( "data/downloaded/gnlib_addons/" .. k .. ".jpg", "noclamp smooth" )
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