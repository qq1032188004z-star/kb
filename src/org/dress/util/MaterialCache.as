package org.dress.util
{
   import flash.utils.Dictionary;
   import org.dress.ui.DecorationDataVO;
   
   public class MaterialCache
   {
      
      public static var instance:MaterialCache = new MaterialCache();
      
      private var length:int;
      
      private var dic:Dictionary = new Dictionary(true);
      
      public function MaterialCache()
      {
         super();
      }
      
      public function hasUrl(url:String) : Boolean
      {
         if(this.dic[url] == null)
         {
            return false;
         }
         return true;
      }
      
      public function pushDecorationData(url:String, decorationData:DecorationDataVO) : void
      {
         if(!this.hasUrl(url))
         {
            ++this.length;
            this.dic[url] = decorationData;
         }
      }
      
      public function getDecorationData(url:String) : DecorationDataVO
      {
         return this.dic[url];
      }
      
      public function realseCache() : void
      {
         var key:* = undefined;
         var item:DecorationDataVO = null;
         for(key in this.dic)
         {
            item = this.dic[key] as DecorationDataVO;
            if(Boolean(item) && item.canDispose())
            {
               item.dispose();
               this.dic[key] = null;
               delete this.dic[key];
               --this.length;
            }
         }
      }
   }
}

