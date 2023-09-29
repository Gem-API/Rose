--------------------------------------------------------------------------------
--                                                                            --
--                  `7MM"""Mq.            .M"""bgd                            --
--                    MM   `MM.          ,MI    "Y                            --
--                    MM   ,M9  ,pW"Wq.  `MMb.      .gP"Ya                    --
--                    MMmmdM9  6W'   `Wb   `YMMNq. ,M'   Yb                   --
--                    MM  YM.  8M     M8 .     `MM 8M""""""                   --
--                    MM   `Mb.YA.   ,A9 Mb     dM YM.    ,                   --
--                  .JMML. .JMM.`Ybmd9'  P"Ybmmd"   `Mbmmd'                   --
--                                                                            --
--                         Roblox Instance Serializer                         --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--  Copyright (c) Gem_API                                                     --
--                                                                            --
--  Permission is hereby granted, free of charge, to any person obtaining     --
--  a copy of this software and associated documentation files (the           --
--  "Software"), to deal in the Software without restriction, including       --
--  without limitation the rights to use, copy, modify, merge, publish,       --
--  distribute, sublicense, and/or sell copies of the Software, and to        --
--  permit persons to whom the Software is furnished to do so, subject to     --
--  the following conditions:                                                 --
--                                                                            --
--  The above copyright notice and this permission notice shall be            --
--  included in all copies or substantial portions of the Software.           --
--                                                                            --
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,           --
--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF        --
--  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.    --
--  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY      --
--  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,      --
--  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE         --
--  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                    --
--                                                                            --
--------------------------------------------------------------------------------
-- Utilities

local function invert_table(t)
	local s = {}
	for k in t do
		s[t[k]] = k
	end
	return s
end

local table_pack = table.pack
local table_unpack = table.unpack

local Instance_new = Instance.new
local Vector2_new = Vector2.new
local Vector3_new = Vector3.new
local Color3_new = Color3.new
local ColorSequence_new = ColorSequence.new
local ColorSequenceKeypoint_new = ColorSequenceKeypoint.new
local CFrame_new = CFrame.new
local NumberRange_new = NumberRange.new
local NumberSequenceKeypoint_new = NumberSequenceKeypoint.new
local NumberSequence_new = NumberSequence.new

--------------------------------------------------------------------------------
-- Datasets

local ROSE_VERSION = 2

local DESERIALIZE_DEFAULT_PARENT = game:GetService("Lighting")

local MUTABLE_PROPERTIES = {
	Folder = {
		"Name"
	},
	Model = {
		"Name",

		"PrimaryPart",

		"WorldPivot"
	},
	SpecialMesh = {
		"MeshId",
		"MeshType",
		"Name",
		"Offset",
		"Scale",
		"TextureId"
	},
	BlockMesh = {
		"Name",
		"Offset",
		"Scale",
		"VertexColor"
	},
	CylinderMesh = {
		"Name",
		"Offset",
		"Scale",
		"VertexColor"
	},
	Weld = {
		"C0",
		"C1",
		"Name",
		"Part0",
		"Part1",

		"Enabled"
	},
	Snap = {
		"C0",
		"C1",
		"Name",
		"Part0",
		"Part1",

		"Enabled"
	},
	Part = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",
		"Shape",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface"
	},
	WedgePart = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface"
	},
	CornerWedgePart = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface"
	},
	TrussPart = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",
		"Shape",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface"
	},
	SpawnLocation = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",
		"Shape",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface",

		"Duration",

		"AllowTeamChangeOnTouch",
		"Neutral",
		"TeamColor"
	},
	Seat = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",
		"Shape",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface",

		"Disabled"
	},
	VehicleSeat = {
		"CastShadow",
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Locked",
		"Name",

		"Size",
		"Position",
		"Rotation",

		"CanCollide",
		"Anchored",
		"Shape",

		"BackSurface",
		"BottomSurface",
		"FrontSurface",
		"LeftSurface",
		"RightSurface",
		"TopSurface",

		"Disabled",
		"HeadsUpDisplay",
		"MaxSpeed",
		"Steer",
		"SteerFloat",
		"Throttle",
		"ThrottleFloat",
		"Torque",
		"TurnSpeed"
	},
	Decal = {
		"Color3",
		"Texture",
		"Transparency",
		"ZIndex",

		"Face",
		"Name"
	},
	Texture = {
		"Color3",
		"OffsetStudsU",
		"OffsetStudsV",
		"StudsPerTileU",
		"StudsPerTileV",
		"Texture",
		"Transparency",
		"ZIndex",

		"Face",
		"Name"
	},
	ClickDetector = {
		"MaxActivationDistance",
		"Name",

		"CursorIcon"
	},
	PointLight = {
		"Brightness",
		"Color",
		"Enabled",
		"Range",
		"Shadows",

		"Name"
	},
	SpotLight = {
		"Angle",
		"Brightness",
		"Color",
		"Enabled",
		"Face",
		"Range",
		"Shadows",

		"Name"
	},
	SurfaceLight = {
		"Angle",
		"Brightness",
		"Color",
		"Enabled",
		"Face",
		"Range",
		"Shadows",

		"Name"
	},
	Fire = {
		"Color",
		"Enabled",
		"Heat",
		"Name",
		"SecondaryColor",
		"Size",
		"TimeScale"
	},
	Smoke = {
		"Color",
		"Enabled",
		"Name",
		"Opacity",
		"RiseVelocity",
		"Size",
		"TimeScale"
	},
	Sparkles = {
		"Enabled",
		"Name",
		"SparkleColor",
		"TimeScale"
	},
	ParticleEmitter = {
		"Color",
		"LightEmission",
		"LightInfluence",
		"Orientation",
		"Size",
		"Squash",
		"Texture",
		"Transparency",
		"ZOffset",

		"Name",
		"EmissionDirection",
		"Enabled",
		"Lifetime",
		"Rate",
		"Rotation",
		"RotSpeed",
		"Speed",
		"SpreadAngle",

		"Shape",
		"ShapeInOut",
		"ShapeStyle",

		"FlipbookLayout",

		"Acceleration",

		"Drag",
		"LockedToPart",
		"TimeScale",
		"VelocityInheritance",
		"WindAffectsDrag"
	},
	Beam = {
		"Color",
		"Enabled",
		"LightEmission",
		"LightInfluence",
		"Texture",
		"TextureLength",
		"TextureMode",
		"TextureSpeed",
		"Transparency",
		"ZOffset",

		"Name",
		
		"Attachment0",
		"Attachment1",
		"CurveSize0",
		"CurveSize1",
		"FaceCamera",
		"Segments",
		"Width0",
		"Width1"
	},
	Attachment = {
		"Visible",

		"Name",

		"CFrame"
	},
}

