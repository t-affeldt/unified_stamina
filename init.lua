local mod_hudbars = minetest.get_modpath("hudbars") ~= nil
local mod_hbsprint = minetest.get_modpath("hbsprint") ~= nil
local mod_sprint = minetest.get_modpath("sprint") ~= nil

unified_stamina = {}

-- MOD: hbsprint

if mod_hbsprint then
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

elseif minetest_wadsprint ~= nil then
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

elseif sprint_lite ~= nil then
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

elseif real_stamina ~= nil then
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

-- FALLBACK

else
    function unified_stamina.get_scale()
        return 100
    end
    function unified_stamina.get(playername) return 1 end
    function unified_stamina.add(playername, percentage) end
    function unified_stamina.set(playername, percentage) end
end
