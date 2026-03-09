package com.core.view
{
   import com.core.observer.Dispatcher;
   
   public class ViewLogic extends Dispatcher
   {
      
      public static const NAME:String = "ViewLogic";
      
      protected var viewName:String;
      
      protected var viewComponent:Object;
      
      public function ViewLogic(viewName:String = null, viewComponent:Object = null)
      {
         super();
         this.viewName = viewName != null ? viewName : NAME;
         this.viewComponent = viewComponent;
      }
      
      public function onRegister() : void
      {
      }
      
      public function setViewComponent(viewComponent:Object) : void
      {
         this.viewComponent = viewComponent;
      }
      
      public function listEvents() : Array
      {
         return [];
      }
      
      public function getViewComponent() : Object
      {
         return this.viewComponent;
      }
      
      public function onRemove() : void
      {
      }
      
      public function getViewName() : String
      {
         return this.viewName;
      }
   }
}

