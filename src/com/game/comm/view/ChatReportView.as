package com.game.comm.view
{
   import com.game.Tools.RectButton;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.green.server.manager.SocketManager;
   
   public class ChatReportView extends HLoaderSprite
   {
      
      private var btnClose:RectButton;
      
      private var txtName:TextField;
      
      private var txtMessage:TextField;
      
      private var txtReason:TextField;
      
      private var btnReport:RectButton;
      
      private var btnPick:Vector.<RectButton>;
      
      private var curData:Object;
      
      private var curPickIndex:Array;
      
      public function ChatReportView(obj:Object)
      {
         super();
         this.curData = obj;
         url = URLUtil.getSvnVer("assets/common/ChatReportView.swf");
      }
      
      override public function setShow() : void
      {
         super.setShow();
         this.txtName = bg["txtName"];
         this.txtMessage = bg["txtMessage"];
         this.txtReason = bg["txtReason"];
         this.txtReason.restrict = "0-9a-zA-Z一-龥";
         this.txtName.text = this.curData["name"];
         this.txtMessage.text = this.curData["message"];
         this.btnReport = createMyBtn(RECT_BUTTON,bg["btnReport"]) as RectButton;
         this.btnClose = createMyBtn(RECT_BUTTON,bg["btnClose"]) as RectButton;
         this.btnReport.tips = "请至少勾选1项举报原因";
         this.btnReport.isDisableTips = true;
         this.btnPick = new Vector.<RectButton>();
         for(var i:int = 0; i < 4; i++)
         {
            this.btnPick.push(createMyBtn(RECT_BUTTON,bg["btnPick" + i]));
         }
         this.curPickIndex = [];
         this.btnReport.setDisable(true);
      }
      
      override protected function onMyBtnMouseClick(event:MouseEvent) : void
      {
         var jsonData:Object = null;
         var jsonStr:String = null;
         super.onMyBtnMouseClick(event);
         var index:int = int(this.btnPick.indexOf(event.currentTarget));
         if(index != -1)
         {
            this.onPick(index);
         }
         else
         {
            switch(event.currentTarget)
            {
               case this.btnReport:
                  if(this.curPickIndex.length > 0)
                  {
                     jsonData = {
                        "target_id":uint(this.curData["roleid"]),
                        "target_name":this.curData["name"],
                        "reasons":this.curPickIndex,
                        "content":this.txtReason.text,
                        "talk":this.curData["message"]
                     };
                     jsonStr = JSON.stringify(jsonData);
                     SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_LUA_ACTIVITY_V3.send,687,["report",jsonStr]);
                  }
               case this.btnClose:
                  if(Boolean(this.parent))
                  {
                     this.parent.removeChild(this);
                  }
            }
         }
      }
      
      private function onPick(index:int) : void
      {
         var mc:MovieClip = this.btnPick[index].skin as MovieClip;
         index++;
         var i:int = int(this.curPickIndex.indexOf(index));
         if(i == -1)
         {
            if(this.curPickIndex.length >= 3)
            {
               AlertManager.instance.addTipAlert({"tip":"最多选择3项举报原因"});
               return;
            }
            this.curPickIndex.push(index);
         }
         else
         {
            this.curPickIndex.splice(i,1);
         }
         mc.gotoAndStop(3 - mc.currentFrame);
         switch(this.curPickIndex.length)
         {
            case 0:
               this.btnReport.tips = "请至少勾选1项举报原因";
               this.btnReport.setDisable(true);
               break;
            default:
               this.btnReport.setDisable(false);
         }
      }
   }
}

