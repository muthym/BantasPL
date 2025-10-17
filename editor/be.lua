-- Bantas Editor (c) 2025 Jon Velasco (muthym)
-- Usage: lua be.lua <filename>

local args = {...}
if #args < 1 then
    print("Usage: lua be.lua <filename>")
    os.exit()
end

local filename = args[1]
local lines = {}
local current = 1
local modified = false

-- Read file
local f = io.open(filename, "r")
if f then
    for l in f:lines() do table.insert(lines, l) end
    f:close()
else
    lines = {""}
end

-- Display the file content
local function display()
    os.execute("clear")
    print("File: " .. filename .. (modified and "  *modified*" or ""))
    print(string.rep("-", 40))
    local width = tonumber(os.getenv("COLUMNS")) or 80
    for i, l in ipairs(lines) do
        local line = tostring(l)
        while #line > width do
            print(string.format("%3d | %s", i, line:sub(1, width)))
            line = "    " .. line:sub(width + 1)
        end
        print(string.format("%3d | %s", i, line))
    end
    print(string.rep("-", 40))
    io.write(string.format("Line %d/%d > ", current, #lines))
end

-- Save file
local function save_file()
    local f = io.open(filename, "w")
    for _, l in ipairs(lines) do f:write(l .. "\n") end
    f:close()
    modified = false
    print("(saved)")
    os.execute("sleep 1")
end

-- Show help
local function show_help()
    print([[
Commands:
  n, p, N          Move between lines
  e, eN            Edit line
  /old/new         Replace text
  text1/text2      Insert after match
  a, i, iN         Append or insert line
  d, dN            Delete line
  s                Save file
  r                Run current file with Bantas interpreter
  q, Q             Quit editor
  ?                Help
]])
    io.write("Press Enter to continue...")
    io.read()
end

-- Main loop
while true do
    display()
    local cmd = io.read()
    if not cmd then break end
    cmd = cmd:gsub("^%s+", "")
    cmd = cmd:lower()  -- make all commands case-insensitive

    if cmd == "q" then
        if modified then
            io.write("Unsaved changes! Quit anyway? (y/N): ")
            local ans = io.read()
            if ans:lower() ~= "y" then goto continue end
        end
        break

    elseif cmd == "s" then
        save_file()

    elseif cmd == "?" then
        show_help()

    elseif cmd == "n" then
        if current < #lines then current = current + 1 end

    elseif cmd == "p" then
        if current > 1 then current = current - 1 end

    elseif cmd:match("^%d+$") then
        local num = tonumber(cmd)
        if num >= 1 and num <= #lines then current = num end

    elseif cmd:match("^e%d+$") then
        local num = tonumber(cmd:match("%d+"))
        if num and lines[num] then
            io.write(":" .. lines[num] .. "\n> ")
            local new = io.read() or ""
            lines[num] = new
            modified = true
        end

    elseif cmd == "e" then
        io.write(":" .. lines[current] .. "\n> ")
        local new = io.read() or ""
        lines[current] = new
        modified = true

    elseif cmd:match("^i%d+$") then
        local num = tonumber(cmd:match("%d+"))
        if num and num >= 1 and num <= #lines + 1 then
            io.write("Insert before line " .. num .. ": ")
            local new = io.read() or ""
            table.insert(lines, num, new)
            modified = true
        end

    elseif cmd == "i" then
        io.write("Insert before line " .. current .. ": ")
        local new = io.read() or ""
        table.insert(lines, current, new)
        modified = true

    elseif cmd == "a" then
        io.write("Append after line " .. current .. ": ")
        local new = io.read() or ""
        table.insert(lines, current + 1, new)
        modified = true
        current = current + 1

    elseif cmd:match("^d%d+$") then
        local num = tonumber(cmd:match("%d+"))
        if num and lines[num] then
            table.remove(lines, num)
            modified = true
            if current > #lines then current = #lines end
        end

    elseif cmd == "d" then
        table.remove(lines, current)
        if #lines == 0 then lines = {""} end
        if current > #lines then current = #lines end
        modified = true

    elseif cmd:match("^/.+/.+") then
        local old, new = cmd:match("^/(.+)/(.+)$")
        if old and new then
            lines[current] = lines[current]:gsub(old, new)
            modified = true
        end

    elseif cmd:match("^.+/.+$") then
        local t1, t2 = cmd:match("^(.+)/(.-)$")
        if t1 and t2 then
            local pos = lines[current]:find(t1, 1, true)
            if pos then
                lines[current] = lines[current]:sub(1, pos + #t1 - 1) .. t2 .. lines[current]:sub(pos + #t1)
                modified = true
            end
        end

    elseif cmd == "r" then
        if modified then save_file() end
        print("Running with Bantas interpreter...\n")
        os.execute("./bantas " .. filename)
        io.write("\nPress Enter to return to editor...")
        io.read()

    else
        -- Ignore invalid input
    end

    ::continue::
end

os.execute("clear")
print("Exited editor.")
