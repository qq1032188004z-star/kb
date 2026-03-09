package com.core.manager
{
   import com.core.observer.Observer;
   import com.core.view.ViewLogic;
   
   public final class ViewManager
   {
      
      protected static var instance:ViewManager;
      
      protected var viewLogicMap:Array;
      
      protected const SINGLETON_MSG:String = "View单例已经被实例化!";
      
      public function ViewManager()
      {
         super();
         if(instance != null)
         {
            throw Error(this.SINGLETON_MSG);
         }
         instance = this;
         this.viewLogicMap = new Array();
         this.initViewManager();
      }
      
      internal static function getInstance() : ViewManager
      {
         if(instance == null)
         {
            instance = new ViewManager();
         }
         return instance;
      }
      
      protected function initViewManager() : void
      {
      }
      
      public function addEventListener(type:String, handlerFunc:Function) : void
      {
         Observer.getInstance().addEventListener(type,handlerFunc);
      }
      
      public function removeEventListener(type:String, handlerFunc:Function) : void
      {
         Observer.getInstance().removeEventListener(type,handlerFunc);
      }
      
      public function registerViewLogic(viewLogic:ViewLogic) : void
      {
         this.viewLogicMap[viewLogic.getViewName()] = viewLogic;
         var events:Array = viewLogic.listEvents();
         for(var i:Number = 0; i < events.length; i++)
         {
            this.addEventListener(events[i][0],events[i][1]);
         }
         viewLogic.onRegister();
      }
      
      public function retrieveViewLogic(viewName:String) : ViewLogic
      {
         return this.viewLogicMap[viewName];
      }
      
      public function removeViewLogic(viewName:String) : ViewLogic
      {
         var events:Array = null;
         var i:Number = NaN;
         var viewLogic:ViewLogic = this.viewLogicMap[viewName] as ViewLogic;
         if(Boolean(viewLogic))
         {
            events = viewLogic.listEvents();
            for(i = 0; i < events.length; i++)
            {
               this.removeEventListener(events[i][0],events[i][1]);
            }
            delete this.viewLogicMap[viewName];
            viewLogic.onRemove();
         }
         return viewLogic;
      }
      
      public function hasViewLogic(viewName:String) : Boolean
      {
         return this.viewLogicMap[viewName] != null;
      }
   }
}

