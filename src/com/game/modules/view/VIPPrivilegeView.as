package com.game.modules.view
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.ui.TextArea;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.green.server.core.GreenSocket;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   
   public class VIPPrivilegeView extends Sprite
   {
      
      private static var instance:VIPPrivilegeView;
      
      private var socket:GreenSocket;
      
      public var vipData:Object = {};
      
      public var loader:Loader;
      
      private var btn:SimpleButton;
      
      private var clip:MovieClip;
      
      private var msgTxt:TextArea;
      
      private var msgTid:int;
      
      private var msgList:Array = ["主人，你有礼包哦！"];
      
      private var currentIndex:int = 0;
      
      public function VIPPrivilegeView()
      {
         super();
         this.mouseEnabled = false;
         this.x = 690;
         this.y = 270;
         this.socket = SocketManager.getGreenSocket();
         this.socket.attachSocketListener(MsgDoc.OP_CLIENT_VIP_AWARD_STATE.back,this.getVipInfoBack);
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.x = 205;
         this.loader.y = 60;
         addChild(this.loader);
         this.socket.sendCmd(MsgDoc.OP_CLIENT_VIP_AWARD_STATE.send);
      }
      
      public static function getInstance() : VIPPrivilegeView
      {
         if(instance == null)
         {
            instance = new VIPPrivilegeView();
         }
         return instance;
      }
      
      public function addArea(index:int = 0) : void
      {
         this.currentIndex = index;
         clearTimeout(this.msgTid);
         if(this.hasGift())
         {
            if(this.msgTxt == null)
            {
               this.msgTxt = new TextArea(275,90,2);
            }
            this.msgTxt.text = this.msgList[index];
            this.addChild(this.msgTxt);
            this.msgTid = setTimeout(this.addArea,8000);
         }
         else
         {
            this.clearArea();
         }
      }
      
      private function hasGift() : Boolean
      {
         return GameData.instance.playerData.weekReward == 0 || GameData.instance.playerData.dayReward == 0;
      }
      
      private function clearArea() : void
      {
         clearTimeout(this.msgTid);
         if(Boolean(this.msgTxt))
         {
            this.msgTxt.dispos();
            this.msgTxt = null;
         }
      }
      
      private function getVipInfoBack(evt:MsgEvent) : void
      {
         var level:int = 0;
         if(GameData.instance.playerData.isNewHand < 9)
         {
            instance.visible = false;
         }
         this.vipData.param = evt.msg.mParams;
         GameData.instance.playerData.haveOpenVip = evt.msg.mParams;
         if(int(this.vipData.param) == 1)
         {
            GameData.instance.playerData.isVip = Boolean(evt.msg.body.readInt());
            GameData.instance.playerData.vipScore = evt.msg.body.readInt();
            GameData.instance.playerData.vipLevel = evt.msg.body.readInt();
            this.vipData.isVip = GameData.instance.playerData.isVip;
            this.vipData.vipScore = GameData.instance.playerData.vipScore;
            this.vipData.vipLevel = GameData.instance.playerData.vipLevel;
            this.vipData.expiredTime = evt.msg.body.readInt();
            this.vipData.timeNow = evt.msg.body.readInt();
            this.vipData.firstopen = evt.msg.body.readInt();
            this.vipData.weekReward = evt.msg.body.readInt();
            this.vipData.dayReward = evt.msg.body.readInt();
            this.vipData.trumpAppearance = evt.msg.body.readInt();
            this.vipData.lastopenTime = evt.msg.body.readInt();
            GameData.instance.playerData.expiredTime = this.vipData.expiredTime;
            GameData.instance.playerData.timeNow = this.vipData.timeNow;
            GameData.instance.playerData.firstopen = this.vipData.firstopen;
            GameData.instance.playerData.lastopenTime = this.vipData.lastopenTime;
            GameData.instance.playerData.weekReward = this.vipData.weekReward;
            GameData.instance.playerData.dayReward = this.vipData.dayReward;
         }
         else
         {
            GameData.instance.playerData.weekReward = evt.msg.body.readInt();
            GameData.instance.playerData.dayReward = evt.msg.body.readInt();
         }
         this.updateView(this.vipData.trumpAppearance);
         this.addArea();
         ApplicationFacade.getInstance().dispatch(EventConst.S_VIPWEEKLY_VIPAWARDSTATE);
      }
      
      public function updateView(id:int = 0) : void
      {
         var level:int = 0;
         if(GameData.instance.playerData.isVip)
         {
            level = GameData.instance.playerData.vipLevel;
            if(id > 0)
            {
               this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/vipprivilege/vip" + id + ".swf")));
            }
            else if(GameData.instance.playerData.isSupertrump)
            {
               this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/vipprivilege/vipsuper.swf")));
            }
            else if(level >= 1 && level <= 3)
            {
               this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/vipprivilege/vip1-3.swf")));
            }
            else if(level >= 4 && level <= 5)
            {
               this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/vipprivilege/vip4-5.swf")));
            }
            else if(level >= 6)
            {
               this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/vipprivilege/vip6.swf")));
            }
         }
         else
         {
            this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/vipprivilege/vip0.swf")));
         }
      }
      
      private function onLoaded(evt:Event) : void
      {
         if(GameData.instance.playerData.isSupertrump)
         {
            this.loader.content["vipTxt"].text = "年费VIP";
         }
         else if(GameData.instance.playerData.isVip)
         {
            this.loader.content["vipTxt"].text = "VIP" + GameData.instance.playerData.vipLevel;
         }
         this.btn = this.loader.content["btn"] as SimpleButton;
         this.clip = this.loader.content["clip"] as MovieClip;
         if(Boolean(this.clip))
         {
            this.clip.stop();
         }
         this.btn.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickTrump);
         this.btn.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.btn.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
      }
      
      private function onClickTrump(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/vip/privilege/VipMainView.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function onRollOut(evt:MouseEvent) : void
      {
         if(Boolean(this.clip))
         {
            this.clip.gotoAndStop(1);
         }
      }
      
      private function onRollOver(evt:MouseEvent) : void
      {
         if(Boolean(this.clip))
         {
            this.clip.gotoAndPlay(1);
         }
      }
      
      private function removeEvent() : void
      {
         this.socket.removeSocketListener(MsgDoc.OP_CLIENT_VIP_AWARD_STATE.back,this.getVipInfoBack);
      }
      
      public function dispos() : void
      {
         this.removeEvent();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

