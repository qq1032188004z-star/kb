package com.game.modules.view.chat
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.modules.view.MapView;
   import com.game.util.ColorUtil;
   import com.game.util.FloatAlert;
   import fl.controls.listClasses.CellRenderer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol580")]
   public class MutilChatItem extends CellRenderer
   {
      
      public var head_mc:MovieClip;
      
      public var name_txt:TextField;
      
      public var level_txt:TextField;
      
      public var chatBtn:SimpleButton;
      
      public var bg_mc:MovieClip;
      
      private const Level:Array = ["游民","族长","副族长","护法","精英","族员"];
      
      public function MutilChatItem()
      {
         super();
         this.init();
         this.mouseChildren = true;
      }
      
      private function init() : void
      {
         this.head_mc.gotoAndStop(1);
         this.bg_mc.gotoAndStop(1);
         this.chatBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onStartChat);
         this.head_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onHead);
      }
      
      private function onStartChat(evt:MouseEvent) : void
      {
         var sendBody:Object = null;
         if(this.data.uid == GlobalConfig.userId)
         {
            new FloatAlert().show(MapView.instance.stage,350,300,"不能自言自语(⊙o⊙)哦");
            return;
         }
         if(this.data.isOnline == 0)
         {
            new FloatAlert().show(MapView.instance.stage,350,300,"族员不在线，不能聊天哦，快去叫他上线吧(*^__^*)");
            return;
         }
         sendBody = {};
         sendBody.isBlack = 0;
         sendBody.isOnline = data.isOnline;
         sendBody.sex = data.sex;
         sendBody.userId = data.uid;
         sendBody.userName = data.uname;
         sendBody.vip = 0;
         sendBody.family = 0;
         ApplicationFacade.getInstance().dispatch(EventConst.CHATWITHFRIEND,sendBody);
      }
      
      override public function set data(params:Object) : void
      {
         if(params == null)
         {
            return;
         }
         this.buttonMode = true;
         super.data = params;
         if(data.level > 5 || data.level < 1)
         {
            data.level = 0;
         }
         this.head_mc.gotoAndStop(data.sex + 1);
         this.name_txt.text = data.uname;
         this.level_txt.text = this.Level[data.level];
         this.changeState(data.isOnline);
      }
      
      public function changeState(isOnline:int) : void
      {
         super.data.isOnline = isOnline;
         if(isOnline == 0)
         {
            this.filters = ColorUtil.getColorMatrixFilterGray();
         }
         else
         {
            this.filters = [];
         }
         if(data.uid == GlobalConfig.userId)
         {
            this.filters = [];
         }
      }
      
      private function onHead(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.isInWarCraft)
         {
            new FloatAlert().show(MapView.instance.stage,350,300,"亲爱的小卡布,战场中不可以查看个人信息哦(⊙o⊙)");
            return;
         }
         if(data.uid != GameData.instance.playerData.userId)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPENPERSONINFOVIEW,{
               "userId":data.uid,
               "isOnline":0,
               "source":0,
               "userName":data.uname,
               "sex":1,
               "body":data
            });
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPENPERSONDETAILVIEW,{
               "userId":data.uid,
               "isOnline":0,
               "source":0,
               "userName":data.uname,
               "sex":GameData.instance.playerData.roleType & 1,
               "body":GameData.instance.playerData
            });
         }
      }
   }
}

