-- title:  bugatory
-- author: chiara solano (chiomisan)
-- desc: idk yet  
-- script: lua
t=0
--sprites
FLOOR=0
itemw=2
itemv=3
itema=4
--bugs
b1=7
b2=8
b3=9
b4=10
b5=11
b6=12
b7=13
b8=14
wall=17
bugthingy={b1, b2, b3, b4, b5, b6, b7, b8}
--player
froggy=33
froggytongy1=34
froggytongy2=35
froggytongy3=36
score = 0
--constants
maxx=29
maxy=16
minx=0
miny=0
--directionality
U={x= 0, y=-1}
D={x= 0, y= 1}
L={x=-1, y= 0}
R={x= 1, y= 0}
DIRS = {U,D,L,R}
orientationFroggy= 0
--player data
p={
x=maxx//2,
y=maxy//2,
speed = {
  x = 0,
  y = 0, 
  max = 4
}
}
--enemy data
--bug1={
--x=20,
--y=10
--}
--bug2={
--x=9,
--y=10
--}
--bug3={
--x=20,
--y=6
--}
--bug4={
--x=9,
--y=6
--}
bugs={}
tiles={}
--functions
--randomstuff
function r(a, b)
  return math.random(a,b)
end

--bug spawning
function bugspawn()
  local tx=r(minx, maxx)
  local ty=r(miny, maxy)


  if mget(tx, ty)==wall then
     bugspawn()
   end
  local z={
    x=tx,
    y=ty,
    d=DIRS[r(1,4)]}
  table.insert(bugs, #bugs+1,z)
end

--ai movement
function ai()

    for id,bug in pairs(bugs) do

    --first up, if a sheep somehow spawned
    --inside a wall...let's remove him
    if mget(bug.x,bug.y)>=wall then
     table.remove(bugs,id)
    end

    --log the sheeps next coors...
    --where he is plus where he's going
    local tx=bug.x+bug.d.x
    local ty=bug.y+bug.d.y

    --test for obstacles...
    if mget(tx,ty)>=wall then

     --pick a new direction if the sheep
     --ran into a wall.
     bug.d=DIRS[r(1,4)]

    else
     --the area is clear so move him there
     bug.x=tx
     bug.y=ty
    end

    --now we can check for a hole and
    --delete the sheep if he has fallen in
    if collision(bug, p) then

     --here we can use the id to remove a
     --specific sheep from the list.
     table.remove(bugs,id)
     score = score + 100
    end
    end
    end
--wallcollider
function isclearahead(dir)

local x=dir.x
local y=dir.y

if mget(p.x+x, p.y+y)<wall then
 return true

else
 return false
 end
end

--thingy collider
function collision(obj1, obj2)

if obj1.x==obj2.x and obj1.y==obj2.y then
 return true
 end
end

function move()
local sx = p.speed.x
local sy = p.speed.y
local smax = p.speed.max

if btn(0) and isclearahead(U) then
  orientationFroggy = 0
  p.y = p.y-1

end
if btn(1) and isclearahead(D) then
  orientationFroggy = 2
 p.y = p.y+1
end
if btn(2) and isclearahead(L) then
 p.x = p.x-1
 orientationFroggy = 3
end 
if btn(3) and isclearahead(R) then
  p.x = p.x+1
 orientationFroggy = 1
end
end
--update position

--mapcreation
function floor()
for x=minx, maxx do
 for y=miny, maxy do
  mset(x,y,FLOOR)
 end
end
end

function perimeter()
 for x=minx,maxx do
  for y=miny,maxy do
   if x==minx or x==maxx then
    mset(x,y,wall)
   elseif y==miny or y==maxy then
    mset(x,y,wall)
   end
  end
 end
end
--log tiles
function logtiles()
 for x=minx, maxx do
  for y= miny, maxy do
  if mget(x,y) == FLOOR then
    table.insert(tiles, #tiles+1,{x,y})
   end
  end
 end
end
--check to build
function tilegood(n)
local x=n[1]
local y=n[2]

if 
   mget(x  ,y-1)<wall and
   mget(x+1,y-1)<wall and
   mget(x-1,y-1)<wall and
   mget(x  ,y+1)<wall and
   mget(x+1,y+1)<wall and
   mget(x-1,y+1)<wall or 

    
   mget(x-1,y  )<wall and 
   mget(x-1,y-1)<wall and 
   mget(x-1,y+1)<wall and 
   
   mget(x+1,y  )<wall and 
   mget(x+1,y-1)<wall and
   mget(x+1,y-1)<wall then
   return true
  else
   return false
  end
 end

--place wall
function wallplace()
local index=math.random(1,#tiles)
 local cell=tiles[index]
 local x=cell[1]
 local y=cell[2]
  if tilegood(cell) then
   mset(x,y,wall)
  end
 table.remove(tiles,index)
end
--mapbuilder
function mapbuilder()
 wallplace()
 
 if #tiles>0 then
  mapbuilder()
 end
end
--screen graphics
function draw()
cls()
  map(0,0,maxx+1,maxy+1)
  spr(froggy, p.x*8,p.y*8,0,1,0,orientationFroggy)
 if #bugs>0 then
   for id, bug in pairs(bugs) do
     for key, bugt in pairs(bugthingy) do
       spr(bugt,bug.x*8, bug.y*8, 0)
     end
   end
 end
end

function init()
 floor()
 perimeter( )
 logtiles()
  mapbuilder()
 
end
init()
i = 0
z = 0
lives = 3


function gameOver()
 print("Game Over",(240/2)-6*4.5,136/2, 12)
 spr(4,240/2-4,136/2+10)
  if btnp(4) then
   init()
   lives=3
  end
end
limit = 1500
a = 0
b = 4 
c = 0
function TIC()
if lives ~=0 then
  t=t+1

 
while i ~=b do
  bugspawn()
  i = i+1
end
 if t%8 == 0 then
   move()
 end
 if t%12 == 0 then
   if #bugs>0 then
     ai()
   end
 end
 draw()
if #bugs==0 then
z = 1000 - t
z = z * 10
score = score + z
i = 0
lives = lives + 1
c = c + 1
a = a +1
t = 0
init()
end
print("score"..score, 5, 5, 12)
print("lives".. lives, 5, 131, 12)
 if t>=limit then
  init()
   t=0
   lives = lives -1
   a = a +1
   i = 0
 end
 if a == 2 then
   limit = limit/2
   a = 0
   
 end
 if c == 2 then
   b = b+2
   c = 0
 end
 else 
   limit = 1500
   score = 0
   gameOver()
end

 if btnp(4)then
    init()
  end	
end

-- <TILES>
-- 000:8e8888888d77777887e7d7788e77eed8877d77788777777887e77778888d8888
-- 001:0000000000000000000ee00000edde0000edde00000ee0000000000000000000
-- 002:0000000000000000000660000065560000655600000660000000000000000000
-- 003:0000000000000000000330000034430000344300000330000000000000000000
-- 007:003ff300f003300f0f3443f000344300ff3443ff003443000f3443f0f003300f
-- 008:002ff200f002200f0f2332f000233200ff0220ff002332000f2332f0f002200f
-- 009:f00ee00f0feddef000edde00fedccdef0edccde00edccde0fedccdeff0eeee0f
-- 010:000ff00000777700f766557f07655670f765567f07655670f755667ff077770f
-- 011:000ff0000f0660f0006556000f6446f0006556000f6556f0006446000f0660f0
-- 012:f001100f0f1221f000d22d00fdbddbdf0dbddbd0dbbddbbddb4dd4bd0dd00dd0
-- 013:f080080ff8a88a8f089aa98000888800f8aa998f08a99a80f899aa8ff088880f
-- 014:f00ee00f0feddef000eeee000edccde0feceecef0ee44ee00e4444e0f033330f
-- 017:111111112111111f221111ff222ddfff222ddfff22eeeeff2eeeeeefeeeeeeee
-- 033:0007700003f65f30075665700075670003766730057657600757757000700700
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 003:234456789876544320000456789a7531
-- </WAVES>

-- <SFX>
-- 000:7363638353ae53bd43dd33ed33ec23dc23bc13ac139b138b137b137a237a237a238a339a33ba43ea43fa43fa43ea43ea33ca23aa238a236913591339b0400000001a
-- 001:d008b00aa00a900b900b901c901ca01cb01db01db01db01db01dc01dc01dc01dd01cd01cd01cc00cb00bb00ba00ba00ba00aa00aa009b008c008d00820b0007f5f5f
-- 002:916091609170917091609151915191519141914191319131a131a131a1319131a121a121a120a110a110a110a110a110a110a110a100a100a110a1103840000ef000
-- </SFX>

-- <PATTERNS>
-- 000:655112155110955114155110755112155110955114155110955112b00012100010900014155100a55114155100866126000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:536224136200536224100000c99124100020c00024100020899124800024100000000000b99124b00024b00024699124000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:000000e99724100000000000000000000000000000699724100000000000000000000000d99724100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </PATTERNS>

-- <TRACKS>
-- 000:1c0300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000340
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

