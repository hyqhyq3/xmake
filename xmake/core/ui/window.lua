--!A cross-platform build utility based on Lua
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 
-- Copyright (C) 2015 - 2018, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        window.lua
--

-- load modules
local log    = require("ui/log")
local rect   = require("ui/rect")
local view   = require("ui/view")
local label  = require("ui/label")
local panel  = require("ui/panel")
local curses = require("ui/curses")

-- define module
local window = window or panel()

-- init window
function window:init(name, bounds, title, shadow)

    -- init panel
    panel.init(self, name, bounds)

    -- check bounds
    assert(self:width() > 4 and self:height() > 3, string.format("%s: too small!", self))

    -- insert shadow
    if shadow then
        self:insert(self:shadow())
        self:frame():bounds():movee(-2, -1)
    end

    -- insert border
    self:frame():insert(self:border())

    -- insert panel
    self:frame():insert(self:panel())

    -- insert title
    if title then
        self._TITLE = label:new("window.title", rect{0, 0, #title, 1}, title)
        self:title():textattr_set("blue bold")
        self:frame():insert(self:title(), {centerx = true})
    end

    -- insert frame
    self:insert(self:frame())
end

-- get frame
function window:frame()
    if not self._FRAME then
        self._FRAME = panel:new("window.frame", rect{0, 0, self:width(), self:height()}):background_set("white")
    end
    return self._FRAME
end

-- get panel
function window:panel()
    if not self._PANEL then
        self._PANEL = panel:new("window.panel", self:frame():bounds())
        self._PANEL:bounds():grow(-1, -1)
    end
    return self._PANEL
end

-- get title
function window:title()
    return self._TITLE
end

-- get shadow 
function window:shadow()
    if not self._SHADOW then
        self._SHADOW = view:new("window.shadow", rect{2, 1, self:width(), self:height()}):background_set("black")
    end
    return self._SHADOW
end

-- get border 
function window:border()
    if not self._BORDER then
        local border = view:new("window.border", self:frame():bounds())
        function border:draw()

            -- draw left and top border
            self:canvas():attr(curses.color_pair("white", self:background()))
            self:canvas():move(0, 0):putchar("hline", self:width())
            self:canvas():move(0, 0):putchar("ulcorner")
            self:canvas():move(0, 1):putchar("vline", self:height() - 1, true)
            self:canvas():move(0, self:height() - 1):putchar("llcorner")

            -- draw bottom and right border
            self:canvas():attr(curses.color_pair("black", self:background()))
            self:canvas():move(1, self:height() - 1):putchar("hline", self:width() - 1)
            self:canvas():move(self:width() - 1, 0):putchar("urcorner")
            self:canvas():move(self:width() - 1, 1):putchar("vline", self:height() - 1, true)
            self:canvas():move(self:width() - 1, self:height() - 1):putchar("lrcorner")
        end
        self._BORDER = border
    end
    return self._BORDER
end

-- return module
return window