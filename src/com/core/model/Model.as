package com.core.model
{
   import com.core.observer.Dispatcher;
   import org.green.server.core.GreenSocket;
   import org.green.server.manager.SocketManager;
   
   public class Model extends Dispatcher
   {
      
      public static var NAME:String = "Model";
      
      protected var con:GreenSocket;
      
      protected var modelName:String;
      
      public function Model(modelName:String = null)
      {
         super();
         this.modelName = modelName != null ? modelName : NAME;
         this.con = SocketManager.getGreenSocket();
      }
      
      public function onRegister() : void
      {
      }
      
      public function registerListener(type:String, handlerFunc:Function) : void
      {
         this.con.addEventListener(type,handlerFunc);
      }
      
      public function deregisterListener(type:String, handlerFunc:Function) : void
      {
         this.con.removeEventListener(type,handlerFunc);
      }
      
      public function onRemove() : void
      {
      }
      
      public function getModelName() : String
      {
         return this.modelName;
      }
   }
}

