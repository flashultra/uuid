# uuid

Cross-platform generation of UUID based on [RFC-4122](https://tools.ietf.org/html/rfc4122) . 

Support for 1, 3, 4 and 5 versions of UUID.
Port from [node-uuid](https://github.com/kelektiv/node-uuid) and using built-in Xorshift128+ for random generator.

Version 3 use Md5 for hash and version 5 use Sha1.

# short-uuid

Generate and translate standard UUIDs into shorter - or just different - formats and back ( [based on short-uuid](https://github.com/oculus42/short-uuid) ). 

It also provides translators to convert back and forth from RFC compliant UUIDs to the shorter formats.

# nanoid

A tiny, secure, URL-friendly, unique string ID generator ( [based on nanoid](https://github.com/ai/nanoid) ). 

* **Small.** 108 bytes (minified and gzipped).  [Size Limit] controls the size.
* **Fast.** It is 40% faster than UUID.
* **Safe.** It uses Xorshift128+ RNG and can use any cryptographically strong RNG.
* **Compact.** It uses a larger alphabet than UUID (`A-Za-z0-9_-`).   So ID size was reduced from 36 to 21 symbols.
* **Portable.** Nano ID was ported  to many programming languages.

## Convert from/to one type to another 
Here is an example of usage, where we store ```nanoId``` in the database ( it's much more compact) , but it is shown to the user as ```uuid``` , for readability and security reasons.

```haxe
var uniqueId = Uuid.nanoId(); // Generate unique id and store in database
var uuid = Uuid.fromNano(uniqueId); // Convert NanoId to Uuid and show on user screen
var searchUid = Uuid.toNano(uuid); // Server receive uuid and convert to NanoId. Use nanoId to search in database.

var shortUuid = Uuid.short();
var uuid = Uuid.fromShort(shortUuid);
```
Convert from any base to another base ( binary, hex, decimal, octal and many others) . 
```haxe
var vBinary = Uuid.convert("273247893827239437",Uuid.NUMBERS_DEC,Uuid.NUMBERS_BIN); //convert decimal to binary format
var vHex = Uuid.convert(vBinary, Uuid.NUMBERS_BIN, Uuid.NUMBERS_HEX); //convert bunary to hex format
var vBase58 = Uuid.convert(vHex,  Uuid.NUMBERS_HEX, Uuid.FLICKR_BASE58); // convert hex to Base58 format 
var vOctal = Uuid.convert(vBase58, Uuid.FLICKR_BASE58, Uuid.NUMBERS_OCT ); // convert from Base58 to octal format 
```

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
| [`Uuid.nanoId()`](#uuidnanoidlen-alphabet-randomfunc-string) | Create a tiny, secure, URL-friendly, unique string ID |
| [`Uuid.short()`](#uuidshorttoalphabet-randomfunc-string) | Generate shorter UUIDs based on v4  |
| [`Uuid.v1()`](#uuidv1node-optclocksequence-msecs-optnsecs-randomfunc-separator-shortuuid-toalphabetstring) | Create a version 1 (timestamp) UUID | 
| [`Uuid.v3()`](#uuidv3name-namespaceseparatorshortuuidtoalphabetstring) | Create a version 3 (namespace with MD5) UUID | 
| [`Uuid.v4()`](#uuidv4randbytesrandomfuncseparatorshortuuidtoalphabetstring) | Create a version 4 (random) UUID | 
| [`Uuid.v5()`](#uuidv5name-namespaceseparatorshortuuidtoalphabetstring) | Create a version 5 (namespace with SHA-1) UUID | 
| [`Uuid.NIL`](#uuidnil) | The nil UUID string (all zeros)  |
| [`Uuid.parse()`](#uuidparseuuid-separatorbytes) | Convert UUID string to bytes | 
| [`Uuid.stringify()`](#uuidstringifydata-separatorstring) | Convert bytes to UUID string |
| [`Uuid.randomFromRange()`](#uuidrandomfromrangemin-maxint) | Return random number between range |
| [`Uuid.randomByte()`](#uuidrandombyteint) | Return random value between 0 and 255 (included) | 
| [`Uuid.fromShort()`](#uuidfromshortshortuuid-separatorfromalphabetstring) | Convert short uuid to Uuid based on the alphabet | 
| [`Uuid.toShort()`](#uuidtoshortuuid-separatortoalphabetstring) | Convert Uuid to short uuid based on the alphabet  | 
| [`Uuid.fromNano()`](#uuidfromnanonanouuid-separatorfromalphabetstring) | Convert nanoId to Uuid | 
| [`Uuid.toNano()`](#uuidtonanouuid-separatortoalphabetstring) | Convert Uuid to nanoId  | 
| [`Uuid.convert()`](#uuidconvertnumber-fromalphabettoalphabetstring) | Convert any string from one alphabet to another | 
| [`Uuid.validate()`](#uuidvalidateuuid-separatorbool) | Test a string to see if it is a valid UUID |
| [`Uuid.version()`](#uuidversionuuid-separatorint) | Detect RFC version of a UUID |

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
| `Uuid.NANO_ID_ALPHABET` | Alphabet used to create NanoId string  | 
| `Uuid.NUMBERS_BIN` | Binary numbers | 
| `Uuid.NUMBERS_OCT` | Octal numbers | 
| `Uuid.NUMBERS_DEC` | Decimal numbers | 
| `Uuid.NUMBERS_HEX` | Hex numbers | 

## API

### Uuid.nanoId(len, alphabet, randomFunc ):String

Create unique string ID

 NanoId is 40% faster than UUID and uses a larger alphabet than UUID (A-Za-z0-9_-), so default size is reduced from 36 to 21 symbols.
 It is comparable to UUID v4.

|                |                                                                              |
| -------------- | ---------------------------------------------------------------------------- |
| `len`          | `Int` Size of the NanoId string ( default is `21`)                           |
| `alphabet`     | `String` Alphabet used to generate NanoId	                                |
| `randomFunc`   | `Void->Int` Any random function that returns a random bytes (0-255)          |
| _returns_      | `String`                                                                     |

Example:

```haxe
trace("Uuid: "+Uuid.nanoId()); // 6OxUkLI4bGmR_JlVMX9fQ
```

### Uuid.short(toAlphabet, randomFunc ):String

Create shorter version for UUID based UUID v4. 


|                |                                                                              |
| -------------- | ---------------------------------------------------------------------------- |
| `toAlphabet`   | `String` Alphabet used to generate short-uuid	                                |
| `randomFunc`   | `Void->Int` Any random function that returns a random bytes (0-255)          |
| _returns_      | `String`                                                                     |

Example:

```haxe
trace("Uuid: "+Uuid.short()); // mhvXdrZT4jP5T8vBxuvm75
```

### Uuid.NIL

The nil UUID string (all zeros).

Example:
```haxe
 trace("Uuid:" +Uuid.NIL); // ⇨ '00000000-0000-0000-0000-000000000000'
```

### Uuid.parse(uuid, separator):Bytes

 Convert UUID string to Bytes
|                |                                                                              |
| -------------- | ---------------------------------------------------------------------------- |
| `uuid`          | `String` A valid UUID |
| `separator`     | `String` Set different divider ( default is `-`)                                   |
| _returns_      | `Bytes`                                                                     |

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
| `shortUuid`     | `String` short uuid string                    |
| `separator`     | `String` Set divider ( default is `-`)                               |
| `fromAlphabet`     | `String` Alphabet to use for translation ( default `FLICKR_BASE58`)                               |
| _returns_ | `String`     |

&#x26a0;&#xfe0f; Note: Alphabets can be a custom ones or one of predefined : `COOKIE_BASE90` , `FLICKR_BASE58` , `BASE_70` , `LOWERCASE_BASE26` , `UPPERCASE_BASE26`, `NO_LOOK_ALIKES_BASE51` , `NUMBERS_BIN` , `NUMBERS_OCT` , `NUMBERS_DEC` , `NUMBERS_HEX`

Example:

```haxe
Uuid.fromShort("ecHyJhpvZANyZY6k1L5EYK"); // 6ae99955-2a0d-5dca-94d6-2e2bc8b764d3
```


### Uuid.toShort(uuid, separator,toAlphabet):String

Translate standard UUIDs into shorter  format

|           |                                          |
| --------- | ---------------------------------------- |
| `uuid`     | `String` A valid UUID                  |
| `separator`     | `String` Set divider ( default is `-`)                               |
| `toAlphabet`     | `String` Alphabet to use for translation ( default `FLICKR_BASE58`)                               |
| _returns_ | `String`     |

&#x26a0;&#xfe0f; Note: Alphabets can be a custom ones or one of predefined : `COOKIE_BASE90` , `FLICKR_BASE58` , `BASE_70` , `LOWERCASE_BASE26` , `UPPERCASE_BASE26`, `NO_LOOK_ALIKES_BASE51` , `NUMBERS_BIN` , `NUMBERS_OCT` , `NUMBERS_DEC` , `NUMBERS_HEX`

Example:

```haxe
Uuid.toShort('6ae99955-2a0d-5dca-94d6-2e2bc8b764d3'); // ecHyJhpvZANyZY6k1L5EYK
```


### Uuid.fromNano(nanoUuid, separator,fromAlphabet):String

Translate shorter  UUID format to standard UUID
|           |                                          |
| --------- | ---------------------------------------- |
| `nanoUuid`     | `String` A valid nanoId string                  |
| `separator`     | `String` Set divider ( default is `-`)                               |
| `fromAlphabet`     | `String` Alphabet to use for translation ( default `FLICKR_BASE58`)                               |
| _returns_ | `String`     |

&#x26a0;&#xfe0f; Note: Alphabets can be a custom ones or one of predefined : `COOKIE_BASE90` , `FLICKR_BASE58` , `BASE_70` , `LOWERCASE_BASE26` , `UPPERCASE_BASE26`, `NO_LOOK_ALIKES_BASE51` , `NUMBERS_BIN` , `NUMBERS_OCT` , `NUMBERS_DEC` , `NUMBERS_HEX`

Example:

```haxe
Uuid.fromShort("ecHyJhpvZANyZY6k1L5EYK"); // 6ae99955-2a0d-5dca-94d6-2e2bc8b764d3
```


### Uuid.toNano(uuid, separator,toAlphabet):String

Translate standard UUIDs into shorter  format

|           |                                          |
| --------- | ---------------------------------------- |
| `uuid`     | `String` A valid UUID                   |
| `separator`     | `String` Set divider ( default is `-`)                               |
| `toAlphabet`     | `String` Alphabet to use for translation ( default `FLICKR_BASE58`)                               |
| _returns_ | `String`     |

&#x26a0;&#xfe0f; Note: Alphabets can be a custom ones or one of predefined : `COOKIE_BASE90` , `FLICKR_BASE58` , `BASE_70` , `LOWERCASE_BASE26` , `UPPERCASE_BASE26`, `NO_LOOK_ALIKES_BASE51` , `NUMBERS_BIN` , `NUMBERS_OCT` , `NUMBERS_DEC` , `NUMBERS_HEX`

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

### Uuid.v1(node, optClockSequence, msecs, optNsecs, randomFunc, separator, shortUuid, toAlphabet):String

Create an RFC version 1 (timestamp) UUID

|  |  |
| --- | --- |
| `node`  |  `Bytes` RFC "node" field as 6 bytes  |
| `optClockSequence` | RFC "clock sequence" as a `Int` between 0 - 0x3fff |
| `msecs` | RFC "timestamp" field (`Float` of milliseconds, unix epoch) |
| `optNsecs` | RFC "timestamp" field (`Int` of nanseconds to add to `msecs`, should be 0-10,000) |
| `randomFunc` | `Void->Int` Any random function that returns a random bytes (0-255) |
| `separator` | `String` Set divider ( default is `-`)|
| `shortUuid` | `Bool` If `true` UUID will be exported as short UUID |
| `toAlphabet`| `String` Alphabet used for export on short UUID |
| _returns_ | UUID `String`  |
| _throws_ | `Error` if more than 10M UUIDs/sec are requested |


Example:

```haxe
Uuid.v1(); // ⇨ '2c5ea4c0-4067-11e9-8bad-9b1deb4d3b7d'
```

Example using  with options:

```haxe
var node = Bytes.ofHex("010207090506");
var optClockSequence = 0x1a7f;
var msecs = 1556526368; 
var optNsecs = 6200; 
uuid = Uuid.v1(node,optClockSequence,msecs,optNsecs); // ⇨ '25848a38-1cd0-11b2-9a7f-010207090506'
```

### Uuid.v3(name, namespace,separator,shortUuid,toAlphabet):String

Create an RFC version 3 (namespace w/ MD5) UUID

API is identical to `v5()`, but uses "v3" instead.

&#x26a0;&#xfe0f; Note: Per the RFC, "_If backward compatibility is not an issue, SHA-1 [Version 5] is preferred_."

### Uuid.v4(randBytes,randomFunc,separator,shortUuid,toAlphabet):String

Create an RFC version 4 (random) UUID

|  |  |
| --- | --- |
| `randBytes`| `Bytes` 16 random bytes (0-255) |
| `randomFunc` | `Void->Int` Any random function that returns a random bytes (0-255) |
| `separator` | `String` Set divider ( default is `-`)|
| `shortUuid` | `Bool` If `true` UUID will be exported as short UUID |
| `toAlphabet`| `String` Alphabet used for export on short UUID |
| _returns_ | UUID `String` |

Example:

```haxe
Uuid.v4(); // ⇨ '1b9d6bcd-bbfd-4b2d-9b5d-ab8dfbbd4bed'
```

Example using predefined `random` values:

```haxe
var randomValues= Bytes.ofHex("109156bec4fbc1ea71b4efe1671c5836");
Uuid.v4(randomValues); // ⇨ '109156be-c4fb-41ea-b1b4-efe1671c5836'
```

### Uuid.v5(name, namespace,separator,shortUuid,toAlphabet):String

Create an RFC version 5 (namespace w/ SHA-1) UUID

|  |  |
| --- | --- |
| `name` | `String` |
| `namespace` | `String` Namespace UUID |
| `separator` | `String` Set divider ( default is `-`)|
| `shortUuid` | `Bool` If `true` UUID will be exported as short UUID |
| `toAlphabet`| `String` Alphabet used for export on short UUID |
| _returns_ | UUID `String` if no `buffer` is specified, otherwise returns `buffer` |

Note: The RFC `DNS` and `URL` namespaces are available as `Uuid.DNS` and `Uuid.URL`.

Example with custom namespace:

```haxe
// Define a custom namespace.  Readers, create your own using something like
// https://www.uuidgenerator.net/
var MY_NAMESPACE = '1b671a64-40d5-491e-99b0-da01ff1f3341';

Uuid.v5('Hello, World!', MY_NAMESPACE); // ⇨ '630eb68f-e0fa-5ecc-887a-7c7a62614681'
```

Example with RFC `URL` namespace:

```haxe
Uuid.v5('https://www.w3.org/', Uuid.URL); // ⇨ 'c106a26a-21bb-5538-8bf2-57095d1976c1'
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
