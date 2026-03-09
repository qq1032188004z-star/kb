package com.game.util
{
   import flash.utils.Dictionary;
   import mx.utils.StringUtil;
   
   public class LuaObjUtil
   {
      
      private static const CLASS_PREFIX:String = "<%CLASS%>";
      
      private static const REPLACE_EQ:String = "<%EQUAL%>";
      
      private static var objDic:Dictionary = new Dictionary();
      
      private static var objIndex:int = 0;
      
      public function LuaObjUtil()
      {
         super();
      }
      
      public static function getLuaObj(luaStr:String) : Object
      {
         var result:Object = null;
         var key:String = null;
         var comparedStr:String = null;
         var objKey:String = null;
         if(!luaStr || luaStr == "" || StringUtil.trim(luaStr) == "")
         {
            return null;
         }
         try
         {
            objIndex = 0;
            luaStr = preParse(luaStr);
            while(luaStr.indexOf("{") >= 0)
            {
               comparedStr = findComparedStr(luaStr);
               objKey = parseObjectToDic(comparedStr);
               luaStr = luaStr.split(comparedStr).join(objKey);
            }
            result = objDic[luaStr];
            for(key in objDic)
            {
               delete objDic[key];
            }
         }
         catch(error:Error)
         {
         }
         if(result == null)
         {
            throw new Error("请检查配置，无法解析的lua对象：" + luaStr);
         }
         return result;
      }
      
      public static function getLuaObjArr(luaStr:String) : Array
      {
         var objs:Object = null;
         var arr:Array = [];
         var obj:Object = getLuaObj(luaStr);
         if(Boolean(obj))
         {
            for each(objs in obj)
            {
               arr.push(objs);
            }
         }
         return arr;
      }
      
      private static function preParse(luaStr:String) : String
      {
         var startIndex:int = 0;
         var endIndex:int = 0;
         var tmpStr:String = null;
         var targetStr:String = null;
         var result:String = luaStr;
         var exp:RegExp = /\s+/g;
         result = result.replace(exp,"");
         while(result.indexOf("\'") >= 0)
         {
            startIndex = result.indexOf("\'");
            endIndex = result.indexOf("\'",startIndex + 1);
            if(endIndex < 0)
            {
               throw new Error("单引号数量为奇数：" + luaStr);
            }
            tmpStr = result.substring(startIndex,endIndex + 1);
            targetStr = tmpStr.split("\'").join("").split("=").join(REPLACE_EQ);
            result = result.split(tmpStr).join(targetStr);
         }
         return result;
      }
      
      public static function findComparedStr(str:String) : String
      {
         var rightIndex:int = str.indexOf("}");
         var leftIndex:int = str.lastIndexOf("{",rightIndex);
         return str.substring(leftIndex,rightIndex + 1);
      }
      
      private static function parseObjectToDic(str:String) : String
      {
         var obj:Object = parseObject(str);
         ++objIndex;
         var key:String = CLASS_PREFIX + objIndex;
         objDic[key] = obj;
         return key;
      }
      
      public static function parseObject(str:String) : Object
      {
         var arr:Array = null;
         var i:String = null;
         var obj:Object = null;
         var j:String = null;
         var kv:Array = null;
         var key:String = null;
         var index:int = 0;
         var value:Object = null;
         var data:String = str.substring(1,str.length - 1);
         if(data.indexOf("=") < 0)
         {
            arr = data.split(",");
            for(i in arr)
            {
               arr[i] = parseType(arr[i]);
            }
            return arr;
         }
         obj = {};
         arr = data.split(",");
         for(j in arr)
         {
            kv = arr[j]["split"]("=");
            key = String(kv[0]);
            index = key.indexOf("[");
            if(index >= 0)
            {
               key = key.substring(index + 1,key.indexOf("]"));
            }
            value = parseType(kv[1]);
            obj[key] = value;
         }
         return obj;
      }
      
      private static function parseType(str:String) : Object
      {
         var obj:Object = null;
         if(Boolean(Number(str)))
         {
            return Number(str);
         }
         if(Boolean(objDic[str]))
         {
            return objDic[str];
         }
         return str.split(REPLACE_EQ).join("=");
      }
   }
}

