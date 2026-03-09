package com.publiccomponent.loading
{
   import flash.system.ApplicationDomain;
   
   public class MaterialLib
   {
      
      private static var instance:MaterialLib;
      
      private var materialList:Array = [];
      
      private var urlList:Array = [];
      
      public function MaterialLib()
      {
         super();
         if(instance != null)
         {
            throw new Error("单例类只能被实例化一次");
         }
         instance = this;
      }
      
      public static function getInstance() : MaterialLib
      {
         if(instance == null)
         {
            instance = new MaterialLib();
         }
         return instance;
      }
      
      public function getMaterial(name:String) : Object
      {
         var result:Object = null;
         var domain:ApplicationDomain = null;
         var cls:Class = null;
         for each(domain in this.materialList)
         {
            if(domain.hasDefinition(name))
            {
               cls = domain.getDefinition(name) as Class;
               result = new cls();
            }
         }
         return result;
      }
      
      public function check(key:String) : Boolean
      {
         var result:Boolean = false;
         if(this.urlList.indexOf(key) != -1)
         {
            result = true;
         }
         return result;
      }
      
      public function push(key:String, value:ApplicationDomain) : void
      {
         this.urlList.push(key);
         this.materialList.push(value);
      }
   }
}

