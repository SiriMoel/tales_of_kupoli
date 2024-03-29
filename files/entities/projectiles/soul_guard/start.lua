dofile_once("mods/tales_of_kupoli/files/scripts/utils.lua")
dofile_once("mods/tales_of_kupoli/files/scripts/souls.lua")

dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local souls_count = GetSoulsCount("all")
local how_many = 0

if souls_count >= 8 then
    how_many = 8
elseif souls_count == 0 then
    GamePrint("You do not have enough souls.")
    how_many = 0
else
    how_many = souls_count
end

local angle_inc = ( 2 * 3.14159 ) / how_many
local theta = math.rad(6)-GameGetFrameNum() / 10.0
local length = 16

SetRandomSeed( pos_x * entity_id, pos_y * entity_id )

local rotation = Random(-12, 12)

while (math.abs(rotation) < 5) do
	rotation = Random(-12, 12)
end

if ( Random( 1, 20 ) == 5 ) then
	rotation = 40
end

local shooter_id = 0

edit_component( entity_id, "ProjectileComponent", function(comp,vars)
	shooter_id = ComponentGetValue2( comp, "mWhoShot" )
end)

if ( shooter_id == NULL_ENTITY ) then
	shooter_id = EntityGetClosestWithTag( pos_x, pos_y, "hittable" )
end

if ( shooter_id ~= nil ) and ( shooter_id ~= NULL_ENTITY ) then
	for i=1,how_many do
		local new_x = pos_x + math.cos( theta ) * length
		local new_y = pos_y + math.sin( theta ) * length
		
		local part_id = shoot_projectile_from_projectile( entity_id, "mods/tales_of_kupoli/files/entities/projectiles/soul_guard/part.xml", new_x, new_y, 0, 0 )
		RemoveSouls(1)

		EntityAddComponent( part_id, "VariableStorageComponent", 
			{
				name = "angle",
				value_float = theta,
			})
			
		EntityAddComponent( part_id, "VariableStorageComponent", 
			{
				name = "rot",
				value_int = rotation,
			})
			
		EntityAddComponent( part_id, "VariableStorageComponent", 
			{
				name = "owner",
				value_int = shooter_id,
			})
			
		theta = theta + angle_inc
	end
end

EntityKill( entity_id )
