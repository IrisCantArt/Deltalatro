
----------------------------------------------
------------ASSETS / ATLASES------------------
----------------------------------------------

SMODS.Atlas{
    key = 'Jokers',
    path = 'Jokers.png',
    px = 71.1,
    py = 95
}

SMODS.Atlas({
  key = "flowers",
  path = "flowers.png",
  px = 71,
  py = 95,
})

SMODS.Atlas({
    key = "flowery",
    path = "flowery.png",
    px = 142,
    py = 190,
})
    

SMODS.Atlas({
    key = 'modicon',
    path = 'modicon.png',
    px = '32',
    py = '32'
})

SMODS.Atlas({
  key = "jackenstein",
  path = "jackenstein.png",
  px = 142,
  py = 95,
})

local DELTALATRO_UI_FONTS = {}
local function deltalatro_ui_font(size)
    size = math.max(8, math.floor(size or 18))
    if not DELTALATRO_UI_FONTS[size] then
        local ok, font = pcall(function()
            if love.filesystem and love.filesystem.getInfo
            and love.filesystem.getInfo("resources/fonts/m6x11plus.ttf") then
                return love.graphics.newFont("resources/fonts/m6x11plus.ttf", size)
            end
            return love.graphics.newFont(size)
        end)
        if ok and font then DELTALATRO_UI_FONTS[size] = font end
    end
    return DELTALATRO_UI_FONTS[size] or love.graphics.getFont()
end

local DLT_C3 = {
    sky = {0.47, 0.75, 0.82, 1},
    sky_light = {0.63, 0.84, 0.87, 1},
    wall_blue = {0.33, 0.59, 0.70, 1},
    wall_light = {0.48, 0.72, 0.77, 1},
    mint = {0.64, 0.85, 0.56, 1},
    mint_light = {0.77, 0.91, 0.64, 1},
    peach = {0.97, 0.70, 0.53, 1},
    peach_light = {1.00, 0.81, 0.62, 1},
    cream = {1.00, 0.91, 0.73, 1},
    glass = {0.57, 0.75, 0.76, 1},
    glass_light = {0.70, 0.83, 0.80, 1},
    teal = {0.25, 0.49, 0.58, 1},
    deep = {0.12, 0.27, 0.37, 1},
    ink = {0.12, 0.22, 0.30, 1},
    pink = {0.87, 0.27, 0.43, 1},
    pink_light = {0.98, 0.43, 0.52, 1},
    yellow = {1.00, 0.84, 0.43, 1},
    leaf = {0.34, 0.61, 0.43, 1},
    shadow = {0.10, 0.24, 0.33, 0.62},
}

local function dlt_c3_color(c, alpha)
    love.graphics.setColor(c[1], c[2], c[3], alpha or c[4] or 1)
end

local function dlt_c3_draw_star(x, y, size, color)
    dlt_c3_color(color)
    love.graphics.rectangle('fill', x + size * 0.35, y, size * 0.30, size, 0, 0)
    love.graphics.rectangle('fill', x, y + size * 0.35, size, size * 0.30, 0, 0)
    love.graphics.rectangle('fill', x + size * 0.18, y + size * 0.18, size * 0.64, size * 0.64, 0, 0)
end

local function dlt_c3_draw_backdrop(w, h)
    local lg = love.graphics
    dlt_c3_color(DLT_C3.sky)
    lg.rectangle('fill', 0, 0, w, h)
    dlt_c3_color(DLT_C3.wall_blue)
    lg.rectangle('fill', 0, 0, w, math.floor(h * 0.285))

    local tile_w, tile_h = math.max(70, math.floor(w / 11)), math.max(28, math.floor(h / 16))
    for row = 0, math.ceil((h * 0.285) / tile_h) do
        local yy = row * tile_h
        local offset = (row % 2) * tile_w * 0.5
        for col = -1, math.ceil(w / tile_w) do
            local xx = offset + col * tile_w
            dlt_c3_color((row + col) % 3 == 0 and DLT_C3.sky_light or DLT_C3.wall_light, 0.50)
            lg.rectangle('fill', xx + 2, yy + 2, tile_w - 4, tile_h - 4)
            dlt_c3_color(DLT_C3.teal, 0.68)
            lg.setLineWidth(2)
            lg.rectangle('line', xx, yy, tile_w, tile_h)
        end
    end

    for i = 0, 8 do
        local x = 18 + i * (w * 0.031)
        local y = 24 + (i % 3) * 13
        dlt_c3_color(i % 2 == 0 and DLT_C3.leaf or DLT_C3.mint, 0.84)
        lg.rectangle('fill', x, y, 7, 30 + (i % 3) * 8)
        lg.rectangle('fill', x - 7, y + 9, 9, 6)
        lg.rectangle('fill', x + 5, y + 17, 10, 6)
    end
    for i = 0, 13 do
        local x = (i * 97 + 38) % math.max(1, w - 20)
        local y = 18 + (i % 4) * 31
        dlt_c3_draw_star(x, y, 8 + (i % 3) * 2, i % 2 == 0 and DLT_C3.cream or DLT_C3.mint_light)
    end

    dlt_c3_color(DLT_C3.peach_light)
    lg.rectangle('fill', 0, h * 0.275, w, h * 0.045)
    dlt_c3_color(DLT_C3.peach)
    lg.rectangle('fill', 0, h * 0.305, w, h * 0.012)

    local floor_y = math.floor(h * 0.315)
    local floor_tile_w, floor_tile_h = math.max(60, math.floor(w / 12)), math.max(38, math.floor(h / 11))
    for row = 0, math.ceil((h - floor_y) / floor_tile_h) do
        for col = 0, math.ceil(w / floor_tile_w) do
            local use_peach = (row + col) % 2 == 0
            dlt_c3_color(use_peach and DLT_C3.peach_light or DLT_C3.mint_light)
            lg.rectangle('fill', col * floor_tile_w, floor_y + row * floor_tile_h,
                floor_tile_w, floor_tile_h)
            dlt_c3_color(use_peach and DLT_C3.peach or DLT_C3.mint, 0.52)
            lg.setLineWidth(1)
            lg.rectangle('line', col * floor_tile_w, floor_y + row * floor_tile_h,
                floor_tile_w, floor_tile_h)
        end
    end

    local bench_y, bench_h = h * 0.47, h * 0.22
    dlt_c3_color(DLT_C3.glass, 0.94)
    lg.rectangle('fill', w * 0.035, bench_y, w * 0.37, bench_h)
    lg.rectangle('fill', w * 0.55, bench_y, w * 0.405, bench_h)
    dlt_c3_color(DLT_C3.teal)
    lg.setLineWidth(4)
    lg.rectangle('line', w * 0.035, bench_y, w * 0.37, bench_h)
    lg.rectangle('line', w * 0.55, bench_y, w * 0.405, bench_h)
    dlt_c3_color(DLT_C3.sky_light, 0.8)
    lg.rectangle('fill', w * 0.035, bench_y + bench_h * 0.18, w * 0.37, bench_h * 0.26)
    lg.rectangle('fill', w * 0.55, bench_y + bench_h * 0.18, w * 0.405, bench_h * 0.26)
    dlt_c3_color(DLT_C3.mint, 0.95)
    lg.rectangle('fill', w * 0.035, bench_y + bench_h * 0.52, w * 0.37, bench_h * 0.48)
    lg.rectangle('fill', w * 0.55, bench_y + bench_h * 0.52, w * 0.405, bench_h * 0.48)

    local counter_y = h * 0.77
    for _, x in ipairs({w * 0.17, w * 0.62}) do
        dlt_c3_color(DLT_C3.glass_light)
        lg.rectangle('fill', x, counter_y, w * 0.18, h * 0.12)
        dlt_c3_color(DLT_C3.teal)
        lg.setLineWidth(3)
        lg.rectangle('line', x, counter_y, w * 0.18, h * 0.12)
        dlt_c3_color(DLT_C3.sky_light)
        lg.rectangle('fill', x + w * 0.025, counter_y + h * 0.025, w * 0.13, h * 0.035)
        dlt_c3_color(DLT_C3.leaf)
        lg.rectangle('fill', x + w * 0.065, counter_y + h * 0.072, w * 0.05, h * 0.012)
    end

    dlt_c3_color(DLT_C3.deep, 0.12)
    lg.rectangle('fill', 0, 0, w, h)
    lg.setLineWidth(1)
end

local function dlt_c3_draw_panel(x, y, w, h, fill)
    local lg = love.graphics
    dlt_c3_color(DLT_C3.shadow)
    lg.rectangle('fill', x + 6, y + 7, w, h)
    dlt_c3_color(fill or DLT_C3.glass_light)
    lg.rectangle('fill', x, y, w, h)
    dlt_c3_color(DLT_C3.deep)
    lg.setLineWidth(4)
    lg.rectangle('line', x, y, w, h)
    dlt_c3_color(DLT_C3.cream, 0.96)
    lg.setLineWidth(2)
    lg.rectangle('line', x + 4, y + 4, math.max(1, w - 8), math.max(1, h - 8))
    lg.setLineWidth(1)
end

local function dlt_c3_draw_header(x, y, w, h, title)
    local lg = love.graphics
    dlt_c3_color(DLT_C3.pink)
    lg.rectangle('fill', x, y, w, h)
    local block_w = 42
    for bx = 0, w, block_w do
        dlt_c3_color(math.floor(bx / block_w) % 2 == 0 and DLT_C3.pink_light or DLT_C3.pink, 0.8)
        lg.rectangle('fill', x + bx, y, math.min(block_w, w - bx), math.max(4, h * 0.15))
    end
    for sx = x + 14, x + w - 10, 78 do
        dlt_c3_draw_star(sx, y + h * 0.20, math.max(5, h * 0.16), DLT_C3.yellow)
    end
    dlt_c3_color(DLT_C3.yellow)
    lg.rectangle('fill', x, y + h - 5, w, 5)
    lg.setFont(deltalatro_ui_font(math.max(18, math.floor(h * 0.42))))
    dlt_c3_color(DLT_C3.cream)
    lg.printf(title, x + 12, y + h * 0.20, w - 24, 'center')
end

local function dlt_c3_draw_button(x, y, w, h, text, selected, fill)
    local base = fill or DLT_C3.mint
    if selected then base = DLT_C3.peach_light end
    dlt_c3_draw_panel(x, y, w, h, base)
    if selected then
        dlt_c3_color(DLT_C3.pink)
        love.graphics.rectangle('fill', x + 7, y + 7, 7, h - 14)
    end
    love.graphics.setFont(deltalatro_ui_font(math.max(14, math.floor(h * 0.28))))
    dlt_c3_color(DLT_C3.ink)
    love.graphics.printf(text, x + 18, y + (h - love.graphics.getFont():getHeight()) / 2,
        w - 30, 'center')
end

----------------------------------------------
------------Spamton code start---------------------
----------------------------------------------

SMODS.Sound({
    key = "BIGSHOT",
    path = "BIGSHOT.ogg",
})

SMODS.Sound({
    key = "eric_hyperlink",
    path = "eric_hyperlink.ogg",
})

G.SPAMTON_SHOP = G.SPAMTON_SHOP or {
    active = false,
    area = nil,
    cards = {},
    selected = 1,
    mode = "main",
    menu_selected = 1,
    talk_page = 0,

    soul_image = nil,
    soul_checked = false,

    shop_spam_image = nil,
    shop_spam_checked = false,

    fonts = {},

    hooks_installed = false,
    draw_hook_installed = false,
    key_hook_installed = false,
    mouse_hook_installed = false,
    update_hook_installed = false,
}

local function spamton_play_bigshot(pitch, volume)
    play_sound(
        "delta_BIGSHOT",
        pitch or 1.0,
        volume or 1.0
    )
end

local function spamton_play_eric()
    play_sound(
        "delta_eric_hyperlink",
        1.0,
        2.0
    )
end

local function spamton_owned()
    return G.jokers
        and next(SMODS.find_card("j_delta_Spamton")) ~= nil
end

local function fn_eric_owned()
    return G.jokers
        and next(SMODS.find_card("j_fn_Eric")) ~= nil
end

local function spamton_load_image(filename)
    local mod = SMODS.Mods["Deltalatro"]

    if not mod or not mod.path then
        return nil
    end

    local full_path =
        mod.path
        .. "/customimages/"
        .. filename

    local ok, image =
        pcall(function()
            if not NFS.getInfo(full_path) then
                return nil
            end

            local file_data =
                NFS.newFileData(full_path)

            local image_data =
                love.image.newImageData(file_data)

            local img =
                love.graphics.newImage(image_data)

            img:setFilter(
                "nearest",
                "nearest"
            )

            return img
        end)

    if ok then
        return image
    end

    return nil
end

local function spamton_get_soul()
    if not G.SPAMTON_SHOP.soul_checked then
        G.SPAMTON_SHOP.soul_checked = true

        G.SPAMTON_SHOP.soul_image =
            spamton_load_image(
                "shop_soul.png"
            )
    end

    return G.SPAMTON_SHOP.soul_image
end

local function spamton_get_shop_spam()
    if not G.SPAMTON_SHOP.shop_spam_checked then
        G.SPAMTON_SHOP.shop_spam_checked = true

        G.SPAMTON_SHOP.shop_spam_image =
            spamton_load_image(
                "shop_spam.png"
            )
    end

    return G.SPAMTON_SHOP.shop_spam_image
end

local function spamton_get_shop_background()
    if not G.SPAMTON_SHOP.shop_bg_checked then
        G.SPAMTON_SHOP.shop_bg_checked = true
        G.SPAMTON_SHOP.shop_bg_image = spamton_load_image("shop_spam_bg.png")
    end
    return G.SPAMTON_SHOP.shop_bg_image
end

local function spamton_get_font(size)
    if not G.SPAMTON_SHOP.fonts[size] then
        G.SPAMTON_SHOP.fonts[size] = deltalatro_ui_font(size)
    end
    return G.SPAMTON_SHOP.fonts[size] or love.graphics.getFont()
end

local function spamton_strip_formatting(text)
    text = tostring(text or "")

    text = text:gsub(
        "%b{}",
        ""
    )

    return text
end

local function spamton_get_name(card)
    if not card
    or not card.config
    or not card.config.center then
        return "UNKNOWN"
    end

    local center =
        card.config.center

    local key =
        center.key
        or card.config.center_key

    local set =
        center.set
        or "Joker"

    if key then
        local ok, result =
            pcall(function()
                return localize{
                    type = "name_text",
                    key = key,
                    set = set
                }
            end)

        if ok
        and result
        and result ~= ""
        and result ~= key then
            return tostring(result)
        end
    end

    return tostring(
        center.name
        or key
        or "UNKNOWN"
    )
end

