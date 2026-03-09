package com.publiccomponent.alert
{
   public class Alert
   {
      
      private var instance:TipMsg;
      
      private var callBack:Function;
      
      public var okLabel:String = "确定";
      
      public var cancelLabel:String = "取消";
      
      public function Alert()
      {
         super();
         this.instance = new TipMsg();
      }
      
      public function showAcceptOrRefuse(msg:String, closeHandler:Function = null, data:Object = null, linkHandler:Function = null) : void
      {
         AlertContainer.instance.addChildXY(this.instance);
         this.okLabel = "接受";
         this.cancelLabel = "拒绝";
         this.instance.visible = true;
         this.instance.showAcceptOrRefuseView(msg,closeHandler,data,linkHandler);
         AlertContainer.instance.x = 0;
      }
      
      public function showSureOrCancel(msg:String, closeHandler:Function = null, data:Object = null, linkHandler:Function = null, time:int = 0) : void
      {
         AlertContainer.instance.addChildXY(this.instance);
         this.okLabel = "确定";
         this.cancelLabel = "取消";
         this.instance.visible = true;
         if(time > 0)
         {
            this.instance.showSureOrCancelAndTimeView(msg,closeHandler,data,linkHandler,time);
         }
         else
         {
            this.instance.showSureOrCancelView(msg,closeHandler,data,linkHandler);
         }
         AlertContainer.instance.x = 0;
      }
      
      public function showUserPassWordError() : void
      {
         AlertContainer.instance.addChildXY(this.instance);
         this.okLabel = "确定";
         this.instance.visible = true;
         this.instance.showUserPassWordError();
         AlertContainer.instance.x = 0;
      }
      
      public function showIdPassWordError() : void
      {
         AlertContainer.instance.addChildXY(this.instance);
         this.okLabel = "确定";
         this.instance.visible = true;
         this.instance.showIdPassWordError();
         AlertContainer.instance.x = 0;
      }
      
      public function show(msg:String, closeHandler:Function = null, other:Object = null) : void
      {
         AlertContainer.instance.addChildXY(this.instance);
         this.okLabel = "确定";
         this.instance.visible = true;
         this.instance.showSureView(msg,closeHandler,other);
         AlertContainer.instance.x = 0;
      }
      
      public function showOne(msg:String, closeHandler:Function = null, data:Object = null) : void
      {
         AlertContainer.instance.addChildXY(this.instance);
         this.okLabel = "确定";
         this.instance.visible = true;
         this.instance.showSureOneView(msg,closeHandler,data);
         AlertContainer.instance.x = 0;
      }
      
      public function showTwo(msg:String, closeHandler:Function = null) : void
      {
         AlertContainer.instance.addChildXY(this.instance);
         this.okLabel = "确定";
         this.instance.visible = true;
         this.instance.showTwo(msg,closeHandler);
         AlertContainer.instance.x = 0;
      }
      
      public function showBattleOrNo(msg:String, closeHandler:Function = null) : void
      {
         AlertContainer.instance.addChildXY(this.instance);
         this.okLabel = "确定";
         this.instance.visible = true;
         this.instance.showBallteOrNo(msg,closeHandler);
         AlertContainer.instance.x = 0;
      }
      
      public function showVip(msg:String) : void
      {
         AlertContainer.instance.addChildXY(this.instance);
         this.instance.visible = true;
         this.instance.showVip(msg);
         AlertContainer.instance.x = 0;
      }
      
      public function showCongratulateView(msg:String, closeHandler:Function = null, data:Object = null) : void
      {
         AlertContainer.instance.addChildXY(this.instance);
         this.okLabel = "确定";
         this.instance.visible = true;
         this.instance.showCongratulateView(msg,closeHandler,data);
         AlertContainer.instance.x = 0;
      }
      
      public function registerParent(xCoord:Number = 0, yCoord:Number = 0) : void
      {
         this.instance.x = xCoord;
         this.instance.y = yCoord;
      }
      
      public function showGiveUpHBTaskOrNot(callback:Function) : void
      {
         AlertContainer.instance.addChildXY(this.instance);
         this.instance.visible = true;
         this.instance.showGiveUpHBTask(callback);
         AlertContainer.instance.x = 0;
      }
      
      public function showSureLink(msg:String, closeHandler:Function = null, data:Object = null, linkHandler:Function = null) : void
      {
         AlertContainer.instance.addChildXY(this.instance);
         this.okLabel = "确定";
         this.instance.visible = true;
         this.instance.showSureViewLink(msg,closeHandler,data,linkHandler);
         AlertContainer.instance.x = 0;
      }
   }
}

