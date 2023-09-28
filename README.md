# Rose

![GitHub release (with filter)](https://img.shields.io/github/v/release/Gem-API/Rose)


Rose, short for Roblox Serializer (RoSe), is a feature-complete Roblox Instance serializer, written entirely in Luau. It is capable of converting any instantiable Roblox instance into a corresponding Lua table while preserving children recursively and storing any writable properties.

## Key Objectives

Rose is designed with three primary objectives:

1. **General Purpose**: Rose aims to provide a versatile solution that can handle anything from Model to GUI serialization.

2. **Space Efficiency**: Serialized tables should be as small as possible.

3. **Speed**: Rose is designed for efficiency and speed, even when dealing with complex Roblox data structures, with speeds of around 120,000 instances/second serialization and 70,000 instance/second deserialization.

## What Rose is Not

It's important to note that Rose is not a complete Roblox-to-Data solution. Instead, it serves as a critical component (the "missing link") within a broader data serialization workflow. An example workflow is as follows:

1. Convert a Roblox Instance to a Lua table using Rose.
2. Convert the Lua table to a language-agnostic format like JSON or Messagepack.
3. Compress the language-agnostic format (Rose, while efficient in size, inevitably contains repetitive data. This makes compression highly effective, often reducing size by 80%).
4. Encode the compressed data for storage on platforms that do not support binary data storage.

## Contributing Guide

Contributors to the Rose project should adhere to the following guidelines:

- **Versioning**: Rose uses [Simple Versioning](https://simver.org/) as its versioning scheme. Major versions indicate breaking changes to the specification, ensuring compatibility with tables created by previous Rose versions.

- **Code Style**: Maintain the code style format of the project. Keep line lengths at 80 characters or less.

### Updating the dataset

Rose uses a predefined lookup table to determine what it can and cannot serialize. The most basic (but valuable) contribution is updating the dataset with new Instance types or properties.

To update the dataset, add another item in the `MUTABLE_PROPERTIES` variable with the following format:

```lua
ClassNameOfInstance = {
    "Property1",
    "Property2",

    "Property3",
},
```

Order properties based on their sequence in the Roblox Studio properties window and leave an empty line between distinct property categories as displayed in the properties panel.

Some properties cannot be written to, only read from. Do not put read-only properties in this panel because the script will fail when setting them during deserialization. The [Roblox API](https://create.roblox.com/docs/en-us/reference/engine) is your friend.

The `Parent` property of all Instances is handled automatically, so please do not include it.

Before submitting a pull request, please test your new dataset by serializing and deserializing any classes you have added or changed, making sure that every property you intended to be saved has been saved and loaded correctly.