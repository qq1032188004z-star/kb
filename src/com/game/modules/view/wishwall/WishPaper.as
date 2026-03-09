package com.game.modules.view.wishwall
{
   import flash.display.Sprite;
   
   public class WishPaper extends Sprite
   {
      
      private var xx:Number = -275;
      
      private var yy:Number = -130;
      
      public function WishPaper()
      {
         super();
         this.cacheAsBitmap = true;
      }
      
      public function addItem(params:Object) : void
      {
         if(!params)
         {
            return;
         }
         var item:WishPaperItem = new WishPaperItem(params);
         this.addChild(item);
      }
      
      public function rankItems() : void
      {
         var i:int = 0;
         var tempx:Number = NaN;
         var tempy:Number = NaN;
         var count:int = this.numChildren;
         for(i = 0; i < count; i++)
         {
            tempx = this.xx + int(Math.random() * 630);
            tempy = this.yy + int(Math.random() * 120);
            this.getChildAt(i).x = tempx;
            this.getChildAt(i).y = tempy;
         }
      }
      
      public function removeAll() : void
      {
         var i:int = 0;
         var num:int = this.numChildren;
         for(i = 0; i < num; i++)
         {
            (this.getChildAt(0) as WishPaperItem).disport();
         }
      }
   }
}

