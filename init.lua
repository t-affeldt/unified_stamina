local mod_hudbars = minetest.get_modpath("hudbars") ~= nil
local mod_hbsprint = minetest.get_modpath("hbsprint") ~= nil
local mod_minetest_wadsprint = minetest.get_modpath("minetest_wadsprint") ~= nil
local mod_sprint_lite = minetest.get_modpath("sprint_lite") ~= nil
local mod_real_stamina = minetest.get_modpath("real_stamina") ~= nil
local mod_cmo_stamina = minetest.get_modpath("cmo_stamina") ~= nil

unified_stamina = {}
unified_stamina.active = true
unified_stamina.active_mod = "none"

-- MOD: hbsprint

if mod_hbsprint then
    unified_stamina.active_mod = "hbsprint"
    local autohide = minetest.settings:get_bool("hudbars_autohide_stamina", true)

    function unified_stamina.get_scale()
        return 20
    end

    function unified_stamina.get(playername)
        local player = minetest.get_player_by_name(playername)
        return (player:get_meta():get_float("hbsprint:stamina") or 20) / 20
    end

    function unified_stamina.add(playername, percentage)
        local player = minetest.get_player_by_name(playername)
        local current = unified_stamina.get(playername)
        local change = percentage * 20
        local stamina = math.min(20, math.max(0, current - change))
        player:get_meta():set_float("hbsprint:stamina", stamina)
        if mod_hudbars then
            if autohide and stamina < 20 then
                hb.unhide_hudbar(player, "stamina")
            end
            hb.change_hudbar(player, "stamina", stamina)
        end
    end

    function unified_stamina.set(playername, percentage)
        local player = minetest.get_player_by_name(playername)
        local stamina = math.min(20, math.max(0, percentage * 20))
        player:get_meta():set_float("hbsprint:stamina", stamina)
        if mod_hudbars then
            if autohide and stamina < 20 then
                hb.unhide_hudbar(player, "stamina")
            elseif autohide and stamina >= 20 then
                hb.hide_hudbar(player, "stamina")
            end
            hb.change_hudbar(player, "stamina", stamina)
        end
    end

-- MOD: minetest_wadsprint

elseif mod_minetest_wadsprint and minetest_wadsprint ~= nil then
    unified_stamina.active_mod = "minetest_wadsprint"
    function unified_stamina.get_scale()
        return 100
    end

    function unified_stamina.get(playername)
        return minetest_wadsprint.api.stamina(playername)
    end

    function unified_stamina.add(playername, percentage)
        minetest_wadsprint.api.addstamina(playername, percentage)
    end

    function unified_stamina.set(playername, percentage)
        minetest_wadsprint.api.stamina(playername, percentage)
    end

-- MOD: sprint_lite

elseif mod_sprint_lite and sprint_lite ~= nil then
    unified_stamina.active_mod = "sprint_lite"
    local scale = tonumber(minetest.settings:get("sprint_lite_max_stamina")) or 20

    function unified_stamina.get_scale()
        return scale
    end

    function unified_stamina.get(playername)
        return sprint_lite.get_stamina(playername) / scale
    end

    function unified_stamina.add(playername, percentage)
        sprint_lite.set_stamina(playername, percentage * scale, true)
    end

    function unified_stamina.set(playername, percentage)
        sprint_lite.set_stamina(playername, percentage * scale, false)
    end

-- MOD: real_stamina

elseif mod_real_stamina and real_stamina ~= nil then
    unified_stamina.active_mod = "real_stamina"
    function unified_stamina.get_scale()
        return 20
    end

    function unified_stamina.get(playername)
        local player = minetest.get_player_by_name(playername)
        return (player:get_meta():get_int("real_stamina:level") or 20) / 20
    end

    function unified_stamina.add(playername, percentage)
        local player = minetest.get_player_by_name(playername)
        local change = math.round(percentage * 20)
        real_stamina.change(player, change)
    end

    function unified_stamina.set(playername, percentage)
        local player = minetest.get_player_by_name(playername)
        local current = unified_stamina.get(playername)
        local total = math.round(percentage * 20)
        local change = math.round(math.min(20, math.max(0, total - current)))
        real_stamina.change(player, change)
    end

-- MOD: cmo_stamina (from Combat & Movement Overhaul)

elseif mod_cmo_stamina and cmo ~= nil and cmo.stamina ~= nil then
    unified_stamina.active_mod = "cmo_stamina"
    function unified_stamina.get_scale()
        return 100
    end

    unified_stamina.get = cmo.stamina.get
    unified_stamina.set = cmo.stamina.set
    unified_stamina.add = cmo.stamina.add

-- FALLBACK

else
    unified_stamina.active = false
    unified_stamina.active_mod = "none"
    function unified_stamina.get_scale()
        return 100
    end
    function unified_stamina.get(playername) return 1 end
    function unified_stamina.add(playername, percentage) end
    function unified_stamina.set(playername, percentage) end
end
