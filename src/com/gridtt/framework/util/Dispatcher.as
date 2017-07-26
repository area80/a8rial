/*
Copyright © 2008-2011, Area80 Co.,Ltd.
All rights reserved.

Facebook: http://www.fb.com/Area80/
Website: http://www.area80.net/


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

* Neither the name of Area80 Incorporated nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.gridtt.framework.util
{

	import flash.errors.IllegalOperationError;

	/**
	 * Dispatcher acts as Signal class but only one argument can be applied.
	 * Sitemanager uses Dispatcher in place of Signal class to be light weight
	 * @author wissarut
	 *
	 */
	public class Dispatcher
	{
		protected var cls:Class;
		protected var listeners:Array;

		/**
		 * Dispatcher acts as Signal class but only one argument can be applied.
		 * @param $cls value class that will be dispatched when event fires
		 *
		 */
		public function Dispatcher($cls:Class = null)
		{

			cls = $cls;
			listeners = new Array();

		}

		public function add($fnc:Function):void
		{

			if (listeners.indexOf($fnc) < 0) {
				listeners.push($fnc);
			}

		}

		public function dispatch($vo:*=null):void
		{

			var i:int;
				
			if (cls  === null && $vo === null) {
				for (i = 0; i < listeners.length; i++) {
					listeners[i]();
				}
			} else if ($vo === null || $vo is cls) {
				for (i = 0; i < listeners.length; i++) {
					listeners[i]($vo);
				}
			} else {
				throw new Error(this, $vo + ' is not an instance of ' + cls + '.');
			}

		}
 
		public function remove($fnc:Function):Function
		{

			var index:int = listeners.indexOf($fnc);
			if (index == -1)
				return $fnc;
			listeners.splice(index, 1);
			return $fnc;

		}

		public function removeAll():void
		{

			for (var i:uint = listeners.length; i--; ) {
				remove(listeners[i] as Function);
			}

		}
	}
}
