
----------------------------------------------
------------ASSETS / ATLASES------------------
----------------------------------------------

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}



----------------------------------------------
------------Spamton code start---------------------
----------------------------------------------

SMODS.Joker{
    key = "big shot",
    name = "spamton",
    atlas = "Jokers",
    pos = {x = 0, y = 0},

    loc_txt = {
        name = "spamton",
        text = {
            "Gain {X:mult,C:white}X2{} Mult",
            "if hand contains a {C:hearts}Heart{} shaped object"
        }
    },

    rarity = 1,
    cost = 6,

    calculate = function(self, card, context)
        if context.joker_main then
            local has_heart = false

            for _, playing_card in ipairs(context.scoring_hand) do
                if playing_card:is_suit("Hearts") then
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
    end
}

---------------------------------
------tenna was also kiulled-----
---------------------------------

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
---------------ralsi CODE end ---------------------
---------------------------------------------------

SMODS.Atlas({ key = "Blinds", atlas_table = "ANIMATION_ATLAS", path = "Blinds.png", px = 34, py = 34, frames = 21 })

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

SMODS.Consumable {
    key = 'rouxls',
    set = 'Items',
    atlas = 'Jokers', 
    pos = { x = 7, y = 0 },
    cost = 6,
    unlocked = true,
    discovered = true,
 
    loc_txt = {
        name = "Rouxls Kaard",   -- he kills both in multiplayer thanks mp
        text = {
            "thoust blind shalt be 50% easier",     --cant fix fortlatro x multiplayer
            "art by Vega", 
        }
    },
 
    
    can_use = function(self, card)
        return G.GAME.blind ~= nil and not G.GAME.blind.defeated
    end,
 
    
    use = function(self, card, area, copier)
        if not G.GAME.blind then return end
 
        
        local function tal_big(x)
            if to_big then return to_big(x) end
            return x
        end
 
        local original = G.GAME.blind.chips
        local new_chips = math.floor(original * 0.5)
 
        
        if tal_big(new_chips) < tal_big(1) then
            new_chips = tal_big(1)
        end
 
        G.GAME.blind.chips = new_chips
        if G.HUD_blind then
            G.HUD_blind.chips = new_chips
        end
    end,
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

------------INIT LOG--------------------------
----------------------------------------------

print("[Deltarune Mod] Loaded successfully!")