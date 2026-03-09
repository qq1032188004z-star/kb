package com.game.modules.view.wishwall
{
   import com.game.locators.GameData;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class WishPaperItem extends HLoaderSprite
   {
      
      public static var ReportObject:Object;
      
      public var data:Object;
      
      public function WishPaperItem(body:Object = null)
      {
         super();
         this.data = body;
         this.url = "assets/wishwall/paper" + this.data.color + ".swf";
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         this.mouseChildren = false;
         bg["contentTxt"].mouseEnabled = false;
         bg["decoMc"].mouseEnabled = false;
         bg["nameTxt"].mouseEnabled = false;
         bg["secret"].mouseEnabled = false;
         bg["dragClip"].mouseEnabled = false;
         if(this.data.content == null || this.data.content == "null")
         {
            this.data.content = "";
         }
         if(this.data.status == 1)
         {
            bg["contentTxt"].text = String(this.data.content);
         }
         else
         {
            bg["contentTxt"].text = "该许愿内容正在审核中...";
         }
         if(this.data.uname == GameData.instance.playerData.userName)
         {
            bg["secret"].visible = false;
            bg["contentTxt"].visible = true;
            if(this.data.status != 1)
            {
               bg["contentTxt"].htmlText = String(this.data.content) + "<font color=\'#FF0000\'>（审核中）</font>";
            }
         }
         else
         {
            bg["secret"].visible = this.data.share == 1 ? false : true;
            bg["contentTxt"].visible = this.data.share == 1 ? true : false;
         }
         bg["dragClip"].gotoAndStop(int(this.data.form) + 1);
         bg["decoMc"].gotoAndStop(int(this.data.deco) + 1);
         bg["nameTxt"].text = this.data.uname;
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemove);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         this.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandler);
      }
      
      override public function disport() : void
      {
         this.data = null;
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemove);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         this.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandler);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
      
      private function onRemove(evt:Event) : void
      {
         this.disport();
      }
      
      private function onMouseDownHandler(evt:MouseEvent) : void
      {
         var i:int = 0;
         var len:int = 0;
         WishPaperItem.ReportObject = this.data;
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            len = this.parent.numChildren;
            for(i = 0; i < len; i++)
            {
               (this.parent.getChildAt(i) as WishPaperItem).filters = [];
            }
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
            this.filters = ColorUtil.setGrowFilter(16776960);
         }
         this.startDrag();
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
      }
      
      private function onMouseUpHandler(evt:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
         this.stopDrag();
      }
      
      private function onMouseMoveHandler(event:MouseEvent) : void
      {
         if(stage == null)
         {
            this.stopDrag();
            return;
         }
         if(stage.mouseX < 100 || stage.mouseX > 890 || stage.mouseY < 170 || stage.mouseY > 450)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
            this.stopDrag();
         }
      }
   }
}

