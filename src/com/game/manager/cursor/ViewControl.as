package com.game.manager.cursor
{
   import com.kb.util.CommonDefine;
   import flash.events.EventDispatcher;
   
   public class ViewControl
   {
      
      private static var instance:ViewControl;
      
      private var eventDispatch:EventDispatcher;
      
      private var listenerArr:Array;
      
      public function ViewControl()
      {
         super();
         this.eventDispatch = new EventDispatcher();
         this.listenerArr = [];
         if(instance != null)
         {
            throw new Error(CommonDefine.CONSTRUCTERROR);
         }
      }
      
      public static function getInstance() : ViewControl
      {
         if(instance == null)
         {
            instance = new ViewControl();
         }
         return instance;
      }
      
      public function registerListener(type:String, listener:Function) : void
      {
         this.eventDispatch.addEventListener(type,listener,false,0,true);
         this.listenerArr.push(type);
      }
      
      public function removeListener(type:String, listener:Function) : void
      {
         var index:int = int(this.listenerArr.indexOf(type));
         this.listenerArr.splice(index,1);
         this.eventDispatch.removeEventListener(type,listener,false);
      }
      
      public function send(type:String, body:Object = null) : Boolean
      {
         return this.eventDispatch.dispatchEvent(new ViewEvent(type,body));
      }
      
      public function getListenerNum() : int
      {
         return this.listenerArr.length;
      }
      
      public function getListenerArr() : Array
      {
         return this.listenerArr;
      }
   }
}

