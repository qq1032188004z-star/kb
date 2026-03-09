package com.game.modules.view.wishwall
{
   import com.game.manager.EventManager;
   import com.game.util.HLoaderSprite;
   import flash.events.MouseEvent;
   
   public class WishPaperPreview extends HLoaderSprite
   {
      
      private var data:Object;
      
      private var paperItem:WishPaperItem;
      
      public function WishPaperPreview(params:Object)
      {
         super();
         this.data = params;
         this.url = "assets/wishwall/wishpreview.swf";
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         this.paperItem = new WishPaperItem(this.data);
         this.paperItem.show(this,410,200);
         this.paperItem.mouseEnabled = false;
         EventManager.attachEvent(bg["sureBtn"],MouseEvent.MOUSE_DOWN,this.onSure);
      }
      
      private function onSure(evt:MouseEvent) : void
      {
         EventManager.removeEvent(bg["sureBtn"],MouseEvent.MOUSE_DOWN,this.onSure);
         this.paperItem.disport();
         this.data = null;
         this.disport();
      }
   }
}

