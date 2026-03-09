package com.core.manager
{
   import com.core.model.Model;
   import com.core.observer.Dispatcher;
   
   public final class ModelManager extends Dispatcher
   {
      
      protected static var instance:ModelManager;
      
      protected const SINGLETON_MSG:String = "Model单例类已经被实例化!";
      
      protected var modelMap:Array;
      
      public function ModelManager()
      {
         super();
         if(instance != null)
         {
            throw Error(this.SINGLETON_MSG);
         }
         instance = this;
         this.modelMap = new Array();
         this.initModelManager();
      }
      
      public static function getInstance() : ModelManager
      {
         if(instance == null)
         {
            instance = new ModelManager();
         }
         return instance;
      }
      
      protected function initModelManager() : void
      {
      }
      
      public function removeModel(modelName:String) : Model
      {
         var model:Model = this.modelMap[modelName] as Model;
         if(Boolean(model))
         {
            this.modelMap[modelName] = null;
            model.onRemove();
         }
         return model;
      }
      
      public function registerModel(model:Model) : void
      {
         this.modelMap[model.getModelName()] = model;
         model.onRegister();
      }
      
      public function retrieveModel(modelName:String) : Model
      {
         return this.modelMap[modelName];
      }
      
      public function hasModel(modelName:String) : Boolean
      {
         return this.modelMap[modelName] != null;
      }
   }
}

