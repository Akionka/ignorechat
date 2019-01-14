script_name('Ignore Chat')
script_author('akionka')
script_version('1.1')
script_version_number(2)
script_description([[{FFFFFF}Данный скрипт разработан Akionka с использованием кода от FYP'а, а также с использованием идей коммьюнити Trinity GTA.
В данный момент скрипт умеет:
 - Скрывать сообщения о новых объявлениях [News]
 - Скрывать сообщения из HQ [PD/FBI]
 - Скрывать сообщения о выдаче звезд [PD/FBI]
 - Скрывать сообщения о звонках 9-1-1 [PD/FBI]
 - Скрывать сообщения о вызовах (новые, принятие, отмена итд) [Taxi/EMS]

Кстати, список команд:
/igmenu | /ignews | /igpohq | /igpozv | /igpoca | /igemtx
Какая что делает можно догадаться из названия, а если совсем туго, то просто введи её.
  
Зачем это все нужно? Людям было банально неудобно создавать SS, когда весь чат срался этими сообщениями.
Вероятно, скрипт имеет баги, поэтому прошу о всех найденных багах писать мне в личку (ссылки в /igmenu).]])
script_properties("forced-reloading-only")
local update_log = [[{2980b9}v1.0 [12.01.2019]{FFFFFF}
I. Работает скрытие:
- Сообщений из HeadQuarters [PD/FBI]
- Сообщений из 9-1-1 [PD/FBI]
- Сообщений из лога выдачи звезд [PD/FBI]
- Сообщений о новых объявлениях [News]
- Сообщений о вызовах (новые, принятие, отмена итд) [Taxi/EMS]
II. Работает система автообновлений (понадобится ли она?)
III. Работает диалог /igmenu
{2980b9}v1.1 [13.01.2019]{FFFFFF}
I. Теперь скрипт не пишет о ненайденных обновлениях, если скрыто приветственное сообщение]]
local sf = require 'sampfuncs'
local sampev = require 'lib.samp.events'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
local dlstatus = require('moonloader').download_status
encoding.default = 'cp1251'
u8 = encoding.UTF8
--
local colournews = -290866945 --цвет news
local colourpohq = 1687547391 --цвет hq
local colourpozv = -8224001 --цвет звезд
local colourpoca = -789528321 --цвет 9-1-1
local colouremtx = -285256193 --цвет вызовов такси и емс
--

local ini = inicfg.load({
  settings =
  {
    ignorenews = false,
    ignorepohq = false,
    ignorepozv = false,
    ignorepoca = false,
	ignoreemtx = false,
	showstarms = true,
	autoupdate = true
  },
}, "ignore-chat")

