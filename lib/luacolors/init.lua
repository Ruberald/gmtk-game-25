local luacolors = {
    _VERSION     = 'luacolors v0.1.0',
    _DESCRIPTION = 'Color utility library for Lua',
    _URL         = 'https://github.com/icrawler/luacolors',
    _LICENSE     = [[
    MIT LICENSE

    Copyright (c) 2014 Phoenix Enero

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]]
}

-- private methods
local function f1(t)
    return t > 0.0088564516790356 and t^0.3333333333333333 or
               0.3333333333333333*23.3611111111111111*t + 0.1379310344827586
end

local function f2(t)
    return t > 0.2068965517241379 and t*t*t or
               3*0.0428061831153388*(t-0.1379310344827586)
end

-- public functions

-- Convert gamma-corrected RGB to CIEXYZ
local function sRGBtoXYZ(r, g, b)
	local f = 1/255
	r = r*f
	g = g*f
	b = b*f
	r = r <= 0.04045 and r/12.92 or ((r+0.055)/(1.055))^2.4
	g = g <= 0.04045 and g/12.92 or ((g+0.055)/(1.055))^2.4
	b = b <= 0.04045 and b/12.92 or ((b+0.055)/(1.055))^2.4
	local X = 0.4124*r + 0.3576*g + 0.1805*b
	local Y = 0.2126*r + 0.7152*g + 0.0722*b
	local Z = 0.0193*r + 0.1192*g + 0.9502*b
	return X*100, Y*100, Z*100
end


-- Convert CIEXYZ to gamma-corrected RGB
local function XYZtosRGB(X, Y, Z)
	X, Y, Z = X/100, Y/100, Z/100
	local r =  3.2406*X - 1.5372*Y - 0.4986*Z
	local g = -0.9689*X + 1.8758*Y + 0.0415*Z
	local b =  0.0557*X - 0.2040*Y + 1.0570*Z
	local k = 1/2.4
	local floor = math.floor
	r = floor((r <= 0.0031308 and 12.92*r or 1.055*r^k-0.055)*255+0.5)
	g = floor((g <= 0.0031308 and 12.92*g or 1.055*g^k-0.055)*255+0.5)
	b = floor((b <= 0.0031308 and 12.92*b or 1.055*b^k-0.055)*255+0.5)
	return r, g, b
end

-- convert CIEXYZ to CIELAB
local function XYZtoLab(X, Y, Z)
	local yon = f1(Y/100)
	local L = 116*(yon) - 16
	local a = 500*(f1(X/95.047) - yon)
	local b = 200*(yon - f1(Z/108.883))
	return L, a, b
end


-- convert gamma-corrected RGB to CIELAB
local function sRGBtoLab(r, g, b)
	return XYZtoLab(sRGBtoXYZ(r, g, b))
end

-- convert CIELAB to CIEXYZ
local function LabtoXYZ(L, a, b)
	local k = 0.0086206896551724*(L+16)
	local Y = 100*f2(k)
	local X = 95.047*f2(k+0.002*a)
	local Z = 108.883*f2(k-0.005*b)
	return X, Y, Z
end


-- convert CIELAB to gamma-corrected RGB
local function LabtosRGB(L, a, b)
	return XYZtosRGB(LabtoXYZ(L, a, b))
end


