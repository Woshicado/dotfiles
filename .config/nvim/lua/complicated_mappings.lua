local utils = require("utils")


local map = vim.keymap.set

-- Right click menu
-- Keyboard users
vim.keymap.set("n", "<C-t>", function()
  require("menu").open("default")
end, {})

-- mouse users + nvimtree users!
vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
  require('menu.utils').delete_old_menus()

  vim.cmd.exec '"normal! \\<RightMouse>"'

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  require("menu").open(options, { mouse = true })
end, {})


-- Toggle checkbox in markdown [ ] <--> [x]
-- map(
--   {'n' },
--   '<leader>tt',
--   function()
--     local line = vim.api.nvim_get_current_line()
--     local modified_line = line:gsub("(- %[)(.)(%])",
--       function(prefix, checkbox, postfix)
--         checkbox = (checkbox == " ") and "x" or " "
--         return prefix .. checkbox .. postfix
--     end)
--     vim.api.nvim_set_current_line(modified_line)
--   end,
--   {
--     desc = 'ftplugin - toggle checkboxes',
--     buffer = true,
--   }
-- )

-- don't copy empty lines on deletion
map(
  'n',
  'dd',
  function()
    return utils.is_empty_line() and '"_dd' or 'dd'
  end,
  {
    expr = true,
    desc = "delete blank lines to black hole register",
  }
)


--
local function is_in_list()
  local current_line = vim.api.nvim_get_current_line()
  return current_line:match('^%s*[%*-+]%s') ~= nil
end

local function has_checkbox()
  local current_line = vim.api.nvim_get_current_line()
  return current_line:match('%s*[%*-+]%s%[[ x]%]') ~= nil
end

local function list_prefix()
  local line = vim.api.nvim_get_current_line()
  local list_char = line:gsub("^%s*([-%*+] )(.*)",
    function(prefix, rest)
      return prefix
    end)
  return list_char
end

local function is_in_num_list()
  local current_line = vim.api.nvim_get_current_line()
  return current_line:match('^%s*%d+%.%s') ~= nil
end

vim.keymap.set('i', '<cr>', function()
  if is_in_list() then
    local prefix = list_prefix()
    return has_checkbox() and '<cr>' .. prefix .. '[ ] ' or '<cr>' .. prefix
  elseif is_in_num_list() then
    local line = vim.api.nvim_get_current_line()
    local modified_line = line:gsub("^%s*(%d+)%.%s.*$",
      function(numb)
        numb = tonumber(numb) + 1
        return tostring(numb)
      end)
    return '<cr>' .. modified_line .. '. '
  else
    return '<cr>'
  end
end, {
  buffer = true,
  expr = true,
})

vim.keymap.set(
  'n',
  'o',
  function()
    if is_in_list() then
      local prefix = list_prefix()
      return has_checkbox() and 'o' .. prefix .. '[ ] ' or 'o' .. prefix
  elseif is_in_num_list() then
    local line = vim.api.nvim_get_current_line()
    local modified_line = line:gsub("^%s*(%d+)%.%s.*$",
      function(numb)
        numb = tonumber(numb) + 1
        return tostring(numb)
      end)
    return 'o' .. modified_line .. '. '
    else
      return 'o'
    end
  end, {
    buffer = true,
    expr = true,
  })

vim.keymap.set('n', 'O', function()
  if is_in_list() then
    local prefix = list_prefix()
    return has_checkbox() and 'O' .. prefix .. '[ ] ' or 'O' .. prefix
  elseif is_in_num_list() then
    local line = vim.api.nvim_get_current_line()
    local modified_line = line:gsub("^%s*(%d+)%.%s.*$",
      function(numb)
        numb = tonumber(numb) + 1
        return tostring(numb)
      end)
    return 'O' .. modified_line .. '. '
  else
    return 'O'
  end
end, {
  buffer = true,
  expr = true,
})