local my_dialog = {
    {
        title = u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях — {FF0000}выключен{FFFFFF}."),
        onclick = function(menu, row)
			ini.settings.ignorenews = not ini.settings.ignorenews
			inicfg.save(ini, "ignore-chat")
			menu[row].title = ini.settings.ignorenews and u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях — {FF0000}выключен{FFFFFF}.")
			return true
        end
    },
    {
        title = u8:decode("[IC]: Режим игнорирования сообщений из HQ — {FF0000}выключен{FFFFFF}."),
        onclick = function(menu, row)
			ini.settings.ignorepohq = not ini.settings.ignorepohq
			inicfg.save(ini, "ignore-chat")
			menu[row].title = ini.settings.ignorepohq and u8:decode("[IC]: Режим игнорирования сообщений из HQ — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений из HQ — {FF0000}выключен{FFFFFF}.")
			return true
        end
    },
    {
        title = u8:decode("[IC]: Режим игнорирования сообщений о розыске — {FF0000}выключен{FFFFFF}."),
        onclick = function(menu, row)
			ini.settings.ignorepozv = not ini.settings.ignorepozv
			inicfg.save(ini, "ignore-chat")
			menu[row].title = ini.settings.ignorepozv and u8:decode("[IC]: Режим игнорирования сообщений о розыске — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о розыске — {FF0000}выключен{FFFFFF}.") 
			return true
        end
    },
    {
        title = u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 — {FF0000}выключен{FFFFFF}."),
        onclick = function(menu, row)
			ini.settings.ignorepoca = not ini.settings.ignorepoca
			inicfg.save(ini, "ignore-chat")
			menu[row].title = ini.settings.ignorepoca and u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 — {FF0000}выключен{FFFFFF}.")
			return true
        end
    },
    {
        title = u8:decode("[IC]: Режим игнорирования сообщений о новых вызовах Taxi/EMS — {FF0000}выключен{FFFFFF}."),
        onclick = function(menu, row)
			ini.settings.ignoreemtx = not ini.settings.ignoreemtx
			inicfg.save(ini, "ignore-chat")
			menu[row].title = ini.settings.ignoreemtx and u8:decode("[IC]: Режим игнорирования сообщений о новых вызовах Taxi/EMS — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых вызовах Taxi/EMS — {FF0000}выключен{FFFFFF}.")
			return true
        end
	},
    {
        title = u8:decode(" "),
        onclick = function(menu, row)
			return true
        end
    },
    {
        title = u8:decode("О скрипте"),
        onclick = function(menu, row)
			sampShowDialog(31339, u8:decode("{2980b9} Ignore Chats | О скрипте"), u8:decode(thisScript().description), u8:decode("Окей"), "", DIALOG_STYLE_MSGBOX)
			return false
        end
    },
    {
        title = u8:decode("Update log"),
        onclick = function(menu, row)
			sampShowDialog(31340, u8:decode("{2980b9} Ignore Chats | Update Log"), u8:decode(update_log), u8:decode("Окей"), "", DIALOG_STYLE_MSGBOX)
			return false
        end
    },
    {
        title = u8:decode("Доп. настройки"),
		submenu = {
			title = u8:decode("{2980b9} Ignore Chats | Доп. настройки"),
			onclick = function(menu, row, submenu)
				submenu[1].title = ini.settings.autoupdate and u8:decode("Автообновление — {00FF00}включено{FFFFFF}.") or u8:decode("Автообновление — {FF0000}выключено{FFFFFF}.")
				submenu[2].title = ini.settings.showstarms and u8:decode("Приветственное сообщение — {00FF00}включено{FFFFFF}.") or u8:decode("Приветственное сообщение — {FF0000}выключено{FFFFFF}.")
				submenu[3].title = u8:decode("Проверить обновления. Текущая версия: "..thisScript().version)
			end,
			{
				title = ini.settings.autoupdate and u8:decode("Автообновление — {00FF00}включено{FFFFFF}.") or u8:decode("Автообновление — {FF0000}выключено{FFFFFF}."),
				onclick = function(menu, row)
					ini.settings.autoupdate = not ini.settings.autoupdate
					inicfg.save(ini, "ignore-chat")
					menu[row].title = ini.settings.autoupdate and u8:decode("Автообновление — {00FF00}включено{FFFFFF}.") or u8:decode("Автообновление — {FF0000}выключено{FFFFFF}.")
					return true
				end,
			},
			{
				title = ini.settings.showstarms and u8:decode("Приветственное сообщение — {00FF00}включено{FFFFFF}.") or u8:decode("Приветственное сообщение — {FF0000}выключено{FFFFFF}."),
				onclick = function(menu, row)
					ini.settings.showstarms = not ini.settings.showstarms
					inicfg.save(ini, "ignore-chat")
					menu[row].title = ini.settings.showstarms and u8:decode("Приветственное сообщение — {00FF00}включено{FFFFFF}.") or u8:decode("Приветственное сообщение — {FF0000}выключено{FFFFFF}.")
					return true
				end,
			},
			{
				title = u8:decode("Проверить обновления. Текущая версия: {2980b9}"..thisScript().version.."{FFFFFF}."),
				onclick = function(menu, row)
					update(false)
					while updateinprogess ~= false do wait(100) end
					return false
				end,
			},
		}
    },
    {
        title = u8:decode(" "),
        onclick = function(menu, row)
			return true
        end
    },
    {
        title = u8:decode("Bug Report [VK]"),
        onclick = function(menu, row)
			os.execute('explorer "https://vk.com/id358870950"')
			return true
        end
    },
    {
        title = u8:decode("Bug Report [Telegram]"),
        onclick = function(menu, row)
			os.execute('explorer "https://teleg.run/akionka"')
			return true
        end
    },
}

