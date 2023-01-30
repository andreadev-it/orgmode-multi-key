local M = {}

local org_mappings = require('orgmode.org.mappings')

-- This function will be used instead of treesitter to find links
local is_link = function ()
    local is_link = org_mappings._get_link_under_cursor()
    if is_link == nil then
       return nil
    end

    return true
end


local type_to_action = {
    [is_link] = "org_mappings.open_at_point",
    timestamp = "org_mappings.change_date",
    headline = "org_mappings.todo_next_state",
    listitem = "org_mappings.toggle_checkbox",
    list = "org_mappings.toggle_checkbox",
    _default = "org_mappings.open_at_point"
}


local function get_action_from_type()
    local ts_utils = require('nvim-treesitter.ts_utils')
    local cur_node = ts_utils.get_node_at_cursor()
    local cur_row = cur_node:range()

    while cur_node ~= nil do
        local nodetype = cur_node:type()

        for identifier, action in pairs(type_to_action) do
            if type(identifier) == "function" then
                if identifier() ~= nil then
                    return action
                end
            elseif nodetype == identifier and identifier ~= "_default" then
                return action
            end
        end

        cur_node = cur_node:parent()
        if cur_node == nil then
            break
        elseif cur_node:range() ~= cur_row then
            break
        end
    end

    return type_to_action._default
end

local function toggle_org_item()
    local org = require('orgmode')

    local action = get_action_from_type()

    if action ~= nil then
        org.action(action)
    end
end


local function setup(settings)
    settings = settings or {}
    local key = settings.key or "<cr>"

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "org",
        callback = function()
            vim.api.nvim_buf_set_keymap( 0, 'n', key, "", {
               callback = function ()
                   toggle_org_item()
               end,
               noremap = true
            })
        end
    })
end

return M
