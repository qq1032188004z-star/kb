package com.game.util
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.utils.Dictionary;
   
   public class DictionaryCla
   {
      
      private var _length:int = 0;
      
      public var dic:Dictionary;
      
      public function DictionaryCla()
      {
         super();
         this.dic = new Dictionary();
      }
      
      public function pushValue(code:*, value:*) : void
      {
         this.dic[code] = value;
         ++this._length;
      }
      
      public function deleteValue(code:*) : void
      {
         var display:DisplayObject = this.dic[code] as DisplayObject;
         if(Boolean(display))
         {
            if(display is Loader)
            {
               Loader(display).unloadAndStop(false);
            }
            if(Boolean(display.parent))
            {
               display.parent.removeChild(display);
            }
         }
         delete this.dic[code];
         --this._length;
      }
      
      public function getValueByCode(code:int) : DisplayObject
      {
         return this.dic[code];
      }
      
      public function deleteAll() : void
      {
         var key:String = null;
         for(key in this.dic)
         {
            delete this.dic[key];
            --this._length;
         }
      }
      
      public function get length() : int
      {
         return this._length;
      }
   }
}

