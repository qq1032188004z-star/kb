package com.game.modules.vo.monster
{
   public class MonsterIntroVo
   {
      
      public var id:int;
      
      public var weight:String;
      
      public var height:String;
      
      public var intro:String;
      
      public var name:String;
      
      public var group:int;
      
      public var elem:int;
      
      public var growup:int;
      
      public var nextmonsterid:int;
      
      public var iscontinue:int;
      
      public var sequence:String;
      
      public var distribute:String;
      
      public var food:String;
      
      public var siteList:Array;
      
      public function MonsterIntroVo()
      {
         super();
         this.initialize();
      }
      
      public function initialize() : void
      {
         this.weight = "未知";
         this.height = "未知";
         this.intro = "未知";
         this.name = "未知名字";
         this.group = 0;
      }
   }
}

