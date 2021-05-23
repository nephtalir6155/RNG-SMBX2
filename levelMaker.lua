levelMaker = {}
playerStartY = 0
playerStartX = 0
savedCode = {}
if SaveData.savedGeneration == nil then
    SaveData.savedGeneration = {}
end
function levelMaker.onStartMake()
    playerStartY = player.y
    playerStartX = player.x
end
function levelMaker.onTickMake(levelType)
    savedCode = {}
    local savedNPC = {}
    local savedBGO = {}
    saving = Block.get()
    for i=1,tablelength(saving) do
        local tosave = {}
        table.insert(tosave,saving[i].id)
        table.insert(tosave,saving[i].x)
        table.insert(tosave,saving[i].y)
        table.insert(tosave,saving[i].width)
        table.insert(tosave,saving[i].height)
        table.insert(tosave,saving[i].contentID)
        table.insert(tosave,saving[i].isHidden)
        table.insert(tosave,saving[i]:mem(0x5A,FIELD_BOOL))
        table.insert(tosave,saving[i].slippery)
        table.insert(savedCode,tosave)
    end
    saving = NPC.get()
    for i=1,tablelength(saving) do
        local tosave = {}
        table.insert(tosave,saving[i].id)
        table.insert(tosave,saving[i]:mem(0xA8,FIELD_DFLOAT))
        table.insert(tosave,saving[i]:mem(0xB0,FIELD_DFLOAT))
        table.insert(tosave,saving[i]:mem(0xDE,FIELD_WORD))
        table.insert(tosave,saving[i].ai2)
        table.insert(tosave,saving[i].ai3)
        table.insert(tosave,saving[i].ai4)
        table.insert(tosave,saving[i].ai5)
        table.insert(tosave,saving[i]:mem(0xD8,FIELD_FLOAT))
        table.insert(savedNPC,tosave)
    end
    saving = BGO.get()
    for i=1,tablelength(saving) do
        local tosave = {}
        table.insert(tosave,saving[i].id)
        table.insert(tosave,saving[i].x)
        table.insert(tosave,saving[i].y)
        table.insert(savedBGO,tosave)
    end
    local dataFile = io.open(Misc.episodePath()..Level.name()..".txt", "w+" )
    dataFile:write(Level.name().." = {}".."\n".."\n"..Level.name()..".water = "..createStringFromBool(Section.get(1).isUnderwater).."\n"..Level.name()..".width = "..math.abs(Section.get(1).boundary.left-Section.get(1).boundary.right).."\n"..Level.name()..".playerY = "..playerStartY.."\n"..Level.name()..".playerX = "..playerStartX.."\n"..Level.name()..".background = "..Section.get(1).backgroundID.."\n"..Level.name()..".music = "..Section.get(1).musicID.."\n"..Level.name()..".bgo = {\n"..createStringFromTable(savedBGO).."}".."\n"..Level.name()..".npc = {\n"..createStringFromTable(savedNPC).."}".."\n"..Level.name()..".blocks = {\n"..createStringFromTable(savedCode).."}\nreturn "..Level.name())
end

function createStringFromBool(t)
    local str = ""
    if t == true then str = str.."true".."" end
    if t == false then str = str.."false".."" end
    return str
end

function createStringFromTable(t)
    local str = ""
    for i=1,tablelength(t) do
        if type(t[i]) == "string" then
            str = str.."'"..t[i].."'"..",\n"
        elseif type(t[i]) == "number" then
            str = str..t[i]..",\n"
        elseif type(t[i]) == "table" then
            str = str.."{\n"..createStringFromTable(t[i]).."},\n"
        elseif type(t[i]) == "boolean" then
         if t[i] == true then str = str.."true"..",\n" end
         if t[i] == false then str = str.."false"..",\n" end
        end
    end
    return str
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

return levelMaker