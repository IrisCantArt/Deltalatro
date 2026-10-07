
----------------------------------------------
------------ASSETS / ATLASES------------------
----------------------------------------------

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
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

local function spamton_get_font(size)
    if not G.SPAMTON_SHOP.fonts[size] then
        local ok, font =
            pcall(function()
                return love.graphics.newFont(size)
            end)

        if ok and font then
            G.SPAMTON_SHOP.fonts[size] =
                font
        end
    end

    return
        G.SPAMTON_SHOP.fonts[size]
        or love.graphics.getFont()
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

local function spamton_get_description(card)
    if not card
    or not card.config
    or not card.config.center then
        return "NO INFORMATION."
    end

    local center =
        card.config.center

    local key =
        center.key
        or card.config.center_key

    local set =
        center.set
        or "Joker"

    local vars = {}

    if center.loc_vars then
        local ok, result =
            pcall(function()
                return center.loc_vars(
                    center,
                    {},
                    card
                )
            end)

        if ok
        and result
        and result.vars then
            vars = result.vars
        end
    end

    if key then
        local ok, result =
            pcall(function()
                return localize{
                    type = "raw_descriptions",
                    key = key,
                    set = set,
                    vars = vars
                }
            end)

        if ok and result then
            if type(result) == "table" then
                local lines = {}

                for _, line in ipairs(result) do
                    if type(line) == "string" then
                        lines[#lines + 1] =
                            spamton_strip_formatting(
                                line
                            )
                    end
                end

                if #lines > 0 then
                    return table.concat(
                        lines,
                        "\n"
                    )
                end
            elseif type(result) == "string" then
                return spamton_strip_formatting(
                    result
                )
            end
        end
    end

    if center.loc_txt then
        local loc =
            center.loc_txt

        if loc["en-us"] then
            loc = loc["en-us"]
        elseif loc.default then
            loc = loc.default
        end

        if type(loc) == "table"
        and type(loc.text) == "table" then

            local lines = {}

            for _, line in ipairs(loc.text) do
                if type(line) == "string" then
                    line =
                        spamton_strip_formatting(
                            line
                        )

                    for i, value in ipairs(vars) do
                        line =
                            line:gsub(
                                "#" .. tostring(i) .. "#",
                                tostring(value)
                            )
                    end

                    lines[#lines + 1] =
                        line
                end
            end

            if #lines > 0 then
                return table.concat(
                    lines,
                    "\n"
                )
            end
        end
    end

    return "NO INFORMATION."
end

local function spamton_get_preview_sprite(card)
    if not card
    or not card.config
    or not card.config.center then
        return nil
    end

    if card._spamton_preview_sprite then
        return card._spamton_preview_sprite
    end

    local center =
        card.config.center

    local atlas_key =
        center.atlas

    local atlas =
        G.ASSET_ATLAS
        and G.ASSET_ATLAS[atlas_key]

    if not atlas then
        return nil
    end

    local pos =
        center.pos
        or {
            x = 0,
            y = 0
        }

    local sprite =
        Sprite(
            0,
            0,
            G.CARD_W * 0.9,
            G.CARD_H * 0.9,
            atlas,
            pos
        )


    card._spamton_preview_sprite =
        sprite

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
    return #G.SPAMTON_SHOP.cards + 1
end

local function spamton_get_entry(index)
    local card_count =
        #G.SPAMTON_SHOP.cards

    if index <= card_count then
        return {
            kind = "card",
            index = index,
            card =
                G.SPAMTON_SHOP.cards[index]
        }
    end

    if index == card_count + 1 then
        return {
            kind = "menu",
            name = "RUN AWAY",
            description =
                "LEAVE SPAMTON'S SHOP.",
            action = "exit"
        }
    end
end

local function spamton_set_selection(index)
    local total =
        spamton_get_total_entries()

    if total <= 0 then
        G.SPAMTON_SHOP.selected = 1
        return
    end

    if index < 1 then
        index = total
    end

    if index > total then
        index = 1
    end

    G.SPAMTON_SHOP.selected =
        index
end

local function spamton_move_selection(amount)
    if not G.SPAMTON_SHOP.active then
        return
    end

    spamton_set_selection(
        G.SPAMTON_SHOP.selected
        + amount
    )

    play_sound(
        "button",
        0.8,
        1.0
    )
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
    G.SPAMTON_SHOP.selected = 1

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

    spamton_play_bigshot(
        1.0,
        1.0
    )
end

local function spamton_destroy_shop()
    G.SPAMTON_SHOP.active = false

    spamton_show_normal_shop()

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

local function spamton_buy_selected()
    if not G.SPAMTON_SHOP.active then
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
            spamton_close_shop()
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

        play_sound(
            "cancel",
            1.0,
            0.9
        )

        return
    end

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

    play_sound(
        "delta_BIGSHOT",
        1.0,
        1.1
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
                                            "SPAMTONS SHOP"
                                        },

                                        button =
                                            "spamton_toggle_shop",

                                        minw = 2.8,
                                        minh = 0.9,
                                        scale = 0.32,

                                        colour =
                                            G.C.BLACK,

                                        text_colour =
                                            G.C.WHITE
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

                if key == "escape" then
                    spamton_close_shop()
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
    local old_mousepressed =
        love.mousepressed

    love.mousepressed =
        function(
            x,
            y,
            button,
            istouch,
            presses
        )
            if G.SPAMTON_SHOP
            and G.SPAMTON_SHOP.active
            and G.STATE
                == G.STATES.SHOP then

                return
            end

            if old_mousepressed then
                return old_mousepressed(
                    x,
                    y,
                    button,
                    istouch,
                    presses
                )
            end
        end

    G.SPAMTON_SHOP.mouse_hook_installed =
        true
end

if not G.SPAMTON_SHOP.update_hook_installed then
    local old_game_update =
        Game.update

    function Game:update(dt)
        old_game_update(
            self,
            dt
        )

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
    local old_draw =
        love.draw
        or function() end

    love.draw =
        function()
            old_draw()

            if not G.SPAMTON_SHOP
            or not G.SPAMTON_SHOP.active
            or G.STATE
                ~= G.STATES.SHOP then

                return
            end

            if G.SETTINGS
            and G.SETTINGS.paused then
                return
            end

            local screen_w,
                  screen_h =
                love.graphics.getDimensions()

            local shop =
                G.SPAMTON_SHOP

            local previous_font =
                love.graphics.getFont()

            local title_font =
                spamton_get_font(34)

            local item_font =
                spamton_get_font(25)

            local info_font =
                spamton_get_font(23)

            local small_font =
                spamton_get_font(18)

            love.graphics.push("all")

            love.graphics.setLineWidth(2)

            love.graphics.setColor(
                0,
                0,
                0,
                1
            )

            love.graphics.rectangle(
                "fill",
                0,
                0,
                screen_w,
                screen_h
            )

            local split_x =
                math.floor(
                    screen_w * 0.59
                )

            local horizontal_y =
                math.floor(
                    screen_h * 0.47
                )

            local right_x =
                split_x

            local right_w =
                screen_w - split_x

            local top_h =
                horizontal_y

            local left_pad = 32

            local shop_spam =
                spamton_get_shop_spam()

            if shop_spam then
                local img_w =
                    shop_spam:getWidth()

                local img_h =
                    shop_spam:getHeight()

                if img_w > 0
                and img_h > 0 then

                    local area_x = 20
                    local area_y = 0

                    local area_w =
                        split_x - 40

                    local area_h =
                        top_h - 15

                    local scale =
                        math.min(
                            area_w / img_w,
                            area_h / img_h
                        )

                    local draw_w =
                        img_w * scale

                    local draw_h =
                        img_h * scale

                    local draw_x =
                        area_x
                        + (
                            area_w
                            - draw_w
                        ) / 2

                    local draw_y =
                        area_y
                        + (
                            area_h
                            - draw_h
                        ) / 2
                        + 12

                    love.graphics.setColor(
                        1,
                        1,
                        1,
                        1
                    )

                    love.graphics.draw(
                        shop_spam,
                        draw_x,
                        draw_y,
                        0,
                        scale,
                        scale
                    )
                end
            end

            love.graphics.setColor(
                1,
                1,
                1,
                1
            )

            love.graphics.line(
                split_x,
                0,
                split_x,
                screen_h
            )

            love.graphics.line(
                0,
                horizontal_y,
                screen_w,
                horizontal_y
            )

            love.graphics.rectangle(
                "line",
                8,
                8,
                screen_w - 16,
                screen_h - 16
            )

            love.graphics.setFont(
                item_font
            )

            local list_x = 48

            local list_y =
                horizontal_y + 42

            local item_spacing = 58

            for i, card in ipairs(
                shop.cards
            ) do
                if card then
                    local y =
                        list_y
                        + (
                            (i - 1)
                            * item_spacing
                        )

                    local selected =
                        shop.selected == i

                    if selected then
                        love.graphics.setColor(
                            1,
                            1,
                            1,
                            1
                        )
                    else
                        love.graphics.setColor(
                            0.55,
                            0.55,
                            0.55,
                            1
                        )
                    end

                    if selected then
                        local soul =
                            spamton_get_soul()

                        if soul then
                            local sw =
                                soul:getWidth()

                            local sh =
                                soul:getHeight()

                            local scale =
                                16 / math.max(
                                    sw,
                                    sh
                                )

                            love.graphics.setColor(
                                1,
                                1,
                                1,
                                1
                            )

                            love.graphics.draw(
                                soul,
                                list_x - 24,
                                y + 4,
                                0,
                                scale,
                                scale
                            )
                        else
                            love.graphics.print(
                                "-",
                                list_x - 20,
                                y
                            )
                        end
                    end

                    local name =
                        spamton_get_name(
                            card
                        )

                    local price =
                        math.max(
                            1,
                            math.floor(
                                card.cost or 1
                            )
                        )

                    love.graphics.setFont(
                        item_font
                    )

                    love.graphics.print(
                        name,
                        list_x,
                        y
                    )

                    love.graphics.setColor(
                        1,
                        1,
                        1,
                        1
                    )

                    love.graphics.print(
                        tostring(price)
                        .. " KROMER",
                        split_x - 170,
                        y
                    )
                end
            end

            local run_slot =
                #shop.cards + 1

            local run_y =
                screen_h - 105

            local run_selected =
                shop.selected == run_slot

            if run_selected then
                love.graphics.setColor(
                    1,
                    1,
                    1,
                    1
                )
            else
                love.graphics.setColor(
                    0.55,
                    0.55,
                    0.55,
                    1
                )
            end

            local soul =
                spamton_get_soul()

            if run_selected then
                if soul then
                    local sw =
                        soul:getWidth()

                    local sh =
                        soul:getHeight()

                    local scale =
                        16 / math.max(
                            sw,
                            sh
                        )

                    love.graphics.setColor(
                        1,
                        1,
                        1,
                        1
                    )

                    love.graphics.draw(
                        soul,
                        list_x - 24,
                        run_y + 9,
                        0,
                        scale,
                        scale
                    )
                else
                    love.graphics.print(
                        "-",
                        list_x - 20,
                        run_y + 5
                    )
                end
            end

            love.graphics.setColor(
                run_selected and 0.12 or 0.04,
                run_selected and 0.12 or 0.04,
                run_selected and 0.12 or 0.04,
                1
            )

            love.graphics.rectangle(
                "fill",
                list_x - 8,
                run_y - 8,
                split_x - 70,
                62
            )

            love.graphics.setLineWidth(2)

            love.graphics.setColor(
                1,
                1,
                1,
                1
            )

            love.graphics.rectangle(
                "line",
                list_x - 8,
                run_y - 8,
                split_x - 70,
                62
            )

            love.graphics.setFont(
                title_font
            )

            love.graphics.print(
                "RUN AWAY",
                list_x + 20,
                run_y
            )

            love.graphics.setLineWidth(2)

            love.graphics.setColor(
                1,
                1,
                1,
                1
            )

            love.graphics.rectangle(
                "line",
                right_x + 18,
                20,
                right_w - 36,
                top_h - 40
            )

            local entry =
                spamton_get_entry(
                    shop.selected
                )

            if entry
            and entry.kind == "card"
            and entry.card then

                local card =
                    entry.card

                local name =
                    spamton_get_name(
                        card
                    )

                local description =
                    spamton_get_description(
                        card
                    )

                local price =
                    math.max(
                        1,
                        math.floor(
                            card.cost or 1
                        )
                    )

                love.graphics.setFont(
                    spamton_get_font(32)
                )

                love.graphics.setColor(
                    1,
                    1,
                    1,
                    1
                )

                love.graphics.print(
                    name,
                    right_x + 42,
                    42
                )

                local preview =
                    spamton_get_preview_sprite(
                        card
                    )

                if preview then
                    preview.T.x =
                        right_x + 28

                    preview.T.y =
                        105

                    preview.T.w =
                        G.CARD_W * 0.72

                    preview.T.h =
                        G.CARD_H * 0.72

                    preview:draw()
                end

                love.graphics.setFont(
                    info_font
                )

                love.graphics.setColor(
                    1,
                    0.8,
                    0.25,
                    1
                )

                love.graphics.print(
                    tostring(price)
                    .. " KROMER",
                    right_x + 175,
                    105
                )

                love.graphics.setColor(
                    0.85,
                    0.85,
                    0.85,
                    1
                )

                spamton_draw_wrapped(
                    description,
                    right_x + 175,
                    145,
                    right_w - 205,
                    info_font,
                    30
                )

                love.graphics.setColor(
                    1,
                    0.4,
                    0.4,
                    1
                )

                love.graphics.print(
                    tostring(
                        card.ability.spamton_discount
                        or 0
                    )
                    .. "% DISCOUNT",
                    right_x + 42,
                    top_h - 58
                )

            elseif entry
            and entry.kind == "menu" then

                love.graphics.setFont(
                    spamton_get_font(32)
                )

                love.graphics.setColor(
                    1,
                    1,
                    1,
                    1
                )

                love.graphics.print(
                    entry.name,
                    right_x + 42,
                    42
                )

                love.graphics.setFont(
                    info_font
                )

                love.graphics.setColor(
                    0.85,
                    0.85,
                    0.85,
                    1
                )

                spamton_draw_wrapped(
                    entry.description,
                    right_x + 42,
                    110,
                    right_w - 84,
                    info_font,
                    30
                )
            end

            local dialogue_y =
                horizontal_y + 25

            love.graphics.setFont(
                info_font
            )

            love.graphics.setColor(
                1,
                1,
                1,
                1
            )

            love.graphics.print(
                "DEALS SO",
                right_x + 38,
                dialogue_y
            )

            love.graphics.print(
                "GOOD I'LL",
                right_x + 38,
                dialogue_y + 32
            )

            love.graphics.print(
                "[$$$]",
                right_x + 38,
                dialogue_y + 64
            )

            love.graphics.print(
                "MYSELF!",
                right_x + 38,
                dialogue_y + 96
            )

            love.graphics.setFont(
                spamton_get_font(32)
            )

            love.graphics.setColor(
                1,
                0.8,
                0.25,
                1
            )

            local money_text =
                spamton_money()
                .. " KROMER"

            local money_width =
                love.graphics.getFont():getWidth(
                    money_text
                )

            love.graphics.print(
                money_text,
                screen_w
                    - money_width
                    - 42,
                screen_h - 65
            )

            love.graphics.setFont(
                small_font
            )

            love.graphics.setColor(
                0.65,
                0.65,
                0.65,
                1
            )

            love.graphics.print(
                "UP / DOWN  SELECT",
                right_x + 38,
                screen_h - 125
            )

            love.graphics.print(
                "ENTER  BUY",
                right_x + 38,
                screen_h - 95
            )

            love.graphics.setFont(
                previous_font
            )

            love.graphics.setLineWidth(1)

            love.graphics.setColor(
                1,
                1,
                1,
                1
            )

            love.graphics.pop()
        end

    G.SPAMTON_SHOP.draw_hook_installed =
        true
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

                spamton_play_eric()
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
----------------------------------
-------MIKE CODE was killed ------
----------------------------------

-- ==========================================
-- Clopen Overlay State
-- ==========================================
G.CLOPEN_OVERLAY = {
    logo = nil,
    initialized = false,
    -- VIRTUAL DIMENSIONS (Match your DVD game for consistency)
    virtualW = 1280,
    virtualH = 720,
    -- Size in virtual pixels
    w = 250, 
    h = 200,
    -- Position in virtual pixels (Adjust these to hit your shop area)
    vx = 65,
    vy = 35
}

-- ==========================================
-- Update Logic (Asset Loading)
-- ==========================================
local old_update = love.update or function() end
function love.update(dt)
    old_update(dt)

    local c = G.CLOPEN_OVERLAY
    if not c.initialized then
        -- Ensure the mod path matches your current mod folder name
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

-- ==========================================
-- Drawing Logic
-- ==========================================
local old_draw = love.draw or function() end
function love.draw()
    old_draw()

    if G.GAME and G.GAME.Clopen and G.STATE == G.STATES.SHOP then
        local c = G.CLOPEN_OVERLAY
        if c.logo then
            -- 1. Calculate the scale factors based on current window size
            local realW, realH = love.graphics.getDimensions()
            local scaleX = realW / c.virtualW
            local scaleY = realH / c.virtualH

            local r, g, b, a = love.graphics.getColor()
            love.graphics.setColor(1, 1, 1, 1)

            -- 2. Draw using the scale factors
            -- Positions (vx, vy) and Dimensions (w, h) are multiplied by scale
            love.graphics.draw(
                c.logo, 
                c.vx * scaleX, 
                c.vy * scaleY, 
                0, 
                (c.w / c.logo:getWidth()) * scaleX, 
                (c.h / c.logo:getHeight()) * scaleY
            )

            love.graphics.setColor(r, g, b, a)
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
        extra = { shop = 'None' } --track what to do to the shop
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

            -- 1 in 4 chance
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

-- =========================
-- Quiz Game Container
-- =========================
G.QUIZ_GAME = {
    active = false,
    input_locked = false, 
    timer = 0,            
    delay_between = 5,    -- Seconds between questions
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

-- =========================
-- Initialization
-- =========================
G.FUNCS = G.FUNCS or {}
G.FUNCS.start_quiz_game = function()
    local qz = G.QUIZ_GAME
    qz.active = true
    qz.wrong_count = 0
    qz.timer = 1 
    qz.font = love.graphics.newFont(32)
    qz.current_q = nil
    qz.input_locked = false -- Start unlocked until first question pops
end

-- =========================
-- Logic Handling
-- =========================
function answer_quiz(index)
    local qz = G.QUIZ_GAME
    if not qz.current_q then return end

    if index == qz.current_q.a then
    else
        qz.wrong_count = qz.wrong_count + 1
    end

    -- CLEANUP AFTER ANSWER
    qz.current_q = nil
    qz.input_locked = false -- UNLOCK input immediately after answering
    qz.timer = qz.delay_between

    if qz.wrong_count >= 2 then
        qz.active = false
        G.GAME.DR_ForcedFail = true
    end
end

-- =========================
-- Hooks & Callbacks
-- =========================

-- Mouse Lock Hook
local old_mouse = love.mousepressed
function love.mousepressed(x, y, button)
    -- Only block if a question is actually being displayed
    if G.QUIZ_GAME.active and G.QUIZ_GAME.current_q and G.QUIZ_GAME.input_locked then 
        return 
    end
    if old_mouse then old_mouse(x, y, button) end
end

-- Key Listener
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

-- Update Loop
local old_upd = Game.update
function Game:update(dt)
    if old_upd then old_upd(self, dt) end
    local qz = G.QUIZ_GAME

    -- Triggering logic
    if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.key == "bl_tenna_show" then
        if not qz.active then
            if pseudorandom('tenna_q') < 0.001 then 
                G.FUNCS.start_quiz_game()
            end
        end
    end

    -- Timer & Auto-Lock Logic
    if qz.active and not qz.current_q then
        qz.timer = qz.timer - dt
        if qz.timer <= 0 then
            qz.current_q = qz.questions[math.random(#qz.questions)]
            qz.input_locked = true -- LOCK input only when a question appears
        end
    end
end

-- Draw Loop
local old_draw = love.draw
function love.draw()
    if old_draw then old_draw() end
    
    local qz = G.QUIZ_GAME
    if not qz.active then return end

    love.graphics.push("all") 
    local realW, realH = love.graphics.getDimensions()
    love.graphics.scale(realW / qz.virtualW, realH / qz.virtualH)

    if qz.current_q then
        -- Darken screen only when question is visible
        love.graphics.setColor(0, 0, 0, 0.85)
        love.graphics.rectangle("fill", 0, 0, qz.virtualW, qz.virtualH)

        love.graphics.setColor(1, 1, 1, 1)
        if qz.font then love.graphics.setFont(qz.font) end

        love.graphics.printf(qz.current_q.q, 0, 200, qz.virtualW, "center")
        for i, choice in ipairs(qz.current_q.choices) do
            love.graphics.printf(i .. ": " .. choice, 0, 300 + (i * 60), qz.virtualW, "center")
        end
    end
    
    -- Strike HUD (stays visible while active, even between questions)
    if qz.font then
        love.graphics.setFont(qz.font)
        love.graphics.setColor(1, 0.3, 0.3, 1)
        love.graphics.print("STRIKES: " .. qz.wrong_count .. " / 2", 50, 50)
    end

    love.graphics.pop() 
end

local end_round_original = end_round
function end_round()
    -- Call the original end_round
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
    virtualW = 1280,
    virtualH = 720,
    font = nil,
    small_font = nil,
    play_event = nil,
    original_play = nil
}

local function yellow_get_hands()
    local hands = {}

    if G
        and G.GAME
        and G.GAME.hands then

        for hand_name, hand_data in pairs(G.GAME.hands) do
            if hand_data then
                table.insert(hands, hand_name)
            end
        end
    end

    table.sort(hands, function(a, b)
        return tostring(a) < tostring(b)
    end)

    return hands
end

local function yellow_hand_name(hand)
    if G
        and G.localization
        and G.localization.misc
        and G.localization.misc.poker_hands
        and G.localization.misc.poker_hands[hand] then

        return tostring(G.localization.misc.poker_hands[hand])
    end

    return tostring(hand)
end

local function yellow_box_for_index(i)
    local cols = 3
    local box_w = 360
    local box_h = 70
    local pad_x = 30
    local pad_y = 20
    local start_x = 60
    local start_y = 140

    local col = (i - 1) % cols
    local row = math.floor((i - 1) / cols)

    return {
        x = start_x + col * (box_w + pad_x),
        y = start_y + row * (box_h + pad_y),
        w = box_w,
        h = box_h
    }
end

local function yellow_point_in_box(px, py, box)
    return px >= box.x
        and px <= box.x + box.w
        and py >= box.y
        and py <= box.y + box.h
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

    y.font = y.font or love.graphics.newFont(24)
    y.small_font = y.small_font or love.graphics.newFont(16)

    y.card = yellow_card
    y.hands = yellow_get_hands()
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

    y.card.ability.extra.chosen_hand = hand

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
            x = prompt.virtualW - 90,
            y = 20,
            w = 60,
            h = 40
        }

        if yellow_point_in_box(vx, vy, close_box) then

            prompt.active = false
            prompt.card = nil
            prompt.hands = {}
            prompt.play_event = nil

            return
        end

        for i, hand in ipairs(prompt.hands) do

            local box = yellow_box_for_index(i)

            if yellow_point_in_box(vx, vy, box) then
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

    if old_yellow_draw then
        old_yellow_draw()
    end

    local prompt = G.YELLOW_PROMPT

    if not prompt.active then
        return
    end

    love.graphics.push("all")

    local realW, realH = love.graphics.getDimensions()

    love.graphics.scale(
        realW / prompt.virtualW,
        realH / prompt.virtualH
    )

    love.graphics.setColor(0, 0, 0, 0.90)

    love.graphics.rectangle(
        "fill",
        0,
        0,
        prompt.virtualW,
        prompt.virtualH
    )

    if prompt.font then
        love.graphics.setFont(prompt.font)
    end

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.printf(
        "CHOOSE A HAND",
        0,
        60,
        prompt.virtualW,
        "center"
    )

    love.graphics.setColor(0.6, 0.2, 0.2, 1)

    love.graphics.rectangle(
        "fill",
        prompt.virtualW - 90,
        20,
        60,
        40,
        6,
        6
    )

    love.graphics.setColor(1, 1, 1, 1)

    if prompt.small_font then
        love.graphics.setFont(prompt.small_font)
    end

    love.graphics.printf(
        "X",
        prompt.virtualW - 90,
        30,
        60,
        "center"
    )

    if #prompt.hands == 0 then

        love.graphics.printf(
            "NO HANDS FOUND",
            0,
            250,
            prompt.virtualW,
            "center"
        )

    else

        for i, hand in ipairs(prompt.hands) do

            local box = yellow_box_for_index(i)

            love.graphics.setColor(0.25, 0.65, 0.35, 1)

            love.graphics.rectangle(
                "fill",
                box.x,
                box.y,
                box.w,
                box.h,
                8,
                8
            )

            love.graphics.setColor(1, 1, 1, 1)

            if prompt.small_font then
                love.graphics.setFont(prompt.small_font)
            end

            love.graphics.printf(
                yellow_hand_name(hand),
                box.x + 10,
                box.y + 24,
                box.w - 20,
                "center"
            )
        end
    end

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
            "Before playing a hand,",
            "choose a {C:attention}poker hand type",
            "Your hand counts as that hand",
            "and gains its {C:chips}Chips{} and {C:mult}Mult{}"
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

-- 1. Initialize Game Objects
local igo = Game.init_game_object
function Game:init_game_object(...)
    local ret = igo(self, ...)
    ret.CanStick = tonumber(ret.CanStick) or 0
    ret.StickShop = tonumber(ret.StickShop) or 0
    ret.toby_phase = 0 -- 0: Idle, 1: Picking Joker, 2: Picking Consumable, 3: Picking Blind
    return ret
end

-- 2. Define the Toby Fox Consumable
SMODS.Consumable{
    key = 'TobyFox',
    set = 'Items',
    atlas = 'Jokers',
    pos = { x = 3, y = 0 }, -- Adjust to your atlas position
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
        -- Start the sequence
        G.GAME.toby_phase = 1
        G.FUNCS.overlay_menu({
            definition = create_UIBox_your_collection_jokers(),
        })
    end
}

-- 3. Main Logic Loop
local original_game_update = Game.update
function Game:update(dt)
    original_game_update(self, dt)

    -- Detect clicks on Collection items during Toby Fox sequence
    local target = G.CONTROLLER.hovering.target
    if G.GAME.toby_phase > 0 and target and target.config and love.mouse.isDown(1) then
        
        -- PHASE 1: Joker Selected
        if G.GAME.toby_phase == 1 and target.config.center and target.config.center.set == 'Joker' then
            local card_key = target.config.center.key
            G.GAME.toby_phase = 2
            
            -- Add the Joker
            local card = create_card('Joker', G.jokers, nil, nil, nil, nil, card_key)
            card:add_to_deck()
            G.jokers:emplace(card)
            
            -- Close and move to next menu
            G.FUNCS.exit_overlay_menu()
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
                G.FUNCS.overlay_menu({ definition = create_UIBox_your_collection_consumables() })
                return true
            end}))

        -- PHASE 2: Consumable Selected
        elseif G.GAME.toby_phase == 2 and target.config.center and (target.config.center.set == 'Tarot' or target.config.center.set == 'Spectral' or target.config.center.set == 'Planet' or target.config.center.set == 'LTMConsumableType') then
            local card_key = target.config.center.key
            G.GAME.toby_phase = 3
            
            -- Add the Consumable
            local card = create_card(target.config.center.set, G.consumeables, nil, nil, nil, nil, card_key)
            card:add_to_deck()
            G.consumeables:emplace(card)

            -- Close and move to Blind menu
            G.FUNCS.exit_overlay_menu()
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
                G.FUNCS.overlay_menu({ definition = create_UIBox_your_collection_blinds() })
                return true
            end}))

        -- PHASE 3: Blind Selected (Same as Stick logic)
        elseif G.GAME.toby_phase == 3 and target.config.blind then
            local clickedBlind = target.config.blind.key
            if clickedBlind ~= 'bl_small' and clickedBlind ~= 'bl_big' then
                G.GAME.Stick = clickedBlind
                G.GAME.StickUsed = 0
                G.GAME.toby_phase = 0 -- Sequence Complete
                G.FUNCS.exit_overlay_menu()
            end
        end
    end

    -- Blind Replacement Logic (Original Stick functionality)
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
        -- Usable in Shop or during a Round, but not while already picking a blind
        return G.STATE ~= G.STATES.BLIND_SELECT
    end,

    use = function(self, card, area, copier)
        -- Advance the Ante logically
        ease_ante(1)
		G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + 1
        
        -- Set flags for the update loop to catch
        G.GAME.ChairRandomize = true 
        G.GAME.ChairUsed = 0
    end
}


