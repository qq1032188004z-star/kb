package com.game.modules.view.chat
{
   import com.game.modules.view.item.PublicChatItem;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class PubChatView extends Sprite
   {
      
      public function PubChatView()
      {
         super();
      }
      
      public function addItem(params:Object) : void
      {
         if(this.numChildren >= 50)
         {
            this.removeChildAt(0);
         }
         var item:PublicChatItem = new PublicChatItem(params);
         this.addChild(item);
         this.rankItems();
      }
      
      private function rankItems() : void
      {
         var item:DisplayObject = null;
         var tempy:Number = NaN;
         var count:int = this.numChildren;
         var i:int = 0;
         for(i = 0; i < count; i++)
         {
            if(i > 0)
            {
               item = this.getChildAt(i - 1);
               tempy = item.y + item.height + 3;
               this.getChildAt(i).y = tempy;
            }
            else
            {
               this.getChildAt(0).y = 0;
            }
         }
      }
   }
}

