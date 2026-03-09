package com.xygame.module.battle.util
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class NewBloodMc extends BloodMc
   {
      
      private var _recycleCallback:Function;
      
      public function NewBloodMc()
      {
         super();
      }
      
      public function showWithRecycle(value:int, parent:Sprite, isLeft:Boolean = true, showMiss:Boolean = true, isCritical:Boolean = false, isRestore:Boolean = false, offset:Point = null, recycleCallback:Function = null) : void
      {
         this._recycleCallback = recycleCallback;
         show(value,parent,isLeft,showMiss,isCritical,isRestore,offset);
      }
      
      public function reset() : void
      {
         stopAnimationInternal();
         this.clearTimeoutInternal();
         removeListenersInternal();
         clearAllChildren();
         resetInternal();
         this.resetDisplayProperties();
         this._recycleCallback = null;
      }
      
      private function resetDisplayProperties() : void
      {
         this.visible = true;
         this.scaleX = 1;
         this.scaleY = 1;
         this.x = 0;
         this.y = 0;
         this.alpha = 1;
         this.rotation = 0;
      }
      
      override public function dispose() : void
      {
         var callback:Function = null;
         stopAnimationInternal();
         this.clearTimeoutInternal();
         removeListenersInternal();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this.visible = false;
         if(this._recycleCallback != null)
         {
            callback = this._recycleCallback;
            this._recycleCallback = null;
            callback(this);
         }
      }
      
      private function hideChildren() : void
      {
         if(this.hasBackground())
         {
            this.getBackground().visible = false;
            if(Boolean(this.getBackground().hasOwnProperty("baoji")))
            {
               this.getBackground()["baoji"].visible = false;
            }
         }
         if(this.hasNumberDisplay())
         {
            this.cleanupNumberDisplay();
         }
      }
      
      private function cleanupNumberDisplay() : void
      {
         var child:* = undefined;
         var numDisplay:Sprite = this.getNumberDisplay();
         if(this.contains(numDisplay))
         {
            this.removeChild(numDisplay);
         }
         while(numDisplay.numChildren > 0)
         {
            child = numDisplay.getChildAt(0);
            if(child is MovieClip)
            {
               MovieClip(child).stop();
            }
            numDisplay.removeChildAt(0);
         }
         this.clearNumberDisplay();
      }
      
      private function stopAnimation() : void
      {
         if(this.hasOwnProperty("stopAnimationInternal"))
         {
            this["stopAnimationInternal"]();
         }
      }
      
      override protected function clearTimeoutInternal() : void
      {
         if(this.hasOwnProperty("clearTimeoutInternal"))
         {
            this["clearTimeoutInternal"]();
         }
      }
      
      private function removeListeners() : void
      {
         if(this.hasOwnProperty("removeListenersInternal"))
         {
            this["removeListenersInternal"]();
         }
      }
      
      private function removeFromParent() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function hasBackground() : Boolean
      {
         return Boolean(this.hasOwnProperty("_mcbg")) && this["_mcbg"] != null;
      }
      
      private function getBackground() : *
      {
         return this["_mcbg"];
      }
      
      private function hasNumberDisplay() : Boolean
      {
         return Boolean(this.hasOwnProperty("_numMc")) && this["_numMc"] != null;
      }
      
      private function getNumberDisplay() : Sprite
      {
         return this["_numMc"] as Sprite;
      }
      
      private function clearNumberDisplay() : void
      {
         this["_numMc"] = null;
      }
   }
}

