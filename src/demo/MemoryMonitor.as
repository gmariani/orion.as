package demo {
	
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    dynamic public class MemoryMonitor extends MovieClip {
		
        public var arr:Array;
        public var t:Number;
		
        public function MemoryMonitor() {
            arr = [];
            addEventListener(Event.ENTER_FRAME, tick);
            t = getTimer();
        }
		
        public function tick(param1:Event) : void {
            var _loc_2:Number;
            var _loc_3:Number;
            var _loc_4:Number;
            var _loc_5:Number;
            var _loc_6:int;
            var _loc_7:int;
            var _loc_8:Number;
            _loc_2 = getTimer();
            _loc_3 = _loc_2 - t;
            arr.push(_loc_3);
            if (arr.length > 10) {
                arr.shift();
            }
            _loc_4 = 0;
            _loc_5 = 0;
            _loc_6 = arr.length;
            _loc_7 = 0;
            while (_loc_7 < _loc_6) {
                _loc_8 = arr[_loc_7] as int;
                _loc_4 = _loc_4 + _loc_8;
                if (_loc_8 > _loc_5)
                {
                    _loc_5 = _loc_8;
                }
                _loc_7++;
            }
            mem.text = int(System.totalMemory / 1000000) + "mb";
            fps.text = int(1000 / (_loc_4 / _loc_6)) + "fps";
            lowfps.text = int(1000 / _loc_5) + "fps";
            t = _loc_2;
            return;
        }
    }
}
