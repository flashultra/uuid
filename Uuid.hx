import haxe.Timer;
import haxe.Int64;
import haxe.io.Bytes;
import haxe.crypto.Md5;
import haxe.crypto.Sha1;

class Uuid {
	inline static var DNS = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
	inline static var URL = '6ba7b811-9dad-11d1-80b4-00c04fd430c8';
	inline static var ISO_OID = '6ba7b812-9dad-11d1-80b4-00c04fd430c8';
	inline static var X500_DN = '6ba7b814-9dad-11d1-80b4-00c04fd430c8';
	
    static var rng:PCG32 = new PCG32();
    
	static var lastMSecs:Float = 0;
	static var lastNSecs = 0;
	static var clockSequenceBuffer:Int = -1;

	public static function v1(node:Bytes = null, optClockSequence:Int = -1, msecs:Float = -1, optNsecs:Int = -1):String {
		var buffer:Bytes = Bytes.alloc(16);
		if (node == null) {
			node = Bytes.alloc(6);
			for (i in 0...6)
				node.set(i, rng.randomFromRange(0, 255));
			node.set(0, node.get(0) | 0x01);
		}
		if (clockSequenceBuffer == -1) {
			clockSequenceBuffer = (rng.randomFromRange(0, 255) << 8 | rng.randomFromRange(0, 255)) & 0x3fff;
		}
		var clockSeq = optClockSequence;
		if (optClockSequence == -1) {
			clockSeq = clockSequenceBuffer;
		}
		if (msecs == -1) {
			msecs = Timer.stamp();
		}
		var nsecs = optNsecs;
		if (optNsecs == -1) {
			nsecs = lastNSecs + 1;
		}
		var dt = (msecs - lastMSecs) + (nsecs - lastNSecs) / 10000;
		if (dt < 0 && (optClockSequence == -1)) {
			clockSeq = (clockSeq + 1) & 0x3fff;
		}
		if ((dt < 0 || msecs > lastMSecs) && optNsecs == -1) {
			nsecs = 0;
		}
		if (nsecs >= 10000) {
			throw "Can't create more than 10M uuids/sec";
		}
		lastMSecs = msecs;
		lastNSecs = nsecs;
		clockSequenceBuffer = clockSeq;

		msecs += 12219292800000;
		var dvs:Int64 = Int64.make(0x00000001, 0x00000000);
		var tl:Int = (((Int64.fromFloat(msecs) & 0xfffffff) * 10000 + nsecs) % dvs).low;
		buffer.set(0, tl >>> 24 & 0xff);
		buffer.set(1, tl >>> 16 & 0xff);
		buffer.set(2, tl >>> 8 & 0xff);
		buffer.set(3, tl & 0xff);

		var tmh:Int = ((Int64.fromFloat(msecs) / dvs * 10000) & 0xfffffff).low;
		buffer.set(4, tmh >>> 8 & 0xff);
		buffer.set(5, tmh & 0xff);

		buffer.set(6, tmh >>> 24 & 0xf | 0x10);
		buffer.set(7, tmh >>> 16 & 0xff);

		buffer.set(8, clockSeq >>> 8 | 0x80);
		buffer.set(9, clockSeq & 0xff);

		for (i in 0...6)
			buffer.set(i + 10, node.get(i));

		var uuid = unparse(buffer);
		return uuid;
	}

	public static function v3(name:String, namespace:String=""):String {
		namespace = StringTools.replace(namespace, '-', '');
		var buffer = Md5.make(Bytes.ofHex(namespace + Bytes.ofString(name).toHex()));
		buffer.set(6, (buffer.get(6) & 0x0f) | 0x30);
		buffer.set(8, (buffer.get(8) & 0x3f) | 0x80);
		var uuid = unparse(buffer);
		return uuid;
	}

	public static function v4(randBytes:Bytes = null):String {
		var buffer:Bytes = Bytes.alloc(16);
		for (i in 0...16) {
			buffer.set(i, rng.randomFromRange(0, 255));
		}
		buffer.set(6, (buffer.get(6) & 0x0f) | 0x40);
		buffer.set(8, (buffer.get(8) & 0x3f) | 0x80);
		var uuid = unparse(buffer);
		return uuid;
	}

	public static function v5(name:String, namespace:String=""):String {
		namespace = StringTools.replace(namespace, '-', '');
		var buffer = Sha1.make(Bytes.ofHex(namespace + Bytes.ofString(name).toHex()));
		buffer.set(6, (buffer.get(6) & 0x0f) | 0x50);
		buffer.set(8, (buffer.get(8) & 0x3f) | 0x80);
		var uuid = unparse(buffer);
		return uuid;
	}

	public static function unparse(data:Bytes):String {
		var hex = data.toHex();
		var uuid = hex.substr(0, 8) + "-" + hex.substr(8, 4) + "-" + hex.substr(12, 4) + "-" + hex.substr(16, 4) + "-" + hex.substr(20, 12);
		return uuid;
	}

	public static function parse(data:String):Bytes {
		return Bytes.ofHex(StringTools.replace(data, '-', ''));
	}
}