-- convert HSL to RGB
-- (taken from https://www.love2d.org/wiki/HSL_color with a few modifications)
local function HSLtoRGB(h, s, l)
    if s<=0 then return l,l,l   end
    h, s, l = h/360*6, s/255, l/255
    local c = (1-math.abs(2*l-1))*s
    local x = (1-math.abs(h%2-1))*c
    local m,r,g,b = (l-.5*c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end


-- convert RGB to HSL
local function RGBtoHSL(r, g, b)
    r, g, b    = r/255, g/255, b/255
	local M, m =  math.max(r, g, b),
				  math.min(r, g, b)
	local c, H = M - m, 0
	if     M == r then H = (g-b)/c%6
	elseif M == g then H = (b-r)/c+2
	elseif M == b then H = (r-g)/c+4
	end	local L = 0.5*M+0.5*m
	local S = c == 0 and 0 or c/(1-math.abs(2*L-1))
	return ((1/6)*H)*360%360, S*255, L*255
end

-- @param table t
local function rgbForGraphics(t)
    return love.math.colorFromBytes(unpack(t))
end

-- public interface
luacolors.sRGBtoXYZ = sRGBtoXYZ
luacolors.XYZtosRGB = XYZtosRGB
luacolors.XYZtoLab = XYZtoLab
luacolors.LabtoXYZ = LabtoXYZ
luacolors.LabtosRGB = LabtosRGB
luacolors.sRGBtoLab = sRGBtoLab
luacolors.HSLtoRGB = HSLtoRGB
luacolors.RGBtoHSL = RGBtoHSL
luacolors.rgbForGraphics = rgbForGraphics


-- colors
-- taken from http://en.wikipedia.org/wiki/CSS_colors
-- Usage: love.graphics.setBackgroundColor(love.math.colorFromBytes(unpack(colors.Slate800)))
luacolors.white = {255, 255, 255}
luacolors.whiteAlpha = function (a) return {255, 255, 255, a} end
luacolors.black = {0, 0, 0}
luacolors.blackAlpha = function (a) return {0, 0, 0, a} end
luacolors.silver = {191, 191, 191}
luacolors.gray = {127, 127, 127}
luacolors.red = {255, 0, 0}
luacolors.maroon = {127, 0, 0}
luacolors.yellow = {255, 255, 0}
luacolors.olive = {127, 127, 0}
luacolors.lime = {0, 255, 0}
luacolors.green = {0, 127, 0}
luacolors.aqua = {0, 255, 255}
luacolors.teal = {0, 127, 127}
luacolors.blue = {0, 0, 255}
luacolors.navy = {0, 0, 127}
luacolors.fuchsia = {255, 0, 255}
luacolors.purple = {127, 0, 127}

-- tailwindcss color palette
luacolors.Slate50 = { 248, 250, 252 }
luacolors.Slate100 = { 241, 245, 249 }
luacolors.Slate200 = { 226, 232, 240 }
luacolors.Slate300 = { 203, 213, 225 }
luacolors.Slate400 = { 148, 163, 184 }
luacolors.Slate = { 100, 116, 139 }
luacolors.Slate500 = { 100, 116, 139 }
luacolors.Slate600 = { 71, 85, 105 }
luacolors.Slate700 = { 51, 65, 85 }
luacolors.Slate800 = { 30, 41, 59 }
luacolors.Slate900 = { 15, 23, 42 }
luacolors.Gray50 = { 249, 250, 251 }
luacolors.Gray100 = { 243, 244, 246 }
luacolors.Gray200 = { 229, 231, 235 }
luacolors.Gray300 = { 209, 213, 219 }
luacolors.Gray400 = { 156, 163, 175 }
luacolors.Gray = { 107, 114, 128 }
luacolors.Gray500 = { 107, 114, 128 }
luacolors.Gray600 = { 75, 85, 99 }
luacolors.Gray700 = { 55, 65, 81 }
luacolors.Gray800 = { 31, 41, 55 }
luacolors.Gray900 = { 17, 24, 39 }
luacolors.Zinc50 = { 250, 250, 250 }
luacolors.Zinc100 = { 244, 244, 245 }
luacolors.Zinc200 = { 228, 228, 231 }
luacolors.Zinc300 = { 212, 212, 216 }
luacolors.Zinc400 = { 161, 161, 170 }
luacolors.Zinc = { 113, 113, 122 }
luacolors.Zinc500 = { 113, 113, 122 }
luacolors.Zinc600 = { 82, 82, 91 }
luacolors.Zinc700 = { 63, 63, 70 }
luacolors.Zinc800 = { 39, 39, 42 }
luacolors.Zinc900 = { 24, 24, 27 }
luacolors.Neutral50 = { 250, 250, 250 }
luacolors.Neutral100 = { 245, 245, 245 }
luacolors.Neutral200 = { 229, 229, 229 }
luacolors.Neutral300 = { 212, 212, 212 }
luacolors.Neutral400 = { 163, 163, 163 }
luacolors.Neutral = { 115, 115, 115 }
luacolors.Neutral500 = { 115, 115, 115 }
luacolors.Neutral600 = { 82, 82, 82 }
luacolors.Neutral700 = { 64, 64, 64 }
luacolors.Neutral800 = { 38, 38, 38 }
luacolors.Neutral900 = { 23, 23, 23 }
luacolors.Stone50 = { 250, 250, 249 }
luacolors.Stone100 = { 245, 245, 244 }
luacolors.Stone200 = { 231, 229, 228 }
luacolors.Stone300 = { 214, 211, 209 }
luacolors.Stone400 = { 168, 162, 158 }
luacolors.Stone = { 120, 113, 108 }
luacolors.Stone500 = { 120, 113, 108 }
luacolors.Stone600 = { 87, 83, 78 }
luacolors.Stone700 = { 68, 64, 60 }
luacolors.Stone800 = { 41, 37, 36 }
luacolors.Stone900 = { 28, 25, 23 }
luacolors.Red50 = { 254, 242, 242 }
luacolors.Red100 = { 254, 226, 226 }
luacolors.Red200 = { 254, 202, 202 }
luacolors.Red300 = { 252, 165, 165 }
luacolors.Red400 = { 248, 113, 113 }
luacolors.Red = { 239, 68, 68 }
luacolors.Red500 = { 239, 68, 68 }
luacolors.Red600 = { 220, 38, 38 }
luacolors.Red700 = { 185, 28, 28 }
luacolors.Red800 = { 153, 27, 27 }
luacolors.Red900 = { 127, 29, 29 }
luacolors.Orange50 = { 255, 247, 237 }
luacolors.Orange100 = { 255, 237, 213 }
luacolors.Orange200 = { 254, 215, 170 }
luacolors.Orange300 = { 253, 186, 116 }
luacolors.Orange400 = { 251, 146, 60 }
luacolors.Orange = { 249, 115, 22 }
luacolors.Orange500 = { 249, 115, 22 }
luacolors.Orange600 = { 234, 88, 12 }
luacolors.Orange700 = { 194, 65, 12 }
luacolors.Orange800 = { 154, 52, 18 }
luacolors.Orange900 = { 124, 45, 18 }
luacolors.Amber50 = { 255, 251, 235 }
luacolors.Amber100 = { 254, 243, 199 }
luacolors.Amber200 = { 253, 230, 138 }
luacolors.Amber300 = { 252, 211, 77 }
luacolors.Amber400 = { 251, 191, 36 }
luacolors.Amber = { 245, 158, 11 }
luacolors.Amber500 = { 245, 158, 11 }
luacolors.Amber600 = { 217, 119, 6 }
luacolors.Amber700 = { 180, 83, 9 }
luacolors.Amber800 = { 146, 64, 14 }
luacolors.Amber900 = { 120, 53, 15 }
luacolors.Yellow50 = { 254, 252, 232 }
luacolors.Yellow100 = { 254, 249, 195 }
luacolors.Yellow200 = { 254, 240, 138 }
luacolors.Yellow300 = { 253, 224, 71 }
luacolors.Yellow400 = { 250, 204, 21 }
luacolors.Yellow = { 234, 179, 8 }
luacolors.Yellow500 = { 234, 179, 8 }
luacolors.Yellow600 = { 202, 138, 4 }
luacolors.Yellow700 = { 161, 98, 7 }
luacolors.Yellow800 = { 133, 77, 14 }
luacolors.Yellow900 = { 113, 63, 18 }
luacolors.Lime50 = { 247, 254, 231 }
luacolors.Lime100 = { 236, 252, 203 }
luacolors.Lime200 = { 217, 249, 157 }
luacolors.Lime300 = { 190, 242, 100 }
luacolors.Lime400 = { 163, 230, 53 }
luacolors.Lime = { 132, 204, 22 }
luacolors.Lime500 = { 132, 204, 22 }
luacolors.Lime600 = { 101, 163, 13 }
luacolors.Lime700 = { 77, 124, 15 }
luacolors.Lime800 = { 63, 98, 18 }
luacolors.Lime900 = { 54, 83, 20 }
luacolors.Green50 = { 240, 253, 244 }
luacolors.Green100 = { 220, 252, 231 }
luacolors.Green200 = { 187, 247, 208 }
luacolors.Green300 = { 134, 239, 172 }
luacolors.Green400 = { 74, 222, 128 }
luacolors.Green = { 34, 197, 94 }
luacolors.Green500 = { 34, 197, 94 }
luacolors.Green600 = { 22, 163, 74 }
luacolors.Green700 = { 21, 128, 61 }
luacolors.Green800 = { 22, 101, 52 }
luacolors.Green900 = { 20, 83, 45 }
luacolors.Emerald50 = { 236, 253, 245 }
luacolors.Emerald100 = { 209, 250, 229 }
luacolors.Emerald200 = { 167, 243, 208 }
luacolors.Emerald300 = { 110, 231, 183 }
luacolors.Emerald400 = { 52, 211, 153 }
luacolors.Emerald = { 16, 185, 129 }
luacolors.Emerald500 = { 16, 185, 129 }
luacolors.Emerald600 = { 5, 150, 105 }
luacolors.Emerald700 = { 4, 120, 87 }
luacolors.Emerald800 = { 6, 95, 70 }
luacolors.Emerald900 = { 6, 78, 59 }
luacolors.Teal50 = { 240, 253, 250 }
luacolors.Teal100 = { 204, 251, 241 }
luacolors.Teal200 = { 153, 246, 228 }
luacolors.Teal300 = { 94, 234, 212 }
luacolors.Teal400 = { 45, 212, 191 }
luacolors.Teal = { 20, 184, 166 }
luacolors.Teal500 = { 20, 184, 166 }
luacolors.Teal600 = { 13, 148, 136 }
luacolors.Teal700 = { 15, 118, 110 }
luacolors.Teal800 = { 17, 94, 89 }
luacolors.Teal900 = { 19, 78, 74 }
luacolors.Cyan50 = { 236, 254, 255 }
luacolors.Cyan100 = { 207, 250, 254 }
luacolors.Cyan200 = { 165, 243, 252 }
luacolors.Cyan300 = { 103, 232, 249 }
luacolors.Cyan400 = { 34, 211, 238 }
luacolors.Cyan = { 6, 182, 212 }
luacolors.Cyan500 = { 6, 182, 212 }
luacolors.Cyan600 = { 8, 145, 178 }
luacolors.Cyan700 = { 14, 116, 144 }
luacolors.Cyan800 = { 21, 94, 117 }
luacolors.Cyan900 = { 22, 78, 99 }
luacolors.Sky50 = { 240, 249, 255 }
luacolors.Sky100 = { 224, 242, 254 }
luacolors.Sky200 = { 186, 230, 253 }
luacolors.Sky300 = { 125, 211, 252 }
luacolors.Sky400 = { 56, 189, 248 }
luacolors.Sky = { 14, 165, 233 }
luacolors.Sky500 = { 14, 165, 233 }
luacolors.Sky600 = { 2, 132, 199 }
luacolors.Sky700 = { 3, 105, 161 }
luacolors.Sky800 = { 7, 89, 133 }
luacolors.Sky900 = { 12, 74, 110 }
luacolors.Blue50 = { 239, 246, 255 }
luacolors.Blue100 = { 219, 234, 254 }
luacolors.Blue200 = { 191, 219, 254 }
luacolors.Blue300 = { 147, 197, 253 }
luacolors.Blue400 = { 96, 165, 250 }
luacolors.Blue = { 59, 130, 246 }
luacolors.Blue500 = { 59, 130, 246 }
luacolors.Blue600 = { 37, 99, 235 }
luacolors.Blue700 = { 29, 78, 216 }
luacolors.Blue800 = { 30, 64, 175 }
luacolors.Blue900 = { 30, 58, 138 }
luacolors.Indigo50 = { 238, 242, 255 }
luacolors.Indigo100 = { 224, 231, 255 }
luacolors.Indigo200 = { 199, 210, 254 }
luacolors.Indigo300 = { 165, 180, 252 }
luacolors.Indigo400 = { 129, 140, 248 }
luacolors.Indigo = { 99, 102, 241 }
luacolors.Indigo500 = { 99, 102, 241 }
luacolors.Indigo600 = { 79, 70, 229 }
luacolors.Indigo700 = { 67, 56, 202 }
luacolors.Indigo800 = { 55, 48, 163 }
luacolors.Indigo900 = { 49, 46, 129 }
luacolors.Violet50 = { 245, 243, 255 }
luacolors.Violet100 = { 237, 233, 254 }
luacolors.Violet200 = { 221, 214, 254 }
luacolors.Violet300 = { 196, 181, 253 }
luacolors.Violet400 = { 167, 139, 250 }
luacolors.Violet = { 139, 92, 246 }
luacolors.Violet500 = { 139, 92, 246 }
luacolors.Violet600 = { 124, 58, 237 }
luacolors.Violet700 = { 109, 40, 217 }
luacolors.Violet800 = { 91, 33, 182 }
luacolors.Violet900 = { 76, 29, 149 }
luacolors.Purple50 = { 250, 245, 255 }
luacolors.Purple100 = { 243, 232, 255 }
luacolors.Purple200 = { 233, 213, 255 }
luacolors.Purple300 = { 216, 180, 254 }
luacolors.Purple400 = { 192, 132, 252 }
luacolors.Purple = { 168, 85, 247 }
luacolors.Purple500 = { 168, 85, 247 }
luacolors.Purple600 = { 147, 51, 234 }
luacolors.Purple700 = { 126, 34, 206 }
luacolors.Purple800 = { 107, 33, 168 }
luacolors.Purple900 = { 88, 28, 135 }
luacolors.Fuchsia50 = { 253, 244, 255 }
luacolors.Fuchsia100 = { 250, 232, 255 }
luacolors.Fuchsia200 = { 245, 208, 254 }
luacolors.Fuchsia300 = { 240, 171, 252 }
luacolors.Fuchsia400 = { 232, 121, 249 }
luacolors.Fuchsia = { 217, 70, 239 }
luacolors.Fuchsia500 = { 217, 70, 239 }
luacolors.Fuchsia600 = { 192, 38, 211 }
luacolors.Fuchsia700 = { 162, 28, 175 }
luacolors.Fuchsia800 = { 134, 25, 143 }
luacolors.Fuchsia900 = { 112, 26, 117 }
luacolors.Pink50 = { 253, 242, 248 }
luacolors.Pink100 = { 252, 231, 243 }
luacolors.Pink200 = { 251, 207, 232 }
luacolors.Pink300 = { 249, 168, 212 }
luacolors.Pink400 = { 244, 114, 182 }
luacolors.Pink = { 236, 72, 153 }
luacolors.Pink500 = { 236, 72, 153 }
luacolors.Pink600 = { 219, 39, 119 }
luacolors.Pink700 = { 190, 24, 93 }
luacolors.Pink800 = { 157, 23, 77 }
luacolors.Pink900 = { 131, 24, 67 }
luacolors.Rose50 = { 255, 241, 242 }
luacolors.Rose100 = { 255, 228, 230 }
luacolors.Rose200 = { 254, 205, 211 }
luacolors.Rose300 = { 253, 164, 175 }
luacolors.Rose400 = { 251, 113, 133 }
luacolors.Rose = { 244, 63, 94 }
luacolors.Rose500 = { 244, 63, 94 }
luacolors.Rose600 = { 225, 29, 72 }
luacolors.Rose700 = { 190, 18, 60 }
luacolors.Rose800 = { 159, 18, 57 }
luacolors.Rose900 = { 136, 19, 55 }

return luacolors