fs = filesystem
gpu = computer.getGPUs()[1]
screen = computer.getScreens()[1]
gpu:bindScreen(screen)
gpu:setSize(150,50)

function string.split(tab, delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( tab, delimiter, from  )
    while delim_from do
        computer.skip()
        table.insert( result, string.sub( tab, from , delim_from-1 ) )
        from  = delim_to + 1
        delim_from, delim_to = string.find( tab, delimiter, from  )
    end
    table.insert( result, string.sub( tab, from  ) )
    return result
end

console = {}
console.lines = {}
console.commands = {}
console.cursorOffset = 0
console.cmdHistory = {}
console.historyCur = 0
console.hisSave = ''
console.size = {150,50}
console.scrollAmount = 0
console.border = 2
console.currentInput = ''
console.draws = 0
console.currentPath = ''
console.debug = false
console.mountPath = 'D'
console.runningProgram = nil

function console._WrapIt(item)
    return math.ceil(#item.str/console.size[1])
end
function console._FilterKeycode(kc, bkc, ckc)
    if kc == 65 then return ckc == 8 and 'A' or 'a'
    elseif kc == 66 then return ckc == 8 and 'B' or 'b'
    elseif kc == 67 then return ckc == 8 and 'C' or 'c'
    elseif kc == 68 then return ckc == 8 and 'D' or 'd'
    elseif kc == 69 then return ckc == 8 and 'E' or 'e'
    elseif kc == 70 then return ckc == 8 and 'F' or 'f'
    elseif kc == 71 then return ckc == 8 and 'G' or 'g'
    elseif kc == 72 then return ckc == 8 and 'H' or 'h' 
    elseif kc == 73 then return ckc == 8 and 'I' or 'i'
    elseif kc == 74 then return ckc == 8 and 'J' or 'j'
    elseif kc == 75 then return ckc == 8 and 'K' or 'k'
    elseif kc == 76 then return ckc == 8 and 'L' or 'l'
    elseif kc == 77 then return ckc == 8 and 'M' or 'm'
    elseif kc == 78 then return ckc == 8 and 'N' or 'n'
    elseif kc == 79 then return ckc == 8 and 'O' or 'o'
    elseif kc == 80 then return ckc == 8 and 'P' or 'p'
    elseif kc == 81 then return ckc == 8 and 'Q' or 'q'
    elseif kc == 82 then return ckc == 8 and 'R' or 'r'
    elseif kc == 83 then return ckc == 8 and 'S' or 's'
    elseif kc == 84 then return ckc == 8 and 'T' or 't'
    elseif kc == 85 then return ckc == 8 and 'U' or 'u'
    elseif kc == 86 then return ckc == 8 and 'V' or 'v'
    elseif kc == 87 then return ckc == 8 and 'W' or 'w'
    elseif kc == 88 then return ckc == 8 and 'X' or 'x'
    elseif kc == 89 then return ckc == 8 and 'Y' or 'y'
    elseif kc == 90 then return ckc == 8 and 'Z' or 'z'
    elseif kc == 32 then return " "
    elseif kc == 48 then return ckc == 8 and ')' or '0'
    elseif kc == 49 then return ckc == 8 and '!' or '1'
    elseif kc == 50 then return ckc == 8 and '@' or '2'
    elseif kc == 51 then return ckc == 8 and '#' or '3'
    elseif kc == 52 then return ckc == 8 and '$' or '4'
    elseif kc == 53 then return ckc == 8 and '%' or '5'
    elseif kc == 54 then return ckc == 8 and '^' or '6'
    elseif kc == 55 then return ckc == 8 and '&' or '7'
    elseif kc == 56 then return ckc == 8 and '*' or '8'
    elseif kc == 57 then return ckc == 8 and '(' or '9'
    elseif kc == 47 then return ckc == 8 and '?' or '/'
    elseif kc == 45 then return ckc == 8 and '_' or '-'
    elseif kc == 44 then return ckc == 8 and '<' or ','
    elseif kc == 46 then return ckc == 8 and '>' or '.'
    elseif kc == 13 then return 'RET'
    elseif kc == 8 then return 'BACK'
    elseif bkc == 37 then return 'LEFT'
    elseif bkc == 38 then return 'UP'
    elseif bkc == 39 then return 'RIGHT'
    elseif bkc == 40 then return 'DOWN'
    elseif kc == 27 then return 'ESC'
    elseif bkc == 33 then return 'PGUP'
    elseif bkc == 34 then return 'PGDWN'
    elseif bkc == 36 then return 'HOME'
    elseif bkc == 45 then return 'INS'
    elseif bkc == 20 then return 'CAPS'
    elseif kc == 9 then return 'TAB'
    elseif bkc == 35 then return 'END'
    elseif bkc == 46 then return 'DEL'
    elseif kc == 61 then return ckc == 8 and '+' or '='
    elseif kc == 91 then return ckc == 8 and '{' or '['
    elseif kc == 93 then return ckc == 8 and '}' or ']'
    elseif kc == 59 then return ckc == 8 and ':' or ';'
    elseif kc == 39 then return ckc == 8 and '"' or "'"
    elseif kc == 92 then return ckc == 8 and '|' or '\\'
    elseif kc == 96 then return ckc == 8 and '~' or '`'
    end
    return nil
end
function console.terminateProgram()
    local dyingWishes = console.runningProgram.terminate()
    console.printColor({0,0,0,1}, {0.1,0.1,0.8,1}, dyingWishes)
    console.runningProgram = nil
end
function console.printColor(...)
    local vars = {...}
    for i = 1, math.floor(#vars / 3) do
        local bg = vars[i*3 - 2]
        local fg = vars[i*3 - 1]
        local txt = vars[i*3]
        table.insert(console.lines, {str = tostring(txt) or '', bg = bg, fg = fg})
    end
end
function console.print(...)
    local vars = {...}
    local bg = {0,0,0,1}
    local fg = {1,1,1,1}
    for k,v in ipairs(vars) do
        table.insert(console.lines, {str = tostring(v) or '', bg = bg, fg = fg})
    end
end
function console.error(str)
    console.printColor({1,1,1,1}, {1,0,0,1}, str)
end
function console.prompt(msg)
    console.printColor({0,0,0,1}, {1,0,0,1}, msg)
    console.print('Please choose either `(y)es` to continue or `(n)o` to cancel.')
    event.listen(gpu)
    console.draw(true)
    gpu:flush()

    local found = false
    repeat
        local e, s, a = event.pull(0.1)
        if e == 'OnKeyDown' and a == 89 then
            found = true
            return true
        elseif e == 'OnKeyDown' and a == 78 then
            found = true
            return false
        end
    until found
    event.ignoreAll()
end

function console.draw(prompting)
    gpu:setBackground(1, 215/255, 0, 1)
    gpu:fill(0,0,console.size[1],console.size[2],' ')
    gpu:setBackground(.6, 150/255, 0, 1)
    gpu:fill(1,1,console.size[1]-2,console.size[2]-2,' ')
    
    local mWidth, mHeight = console.size[1] - (console.border * 2), console.size[2] - (console.border * 2) - 1
    gpu:setBackground(0,0,0,1)
    gpu:setForeground(1,1,1,1)
    gpu:fill(console.border, console.border, mWidth, mHeight + 1, " ")

    if console.runningProgram and not prompting then return end

    --Todo: Add some nice gold borders :D
    local hCounter = 0

    local i = 0
    while hCounter <= mHeight - 1 do
        local curItem = console.lines[#console.lines - i - console.scrollAmount]
        if not curItem then hCounter = mHeight break end
        local wordWrapTimes = console._WrapIt(curItem)

        gpu:setBackground(curItem.bg[1],curItem.bg[2],curItem.bg[3],curItem.bg[4])
        gpu:setForeground(curItem.fg[1],curItem.fg[2],curItem.fg[3],curItem.fg[4])

        local WrappedLines = {}
        for j = 1, wordWrapTimes do 
            local str = string.sub(curItem.str, ((j-1) * mWidth) + 1, math.min(j * mWidth, #curItem.str))
            gpu:setText(console.border, console.border + mHeight - 1 - hCounter - (math.abs(j - wordWrapTimes)), str)
        end

        hCounter = hCounter + wordWrapTimes
        i = i + 1
    end
    local addText = console.currentPath .. "> "
    local newText = string.sub(console.currentInput, math.min(#console.currentInput - mWidth - console.cursorOffset - #addText + 1, 1))
    if console.cursorOffset > 0 then
        local offset = math.min(#console.currentInput - mWidth - console.cursorOffset - #addText + 1, 1)
    else
        local newText = string.sub(console.currentInput, math.min(#console.currentInput - mWidth - #addText + 1, 1))
        end
    gpu:setBackground(0,0,0,1)
    gpu:setForeground(1,1,1,1)
    gpu:setText(console.border, console.border + mHeight, addText .. newText)
    gpu:setText(console.border + #addText + #newText - console.cursorOffset, console.border + mHeight, computer.time() % 2 >= 0.5 and '|' or ' ')
    gpu:flush()

    console.draws = console.draws + 1
end
function console.update()
    event.listen(gpu)
    e, s, a, b, c, d = event.pull(0.1)

    local keyFilter = console._FilterKeycode(a, b, c)
    
    if console.runningProgram and console.runningProgram.event then
        local success, error = pcall(function() console.runningProgram.event(e, keyFilter, a, b, c) end)
        if not success then
            console.runningProgram = nil
            console.error('Program died @ p.event(e, keyFilter, a, b, c): ')
            for k,v in ipairs(string.split(error, '\n')) do
                console.error(v)
            end
        end
    end

    if e ~= nil and console.debug then
        console.printColor({0,0,0,1},{1,0,0,1},tostring(e).." "..tostring(a).." "..tostring(b).." "..tostring(c).." "..tostring(d))
    end
    if not keyFilter then return end

    if e == 'OnKeyDown' then
        if keyFilter == 'RET' and not console.runningProgram then --Return/Enter
            console.scrollAmount = 0
            console.historyCur = 0
            console.hisSave = ''
            console.cursorOffset = 0
            console.execCommand()
        elseif keyFilter == 'BACK' and not console.runningProgram then --Backspace
            console.scrollAmount = 0
            local oneHalf = string.sub(console.currentInput, 1, #console.currentInput - console.cursorOffset)
            local otherHalf = string.sub(console.currentInput, #console.currentInput - console.cursorOffset + 1)
            console.currentInput = string.sub(oneHalf, 1, #oneHalf - 1) .. otherHalf
        
        elseif keyFilter == 'LEFT' and not console.runningProgram then --Left
            console.cursorOffset = math.min(console.cursorOffset + 1, #console.currentInput)
        elseif keyFilter == 'RIGHT' and not console.runningProgram then --Right
            console.cursorOffset = math.max(console.cursorOffset - 1, 0)
        elseif keyFilter == 'UP' and not console.runningProgram then --Up
            console.scrollAmount = 0
            if console.historyCur == 0 then console.hisSave = console.currentInput end
            console.historyCur = console.historyCur - 1
            if console.historyCur < 0 then console.historyCur = #console.cmdHistory end
            if console.historyCur == 0 then console.currentInput = console.hisSave else
                console.currentInput = console.cmdHistory[console.historyCur]
            end
        elseif keyFilter == 'DOWN' and not console.runningProgram then --Down
            console.scrollAmount = 0
            if console.historyCur == 0 then console.hisSave = console.currentInput end
            console.historyCur = console.historyCur + 1
            if console.historyCur > #console.cmdHistory then console.historyCur = 0 end
            if console.historyCur == 0 then console.currentInput = console.hisSave else
                console.currentInput = console.cmdHistory[console.historyCur]
            end
        elseif keyFilter == 'ESC' then --Esc
            console.scrollAmount = 0
            if console.runningProgram then
                console.terminateProgram()
            elseif console.cursorOffset > 0 then
                console.cursorOffset = 0
            elseif console.historyCur ~= 0 then
                console.historyCur = 0
                console.currentInput = console.hisSave
                console.hisSave = ''
            else
                console.currentInput = ''
            end
        elseif keyFilter == 'PGUP' and not console.runningProgram then --PGUP
            console.scrollAmount = console.scrollAmount + 1
            print(console.scrollAmount)
        elseif keyFilter == 'PGDWN' and not console.runningProgram then --PGDWN
            console.scrollAmount = math.max(console.scrollAmount - 1, 0)
        elseif not console.runningProgram then
            console.scrollAmount = 0
            if console.cursorOffset > 0 then
                local oneHalf = string.sub(console.currentInput, 1, #console.currentInput - console.cursorOffset)
                local otherHalf = string.sub(console.currentInput, #console.currentInput - console.cursorOffset + 1)
                console.currentInput = oneHalf .. keyFilter .. otherHalf
            else
                console.currentInput = console.currentInput .. keyFilter
            end
        end
    end
    event.ignoreAll()
end
function console.registerCommand(alias, help, subscribed, func)
    local newCommand = {aliases = {}, f = func, help = help, subscribed = subscribed or {}}
    for str in string.gmatch( alias,'%S+' ) do
        table.insert(newCommand.aliases, str)
    end
    if #newCommand.aliases < 1 then table.insert(newCommand.aliases, alias) end

    table.insert(console.commands, newCommand)
end
function console.execCommand()
    local command
    console.print(console.currentPath .. '> ' .. console.currentInput)
    if string.find(console.currentInput, ' ') then
        command = string.sub(console.currentInput, 1, string.find(console.currentInput, ' ') - 1)
    else
        command = console.currentInput
    end
    local foundAndRan = false
    for k,v in pairs(console.commands) do
        for i,j in pairs(v.aliases) do
            if string.lower(j) == string.lower(command) then
                local allParams = string.sub(console.currentInput, #j + 2)

                local finalSubs = {}
                for l,b in pairs(v.subscribed) do
                    local param = l
                    local help = b.help
                    local pFound = string.find(allParams, param)
                    if pFound then
                        local value = string.match(string.sub(allParams, pFound + #param), '%S+')
                        if value then
                            if type(1) == b.type then
                                if tonumber(value) then
                                    finalSubs[param] = tonumber(value)
                                else
                                    print('fek')
                                    console.error('Invalid parameter ' .. param .. ' supplied: ' .. value .. ' Expected: ' .. b.type)
                                    console.print(v.help)
                                    console.print('\t' .. param .. '\t' .. help)
                                    console.currentInput = ""
                                    return
                                end
                            elseif type(true) == b.type then
                                if string.lower(value) == 'true' then finalSubs[param] = true
                                elseif string.lower(value) == 'false' then finalSubs[param] = false 
                                else
                                    console.error('Invalid parameter ' .. param .. ' supplied: ' .. value .. ' Expected: ' .. b.type)
                                    console.print(v.help)
                                    console.print('\t' .. param .. '\t' .. help)
                                    console.currentInput = ""
                                    return
                                end
                            elseif type("sfd") == b.type then
                                finalSubs[param] = value
                            else
                                finalSubs[param] = value
                            end
                        end
                    end
                end
                foundAndRan = true
                v.f(finalSubs, allParams)
                break
            end
        end
    end
    if not foundAndRan then
        local noFileFound = true
        for k,v in pairs(fs.childs(console.currentPath)) do 
            if string.lower(command) == string.lower(v) then
                local _p = print
                _G.print = console.print
                noFileFound = false

                console.runningProgram = fs.doFile(console.currentPath .. v)
                if not console.runningProgram then console.error('Failed to open program!') end
                if console.runningProgram.init then
                    local kill = false
                    local success, error = pcall(function() kill = console.runningProgram.init(string.sub(console.currentInput, #command + 1)) end)

                    if kill then console.runningProgram = nil end
                    if not success then
                        console.runningProgram = nil
                        console.error('Program died @ p.init(vargs): ')
                        for k,v in ipairs(string.split(error, '\n')) do
                            console.error(v)
                        end
                    end
                end

                _G.print = _p

                break
            end
        end
        if noFileFound and fs.isFile(command) then
            local _p = print
            _G.print = console.print
            noFileFound = false

            console.runningProgram = fs.doFile(command)
            if not console.runningProgram then console.error('Failed to open program!') end
            if console.runningProgram.init then
                local kill
                local success, error = pcall(function() kill = console.runningProgram.init(string.sub(console.currentInput, #command + 1)) end)
                if kill then console.runningProgram = nil end
                if not success then
                    console.runningProgram = nil
                    console.error('Program died @ p.init(vargs): ')
                    for k,v in ipairs(string.split(error, '\n')) do
                        console.error(v)
                    end
                end
            end

            _G.print = _p
        end
        if noFileFound then console.error('No commands or files found with ' .. command .. ' alias') end
    end

    table.insert(console.cmdHistory, console.currentInput)
    console.currentInput = ''
end
function console.init()
    console.registerCommand('help ?', 'Will provide help sensai.', {}, function(vargs, rawVargs)
        for k,v in pairs(console.commands) do
            if #rawVargs > 1 and v.help then
                for i, j in pairs(v.aliases) do
                    if string.lower(j) == string.lower(rawVargs) then
                        console.print(table.concat( v.aliases, ", " ) .. ' - ' .. '\t' .. v.help)
                        for l,b in pairs(v.subscribed) do
                            console.print('\t' .. l .. '\t' .. b.type .. '\t' .. b.help)
                        end
                    end
                end
            elseif v.help then
                console.print(table.concat(v.aliases, ", ") .. ' - ' .. '\t' .. v.help)
            end
        end
    end)
    console.registerCommand('clear cls', 'Clears the screen.', {},  function(vargs)
        console.lines = {}
    end)
    console.registerCommand('ls list lsdir', 'List all current sub items.', {}, function(vargs)
        local allFiles = fs.childs(console.currentPath)
        for k,v in ipairs(allFiles) do
            console.printColor({0,0,0,1}, {0.8,0.8,0.8,1}, k .. "\t" .. v)
        end
    end)
    console.registerCommand('mount', 'Attempt to mount all sub items to a directory.', {}, function(vargs)
        for k,v in ipairs(fs.childs(console.currentPath)) do
            local mounted = fs.mount(console.currentPath .. v, console.currentPath .. 'mount' .. string.sub(v, 1, 5))
            console.print('Trying to mount ' .. console.currentPath .. v .. ' to ' .. console.currentPath .. 'mount' .. string.sub(v, 1, 5) .. '/...' .. (mounted and 'OK' or 'ERROR'))
        end
    end)
    console.registerCommand('cd', 'Change the current working directory.', {}, function(vargs, rawVargs)
        local canCD = fs.isDir(console.currentPath .. rawVargs)
        local altCD = fs.isDir(rawVargs)
        local alt2CD = rawVargs == console.mountPath
        if not canCD and not altCD and not alt2CD then
            console.print('Invalid folder path: ' .. rawVargs)
        elseif canCD then
            console.currentPath = console.currentPath .. rawVargs
            if string.sub(console.currentPath, #console.currentPath - 1) ~= '/' then
                console.currentPath = console.currentPath .. '/'
            end
        elseif altCD then
            console.currentPath = rawVargs
            if string.sub(console.currentPath, #console.currentPath - 1) ~= '/' then
                console.currentPath = console.currentPath .. '/'
            end
        elseif alt2CD then
            console.currentPath = console.mountPath .. '/'
        end
    end)
    console.registerCommand('debug', nil, nil, function(vargs) console.debug = not console.debug end)
    console.registerCommand('restart rs', 'Restart the machine.', {
        ['-t'] = {type = type(1), help = 'Restarts after the set amount of time.'}
    }, function(vargs)
        if vargs['-t'] then
            local time = computer.time() + vargs['-t'] * 10
            console.print('Starting timer. '.. math.floor((time - computer.time())/10) .. 's until restart.')
            while time > computer.time() do
                table.remove( console.lines, #console.lines )
                console.print('Starting timer. '.. math.floor((time - computer.time())/10) .. 's until shutdown.')
                console.draw()
            end
            computer.reset()
        else
            computer.reset()
        end
    end)
    console.registerCommand('resize sz', 'Resize the console window', {
        ['-w'] = {type = type(1), help = 'New width of the console.'},
        ['-h'] = {type = type(1), help = 'New height of the console.'},
        ['-g'] = {type = type(false), help = 'Should the GPU get resized as well'}
    }, function(vargs)
        if vargs['-w'] and vargs['-h'] then
            console.size = {vargs['-w'], vargs['-h']}
            if vargs['-g'] then
                gpu:setSize(vargs['-w'], vargs['-h'])
            end
        else
            console.error('Resize command requires valid -w and -h params.')
        end
    end)
    console.registerCommand('make mk', 'Create a new file', {
        ['-name'] = {type = type(' '), help = 'Name of the file you want to create.'},
        ['-path'] = {type = type(' '), help = 'Optional path to create the file at.'}
    }, function(vargs, rawVargs)
        if not vargs['-name'] then console.error('Make command requires a valid -name param!') return end
        local created
        if vargs['-path'] then 
            created = fs.open(vargs['-path'] .. vargs['-name'], 'w')
        else
            created = fs.open(console.currentPath .. '/' .. vargs['-name'], 'w')
        end

        if not created then console.error('Failed to make file with given params: ' .. rawVargs) end
        if created then created:close() end
    end)
    console.registerCommand('saveEEPROM sdd saveToDisk', 'Saves the EEPROM to the file specified by -name.', {
        ['-name'] = {type = type(' '), help = 'Name of the file to save to.'},
        ['-path'] = {type = type(' '), help = 'Optional path to the file specified by -name'}
    }, function(vargs, rawVargs)
        if not vargs['-name'] then console.error('saveToDisk command requires a valid -name param!') return end
        local cont = console.prompt('Are you sure you want to continue? This will overwrite the file!')
        if not cont then return end
        local created
        if vargs['-path'] then 
            created = fs.open(vargs['-path'] .. vargs['-name'], 'w')
        else
            created = fs.open(console.currentPath .. '/' .. vargs['-name'], 'w')
        end

        if not created then console.error('Failed to load file with given params: ' .. rawVargs) end
        if created then 
            created:write(computer.getEEPROM())
            created:close()
        end
    end)
    console.registerCommand('loadEEPROM ldd loadAsExtension', 'Loads the EEPROM as an extensions.', {}, 
    function(vargs, rawVargs)
        local EEPROM = computer.getEEPROM()
        local func, error = load(EEPROM)
        if not func then console.error('Can\'t load eeprom as extension: ') for k,v in ipairs(string.split(error, '\n')) do console.error(v) end return end
        local program
        local success, error = pcall(function() program = func() end)
        if not success then
            console.error('Can\'t load eeprom as extension: ')
            for k,v in ipairs(string.split(error, '\n')) do
                console.error(v)
            end
        else
            console.runningProgram = program
            local success, error = pcall(function() kill = console.runningProgram.init(rawVargs) end)
            if kill then console.runningProgram = nil end
            if not success then
                console.runningProgram = nil
                console.error('Program died @ p.init(vargs): ')
                for k,v in ipairs(string.split(error, '\n')) do
                    console.error(v)
                end
            end
        end
    end)
    console.registerCommand('printFile', 'Prints the specified file', {
        ['-name'] = {type = type(' '), help = 'Name of the file to print from.'},
        ['-path'] = {type = type(' '), help = 'Optional path to the file specified by -name'}
    }, function(vargs, rawVargs)
        if not vargs['-name'] then console.error('printFile command requires a valid -name param!') return end
        local created
        if vargs['-path'] then 
            created = fs.open(vargs['-path'] .. vargs['-name'], 'r')
        else
            created = fs.open(console.currentPath .. '/' .. vargs['-name'], 'r')
        end

        if not created then console.error('Failed to load file with given params: ' .. rawVargs) end
        if created then 
            for k in string.gmatch(created:read('*all'), '[^\r\n]+') do
                console.printColor({0.3,0.3,0.8,1}, {1, 1, 1, 1}, k)
                computer.skip()
            end
            created:close()
        end
    end)
    console.registerCommand('remove rm', 'Removes a file or folder', {
        ['-name'] = {type = type(' '), help = 'Name of the file or folder you want to remove.'},
        ['-path'] = {type = type(' '), help = 'Optional path to remove the file or folder from.'}
    }, function(vargs, rawVargs)
        if not vargs['-name'] then console.error('Remove command requires a valid -name param!') return end
        local path
        if vargs['-path'] then 
            path = vargs['-path'] .. vargs['-name']
        else
            path = console.currentPath .. '/' .. vargs['-name']
        end

        local canCont = console.prompt('Are you sure you want to delete ' .. path .. '?')
        if not canCont then return end
        local created = fs.remove(path)
        if not created then console.error('Failed to remove file or folder with given params: ' .. rawVargs) end
    end)
    console.registerCommand('mkdir makedir', 'Create a new directory', {
        ['-name'] = {type = type(' '), help = 'Name of the file you want to create.'},
        ['-path'] = {type = type(' '), help = 'Optional path to create the file at.'}
    }, function(vargs, rawVargs)
        if not vargs['-name'] then console.error('Make command requires a valid -name param!') return end
        local path
        if vargs['-path'] then 
            path = vargs['-path'] .. vargs['-name']
        else
            path = console.currentPath .. '/' .. vargs['-name']
        end

        local created = fs.createDir(path)
    end)
    console.printColor({0,0,0,1}, {1, 215/255, 0, 1}, 'Initializing filesystem as "'..console.mountPath..'/"...' .. (fs.initFileSystem(console.mountPath) and 'OK' or 'ERROR'))
    console.currentPath = 'D/'
end

function console.dispatcher()
    console.draw()
    console.update()
    if console.runningProgram then
        if console.runningProgram.draw then
            
            local success, error = pcall(function() console.runningProgram.draw() end)
            if not success then
                console.runningProgram = nil
                console.error('Program died @ p.draw(): ')
                for k,v in ipairs(string.split(error, '\n')) do
                    console.error(v)
                end
                return
            end
        end
        if console.runningProgram.update then
            local success, error = pcall(function() console.runningProgram.update() end)
            if not success then
                console.runningProgram = nil
                console.error('Program died @ p.update(): ')
                for k,v in ipairs(string.split(error, '\n')) do
                    console.error(v)
                end
                return
            end
            local kill = console.runningProgram.update()
            if kill then console.runningProgram = nil end
        end
    end
end


console.init()
while true do
    console.dispatcher()
end