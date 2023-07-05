RemoveCallbacks()

function file_exists(filename)
    local f = io.open(filename, "r")
        if f ~= nil then
            io.close(f)
            return true
        else
            return false
        end
end

function notif(text)
    var = {}
    var[0] = "OnTextOverlay"
    var[1] = text
    var.netid = -1
    SendVarlist(var)
end

if file_exists("C:/config.lua") == false then
    notif([[
`9Config File Not Found
   `2Creating One...   ]])
    local config = io.open("C:/config.lua", "w")
    config:write("config = {\n")
    config:write("TaxAmount = 5,\n")
    config:write("TeleX = 0,\n")
    config:write("TeleY = 0,\n")
    config:write("CekGems = true,\n")
    config:write("pull = 0,\n")
    config:write("kick = 0,\n")
    config:write("ban = 0,\n")
    config:write("trade = 0,\n")
    config:write("telephone = 0,\n")
    config:write("drop = 0,\n")
    config:write("trash = 0,\n")
    config:write('fast = "false",\n')
    config:write("autoTelephone = true,\n")
    config:write("blockSDB = true,\n")
    config:write("p1 = {x = 0,y = 0},\n")
    config:write("p2 = {x = 0,y = 0},\n")
    config:write("}\nreturn config")
    config:close()
end

config = io.open("C:/config.lua", "r")
dofile("C:/config.lua")

TaxAmount = config.TaxAmount
TeleX = config.TeleX
TeleY = config.TeleY
CekGems = config.CekGems
pull = config.pull
kick = config.kick
ban = config.ban
trade = config.trade
telephone = config.telephone
drops = config.drop
trash = config.trash
fast = config.fast
autoTelephone = config.autoTelephone
blockSDB = config.blockSDB
p1x,p1y,p2x,p2y = config.p1.x,config.p1.y,config.p2.x,config.p2.y

breaks = false
spam = false
autoBuy = 0
customPos = 0
autoBuyPos = {
    x = 0,
    y = 0
}

function save()
    local config = io.open("C:/config.lua", "w")
    if config then
        config:write("config = {\n")
        config:write("TaxAmount = "..TaxAmount..",\n")
        config:write("TeleX = "..TeleX..",\n")
        config:write("TeleY = "..TeleY..",\n")
        config:write("CekGems = "..tostring(CekGems)..",\n")
        config:write("pull = "..pull..",\n")
        config:write("kick = "..kick..",\n")
        config:write("ban = "..ban..",\n")
        config:write("trade = "..trade..",\n")
        config:write("telephone = "..telephone..",\n")
        config:write("drop = "..drops..",\n")
        config:write("trash = "..trash..",\n")
        config:write('fast = "'..fast..'",\n')
        config:write("autoTelephone = "..tostring(autoTelephone)..",\n")
        config:write("blockSDB = "..tostring(blockSDB)..",\n")
        config:write("p1 = {x = "..p1x..",y = "..p2y.."},\n")
        config:write("p2 = {x = "..p2x..",y = "..p2y.."},\n")
        config:write("}\nreturn config")
        config:close()
        notif("`9Save `2Success")
    end
end

function drop (id, amount)
    SendPacket(2,"action|dialog_return\ndialog_name|drop\nitem_drop|"..id.."|\nitem_count|"..amount)
end

function convert(x,y)
    if GetTile(x,y).fg == 3898 and ceklock(1796) >= 100 then
        SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785\nx|"..x.."|\ny|"..y.."|\nbuttonClicked|bglconvert")
        notif("`9Convert `2Success")
    else
        notif("`9Convert `4Fail")
    end
end

function collect(oid,x,y)   
    pkt = {}
    pkt.type = 11
    pkt.int_data = oid
    pkt.pos_x = x
    pkt.pos_y = y
    SendPacketRaw(pkt)
end

function take(x,y)
    for _,obj in pairs(GetObjects()) do
        if math.floor(obj.pos_x/32) == x and math.floor(obj.pos_y/32) == y then
            collect(obj.oid,obj.pos_x,obj.pos_y)
        end
    end
end

