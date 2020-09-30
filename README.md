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
## API Summary

|  |  |  
| --- | --- |
| [`Uuid.v1()`](#uuidv1) | Create a version 1 (timestamp) UUID | 
| [`Uuid.v3()`](#uuidv3) | Create a version 3 (namespace with MD5) UUID | 
| [`Uuid.v4()`](#uuidv4) | Create a version 4 (random) UUID | 
| [`Uuid.v5()`](#uuidv5) | Create a version 5 (namespace with SHA-1) UUID | 
| [`Uuid.NIL`](#uuidnil) | The nil UUID string (all zeros)  |
| [`Uuid.parse()`](#uuidparses) | Convert UUID string to bytes | 
| [`Uuid.stringify()`](#uuidstringify) | Convert bytes to UUID string |
| [`Uuid.randomFromRange()`](#uuidrandom) | Return random number between range |
| [`Uuid.randomByte()`](#uuidrandombyte) | Return random value between 0 and 255 (included) | 
| [`Uuid.fromShort()`](#uuidfromshort) | Convert short uuid to Uuid based on the alphabet | 
| [`Uuid.toShort()`](#uuidtoshort) | Convert Uuid to short uuid based on the alphabet  | 
| [`Uuid.convert()`](#uuidconvert) | Convert any string from one alphabet to another | 
| [`Uuid.validate()`](#uuidvalidate) | Test a string to see if it is a valid UUID |
| [`Uuid.version()`](#uuidversion) | Detect RFC version of a UUID |

## API Constants

|  |  |  
| --- | --- |
| `Uuid.DNS` | Returns the [RFC 4122](https://tools.ietf.org/html/rfc4122) identifier of the DNS namespace | 
| `Uuid.URL` | Returns the [RFC 4122](https://tools.ietf.org/html/rfc4122) identifier of the URL namespace | 
| `Uuid.ISO_OID` | Returns the [RFC 4122](https://tools.ietf.org/html/rfc4122) identifier of the ISO OID namespace | 
| `Uuid.X500_DN` | Returns the [RFC 4122](https://tools.ietf.org/html/rfc4122) identifier of the X.500 namespace | 
| `Uuid.LOWERCASE_BASE26` | Lowercase English letters | 
| `Uuid.UPPERCASE_BASE26` | Uppercase English letters. | 
| `Uuid.NO_LOOK_ALIKES_BASE51` | Numbers and english alphabet without lookalikes: `1`, `l`, `I`, `0`, `O`, `o`, `u`, `v`, `5`, `S`, `s` | 
| `Uuid.FLICKR_BASE58` | Avoid similar characters 0/O, 1/I/l | 
| `Uuid.BASE_70` | Numbers, English letters and special character | 
| `Uuid.COOKIE_BASE90` | Safe for HTTP cookies values  | 
| `Uuid.NUMBERS_BIN` | Binary numbers | 
| `Uuid.NUMBERS_OCT` | Octal numbers | 
| `Uuid.NUMBERS_DEC` | Decimal numbers | 
| `Uuid.NUMBERS_HEX` | Hex numbers | 

## API

### Uuid.NIL

The nil UUID string (all zeros).

Example:
```haxe
 trace("Uuid:" +Uuid.NIL); // ⇨ '00000000-0000-0000-0000-000000000000'
```

### Uuid.parse(uuid, separator):Bytes

 Convert UUID string to Bytes
|           |                                          |
| ------------- | ---------------------------------------- |
| `uuid`        | `String` A valid UUID                    |
| `separator`   | `String` Set different divider ( default is `-`)                 |
| _returns_     | `Bytes`                         |
  
Example:
```haxe
// Parse a UUID
var b = Uuid.parse('6ae99955-2a0d-5dca-94d6-2e2bc8b764d3');
trace("Hex: "+b.toHex()); // 6ae999552a0d5dca94d62e2bc8b764d3

// Hex representation on the byte order (for documentation purposes) 
// [
//   '6a', 'e9', '99', '55',
//   '2a', '0d', '5d', 'ca',
//   '94', 'd6', '2e', '2b',
//   'c8', 'b7', '64', 'd3'
// ]
```

### Uuid.stringify(data, separator):String

Convert Bytes to UUID string using separator

|                |                                                                              |
| -------------- | ---------------------------------------------------------------------------- |
| `data`          | `Bytes` Should be 16 bytes |
| `separator`     | `String` Set different divider ( default is `-`)                                   |
| _returns_      | `String`                                                                     |

Example:

```haxe
var b = Bytes.ofHex("6ae999552a0d5dca94d62e2bc8b764d3");
trace("Uuid: "+Uuid.stringify(b)); //6ae99955-2a0d-5dca-94d6-2e2bc8b764d3
```


### Uuid.validate(uuid, separator):Bool

Test a string to see if it is a valid UUID

|           |                                                     |
| --------- | --------------------------------------------------- |
| `uuid`     | `String` to validate                                |
| `separator`     | `String` Set different divider ( default is `-`)                               |
| _returns_ | `true` if string is a valid UUID, `false` otherwise |

Example:

```haxe
Uuid.validate('not a UUID'); // ⇨ false
Uuid.validate('6ae99955-2a0d-5dca-94d6-2e2bc8b764d3'); // ⇨ true
```

### Uuid.version(uuid, separator):Int

Detect RFC version of a UUID

|           |                                          |
| --------- | ---------------------------------------- |
| `uuid`     | `String` A valid UUID                     |
| `separator`     | `String` Set different divider ( default is `-`)                               |
| _returns_ | `Int` The RFC version of the UUID     |

Example:

```haxe
Uuid.version('45637ec4-c85f-11ea-87d0-0242ac130003'); // ⇨ 1
Uuid.version('6ec0bd7f-11c0-43da-975e-2a8ad9ebae0b'); // ⇨ 4
```

### Uuid.randomFromRange(min, max):Int

Return random number between min and max (included) values

|           |                                          |
| --------- | ---------------------------------------- |
| `min`     | `Int` Start number                   |
| `max`     | `Int` End number                                |
| _returns_ | `Int`     |

Example:

```haxe
Uuid.randomFromRange(1,6); // return a number in range [1,6]
```

### Uuid.randomByte():Int

Return a random  number between 0 and 255 (included) 

|           |                                          |
| --------- | ----------------------------------------                              |
| _returns_ | `Int`  

Example:

```haxe
Uuid.randomByte(); // return a number in range [0,255]
```

### Uuid.fromShort(shortUuid, separator,fromAlphabet):String

Translate shorter  UUID format to standard UUID
|           |                                          |
| --------- | ---------------------------------------- |
| `shortUuid`     | `String` A valid UUID                  |
| `separator`     | `String` Set divider ( default is `-`)                               |
| `fromAlphabet`     | `String` Alphabet to use for translation ( default `FLICKR_BASE58`)                               |
| _returns_ | `String`     |

Note: Alphabets can be a custom ones or one of predefined : `COOKIE_BASE90` , `FLICKR_BASE58` , `BASE_70` , `LOWERCASE_BASE26` , `UPPERCASE_BASE26`, `NO_LOOK_ALIKES_BASE51` , `NUMBERS_BIN` , `NUMBERS_OCT` , `NUMBERS_DEC` , `NUMBERS_HEX`

Example:

```haxe
Uuid.fromShort("ecHyJhpvZANyZY6k1L5EYK"); // 6ae99955-2a0d-5dca-94d6-2e2bc8b764d3
```


### Uuid.toShort(uuid, separator,toAlphabet):String

Translate standard UUIDs into shorter  format

|           |                                          |
| --------- | ---------------------------------------- |
| `uuid`     | `String` short uuid string                   |
| `separator`     | `String` Set divider ( default is `-`)                               |
| `toAlphabet`     | `String` Alphabet to use for translation ( default `FLICKR_BASE58`)                               |
| _returns_ | `String`     |

Note: Alphabets can be a custom ones or one of predefined : `COOKIE_BASE90` , `FLICKR_BASE58` , `BASE_70` , `LOWERCASE_BASE26` , `UPPERCASE_BASE26`, `NO_LOOK_ALIKES_BASE51` , `NUMBERS_BIN` , `NUMBERS_OCT` , `NUMBERS_DEC` , `NUMBERS_HEX`

Example:

```haxe
Uuid.toShort('6ae99955-2a0d-5dca-94d6-2e2bc8b764d3'); // ecHyJhpvZANyZY6k1L5EYK
```

### Uuid.convert(number, fromAlphabet,toAlphabet):String

Convert any string from one alphabet to another

|           |                                          |
| --------- | ---------------------------------------- |
| `number`     | `String` Any number or string                   |
| `fromAlphabet`     | `String` Alphabet source   ( for `number`)                            |
| `toAlphabet`     | `String` Alphabet destination                              |
| _returns_ | `String`     |

Example:

```haxe
Uuid.convert('12345',Uuid.NUMBERS_DEC,Uuid.NUMBERS_BIN); // 11000000111001
Uuid.convert('12345678',Uuid.NUMBERS_DEC,Uuid.NUMBERS_HEX);  // ⇨ bc614e
Uuid.convert('1234567890',Uuid.NUMBERS_DEC,Uuid.BASE_70);  //  ⇨ PtmIa
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