function sampev.onServerMessage(color, text)
	if ini.settings.ignorenews and color == colournews and text:find(u8:decode("На модерацию поступило новое объявление. Всего на модерации находится ")) then return false end
	if ini.settings.ignorepohq and color == colourpohq then return false end
	if ini.settings.ignorepozv and color == colourpozv then return false end
	if ini.settings.ignorepoca and color == colourpoca then return false end
	if ini.settings.ignoreemtx and color == ignoreemtx then return false end
end
--
function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(0) end
	
	my_dialog[1].title = ignorenews and u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях — {FF0000}выключен{FFFFFF}.")
	my_dialog[2].title = ignorepohq and u8:decode("[IC]: Режим игнорирования сообщений из HQ — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений из HQ — {FF0000}выключен{FFFFFF}.")
	my_dialog[3].title = ignorepozv and u8:decode("[IC]: Режим игнорирования сообщений о розыске — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о розыске — {FF0000}выключен{FFFFFF}.") 
	my_dialog[4].title = ignorepoca and u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 — {FF0000}выключен{FFFFFF}.")
	sampRegisterChatCommand("ignews", function() ini.settings.ignorenews = not ini.settings.ignorenews inicfg.save(ini, "ignore-chat") sampAddChatMessage(ini.settings.ignorenews and u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях теперь — {00FF00}включен{2980b9}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях теперь — {FF0000}выключен{2980b9}."), 0x2980b9) end)
	sampRegisterChatCommand("igpohq", function() ini.settings.ignorepohq = not ini.settings.ignorepohq inicfg.save(ini, "ignore-chat") sampAddChatMessage(ini.settings.ignorepohq and u8:decode("[IC]: Режим игнорирования сообщений из HQ теперь — {00FF00}включен{2980b9}.") or u8:decode("[IC]: Режим игнорирования сообщений из HQ теперь — {FF0000}выключен{2980b9}."), 0x2980b9) end)
	sampRegisterChatCommand("igpozv", function() ini.settings.ignorepozv = not ini.settings.ignorepozv inicfg.save(ini, "ignore-chat") sampAddChatMessage(ini.settings.ignorepozv and u8:decode("[IC]: Режим игнорирования сообщений о розыске теперь — {00FF00}включен{2980b9}.") or u8:decode("[IC]: Режим игнорирования сообщений о розыске теперь — {FF0000}выключен{2980b9}."), 0x2980b9) end)
	sampRegisterChatCommand("igpoca", function() ini.settings.ignorepoca = not ini.settings.ignorepoca inicfg.save(ini, "ignore-chat") sampAddChatMessage(ini.settings.ignorepoca and u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 теперь — {00FF00}включен{2980b9}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 теперь — {FF0000}выключен{2980b9}."), 0x2980b9) end)
	sampRegisterChatCommand("igemtx", function() ini.settings.ignorepoca = not ini.settings.ignorepoca inicfg.save(ini, "ignore-chat") sampAddChatMessage(ini.settings.ignorepoca and u8:decode("[IC]: Режим игнорирования сообщений о новых вызовах Taxi/EMS теперь — {00FF00}включен{2980b9}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых вызовах Taxi/EMS теперь — {FF0000}выключен{2980b9}."), 0x2980b9) end)
	sampRegisterChatCommand("igmenu", function() 
		lua_thread.create(function()
			my_dialog[1].title = ini.settings.ignorenews and u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях — {FF0000}выключен{FFFFFF}.")
			my_dialog[2].title = ini.settings.ignorepohq and u8:decode("[IC]: Режим игнорирования сообщений из HQ — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений из HQ — {FF0000}выключен{FFFFFF}.")
			my_dialog[3].title = ini.settings.ignorepozv and u8:decode("[IC]: Режим игнорирования сообщений о розыске — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о розыске — {FF0000}выключен{FFFFFF}.") 
			my_dialog[4].title = ini.settings.ignorepoca and u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 — {FF0000}выключен{FFFFFF}.")
			my_dialog[5].title = ini.settings.ignorepoca and u8:decode("[IC]: Режим игнорирования сообщений о новых вызовах Taxi/EMS — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых вызовах Taxi/EMS — {FF0000}выключен{FFFFFF}.")
			submenus_show(my_dialog, u8:decode("{2980b9} Ignore Chats"))
		end) 
	end)
	sampRegisterChatCommand("iglog", function()
		sampShowDialog(31340, u8:decode("{2980b9} Ignore Chats | Update Log"), u8:decode(update_log), u8:decode("Окей"), "", DIALOG_STYLE_MSGBOX)
	end)
	if ini.settings.showstarms then
		sampAddChatMessage(u8:decode("[IC]: Скрипт {00FF00}успешно{FFFFFF} загружен. Версия: {2980b9}"..thisScript().version.."{FFFFFF}."), -1)
		sampAddChatMessage(u8:decode("[IC]: Автор - {2980b9}Akionka{FFFFFF}. Выключить данное сообщение можно в {2980b9}/igmenu{FFFFFF}."), -1)
	end
	update(true)
	while updateinprogess ~= false do wait(100) end
	while true do
		wait(0)
		local result, button, list, input = sampHasDialogRespond(31339)
		if result then 
			my_dialog[1].title = ini.settings.ignorenews and u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях — {FF0000}выключен{FFFFFF}.")
			my_dialog[2].title = ini.settings.ignorepohq and u8:decode("[IC]: Режим игнорирования сообщений из HQ — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений из HQ — {FF0000}выключен{FFFFFF}.")
			my_dialog[3].title = ini.settings.ignorepozv and u8:decode("[IC]: Режим игнорирования сообщений о розыске — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о розыске — {FF0000}выключен{FFFFFF}.") 
			my_dialog[4].title = ini.settings.ignorepoca and u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 — {FF0000}выключен{FFFFFF}.")
			my_dialog[5].title = ini.settings.ignorepoca and u8:decode("[IC]: Режим игнорирования сообщений о новых вызовах Taxi/EMS — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых вызовах Taxi/EMS — {FF0000}выключен{FFFFFF}.")
			submenus_show(my_dialog, u8:decode("{2980b9} Ignore Chats"))
		end
		local result, button, list, input = sampHasDialogRespond(31340)
		if result then 
			my_dialog[1].title = ini.settings.ignorenews and u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых объявлениях — {FF0000}выключен{FFFFFF}.")
			my_dialog[2].title = ini.settings.ignorepohq and u8:decode("[IC]: Режим игнорирования сообщений из HQ — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений из HQ — {FF0000}выключен{FFFFFF}.")
			my_dialog[3].title = ini.settings.ignorepozv and u8:decode("[IC]: Режим игнорирования сообщений о розыске — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о розыске — {FF0000}выключен{FFFFFF}.") 
			my_dialog[4].title = ini.settings.ignorepoca and u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых звонках в 9-1-1 — {FF0000}выключен{FFFFFF}.")
			my_dialog[5].title = ini.settings.ignorepoca and u8:decode("[IC]: Режим игнорирования сообщений о новых вызовах Taxi/EMS — {00FF00}включен{FFFFFF}.") or u8:decode("[IC]: Режим игнорирования сообщений о новых вызовах Taxi/EMS — {FF0000}выключен{FFFFFF}.")
			submenus_show(my_dialog, u8:decode("{2980b9} Ignore Chats"))
		end
	end
end

function update(auto)
	local fpath = os.getenv('TEMP') .. '\\ic-version.json'
	downloadUrlToFile('https://raw.githubusercontent.com/Akionka/ignorechat/master/version.json', fpath, function(id, status, p1, p2)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			local f = io.open(fpath, 'r')
			if f then
				local info = decodeJson(f:read('*a'))
				if info and info.version then
					version = info.version
					version_num = info.version_num
					if version_num > thisScript().version_num then
						sampAddChatMessage(u8:decode("[IC]: Найдено объявление. Текущая версия: {2980b9}"..thisScript().version.."{FFFFFF}, новая версия: {2980b9}"..version.."{FFFFFF}."), -1)
						if auto then sampAddChatMessage(ini.settings.autoupdate and u8:decode("[IC]: Так как у вас {00FF00}включено{FFFFFF} автообновление, скрипт обновится прямо сейчас. Внимание! Игра или скрипт может вылететь.") or u8:decode("[IC]: Так как у вас {FF0000}выключено{FFFFFF} автообновление, скрипт не будет обновляться, однако вы можете сделать это в /igmenu."), -1) end
						if ini.settings.autoupdate then 
							lua_thread.create(goupdate) 
						elseif not auto then
							lua_thread.create(goupdate)
						else 
							updateinprogess = false
						end
					else
						if ini.settings.showstarms and auto then sampAddChatMessage(u8:decode("[IC]: У вас установлена самая свежая версия скрипта."), -1) end
						updateinprogess = false
					end
				end
			end
		end
	end)
end
--скачивание актуальной версии
function goupdate()
	wait(300)
	downloadUrlToFile("https://raw.githubusercontent.com/Akionka/ignorechat/master/ignore-chat.lua", thisScript().path, function(id3, status1, p13, p23)
		if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
			sampAddChatMessage((u8:decode('[IC]: Новая версия установлена! Чтобы скрипт обновился нужно либо перезайти в игру, либо ...')), -1)
			sampAddChatMessage((u8:decode('[IC]: ... если у вас есть автоперезагрузка скриптов, то новая версия уже готова и снизу вы увидите приветственное сообщение')), -1)
			sampAddChatMessage((u8:decode('[IC]: Если что-то пошло не так, то сообщите мне об этом в VK или Telegram > vk.com/akionka tele.run/akionka')), -1)
		end	
	end)
end

--Спасибо FYP за енту крутую хуету:)
function submenus_show(menu, caption, select_button, close_button, back_button)
    select_button, close_button, back_button = select_button or u8:decode("Выбрать"), close_button or u8:decode("Закрыть"), back_button or u8:decode("Назад")
    prev_menus = {}
    function display(menu, id, caption)
        local string_list = {}
        for i, v in ipairs(menu) do
            table.insert(string_list, type(v.submenu) == "table" and v.title .. "  >>" or v.title)
        end
        sampShowDialog(id, caption, table.concat(string_list, "\n"), select_button, (#prev_menus > 0) and back_button or close_button, sf.DIALOG_STYLE_LIST)
        repeat
            wait(0)
            local result, button, list = sampHasDialogRespond(id)
            if result then
                if button == 1 and list ~= -1 then
                    local item = menu[list + 1]
                    if type(item.submenu) == "table" then -- submenu
                        table.insert(prev_menus, {menu = menu, caption = caption})
                        if type(item.onclick) == "function" then
                            item.onclick(menu, list + 1, item.submenu)
                        end
                        return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
                    elseif type(item.onclick) == "function" then
                        local result = item.onclick(menu, list + 1)
                        if not result then return result end
                        return display(menu, id, caption)
                    end
                else -- if button == 0
                    if #prev_menus > 0 then
                        local prev_menu = prev_menus[#prev_menus]
                        prev_menus[#prev_menus] = nil
                        return display(prev_menu.menu, id - 1, prev_menu.caption)
                    end
                    return false
                end
            end
        until result
    end
    return display(menu, 31337, caption or menu.title)
end
