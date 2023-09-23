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

local Instance_new = Instance.new

--------------------------------------------------------------------------------
-- Datasets

local ROSE_VERSION = 0

local DESERIALIZE_DEFAULT_PARENT = game:GetService("Lighting")

local MUTABLE_PROPERTIES = {
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
	Weld = {
		"C0",
		"C1",
		"Name",
		"Part0",
		"Part1",

		"Enabled"
	},
	Part = {
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Name",

		"Size",
		"Position",
		"Rotation",

		"Anchored",
		"CanCollide"
	},
	WedgePart = {
		"Color",
		"Material",
		"Reflectance",
		"Transparency",

		"Name",

		"Size",
		"Position",
		"Rotation",

		"Anchored",
		"CanCollide"
	},
	ClickDetector = {
		"MaxActivationDistance",
		"Name",

		"CursorIcon"
	}
}

local IV_CLASSNAMES = {}

for i in MUTABLE_PROPERTIES do
	IV_CLASSNAMES[#IV_CLASSNAMES + 1] = i
end

local VI_CLASSNAMES = invert_table(IV_CLASSNAMES)

-- I/V Pairs
local ENUMS = Enum:GetEnums()

local IV_PROPERTY_TYPES = {
	"string",
	"number",
	"boolean",

	"Vector3",
	"Color3",
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
-- Internal Functions

local scope = nil

local uid_counter = 0
local uid_reference = {}

local post_deserialize_links = {}

local function build_uid_reference(instance)
	uid_counter += 1
	uid_reference[instance] = uid_counter

	local children = instance:GetChildren()
	for i in children do
		build_uid_reference(children[i])
	end
end

----------------------------------------
-- Serialize

local function serialize_property(p)
	local _type = typeof(p)

	local prop_type = VI_PROPERTY_TYPES[_type]
	if not prop_type then
		return nil
	end

	local value = nil

	if _type == "string" then
		value = p
	elseif _type == "number" then
		value = p
	elseif _type == "boolean" then
		value = p
	elseif _type == "Vector3" then
		value = {p.X, p.Y, p.Z}
	elseif _type == "Color3" then
		value = {p.R, p.G, p.B}
	elseif _type == "EnumItem" then
		value = {
			table.find(ENUMS, p.EnumType),
			table.find(p.EnumType:GetEnumItems(), p)
		}
	elseif _type == "CFrame" then
		local angles = p:ToAxisAngle()
		value = table.pack(p:GetComponents())
	elseif _type == "Instance" then
		if not p:IsDescendantOf(scope) then
			warn("Object-type property references '" .. p.Name .. 
				"' which is not in the serialization scope."
			)

			return nil
		else
			value = uid_reference[p]
		end
	end

	return {
		t = prop_type,
		v = value
	}
end

local function serialize_instance(obj)
	local props = {}

	local prop_pool = MUTABLE_PROPERTIES[obj.ClassName]

	for i in prop_pool do
		props[prop_pool[i]] = serialize_property(obj[prop_pool[i]])
	end

	local children = {}

	local child_pool = obj:GetChildren()
	for i in child_pool do
		if not MUTABLE_PROPERTIES[child_pool[i].ClassName] then
			--warn("Cannot serialize instance " .. child_pool[i].ClassName)
			continue
		end
		children[#children + 1] = serialize_instance(child_pool[i])
	end 

	return {
		u = uid_reference[obj],
		t = VI_CLASSNAMES[obj.ClassName],
		p = props,
		c = children
	}
end

----------------------------------------
-- Deserialize

local function post_deserialize_link_pass()
	for i in post_deserialize_links do
		local v = post_deserialize_links[i]
		v[1][v[2]] = uid_reference[v[3]]
	end
end


local function deserialize_property(property, prop_name, instance)
	local prop_type = IV_PROPERTY_TYPES[property.t]
	local value = property.v

	local result = nil

	if prop_type == "string" then
		result = value
	elseif prop_type == "number" then
		result = value
	elseif prop_type == "boolean" then
		result = value
	elseif prop_type == "Vector3" then
		result = Vector3.new(value[1], value[2], value[3])
	elseif prop_type == "Color3" then
		result = Color3.new(value[1], value[2], value[3])
	elseif prop_type == "EnumItem" then
		result = ENUMS[value[1]]:GetEnumItems()[value[2]]
	elseif prop_type == "CFrame" then
		result = CFrame.new(table.unpack(value))
	elseif prop_type == "Instance" then
		post_deserialize_links[#post_deserialize_links + 1] =
			{instance, prop_name, value}
	end

	return result
end

local function deserialize_instance(obj)
	local instance = Instance_new(
        IV_CLASSNAMES[obj.t], DESERIALIZE_DEFAULT_PARENT
    )

	for i in obj.c do
		local child = deserialize_instance(obj.c[i])
		child.Parent = instance
	end

	for name in obj.p do
		instance[name] = deserialize_property(obj.p[name], name, instance)
	end

	uid_reference[obj.u] = instance

	return instance
end

--------------------------------------------------------------------------------
-- Exposed API

local rose = {}

function rose.serialize(instance)
	scope = instance

	uid_reference = {}
	build_uid_reference(instance)

	return {
		["version"] = ROSE_VERSION,
		["tree"] = serialize_instance(instance)
	}
end

function rose.deserialize(packet)
	if packet.version ~= ROSE_VERSION then
		warn("RoSe packet provided was generated by an older version of RoSe.")
		return nil
	end

	uid_reference = {}
	post_deserialize_links = {}

	local result = deserialize_instance(packet.tree)

	post_deserialize_link_pass()

	return result
end

return rose