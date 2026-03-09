package com.game.dohko.util
{
   import com.game.dohko.view.BaseDisplay;
   import flash.utils.Dictionary;
   
   public class ViewCacheUtil
   {
      
      private static var _instance:ViewCacheUtil;
      
      private var _displays:Dictionary;
      
      public function ViewCacheUtil(c:PrivateClass)
      {
         super();
         if(c == null)
         {
            throw new Error("请通过.instance获取实例");
         }
         this._displays = new Dictionary();
      }
      
      public static function get instance() : ViewCacheUtil
      {
         if(_instance == null)
         {
            _instance = new ViewCacheUtil(new PrivateClass());
         }
         return _instance;
      }
      
      public static function destroyStatic() : void
      {
         if(Boolean(_instance))
         {
            _instance.dispose();
         }
         _instance = null;
      }
      
      public function getCache(cls:Class, params:Object = null, loadSequence:int = 1) : BaseDisplay
      {
         var exist:BaseDisplay = this._displays[cls];
         if(exist == null)
         {
            exist = this._displays[cls] = new cls() as BaseDisplay;
         }
         exist.loadSequence = loadSequence;
         exist.moduleParams = params;
         return exist;
      }
      
      public function deleteCache(cls:Class) : void
      {
         this._displays[cls] = null;
         delete this._displays[cls];
      }
      
      private function disposAll() : void
      {
         var auctBaseDisPlay:BaseDisplay = null;
         var key:Object = null;
         for(key in this._displays)
         {
            auctBaseDisPlay = this._displays[key];
            if(auctBaseDisPlay != null)
            {
               auctBaseDisPlay.dispos();
               auctBaseDisPlay = null;
            }
            this._displays[key] = null;
            delete this._displays[key];
         }
      }
      
      public function dispose() : void
      {
         this.disposAll();
         this._displays = null;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
