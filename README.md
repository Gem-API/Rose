# Rose

Rose (RoSe; or Roblox Serializer) is feature complete Roblox Instance serializer written entirely in Luau. It can convert any instantiable Roblox instance into a corresponding lua table preserving children recursively, as well as storing any writable property

Rose has 3 main goals:
* To be general purpose.
* To be space efficient.
* To be fast.

----
### Table of Contents

* [Summary](#rose)
* [What Rose is Not](#what-rose-is-not)
* [Contributing Guide](#contributing-guide)

----
### What Rose is Not:

This project is not a complete Roblox to Data solution. Its goal is to serve as the "missing link" in a chain of tools that can be used to serialize Roblox data.

Instead, the rest of the process is left to the developer. Rose is simply a tool for the first step.

In general, the process should look something like this:

1. Convert a Roblox Instance to a Lua table with Rose.
2. Convert the lua table to a language-agnostic format like JSON or Messagepack.
3. Compress the generic data format (**Note:** while Rose does aim for size efficiency, it is inevitable that there will be large amounts of repeating data. As such compression is extremly effective on Rose data, reducing storage sizes by around 80%).
4. Encode the compressed data so that it can be stored by platforms that do not allow for binary data storage.

----
### Contributing Guide

Rose uses [Simple Versioning](https://simver.org/) as its versioning scheme for simplicity, where every major version indicates a breaking change to the specification (i.e. the new Rose version cannot decode tables made by the previous Rose version).

Please follow the code style format of the project, keeping line lengths 80 characters or less for readability.
