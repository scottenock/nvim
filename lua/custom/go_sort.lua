local M = {}
local ts = vim.treesitter

function M.sort_functions()
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = ts.get_parser(bufnr)
  
  if not parser then
    vim.notify("No treesitter parser available for this buffer", vim.log.levels.WARN)
    return
  end
  
  local tree = parser:parse()[1]
  if not tree then
    vim.notify("Failed to parse buffer", vim.log.levels.ERROR)
    return
  end
  
  local root = tree:root()
  local lang = parser:lang()
  
  -- Only support Go files
  if lang ~= "go" then
    vim.notify("This command only supports Go files", vim.log.levels.WARN)
    return
  end
  
  -- Query for Go functions, methods, and types
  local query_str = [[
    (function_declaration) @func
    (method_declaration) @method
    (type_declaration) @type
  ]]
  
  local query = ts.query.parse(lang, query_str)
  local items = {}
  
  -- Helper to check if exported (starts with uppercase in Go)
  local function is_exported(name)
    return name and name:sub(1,1):match("[A-Z]") ~= nil
  end
  
  -- Helper to extract receiver type from method
  local function get_receiver_type(text)
    -- func (r *Receiver) MethodName or func (r Receiver) MethodName
    local receiver = text:match("func%s+%([^)]*%*?([%w_]+)%)%s+")
    return receiver
  end
  
  -- Collect all items with their positions
  for id, node in query:iter_captures(root, bufnr, 0, -1) do
    local capture_name = query.captures[id]
    local start_row, start_col, end_row, end_col = node:range()
    
    -- Look for comments above the item
    local comment_start = start_row
    local check_row = start_row - 1
    
    -- Walk backwards to find comments
    while check_row >= 0 do
      local line = vim.api.nvim_buf_get_lines(bufnr, check_row, check_row + 1, false)[1]
      if line and line:match("^%s*//") then
        comment_start = check_row
        check_row = check_row - 1
      elseif line and line:match("^%s*$") then
        check_row = check_row - 1
      else
        break
      end
    end
    
    -- Get the full text including comments
    local lines = vim.api.nvim_buf_get_lines(bufnr, comment_start, end_row + 1, false)
    local text = table.concat(lines, "\n")
    
    -- Extract name for sorting
    local item_line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
    local name
    
    if capture_name == "method" then
      name = item_line:match("func%s+%([^)]+%)%s+([%w_]+)")
    elseif capture_name == "func" then
      name = item_line:match("func%s+([%w_]+)")
    elseif capture_name == "type" then
      name = item_line:match("type%s+([%w_]+)")
    end
    
    if name then
      local item = {
        name = name,
        text = text,
        start_row = comment_start,
        end_row = end_row,
        capture_type = capture_name,
        is_exported = is_exported(name),
        receiver_type = capture_name == "method" and get_receiver_type(text) or nil,
      }
      
      table.insert(items, item)
    end
  end
  
  if #items == 0 then
    vim.notify("No functions or types found to sort", vim.log.levels.INFO)
    return
  end
  
  -- Separate exported and unexported items
  local exported_items = {}
  local unexported_items = {}
  
  for _, item in ipairs(items) do
    if item.is_exported then
      table.insert(exported_items, item)
    else
      table.insert(unexported_items, item)
    end
  end
  
  -- Helper to sort items keeping types with their methods
  local function sort_with_type_grouping(item_list)
    local type_groups = {}
    local standalone = {}
    
    -- Build type groups
    for _, item in ipairs(item_list) do
      if item.capture_type == "type" then
        type_groups[item.name] = {
          type_def = item,
          methods = {},
        }
      end
    end
    
    -- Assign methods to their types
    for _, item in ipairs(item_list) do
      if item.receiver_type and type_groups[item.receiver_type] then
        table.insert(type_groups[item.receiver_type].methods, item)
      elseif item.capture_type ~= "type" then
        table.insert(standalone, item)
      end
    end
    
    -- Collect and sort type groups by type name
    local sorted_groups = {}
    for _, group in pairs(type_groups) do
      table.insert(sorted_groups, group)
    end
    table.sort(sorted_groups, function(a, b)
      return a.type_def.name:lower() < b.type_def.name:lower()
    end)
    
    -- Sort standalone functions by name
    table.sort(standalone, function(a, b)
      return a.name:lower() < b.name:lower()
    end)
    
    -- Build result: types with methods, then standalone functions
    local result = {}
    for _, group in ipairs(sorted_groups) do
      table.insert(result, group.type_def)
      for _, method in ipairs(group.methods) do
        table.insert(result, method)
      end
    end
    for _, item in ipairs(standalone) do
      table.insert(result, item)
    end
    
    return result
  end
  
  -- Sort exported and unexported separately
  local sorted_exported = sort_with_type_grouping(exported_items)
  local sorted_unexported = sort_with_type_grouping(unexported_items)
  
  -- Combine: exported first, then unexported
  items = {}
  for _, item in ipairs(sorted_exported) do
    table.insert(items, item)
  end
  for _, item in ipairs(sorted_unexported) do
    table.insert(items, item)
  end
  
  -- Replace items in buffer
  -- Work backwards to maintain line numbers
  local original_items = {}
  for _, item in ipairs(items) do
    table.insert(original_items, item)
  end
  
  table.sort(original_items, function(a, b)
    return a.start_row > b.start_row
  end)
  
  -- Delete all blocks
  for _, item in ipairs(original_items) do
    vim.api.nvim_buf_set_lines(bufnr, item.start_row, item.end_row + 1, false, {})
  end
  
  -- Insert sorted items
  local insert_pos = original_items[#original_items].start_row
  for i, item in ipairs(items) do
    local lines = vim.split(item.text, "\n")
    vim.api.nvim_buf_set_lines(bufnr, insert_pos, insert_pos, false, lines)
    insert_pos = insert_pos + #lines
    
    -- Add blank line between items (except after last one)
    if i < #items then
      vim.api.nvim_buf_set_lines(bufnr, insert_pos, insert_pos, false, {""})
      insert_pos = insert_pos + 1
    end
  end
  
  vim.notify("Sorted " .. #items .. " items", vim.log.levels.INFO)
end

-- Create the command
vim.api.nvim_create_user_command('SortFunctions', M.sort_functions, {})

return M
