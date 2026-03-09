package com.game.modules.view.item
{
   import com.game.comm.AlertUtil;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol583")]
   public class PublicChatItem extends Sprite
   {
      
      public var bgClip:MovieClip;
      
      private var msgTxt:TextField;
      
      private var data:Object;
      
      public function PublicChatItem(params:Object)
      {
         var multilineFormat:TextFormat = null;
         var isMy:Boolean = false;
         var str:String = null;
         super();
         this.bgClip.gotoAndStop(1);
         this.bgClip.width = 185;
         this.data = params;
         this.msgTxt = new TextField();
         this.msgTxt.selectable = false;
         addChild(this.msgTxt);
         this.msgTxt.x = 2;
         this.msgTxt.multiline = true;
         this.msgTxt.wordWrap = true;
         this.msgTxt.width = this.bgClip.width - 4;
         if(this.data.hasOwnProperty("first"))
         {
            multilineFormat = new TextFormat();
            multilineFormat.align = TextFormatAlign.CENTER;
            this.msgTxt.setTextFormat(multilineFormat);
            this.msgTxt.defaultTextFormat = multilineFormat;
            this.msgTxt.text = "抵制不良游戏 拒绝盗版游戏\n" + "注意自我保护 谨防受骗上当\n" + "适度游戏益脑 沉迷游戏伤身\n" + "合理安排时间 享受健康生活";
            this.msgTxt.textColor = 16752128;
         }
         else
         {
            this.msgTxt.autoSize = TextFieldAutoSize.LEFT;
            isMy = uint(this.data["roleid"]) == uint(GameData.instance.playerData.userId);
            str = "<a href=\'event:name\'><font color=\'#FFFF00\'><u>" + this.data.name + "</u>：</font></a>" + "<font color=\'#ffffff\'>" + this.data.message + "</font>";
            if(!isMy)
            {
               str += "<a href=\'event:report\'><font color=\'#ff9e00\'>  <u>[举报]</u></font></a>";
            }
            this.msgTxt.htmlText = str;
            this.msgTxt.addEventListener(TextEvent.LINK,this.onTextLink);
         }
         this.msgTxt.height = this.msgTxt.textHeight + 4;
         this.bgClip.height = this.msgTxt.textHeight + 6;
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemove);
      }
      
      private function onTextLink(event:TextEvent) : void
      {
         switch(event.text)
         {
            case "report":
               AlertUtil.showReportView(this.data);
               break;
            case "name":
               this.onMouseClick();
         }
      }
      
      private function onMouseClick() : void
      {
         if(uint(this.data.roleid) == 0)
         {
            return;
         }
         if(uint(this.data.roleid) != uint(GameData.instance.playerData.userId))
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPENPERSONINFOVIEW,{
               "userId":this.data.roleid,
               "isOnline":1,
               "source":0,
               "userName":this.data.name,
               "body":this.data.body
            });
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPENPERSONDETAILVIEW,{
               "userId":this.data.roleid,
               "isOnline":1,
               "source":0,
               "userName":this.data.name,
               "body":this.data.body
            });
         }
      }
      
      private function onRemove(evt:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemove);
      }
   }
}

