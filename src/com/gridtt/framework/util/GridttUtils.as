package com.gridtt.framework.util
{

	import flash.display.Loader;
	import flash.filters.BlurFilter;
	import flash.system.System;
	import flash.utils.getQualifiedClassName;

	public class GridttUtils
	{
		public static function cloneArray(src:Array, cloneObject:Boolean = false):Array
		{
			var res:Array = new Array();
			for (var i:int = 0; i < src.length; i++) {
				if (cloneObject) {

					if (typeof(src[i].clone) == "function") {
						var o:* = src[i].clone();
						if (getQualifiedClassName(o) == getQualifiedClassName(src[i])) {
							res.push(o);
						} else {
							res.push(src[i]);
						}
					}
				} else {
					res.push(src[i]);
				}
			}
			return res;
		}

		/**
		 * Clear and Unload the specify loader
		 * @param ldr input loader
		 *
		 */
		public static function clearLoader(ldr:Loader, gc:Boolean = false):void
		{
			if (ldr.parent && ldr.parent.contains(ldr)) {
				ldr.parent.removeChild(ldr);
			}
			try {
				ldr.close();
			} catch (e:Error) {
			}
			try {
				ldr.unload();
			} catch (e:Error) {
			}
			if (gc)
				System.gc();
		}


	}
}