function cekobjlock(x,y)
    for _, obj in pairs(GetObjects()) do
        if obj.id == 242 or obj.id == 1796 or obj.id == 7188 then
            if math.floor(obj.pos_x/32) == x and math.floor(obj.pos_y/32) == y then
                return true
            end
        end
    end
    return false
end

function wd(amount)
    SendPacket(2, "action|dialog_return\ndialog_name|bank_withdraw\nbgl_count|"..amount)
end

function depo(amount)
    SendPacket(2, "action|dialog_return\ndialog_name|bank_deposit\nbgl_count|"..amount)
end

function shatter(id)
    pkt = {}
    pkt.type = 10
    pkt.int_data = id
    SendPacketRaw(pkt)
end

function ceklock(id)
    for _, inv in pairs(GetInventory()) do
        if inv.id == id then
            return inv.count
        end
    end
    return 0
end

function LogToConsole(text)
    var = {
        [0] = "OnConsoleMessage",
        [1] = "`1[`4Ret `2Proxy`1] "..text,
        netid = -1
    }
    SendVarlist(var)
end

function cd(amount)
RunThread(function()
    local bgl = 0
    local dl = 0
    local wl = 0
    if amount >= 10000 then
        bgl = amount // 10000
        dl = (amount - bgl * 10000) // 100
        wl = amount % 100
    elseif amount < 10000 then
        dl = amount // 100
        wl = amount % 100
    end
    isCdRunning = true
    if ceklock(1796) < dl then
        repeat
            shatter(7188)
            Sleep(50)
        until ceklock(1796) >= dl
        Sleep(100)
        drop(7188,bgl)
        Sleep(100)
        drop(1796,dl)
        Sleep(100)
        drop(242,wl)
    elseif ceklock(242) < wl then
        repeat
            shatter(1796)
            Sleep(50)
        until ceklock(242) >= wl
        Sleep(100)
        drop(7188,bgl)
        Sleep(100)
        drop(1796,dl)
        Sleep(100)
        drop(242,wl)
    else
        Sleep(100)
        drop(7188,bgl)
        Sleep(100)
        drop(1796,dl)
        Sleep(100)
        drop(242,wl)
    end
    isCdRunning = false
end)
end

AddCallback("block","OnVarlist" ,function(var,packet)
if var[0] == "OnDialogRequest" and var[1]:find("end_dialog|bank_withdraw") then
    var[1]:gsub("`$","")
    x = var[1]:match("you have (.*) in the bank")
    Sleep(500)
    SendPacket(2, "action|dialog_return\ndialog_name|bank_withdraw\nbgl_count|"..x)
    return true
elseif var[0] == "OnDialogRequest" and var[1]:find("end_dialog|telephone|Hang Up||") then
    return true
elseif var[0] == "OnDialogRequest" and var[1]:find("add_button|pull") then
    return true
elseif var[0] == "OnDialogRequest" and var[1]:find("Dial a number to call somebody in Growtopia") and fast == "telephone" then
    RunThread(function ()
        TeleX = tonumber(var[1]:match("embed_data|x|(.*)embed_data"))
        TeleY = tonumber(var[1]:match("embed_data|y|(.*)add_label"))
        convert(TeleX,TeleY)
    end)
    return true
elseif var[0] == "OnSDBroadcast" and blockSDB then
    return true
elseif var[0] == "OnDialogRequest" and fast == "trash" and var[1]:find("end_dialog|trash") then
    if var[1]:find("embed_data|item_trash|(-%d+)") then
        local id = tonumber(var[1]:match("embed_data|item_trash|(-%d+)"))
        local amount = var[1]:match("you have (.*)|left|")
        SendPacket(2,"action|dialog_return\ndialog_name|trash\nitem_trash|"..id.."|\nitem_count|"..amount)
    else
        local id = tonumber(var[1]:match("embed_data|item_trash|(%d+)"))
        local amount = var[1]:match("you have (.*)|left|")
        SendPacket(2,"action|dialog_return\ndialog_name|trash\nitem_trash|"..id.."|\nitem_count|"..amount)
    end
    return true
elseif var[0] == "OnDialogRequest" and fast == "drop" and var[1]:find("How many to drop?") then
    if var[1]:find("embed_data|item_drop|(-%d+)") then
        local id = tonumber(var[1]:match("embed_data|item_drop|(-%d+)"))
        local amountDrop = var[1]:match("you have (.*)|left|")
        drop(id,amountDrop)
    else
        local id = tonumber(var[1]:match("embed_data|item_drop|(%d+)"))
        local amountDrop = var[1]:match("you have (.*)|left|")
        drop(id,amountDrop)
    end
    return true
elseif var[0] == "OnTextOverlay" and var[1]:find("You don't have enough of those!") then
    return true
elseif var[0] == "OnDialogRequest" and var[1]:find("end_dialog|telephone") and autoBuy == 1 then
    return true
end
end)

