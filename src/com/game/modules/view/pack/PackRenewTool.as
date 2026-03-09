package com.game.modules.view.pack
{
   import com.game.manager.EventManager;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.alert.Alert;
   import flash.events.MouseEvent;
   import org.green.server.manager.SocketManager;
   
   public class PackRenewTool extends HLoaderSprite
   {
      
      public static var Instance:PackRenewTool = new PackRenewTool();
      
      private var body:Object;
      
      public function PackRenewTool()
      {
         super();
         this.showloading = false;
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.body = params;
         if(!bg)
         {
            this.url = "assets/material/pack_renew_tool.swf";
         }
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         EventManager.attachEvent(bg.btn0,MouseEvent.MOUSE_DOWN,this.btn0Handler);
         EventManager.attachEvent(bg.btn1,MouseEvent.MOUSE_DOWN,this.btn1Handler);
         EventManager.attachEvent(bg.btn2,MouseEvent.MOUSE_DOWN,this.btn2Handler);
      }
      
      override public function disport() : void
      {
         if(bg)
         {
            EventManager.removeEvent(bg.btn0,MouseEvent.MOUSE_DOWN,this.btn0Handler);
            EventManager.removeEvent(bg.btn1,MouseEvent.MOUSE_DOWN,this.btn1Handler);
            EventManager.removeEvent(bg.btn2,MouseEvent.MOUSE_DOWN,this.btn2Handler);
         }
         super.disport();
      }
      
      private function btn0Handler(evt:MouseEvent) : void
      {
         new Alert().showSureOrCancel("是否【花费" + this.getCostStr(this.body.iid,1) + "】进行续期?",this.sureHandler1);
      }
      
      private function sureHandler1(... rest) : void
      {
         if(rest[0] == "确定")
         {
            SocketManager.getGreenSocket().sendCmd(1186286,0,[this.body.ttype,this.body.sn,this.body.iid,1]);
         }
      }
      
      private function btn1Handler(evt:MouseEvent) : void
      {
         new Alert().showSureOrCancel("是否【花费" + this.getCostStr(this.body.iid,3) + "】进行续期?",this.sureHandler2);
      }
      
      private function sureHandler2(... rest) : void
      {
         if(rest[0] == "确定")
         {
            SocketManager.getGreenSocket().sendCmd(1186286,0,[this.body.ttype,this.body.sn,this.body.iid,3]);
         }
      }
      
      private function btn2Handler(evt:MouseEvent) : void
      {
         new Alert().showSureOrCancel("是否【花费" + this.getCostStr(this.body.iid,7) + "】进行续期?",this.sureHandler3);
      }
      
      private function sureHandler3(... rest) : void
      {
         if(rest[0] == "确定")
         {
            SocketManager.getGreenSocket().sendCmd(1186286,0,[this.body.ttype,this.body.sn,this.body.iid,7]);
            parentRemove();
         }
      }
      
      private function getCostStr(id:int, num:int) : String
      {
         var cost:int = 0;
         var str:String = "";
         if(id == 610008 || id == 610009)
         {
            cost = 28;
            str = 28 * num + "卡布币";
         }
         return str;
      }
   }
}

