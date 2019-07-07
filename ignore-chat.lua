script_name('Ignore Chat')
script_author('akionka')
script_version('1.8.2')
script_version_number(11)
local sampev   = require 'lib.samp.events'
local imgui    = require 'imgui'
local encoding = require 'encoding'
local inicfg   = require 'inicfg'
local dlstatus = require('moonloader').download_status
encoding.default = 'cp1251'
u8 = encoding.UTF8

local colournews  = -290866945 -- Цвет news
local colourpohq1 = 1687547391 -- Цвет hq1
local colourpohq2 = -12254977  -- Цвет hq2
local colourpozv  = -8224001   -- Цвет звезд
local colourpoca  = -789528321 -- Цвет 9-1-1
local colouremtx  = -285256193 -- Цвет вызовов такси и емс
local colorcrime  = nil        -- Цвет для ОПГ, в разработке.

local updatesavaliable = false

local ini = inicfg.load({
  settings =
  {
    ignorenews = false,
    ignorepohq = false,
    ignorepozv = false,
    ignorepoca = false,
    ignoreemtx = false,
    startmsg   = true,
  },
}, "ignore-chat")

function sampev.onServerMessage(color, text)
  if ini.settings.ignorenews and color == colournews and text:find(u8:decode("На модерацию поступило новое объявление. Всего на модерации находится ")) then return false end
  if ini.settings.ignorepohq and color == colourpohq1 and text:find(u8:decode("[HQ]:")) then return false end
  if ini.settings.ignorepohq and color == colourpohq2 and text:find(u8:decode("[HQ]:")) then return false end
  if ini.settings.ignorepozv and color == colourpozv then return false end
  if ini.settings.ignorepoca and color == colourpoca then return false end
  if ini.settings.ignoreemtx and color == colouremtx then return false end
end

local main_window_state = imgui.ImBool(false)
local startmsg          = imgui.ImBool(ini.settings.startmsg)
local ignorenews        = imgui.ImBool(ini.settings.ignorenews)
local ignorepohq        = imgui.ImBool(ini.settings.ignorepohq)
local ignorepozv        = imgui.ImBool(ini.settings.ignorepozv)
local ignorepoca        = imgui.ImBool(ini.settings.ignorepoca)
local ignoreemtx        = imgui.ImBool(ini.settings.ignoreemtx)

function imgui.OnDrawFrame()
  if main_window_state.v then
    imgui.Begin(thisScript().name.." v"..thisScript().version, main_window_state, imgui.WindowFlags.AlwaysAutoResize)
    if imgui.Checkbox('Режим игнорирования сообщений о новых объявлениях', ignorenews) then
      ini.settings.ignorenews = ignorenews.v
      inicfg.save(ini, 'ignore-chat')
    end
    if imgui.Checkbox('Режим игнорирования сообщений из HQ', ignorepohq) then
      ini.settings.ignorepohq = ignorepohq.v
      inicfg.save(ini, 'ignore-chat')
    end
    if imgui.Checkbox('Режим игнорирования сообщений о розыске', ignorepozv) then
      ini.settings.ignorepozv = ignorepozv.v
      inicfg.save(ini, 'ignore-chat')
    end
    if imgui.Checkbox('Режим игнорирования сообщений о новых звонках в 9-1-1', ignorepoca) then
      ini.settings.ignorepoca = ignorepoca.v
      inicfg.save(ini, 'ignore-chat')
    end
    if imgui.Checkbox('Режим игнорирования сообщений о новых вызовах Taxi/EMS', ignoreemtx) then
      ini.settings.ignoreemtx = ignoreemtx.v
      inicfg.save(ini, 'ignore-chat')
    end
	if imgui.CollapsingHeader('Дополнительные настройки') then
	  if updatesavaliable then
		if imgui.Button('Скачать обновление') then
		  update('https://raw.githubusercontent.com/Akionka/ignorechat/master/ignore-chat.lua')
		  main_window_state.v = false
		end
	  else
		if imgui.Button('Проверить обновление') then
		  checkupdates('https://raw.githubusercontent.com/Akionka/ignorechat/master/version.json')
		end
	  end
	  if imgui.Checkbox("Стартовое сообщение", startmsg) then
		ini.settings.startmsg = startmsg.v
		inicfg.save(ini, "ignore-chat")
	  end
	  imgui.Separator()
	end
    if imgui.Button('Bug report [VK]') then os.execute('explorer "https://vk.com/akionka"') end
    if imgui.Button('Bug report [Telegram]') then os.execute('explorer "https://teleg.run/akionka"') end
    imgui.End()
  end
end