local original_game_update = Game.update
function Game:update(dt)
    original_game_update(self, dt)

    -- Check if the Chair was activated and we are waiting for the UI to load
    if G.GAME.ChairRandomize and G.GAME.ChairUsed == 0 then
        -- Trigger only when the Blind Selection screen and the Boss UI exist
        if G.STATE == G.STATES.BLIND_SELECT and G.blind_select_opts and G.blind_select_opts.boss then
            
            G.GAME.ChairUsed = 1 
            G.GAME.ChairRandomize = false

            -- Instant Randomization (DQ Reset style)
            -- This forces a reroll and handles the UI rebuild automatically
            G.from_boss_tag = true
            G.FUNCS.reroll_boss()

            -- Trigger tags that react to new blind choices (e.g., Negative Tag)
            for i = 1, #G.GAME.tags do
                if G.GAME.tags[i]:apply_to_run({ type = 'new_blind_choice' }) then
                    break
                end
            end
        end
    end
end

-------------------------------------------
------------------ code end-----------------
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
    entries = {}, -- 
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
    lp.font = lp.font or love.graphics.newFont(24)
    lp.small_font = lp.small_font or love.graphics.newFont(16)
    lp.entries = laserpointer_build_entries()
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
    local cols = 3
    local box_w, box_h = 360, 70
    local pad_x, pad_y = 30, 20
    local start_x, start_y = 60, 140
 
    local col = (i - 1) % cols
    local row = math.floor((i - 1) / cols)
 
    return {
        x = start_x + col * (box_w + pad_x),
        y = start_y + row * (box_h + pad_y),
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
        local realW, realH = love.graphics.getDimensions()
        local vx = x / (realW / lp.virtualW)
        local vy = y / (realH / lp.virtualH)
 
        
        local close_box = { x = lp.virtualW - 90, y = 20, w = 60, h = 40 }
        if point_in_box(vx, vy, close_box) then
            lp.active = false
            return
        end
 
        for i, entry in ipairs(lp.entries) do
            local box = laserpointer_box_for_index(i)
            if point_in_box(vx, vy, box) then
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
 
    love.graphics.setColor(0, 0, 0, 0.85)
    love.graphics.rectangle("fill", 0, 0, lp.virtualW, lp.virtualH)
 
    if lp.font then love.graphics.setFont(lp.font) end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("CHOOSE A CARD TO SELL", 0, 60, lp.virtualW, "center")
 
    
    love.graphics.setColor(0.6, 0.2, 0.2, 1)
    love.graphics.rectangle("fill", lp.virtualW - 90, 20, 60, 40, 6, 6)
    love.graphics.setColor(1, 1, 1, 1)
    if lp.small_font then love.graphics.setFont(lp.small_font) end
    love.graphics.printf("X", lp.virtualW - 90, 30, 60, "center")
 
    if #lp.entries == 0 then
        love.graphics.printf("Nothing available to sell right now.", 0, 200, lp.virtualW, "center")
    end
 
    for i, entry in ipairs(lp.entries) do
        local box = laserpointer_box_for_index(i)
        local value = laserpointer_sell_value(entry.card)
 
        if entry.tag == "Shop" then
            love.graphics.setColor(0.25, 0.45, 0.75, 1)
        else
            love.graphics.setColor(0.25, 0.65, 0.35, 1)
        end
        love.graphics.rectangle("fill", box.x, box.y, box.w, box.h, 8, 8)
 
        love.graphics.setColor(1, 1, 1, 1)
        if lp.small_font then love.graphics.setFont(lp.small_font) end
        love.graphics.printf(entry.label .. " [" .. entry.tag .. "]", box.x + 10, box.y + 10, box.w - 20, "left")
        love.graphics.printf("Sell: $" .. tostring(value), box.x + 10, box.y + 38, box.w - 20, "left")
    end
 
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

SMODS.Joker{
    key = "jarona",
    name = "flowery",
    rarity = 3,
    cost = 8,
    atlas = "flowery",
    pos = {x = 3, y = 0},

    loc_txt = {
        name = "Jarona",
        text = {
            "When sold, create",
            "2 random {C:attention}Flower{} Jokers",
            "{C:inactive}(Can exceed Joker limit)"
        }
    },

    calculate = function(self, card, context)
        if context.selling_self then
            for i = 1, 2 do
                local flower = SMODS.add_card{
                    set = "Joker",
                    pool = "flowers",
                    area = G.jokers,
                    allow_duplicates = true
                }

                if flower then
                    flower.bypass_card_limit = true
                end
            end

            return {
                message = "The life forever for flowers!",
                colour = G.C.GREEN
            }
        end
    end
}
----------------------------------------------
----------------------jarona code end---------
----------------------------------------------



------------INIT LOG--------------------------
----------------------------------------------

print("[Deltalatro] Loaded successfully!")
