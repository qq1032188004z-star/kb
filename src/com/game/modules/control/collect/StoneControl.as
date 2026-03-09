package com.game.modules.control.collect
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.global.GlobalConfig;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.modules.view.MapView;
   import com.game.modules.view.collect.Stone;
   import com.game.modules.view.person.GamePerson;
   import com.game.util.AwardAlert;
   import com.game.util.PropertyPool;
   import com.game.util.ScreenSprite;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.XMLLocator;
   
   public class StoneControl extends ViewConLogic
   {
      
      public static var NAME:String = "stonecontrol";
      
      private var tempstuffid:Number;
      
      private var temptoolname:String = "";
      
      private var temptooltip:String = "";
      
      private var temprole:GamePerson;
      
      private var collectInt:int;
      
      public function StoneControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.ONCHECKSTUFFBACK,this.CheckStuffBack],[EventConst.ONCOLLECTSTUFFBACK,this.onCollectStuffBack],[EventConst.COLLECTSTUFFOVER,this.collectstuffover],[EventConst.CANCLECOLLECT,this.CancleCollect],[EventConst.GETSTUFFSTATUS,this.GetStatus]];
      }
      
      private function CheckStuffBack(evt:MessageEvent) : void
      {
         GameData.instance.playerData.collectStatus = 0;
         switch(evt.body.statusid)
         {
            case -2:
               dispatch(EventConst.BOBSTATECLICK,{
                  "url":"assets/material/AlertTool.swf",
                  "xCoord":0,
                  "yCoord":0,
                  "moduleParams":{
                     "msg":"你要装备<font color=\'#663366\'>【" + this.temptoolname + "或超级采集器】</font>才可以哦",
                     "msgtip":this.temptooltip,
                     "state":0
                  }
               });
               break;
            case -5:
               dispatch(EventConst.BOBSTATECLICK,{
                  "url":"assets/material/AlertTool.swf",
                  "xCoord":0,
                  "yCoord":0,
                  "moduleParams":{
                     "msg":"你要装备<font color=\'#663366\'>【" + this.temptoolname + "或超级采集器】</font>才可以哦",
                     "msgtip":"在【背包】里面找一下吧",
                     "state":1
                  }
               });
               break;
            case -3:
               break;
            case -1:
               new Alert().show("为了保护地球，你今天不能再采这里了哦!");
               break;
            case -4:
               new Alert().show("未知错误!");
               break;
            case 1:
               this.startPlayCollectMovie(evt.body);
               break;
            case 2:
               this.onCollectStuffBack(evt.body);
               break;
            case 3:
               this.collectstuffover(evt.body);
               break;
            case 4:
               this.onCollectStuffBack(evt.body);
         }
      }
      
      public function get view() : Stone
      {
         return this.getViewComponent() as Stone;
      }
      
      private function GetStatus(evt:MessageEvent) : void
      {
         this.tempstuffid = evt.body.stuffid;
         PropertyPool.instance.getXML("config/","collect",this.xmlLoaded);
      }
      
      private function xmlLoaded(xml:XML) : void
      {
         this.temptoolname = xml.children().(@id == tempstuffid)[0].name;
         this.temptooltip = this.temptoolname + xml.children().(@id == tempstuffid)[0].tipdesc + "\n超级采集器在【商城】中购买";
         sendMessage(MsgDoc.OP_GET_COLLETC_STUFF_STATUS.send,1,[this.tempstuffid]);
      }
      
      private function CancleCollect(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_GET_COLLETC_STUFF_STATUS.send,3);
      }
      
      private function onCollectStuffBack(params:Object) : void
      {
         var stuffcount:int = 0;
         var stuffid:int = 0;
         var userid:int = 0;
         var role:GamePerson = null;
         var stuffname:String = null;
         var obj:Object = null;
         var url:String = null;
         var stuffcount2:int = 0;
         var stuffid2:int = 0;
         var stuffname2:String = null;
         var obj2:Object = null;
         var url2:String = null;
         if(params == null)
         {
            return;
         }
         if(params.extra == 0)
         {
            if(params.userid == GlobalConfig.userId)
            {
               ScreenSprite.instance.show(false);
               stuffcount = int(params.stuffcount);
               stuffid = int(params.stuffid);
               userid = int(params.userid);
               MapView.instance.masterPerson.removeCollectBar();
               role = MapView.instance.findGameSprite(userid) as GamePerson;
               if(role != null)
               {
                  role.removeCollectBar();
                  role.statusClip.clear();
                  role.removeStatus();
               }
               stuffname = XMLLocator.getInstance().tooldic[stuffid].name;
               if(Boolean(GameData.instance.autoCollectData.isAutoNum))
               {
                  obj = {};
                  obj.id = stuffid;
                  obj.amount = stuffcount;
                  GameData.instance.autoCollectData.rewardList.push(obj);
                  AlertManager.instance.addTipAlert({
                     "tip":"获得" + stuffcount + "个" + stuffname,
                     "type":1
                  });
               }
               else
               {
                  url = "assets/tool/" + stuffid + ".swf";
                  new AwardAlert().showGoodsAward(url,MapView.instance.stage,"获得" + stuffcount + "个" + stuffname + "快去背包看看吧",true);
               }
            }
         }
         else
         {
            stuffcount2 = int(params.stuffcount);
            stuffid2 = int(params.stuffid);
            stuffname2 = XMLLocator.getInstance().tooldic[stuffid2].name;
            if(Boolean(GameData.instance.autoCollectData.isAutoNum))
            {
               obj2 = {};
               obj2.id = stuffid2;
               obj2.amount = stuffcount2;
               GameData.instance.autoCollectData.rewardList.push(obj2);
               AlertManager.instance.addTipAlert({
                  "tip":"你还额外获得" + stuffcount2 + "个" + stuffname2,
                  "type":1
               });
            }
            else
            {
               url2 = "assets/tool/" + stuffid2 + ".swf";
               new AwardAlert().showGoodsAward(url2,MapView.instance.stage,"你还额外获得" + stuffcount2 + "个" + stuffname2,true);
            }
         }
      }
      
      private function collectstuffover(params:Object) : void
      {
         this.clearStatus(params.userid);
         if(params.userid == GlobalConfig.userId)
         {
            if(Boolean(GameData.instance.autoCollectData.isAutoNum))
            {
               GameData.instance.autoCollectData.keepAuto = true;
            }
            GameData.instance.dispatchEvent(new MessageEvent(EventDefine.AUTO_COLLECT_FINISH));
         }
      }
      
      public function clearStatus(id:int) : void
      {
         var role:GamePerson = MapView.instance.scene.findBySequenceId(id) as GamePerson;
         if(role != null)
         {
            if(role.statusClip != null)
            {
               role.statusClip.clear();
            }
            role.removeStatus();
         }
         if(id == GlobalConfig.userId)
         {
            if(MapView.instance.masterPerson.collectFilm != null)
            {
               MapView.instance.masterPerson.removeCollectBar();
            }
         }
      }
      
      private function startPlayCollectMovie(params:Object) : void
      {
         dispatch("collecting_stone",this.tempstuffid);
         this.temprole = MapView.instance.scene.findBySequenceId(params.userid) as GamePerson;
         this.showCollectStatus(params.userid);
         if(params.userid == GlobalConfig.userId)
         {
            MapView.instance.masterPerson.setCollectBar();
            MapView.instance.masterPerson.collectFilm.addFrameScript(MapView.instance.masterPerson.collectFilm.totalFrames - 1,this.sendCollectToServer);
         }
      }
      
      public function showCollectStatus(id:int) : void
      {
         if(this.temprole != null)
         {
            this.temprole.playStatus = "chutoufilm";
         }
         if(this.temprole == null)
         {
            return;
         }
         if(this.temprole.sequenceID == MapView.instance.masterPerson.sequenceID && !GameData.instance.autoCollectData.isAutoNum)
         {
            ScreenSprite.instance.show(true,false,1);
         }
      }
      
      private function sendCollectToServer() : void
      {
         MapView.instance.masterPerson.collectFilm.addFrameScript(0,null);
         MapView.instance.masterPerson.removeCollectBar();
         MapView.instance.masterPerson.removeStatus();
         ScreenSprite.instance.hide();
         sendMessage(MsgDoc.OP_GET_COLLETC_STUFF_STATUS.send,2,[this.tempstuffid]);
      }
   }
}

