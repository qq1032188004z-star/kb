package com.game.modules.view.chat
{
   import fl.containers.ScrollPane;
   import fl.controls.ScrollBarDirection;
   import fl.events.ScrollEvent;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   
   public class ChatTextField extends Sprite
   {
      
      private var _textContainer:Sprite;
      
      private var _scroll:ScrollPane;
      
      private var _maxLines:uint;
      
      private var _msgArr:Array;
      
      private var isFirst:Boolean = true;
      
      public function ChatTextField(w:uint = 300, h:uint = 200)
      {
         super();
         this._msgArr = new Array();
         this._textContainer = new Sprite();
         this._scroll = new ScrollPane();
         this._scroll.horizontalScrollPolicy = "off";
         this._scroll.focusEnabled = true;
         this._scroll.source = this._textContainer;
         this._scroll.setSize(w,h);
         this._scroll.addEventListener(ScrollEvent.SCROLL,this.onScroll);
         this._scroll.setStyle("upSkin",new Shape());
         addChild(this._scroll);
         this.maxLines = 130;
      }
      
      public function initStyle(upBtb:Object, downBtn:Object, scrollBtn:Object, trackBg:Object) : void
      {
         this._scroll.setStyle("upArrowDisabledSkin",upBtb);
         this._scroll.setStyle("upArrowDownSkin",upBtb);
         this._scroll.setStyle("upArrowOverSkin",upBtb);
         this._scroll.setStyle("upArrowUpSkin",upBtb);
         this._scroll.setStyle("downArrowDisabledSkin",downBtn);
         this._scroll.setStyle("downArrowDownSkin",downBtn);
         this._scroll.setStyle("downArrowOverSkin",downBtn);
         this._scroll.setStyle("downArrowUpSkin",downBtn);
         this._scroll.setStyle("trackUpSkin",trackBg);
         this._scroll.setStyle("trackDisabledSkin",trackBg);
         this._scroll.setStyle("trackDownSkin",trackBg);
         this._scroll.setStyle("trackOverSkin",trackBg);
         this._scroll.setStyle("thumbIcon",scrollBtn);
         this._scroll.setStyle("thumbUpSkin",scrollBtn);
         this._scroll.setStyle("thumbOverSkin",scrollBtn);
         this._scroll.setStyle("thumbDownSkin",scrollBtn);
         this._scroll.setStyle("thumbDisabledSkin",scrollBtn);
      }
      
      public function appendMessage(channel:String, srcName:String, dstName:String, id:uint, content:String, bSelf:Boolean) : void
      {
         var obj:DisplayObject = null;
         var item:FaceTextField = null;
         if(srcName == null || srcName == "")
         {
            return;
         }
         var tf:FaceTextField = new FaceTextField(this._scroll.width - this._scroll.verticalScrollBar.width - 10);
         tf.appendChatText(channel,srcName,dstName,id,content,bSelf);
         this._msgArr.push(tf);
         tf.x = 0;
         tf.y = this._textContainer.height;
         this._textContainer.addChild(tf);
         if(this._msgArr.length > this._maxLines)
         {
            obj = this._msgArr.shift();
            if(Boolean(obj))
            {
               this._textContainer.removeChild(obj);
               for each(item in this._msgArr)
               {
                  item.y -= obj.height;
               }
            }
         }
         if(this._textContainer.height > this._scroll.height)
         {
            this._scroll.update();
            this._scroll.verticalScrollPosition = this._scroll.maxVerticalScrollPosition;
            if(this._scroll.maxVerticalScrollPosition < 30)
            {
               this._scroll.verticalScrollBar.visible = false;
            }
            else
            {
               this._scroll.verticalScrollBar.visible = true;
            }
         }
         else
         {
            this._scroll.refreshPane();
         }
         tf._txtField.addEventListener(TextEvent.LINK,this.onLink);
      }
      
      private function onScroll(e:ScrollEvent) : void
      {
         var item:FaceTextField = null;
         if(e.direction == ScrollBarDirection.VERTICAL)
         {
            for each(item in this._msgArr)
            {
               if(item.y + item.height < this._scroll.verticalScrollPosition || item.y > this._scroll.verticalScrollPosition + this.height)
               {
                  item.visible = false;
               }
               else
               {
                  item.visible = true;
                  if(this.isFirst)
                  {
                     this.isFirst = false;
                     this.appendMessage("","","",0,"",false);
                  }
               }
            }
         }
      }
      
      private function onLink(e:TextEvent) : void
      {
      }
      
      public function set maxLines(n:uint) : void
      {
         this._maxLines = n;
      }
      
      public function get maxLines() : uint
      {
         return this._maxLines;
      }
      
      public function clear() : void
      {
      }
   }
}

