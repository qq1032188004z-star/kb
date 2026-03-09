package com.xygame.module.battle.util
{
   import flash.utils.getDefinitionByName;
   
   public class GetGameClass
   {
      
      public function GetGameClass()
      {
         super();
      }
      
      public static function hShowAuto() : void
      {
         getDefinitionByName("com.xygame.module.util.HodamMouse").instance.hShowAuto();
      }
      
      public static function get AppGlobal() : Class
      {
         return getDefinitionByName("com.game.global.GlobalConfig") as Class;
      }
      
      public static function get AppFace() : Object
      {
         return getDefinitionByName("com.game.facade.ApplicationFacade");
      }
      
      public static function get MD() : Object
      {
         return getDefinitionByName("com.game.locators.MsgDoc");
      }
      
      public static function get LS() : Object
      {
         return getDefinitionByName("com.xygame.module.spiritLevelUp.view.LearnSkill");
      }
      
      public static function get LU() : Object
      {
         return getDefinitionByName("com.xygame.module.spiritLevelUp.view.LevelUpWindow");
      }
      
      public static function hShowHand() : void
      {
         getDefinitionByName("com.xygame.module.util.HodamMouse").instance.hShowHand();
      }
      
      public static function get AppMapMediator() : Object
      {
         return getDefinitionByName("com.game.modules.control.MapControl");
      }
   }
}

