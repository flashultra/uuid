package uuid;

import haxe.Int64;
import haxe.Exception;

class FlakeId {
	// Custom Epoch (January 1, 2015 Midnight UTC = 2015-01-01T00:00:00Z)
    public static final DEFAULT_CUSTOM_EPOCH :Int64 = Int64.make(0x00000000,0x54A48E00);

    private static final SEQUENCE_BIT:Int = 12;
    private static final MACHINE_BIT:Int = 5;
    private static final DATACENTER_BIT:Int = 5;

    private static final MAX_DATACENTER_NUM:Int = -1 ^ (-1 << DATACENTER_BIT);
    private static final MAX_MACHINE_NUM:Int = -1 ^ (-1 << MACHINE_BIT);
    private static final MAX_SEQUENCE:Int = -1 ^ (-1 << SEQUENCE_BIT);

    private static final MACHINE_LEFT:Int = SEQUENCE_BIT ;
    private static final DATACENTER_LEFT:Int = SEQUENCE_BIT  + MACHINE_BIT;
    private static final TIMESTMP_LEFT:Int = DATACENTER_LEFT + DATACENTER_BIT ;

    private var datacenterId:Int;
    private var machineId:Int;
    private var sequence:Int = 0;
    private var lastTimestamp:Int64 = -1;
    private var customEpoch:Int64 = DEFAULT_CUSTOM_EPOCH;


	public function new(?datacenterId:Int,?machineId:Int,?epochTime:Int64)
    {
		if ( datacenterId == null ) datacenterId = Uuid.randomFromRange(0,MAX_DATACENTER_NUM);
		if ( machineId == null ) machineId = Uuid.randomFromRange(0,MAX_MACHINE_NUM);
        if ( epochTime == null ) epochTime = DEFAULT_CUSTOM_EPOCH;
		
        if (datacenterId > MAX_DATACENTER_NUM || datacenterId < 0)
        {
            throw new Exception('datacenterId can\'t be greater than $MAX_DATACENTER_NUM or less than 0');
        }
        if (machineId > MAX_MACHINE_NUM || machineId < 0)
        {
            throw new Exception('machineId can\'t be greater than $MAX_MACHINE_NUM or less than 0');
        }
        this.datacenterId = datacenterId;
        this.machineId = machineId;
    }

    public function nextId():Int64
    {
        var currentTimestamp :Int64 = timestamp();

        if (currentTimestamp  < lastTimestamp) {
            currentTimestamp  = lastTimestamp;
        }

        if (currentTimestamp  == lastTimestamp) {
            sequence = (sequence + 1) & MAX_SEQUENCE;
            if (sequence == 0) {
                currentTimestamp  = waitNextMillis();
            }
        } else {
            sequence = Uuid.randomFromRange(0,9) & MAX_SEQUENCE;
        }

        lastTimestamp = currentTimestamp ;

        var id:Int64 = ((currentTimestamp - customEpoch) << TIMESTMP_LEFT)
                   | (datacenterId << DATACENTER_LEFT) 
                   | (machineId << MACHINE_LEFT)
                   | sequence;

        return id;
    }

    private function waitNextMillis():Int64
    {
        var  mill:Int64 = timestamp();
        while (mill <= lastTimestamp)
        {
            mill = timestamp();
        }
        return mill;
    }

    public function setMachineId( machineId:Int):Void
    {
		if (machineId > MAX_MACHINE_NUM || machineId < 0)
        {
            throw new Exception('machineId can\'t be greater than $MAX_MACHINE_NUM or less than 0');
        }
        this.machineId = machineId;
    }
	
	public function setDatacenterId( datacenterId:Int):Void
    {
        if (datacenterId > MAX_DATACENTER_NUM || datacenterId < 0)
        {
            throw new Exception('datacenterId can\'t be greater than $MAX_DATACENTER_NUM or less than 0');
        }
        this.datacenterId = datacenterId;
    }

    public function setCustomEpoch(customEpoch:Int64):Void
    {
		if ( customEpoch < 0 ) 
		{
			 throw new Exception('customEpoch can\'t be less than 0');
		}
        this.customEpoch = customEpoch;
    }

    public function timestamp():Int64
    {
        return Int64.fromFloat(#if js js.lib.Date.now() #else Sys.time()*1000 #end);
    }
}