function autoDlMenu()
    local menu = [[
add_label_with_icon|big|`2AUTO `eBUY `1DL|left|7188|
add_spacer|small|
add_textbox|Stand In Front Of Telephone Or Use Already Set Tele Pos|
add_checkbox|enable|Enable Auto Buy|]]..autoBuy..[[|
add_checkbox|customPos|Custom Pos|]]..customPos..[[|
add_textbox|Already Set Pos `1[`2]]..TeleX..[[`1,`2]]..TeleY..[[`1]|
add_quick_exit|
end_dialog|autodl|Cancel|Ok
    ]]
    local var = {
        [0] = "OnDialogRequest",
        [1] = menu,
        netid = -1
    }
    SendVarlist(var)
end

function bubble(text)
    var = {}
    var[0] = "OnTalkBubble"
    var[1] = GetLocal().netid
    var[2] = text
    var.netid = -1
    SendVarlist(var)
end

function fastMenu()
    var = {}
    var[0] = "OnDialogRequest"
    var[1] = "add_label_with_icon|big|Fast Wrench Menu|left|32\nadd_label|small| |left\nadd_checkbox|pull|Fast Pull|"..pull.."\nadd_checkbox|kick|Fast kick|"..kick.."\nadd_checkbox|ban|Fast ban|"..ban.."\nadd_checkbox|trade|Fast Trade|"..trade.."\nadd_checkbox|telephone|Fast Convert|"..telephone.."\nadd_checkbox|drop|Fast Drop|"..drops.."\nadd_checkbox|trash|Fast trash|"..trash.."\nadd_quick_exit|\nend_dialog|fast|Cancel|Ok"
    var.netid = -1
    SendVarlist(var)
end

function fasts(tipe,netid)
if tipe == "pull" then
    SendPacket(2,"action|dialog_return\ndialog_name|popup\nnetID|"..netid.."|\nbuttonClicked|pull")
elseif tipe == "kick" then
    SendPacket(2,"action|dialog_return\ndialog_name|popup\nnetID|"..netid.."|\nbuttonClicked|kick")
elseif tipe == "ban" then
    SendPacket(2,"action|dialog_return\ndialog_name|popup\nnetID|"..netid.."|\nbuttonClicked|world_ban")
elseif tipe == "trade" then
    SendPacket(2,"action|dialog_return\ndialog_name|popup\nnetID|"..netid.."|\nbuttonClicked|trade")
end
end

