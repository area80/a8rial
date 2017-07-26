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

	import com.adobe.serialization.adobejson.AdobeJSON;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	/**
	 * Map an anonymous object to specify class, useful when use with JSON
	 * @author wissarut
	 *
	 */
	public class ClassMapper
	{
		/**
		 * Convert JSON String to a specify class
		 * @param jsonstr
		 * @param objClass
		 * @return
		 *
		 */
		public static function JSONToClass(jsonstr:String, objClass:Class):*
		{
			var json:Object = AdobeJSON.decode(jsonstr);
			return map(json, objClass);
		}

		/**
		 * Convert anonymous object to a specify class
		 * @param obj input anonymous object
		 * @param objClass class to be mapped
		 * @return
		 *
		 */
		public static function map(obj:Object, objClass:Class):*
		{
			var returnObject:Object = new (objClass)();
			var propertyMap:XML = describeType(returnObject);
			var propertyTypeClass:Class;
			for each (var varList:XMLList in[propertyMap.variable, propertyMap.accessor]) {

				for each (var property:XML in varList) {
					if ((obj as Object).hasOwnProperty(property.@name)) {
						propertyTypeClass = getDefinitionByName(property.@type) as Class;
						if (obj[property.@name] is Array) {
							var array:Array = obj[property.@name] as Array;
							var split:Array = String(property.@type).split("Vector.");
							var innerClassName:String = String(split[1]).slice(1, -1);
							var innerClass:Class = getDefinitionByName(innerClassName) as Class;
							returnObject[property.@name] = new propertyTypeClass();
							for each (var item:* in obj[property.@name]) {
								returnObject[property.@name].push(map(item, innerClass));
							}
						} else if (obj[property.@name] is (propertyTypeClass)) {
							returnObject[property.@name] = obj[property.@name];
						} else {
							returnObject[property.@name] = map(obj[property.@name], propertyTypeClass);
						}
					}
				}

			}
			return returnObject;
		}
	}
}