local function spamton_collect_ui_text(node, out, depth)
    if type(node) ~= "table" or (depth or 0) > 24 then return end
    local cfg = node.config
    if cfg and type(cfg.text) == "string" and cfg.text ~= "" then
        out[#out + 1] = spamton_strip_formatting(cfg.text)
    end
    if type(node.nodes) == "table" then
        for _, child in ipairs(node.nodes) do
            spamton_collect_ui_text(child, out, (depth or 0) + 1)
        end
    end
end

local function spamton_copy_default(value)
    if type(value) ~= "table" then return value end
    local out = {}
    for k, v in pairs(value) do
        out[k] = spamton_copy_default(v)
    end
    return out
end

local function spamton_with_center_defaults(card, callback)
    local original_ability = card.ability
    if type(card.ability) ~= "table" then card.ability = {} end
    local ability = card.ability
    local config = (card.config and card.config.center and card.config.center.config) or {}
    local added = {}

    local function fill_if_missing(target, key, value)
        if type(target) == "table" and target[key] == nil and value ~= nil then
            target[key] = spamton_copy_default(value)
            added[#added + 1] = {target = target, key = key}
        end
    end

    for key, value in pairs(config) do
        if key == "Xmult" then
            fill_if_missing(ability, "x_mult", value)
        elseif key == "extra" then
            if ability.extra == nil then
                fill_if_missing(ability, "extra", value)
            elseif type(ability.extra) == "table" and type(value) == "table" then
                for extra_key, extra_value in pairs(value) do
                    fill_if_missing(ability.extra, extra_key, extra_value)
                end
            end
        elseif key ~= "x_mult" then
            fill_if_missing(ability, key, value)
        end
    end
    fill_if_missing(ability, "name", card.config.center.name)
    fill_if_missing(ability, "set", card.config.center.set)
    fill_if_missing(ability, "type", config.type or "")

    local ok, result = pcall(callback)
    for i = #added, 1, -1 do
        added[i].target[added[i].key] = nil
    end
    card.ability = original_ability
    if ok then return result end
    return nil
end

local function spamton_get_description(card)
    if not card or not card.config or not card.config.center then
        return "NO INFORMATION."
    end

    local old_bypass = card.bypass_discovery_ui
    card.bypass_discovery_ui = true
    local description = spamton_with_center_defaults(card, function()
        if type(card.generate_UIBox_ability_table) == "function" then
            local ok, ui_table = pcall(function()
                return card:generate_UIBox_ability_table()
            end)
            if ok and type(ui_table) == "table" and type(ui_table.main) == "table" then
                local lines = {}
                spamton_collect_ui_text(ui_table.main, lines, 0)
                local cleaned = {}
                local contains_nil = false
                for _, line in ipairs(lines) do
                    line = tostring(line):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
                    if line ~= "" and line ~= spamton_get_name(card) then
                        if line:match("%f[%a]nil%f[%A]") then contains_nil = true end
                        cleaned[#cleaned + 1] = line
                    end
                end
                if #cleaned > 0 and not contains_nil then
                    return table.concat(cleaned, "\n")
                end
            end
        end

        local center = card.config.center
        local key = center.key or card.config.center_key
        local set = center.set or (card.ability and card.ability.set) or "Joker"
        local vars = {}
        if center.loc_vars then
            local ok, result = pcall(function()
                return center.loc_vars(center, {}, card)
            end)
            if ok and result and type(result.vars) == "table" then
                vars = result.vars
            end
        else
            local a = card.ability or {}
            local cfg = center.config or {}
            local extra = type(a.extra) == "table" and a.extra or (type(cfg.extra) == "table" and cfg.extra or {})
            local name = a.name or center.name
            if name == "Sly Joker" or name == "Wily Joker" or name == "Clever Joker" or name == "Devious Joker" or name == "Crafty Joker" then
                vars = {a.t_chips or cfg.t_chips or 0, localize(a.type or cfg.type or "Pair", "poker_hands")}
            elseif name == "Jolly Joker" or name == "Zany Joker" or name == "Mad Joker" or name == "Crazy Joker" or name == "Droll Joker" then
                vars = {a.t_mult or cfg.t_mult or 0, localize(a.type or cfg.type or "Pair", "poker_hands")}
            elseif name == "Gluttonous Joker" or name == "Greedy Joker" or name == "Lusty Joker" or name == "Wrathful Joker" then
                vars = {extra.s_mult or 0, localize(extra.suit or "Clubs", "suits_singular")}
            elseif name == "Joker" then
                vars = {a.mult or cfg.mult or 0}
            elseif name == "Half Joker" then
                vars = {extra.mult or 0, extra.size or 0}
            end
        end

        if key then
            local ok, result = pcall(function()
                return localize{type = "raw_descriptions", key = key, set = set, vars = vars}
            end)
            if ok and result then
                local lines = {}
                if type(result) == "table" then
                    for _, line in ipairs(result) do
                        if type(line) == "string" then lines[#lines + 1] = spamton_strip_formatting(line) end
                    end
                elseif type(result) == "string" then
                    lines[1] = spamton_strip_formatting(result)
                end
                if #lines > 0 then
                    local text = table.concat(lines, "\n")
                    return text:gsub("%f[%a]nil%f[%A]", "?")
                end
            end
        end

        if center.loc_txt then
            local loc = center.loc_txt
            if loc["en-us"] then loc = loc["en-us"] elseif loc.default then loc = loc.default end
            if type(loc) == "table" and type(loc.text) == "table" then
                local lines = {}
                for _, line in ipairs(loc.text) do
                    if type(line) == "string" then
                        line = spamton_strip_formatting(line)
                        for i, value in ipairs(vars) do
                            line = line:gsub("#" .. tostring(i) .. "#", tostring(value == nil and "?" or value))
                        end
                        line = line:gsub("%f[%a]nil%f[%A]", "?")
                        lines[#lines + 1] = line
                    end
                end
                if #lines > 0 then return table.concat(lines, "\n") end
            end
        end
        return "NO INFORMATION."
    end)
    card.bypass_discovery_ui = old_bypass
    return description or "NO INFORMATION."
end

local function spamton_clear_preview_sprite(card)
    if card and card._spamton_preview_sprite then
        pcall(function()
            if card._spamton_preview_sprite.remove then
                card._spamton_preview_sprite:remove()
            end
        end)
        card._spamton_preview_sprite = nil
    end
end

local function spamton_get_preview_sprite(card)
    if not card or not card.config or not card.config.center then
        return nil
    end
    if card._spamton_preview_sprite then
        return card._spamton_preview_sprite
    end

    local center = card.config.center
    local original_sprite = card.children and card.children.center
    local atlas = original_sprite and original_sprite.atlas
    if not atlas then
        local atlas_key = center.atlas or center.set or "centers"
        atlas = G.ASSET_ATLAS and G.ASSET_ATLAS[atlas_key]
    end
    if not atlas then return nil end

    local pos = (original_sprite and original_sprite.sprite_pos) or center.pos or {x = 0, y = 0}
    local ok, sprite = pcall(function()
        return Sprite(0, 0, G.CARD_W * 0.9, G.CARD_H * 0.9, atlas, pos)
    end)
    if not ok or not sprite then return nil end
    if sprite.states then
        if sprite.states.visible ~= nil then sprite.states.visible = true end
        if sprite.states.hover then sprite.states.hover.can = false end
        if sprite.states.click then sprite.states.click.can = false end
        if sprite.states.drag then sprite.states.drag.can = false end
    end
    card._spamton_preview_sprite = sprite
    return sprite
end

local function spamton_wrap_text(
    text,
    font,
    max_width
)
    local result = {}

    for paragraph in tostring(text):gmatch("[^\n]*") do
        if paragraph == "" then
            result[#result + 1] = ""
        else
            local current = ""

            for word in paragraph:gmatch("%S+") do
                local candidate

                if current == "" then
                    candidate = word
                else
                    candidate =
                        current
                        .. " "
                        .. word
                end

                if font:getWidth(candidate)
                    > max_width
                    and current ~= "" then

                    result[#result + 1] =
                        current

                    current = word
                else
                    current = candidate
                end
            end

            if current ~= "" then
                result[#result + 1] =
                    current
            end
        end
    end

    return result
end

local function spamton_draw_wrapped(
    text,
    x,
    y,
    width,
    font,
    line_height
)
    local lines =
        spamton_wrap_text(
            text,
            font,
            width
        )

    love.graphics.setFont(
        font
    )

    for i, line in ipairs(lines) do
        love.graphics.print(
            line,
            x,
            y + ((i - 1) * line_height)
        )
    end

    return #lines * line_height
end

local function spamton_money()
    local dollars =
        (G.GAME and G.GAME.dollars)
        or 0

    return tostring(dollars)
end

local function spamton_get_total_entries()
    local shop = G.SPAMTON_SHOP
    if shop.mode == "items" then
        return #shop.cards + 1
    elseif shop.mode == "talkmenu" then
        return 3
    end
    return math.max(1, #shop.cards)
end

local function spamton_get_entry(index)
    local shop = G.SPAMTON_SHOP
    local card = shop.cards[index]
    if card then
        return {
            kind = "card",
            index = index,
            card = card
        }
    end
    if shop.mode == "items" and index == #shop.cards + 1 then
        return {
            kind = "menu",
            action = "exit",
            label = "RUN AWAY"
        }
    end
    return nil
end

local function spamton_set_selection(index)
    local total = spamton_get_total_entries()
    if total <= 0 then
        G.SPAMTON_SHOP.selected = 1
        return
    end
    if index < 1 then index = total end
    if index > total then index = 1 end
    G.SPAMTON_SHOP.selected = index
end

local function spamton_shop_layout(sw, sh)
    local frame_w = sw * 0.77
    local frame_x = (sw - frame_w) / 2
    local art_h = sh * 0.492
    local panel_y = sh * 0.512
    local panel_h = sh * 0.435
    local left_w = frame_w * 0.625
    local gap = frame_w * 0.010
    local right_w = frame_w - left_w - gap
    local left = {x = frame_x, y = panel_y, w = left_w, h = panel_h}
    local right = {x = frame_x + left_w + gap, y = panel_y, w = right_w, h = panel_h}

    local function rows(box, count, top_fraction, bottom_fraction)
        local result = {}
        local usable_h = box.h * bottom_fraction
        local row_h = usable_h / count
        for i = 1, count do
            result[i] = {
                x = box.x + box.w * 0.035,
                y = box.y + box.h * top_fraction + (i - 1) * row_h,
                w = box.w * 0.93,
                h = row_h * 0.94
            }
        end
        return result
    end

    local options = rows(right, 4, 0.055, 0.66)
    local talk_options = rows(left, 3, 0.035, 0.90)
    local items = rows(left, 5, 0.035, 0.94)
    local art = {x = frame_x, y = 0, w = frame_w, h = art_h}
    local preview = {
        x = art.x + art.w * 0.655,
        y = art.y + art.h * 0.075,
        w = art.w * 0.325,
        h = art.h * 0.84
    }
    local dialogue_panel = {
        x = left.x,
        y = left.y,
        w = left.w + gap + right.w,
        h = left.h
    }

    return {
        frame_x = frame_x,
        frame_w = frame_w,
        art = art,
        left = left,
        right = right,
        options = options,
        talk_options = talk_options,
        items = items,
        preview = preview,
        dialogue_panel = dialogue_panel,
        money_y = panel_y + panel_h * 0.825
    }
end

local function spamton_move_selection(amount)
    local shop = G.SPAMTON_SHOP
    if not shop.active then return end

    if shop.mode == "main" then
        shop.menu_selected = ((shop.menu_selected or 1) - 1 + amount) % 4 + 1
    elseif shop.mode == "talkmenu" then
        shop.talk_selected = ((shop.talk_selected or 1) - 1 + amount) % 3 + 1
    elseif shop.mode == "items" then
        spamton_set_selection((shop.selected or 1) + amount)
    end
end

local function spamton_random_discount()
    return math.random(
        20,
        80
    )
end

local function spamton_create_shop()
    if G.SPAMTON_SHOP.area then
        return
    end

    if G.STATE ~= G.STATES.SHOP then
        return
    end

    G.SPAMTON_SHOP.area =
        CardArea(
            -2000,
            -2000,
            G.CARD_W * 4,
            G.CARD_H,
            {
                card_limit = 4,
                type = "shop",
                highlight_limit = 1
            }
        )

    G.SPAMTON_SHOP.area.states.visible =
        false

    G.SPAMTON_SHOP.cards = {}
    G.SPAMTON_SHOP.selected = 1

    for i = 1, 4 do
        local shop_card =
            SMODS.create_card({
                set = "Joker",
                area = G.SPAMTON_SHOP.area,
                key_append =
                    "spamton_shop_"
                    .. tostring(i),
                skip_materialize = true,
                allow_duplicates = true
            })

        if shop_card then
            shop_card.ability =
                shop_card.ability
                or {}

            shop_card.ability.spamton_discounted =
                true

            shop_card.ability.spamton_original_cost =
                shop_card.cost or 1

            shop_card.ability.spamton_discount =
                spamton_random_discount()

            shop_card.cost =
                math.max(
                    1,
                    math.floor(
                        shop_card.ability.spamton_original_cost
                        * (
                            1
                            - (
                                shop_card.ability.spamton_discount
                                / 100
                            )
                        )
                        + 0.5
                    )
                )

            shop_card:set_cost(
                shop_card.cost
            )

            G.SPAMTON_SHOP.cards[
                #G.SPAMTON_SHOP.cards + 1
            ] = shop_card

            G.SPAMTON_SHOP.area:emplace(
                shop_card
            )

            shop_card:start_materialize()
        end
    end
end

local function spamton_hide_normal_shop()
    if G.shop_jokers then
        G.shop_jokers.states.visible =
            false
    end

    if G.shop_vouchers then
        G.shop_vouchers.states.visible =
            false
    end

    if G.shop_booster then
        G.shop_booster.states.visible =
            false
    end
end

local function spamton_show_normal_shop()
    if G.shop_jokers then
        G.shop_jokers.states.visible =
            true
    end

    if G.shop_vouchers then
        G.shop_vouchers.states.visible =
            true
    end

    if G.shop_booster then
        G.shop_booster.states.visible =
            true
    end
end

local function spamton_open_shop()
    if not spamton_owned() then
        return
    end

    if G.STATE ~= G.STATES.SHOP then
        return
    end

    if not G.SPAMTON_SHOP.area then
        spamton_create_shop()
    end

    if not G.SPAMTON_SHOP.area then
        return
    end

    G.SPAMTON_SHOP.active = true
    G.SPAMTON_SHOP.mode = "main"
    G.SPAMTON_SHOP.menu_selected = 1
    G.SPAMTON_SHOP.selected = 1
    G.SPAMTON_SHOP.talk_selected = 1
    G.SPAMTON_SHOP.dialogue_pages = nil
    G.SPAMTON_SHOP.dialogue_page = 1
    G.SPAMTON_SHOP.dialogue_progress = 0
    G.SPAMTON_SHOP.status_message = nil

    spamton_hide_normal_shop()

    spamton_play_bigshot(
        1.0,
        1.2
    )
end

local function spamton_close_shop()
    if not G.SPAMTON_SHOP.active then
        return
    end

    G.SPAMTON_SHOP.active = false

    spamton_show_normal_shop()

end

local function spamton_destroy_shop()
    G.SPAMTON_SHOP.active = false

    spamton_show_normal_shop()

    for _, shop_card in ipairs(G.SPAMTON_SHOP.cards or {}) do
        spamton_clear_preview_sprite(shop_card)
    end

    if G.SPAMTON_SHOP.area then
        pcall(function()
            G.SPAMTON_SHOP.area:remove()
        end)

        G.SPAMTON_SHOP.area = nil
    end

    G.SPAMTON_SHOP.cards = {}
    G.SPAMTON_SHOP.selected = 1
end

local function spamton_remove_purchased_card(card)
    for i, shop_card in ipairs(
        G.SPAMTON_SHOP.cards
    ) do
        if shop_card == card then
            spamton_clear_preview_sprite(shop_card)
            table.remove(
                G.SPAMTON_SHOP.cards,
                i
            )

            break
        end
    end

    local total =
        spamton_get_total_entries()

    if G.SPAMTON_SHOP.selected > total then
        G.SPAMTON_SHOP.selected =
            total
    end

    if G.SPAMTON_SHOP.selected < 1 then
        G.SPAMTON_SHOP.selected =
            1
    end
end

local SPAMTON_TALK_TOPICS = {
    [1] = {
        name = "OUR DEAL",
        hint = "LET'S MAKE A [DEAL].",
        pages = {
            "* TAKE THIS DEAL AND YOU WILL [DIE]!!!",
            "* IT'S THAT GOOD!!!",
            "* DEALS SO GOOD I'LL [$$$] MYSELF!"
        }
    },
    [2] = {
        name = "FEAR",
        hint = "WHAT ARE YOU AFRAID OF?",
        pages = {
            "* WHAT ARE YOU AFRAID OF???",
            "* ACCORDING TO [[ENCYCLOPEDIA]] OF [[BEING AFRAID]]...",
            "* THERE'S NOTHING TO FEAR..."
        }
    }
}

local function spamton_start_topic(topic_index)
    local shop = G.SPAMTON_SHOP
    local topic = SPAMTON_TALK_TOPICS[topic_index]
    if not topic then return end
    shop.talk_selected = topic_index
    shop.dialogue_pages = topic.pages
    shop.dialogue_page = 1
    shop.dialogue_progress = 0
    shop.mode = "dialogue"
end

local function spamton_advance_dialogue()
    local shop = G.SPAMTON_SHOP
    if shop.mode ~= "dialogue" then return end
    local pages = shop.dialogue_pages or {}
    local text = pages[shop.dialogue_page or 1] or ""
    if (shop.dialogue_progress or 0) < #text then
        shop.dialogue_progress = #text
        return
    end
    shop.dialogue_page = (shop.dialogue_page or 1) + 1
    if shop.dialogue_page > #pages then
        shop.mode = "talkmenu"
        shop.dialogue_pages = nil
        shop.dialogue_page = 1
        shop.dialogue_progress = 0
    else
        shop.dialogue_progress = 0
    end
end

local function spamton_buy_selected()
    if not G.SPAMTON_SHOP.active then
        return
    end

    local shop = G.SPAMTON_SHOP
    if shop.mode == "dialogue" then
        spamton_advance_dialogue()
        return
    end

    if shop.mode == "main" then
        local choice = shop.menu_selected or 1
        if choice == 1 then
            shop.mode = "items"
            shop.buy_mode = "single"
            shop.selected = 1
            shop.status_message = nil
        elseif choice == 2 then
            shop.mode = "items"
            shop.buy_mode = "more"
            shop.selected = 1
            shop.status_message = nil
        elseif choice == 3 then
            shop.mode = "talkmenu"
            shop.talk_selected = shop.talk_selected or 1
            shop.status_message = nil
        elseif choice == 4 then
            spamton_close_shop()
        end
        return
    end

    if shop.mode == "talkmenu" then
        local choice = shop.talk_selected or 1
        if choice == 1 or choice == 2 then
            spamton_start_topic(choice)
        elseif choice == 3 then
            shop.mode = "main"
            shop.menu_selected = 1
            shop.status_message = nil
        end
        return
    end

    local entry =
        spamton_get_entry(
            G.SPAMTON_SHOP.selected
        )

    if not entry then
        return
    end

    if entry.kind == "menu" then
        if entry.action == "exit" then
            shop.mode = "main"
            shop.menu_selected = 1
            shop.status_message = nil
        end
        return
    end

    local card =
        entry.card

    if not card then
        return
    end

    local price =
        math.max(
            1,
            math.floor(
                card.cost or 1
            )
        )

    if to_big(G.GAME.dollars)
        < to_big(price) then
        shop.status_message = "YOU DON'T HAVE ENOUGH [KROMER]!"
        return
    end

    shop.status_message = nil

    local original_cost =
        card.ability
        and card.ability.spamton_original_cost
        or card.cost
        or 1

    ease_dollars(
        -price
    )

    card.ability =
        card.ability
        or {}

    card.ability.spamton_discounted =
        nil

    card.ability.spamton_original_cost =
        original_cost

    card.ability.spamton_negative_until_ante =
        G.GAME.round_resets.ante

    card.cost =
        original_cost

    card:set_cost(
        original_cost
    )

    if G.SPAMTON_SHOP.area then
        G.SPAMTON_SHOP.area:remove_card(
            card
        )
    end

    spamton_remove_purchased_card(
        card
    )

    SMODS.add_to_deck(
        card,
        {
            area = G.jokers
        }
    )

    if G.jokers then
        G.jokers:emplace(
            card
        )
    end

    card.debuff = false

    if card.set_debuff then
        pcall(function()
            card:set_debuff(false)
        end)
    end

    card:juice_up(
        0.5,
        0.3
    )

    local replacement =
        SMODS.create_card({
            set = "Joker",
            area = G.SPAMTON_SHOP.area,
            key_append =
                "spamton_replacement",
            skip_materialize = true,
            allow_duplicates = true
        })

    if replacement then
        replacement.ability =
            replacement.ability
            or {}

        replacement.ability.spamton_discounted =
            true

        replacement.ability.spamton_original_cost =
            replacement.cost or 1

        replacement.ability.spamton_discount =
            spamton_random_discount()

        replacement.cost =
            math.max(
                1,
                math.floor(
                    replacement.ability.spamton_original_cost
                    * (
                        1
                        - (
                            replacement.ability.spamton_discount
                            / 100
                        )
                    )
                    + 0.5
                )
            )

        replacement:set_cost(
            replacement.cost
        )

        G.SPAMTON_SHOP.cards[
            #G.SPAMTON_SHOP.cards + 1
        ] = replacement

        G.SPAMTON_SHOP.area:emplace(
            replacement
        )

        replacement:start_materialize()
    end

    if G.SPAMTON_SHOP.selected >
        #G.SPAMTON_SHOP.cards then

        G.SPAMTON_SHOP.selected =
            math.max(
                1,
                #G.SPAMTON_SHOP.cards
            )
    end

    G.SPAMTON_SHOP.mode = "main"
    G.SPAMTON_SHOP.menu_selected = 1
    G.SPAMTON_SHOP.status_message = nil
end

local spamton_old_calculate_joker =
    Card.calculate_joker

local function spamton_negative_active(card)
    if not card
    or not card.ability
    or not card.ability.spamton_negative_until_ante then
        return false
    end

    if not G.GAME
    or not G.GAME.round_resets then
        return false
    end

    return G.GAME.round_resets.ante
        <= card.ability.spamton_negative_until_ante
end

local function spamton_negate_effect(effect)
    if type(effect) ~= "table" then
        return effect
    end

    local additive_values = {
        "mult",
        "mult_mod",
        "chips",
        "chip_mod",
        "dollars",
        "dollar_mod",
        "hands",
        "discards",
        "hand_size",
        "h_mod",
        "card_limit",
        "joker_slot",
        "consumable_slot",
        "extra_slots_used"
    }

    for _, key in ipairs(
        additive_values
    ) do
        if type(effect[key]) == "number" then
            effect[key] =
                -effect[key]
        end
    end

    local multiplier_values = {
        "xmult",
        "Xmult",
        "x_mult",
        "Xmult_mod",
        "x_mult_mod",
        "xchips",
        "Xchips",
        "x_chips",
        "Xchips_mod",
        "x_chips_mod"
    }

    for _, key in ipairs(
        multiplier_values
    ) do
        if type(effect[key]) == "number"
        and effect[key] ~= 0 then

            effect[key] =
                1 / effect[key]
        end
    end

    if type(effect.Emult) == "number"
    and effect.Emult ~= 0 then

        effect.Emult =
            1 / effect.Emult
    end

    if type(effect.emult) == "number"
    and effect.emult ~= 0 then

        effect.emult =
            1 / effect.emult
    end

    if type(effect.Echips) == "number"
    and effect.Echips ~= 0 then

        effect.Echips =
            1 / effect.Echips
    end

    if type(effect.echips) == "number"
    and effect.echips ~= 0 then

        effect.echips =
            1 / effect.echips
    end

    return effect
end

function Card:calculate_joker(
    context,
    ...
)
    local ret, trig =
        spamton_old_calculate_joker(
            self,
            context,
            ...
        )

    if spamton_negative_active(
        self
    )
    and type(ret) == "table" then

        ret =
            spamton_negate_effect(
                ret
            )
    end

    return ret, trig
end

G.FUNCS.spamton_toggle_shop =
    function()
        if G.SPAMTON_SHOP.active then
            spamton_close_shop()
        else
            spamton_open_shop()
        end
    end

if not G.SPAMTON_SHOP.hooks_installed then
    local old_shop_ui =
        G.UIDEF.shop

    G.UIDEF.shop =
        function()
            local ret =
                old_shop_ui()

            if spamton_owned() then
                local function insert_button(node)
                    if type(node) ~= "table" then
                        return false
                    end

                    if node.nodes then
                        for i, child in ipairs(
                            node.nodes
                        ) do
                            if type(child) == "table"
                            and child.config
                            and child.config.button
                            == "reroll_shop" then

                                table.insert(
                                    node.nodes,
                                    i + 1,
                                    UIBox_button{
                                        label = {
                                            "SPAMTON'S SHOP"
                                        },

                                        button =
                                            "spamton_toggle_shop",

                                        minw = 2.8,
                                        minh = 0.9,
                                        scale = 0.32,

                                        colour =
                                            G.C.RED or G.C.ORANGE,

                                        text_colour =
                                            G.C.WHITE,
                                        shadow = true
                                    }
                                )

                                return true
                            end

                            if insert_button(
                                child
                            ) then
                                return true
                            end
                        end
                    end

                    return false
                end

                insert_button(ret)
            end

            return ret
        end

    G.SPAMTON_SHOP.hooks_installed =
        true
end

if not G.SPAMTON_SHOP.key_hook_installed then
    local old_keypressed =
        love.keypressed

    love.keypressed =
        function(
            key,
            scancode,
            isrepeat
        )
            if G.SPAMTON_SHOP
            and G.SPAMTON_SHOP.active
            and G.STATE
                == G.STATES.SHOP then

                if key == "up" then
                    spamton_move_selection(
                        -1
                    )

                    return
                end

                if key == "down" then
                    spamton_move_selection(
                        1
                    )

                    return
                end

                if key == "return"
                or key == "kpenter" then

                    spamton_buy_selected()

                    return
                end

                if key == "escape" or key == "backspace" then
                    local shop = G.SPAMTON_SHOP
                    if shop.mode == "dialogue" then
                        shop.mode = "talkmenu"
                        shop.dialogue_pages = nil
                        shop.dialogue_page = 1
                        shop.dialogue_progress = 0
                    elseif shop.mode == "talkmenu" or shop.mode == "items" then
                        shop.mode = "main"
                        shop.menu_selected = 1
                        shop.status_message = nil
                    else
                        spamton_close_shop()
                    end
                    return
                end
            end

            if old_keypressed then
                return old_keypressed(
                    key,
                    scancode,
                    isrepeat
                )
            end
        end

    G.SPAMTON_SHOP.key_hook_installed =
        true
end

if not G.SPAMTON_SHOP.mouse_hook_installed then
    local old_mousepressed = love.mousepressed
    love.mousepressed = function(x, y, button, istouch, presses)
        local shop = G.SPAMTON_SHOP
        if shop and shop.active and G.STATE == G.STATES.SHOP then
            if button ~= 1 then return end
            local sw, sh = love.graphics.getDimensions()
            local layout = spamton_shop_layout(sw, sh)
            if shop.mode == "main" then
                for i, box in ipairs(layout.options) do
                    if x >= box.x and x <= box.x + box.w
                    and y >= box.y and y <= box.y + box.h then
                        shop.menu_selected = i
                        spamton_buy_selected()
                        return
                    end
                end
            elseif shop.mode == "talkmenu" then
                for i, box in ipairs(layout.talk_options) do
                    if x >= box.x and x <= box.x + box.w
                    and y >= box.y and y <= box.y + box.h then
                        shop.talk_selected = i
                        spamton_buy_selected()
                        return
                    end
                end
            elseif shop.mode == "dialogue" then
                if x >= layout.dialogue_panel.x and x <= layout.dialogue_panel.x + layout.dialogue_panel.w
                and y >= layout.dialogue_panel.y and y <= layout.dialogue_panel.y + layout.dialogue_panel.h then
                    spamton_advance_dialogue()
                end
                return
            elseif shop.mode == "items" then
                for i, box in ipairs(layout.items) do
                    if i <= #shop.cards + 1
                    and x >= box.x and x <= box.x + box.w
                    and y >= box.y and y <= box.y + box.h then
                        if shop.selected == i then
                            spamton_buy_selected()
                        else
                            shop.selected = i
                            shop.status_message = nil
                        end
                        return
                    end
                end
            end
            return
        end
        if old_mousepressed then
            return old_mousepressed(x, y, button, istouch, presses)
        end
    end
    G.SPAMTON_SHOP.mouse_hook_installed = true
end

if not G.SPAMTON_SHOP.update_hook_installed then
    local old_game_update =
        Game.update

    function Game:update(dt)
        old_game_update(
            self,
            dt
        )

        local shop = G.SPAMTON_SHOP
        if shop and shop.active and shop.mode == "dialogue" then
            local pages = shop.dialogue_pages or {}
            local page_text = pages[shop.dialogue_page or 1] or ""
            shop.dialogue_progress = math.min(#page_text,
                (shop.dialogue_progress or 0) + (dt or 0) * 36)
        end

        if not G.SPAMTON_SHOP.active then
            return
        end

        if G.STATE ~= G.STATES.SHOP then
            spamton_destroy_shop()
            return
        end

        if not spamton_owned() then
            spamton_destroy_shop()
            return
        end

        spamton_hide_normal_shop()
    end

    G.SPAMTON_SHOP.update_hook_installed =
        true
end

if not G.SPAMTON_SHOP.draw_hook_installed then
    local old_draw = love.draw or function() end
    love.draw = function()
        old_draw()
        local shop = G.SPAMTON_SHOP
        if not shop or not shop.active or G.STATE ~= G.STATES.SHOP then return end
        if G.SETTINGS and G.SETTINGS.paused then return end

        local sw, sh = love.graphics.getDimensions()
        local layout = spamton_shop_layout(sw, sh)
        local art, left, right = layout.art, layout.left, layout.right
        local old_font = love.graphics.getFont()
        local scale_ref = sh / 720
        local function setc(r, g, b, a) love.graphics.setColor(r, g, b, a or 1) end
        local function rect(mode, x, y, w, h) love.graphics.rectangle(mode, math.floor(x), math.floor(y), math.floor(w), math.floor(h)) end
        local function panel(box)
            setc(1, 1, 1, 1)
            love.graphics.setLineWidth(math.max(2, math.floor(2 * scale_ref)))
            rect("line", box.x, box.y, box.w, box.h)
            local c = math.max(5, 7 * scale_ref)
            for _, corner in ipairs({
                {box.x, box.y}, {box.x + box.w, box.y},
                {box.x, box.y + box.h}, {box.x + box.w, box.y + box.h}
            }) do
                local cx, cy = corner[1], corner[2]
                love.graphics.line(cx-c, cy, cx+c, cy)
                love.graphics.line(cx, cy-c, cx, cy+c)
                rect("fill", cx-1.4*scale_ref, cy-1.4*scale_ref, 3*scale_ref, 3*scale_ref)
            end
            love.graphics.setLineWidth(1)
        end
        local function heart_cursor(x, y, size)
            local soul = spamton_get_soul()
            if soul then
                local sw0, sh0 = soul:getDimensions()
                local sc = size / math.max(sw0, sh0)
                setc(1, 1, 1, 1)
                love.graphics.draw(soul, x, y, 0, sc, sc)
            else
                setc(1, 0.08, 0.12, 1)
                love.graphics.circle("fill", x + size*0.32, y + size*0.32, size*0.25)
                love.graphics.circle("fill", x + size*0.67, y + size*0.32, size*0.25)
                love.graphics.polygon("fill", x + size*0.08, y + size*0.40,
                    x + size*0.92, y + size*0.40, x + size*0.50, y + size)
            end
        end
        local function draw_phone(px, py, pw, ph)
            setc(0.22, 0.19, 0.31, 0.88)
            love.graphics.polygon("fill", px + pw*0.30, py, px + pw*0.72, py,
                px + pw*0.91, py + ph*0.80, px + pw*0.10, py + ph*0.80)
            setc(0, 0, 0, 1)
            rect("fill", px + pw*0.15, py + ph*0.68, pw*0.72, ph*0.18)
            setc(0.48, 0.38, 0.32, 1)
            rect("fill", px + pw*0.12, py + ph*0.78, pw*0.78, ph*0.07)
            setc(0.05, 0.04, 0.06, 1)
            rect("fill", px + pw*0.32, py + ph*0.51, pw*0.40, ph*0.22)
            rect("fill", px + pw*0.25, py + ph*0.50, pw*0.52, ph*0.06)
            setc(0.72, 0.67, 0.64, 1)
            love.graphics.circle("line", px + pw*0.52, py + ph*0.61, pw*0.095)
            love.graphics.circle("line", px + pw*0.52, py + ph*0.61, pw*0.06)
            setc(0.03, 0.03, 0.04, 1)
            rect("fill", px + pw*0.28, py + ph*0.87, pw*0.09, ph*0.07)
            rect("fill", px + pw*0.67, py + ph*0.87, pw*0.09, ph*0.07)
        end

        love.graphics.push("all")
        love.graphics.origin()
        setc(0, 0, 0, 1)
        rect("fill", 0, 0, sw, sh)

        local shop_bg = spamton_get_shop_background()
        if shop_bg then
            local bg_w, bg_h = shop_bg:getDimensions()
            if bg_w > 0 and bg_h > 0 then
                setc(1, 1, 1, 1)
                love.graphics.draw(shop_bg, art.x, art.y, 0, art.w / bg_w, art.h / bg_h)
            end
        else
            setc(0.22, 0.61, 0.84, 1)
            rect("fill", art.x, art.y, art.w, art.h)
            local brick_h = math.max(24, sh * 0.105)
            local brick_w = math.max(75, sw * 0.14)
            for row = 0, math.ceil(art.h / brick_h) do
                local by = art.y + row * brick_h
                local offset = (row % 2) * brick_w * 0.5
                setc(0.12, 0.43, 0.69, 1)
                love.graphics.line(art.x, by, art.x + art.w, by)
                for col = -1, math.ceil(art.w / brick_w) do
                    local bx = art.x + offset + col * brick_w
                    love.graphics.line(bx, by, bx, math.min(art.y + art.h, by + brick_h))
                    setc(0.35, 0.70, 0.88, 0.22)
                    rect("fill", bx + 3, by + 3, brick_w - 7, math.max(2, brick_h - 7))
                    setc(0.12, 0.43, 0.69, 1)
                end
            end
            setc(0.90, 0.96, 1, 0.92)
            for _, cloud in ipairs({
                {0.56,0.15,0.08,0.10},{0.61,0.10,0.09,0.13},{0.66,0.15,0.10,0.08},
                {0.67,0.33,0.08,0.08},{0.72,0.30,0.06,0.10}
            }) do
                love.graphics.rectangle("fill", art.x + art.w*cloud[1], art.y + art.h*cloud[2], art.w*cloud[3], art.h*cloud[4])
            end
            setc(0.005, 0.008, 0.018, 1)
            rect("fill", art.x + art.w*0.82, art.y, art.w*0.18, art.h)
            for i = 0, 12 do
                local gy = art.y + art.h * (0.08 + i*0.067)
                local gw = art.w * ((i % 3 == 0) and 0.22 or ((i % 2 == 0) and 0.12 or 0.17))
                setc(i % 2 == 0 and 0.03 or 0.08, 0.06, i % 3 == 0 and 0.19 or 0.29, 1)
                rect("fill", art.x + art.w*0.77, gy, gw, math.max(3, sh*0.012))
                if i % 2 == 1 then
                    setc(0.08, 0.42, 0.68, 1)
                    rect("fill", art.x + art.w*0.84, gy + sh*0.014, art.w*0.13, math.max(2, sh*0.009))
                end
            end

            local shop_spam = spamton_get_shop_spam()
            if shop_spam then
                local iw, ih = shop_spam:getDimensions()
                if iw > 0 and ih > 0 then
                    local max_w, max_h = art.w * 0.53, art.h * 0.985
                    local sc = math.min(max_w / iw, max_h / ih)
                    local dw, dh = iw * sc, ih * sc
                    local dx = art.x + art.w * 0.37 - dw / 2
                    local dy = art.y + (art.h - dh) / 2
                    setc(1, 1, 1, 1)
                    love.graphics.draw(shop_spam, math.floor(dx), math.floor(dy), 0, sc, sc)
                end
            end
            draw_phone(art.x + art.w*0.79, art.y + art.h*0.015, art.w*0.19, art.h*0.96)
        end
        setc(1, 1, 1, 1)
        love.graphics.setLineWidth(math.max(2, 2*scale_ref))
        rect("line", art.x, art.y, art.w, art.h)
        love.graphics.setLineWidth(1)

        setc(0, 0, 0, 1)
        rect("fill", left.x, left.y, left.w, left.h)
        rect("fill", right.x, right.y, right.w, right.h)
        panel(left)
        panel(right)

        local body_font_size = math.max(22, math.floor(sh * 0.044))
        local menu_font_size = math.max(22, math.floor(sh * 0.043))
        local money_font_size = math.max(18, math.floor(sh * 0.034))
        love.graphics.setFont(spamton_get_font(body_font_size))
        setc(1, 1, 1, 1)

        local function print_wrapped(text, x, y, width, font, line_height, max_lines)
            local lines = spamton_wrap_text(tostring(text or ""), font, width)
            love.graphics.setFont(font)
            for i, line in ipairs(lines) do
                if not max_lines or i <= max_lines then
                    love.graphics.print(line, x, y + (i - 1) * line_height)
                end
            end
        end

        local function draw_money()
            love.graphics.setFont(spamton_get_font(money_font_size))
            setc(1, 1, 1, 1)
            love.graphics.printf(spamton_money() .. " KROMER", right.x + right.w * 0.04,
                layout.money_y, right.w * 0.92, "center")
        end

        if shop.mode == "main" then
            local dialogue = {
                "* HEY EVERY              !",
                "* IT'S ME, SPAMTON G.",
                "  SPAMTON!"
            }
            local dialogue_y = {
                left.y + left.h * 0.105,
                left.y + left.h * 0.285,
                left.y + left.h * 0.615
            }
            love.graphics.setFont(spamton_get_font(body_font_size))
            for i, line in ipairs(dialogue) do
                love.graphics.print(line, left.x + left.w * 0.045, dialogue_y[i])
            end

            love.graphics.setFont(spamton_get_font(menu_font_size))
            local labels = {"BUY", "BUYMORE!!!", "TALKING", "ESCAPE"}
            for i, label in ipairs(labels) do
                local box = layout.options[i]
                if shop.menu_selected == i then
                    heart_cursor(box.x + right.w * 0.13, box.y + box.h * 0.12, sh * 0.034)
                    setc(1, 1, 1, 1)
                else
                    setc(0.93, 0.93, 0.93, 1)
                end
                love.graphics.print(label, box.x + right.w * 0.29, box.y + box.h * 0.03)
            end
            draw_money()

        elseif shop.mode == "talkmenu" then
            local talk_labels = {"OUR DEAL", "FEAR", "EXIT AND BUY MORE!!!"}
            love.graphics.setFont(spamton_get_font(math.max(18, math.floor(sh * 0.035))))
            for i, label in ipairs(talk_labels) do
                local box = layout.talk_options[i]
                if shop.talk_selected == i then
                    heart_cursor(box.x + left.w * 0.025, box.y + box.h * 0.13, sh * 0.031)
                    setc(1, 1, 1, 1)
                else
                    setc(0.93, 0.93, 0.93, 1)
                end
                love.graphics.print(label, box.x + left.w * 0.09, box.y + box.h * 0.015)
            end

            local topic = SPAMTON_TALK_TOPICS[shop.talk_selected or 1]
            local hint = topic and topic.hint or "WHAT DO YOU WANT TO TALK ABOUT?"
            love.graphics.setFont(spamton_get_font(math.max(18, math.floor(sh * 0.032))))
            setc(1, 1, 1, 1)
            print_wrapped("* " .. hint, right.x + right.w * 0.08, right.y + right.h * 0.12,
                right.w * 0.82, spamton_get_font(math.max(18, math.floor(sh * 0.032))), sh * 0.048, 5)
            love.graphics.setFont(spamton_get_font(math.max(14, math.floor(sh * 0.025))))
            setc(0.85, 0.85, 0.85, 1)
            love.graphics.printf("UP / DOWN: SELECT   ENTER: TALK", right.x + right.w * 0.05,
                right.y + right.h * 0.66, right.w * 0.9, "center")
            draw_money()

        elseif shop.mode == "dialogue" then
            local box = layout.dialogue_panel
            setc(0, 0, 0, 1)
            rect("fill", box.x, box.y, box.w, box.h)
            panel(box)
            local pages = shop.dialogue_pages or {}
            local text = pages[shop.dialogue_page or 1] or ""
            local visible = math.max(0, math.min(#text, math.floor(shop.dialogue_progress or 0)))
            love.graphics.setFont(spamton_get_font(math.max(23, math.floor(sh * 0.044))))
            setc(1, 1, 1, 1)
            love.graphics.printf(text:sub(1, visible), box.x + box.w * 0.035,
                box.y + box.h * 0.12, box.w * 0.92, "left")
            love.graphics.setFont(spamton_get_font(math.max(13, math.floor(sh * 0.022))))
            setc(0.75, 0.75, 0.75, 1)
            love.graphics.printf("ENTER / CLICK TO CONTINUE", box.x + box.w * 0.02,
                box.y + box.h * 0.88, box.w * 0.96, "right")

        elseif shop.mode == "items" then
            local selected_entry = spamton_get_entry(shop.selected or 1)
            local selected_card = selected_entry and selected_entry.card or nil
            local labels = {}
            for i, card in ipairs(shop.cards) do
                labels[i] = spamton_get_name(card)
            end
            labels[#shop.cards + 1] = "RUN AWAY"

            love.graphics.setFont(spamton_get_font(math.max(18, math.floor(sh * 0.033))))
            for i, label in ipairs(labels) do
                local box = layout.items[i]
                if box then
                    if shop.selected == i then
                        heart_cursor(box.x + left.w * 0.012, box.y + box.h * 0.13, sh * 0.030)
                        setc(1, 1, 1, 1)
                    else
                        setc(0.84, 0.84, 0.84, 1)
                    end
                    local display_name = label
                    if #display_name > 21 then display_name = display_name:sub(1, 18) .. "..." end
                    love.graphics.print(display_name, box.x + left.w * 0.07, box.y + box.h * 0.02)
                    if i <= #shop.cards then
                        local price = math.max(1, math.floor(shop.cards[i].cost or 1))
                        love.graphics.printf(tostring(price) .. " KROMER", box.x + left.w * 0.55,
                            box.y + box.h * 0.02, left.w * 0.36, "right")
                    end
                end
            end

            local preview = layout.preview
            setc(0, 0, 0, 0.98)
            rect("fill", preview.x, preview.y, preview.w, preview.h)
            panel(preview)
            if selected_card then
                love.graphics.setFont(spamton_get_font(math.max(17, math.floor(sh * 0.030))))
                setc(1, 1, 1, 1)
                local selected_name = spamton_get_name(selected_card)
                print_wrapped(selected_name:upper(), preview.x + preview.w * 0.06,
                    preview.y + preview.h * 0.07, preview.w * 0.88,
                    spamton_get_font(math.max(17, math.floor(sh * 0.030))), sh * 0.045, 3)

                local sprite = spamton_get_preview_sprite(selected_card)
                if sprite and sprite.T then
                    local old = {x = sprite.T.x, y = sprite.T.y, w = sprite.T.w, h = sprite.T.h}
                    local old_vt
                    if sprite.VT then
                        old_vt = {x = sprite.VT.x, y = sprite.VT.y, w = sprite.VT.w, h = sprite.VT.h}
                    end
                    local aspect = (G.CARD_W and G.CARD_H and G.CARD_H > 0) and (G.CARD_W / G.CARD_H) or 0.74
                    local preview_h = math.min(preview.h * 0.52, preview.w * 0.50 / math.max(aspect, 0.1))
                    local preview_w = preview_h * aspect
                    sprite.T.x = preview.x + preview.w * 0.055
                    sprite.T.y = preview.y + preview.h * 0.30
                    sprite.T.w = preview_w
                    sprite.T.h = preview_h
                    if sprite.VT then
                        sprite.VT.x, sprite.VT.y = sprite.T.x, sprite.T.y
                        sprite.VT.w, sprite.VT.h = sprite.T.w, sprite.T.h
                    end
                    pcall(function() sprite:draw() end)
                    sprite.T.x, sprite.T.y, sprite.T.w, sprite.T.h = old.x, old.y, old.w, old.h
                    if sprite.VT and old_vt then
                        sprite.VT.x, sprite.VT.y = old_vt.x, old_vt.y
                        sprite.VT.w, sprite.VT.h = old_vt.w, old_vt.h
                    end
                end

                love.graphics.setFont(spamton_get_font(math.max(13, math.floor(sh * 0.022))))
                setc(0.9, 0.9, 0.9, 1)
                local rarity = selected_card.config and selected_card.config.center
                    and selected_card.config.center.rarity
                local detail = "LIMITED TIME DEAL"
                if rarity then detail = detail .. "\nRARITY: " .. tostring(rarity) end
                print_wrapped(detail, preview.x + preview.w * 0.52, preview.y + preview.h * 0.36,
                    preview.w * 0.42, spamton_get_font(math.max(13, math.floor(sh * 0.022))), sh * 0.035, 6)
            else
                love.graphics.setFont(spamton_get_font(math.max(21, math.floor(sh * 0.038))))
                setc(1, 1, 1, 1)
                love.graphics.printf("RUN AWAY", preview.x + 8, preview.y + preview.h * 0.40,
                    preview.w - 16, "center")
            end

            love.graphics.setFont(spamton_get_font(math.max(17, math.floor(sh * 0.030))))
            setc(1, 1, 1, 1)
            if selected_card then
                local description = spamton_get_description(selected_card)
                if #description > 150 then description = description:sub(1, 147) .. "..." end
                print_wrapped(description, right.x + right.w * 0.07, right.y + right.h * 0.09,
                    right.w * 0.86, spamton_get_font(math.max(17, math.floor(sh * 0.030))), sh * 0.043, 6)
                setc(0.90, 0.90, 0.90, 1)
                love.graphics.setFont(spamton_get_font(math.max(14, math.floor(sh * 0.024))))
                love.graphics.printf("DEALS SO GOOD I'LL [$$$] MYSELF!", right.x + right.w * 0.05,
                    right.y + right.h * 0.64, right.w * 0.90, "center")
            else
                love.graphics.printf("RUN AWAY?", right.x + right.w * 0.05, right.y + right.h * 0.20,
                    right.w * 0.90, "center")
            end
            if shop.status_message then
                setc(1, 0.25, 0.28, 1)
                love.graphics.setFont(spamton_get_font(math.max(13, math.floor(sh * 0.023))))
                love.graphics.printf(shop.status_message, right.x + right.w * 0.05,
                    right.y + right.h * 0.73, right.w * 0.90, "center")
            end
            draw_money()
        end

        love.graphics.setFont(old_font)
        love.graphics.setLineWidth(1)
        setc(1, 1, 1, 1)
        love.graphics.pop()
    end
    G.SPAMTON_SHOP.draw_hook_installed = true
end

SMODS.Joker{
    key = "Spamton",

    name = "spamton",

    atlas = "Jokers",

    pos = {
        x = 0,
        y = 0
    },

    loc_txt = {
        name = "spamton",

        text = {
            "Gain {X:mult,C:white}X2{} Mult",
            "if hand contains a {C:hearts}Heart{} shaped object",
            "Opens a new spamton shop"
        }
    },

    rarity = 1,

    cost = 4,

    calculate = function(
        self,
        card,
        context
    )
        if context.joker_main then
            local has_heart = false

            for _, playing_card in ipairs(
                context.scoring_hand or {}
            ) do
                if playing_card:is_suit(
                    "Hearts"
                ) then

                    has_heart = true
                    break
                end
            end

            if has_heart then
                return {
                    Xmult = 2
                }
            end
        end

        if context.ending_shop then
            if G.SPAMTON_SHOP then
                spamton_destroy_shop()
            end
        end
    end,

    update = function(
        self,
        card
    )
        if not card.children
        or not card.children.center then
            return
        end

        local eric_owned =
            fn_eric_owned()

        if eric_owned then
            if card.ability.spamton_eric_pos
            ~= true then

                card.children.center:
                    set_sprite_pos({
                        x = 4,
                        y = 1
                    })

                card.ability.spamton_eric_pos =
                    true

                if not (G.SPAMTON_SHOP and G.SPAMTON_SHOP.active) then
                    spamton_play_eric()
                end
            end
        else
            if card.ability.spamton_eric_pos
            == true then

                card.children.center:
                    set_sprite_pos({
                        x = 0,
                        y = 0
                    })

                card.ability.spamton_eric_pos =
                    false
            end
        end
    end
}
----------------------------------------------
------------Spamton Sweepstakes----------------
----------------------------------------------

G.SPAMTON_SWEEPSTAKES = G.SPAMTON_SWEEPSTAKES or {
    active = false,
    hooks_installed = false,
    draw_hook_installed = false,
    key_hook_installed = false,
    mouse_hook_installed = false,
    button_hook_installed = false,
    fonts = {},
}

local SWEEPSTAKES_PRICE = 150
local SWEEPSTAKES_MAX_GAMBLES = 3

local function spamton_sweepstakes_in_blind_select()
    return G and G.GAME and G.STATES
        and G.STATE == G.STATES.BLIND_SELECT
end

local function spamton_sweepstakes_button_rect(sw, sh)
    return sw * 0.035, sh * 0.315, sw * 0.22, sh * 0.062
end

local function spamton_sweepstakes_panel_rect(sw, sh)
    local x, y = sw * 0.15, sh * 0.10
    local w, h = sw * 0.70, sh * 0.80
    local close = {x = x + w - 58, y = y + 16, w = 40, h = 36}
    local buy_w = math.min(420, w * 0.54)
    local buy = {x = x + (w - buy_w) / 2, y = y + h * 0.68, w = buy_w, h = sh * 0.085}
    return {x = x, y = y, w = w, h = h, close = close, buy = buy}
end

local function spamton_sweepstakes_font(size)
    local state = G.SPAMTON_SWEEPSTAKES
    state.fonts = state.fonts or {}
    if not state.fonts[size] then
        state.fonts[size] = deltalatro_ui_font(size)
    end
    return state.fonts[size] or love.graphics.getFont()
end

local function spamton_sweepstakes_gambles()
    if not G.GAME then return 0 end
    G.GAME.spamton_sweepstakes_gambles =
        math.max(0, math.min(SWEEPSTAKES_MAX_GAMBLES,
            G.GAME.spamton_sweepstakes_gambles or 0))
    return G.GAME.spamton_sweepstakes_gambles
end

local function spamton_sweepstakes_can_open()
    return spamton_sweepstakes_in_blind_select()
        and spamton_sweepstakes_gambles() < SWEEPSTAKES_MAX_GAMBLES
end

local function spamton_sweepstakes_close()
    if G.SPAMTON_SWEEPSTAKES then
        G.SPAMTON_SWEEPSTAKES.active = false
    end
end

local function spamton_sweepstakes_pool_has_cards(set)
    local pool = G.P_CENTER_POOLS and G.P_CENTER_POOLS[set]
    return type(pool) == "table" and #pool > 0
end

local function spamton_sweepstakes_pick(list, seed)
    if type(list) ~= "table" or #list == 0 then return nil end
    if pseudorandom_element then
        return pseudorandom_element(list, pseudoseed(seed or "spamton_sweepstakes"))
    end
    return list[math.random(1, #list)]
end

local function spamton_sweepstakes_get_sets()
    local sets = {"Base"}

    if G.jokers and G.jokers.cards
    and #G.jokers.cards < (G.jokers.config.card_limit or 5)
    and spamton_sweepstakes_pool_has_cards("Joker") then
        sets[#sets + 1] = "Joker"
    end

    local consumables_have_room = G.consumeables
        and G.consumeables.cards
        and #G.consumeables.cards < (G.consumeables.config.card_limit or 2)

    if consumables_have_room then
        for _, set in ipairs({"Tarot", "Planet", "Spectral"}) do
            if spamton_sweepstakes_pool_has_cards(set) then
                sets[#sets + 1] = set
            end
        end
    end

    return sets
end

local function spamton_sweepstakes_random_edition(card)
    if not card or not card.set_edition or not poll_edition then return end
    local ok, edition = pcall(function()
        return poll_edition("spamton_sweepstakes", nil, true, true)
    end)
    if ok and type(edition) == "table" and next(edition) then
        pcall(function()
            card:set_edition(edition, true, true)
        end)
    end
end

local function spamton_sweepstakes_add_playing_card()
    if not G.P_CARDS or #G.P_CARDS == 0 then return nil end

    local front = spamton_sweepstakes_pick(G.P_CARDS, "spamton_sweepstakes_front")
    if not front then return nil end

    local card = create_playing_card({
        front = front,
        center = G.P_CENTERS.c_base
    }, G.hand or G.deck, nil, nil, {G.C.SECONDARY_SET.Enhanced})

    if not card then return nil end
    local target_area = G.hand or G.deck
    if target_area and card.area ~= target_area then
        target_area:emplace(card)
    end

    local enhancements = {}
    for _, center in ipairs((G.P_CENTER_POOLS and G.P_CENTER_POOLS.Enhanced) or {}) do
        if center and center.key and center.key ~= "c_base" then
            enhancements[#enhancements + 1] = center
        end
    end

    local enhancement = spamton_sweepstakes_pick(enhancements, "spamton_sweepstakes_enhancement")
    if enhancement and card.set_ability then
        pcall(function()
            card:set_ability(enhancement, nil, true)
        end)
    end

    local seal_keys = {}
    for key in pairs(G.P_SEALS or {}) do
        seal_keys[#seal_keys + 1] = key
    end
    local seal = spamton_sweepstakes_pick(seal_keys, "spamton_sweepstakes_seal")
    if seal and card.set_seal then
        pcall(function()
            card:set_seal(seal, true, true)
        end)
    end

    spamton_sweepstakes_random_edition(card)

    if card.start_materialize then
        card:start_materialize()
    end
    return card
end

local function spamton_sweepstakes_create_prize()
    local sets = spamton_sweepstakes_get_sets()
    local set = spamton_sweepstakes_pick(sets, "spamton_sweepstakes_type")
    if not set then return nil end

    if set == "Base" then
        return spamton_sweepstakes_add_playing_card(), "Base"
    end

    local area = set == "Joker" and G.jokers or G.consumeables
    if not area then return nil end

    local card = SMODS.create_card({
        set = set,
        key_append = "spamton_sweepstakes",
        allow_duplicates = true
    })
    if not card then return nil end

    if set == "Joker" then
        spamton_sweepstakes_random_edition(card)
    end

    if card.add_to_deck then
        card:add_to_deck()
    end
    area:emplace(card)
    if card.start_materialize then
        card:start_materialize()
    end
    return card, set
end

local function spamton_sweepstakes_buy()
    if not G.SPAMTON_SWEEPSTAKES.active
    or not spamton_sweepstakes_can_open() then
        return
    end

    local gambles = spamton_sweepstakes_gambles()
    if gambles >= SWEEPSTAKES_MAX_GAMBLES then
        return
    end

    if not G.GAME.dollars or to_big(G.GAME.dollars) < to_big(SWEEPSTAKES_PRICE) then
        return
    end

    local card, set = spamton_sweepstakes_create_prize()
    if not card then
        return
    end

    ease_dollars(-SWEEPSTAKES_PRICE)
    G.GAME.spamton_sweepstakes_gambles = gambles + 1

    if G.GAME.spamton_sweepstakes_gambles >= SWEEPSTAKES_MAX_GAMBLES then
        spamton_sweepstakes_close()
    end

    if card.juice_up then
        card:juice_up(0.5, 0.3)
    end


    G.SPAMTON_SWEEPSTAKES.last_prize =
        (set == "Base" and "A PLAYING CARD!!!")
        or (set == "Joker" and "A [BIG SHOT] JOKER!!!")
        or ("A MYSTERY " .. string.upper(tostring(set)) .. " CARD!!!")
end

G.FUNCS.spamton_sweepstakes_toggle = function()
    if not spamton_sweepstakes_can_open() then return end

    if G.SPAMTON_SWEEPSTAKES.active then
        spamton_sweepstakes_close()
    else
        G.SPAMTON_SWEEPSTAKES.active = true
        G.SPAMTON_SWEEPSTAKES.last_prize = nil
    end
end

G.SPAMTON_SWEEPSTAKES.button_hook_installed = true

if not G.SPAMTON_SWEEPSTAKES.key_hook_installed then
    local old_keypressed = love.keypressed
    love.keypressed = function(key, scancode, isrepeat)
        if G.SPAMTON_SWEEPSTAKES
        and G.SPAMTON_SWEEPSTAKES.active
        and G.GAME then
            if key == "return" or key == "kpenter" then
                spamton_sweepstakes_buy()
                return
            elseif key == "escape" or key == "backspace" then
                spamton_sweepstakes_close()
                return
            end
        end

        if old_keypressed then
            return old_keypressed(key, scancode, isrepeat)
        end
    end
    G.SPAMTON_SWEEPSTAKES.key_hook_installed = true
end

if not G.SPAMTON_SWEEPSTAKES.mouse_hook_installed then
    local old_mousepressed = love.mousepressed
    love.mousepressed = function(x, y, button, istouch, presses)
        if button == 1 and G.SPAMTON_SWEEPSTAKES and G.GAME then
            if G.SPAMTON_SWEEPSTAKES.active then
                if not spamton_sweepstakes_in_blind_select() then
                    spamton_sweepstakes_close()
                else
                    local sw, sh = love.graphics.getDimensions()
                    local panel = spamton_sweepstakes_panel_rect(sw, sh)
                    local close, buy = panel.close, panel.buy
                    if x >= close.x and x <= close.x + close.w
                    and y >= close.y and y <= close.y + close.h then
                        spamton_sweepstakes_close()
                    elseif x >= buy.x and x <= buy.x + buy.w
                    and y >= buy.y and y <= buy.y + buy.h then
                        spamton_sweepstakes_buy()
                    end
                    return
                end
            elseif spamton_sweepstakes_can_open() then
                local sw, sh = love.graphics.getDimensions()
                local bx, by, bw, bh = spamton_sweepstakes_button_rect(sw, sh)
                if x >= bx and x <= bx + bw
                and y >= by and y <= by + bh then
                    G.FUNCS.spamton_sweepstakes_toggle()
                    return
                end
            end
        end

        if old_mousepressed then
            return old_mousepressed(x, y, button, istouch, presses)
        end
    end
    G.SPAMTON_SWEEPSTAKES.mouse_hook_installed = true
end

G.SPAMTON_SWEEPSTAKES.draw_hook_installed = true

if not G.SPAMTON_SWEEPSTAKES.update_hook_installed then
    local old_update = Game.update
    function Game:update(dt)
        old_update(self, dt)
        if G.SPAMTON_SWEEPSTAKES and G.SPAMTON_SWEEPSTAKES.active then
            if not spamton_sweepstakes_in_blind_select()
            or spamton_sweepstakes_gambles() >= SWEEPSTAKES_MAX_GAMBLES then
                spamton_sweepstakes_close()
            end
        end
    end
    G.SPAMTON_SWEEPSTAKES.update_hook_installed = true
end

----------------------------------
-------MIKE CODE was killed ------
----------------------------------

G.CLOPEN_OVERLAY = {
    logo = nil,
    initialized = false,
    virtualW = 1280,
    virtualH = 720,
    w = 250, 
    h = 200,
    vx = 65,
    vy = 35
}

local old_update = love.update or function() end
function love.update(dt)
    old_update(dt)

    local c = G.CLOPEN_OVERLAY
    if not c.initialized then
        local path = SMODS.Mods["Deltalatro"].path .. "/assets/Clopen.png"
        if NFS.getInfo(path) then 
            local fileData = NFS.newFileData(path)
            if fileData then
                c.logo = love.graphics.newImage(love.image.newImageData(fileData))
                c.initialized = true
            end
        end
    end
end

local old_draw = love.draw or function() end
function love.draw()
    old_draw()

    if G.GAME and G.GAME.Clopen and G.STATE == G.STATES.SHOP then
        local c = G.CLOPEN_OVERLAY
        if c.logo then
            local realW, realH = love.graphics.getDimensions()
            local scaleX = realW / c.virtualW
            local scaleY = realH / c.virtualH
            love.graphics.push("all")
            local px, py = (c.vx - 18) * scaleX, (c.vy - 26) * scaleY
            local pw, ph = (c.w + 36) * scaleX, (c.h + 70) * scaleY
            dlt_c3_draw_panel(px, py, pw, ph, DLT_C3.glass_light)
            dlt_c3_draw_header(px, py, pw, 34 * scaleY, "CLOPEN")
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(
                c.logo,
                c.vx * scaleX,
                c.vy * scaleY,
                0,
                (c.w / c.logo:getWidth()) * scaleX,
                (c.h / c.logo:getHeight()) * scaleY
            )
            love.graphics.pop()
        end
    end
end

SMODS.Joker{
    key = 'Sans',
    loc_txt = {
        ['en-us'] = {
            name = "Sans",
            text = {
                "Shop can be Opened, Closed, or Clopen",
				"{C:inactive}Current State:{} {C:attention}#1#{}"
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 1, y = 0 },
    config = {
        extra = { shop = 'None' }
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.shop 
            }
        }
    end,

	update = function(self, card)
        if card.ability.extra.shop == 'Clopen' then
			G.GAME.Clopen = true
			if G.shop_jokers and G.shop_jokers.cards then
				for  _, j in ipairs(G.shop_jokers.cards) do
					j:start_dissolve()
				end
			end
			if G.shop_vouchers and G.shop_vouchers.cards then
				for  _, v in ipairs(G.shop_vouchers.cards) do
					v:start_dissolve()
				end
			end
			if G.shop_booster and G.shop_booster.cards then
				for  _, b in ipairs(G.shop_booster.cards) do
					b:start_dissolve()
				end
			end
		end
    end,
	
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then
            local shopstate = {
				'Opened', 'Closed', 'Clopen', 'Opened', 
			}
			card.ability.extra.shop = shopstate[math.random(1, #shopstate)]
			if card.ability.extra.shop == 'Closed' then
				G.GAME.Burger = (G.GAME.Burger or 0) + 1
			end
			if card.ability.extra.shop == 'Opened' then
				G.GAME.discount_percent = (G.GAME.discount_percent or 0) + 25
			end
        end
		
		if context.ending_shop or context.selling_self then
			G.GAME.discount_percent = 0
			G.GAME.Clopen = false
			if card.ability.extra.shop == 'Closed' then
				G.GAME.Burger = (G.GAME.Burger or 0) - 1
			end
		end
    end
}

---------------------------------------------------
----------------sans code end----------------------
---------------------------------------------------



---------------------------------------------------
---------------THE RORING KNIGHT START-------------
---------------------------------------------------

SMODS.Joker{
    key = "RoaringKnight",
    name = "Roaring Knight",

    loc_txt = {
        name = "Roaring Knight",
        text = {
            "He isn't the Radio Star,",
            "but he killed the Video Star",
            "Gains {X:mult,C:white}+0.5X{} Mult",
            "for each destroyed {C:attention}card{}",
            "{C:inactive}(Jokers and Consumables){}"
        }
    },

    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    atlas = "Jokers",
    pos = {x = 9, y = 0},

    in_pool = function(self)
        return true
    end,

    config = {
        extra = { xmult = 1 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult }
        }
    end,

    calculate = function(self, card, context)

        if context.joker_main then
            return {
                Xmult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and not context.repetition and not context.individual then
            
            local targets = {}

            if G.jokers then
                for _, j in ipairs(G.jokers.cards) do
                    table.insert(targets, j)
                end
            end

            if G.consumeables then
                for _, c in ipairs(G.consumeables.cards) do
                    table.insert(targets, c)
                end
            end

            if #targets > 0 then
                local target = pseudorandom_element(targets, pseudoseed('roaring_knight'))

                if target then
                    target:start_dissolve()
                    card.ability.extra.xmult = card.ability.extra.xmult + 0.5
                end
            end
        end
    end
}

---------------------------------------------------
---------------THE RORING KNIGHT CODE END----------
---------------------------------------------------

---------------------------------------------------
---------------ralsi CODE START--------------------
---------------------------------------------------

SMODS.Joker{
    key = "ralsei",

    atlas = "Jokers",
    pos = { x = 2, y = 0 },
    rarity = 4,
    cost = 8,
    blueprint_compat = true,

    loc_txt = {
        ['en-us'] = {
            name = "Ralsei",
            text = {
                "1 in 4 chance to gain",
                "{X:mult,C:white}X#1#{} Mult (2 - 15)"
            }
        }
    },

    config = {
        extra = {
            x_min = 2,
            x_max = 15,
            odds = 4
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.x_max
            }
        }
    end,

    calculate = function(self, card, context)

        if context.joker_main then

            if math.random(card.ability.extra.odds) == 1 then

                local xval = math.random(
                    card.ability.extra.x_min,
                    card.ability.extra.x_max
                )

                return {
                    x_mult = xval,
                    message = "..." ,
                    colour = G.C.PURPLE
                }
            end
        end
    end
}

---------------------------------------------------
---------------tenna CODE start -------------------
---------------------------------------------------

SMODS.Joker{
    key = "tenna",
    loc_txt = {
        name = "Tenna",
        text = {
            "Every Blind is a {C:attention}Boss Blind{}",
            "Gain {X:mult,C:white}X#1#{} Mult",
            "for every {C:attention}Boss Blind{} defeated",
            "{C:inactive}art by Vega{}",
        }
    },
    atlas = "Jokers",
    pos = { x = 0, y = 1 },

    config = {
        extra = {
            xmult = 1
        }
    },

    rarity = 3,
    cost = 8,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult
            }
        }
    end,

    update = function(self, card)
        card.anim_frame = card.anim_frame or 0
        card.anim_timer = card.anim_timer or 0
        card.last_render = card.last_render or G.TIMERS.REAL

        local fps = 9
        local max_frame = 5
        local now = G.TIMERS.REAL
        local delta = now - card.last_render
        card.last_render = now

        card.anim_timer = card.anim_timer + delta

        if card.anim_timer >= 1 / fps then
            card.anim_timer = 0
            card.anim_frame = (card.anim_frame + 1) % (max_frame + 1)

            if card.children and card.children.floating_sprite then
                card.children.floating_sprite:set_sprite_pos({
                    x = card.anim_frame,
                    y = 0
                })
            end
        end

        if G.GAME
        and G.GAME.blind
        and G.GAME.blind.boss == false then
            G.GAME.blind.boss = true
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        if not G.GAME or not G.GAME.round_resets then
            return
        end

        local blinds = {}

        if G.P_BLINDS then
            for key, blind in pairs(G.P_BLINDS) do
                if blind and blind.name then
                    blinds[#blinds + 1] = key
                end
            end
        end

        if #blinds > 0 then
            if G.GAME.round_resets.blind_choices.Small then
                G.GAME.round_resets.blind_choices.Small =
                    pseudorandom_element(blinds, pseudoseed("tenna_small"))
            end

            if G.GAME.round_resets.blind_choices.Big then
                G.GAME.round_resets.blind_choices.Big =
                    pseudorandom_element(blinds, pseudoseed("tenna_big"))
            end

            if G.GAME.round_resets.blind_choices.Boss then
                G.GAME.round_resets.blind_choices.Boss =
                    pseudorandom_element(blinds, pseudoseed("tenna_boss"))
            end
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                Xmult = card.ability.extra.xmult
            }
        end

        if context.end_of_round
        and not context.repetition
        and not context.individual
        and G.GAME.blind
        and G.GAME.blind.boss then

            card.ability.extra.xmult =
                card.ability.extra.xmult + 1

            return {
                message = "+1 XMult",
                colour = G.C.MULT
            }
        end

        if context.setting_blind then
            if G.GAME.blind then
                G.GAME.blind.boss = true
            end
        end
    end
}

if not _G.__TENNA_RESET_BLINDS_HOOK then
    _G.__TENNA_RESET_BLINDS_HOOK = true

    local tenna_original_reset_blinds = reset_blinds

    function reset_blinds()
        tenna_original_reset_blinds()

        if not G.GAME
        or not G.GAME.round_resets
        or not G.jokers
        or not G.jokers.cards then
            return
        end

        local tenna_owned = false

        for _, joker in ipairs(G.jokers.cards) do
            if joker.config
            and joker.config.center
            and joker.config.center.key == "j_delta_tenna" then
                tenna_owned = true
                break
            end
        end

        if not tenna_owned then
            return
        end

        local blinds = {}

        if G.P_BLINDS then
            for key, blind in pairs(G.P_BLINDS) do
                if blind and blind.name then
                    blinds[#blinds + 1] = key
                end
            end
        end

        if #blinds == 0 then
            return
        end

        local ante = G.GAME.round_resets.ante or 1

        if G.GAME.round_resets.blind_choices.Small then
            G.GAME.round_resets.blind_choices.Small =
                pseudorandom_element(
                    blinds,
                    pseudoseed("tenna_small_" .. ante)
                )
        end

        if G.GAME.round_resets.blind_choices.Big then
            G.GAME.round_resets.blind_choices.Big =
                pseudorandom_element(
                    blinds,
                    pseudoseed("tenna_big_" .. ante)
                )
        end

        if G.GAME.round_resets.blind_choices.Boss then
            G.GAME.round_resets.blind_choices.Boss =
                pseudorandom_element(
                    blinds,
                    pseudoseed("tenna_boss_" .. ante)
                )
        end
    end
end

---------------------------------------------------
---------------tv time CODE start -----------------
---------------------------------------------------
SMODS.Atlas({
    key = "Blinds",
    atlas_table = "ASSET_ATLAS",
    path = "Blinds.png",
    px = 16,
    py = 16
})

local upd = Game.update
function Game:update(dt)
    upd(self, dt)
    
    if G.GAME.DR_ForcedFail then
		if G.STATE ~= G.STATES.GAME_OVER and G.STATE ~= 2 and G.STATE ~= 1 then
			G.GAME.chips = (G.GAME.blind.chips * 0.50)
			if not G.GAME.DR_ForcedFailTriggered then
				G.GAME.DR_ForcedFailTriggered = true
				G.STATE = G.STATES.HAND_PLAYED
				G.STATE_COMPLETE = true
			end
		end
		
		if G.STATE == 1 then
			if not G.GAME.DR_ForcedFailTriggered then
				G.GAME.DR_ForcedFailTriggered = true
				G.GAME.chips = (G.GAME.blind.chips * 0.50)
				G.STATE = G.STATES.HAND_PLAYED
				G.STATE_COMPLETE = true
				end_round()
			end
		end
    end
end

SMODS.Blind{
    key = "tennatime",
    atlas = "Blinds", 
    pos = {x = 0, y = 0},
    boss = { min = 1, max = 10, hardcore = true },
    boss_colour = HEX("ff0040"),

    name = "Tenna's TV Time",
	loc_txt = {
        name = 'Tenna\'s TV Time',
		text = { "ONE MORE GAME KRIS!", "2 wrong answers = DEATH" }
    },
    dollars = 8,
    mult = 2,


    calculate = function(self, card, context)
		if context.first_hand_drawn and not G.GAME.blind.disabled then
			G.FUNCS.start_quiz_game()
		end
    end,
}

G.QUIZ_GAME = {
    active = false,
    input_locked = false, 
    timer = 0,            
    delay_between = 7,
    virtualW = 1280,
    virtualH = 720,
    questions = {
        {q = "What joker do you see when opening the game?", a = 1,  a = 4, choices = {"joker", "sans", "Blueglow", "EricTheToon"}},
        {q = "Whos groovy and never glooby?", a = 3, choices = {"the mimic", "the kight", "tenna", "EricTheToon"}},
        {q = "Mike can we bring some waters for the kids?", a = 2, a = 1, a = 3, a = 4, choices = {"No", "No", "No", "No"}},
        {q = "What time is it?", a = 3, choices = {"6:30", "12:00 AM", "TV TIME!!!", "muffen time"}},
        {q = "Who made balatro?", a = 2, choices = {"EricTheToon", "LocalThunk", "stephylicious", "JIMBO,"}},
        {q = "How many jokers are in normal balatro?", a = 4, choices = {"3", "156", "1987", "150"}},
        {q = "Who is that [[clown around town]]?", a = 1, a = 4, choices = {"Jevil", "cancer", "ned", "jimbo"}},
        {q = "Who is that funny skellington thats here on late nights?", a = 1, a = 2, choices = {"sans", "papyrus", "jack skellington", "skull troper"}},
        {q = "what type of pasta is ready?", a = 2, choices = {"cheezy", "creapy", "crac", "yummy"}},

    },
    current_q = nil,
    wrong_count = 0,
    font = nil
}

G.FUNCS = G.FUNCS or {}
G.FUNCS.start_quiz_game = function()
    local qz = G.QUIZ_GAME
    qz.active = true
    qz.wrong_count = 0
    qz.timer = 1 
    qz.font = deltalatro_ui_font(32)
    qz.current_q = nil
    qz.input_locked = false
end

function answer_quiz(index)
    local qz = G.QUIZ_GAME
    if not qz.current_q then return end

    if index == qz.current_q.a then
    else
        qz.wrong_count = qz.wrong_count + 1
    end

    qz.current_q = nil
    qz.input_locked = false
    qz.timer = qz.delay_between

    if qz.wrong_count >= 2 then
        qz.active = false
        G.GAME.DR_ForcedFail = true
    end
end


local old_mouse = love.mousepressed
function love.mousepressed(x, y, button)
    if G.QUIZ_GAME.active and G.QUIZ_GAME.current_q and G.QUIZ_GAME.input_locked then 
        return 
    end
    if old_mouse then old_mouse(x, y, button) end
end

local old_keypressed = love.keypressed
function love.keypressed(key)
    if old_keypressed then old_keypressed(key) end
    local qz = G.QUIZ_GAME
    if qz.active and qz.current_q then
        if key == "1" then answer_quiz(1) end
        if key == "2" then answer_quiz(2) end
        if key == "3" then answer_quiz(3) end
        if key == "4" then answer_quiz(4) end
    end
end

local old_upd = Game.update
function Game:update(dt)
    if old_upd then old_upd(self, dt) end
    local qz = G.QUIZ_GAME

    if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.key == "bl_tenna_show" then
        if not qz.active then
            if pseudorandom('tenna_q') < 0.001 then 
                G.FUNCS.start_quiz_game()
            end
        end
    end

    if qz.active and not qz.current_q then
        qz.timer = qz.timer - dt
        if qz.timer <= 0 then
            qz.current_q = qz.questions[math.random(#qz.questions)]
            qz.input_locked = true
        end
    end
end

local old_draw = love.draw
function love.draw()
    if old_draw then old_draw() end

    local qz = G.QUIZ_GAME
    if not qz.active then return end

    love.graphics.push("all")
    local realW, realH = love.graphics.getDimensions()
    love.graphics.scale(realW / qz.virtualW, realH / qz.virtualH)

    if qz.current_q then
        dlt_c3_draw_backdrop(qz.virtualW, qz.virtualH)
        dlt_c3_draw_panel(80, 86, 1120, 565, DLT_C3.glass_light)
        dlt_c3_draw_header(94, 100, 1092, 72, "TENNA'S TV TIME")

        love.graphics.setFont(deltalatro_ui_font(26))
        dlt_c3_color(DLT_C3.ink)
        love.graphics.printf(tostring(qz.current_q.q or ""), 145, 194, 990, "center")

        for i, choice in ipairs(qz.current_q.choices or {}) do
            local y = 274 + ((i - 1) * 78)
            local fill = (i % 2 == 0) and DLT_C3.peach_light or DLT_C3.mint_light
            dlt_c3_draw_panel(160, y, 960, 58, fill)
            dlt_c3_color(DLT_C3.pink)
            love.graphics.setFont(deltalatro_ui_font(19))
            love.graphics.printf("[" .. tostring(i) .. "]", 178, y + 16, 58, "left")
            dlt_c3_color(DLT_C3.ink)
            love.graphics.printf(tostring(choice), 245, y + 16, 850, "left")
        end

        dlt_c3_draw_panel(390, 612, 500, 40, DLT_C3.cream)
        love.graphics.setFont(deltalatro_ui_font(17))
        dlt_c3_color(DLT_C3.ink)
        love.graphics.printf("CHOOSE WITH KEYS 1 - 4", 405, 621, 470, "center")
    end

    dlt_c3_draw_panel(28, 28, 250, 52, DLT_C3.peach_light)
    love.graphics.setFont(deltalatro_ui_font(22))
    dlt_c3_color(DLT_C3.ink)
    love.graphics.printf("STRIKES: " .. tostring(qz.wrong_count) .. " / 2", 38, 42, 230, "center")

    love.graphics.pop()
end

local end_round_original = end_round
function end_round()
    end_round_original()
	G.QUIZ_GAME.active = false
end
---------------------------------------------------
-------------------yellow -------------------------
---------------------------------------------------

G.YELLOW_PROMPT = {
    active = false,
    card = nil,
    hands = {},
    scroll_y = 0,
    virtualW = 1280,
    virtualH = 720,
    font = nil,
    small_font = nil,
    play_event = nil,
    original_play = nil
}

local DLT_FLOWER_UI = {
    sky = {0.79, 0.91, 0.73, 1},
    sky_light = {0.91, 0.96, 0.76, 1},
    grass = {0.36, 0.62, 0.31, 1},
    grass_dark = {0.19, 0.39, 0.20, 1},
    grass_light = {0.58, 0.76, 0.38, 1},
    leaf = {0.24, 0.49, 0.26, 1},
    cream = {1.00, 0.96, 0.76, 1},
    cream_light = {1.00, 0.99, 0.87, 1},
    pink = {0.96, 0.54, 0.69, 1},
    pink_light = {1.00, 0.73, 0.79, 1},
    gold = {0.98, 0.78, 0.29, 1},
    orange = {0.91, 0.49, 0.24, 1},
    purple = {0.56, 0.40, 0.64, 1},
    ink = {0.14, 0.29, 0.16, 1},
    shadow = {0.10, 0.24, 0.12, 0.55},
}

local function yellow_ui_color(color, alpha)
    love.graphics.setColor(color[1], color[2], color[3], alpha or color[4] or 1)
end

local function yellow_ui_flower(x, y, radius, petal_color, center_color)
    local lg = love.graphics
    for petal = 0, 5 do
        local angle = petal * math.pi / 3
        yellow_ui_color(petal_color)
        lg.ellipse('fill', x + math.cos(angle) * radius * 0.72,
            y + math.sin(angle) * radius * 0.72, radius * 0.42, radius * 0.32)
    end
    yellow_ui_color(center_color or DLT_FLOWER_UI.gold)
    lg.ellipse('fill', x, y, radius * 0.33, radius * 0.33)
end

local function yellow_ui_draw_backdrop(w, h)
    local lg = love.graphics
    yellow_ui_color(DLT_FLOWER_UI.sky)
    lg.rectangle('fill', 0, 0, w, h)

    yellow_ui_color(DLT_FLOWER_UI.sky_light, 0.75)
    lg.rectangle('fill', 0, 0, w, h * 0.28)
    yellow_ui_color(DLT_FLOWER_UI.grass_light)
    lg.polygon('fill', 0, h * 0.29, w * 0.30, h * 0.20, w * 0.58, h * 0.31,
        w * 0.82, h * 0.23, w, h * 0.30, w, h, 0, h)
    yellow_ui_color(DLT_FLOWER_UI.grass)
    lg.rectangle('fill', 0, h * 0.58, w, h * 0.42)
    yellow_ui_color(DLT_FLOWER_UI.grass_dark, 0.40)
    for stripe = 0, 8 do
        lg.rectangle('fill', 0, h * 0.60 + stripe * 18, w, 2)
    end

    for i = 0, 12 do
        local x = (i * 101 + 28) % w
        local y = h * 0.17 + (i % 4) * 27
        yellow_ui_color(DLT_FLOWER_UI.leaf)
        lg.setLineWidth(3)
        lg.line(x, y + 18, x + ((i % 2 == 0) and 5 or -5), y + 50)
        lg.ellipse('fill', x - 8, y + 29, 8, 4)
        lg.ellipse('fill', x + 7, y + 38, 8, 4)
        yellow_ui_flower(x, y, 10 + (i % 3) * 2,
            i % 3 == 0 and DLT_FLOWER_UI.pink or (i % 3 == 1 and DLT_FLOWER_UI.cream or DLT_FLOWER_UI.purple),
            DLT_FLOWER_UI.gold)
    end
    for i = 0, 9 do
        local x = (i * 137 + 52) % w
        local y = h * 0.79 + (i % 3) * 30
        yellow_ui_color(DLT_FLOWER_UI.grass_dark)
        lg.line(x, y + 20, x, y + 38)
        yellow_ui_flower(x, y, 9 + (i % 2) * 2,
            i % 2 == 0 and DLT_FLOWER_UI.cream or DLT_FLOWER_UI.pink_light,
            DLT_FLOWER_UI.gold)
    end
    lg.setLineWidth(1)
    yellow_ui_color(DLT_FLOWER_UI.grass_dark, 0.18)
    lg.rectangle('fill', 0, 0, w, h)
end

local function yellow_ui_draw_panel(x, y, w, h, fill)
    local lg = love.graphics
    yellow_ui_color(DLT_FLOWER_UI.shadow)
    lg.rectangle('fill', x + 6, y + 7, w, h)
    yellow_ui_color(DLT_FLOWER_UI.grass_dark)
    lg.rectangle('fill', x - 3, y - 3, w + 6, h + 6)
    yellow_ui_color(fill or DLT_FLOWER_UI.cream)
    lg.rectangle('fill', x, y, w, h)
    yellow_ui_color(DLT_FLOWER_UI.gold)
    lg.setLineWidth(3)
    lg.rectangle('line', x + 4, y + 4, w - 8, h - 8)
    yellow_ui_color(DLT_FLOWER_UI.cream_light, 0.9)
    lg.setLineWidth(1)
    lg.rectangle('line', x + 8, y + 8, w - 16, h - 16)
end

local function yellow_ui_draw_button(x, y, w, h, label, selected, fill)
    local lg = love.graphics
    local base = fill or DLT_FLOWER_UI.cream_light
    if selected then base = DLT_FLOWER_UI.pink_light end
    yellow_ui_draw_panel(x, y, w, h, base)
    if selected then
        yellow_ui_color(DLT_FLOWER_UI.pink)
        lg.rectangle('fill', x + 8, y + 8, 9, h - 16)
    else
        yellow_ui_flower(x + 23, y + h / 2, 9, DLT_FLOWER_UI.pink, DLT_FLOWER_UI.gold)
    end
    lg.setFont(deltalatro_ui_font(math.max(14, math.floor(h * 0.28))))
    yellow_ui_color(DLT_FLOWER_UI.ink)
    lg.printf(label, x + 34, y + (h - lg.getFont():getHeight()) / 2, w - 48, 'center')
end

local function yellow_get_hands()
    local hands = {}
    if G and G.GAME and G.GAME.hands then
        for hand_name, hand_data in pairs(G.GAME.hands) do
            if hand_data then hands[#hands + 1] = hand_name end
        end
    end
    table.sort(hands, function(a, b) return tostring(a) < tostring(b) end)
    return hands
end

local function yellow_hand_name(hand)
    if G and G.localization and G.localization.misc
    and G.localization.misc.poker_hands and G.localization.misc.poker_hands[hand] then
        return tostring(G.localization.misc.poker_hands[hand])
    end
    return tostring(hand)
end

local function yellow_box_for_index(i)
    local cols = 3
    local box_w, box_h = 360, 70
    local pad_x, pad_y = 30, 20
    local start_x, start_y = 60, 150
    local col = (i - 1) % cols
    local row = math.floor((i - 1) / cols)
    return {
        x = start_x + col * (box_w + pad_x),
        y = start_y + row * (box_h + pad_y) - (G.YELLOW_PROMPT.scroll_y or 0),
        w = box_w,
        h = box_h
    }
end

local function yellow_point_in_box(px, py, box)
    return px >= box.x and px <= box.x + box.w
        and py >= box.y and py <= box.y + box.h
end

G.FUNCS = G.FUNCS or {}

G.FUNCS.start_yellow_prompt = function(e)
    local y = G.YELLOW_PROMPT

    if y.active then
        return
    end

    local yellow_cards = find_joker("Yellow")

    if not yellow_cards then
        return
    end

    local yellow_card = yellow_cards

    if type(yellow_cards) == "table" and yellow_cards[1] then
        yellow_card = yellow_cards[1]
    end

    if not yellow_card then
        return
    end

    if not yellow_card.ability
        or not yellow_card.ability.extra then

        return
    end

    if yellow_card.ability.extra.chosen_hand then
        return
    end

    y.font = y.font or deltalatro_ui_font(24)
    y.small_font = y.small_font or deltalatro_ui_font(18)

    y.card = yellow_card
    y.hands = yellow_get_hands()
    y.scroll_y = 0
    y.play_event = e
    y.active = true
end

local function yellow_select(hand)
    local y = G.YELLOW_PROMPT

    if not y.card
        or not y.card.ability
        or not y.card.ability.extra then

        return
    end

    local convinced = pseudorandom and pseudorandom('yellow_convinces_hand') < 0.9
    if not pseudorandom then
        convinced = math.random(1, 10) ~= 1
    end
    y.card.ability.extra.chosen_hand = convinced and hand or 'High Card'
    y.card.ability.extra.last_requested_hand = hand
    y.card.ability.extra.last_convinced = not not convinced

    local play_event = y.play_event
    local original_play = y.original_play

    y.active = false
    y.card = nil
    y.hands = {}
    y.play_event = nil

    if play_event and original_play then
        original_play(play_event)
    end
end

local old_yellow_mousepressed = love.mousepressed

function love.mousepressed(x, y, button)

    local prompt = G.YELLOW_PROMPT

    if prompt.active then

        if button ~= 1 then
            return
        end

        local realW, realH = love.graphics.getDimensions()

        local vx = x / (realW / prompt.virtualW)
        local vy = y / (realH / prompt.virtualH)

        local close_box = {
            x = prompt.virtualW - 94,
            y = 34,
            w = 44,
            h = 40
        }

        if yellow_point_in_box(vx, vy, close_box) then

            prompt.active = false
            prompt.card = nil
            prompt.hands = {}
            prompt.play_event = nil

            return
        end

        if vx < 48 or vx > 1220 or vy < 142 or vy > 614 then return end
        for i, hand in ipairs(prompt.hands) do
            local box = yellow_box_for_index(i)
            if box.y >= 142 and box.y + box.h <= 614
            and yellow_point_in_box(vx, vy, box) then
                yellow_select(hand)
                return
            end
        end

        return
    end

    if old_yellow_mousepressed then
        old_yellow_mousepressed(x, y, button)
    end
end

local old_yellow_draw = love.draw

function love.draw()
    if old_yellow_draw then old_yellow_draw() end

    local prompt = G.YELLOW_PROMPT
    if not prompt or not prompt.active then return end

    love.graphics.push('all')
    local realW, realH = love.graphics.getDimensions()
    love.graphics.scale(realW / prompt.virtualW, realH / prompt.virtualH)

    yellow_ui_draw_backdrop(prompt.virtualW, prompt.virtualH)
    yellow_ui_draw_panel(28, 22, 1212, 664, DLT_FLOWER_UI.cream)

    yellow_ui_color(DLT_FLOWER_UI.grass_dark)
    love.graphics.rectangle('fill', 42, 36, 1184, 76)
    yellow_ui_color(DLT_FLOWER_UI.grass)
    love.graphics.rectangle('fill', 48, 42, 1172, 64)
    yellow_ui_color(DLT_FLOWER_UI.gold)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line', 48, 42, 1172, 64)
    yellow_ui_flower(82, 74, 17, DLT_FLOWER_UI.pink_light, DLT_FLOWER_UI.gold)
    yellow_ui_flower(1185, 74, 17, DLT_FLOWER_UI.cream_light, DLT_FLOWER_UI.gold)
    love.graphics.setFont(deltalatro_ui_font(31))
    yellow_ui_color(DLT_FLOWER_UI.cream_light)
    love.graphics.printf('CONVINCE YELLOW', 190, 54, 900, 'center')

    yellow_ui_draw_panel(prompt.virtualW - 94, 34, 44, 40, DLT_FLOWER_UI.pink_light)
    love.graphics.setFont(deltalatro_ui_font(22))
    yellow_ui_color(DLT_FLOWER_UI.ink)
    love.graphics.printf('X', prompt.virtualW - 94, 39, 44, 'center')

    love.graphics.setFont(deltalatro_ui_font(16))
    yellow_ui_color(DLT_FLOWER_UI.ink)
    love.graphics.printf('CHOOSE A HAND TO TRY TO CONVINCE HIM OF...', 82, 116, 1110, 'center')
    love.graphics.setFont(deltalatro_ui_font(13))
    yellow_ui_color(DLT_FLOWER_UI.grass_dark)
    love.graphics.printf('9 IN 10: PLAY YOUR PICKED HAND  •  1 IN 10: HIGH CARD', 82, 132, 1110, 'center')

    if #prompt.hands == 0 then
        love.graphics.setFont(deltalatro_ui_font(24))
        yellow_ui_color(DLT_FLOWER_UI.ink)
        love.graphics.printf('NO HANDS FOUND', 0, 300, prompt.virtualW, 'center')
    else
        local mouse_x, mouse_y = love.mouse.getPosition()
        local vx = mouse_x / (realW / prompt.virtualW)
        local vy = mouse_y / (realH / prompt.virtualH)
        local visible_rows = 5
        for i, hand in ipairs(prompt.hands) do
            local box = yellow_box_for_index(i)
            if box.y >= 142 and box.y + box.h <= 614 then
                local hovered = yellow_point_in_box(vx, vy, box)
                local fill = (i % 3 == 0) and DLT_FLOWER_UI.pink_light
                    or ((i % 2 == 0) and DLT_FLOWER_UI.sky_light or DLT_FLOWER_UI.cream_light)
                yellow_ui_draw_button(box.x, box.y, box.w, box.h,
                    '#' .. tostring(i) .. '   ' .. yellow_hand_name(hand), hovered, fill)
            end
        end
        local rows = math.ceil(#prompt.hands / 3)
        if rows > visible_rows then
            local track_x, track_y, track_h = 1218, 150, 462
            yellow_ui_color(DLT_FLOWER_UI.grass_dark)
            love.graphics.rectangle('fill', track_x, track_y, 8, track_h)
            local thumb_h = math.max(36, track_h * visible_rows / rows)
            local max_scroll = math.max(1, (rows - visible_rows) * 90)
            local thumb_y = track_y + (track_h - thumb_h) * (prompt.scroll_y or 0) / max_scroll
            yellow_ui_color(DLT_FLOWER_UI.pink)
            love.graphics.rectangle('fill', track_x, thumb_y, 8, thumb_h)
            yellow_ui_color(DLT_FLOWER_UI.gold)
            love.graphics.rectangle('line', track_x - 1, thumb_y, 10, thumb_h)
            yellow_ui_flower(track_x + 4, thumb_y + thumb_h / 2, 5,
                DLT_FLOWER_UI.cream_light, DLT_FLOWER_UI.gold)
        end
    end

    yellow_ui_draw_panel(190, 636, 900, 44, DLT_FLOWER_UI.sky_light)
    love.graphics.setFont(deltalatro_ui_font(15))
    yellow_ui_color(DLT_FLOWER_UI.ink)
    love.graphics.printf(#prompt.hands > 15 and 'SCROLL THROUGH THE HAND TYPES  •  CLICK A HAND TO CONFIRM'
        or 'CLICK A HAND TO TRY TO CONVINCE YELLOW', 205, 649, 870, 'center')
    love.graphics.pop()
end

local yellow_play_hooked = false

local function yellow_install_play_hook()

    if yellow_play_hooked then
        return
    end

    if not G
        or not G.FUNCS
        or not G.FUNCS.play_cards_from_highlighted then

        return
    end

    local old_play = G.FUNCS.play_cards_from_highlighted

    G.YELLOW_PROMPT.original_play = old_play

    G.FUNCS.play_cards_from_highlighted = function(e)

        if G.YELLOW_PROMPT.active then
            return
        end

        local yellow_cards = find_joker("Yellow")

        if yellow_cards then

            local yellow_card = yellow_cards

            if type(yellow_cards) == "table" and yellow_cards[1] then
                yellow_card = yellow_cards[1]
            end

            if yellow_card
                and yellow_card.ability
                and yellow_card.ability.extra
                and not yellow_card.ability.extra.chosen_hand then

                G.FUNCS.start_yellow_prompt(e)

                return
            end
        end

        return old_play(e)
    end

    yellow_play_hooked = true
end

local yellow_joker_registered = false

SMODS.Joker{
    key = "yellow",
    name = "Yellow",

    atlas = "flowers",
    pos = { x = 0, y = 5 },
    soul_pos = { x = 1, y = 5 },
    
    rarity = 3,
    cost = 10,

    pool = "flowers",

    blueprint_compat = false,

    config = {
        extra = {
            chosen_hand = nil
        }
    },

    loc_txt = {
        name = "Yellow",
        text = {
            "Before playing a hand, choose which poker hand Yellow should play",
            "{C:green}9 in 10{} chance to play your chosen hand",
            "{C:green}1 in 10{} chance to force {C:attention}High Card{} instead"
        }
    },

    calculate = function(self, card, context)

        if context.evaluate_poker_hand
            and card.ability
            and card.ability.extra
            and card.ability.extra.chosen_hand then

            local forced_hand =
                card.ability.extra.chosen_hand

            if G
                and G.GAME
                and G.GAME.hands
                and G.GAME.hands[forced_hand] then

                card.ability.extra.chosen_hand = nil

                return {
                    replace_scoring_name = forced_hand,
                    replace_display_name = forced_hand
                }
            end
        end

        return nil
    end
}

yellow_joker_registered = true

local old_yellow_game_update = Game.update

function Game:update(dt)

    old_yellow_game_update(self, dt)

    if not yellow_play_hooked then
        yellow_install_play_hook()
    end
end

yellow_install_play_hook()




---------------------------------------------------
-------------------jackenstein code start----------
---------------------------------------------------

SMODS.Sound({
    key = "jackenstein_long",
    path = "jackenstein_long.ogg",
})

SMODS.Joker({
    key = "jackenstein",
    atlas = "jackenstein",
    pos = { x = 0, y = 0 },

    loc_txt = {
        name = "Jackenstein",
        text = {
            "Takes up {C:attention}2{} Joker slots",
            "Play a hand within {C:attention}21{} seconds",
            "Gain {X:chips,C:white}X#1#{} Chips",
            "based on time remaining"
        }
    },

    rarity = 4,
    cost = 15,
    blueprint_compat = false,

    config = {
        extra = {
            time_limit = 21,
            warning_time = 10,
            hand_start_time = nil,
            warned = false
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.time_limit
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - 1
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
    end,

    update = function(self, card)
        if card.T and card.T.w and card.T.w < G.CARD_W * 1.9 then
            card.T.w = G.CARD_W * 2
        end
    end,

    calculate = function(self, card, context)
        if context.hand_drawn then
            card.ability.extra.hand_start_time = love.timer.getTime()
            card.ability.extra.warned = false
        end

        if card.ability.extra.hand_start_time then
            local elapsed = love.timer.getTime() - card.ability.extra.hand_start_time
            local remaining = card.ability.extra.time_limit - elapsed

            if remaining <= card.ability.extra.warning_time
            and not card.ability.extra.warned
            and remaining > 0 then
                card.ability.extra.warned = true
                play_sound("delta_jackenstein_long")
            end
        end

        if context.joker_main and card.ability.extra.hand_start_time then
            local elapsed = love.timer.getTime() - card.ability.extra.hand_start_time
            local remaining = math.max(
                0,
                card.ability.extra.time_limit - elapsed
            )

            card.ability.extra.hand_start_time = nil

            if remaining > 0 then
                remaining = math.floor(remaining)

                return {
                    x_chips = remaining,
                    card = card
                }
            end
        end
    end,

    draw = function(self, card)
        if card.ability.extra.hand_start_time then
            local elapsed = love.timer.getTime() - card.ability.extra.hand_start_time
            local remaining = math.max(
                0,
                card.ability.extra.time_limit - elapsed
            )

            love.graphics.push()

            love.graphics.setColor(0, 0, 0, 0.75)

            love.graphics.rectangle(
                "fill",
                10,
                10,
                65,
                28,
                5,
                5
            )

            if remaining <= card.ability.extra.warning_time then
                love.graphics.setColor(1, 0, 0, 1)
            else
                love.graphics.setColor(1, 1, 1, 1)
            end

            love.graphics.print(
                string.format("%.1f", remaining),
                18,
                14
            )

            love.graphics.pop()
        end
    end
})

---------------------------------------------------
----------------lancer code start------------------
---------------------------------------------------

SMODS.Joker {
    key = 'lancer',
    loc_txt = {
        name = 'Lancer',
        text = {
            "Retriggers played {C:attention}Spades{}",
            "and {C:attention}Jacks{}",
            "credit to oxanis"
        }
    },

    rarity = 2,
    atlas = 'Jokers',
    pos = { x = 8, y = 1 },
    cost = 6,
    unlocked = true,
    blueprint_compat = true,
    perishable_compat = true,
    config = { extra = { repetitions = 1 } },
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card:get_id() == 11 then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
        if context.repetition and context.cardarea == G.play and context.other_card:is_suit("Spades") then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end
}

--------------------------------------------------
-----------------lacer code end-------------------
--------------------------------------------------

SMODS.Rarity{
    key = "weird",
    loc_txt = {
        name = "weird"
    },
    default_weight = 0,
    badge_colour = HEX("70B0FF"),
}
    
SMODS.Joker {
    key = 'snowgrave',
    loc_txt = {
        name = 'Snowgrave',
        text = {
            "{C:blue}+#1#{} chips.",
            "{C:red}All cards debuffed.{}"
        }
    },

    rarity = 'delta_weird',
    atlas = 'Jokers',
    pos = { x = 9, y = 1},
    cost = 16,
    unlocked = true,
    blueprint_compat = true,
    perishable_compat = true,
    config = { extra = { chips = 2500 },},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.chips}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
        if context.debuff_card and context.debuff_card.area ~= G.jokers then
            return {
                debuff = true
            }
        end
    end
}

---------------------------------------------------
-------------------------king start----------------
---------------------------------------------------

SMODS.Joker {
    key = 'king',
    loc_txt = {
        name = 'King',
        text = {
            "destroys {C:green}#1# in #2#{}",
            "cards held in hand",
        }
    },

    rarity = 3,
    atlas = 'Jokers',
    pos = { x = 3, y = 2 },
    cost = 12,
    unlocked = true,
    blueprint_compat = true,
    perishable_compat = true,
    config = { extra = { odds = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.hand and not context.end_of_round and pseudorandom(pseudoseed('seed')) < G.GAME.probabilities.normal / card.ability.extra.odds then
            return {
                remove = true
            }
        end
    end
}

---------------------------------------------------
--------------------egg start----------------------
---------------------------------------------------

SMODS.ConsumableType {
    key = 'weirdConsumable',
    default = 'degg',
    collection_rows = { 4, 5 },
    primary_colour = HEX("70B0FF"),
	secondary_colour = HEX("70B0FF"),
    loc_txt = { name = '???', collection = 'weird consumables' },
}

SMODS.Consumable{
    key = 'degg',
    atlas = 'Jokers',
    pos = { x = 6, y = 2},
    set = 'weirdConsumable',
    loc_txt = {
        name = 'egg',
        text = {
            "* not too important,",
            "{C:attention}not too unimportant.{}",
        }
    },
    use = function(self, card, area, copier)
        delay(0.6)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                SMODS.add_card({ set = 'Joker', rarity = 'delta_weird' })
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}
--------------------------------------------------
------------------egg code start------------------
--------------------------------------------------


SMODS.Joker {
    key = 'roaring',
    loc_txt = {
        name = 'The Roaring',
        text = {
            "Played {C:attention}stone{} cards give",
            "{C:blue}+#2#{} chips, {C:red}+#3#{} mult,",
            "and {X:mult,C:white}X#1#{} Mult"
        }
    },

    rarity = 4,
    atlas = 'Jokers',
    pos = { x = 7, y = 1 },
    cost = 25,
    unlocked = true,
    blueprint_compat = true,
    perishable_compat = true,
    config = { extra = { xmult = 2, chips = 100, mult = 10 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult, card.ability.extra.chips, card.ability.extra.mult} }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not (context.other_card:is_suit("Spades") or context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds") or context.other_card:is_suit("Clubs")) then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                xmult = card.ability.extra.xmult,
            }
        end
    end
}
----------------------------------------------
--------------roaring code end----------------
----------------------------------------------

---------------------------------------------------
---------------kaard code start -------------------
---------------------------------------------------

SMODS.Joker{
    key = "rouxls",
    atlas = "Jokers",
    pos = { x = 7, y = 0 },

    loc_txt = {
        name = "Rouxls Kaard",
        text = {
            "Scoring {C:attention}Stone{} cards make the",
            "Blind requirement {C:attention}#1#%{} smaller",
            "When {C:money}sold{}, instantly make the",
            "Blind requirement {C:attention}50%{} smaller",
            "{C:inactive}art by Vega{}"
        }
    },

    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,

    config = {
        extra = {
            percent = 0.15
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.percent * 100 }
        }
    end,

    calculate = function(self, card, context)
        
        local function tal_big(x)
            if to_big then return to_big(x) end
            return x
        end

        
        if context.individual and context.cardarea == G.play then
            local target = context.other_card
            if target and target.ability.effect == 'Stone Card' and G.GAME.blind then
                local new_chips = math.floor(G.GAME.blind.chips * (1 - card.ability.extra.percent))
                if tal_big(new_chips) < tal_big(1) then
                    new_chips = tal_big(1)
                end
                G.GAME.blind.chips = new_chips
                if G.HUD_blind then
                    G.HUD_blind.chips = new_chips
                end
            end
        end

        
        if context.selling_self and G.GAME.blind then
            local new_chips = math.floor(G.GAME.blind.chips * 0.5)
            if tal_big(new_chips) < tal_big(1) then
                new_chips = tal_big(1)
            end
            G.GAME.blind.chips = new_chips
            if G.HUD_blind then
                G.HUD_blind.chips = new_chips
            end
        end
    end
}
 
---------------------------------------------------
-------------------kaard code end------------------
---------------------------------------------------

---------------------------------------------------
---------------------toby code start---------------
---------------------------------------------------

loc_colour()
G.C.ITEMS = HEX("f87b22")
G.C.ITEMS_SECONDARY = HEX("f87b22")
G.ARGS.LOC_COLOURS["Deltalatro_Items"] = G.C.ITEMS

SMODS.ConsumableType {
  key = "Items",
  collection_rows = { 6, 6 },
  shop_rate = 0.01,
  primary_colour = G.C.ITEMS,
  secondary_colour = G.C.ITEMS_SECONDARY,
  loc_txt = {
    collection = "Items",
    name = "Items",
    undiscovered = {
      name = "Not Discovered",
      text = {
        "Purchase or use",
        "this card in an",
        "unseeded run to",
        "learn what it does"
      }
    },
  },
}

local igo = Game.init_game_object
function Game:init_game_object(...)
    local ret = igo(self, ...)
    ret.CanStick = tonumber(ret.CanStick) or 0
    ret.StickShop = tonumber(ret.StickShop) or 0
    ret.toby_phase = 0
    return ret
end

SMODS.Consumable{
    key = 'TobyFox',
    set = 'Items',
    atlas = 'Jokers',
    pos = { x = 3, y = 0 },
    loc_txt = {
        name = 'Toby Fox',
        text = {
            'Choose {C:attention}1 Joker{}, {C:attention}1 Consumable{},',
            'and the next {C:attention}Boss Blind{}',
        }
    },
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.toby_phase = 1
        G.FUNCS.overlay_menu({
            definition = create_UIBox_your_collection_jokers(),
        })
    end
}

local original_game_update = Game.update
function Game:update(dt)
    original_game_update(self, dt)

    local target = G.CONTROLLER.hovering.target
    if G.GAME.toby_phase > 0 and target and target.config and love.mouse.isDown(1) then
        
        if G.GAME.toby_phase == 1 and target.config.center and target.config.center.set == 'Joker' then
            local card_key = target.config.center.key
            G.GAME.toby_phase = 2
            
            local card = create_card('Joker', G.jokers, nil, nil, nil, nil, card_key)
            card:add_to_deck()
            G.jokers:emplace(card)
            
            G.FUNCS.exit_overlay_menu()
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
                G.FUNCS.overlay_menu({ definition = create_UIBox_your_collection_consumables() })
                return true
            end}))

        elseif G.GAME.toby_phase == 2 and target.config.center and (target.config.center.set == 'Tarot' or target.config.center.set == 'Spectral' or target.config.center.set == 'Planet' or target.config.center.set == 'LTMConsumableType') then
            local card_key = target.config.center.key
            G.GAME.toby_phase = 3
            
            local card = create_card(target.config.center.set, G.consumeables, nil, nil, nil, nil, card_key)
            card:add_to_deck()
            G.consumeables:emplace(card)

            G.FUNCS.exit_overlay_menu()
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
                G.FUNCS.overlay_menu({ definition = create_UIBox_your_collection_blinds() })
                return true
            end}))

        elseif G.GAME.toby_phase == 3 and target.config.blind then
            local clickedBlind = target.config.blind.key
            if clickedBlind ~= 'bl_small' and clickedBlind ~= 'bl_big' then
                G.GAME.Stick = clickedBlind
                G.GAME.StickUsed = 0
                G.GAME.toby_phase = 0
                G.FUNCS.exit_overlay_menu()
            end
        end
    end

    if G.GAME.Stick and G.STATE == G.STATES.BLIND_SELECT and G.blind_select_opts and (G.GAME.StickUsed == 0) then
        G.GAME.StickTime = (G.GAME.StickTime or 0) + 1
        if G.GAME.StickTime >= 20 then
            G.GAME.StickTime = 0
            G.GAME.StickUsed = 1
            
            local par = G.blind_select_opts.boss.parent
            G.GAME.round_resets.blind_choices.Boss = G.GAME.Stick
            G.blind_select_opts.boss:remove()

            G.blind_select_opts.boss = UIBox {
                T = {par.T.x, 0, 0, 0},
                definition = {
                    n = G.UIT.ROOT,
                    config = { align = "cm", colour = G.C.CLEAR },
                    nodes = {
                        UIBox_dyn_container(
                            { create_UIBox_blind_choice('Boss') },
                            false,
                            get_blind_main_colour('Boss'),
                            mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8)
                        )
                    }
                },
                config = { align = "bmi", offset = { x = 0, y = G.ROOM.T.y + 9 }, major = par, xy_bond = 'Weak' }
            }
            par.config.object = G.blind_select_opts.boss
            par.config.object:recalculate()
            G.blind_select_opts.boss.parent = par
            G.blind_select_opts.boss.alignment.offset.y = 0
        end
    end
end

---------------------------------------------------
--------------------toby code end------------------
---------------------------------------------------


---------------------------------------------------
---------------gift code start---------------------
---------------------------------------------------

SMODS.Consumable{
    key = 'tenna_gift',
    set = 'Items',
    atlas = 'Jokers',
    pos = { x = 5, y = 0 }, 

    loc_txt = {
        name = "tennas gift",
        text = {
            "Creates {C:attention}1 random Joker{}",
            "Cannot duplicate existing Jokers",
            "Must have room"
        }
    },

    can_use = function(self, card)
        
        if not G.jokers or not G.jokers.cards then return false end
        if #G.jokers.cards >= G.jokers.config.card_limit then return false end
        return true
    end,

    use = function(self, card, area, copier)
        if not G.jokers or not G.jokers.cards then return end

        
        local owned = {}
        for _, j in ipairs(G.jokers.cards) do
            if j.config.center and j.config.center.key then
                owned[j.config.center.key] = true
            end
        end

        
        local pool = {}
        for k, v in pairs(G.P_CENTERS) do
            if v.set == "Joker" and not owned[k] then
                table.insert(pool, k)
            end
        end

        
        if #pool == 0 then
            return
        end

        
        local chosen = pool[math.random(1, #pool)]

        
        local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, chosen)
        new_card:add_to_deck()
        G.jokers:emplace(new_card)
    end
}

----------------------------------------------
------------end gift code---------------------
----------------------------------------------

----------------------------------------------
------------start chair-----------------------
----------------------------------------------

SMODS.Consumable{
    key = 'chair',
    set = 'Items',
    atlas = 'Jokers',
    pos = { x = 4, y = 0 }, 

    loc_txt = {
        name = "Chair",
        text = {
            "Have a seat and {C:attention}skip{} to next ante",
            "Fights a {C:attention}random{} Boss Blind",
            "{C:inactive}Must NOT be during blind selection{}"
        }
    },

    can_use = function(self, card)
        return G.STATE ~= G.STATES.BLIND_SELECT
    end,

    use = function(self, card, area, copier)
        ease_ante(1)
		G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + 1
        
        G.GAME.ChairRandomize = true 
        G.GAME.ChairUsed = 0
    end
}


local original_game_update = Game.update
function Game:update(dt)
    original_game_update(self, dt)

    if G.GAME.ChairRandomize and G.GAME.ChairUsed == 0 then
        if G.STATE == G.STATES.BLIND_SELECT and G.blind_select_opts and G.blind_select_opts.boss then
            
            G.GAME.ChairUsed = 1 
            G.GAME.ChairRandomize = false

            G.from_boss_tag = true
            G.FUNCS.reroll_boss()

            for i = 1, #G.GAME.tags do
                if G.GAME.tags[i]:apply_to_run({ type = 'new_blind_choice' }) then
                    break
                end
            end
        end
    end
end

-------------------------------------------
-------------chair code end----------------
-------------------------------------------

SMODS.Consumable{
    key = 'board',
    set = 'Items',
    atlas = 'Jokers',
    pos = { x = 6, y = 0 }, 

    loc_txt = {
        name = "Tenna's Marvelous Mystery Board",
        text = {
            "Disable the current blind"
        }
    },

    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND and G.GAME.blind.boss
    end,

    use = function(self, card, area, copier)
        G.GAME.blind:disable()
		if ((SMODS.Mods["Fortlatro"] or {}).can_load) then
			G.DODGE_GAME.active = false
			G.DODGE_GAME.beams = {} 
			G.DODGE_GAME.shake_timer = 0
			G.DEFENSE_GAME.active = false
		end
    end
}


---------------------------------------------------
-------------------card end------------------------
---------------------------------------------------

SMODS.Consumable {
    key = 'laserpointer',
    set = 'Items', 
    atlas = 'Jokers', 
    pos = { x = 8, y = 0 },
    cost = 8,
    unlocked = true,
    discovered = true,
 
    loc_txt = {
        name = "So I haveth a Laser Pointere",
        text = {
            "selleth any item (including from shop)",
        }
    },
 
    can_use = function(self, card)
        return true
    end,
 
    
    use = function(self, card, area, copier)
        G.FUNCS.start_laserpointer_prompt()
    end,
}
 

G.LASERPOINTER_PROMPT = {
    active = false,
    virtualW = 1280,
    virtualH = 720,
    font = nil,
    small_font = nil,
    entries = {},
    scroll_y = 0,
}
 
local function laserpointer_sell_value(card)
    local base = (card and card.cost) or 1
    local v = math.floor(base / 2)
    if v < 1 then v = 1 end
    return v
end
 

local function laserpointer_build_entries()
    local entries = {}
 
    if G.jokers and G.jokers.cards then
        for i, c in ipairs(G.jokers.cards) do
            table.insert(entries, { card = c, area = G.jokers, label = (c.ability and c.ability.name) or "Joker", tag = "Yours" })
        end
    end
 
    if G.consumeables and G.consumeables.cards then
        for i, c in ipairs(G.consumeables.cards) do

            if not (c.ability and c.ability.name == "So I haveth a Laser Pointere") then
                table.insert(entries, { card = c, area = G.consumeables, label = (c.ability and c.ability.name) or "Consumable", tag = "Yours" })
            end
        end
    end
 
    if G.shop_jokers and G.shop_jokers.cards then
        for i, c in ipairs(G.shop_jokers.cards) do
            table.insert(entries, { card = c, area = G.shop_jokers, label = (c.ability and c.ability.name) or "Shop Item", tag = "Shop" })
        end
    end
 
    return entries
end
 
G.FUNCS = G.FUNCS or {}
G.FUNCS.start_laserpointer_prompt = function()
    local lp = G.LASERPOINTER_PROMPT
    lp.font = lp.font or deltalatro_ui_font(24)
    lp.small_font = lp.small_font or deltalatro_ui_font(18)
    lp.entries = laserpointer_build_entries()
    lp.scroll_y = 0
    lp.active = true
end
 
local function laserpointer_sell(entry)
    if not entry or not entry.card or not entry.area then return end
 
    local value = laserpointer_sell_value(entry.card)
    ease_dollars(value)
 
    entry.area:remove_card(entry.card)
    entry.card:remove()
 
    G.LASERPOINTER_PROMPT.active = false
end
 

local function laserpointer_box_for_index(i)
    local count = #(G.LASERPOINTER_PROMPT and G.LASERPOINTER_PROMPT.entries or {})
    local cols = math.max(3, math.min(5, math.ceil(math.sqrt(math.max(1, count) * 1.3))))
    local pad_x, pad_y = 14, 12
    local box_h = 58
    local area_w = 1190
    local box_w = (area_w - (cols - 1) * pad_x) / cols
    local total_w = cols * box_w + (cols - 1) * pad_x
    local start_x, start_y = (1280 - total_w) / 2, 142
    local col = (i - 1) % cols
    local row = math.floor((i - 1) / cols)
    return {
        x = start_x + col * (box_w + pad_x),
        y = start_y + row * (box_h + pad_y) - (G.LASERPOINTER_PROMPT.scroll_y or 0),
        w = box_w,
        h = box_h
    }
end
 
local function point_in_box(px, py, box)
    return px >= box.x and px <= box.x + box.w and py >= box.y and py <= box.y + box.h
end
 

local old_mousepressed_lp = love.mousepressed
function love.mousepressed(x, y, button)
    local lp = G.LASERPOINTER_PROMPT
    if lp.active then
        if button ~= 1 then return end
        local realW, realH = love.graphics.getDimensions()
        local vx = x / (realW / lp.virtualW)
        local vy = y / (realH / lp.virtualH)
 
        
        local close_box = { x = lp.virtualW - 90, y = 20, w = 60, h = 40 }
        if point_in_box(vx, vy, close_box) then
            lp.active = false
            return
        end
 
        if vy < 132 or vy > 624 then return end
        for i, entry in ipairs(lp.entries) do
            local box = laserpointer_box_for_index(i)
            if box.y >= 132 and box.y + box.h <= 624
            and point_in_box(vx, vy, box) then
                laserpointer_sell(entry)
                return
            end
        end
 
        return 
    end
    if old_mousepressed_lp then old_mousepressed_lp(x, y, button) end
end
 
local old_draw_lp = love.draw
function love.draw()
    if old_draw_lp then old_draw_lp() end

    local lp = G.LASERPOINTER_PROMPT
    if not lp.active then return end

    love.graphics.push("all")
    local realW, realH = love.graphics.getDimensions()
    love.graphics.scale(realW / lp.virtualW, realH / lp.virtualH)

    dlt_c3_draw_backdrop(lp.virtualW, lp.virtualH)
    dlt_c3_draw_panel(28, 22, 1212, 664, DLT_C3.glass_light)
    dlt_c3_draw_header(42, 36, 1184, 82, "LASER POINTER")
    love.graphics.setFont(deltalatro_ui_font(17))
    dlt_c3_color(DLT_C3.ink)
    love.graphics.printf("SELECT A CARD TO SELL FOR HALF ITS COST", 70, 85, 1080, "center")

    dlt_c3_draw_panel(lp.virtualW - 90, 20, 60, 40, DLT_C3.peach_light)
    love.graphics.setFont(deltalatro_ui_font(22))
    dlt_c3_color(DLT_C3.ink)
    love.graphics.printf("X", lp.virtualW - 90, 27, 60, "center")

    if #lp.entries == 0 then
        dlt_c3_draw_panel(300, 290, 680, 70, DLT_C3.cream)
        love.graphics.setFont(deltalatro_ui_font(22))
        dlt_c3_color(DLT_C3.ink)
        love.graphics.printf("NOTHING AVAILABLE TO SELL RIGHT NOW", 315, 310, 650, "center")
    end

    local mouse_x, mouse_y = love.mouse.getPosition()
    local vx = mouse_x / (realW / lp.virtualW)
    local vy = mouse_y / (realH / lp.virtualH)
    for i, entry in ipairs(lp.entries) do
        local box = laserpointer_box_for_index(i)
        if box.y >= 132 and box.y + box.h <= 624 then
            local value = laserpointer_sell_value(entry.card)
            local hovered = point_in_box(vx, vy, box)
            local fill
            if entry.tag == "Shop" then
                fill = (i % 2 == 0) and DLT_C3.peach_light or DLT_C3.peach
            else
                fill = (i % 2 == 0) and DLT_C3.mint_light or DLT_C3.sky_light
            end
            dlt_c3_draw_panel(box.x, box.y, box.w, box.h, hovered and DLT_C3.cream or fill)
            dlt_c3_color(entry.tag == "Shop" and DLT_C3.pink or DLT_C3.teal)
            love.graphics.rectangle("fill", box.x + 6, box.y + 6, 7, box.h - 12)
            love.graphics.setFont(deltalatro_ui_font(17))
            dlt_c3_color(DLT_C3.ink)
            love.graphics.printf(tostring(entry.label) .. "  [" .. tostring(entry.tag) .. "]", box.x + 20, box.y + 6, box.w - 28, "left")
            love.graphics.setFont(deltalatro_ui_font(18))
            dlt_c3_color(DLT_C3.pink)
            love.graphics.printf("SELL: $" .. tostring(value), box.x + 20, box.y + 31, box.w - 28, "left")
        end
    end

    local total_count = #lp.entries
    local cols = math.max(3, math.min(5, math.ceil(math.sqrt(math.max(1, total_count) * 1.3))))
    local rows = math.ceil(total_count / cols)
    local visible_rows = 7
    if rows > visible_rows then
        local track_x, track_y, track_h = 1230, 140, 474
        dlt_c3_color(DLT_C3.teal)
        love.graphics.rectangle("fill", track_x, track_y, 8, track_h)
        local thumb_h = math.max(32, track_h * visible_rows / rows)
        local max_scroll = math.max(1, (rows - visible_rows) * 70)
        local thumb_y = track_y + (track_h - thumb_h) * (lp.scroll_y or 0) / max_scroll
        dlt_c3_color(DLT_C3.pink)
        love.graphics.rectangle("fill", track_x, thumb_y, 8, thumb_h)
        dlt_c3_color(DLT_C3.cream)
        love.graphics.rectangle("line", track_x - 1, thumb_y, 10, thumb_h)
    end

    dlt_c3_draw_panel(190, 640, 900, 42, DLT_C3.peach_light)
    love.graphics.setFont(deltalatro_ui_font(15))
    dlt_c3_color(DLT_C3.ink)
    love.graphics.printf(#lp.entries > 35 and "SCROLL TO SEE MORE  •  CLICK AN ITEM TO SELL IT" or "CLICK AN ITEM TO SELL IT", 205, 650, 870, "center")
    love.graphics.pop()
end


----------------------------------------------
-------------------end of lazer---------------
----------------------------------------------
SMODS.Sound({
    key = "itsmyj",
    path = "itsmyj.ogg",
})


SMODS.Consumable{
    key = "Planetery",
    name = "Planetery Hands",
    set = "Planet",
    atlas = "flowery",
    pos = { x = 0, y = 0 },
    cost = 10,
    unlocked = true,
    discovered = true,

    pool = "flowers",

    hidden = true,
    soul_rate = 0.0001,

    loc_txt = {
        name = "Planetery",
        text = {
            "Upgrade {C:attention}all poker hands{}",
            "by {C:attention}9{} levels"
        }
    },

    config = {
        extra = {
            levels = 9
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.levels
            }
        }
    end,

    can_use = function(self, card)
        return G.GAME and G.GAME.hands
    end,

    use = function(self, card, area, copier)

        local levels = card.ability.extra.levels or 9

        play_sound("delta_itsmyj", 1.0, 1.0)

        local hands = {}

        for hand_name, hand_data in pairs(G.GAME.hands) do
            if hand_data then
                table.insert(hands, hand_name)
            end
        end

        table.sort(hands, function(a, b)
            return tostring(a) < tostring(b)
        end)

        update_hand_text(
            {
                sound = "button",
                volume = 0.7,
                pitch = 0.8,
                delay = 0.3
            },
            {
                handname = localize("k_all_hands"),
                chips = "...",
                mult = "...",
                level = ""
            }
        )

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.2,
            func = function()

                if card then
                    card:juice_up(0.8, 0.5)
                end

                return true
            end
        }))

        delay(0.3)

        for i, hand_name in ipairs(hands) do

            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.1,
                func = function()

                    local hand_data = G.GAME.hands[hand_name]

                    if hand_data then

                        update_hand_text(
                            {
                                sound = "button",
                                volume = 0.7,
                                pitch = 0.8,
                                delay = 0
                            },
                            {
                                handname = localize(
                                    hand_name,
                                    "poker_hands"
                                ),
                                chips = hand_data.chips,
                                mult = hand_data.mult,
                                level = hand_data.level
                            }
                        )

                        play_sound(
                            "tarot1",
                            1.0 + (i * 0.02),
                            1.0
                        )

                        level_up_hand(
                            copier or card,
                            hand_name,
                            true,
                            levels
                        )

                        if card then
                            card:juice_up(0.5, 0.3)
                        end
                    end

                    return true
                end
            }))

            delay(0.15)
        end

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.3,
            func = function()

                update_hand_text(
                    {
                        sound = "button",
                        volume = 0.7,
                        pitch = 1.1,
                        delay = 0
                    },
                    {
                        mult = 0,
                        chips = 0,
                        handname = "",
                        level = ""
                    }
                )

                return true
            end
        }))
    end
}
----------------------------------------------
-----------------planet code end--------------
---------------------------------------------- 

local old_add_to_pool = SMODS.add_to_pool

SMODS.add_to_pool = function(obj, ...)
    if G.GAME and G.GAME.flowery_deck and obj then
        if obj.mod and obj.mod.id ~= "Deltalatro" then
            return false
        end
    end

    return old_add_to_pool(obj, ...)
end

SMODS.Back{
    key = "flowery",
    name = "Flowery Deck",
    atlas = "flowery",
    pos = { x = 2, y = 0 },
    unlocked = true,
    discovered = true,

    config = {},

    loc_txt = {
        name = "Flowery Deck",
        text = {
            "Only allows {C:attention}base game{}",
            "and {C:purple}Deltalatro{} content"
        }
    },

    apply = function(self, back)
        G.GAME.flowery_deck = true
    end
}
           
----------------------------------------------
-------------flowery deck code end------------
----------------------------------------------


SMODS.Sound({
    key = "freedom",
    path = "freedom.ogg",
})


SMODS.Booster({
    key = "items",
    atlas = "Jokers",
    pos = { x = 1, y = 1 },

    loc_txt = {
        name = "Items Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} Item cards",
            "to have (does not take Flowery dollars)"
        },
        group_name = "Items Pack"
    },

    config = {
        extra = 3,
        choose = 1
    },

    cost = 4,
    weight = 0.5,
    kind = "Items",
    draw_hand = true,
    discovered = true,

    create_card = function(self, card, i)
        local attempts = 0
        local item

        repeat
            if item then
                item:remove()
            end

            item = create_card(
                "Items",
                G.pack_cards,
                nil,
                nil,
                true,
                true,
                nil,
                "delta_items"
            )

            attempts = attempts + 1
        until not item
            or not item.config
            or not item.config.center
            or item.config.center.key ~= "c_delta_board"
            or attempts >= 100

        return item
    end,

    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.BLACK)
        ease_background_colour({
            new_colour = G.C.BLACK,
            special_colour = G.C.BLACK,
            contrast = 2
        })
        play_sound("delta_freedom")
    end
})

------------INIT LOG--------------------------
----------------------------------------------

print("[Deltalatro] Loaded successfully!")


----------------------------------------------
--------SPAMTON SWEEPSTAKES FINAL UI----------
----------------------------------------------

if not G.SPAMTON_SWEEPSTAKES.final_hooks_installed then
    local previous_sweepstakes_keypressed = love.keypressed
    love.keypressed = function(key, scancode, isrepeat)
        if G.SPAMTON_SWEEPSTAKES and G.SPAMTON_SWEEPSTAKES.active then
            if not spamton_sweepstakes_in_blind_select() then
                spamton_sweepstakes_close()
            elseif key == "return" or key == "kpenter" then
                spamton_sweepstakes_buy()
                return
            elseif key == "escape" or key == "backspace" then
                spamton_sweepstakes_close()
                return
            end
        end
        if previous_sweepstakes_keypressed then
            return previous_sweepstakes_keypressed(key, scancode, isrepeat)
        end
    end

    local previous_sweepstakes_mousepressed = love.mousepressed
    love.mousepressed = function(x, y, button, istouch, presses)
        if button == 1 and G.SPAMTON_SWEEPSTAKES and G.GAME then
            if G.SPAMTON_SWEEPSTAKES.active then
                if not spamton_sweepstakes_in_blind_select() then
                    spamton_sweepstakes_close()
                else
                    local sw, sh = love.graphics.getDimensions()
                    local panel = spamton_sweepstakes_panel_rect(sw, sh)
                    local close, buy = panel.close, panel.buy
                    if x >= close.x and x <= close.x + close.w
                    and y >= close.y and y <= close.y + close.h then
                        spamton_sweepstakes_close()
                    elseif x >= buy.x and x <= buy.x + buy.w
                    and y >= buy.y and y <= buy.y + buy.h then
                        spamton_sweepstakes_buy()
                    elseif x < panel.x or x > panel.x + panel.w
                    or y < panel.y or y > panel.y + panel.h then
                        spamton_sweepstakes_close()
                    end
                    return
                end
            elseif spamton_sweepstakes_can_open() then
                local sw, sh = love.graphics.getDimensions()
                local bx, by, bw, bh = spamton_sweepstakes_button_rect(sw, sh)
                if x >= bx and x <= bx + bw
                and y >= by and y <= by + bh then
                    G.FUNCS.spamton_sweepstakes_toggle()
                    return
                end
            end
        end
        if previous_sweepstakes_mousepressed then
            return previous_sweepstakes_mousepressed(x, y, button, istouch, presses)
        end
    end

    local sweepstakes_site_prizes = {
        "FANGAMER GIFT CARDS",
        "SHIRTWEAR 1.04s SPAMTON UPDATE PATCH",
        "SPAMTON'S OLD SOCKS",
        "SPAMTON TOILET PAPER",
        "WORM FROM THE STRING",
        "CHAMPIONSHIP BELT",
        "SPAMTON AFTER NOT SURVIVING",
        "CUNGADERO CROSSING SIGN",
        "'FUR-THENTIC' CARDBOARD BOX",
        "SPAMKEY CANDLE",
        "BANANA",
        "RALSEI NURSE COSTUME",
        "YOUR BEST [$#*] HEART LOCKET",
        "PIPIS BATH RUG",
        "EMBROIDERED BATHROBE AND SLIPPERS",
        "FUNGIBLE TOKEN",
        "PIPIS BIG SHOT FANTASYSHIP RING",
        "ENGRAVED WRISTWATCH",
        "SPAMTON 3-D CELEBRITY PHOTO CUBE",
        "HOT MAMAS REAL WINE GLASS",
        "SKELETON SNOW GLOBE",
        "EVERY PIECE OF DELTARUNE MERCH",
        "SPAMTON ENGRAVED WEDDING RING",
        "SPAMTON BODY PILLOW"
    }

    local previous_sweepstakes_draw = love.draw or function() end
    love.draw = function()
        previous_sweepstakes_draw()

        if not G.SPAMTON_SWEEPSTAKES or not G.GAME
        or (G.SETTINGS and G.SETTINGS.paused) then
            return
        end

        if not spamton_sweepstakes_in_blind_select() then
            if G.SPAMTON_SWEEPSTAKES.active then
                G.SPAMTON_SWEEPSTAKES.active = false
            end
            return
        end

        local gambles = spamton_sweepstakes_gambles()
        if gambles >= SWEEPSTAKES_MAX_GAMBLES then
            G.SPAMTON_SWEEPSTAKES.active = false
            return
        end

        local sw, sh = love.graphics.getDimensions()
        local old_font = love.graphics.getFont()
        local button_x, button_y, button_w, button_h = spamton_sweepstakes_button_rect(sw, sh)

        local colors = {
            green = {0.19, 0.43, 0.25, 1},
            deep_green = {0.07, 0.20, 0.12, 1},
            mint = {0.60, 0.90, 0.49, 1},
            pale_mint = {0.79, 0.94, 0.65, 1},
            yellow = {1.00, 0.91, 0.10, 1},
            pink = {1.00, 0.16, 0.42, 1},
            red = {0.82, 0.07, 0.15, 1},
            blue = {0.06, 0.59, 0.95, 1},
            black = {0.025, 0.035, 0.025, 1},
            white = {1, 1, 0.88, 1},
            orange = {1.00, 0.43, 0.08, 1}
        }

        local function setc(c, alpha)
            love.graphics.setColor(c[1], c[2], c[3], alpha == nil and (c[4] or 1) or alpha)
        end

        local function font(size)
            love.graphics.setFont(spamton_sweepstakes_font(math.max(9, math.floor(size))))
        end

        local function text(str, x, y, w, size, color, align)
            setc(color or colors.white)
            font(size)
            love.graphics.printf(tostring(str or ""), x, y, w, align or "left")
        end

        local function panel(x, y, w, h, fill, outline, line_width, radius)
            setc(colors.black, 0.50)
            love.graphics.rectangle("fill", x + 4, y + 5, w, h, radius or 4, radius or 4)
            setc(fill)
            love.graphics.rectangle("fill", x, y, w, h, radius or 4, radius or 4)
            setc(colors.black)
            love.graphics.setLineWidth((line_width or 2) + 2)
            love.graphics.rectangle("line", x, y, w, h, radius or 4, radius or 4)
            setc(outline or colors.yellow)
            love.graphics.setLineWidth(line_width or 2)
            love.graphics.rectangle("line", x, y, w, h, radius or 4, radius or 4)
        end

        local function star(cx, cy, r, color)
            setc(color)
            local points = {}
            for i = 0, 9 do
                local angle = -math.pi / 2 + i * math.pi / 5
                local radius = i % 2 == 0 and r or r * 0.43
                points[#points + 1] = cx + math.cos(angle) * radius
                points[#points + 1] = cy + math.sin(angle) * radius
            end
            love.graphics.polygon("fill", points)
        end

        local function site_title(str, x, y, w, size)
            font(size)
            local f = love.graphics.getFont()
            local total = 0
            for i = 1, #str do
                total = total + f:getWidth(str:sub(i, i))
            end
            local scale = 1
            if total > w then scale = w / total end
            love.graphics.push()
            love.graphics.translate(x + (w - total * scale) / 2, y)
            love.graphics.scale(scale, 1)
            local cursor = 0
            for i = 1, #str do
                local ch = str:sub(i, i)
                setc(colors.black)
                love.graphics.print(ch, cursor + 2, 2)
                cursor = cursor + f:getWidth(ch)
            end
            local palette = {colors.white, colors.yellow, colors.black, colors.white, colors.yellow, colors.black}
            cursor = 0
            for i = 1, #str do
                local ch = str:sub(i, i)
                setc(palette[((i - 1) % #palette) + 1])
                love.graphics.print(ch, cursor, 0)
                cursor = cursor + f:getWidth(ch)
            end
            love.graphics.pop()
        end

        love.graphics.push("all")

        if not G.SPAMTON_SWEEPSTAKES.active then
            panel(button_x, button_y, button_w, button_h, colors.red, colors.yellow, 2, 3)
            setc(colors.pink)
            love.graphics.rectangle("fill", button_x + 4, button_y + 4, button_w - 8, 7)
            for i = 1, 9 do
                star(button_x + 10 + (button_w - 20) * (i - 1) / 8, button_y + 7, 3.2,
                    i % 2 == 0 and colors.yellow or colors.white)
            end
            site_title("$PAMTON $WEEPSTAKES", button_x + 8, button_y + 13, button_w - 16, math.min(19, sh * 0.024))
            text("$150 ENTRY  |  " .. tostring(gambles) .. "/3 USED", button_x + 6, button_y + button_h - 20,
                button_w - 12, math.min(13, sh * 0.017), colors.white, "center")
            love.graphics.setFont(old_font)
            love.graphics.pop()
            return
        end

        local p = spamton_sweepstakes_panel_rect(sw, sh)
        local px, py, pw, ph = p.x, p.y, p.w, p.h
        local close, buy = p.close, p.buy
        local pad = math.max(12, pw * 0.022)

        setc({0.015, 0.045, 0.025, 0.84})
        love.graphics.rectangle("fill", 0, 0, sw, sh)
        for row = 0, math.ceil(sh / 34) do
            for col = 0, math.ceil(sw / 46) do
                local x = col * 46 + ((row % 2) * 15)
                local y = row * 34
                local choose = (row * 7 + col * 3) % 5
                local c = choose == 0 and colors.mint or (choose == 1 and colors.green or colors.deep_green)
                setc(c, 0.18)
                love.graphics.rectangle("fill", x, y, 22, 15)
            end
        end
        for line_y = 0, sh, 6 do
            setc(colors.mint, 0.035)
            love.graphics.line(0, line_y, sw, line_y)
        end

        panel(px, py, pw, ph, colors.pale_mint, colors.yellow, 4, 3)
        local header_h = ph * 0.17
        setc(colors.pink)
        love.graphics.rectangle("fill", px + 9, py + 9, pw - 18, header_h)
        setc(colors.black)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", px + 9, py + 9, pw - 18, header_h)
        setc(colors.yellow)
        love.graphics.rectangle("fill", px + 9, py + 9, pw - 18, 6)
        for i = 0, 17 do
            local sx = px + 17 + (pw - 34) * i / 17
            star(sx, py + 20, 5, i % 2 == 0 and colors.yellow or colors.white)
        end
        site_title("SPAMTON SWEEPSTAKES", px + 26, py + 29, pw - 90,
            math.max(18, math.min(31, sh * 0.038)))
        local tagline = "$pamton $weepstakes  //  THE PROMOTION IS OVER... BUT THE DEALS LIVE ON!!!"
        local tagline_size = math.max(8, math.min(12, sh * 0.014))
        font(tagline_size)
        local tagline_font = love.graphics.getFont()
        local tagline_max_w = pw - 54
        local tagline_width = tagline_font:getWidth(tagline)
        if tagline_width > tagline_max_w and tagline_width > 0 then
            tagline_size = math.max(7, tagline_size * tagline_max_w / tagline_width)
        end
        text(tagline, px + 27, py + 9 + header_h - tagline_size - 12,
            tagline_max_w, tagline_size, colors.black, "center")

        panel(close.x, close.y, close.w, close.h, colors.red, colors.yellow, 2, 3)
        text("X", close.x, close.y + 4, close.w, math.min(24, sh * 0.032), colors.white, "center")

        text("WE DID IT!!!!!!", px + pad, py + header_h + 13, pw - pad * 2,
            math.max(17, sh * 0.027), colors.red, "center")

        local stat_y = py + header_h + math.max(34, sh * 0.052)
        local stat_h = sh * 0.092
        local stat_gap = 10
        local stat_x = px + pad
        local stat_w = (pw - pad * 2 - stat_gap * 2) / 3
        local stats = {
            {"$322,805.68", "TOTAL!!!", colors.yellow, colors.red},
            {"$58,924.53", "TOWARDS FREEDOM!!!", colors.blue, colors.white},
            {"$28,786.45", "TOWARDS SILENCE", colors.pink, colors.white}
        }
        for i, stat in ipairs(stats) do
            local sx = stat_x + (i - 1) * (stat_w + stat_gap)
            panel(sx, stat_y, stat_w, stat_h, stat[3], colors.black, 2, 2)
            text(stat[1], sx + 4, stat_y + 8, stat_w - 8, math.max(14, sh * 0.025), colors.black, "center")
            text(stat[2], sx + 6, stat_y + stat_h * 0.56, stat_w - 12, math.max(10, sh * 0.016), stat[4], "center")
        end

        local body_y = stat_y + stat_h + 12
        local body_h = sh * 0.19
        local left_w = pw * 0.255
        local left_x = px + pad
        local right_x = left_x + left_w + 12
        local right_w = px + pw - pad - right_x

        panel(left_x, body_y, left_w, body_h, colors.yellow, colors.black, 2, 2)
        setc(colors.pink)
        love.graphics.rectangle("fill", left_x + 8, body_y + 8, left_w - 16, 24)
        text("YOUR PRIZE!!!", left_x + 8, body_y + 10, left_w - 16, math.max(12, sh * 0.018), colors.white, "center")

        local gift_w = left_w * 0.50
        local gift_h = body_h * 0.40
        local gift_x = left_x + (left_w - gift_w) / 2
        local gift_y = body_y + 40
        setc(colors.red)
        love.graphics.rectangle("fill", gift_x, gift_y + gift_h * 0.28, gift_w, gift_h * 0.72)
        setc(colors.white)
        love.graphics.rectangle("fill", gift_x - 5, gift_y + gift_h * 0.22, gift_w + 10, gift_h * 0.18)
        setc(colors.pink)
        love.graphics.rectangle("fill", gift_x + gift_w * 0.40, gift_y + gift_h * 0.22, gift_w * 0.20, gift_h * 0.78)
        love.graphics.rectangle("fill", gift_x + gift_w * 0.43, gift_y, gift_w * 0.14, gift_h * 0.27)
        setc(colors.yellow)
        love.graphics.ellipse("fill", gift_x + gift_w * 0.39, gift_y + gift_h * 0.10, gift_w * 0.17, gift_h * 0.10)
        love.graphics.ellipse("fill", gift_x + gift_w * 0.61, gift_y + gift_h * 0.10, gift_w * 0.17, gift_h * 0.10)
        text("MYSTERY CARD", left_x + 8, body_y + body_h * 0.69, left_w - 16,
            math.max(12, sh * 0.019), colors.black, "center")
        text("$150 PER TRY", left_x + 8, body_y + body_h * 0.82, left_w - 16,
            math.max(10, sh * 0.016), colors.red, "center")

        if G.SPAMTON_SWEEPSTAKES.last_prize then
            text(G.SPAMTON_SWEEPSTAKES.last_prize, left_x + 9, body_y + body_h * 0.91,
                left_w - 18, math.max(9, sh * 0.013), colors.black, "center")
        end

        panel(right_x, body_y, right_w, body_h, {0.92, 0.98, 0.73, 1}, colors.green, 2, 2)
        setc(colors.green)
        love.graphics.rectangle("fill", right_x + 7, body_y + 7, right_w - 14, 25)
        text("PRIZES!!!", right_x + 12, body_y + 9, right_w - 24,
            math.max(12, sh * 0.019), colors.white, "center")
        local list_y = body_y + 38
        local list_h = body_h - 45
        local col_gap = 12
        local prize_col_w = (right_w - 22 - col_gap) / 2
        local row_h = list_h / 4
        local visible_prizes = {
            "FANGAMER GIFT CARDS",
            "SPAMTON'S OLD SOCKS",
            "SPAMTON TOILET PAPER",
            "WORM FROM THE STRING",
            "CHAMPIONSHIP BELT",
            "CUNGADERO CROSSING SIGN",
            "BANANA",
            "PIPIS BATH RUG"
        }
        for i, prize_name in ipairs(visible_prizes) do
            local col = i <= 4 and 0 or 1
            local row = (i - 1) % 4
            local rx = right_x + 11 + col * (prize_col_w + col_gap)
            local ry = list_y + row * row_h
            local fill = (row + col) % 2 == 0 and colors.pale_mint or {0.68, 0.89, 0.51, 1}
            setc(fill)
            love.graphics.rectangle("fill", rx, ry + 2, prize_col_w, row_h - 4)
            setc(colors.green)
            love.graphics.setLineWidth(1)
            love.graphics.rectangle("line", rx, ry + 2, prize_col_w, row_h - 4)
            text("* " .. prize_name, rx + 5, ry + 5, prize_col_w - 10,
                math.max(9, math.min(13, sh * 0.015)), colors.black, "left")
        end

        local ticker_y = body_y + body_h + 8
        local ticker_h = sh * 0.034
        panel(px + pad, ticker_y, pw - pad * 2, ticker_h, colors.blue, colors.black, 1, 2)
        local ticker_text = "  *  " .. table.concat(sweepstakes_site_prizes, "  *  ") .. "  *  "
        font(math.max(10, sh * 0.016))
        local ticker_font = love.graphics.getFont()
        local ticker_width = math.max(1, ticker_font:getWidth(ticker_text))
        local ticker_x = px + pad + 4
        local ticker_clip_x = ticker_x
        local ticker_clip_y = ticker_y + 2
        local ticker_clip_w = pw - pad * 2 - 8
        love.graphics.setScissor(ticker_clip_x, ticker_clip_y, ticker_clip_w, math.max(1, ticker_h - 4))
        setc(colors.yellow)
        local offset = ((love.timer and love.timer.getTime and love.timer.getTime() or 0) * 45) % ticker_width
        local draw_x = ticker_clip_x - offset
        love.graphics.print(ticker_text, draw_x, ticker_clip_y)
        love.graphics.print(ticker_text, draw_x + ticker_width, ticker_clip_y)
        love.graphics.setScissor()

        local can_buy = G.GAME.dollars and to_big(G.GAME.dollars) >= to_big(SWEEPSTAKES_PRICE)
        panel(buy.x, buy.y, buy.w, buy.h,
            can_buy and colors.red or colors.deep_green, can_buy and colors.yellow or colors.mint, 3, 3)
        setc(can_buy and colors.yellow or colors.white)
        font(math.max(18, sh * 0.030))
        love.graphics.printf(can_buy and "[$150]  ENTER THE SWEEPSTAKES!!!" or "YOU NEED $150, [[LITTLE SPONGE]]!!!",
            buy.x + 8, buy.y + buy.h * 0.24, buy.w - 16, "center")

        text("TRIES USED: " .. tostring(gambles) .. " / " .. tostring(SWEEPSTAKES_MAX_GAMBLES),
            px + pad, py + ph - 66, pw - pad * 2, math.max(13, sh * 0.021), colors.red, "center")
        text("IN-GAME PRIZE: ONE RANDOM PLAYING CARD, JOKER, TAROT, PLANET OR SPECTRAL CARD",
            px + pad, py + ph - 45, pw - pad * 2, math.max(9, sh * 0.014), colors.deep_green, "center")
        text("ENTER: BUY     ESC: CLOSE     CAMPAIGN TOTALS FROM THE ORIGINAL SITE",
            px + pad, py + ph - 27, pw - pad * 2, math.max(9, sh * 0.013), colors.deep_green, "center")

        love.graphics.setFont(old_font)
        love.graphics.pop()
    end

    G.SPAMTON_SWEEPSTAKES.final_hooks_installed = true
end



----------------------------------------------
--------ui bullshit---------------------------
----------------------------------------------

local previous_scroll_wheelmoved = love.wheelmoved
love.wheelmoved = function(x, y)
    local yellow = G.YELLOW_PROMPT
    if yellow and yellow.active then
        if #yellow.hands > 15 then
            local rows = math.ceil(#yellow.hands / 3)
            local max_scroll = math.max(0, (rows - 5) * 90)
            yellow.scroll_y = math.max(0, math.min(max_scroll, (yellow.scroll_y or 0) - y * 90))
        end
        return
    end

    local lp = G.LASERPOINTER_PROMPT
    if lp and lp.active then
        local count = #(lp.entries or {})
        local cols = math.max(3, math.min(5, math.ceil(math.sqrt(math.max(1, count) * 1.3))))
        local rows = math.ceil(count / cols)
        local max_scroll = math.max(0, (rows - 7) * 70)
        lp.scroll_y = math.max(0, math.min(max_scroll, (lp.scroll_y or 0) - y * 70))
        return
    end

    if previous_scroll_wheelmoved then
        return previous_scroll_wheelmoved(x, y)
    end
end