local help = [[set_default_color|`3
add_label_with_icon|big|`4RET `ePROXY|left|7188|
add_spacer|small|
add_label_with_icon|small|`1This Script Made By ret7940|left|482|
add_label_with_icon|small|`1Yang Resell Semoga Jadi Yatim Dan Masuk Neraka :D|left|482|
add_label_with_icon|small|`1Link Discord : `2https://linktr.ee/retscript|left|482
add_spacer|small|
add_label_with_icon|small|`eMain|left|14214
add_textbox|/ret {to preview proxy command}|left|
add_textbox|/dd [amount] {to drop DL according to the amount}|left|
add_textbox|/cd [amount] {to drop DL and WL according to the amount}|left|
add_textbox|/db [amount] {to drop BGL according to the amount}|left|
add_textbox|/depo [amount] {to depo BGL according to the amount}|left|
add_textbox|/dpa {to depo all BGL in inventory}|left|
add_textbox|/wd [amount] {to withdraw BGL according to the amount}|left|
add_textbox|/wda {to withdraw all bgl in bank}|left|
add_textbox|/daw {to drop all BGL DL and WL in inventory}|left|
add_textbox|/terminate {to terminate/stop the script `p(i recomend use this)`3}|left|
add_spacer|small|
add_label_with_icon|small|`eHoster|left|758|
add_textbox|/tax [amount] {to set tax count`3}|left|
add_textbox|/ctax {to check current tax`3}|left|
add_textbox|/cgems {to turn on/off check gems `p(default is on)`3}|left|
add_textbox|/p1 {to set player 1 dbox}|left|
add_textbox|/p2 {to set player 2 dbox}|left|
add_textbox|/tp {to take bet and auto eat tax `p(dont forget to set player pos)`3}|left|
add_textbox|/w1 {to drop bet to player 1 and auto tax}|left|
add_textbox|/w2 {to drop bet to player 2 and auto tax}|left|
add_spacer|small|
add_label_with_icon|small|`eOther Features|left|2
add_textbox|/c {to convert DL to BGL `p(dont forget set telephone pos)`3}|left|
add_textbox|/config {to check current setting}|left|
add_textbox|/wm {to open fast wrench menu}|left|
add_textbox|/save {to save proxy settings}|left|
add_textbox|/relog {to reenter current world}|left|
add_textbox|/spam {to turn on auto spam in cheat menu}|left|
add_textbox|/block {to block fucking SDB}|left|
add_textbox|/setphone {to set telephon pos}|left|
add_textbox|/telephone {to set auto convert on/off}|left|
add_textbox|/autodl {to open auto buy dl menu}|left|
add_spacer|small|
add_button|discord|`eDISCORD `3SERVER|noflags|0|0|
add_spacer|small|
add_quick_exit|
end_dialog|help|Cancel|Ok|
]]

