package com.publiccomponent.util
{
   import com.publiccomponent.ui.ButtonEffect;
   import flash.display.DisplayObject;
   
   public class ButtonEffectUtil
   {
      
      private static var _effects:Array = [];
      
      public function ButtonEffectUtil()
      {
         super();
      }
      
      public static function registerEffect(btn:DisplayObject, effectType:int = 1, lightVisible:Boolean = true, xCoode:Number = 0, yCoode:Number = 0, time:int = 0) : void
      {
         var specia:ButtonEffect = getEffect(btn);
         if(Boolean(specia))
         {
            return;
         }
         var effect:ButtonEffect = new ButtonEffect(effectType,btn,lightVisible,time);
         if(xCoode != 0 || yCoode != 0)
         {
            effect.setPoint(xCoode,yCoode);
         }
         _effects.push(effect);
      }
      
      private static function getEffect(btn:DisplayObject) : ButtonEffect
      {
         var specia:ButtonEffect = null;
         for each(specia in _effects)
         {
            if(specia.btn == btn)
            {
               return specia;
            }
         }
         return null;
      }
      
      private static function hasEffect(btn:DisplayObject) : Boolean
      {
         return getEffect(btn) != null;
      }
      
      public static function delEffect(btn:DisplayObject) : void
      {
         var info:ButtonEffect = null;
         if(btn == null)
         {
            return;
         }
         for(var i:int = 0; i < _effects.length; i++)
         {
            info = _effects[i];
            if(Boolean(info) && info.btn == btn)
            {
               _effects.splice(i,1);
               info.disport();
               info = null;
               break;
            }
         }
      }
   }
}

