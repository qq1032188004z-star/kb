package com.kb.util
{
   public class Handler
   {
      
      private var h:Object;
      
      private var m:Object;
      
      private var p:Object;
      
      public function Handler(reference:Object, method:Object, arguement:* = null)
      {
         super();
         this.h = reference;
         this.m = method;
         this.p = arguement;
      }
      
      public function dispatch(data:* = null) : void
      {
         if(this.m != null)
         {
            (this.m as Function).apply(this.h,[this.p,data]);
         }
      }
      
      public function get reference() : Object
      {
         return this.h;
      }
      
      public function get method() : Object
      {
         return this.m;
      }
      
      public function get arguement() : Object
      {
         return this.p;
      }
      
      public function dispose() : void
      {
         this.h = null;
         this.m = null;
         this.p = null;
      }
   }
}