AddCallback("help","OnPacket", function (types,packet)
if types == 2 then
    if packet == "action|input\n|text|/ret" then
        var = {}
        var[0] = "OnDialogRequest"
        var[1] = help
        var.netid = -1
        SendVarlist(var)
        return true
    elseif packet:find("/tax") then
        tax = tonumber(packet:match("/tax (.*)"))
        TaxAmount = tax
        notif("`9Tax Set To `2["..TaxAmount.."%]")
        LogToConsole("`9Tax Set To `2["..TaxAmount.."%]")
        return true
    elseif packet == "action|input\n|text|/ctax" then
        LogToConsole("`9Current Tax `2["..TaxAmount.."%]")
        return true
    elseif packet == "action|input\n|text|/setphone" then
        TeleX = math.floor(GetLocal().pos_x // 32)
        TeleY = math.floor(GetLocal().pos_y // 32)
        LogToConsole("`6Telephone Pos Set To `2"..TeleX.."`6,`2"..TeleY)
        notif("`6Telephone Pos Set To `2"..TeleX.."`6,`2"..TeleY)
        return true
    elseif packet == "action|input\n|text|/telephone" then
        if autoTelephone == false then
            LogToConsole("`9Auto Telephone `2ON")
            notif("`9Auto Telephone `2ON")
            autoTelephone = true
            return true
        else
            LogToConsole("`9Auto Telephone `4OFF")
            notif("`9Auto Telephone `4OFF")
            autoTelephone = false
            return true
        end
    elseif packet:find("/dd") then
        RunThread(function() 
        isCdRunning = true
        local amount = tonumber(packet:match("/dd (.*)"))
        if ceklock(1796) < amount then
            shatter(7188)
            Sleep(250)
            if ceklock(1796) >= amount then
                drop(1796, amount)
            elseif ceklock(1796) < amount then
                shatter(7188)
                drop(1796, amount)
            elseif ceklock(7188) == 0 then
                notif("`4Not Enough Lock")
            end
        else
            drop(1796, amount)
        end
        isCdRunning = false
        end)
        return true
    elseif packet:find("/db") then
        isCdRunning = true
        local amount = tonumber(packet:match("/db (.*)"))
        if ceklock(7188) < amount then
            notif("`4Not Enough Lock")
        else
            drop(7188, amount)
        end
        isCdRunning = false
        return true
    elseif packet:find("/cd") then
        RunThread(function()
            local amount = tonumber(packet:match("/cd (.*)"))
            cd(amount)
        end)
        return true
    elseif packet == "action|input\n|text|/c" then
        convert(TeleX, TeleY)
        return true
	elseif packet == "action|input\n|text|/wda" then
            SendPacket(2, "action|dialog_return\ndialog_name|social\nbuttonClicked|bgl_withdraw")
        return true
    elseif packet:find("/wd") then
        local amount = packet:match("/wd (.*)")
        wd(amount)
        return true
    elseif packet == "action|input\n|text|/daw" then
        local bgl = ceklock(7188)
        local dl = ceklock(1796)
        local wl = ceklock(242)
        RunThread(function() 
            drop(7188,bgl)
            Sleep(300)
            drop(1796, dl)
            Sleep(300)
            drop(242,wl)
        end)
        return true
    elseif packet == "action|input\n|text|/dpa" then
        local amount = ceklock(7188)
        if amount == 0 then
            notif("`4Not Enough BGL")
        else
            depo(amount)
        end
        return true
	elseif packet:find("/depo") then
		local amount = packet:match("/depo (.*)")
		depo(amount)
        return true
    elseif packet == "action|input\n|text|/cgems" then
        if CekGems == false then
            CekGems = true
            LogToConsole("Check Gems Turned `2ON")
            notif("Check Gems Turned `2ON")
        else
            CekGems = false
            LogToConsole("Check Gems Turned `4OFF")
            notif("Check Gems Turned `4OFF")
        end
        return true
    elseif packet == "action|input\n|text|/wm" then
        fastMenu()
        return true
    elseif packet == "action|input\n|text|/p1" then
        p1x = math.floor(GetLocal().pos_x//32)
        p1y = math.floor(GetLocal().pos_y//32)
        LogToConsole("`9Player 1 Dbox Set To `2"..p1x.."`9,`2"..p1y)
        notif("`9Player 1 Dbox Set To `2"..p1x.."`9,`2"..p1y)
        return true
    elseif packet == "action|input\n|text|/p2" then
        p2x = math.floor(GetLocal().pos_x//32)
        p2y = math.floor(GetLocal().pos_y//32)
        LogToConsole("`9Player 2 Dbox Set To `2"..p2x.."`9,`2"..p2y)
        notif("`9Player 2 Dbox Set To `2"..p2x.."`9,`2"..p2y)
        return true
    elseif packet == "action|input\n|text|/tp" then
        RunThread(function()
            local lock = ceklock(242) + ceklock(1796)*100 + ceklock(7188)*10000
            repeat
                Sleep(300)
                take(p1x,p1y)
                take(p2x,p2y)
            until cekobjlock(p1x,p1y) == false and cekobjlock(p2x,p2y) == false
            Sleep(300)
            local curLock = ceklock(242) + ceklock(1796)*100 + ceklock(7188)*10000
            local totalLock = curLock - lock
            totalLock = math.floor(totalLock + 0.5) / 100
            totalLock = math.floor(totalLock)
            local tax = math.ceil((TaxAmount / 100) * totalLock)
            win = math.floor(totalLock - tax)
            Sleep(300)
            LogToConsole("`9Bet `o: `1"..totalLock.."DL")
            LogToConsole("`2Tax `o: `1"..tax.."DL `2["..TaxAmount.."%]")
            LogToConsole("`eWin `o: `1"..win.."DL")
            notif("`9Bet `o: `1"..totalLock.."DL `2Tax `o: `1"..tax.."DL `eWin `o: `1"..win.."DL")
        end)
        return true
    elseif packet:find("/w") then
        local wins = packet:match("/w(.*)")
        RunThread(function()
            if wins == "1" then
                local curPosX = GetLocal().pos_x // 32
                local curPosY = GetLocal().pos_y // 32
                GetLocal().facing_left = true
                Sleep(100)
                FindPath(p1x,p1y)
                Sleep(300)
                cd(win*100)
                Sleep(1000)
                FindPath(curPosX,curPosY)
            elseif wins == "2" then
                local curPosX = GetLocal().pos_x // 32
                local curPosY = GetLocal().pos_y // 32
                GetLocal().facing_left = false
                Sleep(100)
                FindPath(p2x,p2y)
                Sleep(300)
                cd(win*100)
                Sleep(1000)
                FindPath(curPosX,curPosY)
            end
        end)
        return true
    elseif packet == "action|input\n|text|/terminate" then
        RemoveCallbacks()
        breaks = true
        return true
    elseif packet == "action|input\n|text|/relog" then
        SendPacket(3,"action|join_request\nname|"..GetLocal().world.."\ninvitedWorld|0")
        return true
    elseif packet == "action|input\n|text|/block" then
        if blockSDB == false then
            LogToConsole("`eSDB `4Blocked(evil)")
            notif("`eSDB `4Blocked")
            blockSDB = true
        else
            LogToConsole("`eSDB `2Unblocked(smile)")
            notif("`eSDB `2Unblocked")
            blockSDB = false
        end
        return true
    elseif packet == "action|input\n|text|/save" then
        RunThread(save())
        return true
    elseif packet == "action|input\n|text|/spam" then
        if spam then
            spam = false
            SendPacket(2,"action|dialog_return\ndialog_name|cheats\ncheck_autospam|0")
        else
            spam = true
            SendPacket(2,"action|dialog_return\ndialog_name|cheats\ncheck_autospam|1")
        end
        return true
    elseif packet == "action|input\n|text|/config" then
        local autoTelephones
        local CekGemss
        local blockSDBs
        local fasts
        if autoTelephone then
            autoTelephones = "`2ON"
        else
            autoTelephones = "`4OFF"
        end
        if CekGems then
            CekGemss = "`2ON"
        else
            CekGemss = "`4OFF"
        end
        if blockSDB then
            blockSDBs = "`2ON"
        else
            blockSDBs = "`4OFF"
        end
        if fast == "false" then
            fasts = "`4OFF"
        end
        LogToConsole("`9Tax : `2"..TaxAmount.."%")
        LogToConsole("`9Tele Pos : `2"..TeleX..","..TeleY)
        LogToConsole("`9Auto Telephone : "..autoTelephones)
        LogToConsole("`9Check Gems : "..CekGemss)
        LogToConsole("`9Fast Wrench : "..fasts)
        LogToConsole("`9Block SDB : "..blockSDBs)
        LogToConsole("`9Player 1 Pos : `2"..p1x..","..p1y)
        LogToConsole("`9Player 2 Pos : `2"..p2x..","..p2y)
        return true
    elseif packet == "action|input\n|text|/autodl" then
        autoDlMenu()
    end
end
return false
end)

AddCallback("listener", "OnPacket", function (types,packet)
    if packet:find("action|dialog_return\ndialog_name|fast") then
        pull = tonumber(packet:match("pull|(.*)kick"))
        kick = tonumber(packet:match("kick|(.*)ban"))
        ban = tonumber(packet:match("ban|(.*)trade"))
        trade = tonumber(packet:match("trade|(.*)telephone"))
        telephone = tonumber(packet:match("telephone|(.*)drop"))
        drops = tonumber(packet:match("drop|(.*)trash"))
        trash = tonumber(packet:match("trash|(.*)"))
    end
    if packet:find("action|dialog_return\ndialog_name|autodl") then
        autoBuy = tonumber(packet:match("enable|(.*)customPos"))
        customPos = tonumber(packet:match("customPos|(.*)"))
        if packet:find("customPos|1") then
            autoBuyPos.x = TeleX
            autoBuyPos.y = TeleY
        else
            autoBuyPos.x = math.floor(GetLocal().pos_x/32)
            autoBuyPos.y = math.floor(GetLocal().pos_y/32)
        end
    end
    if pull + kick + ban + trade > 1 then
        notif("`9Choose One Masbro")
        pull = 0
        kick = 0
        ban = 0
        trade = 0
        fast = "false"
    end
    if packet:find("action|dialog_return\ndialog_name|fast") then
        if packet:find("pull|1") then
            fast = "pull"
        elseif packet:find("kick|1") then
            fast = "kick"
        elseif packet:find("ban|1") then
            fast = "ban"
        elseif packet:find("trade|1") then
            fast = "trade"
        elseif packet:find("telephone|1") and autoTelephone then
            notif("`4Auto Telephone Is On Right Now")
        elseif packet:find("telephone|1") then
            fast = "telephone"
        elseif packet:find("drop|1") then
            fast = "drop"
        elseif packet:find("trash|1") then
            fast = "trash"
        elseif packet:find("pull|0") or
            packet:find("kick|0") or
            packet:find("ban|0") or
            packet:find("trade|0") or
            packet:find("telephone|0") or
            packet:find("drop|0") or
            packet:find("trash|0") then
            fast = "false"
        end
        log(fast)
    end
    if packet:find("action|wrench") then
        netIdFast = packet:match("|netid|(.*)")
        if fast == "pull" then
            fasts(fast,netIdFast)
        elseif fast == "kick" then
            fasts(fast,netIdFast)
        elseif fast == "ban" then
            fasts(fast,netIdFast)
        elseif fast == "trade" then
            fasts(fast,netIdFast)
        end
    end
end)

var2 = {}

AddCallback("fekspin", "OnVarlist", function(var,packet)
    if var[0] == "OnTalkBubble" and var[2]:find("spun the wheel and got") then
        var1 = {
            [0] = "OnTalkBubble",
            [1] = var[1],
            [3] = var[3],
            [4] = var[4],
            netid = -1
        }
        var2.netid = var[1]
        return true
    end
    if var[0] == "OnConsoleMessage" and var[1]:find("spun the wheel and got") then
        if not var[1]:find("CT:") and not var[1]:find("`6<(.+)`6>") then
            lookingForName = var[1]:match("%[(.+)spun")
            lookingforNumber = var[1]:match("got (.+)``!]``")
            text = "`2[REAL]`0" ..var[1]
            var1[2] = text
            SendVarlist(var1)
            var2[0] = "OnNameChanged"
            var2[1] = lookingForName .."`9["..lookingforNumber.."`9]"
            SendVarlist(var2)
        else
            if var[1]:find("%$(.-)$") then
                t1 = var[1]:match("%$(.-)$")
            else
                t1 = var[1]
            end
            text = "`4[FAKE]`0"..t1
            var1[2] = text
            SendVarlist(var1)
        end
    end
end)

RunThread(function()
    while true do
        if breaks then
            break
        elseif spam then
            SendPacket(2,"action|input\n|text|"..spamText)
            Sleep(spamDelay)
        end
    end
end)

RunThread(function ()
while true do
Sleep(300)
if not isCdRunning then
    Sleep(200)
    if autoTelephone then
        if ceklock(1796) >= 100 and TeleX > 0 and TeleY > 0 then
            convert(TeleX,TeleY)
        end
    end
        if breaks then
            break
        end
    end
end
end)

while true do
gems = GetLocal().gems
Sleep(100)
if CekGems then
    Sleep(1000)
    gems = GetLocal().gems - gems
    if gems > 0 then
        SendPacket(2,"action|input\n|text|Collected "..math.floor(gems).." (gems)")
    end
end
if autoBuy == 1 then
    LogToConsole("Starting Buy")
    isCdRunning = true
    while GetLocal().gems >= 110000 and autoBuy == 1 and not breaks do
        SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785\nx|"..autoBuyPos.x.."|\ny|"..autoBuyPos.y.."|\nbuttonClicked|dlconvert")
        Sleep(80)
        if GetItemCount(1796) >= 100 then
            SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785\nx|"..autoBuyPos.x.."|\ny|"..autoBuyPos.y.."|\nbuttonClicked|bglconvert")
            Sleep(80)
        end
    end
    autoBuy = 0
    isCdRunning = false
end
if breaks then
    break
end
end