local IV_CLASSNAMES = {}

for i in MUTABLE_PROPERTIES do
	IV_CLASSNAMES[#IV_CLASSNAMES + 1] = i
end

local VI_CLASSNAMES = invert_table(IV_CLASSNAMES)

local IV_PROPERTY_TYPES = {
	"string",
	"number",
	"boolean",

	"NumberRange",
	"NumberSequence",

	"Vector2",
	"Vector3",

	"Color3",
	"ColorSequence",

	"EnumItem",

	"CFrame",

	"Instance"
}

local VI_PROPERTY_TYPES = invert_table(IV_PROPERTY_TYPES)

local DEFAULT_INSTANCES = {}

for className in MUTABLE_PROPERTIES do
	DEFAULT_INSTANCES[className] = Instance_new(className)
end

--------------------------------------------------------------------------------
-- Internal API

local give_warnings = false

local scope = nil

local uid_counter = 0
local uid_reference = {}

local skipped_instances = 0
local skipped_instance_types = {}

local post_deserialize_links_counter = 0
local post_deserialize_links = {}

local function reset_internal_variables()
	scope = nil

	uid_counter = 0
	uid_reference = {}

	skipped_instances = 0
	skipped_instance_types = {}

	post_deserialize_links_counter = 0
	post_deserialize_links = {}
end

local function build_uid_reference(instance)
	uid_counter += 1
	uid_reference[instance] = uid_counter

	local children = instance:GetChildren()
	for i in children do
		build_uid_reference(children[i])
	end
end

----------------------------------------
-- Serializer

local function serialize_property(p)
	local _type = typeof(p)

	local prop_type = VI_PROPERTY_TYPES[_type]
	if not prop_type then
		return nil
	end

	local value = nil

	if _type == "EnumItem" then
		value = p.Value
	
	elseif _type == "Vector3" then
		value = {p.X, p.Y, p.Z}

	elseif _type == "boolean" then
		value = p

	elseif _type == "Color3" then
		value = {p.R, p.G, p.B}

	elseif _type == "number" then
		value = p

	elseif _type == "string" then
		value = p

	elseif _type == "CFrame" then
		value = table_pack(p:GetComponents())

	elseif _type == "Instance" then
		if not p:IsDescendantOf(scope) then
			warn("Object-type property references '" .. p.Name .. 
				"' which is not in the serialization scope."
			)

			return nil
		else
			value = uid_reference[p]
		end

	elseif _type == "Vector2" then
		value = {p.X, p.Y}

	elseif _type == "ColorSequence" then
		value = {}

		local kps = p.Keypoints
		for i in kps do
			local kp = kps[i]
			local kpc = kp.Value

			value[i] = {kp.Time, kpc.R, kpc.G, kpc.B}
		end

	elseif _type == "NumberRange" then
		value = {p.Min, p.Max}

	elseif _type == "NumberSequence" then
		value = {}

		local kps = p.Keypoints
		for i in kps do
			local kp = kps[i]

			value[i] = {kp.Time, kp.Value, kp.Envelope}
		end

	end

	return {
		prop_type,
		value
	}
end

local function serialize_instance(obj)
	local class_name = obj.ClassName

	local prop_pool = MUTABLE_PROPERTIES[class_name]

	local props = {}

	for i in prop_pool do
		local p = prop_pool[i]
		if DEFAULT_INSTANCES[class_name][p] == obj[p] then
			continue
		end
		props[p] = serialize_property(obj[p])
	end

	local children_counter = 0
	local children = {}

	local child_pool = obj:GetChildren()
	for i in child_pool do
		local c = child_pool[i]
		if not MUTABLE_PROPERTIES[c.ClassName] then
			skipped_instance_types[c.ClassName] = 1
			skipped_instances += 1

			continue
		end
		children_counter += 1
		children[children_counter] = serialize_instance(c)
	end 

	return {
		uid_reference[obj],
		VI_CLASSNAMES[class_name],
		props,
		children
	}
end

----------------------------------------
-- Deserializer

local function post_deserialize_link_pass()
	for i in post_deserialize_links do
		local v = post_deserialize_links[i]
		v[1][v[2]] = uid_reference[v[3]]
	end
end


local function deserialize_property(property, prop_name, instance)
	local prop_type = IV_PROPERTY_TYPES[property[1]]
	local value = property[2]

	local result = nil

	if prop_type == "EnumItem" then
		result = value

	elseif prop_type == "Vector3" then
		result = Vector3_new(value[1], value[2], value[3])

	elseif prop_type == "boolean" then
		result = value

	elseif prop_type == "Color3" then
		result = Color3_new(value[1], value[2], value[3])

	elseif prop_type == "number" then
		result = value

	elseif prop_type == "string" then
		result = value

	elseif prop_type == "CFrame" then
		result = CFrame_new(table_unpack(value))

	elseif prop_type == "Instance" then
		post_deserialize_links_counter += 1
		post_deserialize_links[post_deserialize_links_counter] =
			{instance, prop_name, value}

	elseif prop_type == "Vector2" then
		result = Vector2_new(value.X, value.Y)

	elseif prop_type == "ColorSequence" then
		local kps = {}

		for i in value do
			local v = value[i]
			kps[i] = ColorSequenceKeypoint_new(
				v[1], Color3_new(v[2], v[3], v[4])
			)
		end

		result = ColorSequence_new(kps)

	elseif prop_type == "NumberRange" then
		result = NumberRange_new(value[1], value[2])

	elseif prop_type == "NumberSequence" then
		local kps = {}

		for i in value do
			local v = value[i]
			kps[i] = NumberSequenceKeypoint_new(
				v[1], v[2], v[3]
			)
		end

		result = NumberSequence_new(kps)

	end

	return result
end

local function deserialize_instance(obj, parent)
	local instance = Instance_new(IV_CLASSNAMES[obj[2]])

	for i in obj[4] do
		deserialize_instance(obj[4][i], instance)
	end

	for name in obj[3] do
		instance[name] = deserialize_property(obj[3][name], name, instance)
	end

	uid_reference[obj[1]] = instance

	instance.Parent = parent or DESERIALIZE_DEFAULT_PARENT

	return instance
end

--------------------------------------------------------------------------------
-- Exposed API

local rose = {}

function rose.serialize(instance)
	if not MUTABLE_PROPERTIES[instance.ClassName] then
		warn("Given instance was not serializable")
		return nil
	end

	reset_internal_variables()

	build_uid_reference(instance)

	local result = serialize_instance(instance)

	if skipped_instances ~= 0 and give_warnings then
		warn("ROSE - Some instance(s) were not serialized:")
		for i in skipped_instance_types do
			warn("    Type '" .. i .. "'")
		end
	end

	return {
		["version"] = ROSE_VERSION,
		["tree"] = result
	}
end

function rose.deserialize(packet)
	if packet.version ~= ROSE_VERSION then
		warn("ROSE packet provided was generated by an older version of ROSE.")
		return nil
	end

	reset_internal_variables()

	local result = deserialize_instance(packet.tree)

	post_deserialize_link_pass()

	return result
end

function rose.give_warnings(value: boolean)
	give_warnings = value
end

return rose