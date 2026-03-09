package com.game.modules.view
{
   import flash.utils.Dictionary;
   
   public class HorseTipManager
   {
      
      public static var dic:Dictionary = new Dictionary();
      
      public function HorseTipManager()
      {
         super();
      }
      
      public static function getHorseTip(name:String = "") : HorseTip
      {
         var horseTip:HorseTip = dic[name];
         if(horseTip == null)
         {
            horseTip = new HorseTip();
            dic[name] = horseTip;
         }
         return horseTip;
      }
      
      public static function getBatchUseTip(name:String = "batchUse") : BatchUseClip
      {
         var batchUse:BatchUseClip = dic[name];
         if(batchUse == null)
         {
            batchUse = new BatchUseClip();
            dic[name] = batchUse;
         }
         return batchUse;
      }
   }
}

