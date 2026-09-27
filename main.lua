
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
    key = 'modicon',
    path = 'modicon.png',
    px = '32',
    py = '32'
})

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
            "for every {C:attention}Boss Blind{} defeated"
            "{C:inactive}art by Vega{}"
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
        {q = "Whos grovey and never glooby?", a = 3, choices = {"the mimic", "the kight", "tenna", "EricTheToon"}},
        {q = "Mike can we bring some waters for the kids?", a = 2, a = 1, a = 3, a = 4, choices = {"No", "No", "No", "No"}},
        {q = "What time is it?", a = 3, choices = {"6:30", "12:00 AM", "TV TIME!!!", "muffen time"}},
        {q = "Who made balatro?", a = 2, choices = {"EricTheToon", "LocalThunk", "stephylicious", "JIMBO,"}},
        {q = "How many jokers are in normal balatro?", a = 4, choices = {"3", "156", "1987", "150"}},
        {q = "Who is that [[clown around town]]?", a = 1, a = 4, choices = {"Jevil", "cancer", "ned", "jimbo"}},
        {q = "Who is that funny skellington thats here on late nights?", a = 1, a = 2, choices = {"sans", "papirus", "jack skellington", "skull troper"}},
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

           
------------INIT LOG--------------------------
----------------------------------------------

print("[Deltarune Mod] Loaded successfully!")