local PANEL = {}

function PANEL:Init()
    self:SetSize( 300, 200 )
    self:DockPadding( 5, 5, 5, 5 )

    self.images = {}
    self.cur_image = 1

    self.new_mat_x = 0
    self.obj_mat_x = 0
    self.old_mat_x = 0

    self.btnLeft = self:Add( "DButton" )
        self.btnLeft:SetText( "<" )
        self.btnLeft:SetFont( "GNLFontB20" )
        self.btnLeft:Dock( LEFT )
        self.btnLeft.Paint = function( self, w, h )
            draw.SimpleText( self:GetText(), self:GetFont(), w / 2, h / 2, self:IsHovered() and GNLib.Colors.Concrete or GNLib.Colors.Clouds, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            return true
        end
        self.btnLeft.DoClick = function()
            if self.start_transition then return end

            self.old_mat = self.images[self.cur_image]
            self.cur_image = self.cur_image <= 1 and #self.images or self.cur_image - 1
            self.start_transition = true

            self.new_mat_x = -self:GetWide()
            self.obj_mat_x = -self.new_mat_x
            self.old_mat_x = 0
        end

    self.btnRight = self:Add( "DButton" )
        self.btnRight:SetText( ">" )
        self.btnRight:SetFont( "GNLFontB20" )
        self.btnRight:Dock( RIGHT )
        self.btnRight.Paint = function( self, w, h )
            draw.SimpleText( self:GetText(), self:GetFont(), w / 2, h / 2, self:IsHovered() and GNLib.Colors.Concrete or GNLib.Colors.Clouds, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            return true
        end
        self.btnRight.DoClick = function()
            if self.start_transition then return end

            self.old_mat = self.images[self.cur_image]
            self.cur_image = self.cur_image >= #self.images and 1 or self.cur_image + 1
            self.start_transition = true

            self.new_mat_x = self:GetWide()
            self.obj_mat_x = -self.new_mat_x
            self.old_mat_x = 0
        end
end

function PANEL:PerformLayout( w, h )
    self.btnLeft:SetWide( w / 10 )
    self.btnRight:SetWide( w / 10 )
end

function PANEL:GetImageByID( id )
    return self.images[id % #self.images].mat
end

function PANEL:AddImage( path, txt )
    local mat = isstring( path ) and Material( path ) or path -- allow material or path
    self.images[#self.images + 1] = { mat = mat, txt = txt }
end

function PANEL:Paint( w, h )
    local mat = self.images[self.cur_image]

    GNLib.DrawStencil( function()
        GNLib.DrawRoundedRect( 8, 0, 0, w, h, color_white )   
    end, function()
        if mat then 
            if self.start_transition then
                self.new_mat_x = Lerp( FrameTime() * 5, self.new_mat_x, 0 )
                self.old_mat_x = Lerp( FrameTime() * 5, self.old_mat_x, self.obj_mat_x )
    
                local floored_x = math.floor( self.new_mat_x )
                if floored_x <= 1 and floored_x >= -1 then
                    self.start_transition = false
                end
    
                GNLib.DrawMaterial( mat.mat , self.new_mat_x, 0, w, h ) 
                GNLib.SimpleTextShadowed( mat.txt, "GNLFontB15", self.new_mat_x + w / 2, h / 1.15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, 2, GNLib.Colors.WetAshpalt )
    
                GNLib.DrawMaterial( self.old_mat.mat, self.old_mat_x, 0, w, h )
                GNLib.SimpleTextShadowed( self.old_mat.txt, "GNLFontB15", self.old_mat_x + w / 2, h / 1.15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, 2, GNLib.Colors.WetAshpalt )
            else
                GNLib.DrawMaterial( mat.mat, 0, 0, w, h ) 
                GNLib.SimpleTextShadowed( mat.txt, "GNLFontB15", w / 2, h / 1.15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, 2, GNLib.Colors.WetAshpalt )
            end
        else
            GNLib.DrawRoundedRect( 8, 0, 0, w, h, GNLib.Colors.Silver )
        end
    end )
end

vgui.Register( "GNCarousel", PANEL, "DPanel" )