function apply_custom_style()imgui.SwitchContext()local a=imgui.GetStyle()local b=a.Colors;local c=imgui.Col;local d=imgui.ImVec4;a.WindowRounding=0.0;a.WindowTitleAlign=imgui.ImVec2(0.5,0.5)a.ChildWindowRounding=0.0;a.FrameRounding=0.0;a.ItemSpacing=imgui.ImVec2(5.0,5.0)a.ScrollbarSize=13.0;a.ScrollbarRounding=0;a.GrabMinSize=8.0;a.GrabRounding=0.0;b[c.TitleBg]=d(0.60,0.20,0.80,1.00)b[c.TitleBgActive]=d(0.60,0.20,0.80,1.00)b[c.TitleBgCollapsed]=d(0.60,0.20,0.80,1.00)b[c.CheckMark]=d(0.60,0.20,0.80,1.00)b[c.Button]=d(0.60,0.20,0.80,0.31)b[c.ButtonHovered]=d(0.60,0.20,0.80,0.80)b[c.ButtonActive]=d(0.60,0.20,0.80,1.00)b[c.WindowBg]=d(0.13,0.13,0.13,1.00)b[c.Header]=d(0.60,0.20,0.80,0.31)b[c.HeaderHovered]=d(0.60,0.20,0.80,0.80)b[c.HeaderActive]=d(0.60,0.20,0.80,1.00)b[c.FrameBg]=d(0.60,0.20,0.80,0.31)b[c.FrameBgHovered]=d(0.60,0.20,0.80,0.80)b[c.FrameBgActive]=d(0.60,0.20,0.80,1.00)b[c.ScrollbarBg]=d(0.60,0.20,0.80,0.31)b[c.ScrollbarGrab]=d(0.60,0.20,0.80,0.31)b[c.ScrollbarGrabHovered]=d(0.60,0.20,0.80,0.80)b[c.ScrollbarGrabActive]=d(0.60,0.20,0.80,1.00)b[c.Text]=d(1.00,1.00,1.00,1.00)b[c.Border]=d(0.60,0.20,0.80,0.00)b[c.BorderShadow]=d(0.00,0.00,0.00,0.00)b[c.CloseButton]=d(0.60,0.20,0.80,0.31)b[c.CloseButtonHovered]=d(0.60,0.20,0.80,0.80)b[c.CloseButtonActive]=d(0.60,0.20,0.80,1.00)end

function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(0) end

  checkupdates('https://raw.githubusercontent.com/Akionka/ignorechat/master/version.json')
  apply_custom_style()
  sampRegisterChatCommand("igmenu", function()
    main_window_state.v = not main_window_state.v
    print(main_window_state.v)
  end)

  if ini.settings.startmsg then
    sampAddChatMessage(u8:decode("[IC]: Скрипт {00FF00}успешно{FFFFFF} загружен. Версия: {9932cc}"..thisScript().version.."{FFFFFF}."), -1)
    sampAddChatMessage(u8:decode("[IC]: Автор - {9932cc}Akionka{FFFFFF}. Выключить данное сообщение можно в {9932cc}/igmenu{FFFFFF}."), -1)
  end

  while true do
    wait(0)
    imgui.Process = main_window_state.v
  end
end

function checkupdates(json)
  local fpath = os.tmpname()
  if doesFileExist(fpath) then os.remove(fpath) end
  downloadUrlToFile(json, fpath, function(_, status, _, _)
    if status == dlstatus.STATUSEX_ENDDOWNLOAD then
      if doesFileExist(fpath) then
        local f = io.open(fpath, 'r')
        if f then
          local info = decodeJson(f:read('*a'))
          local updateversion = info.version_num
          f:close()
          os.remove(fpath)
          if updateversion > thisScript().version_num then
            updatesavaliable = true
            sampAddChatMessage(u8:decode("[IC]: Найдено объявление. Текущая версия: {9932cc}"..thisScript().version.."{FFFFFF}, новая версия: {9932cc}"..info.version.."{FFFFFF}."), -1)
            return true
          else
            updatesavaliable = false
            sampAddChatMessage(u8:decode("[IC]: У вас установлена самая свежая версия скрипта."), -1)
          end
        else
          updatesavaliable = false
          sampAddChatMessage(u8:decode("[IC]: Что-то пошло не так, упс. Попробуйте позже."), -1)
        end
      end
    end
  end)
end

function update(url)
  downloadUrlToFile(url, thisScript().path, function(_, status1, _, _)
    if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
      sampAddChatMessage(u8:decode('[IC]: Новая версия установлена! Чтобы скрипт обновился нужно либо перезайти в игру, либо ...'), -1)
      sampAddChatMessage(u8:decode('[IC]: ... если у вас есть автоперезагрузка скриптов, то новая версия уже готова и снизу вы увидите приветственное сообщение.'), -1)
      sampAddChatMessage(u8:decode('[IC]: Если что-то пошло не так, то сообщите мне об этом в VK или Telegram > {2980b0}vk.com/akionka teleg.run/akionka{FFFFFF}.'), -1)
      thisScript():reload()
    end
  end)
end
