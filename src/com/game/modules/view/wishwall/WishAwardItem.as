package com.game.modules.view.wishwall
{
   import com.game.util.TimeTransform;
   import com.publiccomponent.list.ItemRender;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol456")]
   public class WishAwardItem extends ItemRender
   {
      
      public var msgTxt:TextField;
      
      public var bgmc:MovieClip;
      
      public function WishAwardItem()
      {
         super();
         this.msgTxt.text = "";
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      override public function set data(params:Object) : void
      {
         var str:String = null;
         if(params.hasOwnProperty("uname"))
         {
            str = "" + params.uname;
         }
         if(params.hasOwnProperty("time"))
         {
            str += " 在 " + TimeTransform.getInstance().transDate(params.time) + " 这一天许愿时，幸运地";
         }
         if(params.hasOwnProperty("isBingo"))
         {
            if(params.isBingo == 4)
            {
               str += "获得了一个白银葫芦的奖励。";
            }
            else if(params.isBingo == 5)
            {
               str += "获得了1000历练的奖励。";
            }
         }
         this.msgTxt.text = str;
         super.data = params;
      }
      
      private function onRemoved(evt:Event) : void
      {
         super.dispos();
      }
   }
}

