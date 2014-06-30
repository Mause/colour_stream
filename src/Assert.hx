class AssertException extends haxe.more.exceptions.Exception {}

class Assert {
    public static function assert( cond : Bool, ?message : String, ?pos : haxe.PosInfos ) {
        if( !cond ) {
            // haxe.Log.trace("Assert in "+pos.className+"::"+pos.methodName,pos);
            throw new AssertException(
                "Assert in "+pos.className+"::"+pos.methodName +
                (message == null ? '' : '->'+message)
            );
        }
    }
}
