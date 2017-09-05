import Macro.transform;
import js.Promise;

typedef Continuation<T> = T->Void;

class Main {
	// some async API
	static var nextNumber = 0;
	static function getNumber(cb:Int->Void) cb(++nextNumber);
	static function getNumberPromise() return new Promise((resolve,_) -> getNumber(resolve));

	// known (hard-coded for now) suspending functions
	inline static function await<T>(f:(T->Void)->Void, cont:Continuation<T>):Void
		f(cont);

	inline static function awaitPromise<T>(p:Promise<T>, cont:Continuation<T>):Void
		p.then(cont);

	static function test(n:Int, cont:Continuation<String>):Void
		cont('hi $n times');

	static function test_async() {
		// sample coroutine
		var coro = transform(function(n:Int):Int {

			trace("hi");

			while (await(getNumber) < 10) {
				trace('wait for it...');

				var promise = getNumberPromise();
				trace(awaitPromise(promise));
			}

			trace("bye");
			return 15;

		});

		var cont = coro(10, value -> trace('Result: $value'));
		cont(null); // manually start
	}

	static function test_generator() {
		// generator
		var fibCoro = transform(function(yield):Void {
			yield(1); // first Fibonacci number
			var cur = 1;
			var next = 1;
			while (true) {
				yield(next); // next Fibonacci number
				var tmp = cur + next;
				cur = next;
				next = tmp;
			}
		});

		for (v in new Gen(fibCoro)) {
			trace(v);
			if (v > 10000)
				break;
		}
	}

	static function main() {
		test_async();
		test_generator();
	}
}

typedef Yield<T> = T->Continuation<Any>->Void;

enum GenState {
	NotReady;
	Ready;
	Done;
	Failed;
}

class Gen {
	var nextStep:Continuation<Any>;
	var nextValue:Int;
	var state:GenState;

	public function new(cont:Yield<Int>->Continuation<Dynamic>->Continuation<Any>) {
		nextStep = cont(yield, done);
		state = NotReady;
	}

	function yield(value:Int, next:Continuation<Dynamic>) {
		nextValue = value;
		state = Ready;
	}

	function done(result:Any) {
		state = Done;
	}

	public function hasNext():Bool {
		return switch state {
			case Done: false;
			case Ready: true;
			case _:
				state = Failed;
				nextStep(null);
				state == Ready;
		}
	}

	public function next():Int {
		if (!hasNext()) throw "no more";
		state = NotReady;
		return nextValue;
	}
}
