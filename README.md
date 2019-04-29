# uuid

Cross-platform generation of UUID based on [RFC-4122](https://tools.ietf.org/html/rfc4122) . 

Support for 1, 3, 4 and 5 versions of UUID.
Port from [node-uuid](https://github.com/kelektiv/node-uuid) and using [PCG32](https://github.com/flashultra/hxprng) for random generator.

Version 3 use Md5 for hash and version 5 use Sha1.

## Installation
Require [PCG32](https://github.com/flashultra/hxprng) . If you won't want to use it can replace it with ```Std.random(256)``` or any other prng library.

## Usage
Version 1 (timestamp):
```haxe
var uuid = Uuid.v1();
trace("UUID: " + uuid);

//Using predefined values
var node = Bytes.ofHex("010203040506"); // Array of 6 bytes, by default is random generated
var optClockSequence = 0x1a7f; // clock sequence (0 - 0x3fff)
var msecs = 1556526368;  // Time in milliseconds since unix Epoch
var optNsecs = 4500; // Additional time in nanoseconds (0-9999)
uuid = Uuid.v1(node,optClockSequence,msecs,optNsecs);
trace("UUID: " + uuid);
```
Version 3 (namespace):
```haxe
var uuid = Uuid.v3("https://example.com/haxe",Uuid.URL); //namespace should be valid Uuid
trace("UUID: " + uuid);

uuid = Uuid.v3("The Cross-platform Toolkit");
trace("UUID: " + uuid);

uuid = Uuid.v3("The Cross-platform Toolkit",'7e9606ce-8af4-435b-89d6-66d6d885b97a');
trace("UUID: " + uuid);
```
Version 4 (random):
```haxe
var uuid = Uuid.v4();
trace("UUID: " + uuid);
```
Version 5 (namespace):
```haxe
var uuid = Uuid.v5("https://example.com/haxe",Uuid.URL);
trace("UUID: " + uuid);

uuid = Uuid.v5("The Cross-platform Toolkit");
trace("UUID: " + uuid);

uuid = Uuid.v5("The Cross-platform Toolkit",'7e9606ce-8af4-435b-89d6-66d6d885b97a');
trace("UUID: " + uuid);
```
