# uuid

Cross-platform generation of UUID based on [RFC-4122](https://tools.ietf.org/html/rfc4122) . 

Support for 1, 3, 4 and 5 versions of UUID.
Port from [node-uuid](https://github.com/kelektiv/node-uuid) and using built-in Xorshift128+ for random generator.

Version 3 use Md5 for hash and version 5 use Sha1.

## Random generator 
For Uuid.v1() and Uuid.v4() you can pass any random function which return value between 0 and 255 . The default random generator is Xorshift128+ . Here is example for custom random function using Std.random
```haxe
public function secureRandom():Int
{	
	return Std.random(256);
}

var uuid = Uuid.v1(secureRandom);

```
You can use Uuid to get any random number between some range, based on Xorshift128+ RNG, using the following code:
```haxe
 var dice:Int = Uuid.randomFromRange(1,6);
```

## Usage
Version 1 (timestamp):
```haxe
var uuid = Uuid.v1();
trace("UUID: " + uuid);

// Using custom separator
var uuid = Uuid.v1("_");
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

//Using custom separator - empty position
var uuid = Uuid.v4("");
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
