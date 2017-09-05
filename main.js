// Generated by Haxe 4.0.0 (git build development @ 7429981)
(function () { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var Main = function() { };
Main.getNumber = function(cb) {
	cb(++Main.nextNumber);
};
Main.getNumberPromise = function() {
	return new Promise(function(resolve,_) {
		Main.getNumber(resolve);
		return;
	});
};
Main.main = function() {
	(function(n,__continuation) {
		var __state = 0;
		var tmp0;
		var promise;
		var tmp1;
		var __stateMachine = null;
		__stateMachine = function(__result) {
			while(true) switch(__state) {
			case 0:
				console.log("Main.hx:26:","hi");
				__state = 1;
				break;
			case 1:
				__state = 2;
				Main.getNumber(__stateMachine);
				return;
			case 2:
				tmp0 = __result;
				if(tmp0 < 10) {
					__state = 3;
				} else {
					__state = 5;
				}
				break;
			case 3:
				console.log("Main.hx:29:","wait for it...");
				promise = Main.getNumberPromise();
				__state = 4;
				promise.then(__stateMachine);
				return;
			case 4:
				tmp1 = __result;
				console.log("Main.hx:32:",tmp1);
				__state = 1;
				break;
			case 5:
				console.log("Main.hx:35:","bye");
				__state = -1;
				__continuation(15);
				return;
			default:
				throw new js__$Boot_HaxeError("Invalid state");
			}
		};
		__stateMachine(null);
	})(10,function(value) {
		console.log("Main.hx:40:","Result: " + value);
		return;
	});
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) {
		Error.captureStackTrace(this,js__$Boot_HaxeError);
	}
};
js__$Boot_HaxeError.wrap = function(val) {
	if((val instanceof Error)) {
		return val;
	} else {
		return new js__$Boot_HaxeError(val);
	}
};
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
});
Main.nextNumber = 0;
Main.main();
})();
