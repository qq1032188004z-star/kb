package com.core.manager
{
   import com.core.model.Model;
   import com.core.observer.Dispatcher;
   import com.core.view.ViewLogic;
   
   public class Facade extends Dispatcher
   {
      
      protected static var instance:Facade;
      
      protected const SINGLETON_MSG:String = "门面单例类已经被实例化!";
      
      protected var modelManager:ModelManager;
      
      protected var viewManager:ViewManager;
      
      public function Facade()
      {
         super();
         if(instance != null)
         {
            throw Error(this.SINGLETON_MSG);
         }
         instance = this;
      }
      
      public static function getInstance() : Facade
      {
         if(instance == null)
         {
            instance = new Facade();
         }
         return instance;
      }
      
      public function startUp() : void
      {
         this.initializeFacade();
      }
      
      public function removeModel(modelName:String) : Model
      {
         var model:Model = null;
         if(model == null)
         {
            model = this.modelManager.removeModel(modelName);
         }
         return model;
      }
      
      public function registerModel(model:Model) : void
      {
         this.modelManager.registerModel(model);
      }
      
      protected function initializeFacade() : void
      {
         this.initModelManager();
         this.initViewManager();
      }
      
      public function retrieveModel(modelName:String) : Model
      {
         return this.modelManager.retrieveModel(modelName);
      }
      
      public function hasModel(modelName:String) : Boolean
      {
         return this.modelManager.hasModel(modelName);
      }
      
      protected function initModelManager() : void
      {
         if(this.modelManager != null)
         {
            return;
         }
         this.modelManager = ModelManager.getInstance();
      }
      
      public function removeViewLogic(viewName:String) : ViewLogic
      {
         var view:ViewLogic = null;
         if(view == null)
         {
            view = this.viewManager.removeViewLogic(viewName);
         }
         return view;
      }
      
      public function registerViewLogic(viewLogic:ViewLogic) : void
      {
         if(viewLogic != null)
         {
            this.viewManager.registerViewLogic(viewLogic);
         }
      }
      
      protected function initViewManager() : void
      {
         if(this.viewManager != null)
         {
            return;
         }
         this.viewManager = ViewManager.getInstance();
      }
      
      public function retrieveViewLogic(viewName:String) : ViewLogic
      {
         return this.viewManager.retrieveViewLogic(viewName) as ViewLogic;
      }
      
      public function hasViewLogic(viewName:String) : Boolean
      {
         return this.viewManager.hasViewLogic(viewName);
      }
   }
}

