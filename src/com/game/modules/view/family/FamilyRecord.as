package com.game.modules.view.family
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.modules.control.family.FamilyControl;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.ui.ToolTip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.text.TextFieldType;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import phpcon.PhpConnection;
   import phpcon.PhpEvent;
   import phpcon.PhpEventConst;
   
   public class FamilyRecord extends HLoaderSprite
   {
      
      private var familyInfo:Object;
      
      private var badge:FamilyBadge;
      
      private var mlist:TileList;
      
      private var members:Array = [];
      
      private var mbar:FamilyBar;
      
      private var changeBadge:FamilyBadgeChange;
      
      private var transLeader:FamilyLeaderChange;
      
      private var changeObject:Object;
      
      private var setting:int;
      
      public var notice:String = "";
      
      private var totalSeconds:int;
      
      private var tid2:int;
      
      public var LeaderExit:Boolean = false;
      
      private var body:Object;
      
      public function FamilyRecord()
      {
         GreenLoading.loading.visible = true;
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.mlist = new TileList(-125,-145);
         this.url = "assets/family/familyRecord.swf";
      }
      
      override public function setShow() : void
      {
         this.loader.loader.unloadAndStop(false);
         this.bg.cacheAsBitmap = true;
         bg["battleBtn"].visible = false;
         this.initEvents();
         if(ApplicationFacade.getInstance().hasViewLogic(FamilyControl.NAME))
         {
            ApplicationFacade.getInstance().removeViewLogic(FamilyControl.NAME);
         }
         ApplicationFacade.getInstance().registerViewLogic(new FamilyControl(this));
         GreenLoading.loading.visible = false;
      }
      
      public function initBadge(body:Object) : void
      {
         this.familyInfo = body;
         if(!body || !bg)
         {
            return;
         }
         this.badge = new FamilyBadge();
         this.badge.setBadge(body.midid,body.smallid,body._name,body.midcolor,body.circolor);
         this.badge.x = -140;
         this.badge.y = -164;
         this.badge.mouseEnabled = false;
         bg["mc0"].addChildAt(this.badge,bg["mc0"].numChildren);
         bg["mc0"]["transTxt"].text = "";
         bg["mc0"]["nameTxt"].text = body.f_name;
         bg["mc0"]["numberTxt"].text = body.f_number;
         bg["mc0"]["leaderTxt"].text = body.f_leader;
         bg["mc0"]["countTxt1"].text = body.f_members;
         bg["mc0"]["countTxt2"].text = body.f_monsters;
         bg["mc0"]["countTxt3"].text = body.f_upLevels;
         bg["mc0"]["ggTxt"].maxChars = 50;
         bg["mc0"]["ggTxt"].text = body.notice;
         bg["mc0"]["ggTxt"].type = TextFieldType.DYNAMIC;
         bg["mc0"]["ggTxt"].mouseEnabled = false;
         bg["mc0"]["saveBtn"].visible = false;
         bg["mc0"]["saveBtn"].mouseEnabled = false;
         bg["battleBtn"].visible = false;
         if(GameData.instance.playerData.family_id == body.f_number)
         {
            bg["mc0"]["joinBtn"].visible = false;
            bg["mc0"]["joinBtn"].mouseEnabled = false;
            if(GameData.instance.playerData.userId == body.f_leaderId)
            {
               GameData.instance.playerData.family_level = 1;
               bg["mc0"]["changeBtn"].visible = true;
               bg["mc0"]["changeBtn"].mouseEnabled = true;
               bg["mc0"]["cancelBtn"].visible = true;
               bg["mc0"]["cancelBtn"].mouseEnabled = true;
               bg["mc1"]["upBtn"].visible = true;
               bg["mc1"]["upBtn"].mouseEnabled = true;
               bg["mc1"]["downBtn"].visible = true;
               bg["mc1"]["downBtn"].mouseEnabled = true;
               bg["mc1"]["fireBtn"].visible = true;
               bg["mc1"]["fireBtn"].mouseEnabled = true;
               bg["btn2"].visible = true;
               bg["btn2"].mouseEnabled = true;
               bg["topmc"].visible = true;
               bg["topmc2"].visible = false;
               bg["battleBtn"].visible = true;
               ToolTip.BindDO(bg["battleBtn"],"出征令，持有者拥有申请家族战场的权力。（点击分配给族员）。");
            }
            else
            {
               bg["mc0"]["changeBtn"].visible = false;
               bg["mc0"]["changeBtn"].mouseEnabled = false;
               bg["mc0"]["cancelBtn"].visible = false;
               bg["mc0"]["cancelBtn"].mouseEnabled = false;
               bg["mc1"]["upBtn"].visible = false;
               bg["mc1"]["upBtn"].mouseEnabled = false;
               bg["mc1"]["downBtn"].visible = false;
               bg["mc1"]["downBtn"].mouseEnabled = false;
               bg["mc1"]["fireBtn"].visible = false;
               bg["mc1"]["fireBtn"].mouseEnabled = false;
               bg["btn2"].visible = false;
               bg["btn2"].mouseEnabled = false;
               bg["topmc"].visible = false;
               bg["topmc2"].visible = true;
            }
         }
         else
         {
            bg["mc0"]["joinBtn"].visible = true;
            bg["mc0"]["joinBtn"].mouseEnabled = true;
            bg["mc0"]["changeBtn"].visible = false;
            bg["mc0"]["changeBtn"].mouseEnabled = false;
            bg["mc0"]["cancelBtn"].visible = false;
            bg["mc0"]["cancelBtn"].mouseEnabled = false;
            bg["mc1"]["upBtn"].visible = false;
            bg["mc1"]["upBtn"].mouseEnabled = false;
            bg["mc1"]["downBtn"].visible = false;
            bg["mc1"]["downBtn"].mouseEnabled = false;
            bg["mc1"]["fireBtn"].visible = false;
            bg["mc1"]["fireBtn"].mouseEnabled = false;
            bg["btn2"].visible = false;
            bg["btn2"].mouseEnabled = false;
            bg["topmc"].visible = false;
            bg["topmc2"].visible = true;
         }
         if(body.trans_time > 0)
         {
            bg["mc0"]["transTxt"].visible = true;
            bg["mc0"]["transTxt"].mouseEnabled = true;
            bg["mc2"]["transBtn"].mouseEnabled = false;
            bg["mc2"]["transBtn"].filters = ColorUtil.getColorMatrixFilterGray();
            ToolTip.setDOInfo(bg["mc0"]["transTxt"],"族长职位将转移给【" + body.trans_name + "】");
            this.showTransTime(body.trans_time);
         }
         else
         {
            bg["mc0"]["transTxt"].visible = false;
            bg["mc0"]["transTxt"].mouseEnabled = false;
            bg["mc0"]["cancelBtn"].visible = false;
            bg["mc0"]["cancelBtn"].mouseEnabled = false;
         }
         this.on_btn(null);
         for(var i:int = 0; i < 3; i++)
         {
            bg["mc2"]["mmc" + i].gotoAndStop(1);
         }
         bg["mc2"]["mmc" + body.setting].gotoAndStop(2);
         this.setting = body.setting;
         bg["mc0"]["countTxt4"].text = "" + body.f_shili;
         var urlvar:URLVariables = new URLVariables();
         urlvar.fid = body.f_number;
         GreenLoading.loading.visible = false;
         PhpConnection.instance().getdata("family/search_rank.php",urlvar);
      }
      
      private function showTransTime(seconds:int) : void
      {
         this.totalSeconds = seconds;
         this.tid2 = setInterval(this.loopCount1,1000);
      }
      
      private function loopCount1() : void
      {
         var minutes:int = 0;
         var hour:int = 0;
         var day:int = 0;
         var tips:String = "转移中(剩余";
         this.totalSeconds -= 1;
         if(this.totalSeconds <= 0)
         {
            clearInterval(this.tid2);
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":1
            });
            this.disport();
         }
         else
         {
            minutes = this.totalSeconds / 60;
            hour = minutes / 60;
            day = hour / 24;
            if(day > 0)
            {
               tips += day + "天" + int(hour % 24) + "时" + ")";
            }
            else if(hour > 0)
            {
               tips += hour + "时" + int(minutes % 60) + "分" + ")";
            }
            else if(minutes > 0)
            {
               tips += minutes + "分" + int(this.totalSeconds % 60) + "秒" + ")";
            }
            else
            {
               tips += int(this.totalSeconds % 60) + "秒" + ")";
            }
            bg["mc0"]["transTxt"].text = tips;
         }
      }
      
      public function initMembers(list:Array) : void
      {
         if(this.mlist == null || bg == null)
         {
            return;
         }
         this.members = list;
         this.mlist.build(1,9,230,30,1,1,FamilyMemberItem);
         this.sort();
         bg["mc1"].addChildAt(this.mlist,bg["mc1"].numChildren);
         this.mbar = new FamilyBar(this.mlist,this.members,bg["mc1"]["bar1"],bg["mc1"]["bar3"],bg["mc1"]["bar2"],false);
         EventManager.attachEvent(this.mlist,ItemClickEvent.ITEMCLICKEVENT,this.on_clickItem,true);
      }
      
      private function sort() : void
      {
         var obj:Object = null;
         var onlineList:Array = [];
         var notOnlineList:Array = [];
         for each(obj in this.members)
         {
            if(obj.isOnline == 1)
            {
               onlineList.push(obj);
            }
            else
            {
               notOnlineList.push(obj);
            }
         }
         onlineList = onlineList.sortOn("level",Array.NUMERIC);
         notOnlineList = notOnlineList.sortOn("level",Array.NUMERIC);
         this.members = onlineList.concat(notOnlineList);
         if(this.mlist != null && this.members != null)
         {
            this.mlist.dataProvider = this.members;
         }
      }
      
      private function initEvents() : void
      {
         EventManager.attachEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
         EventManager.attachEvent(bg["mc0"]["cancelBtn"],MouseEvent.CLICK,this.on_mc0_cancelBtn);
         EventManager.attachEvent(bg["mc0"]["changeBtn"],MouseEvent.CLICK,this.on_mc0_changeBtn);
         EventManager.attachEvent(bg["mc0"]["saveBtn"],MouseEvent.CLICK,this.on_mc0_saveBtn);
         EventManager.attachEvent(bg["mc0"]["joinBtn"],MouseEvent.CLICK,this.on_mc0_joinBtn);
         EventManager.attachEvent(bg["mc0"]["exitBtn"],MouseEvent.CLICK,this.on_mc0_exitBtn);
         EventManager.attachEvent(bg["mc1"]["upBtn"],MouseEvent.CLICK,this.on_mc1_upBtn);
         EventManager.attachEvent(bg["mc1"]["downBtn"],MouseEvent.CLICK,this.on_mc1_downBtn);
         EventManager.attachEvent(bg["mc1"]["fireBtn"],MouseEvent.CLICK,this.on_mc1_fireBtn);
         EventManager.attachEvent(bg["mc2"]["changeBtn"],MouseEvent.CLICK,this.on_mc2_changeBtn);
         EventManager.attachEvent(bg["mc2"]["transBtn"],MouseEvent.CLICK,this.on_mc2_transBtn);
         EventManager.attachEvent(bg["mc2"]["sureBtn"],MouseEvent.CLICK,this.on_mc2_sureBtn);
         EventManager.attachEvent(bg["battleBtn"],MouseEvent.CLICK,this.openGoForBattleView);
         for(var i:int = 0; i < 3; i++)
         {
            EventManager.attachEvent(bg["btn" + i],MouseEvent.CLICK,this.on_btn);
            EventManager.attachEvent(bg["mc2"]["bbtn" + i],MouseEvent.CLICK,this.on_bbtn);
         }
         EventManager.attachEvent(PhpConnection.instance(),PhpEventConst.RANK_SEARCH,this.onPhpBack);
      }
      
      private function openGoForBattleView(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/FamilyGoForBattleModule.swf",
            "xCoord":0,
            "yCoord":0,
            "params":{"flag":1}
         });
      }
      
      private function on_closeBtn(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_mc0_cancelBtn(evt:MouseEvent) : void
      {
         var param:Object = null;
         if(GameData.instance.playerData.family_base_id == GameData.instance.playerData.family_id && GameData.instance.playerData.userId == this.familyInfo.f_leaderId)
         {
            param = {};
            param.uid = this.familyInfo.trans_id;
            param.option = 1;
            this.dispatchEvent(new MessageEvent(EventConst.RECORD_TRANSFORM_LEADER,param));
            this.on_closeBtn(null);
         }
      }
      
      private function on_mc0_changeBtn(evt:MouseEvent) : void
      {
         bg["mc0"]["ggTxt"].type = TextFieldType.INPUT;
         bg["mc0"]["ggTxt"].mouseEnabled = true;
         bg["mc0"]["ggTxt"].text = "";
         bg["mc0"]["changeBtn"].visible = false;
         bg["mc0"]["changeBtn"].mouseEnabled = false;
         bg["mc0"]["saveBtn"].visible = true;
         bg["mc0"]["saveBtn"].mouseEnabled = true;
      }
      
      private function on_mc0_saveBtn(evt:MouseEvent) : void
      {
         if(!bg["mc0"]["ggTxt"].mouseEnabled)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":2
            });
         }
         else if(bg["mc0"]["ggTxt"].text == "")
         {
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":3
            });
         }
         else
         {
            this.notice = bg["mc0"]["ggTxt"].text;
            this.dispatchEvent(new MessageEvent(EventConst.RECORD_CHANGE_NOTICE,this.notice));
            bg["mc0"]["ggTxt"].type = TextFieldType.DYNAMIC;
            bg["mc0"]["ggTxt"].mouseEnabled = false;
            bg["mc0"]["changeBtn"].visible = true;
            bg["mc0"]["changeBtn"].mouseEnabled = true;
            bg["mc0"]["saveBtn"].visible = false;
            bg["mc0"]["saveBtn"].mouseEnabled = false;
         }
      }
      
      private function on_mc0_joinBtn(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.family_id > 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":4
            });
         }
         else
         {
            this.dispatchEvent(new MessageEvent(EventConst.REQ_JOININ_FAMILY,this.familyInfo.f_number));
         }
      }
      
      private function on_mc0_exitBtn(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.userId == this.familyInfo.f_leaderId && GameData.instance.playerData.family_id == this.familyInfo.f_number && this.familyInfo.trans_time > 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":5
            });
            return;
         }
         AlertManager.instance.showTipAlert({
            "systemid":1057,
            "flag":6,
            "callback":this.exitOrNot
         });
      }
      
      private function exitOrNot(str:String, data:Object) : void
      {
         this.LeaderExit = false;
         if(str == "确定")
         {
            if(GameData.instance.playerData.userId == this.familyInfo.f_leaderId)
            {
               if(this.members.length <= 1)
               {
                  this.dispatchEvent(new Event(EventConst.RECORD_EXIT_FAMILY));
               }
               else
               {
                  this.LeaderExit = true;
                  this.on_mc2_transBtn(null);
               }
               return;
            }
            if(GameData.instance.playerData.family_id > 0)
            {
               this.dispatchEvent(new Event(EventConst.RECORD_EXIT_FAMILY));
            }
            else
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1057,
                  "flag":7
               });
            }
         }
      }
      
      private function on_clickItem(evt:ItemClickEvent) : void
      {
         var i:int = 0;
         var item:FamilyMemberItem = null;
         this.body = evt.params;
         var len:int = this.mlist.numChildren;
         for(i = 0; i < len; i++)
         {
            item = this.mlist.getChildAt(i) as FamilyMemberItem;
            if(item.data == evt.params)
            {
               item.onDown();
            }
            else
            {
               item.onUp();
            }
         }
      }
      
      private function on_mc1_upBtn(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.userId != this.familyInfo.f_leaderId || this.body == null)
         {
            return;
         }
         if(this.body.level <= 2)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":8
            });
         }
         else
         {
            --this.body.level;
            this.dispatchEvent(new MessageEvent(EventConst.RECORD_CHANGE_LEVEL,this.body));
         }
      }
      
      public function upLevel() : void
      {
         this.sort();
         this.body = null;
      }
      
      private function on_mc1_downBtn(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.userId != this.familyInfo.f_leaderId || this.body == null)
         {
            return;
         }
         if(this.body.level >= 5)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":9
            });
         }
         else if(this.body.level == 1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":10
            });
         }
         else
         {
            ++this.body.level;
            this.dispatchEvent(new MessageEvent(EventConst.RECORD_CHANGE_LEVEL,this.body));
         }
      }
      
      private function on_mc1_fireBtn(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.userId != this.familyInfo.f_leaderId || this.body == null)
         {
            return;
         }
         if(this.body.uid == GameData.instance.playerData.userId)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":11
            });
            return;
         }
         AlertManager.instance.showTipAlert({
            "systemid":1057,
            "flag":12,
            "callback":this.fireOrNot,
            "data":this.body
         });
      }
      
      private function fireOrNot(str:String, data:Object) : void
      {
         var obj:Object = null;
         var i:int = 0;
         if(str == "确定")
         {
            if(GameData.instance.playerData.userId == this.familyInfo.f_leaderId)
            {
               this.dispatchEvent(new MessageEvent(EventConst.RECORD_FIRE,data));
               if(bg["mc0"]["transTxt"].text != "" && this.familyInfo.trans_id > 0 && data.uid == this.familyInfo.trans_id)
               {
                  this.disport();
               }
               for each(obj in this.members)
               {
                  if(obj.uid == this.body.uid)
                  {
                     i = int(this.members.indexOf(obj));
                     this.members.splice(i,1);
                  }
               }
               this.mlist.dataProvider = this.members;
               this.body = null;
            }
         }
      }
      
      private function on_mc2_changeBtn(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.userId != this.familyInfo.f_leaderId)
         {
            return;
         }
         if(this.changeBadge != null && this.contains(this.changeBadge))
         {
            return;
         }
         this.changeBadge = new FamilyBadgeChange();
         this.addChild(this.changeBadge);
         EventManager.attachEvent(this.changeBadge,EventConst.RECORD_CHANGE_BADGE,this.on_ChangeBadge);
      }
      
      private function on_ChangeBadge(evt:MessageEvent) : void
      {
         this.familyInfo.midid = evt.body.midid;
         this.familyInfo.smallid = evt.body.smallid;
         this.familyInfo.midcolor = evt.body.midcolor;
         this.familyInfo.circolor = evt.body.circolor;
         this.familyInfo._name = evt.body._name;
         this.changeObject = evt.body;
      }
      
      private function on_mc2_transBtn(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.userId != this.familyInfo.f_leaderId)
         {
            return;
         }
         if(this.transLeader != null && this.contains(this.transLeader))
         {
            return;
         }
         this.transLeader = new FamilyLeaderChange();
         this.transLeader.initParams(this.members);
         this.addChild(this.transLeader);
         EventManager.attachEvent(this.transLeader,EventConst.RECORD_TRANSFORM_LEADER,this.on_TransformLeader);
      }
      
      private function on_TransformLeader(evt:MessageEvent) : void
      {
         var param:Object = evt.body;
         param.option = 0;
         this.dispatchEvent(new MessageEvent(EventConst.RECORD_TRANSFORM_LEADER,param));
      }
      
      private function on_mc2_sureBtn(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.userId != this.familyInfo.f_leaderId)
         {
            return;
         }
         if(this.familyInfo.setting == this.setting && this.changeObject == null)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":13
            });
            return;
         }
         this.familyInfo.setting = this.setting;
         if(this.familyInfo.badge_id > 0)
         {
            this.familyInfo.badge_id = 4399;
         }
         this.dispatchEvent(new MessageEvent(EventConst.RECORD_CHANGE_FAMILY_INFO,this.familyInfo));
      }
      
      private function on_btn(evt:MouseEvent) : void
      {
         var index:String = null;
         for(var i:int = 0; i < 3; i++)
         {
            bg["mc" + i].visible = false;
         }
         if(evt == null)
         {
            index = "0";
         }
         else
         {
            index = (evt.target.name as String).substr(3,1);
         }
         bg["mc" + index].visible = true;
         bg["topmc"].gotoAndStop(int(index) + 1);
         bg["topmc2"].gotoAndStop(int(index) + 1);
      }
      
      private function on_bbtn(evt:MouseEvent) : void
      {
         var index:String = null;
         for(var i:int = 0; i < 3; i++)
         {
            bg["mc2"]["mmc" + i].gotoAndStop(1);
         }
         if(evt == null)
         {
            index = "0";
         }
         else
         {
            index = (evt.target.name as String).substr(4,1);
         }
         bg["mc2"]["mmc" + index].gotoAndStop(2);
         this.setting = int(index);
      }
      
      private function onPhpBack(evt:PhpEvent) : void
      {
         bg["mc0"]["countTxt5"].text = evt.data.rank > 0 ? "第" + evt.data.rank + "名" : "300名以外";
      }
      
      override public function disport() : void
      {
         clearInterval(this.tid2);
         GreenLoading.loading.visible = false;
         this.familyInfo = null;
         this.changeObject = null;
         CacheUtil.deleteObject(FamilyRecord);
         EventManager.removeEvent(bg["colseBtn"],MouseEvent.CLICK,this.on_closeBtn);
         EventManager.removeEvent(bg["mc0"]["cancelBtn"],MouseEvent.CLICK,this.on_mc0_cancelBtn);
         EventManager.removeEvent(bg["mc0"]["changeBtn"],MouseEvent.CLICK,this.on_mc0_changeBtn);
         EventManager.removeEvent(bg["mc0"]["saveBtn"],MouseEvent.CLICK,this.on_mc0_saveBtn);
         EventManager.removeEvent(bg["mc0"]["exitBtn"],MouseEvent.CLICK,this.on_mc0_exitBtn);
         EventManager.removeEvent(bg["mc1"]["upBtn"],MouseEvent.CLICK,this.on_mc1_upBtn);
         EventManager.removeEvent(bg["mc1"]["downBtn"],MouseEvent.CLICK,this.on_mc1_downBtn);
         EventManager.removeEvent(bg["mc1"]["fireBtn"],MouseEvent.CLICK,this.on_mc1_fireBtn);
         EventManager.removeEvent(bg["mc2"]["changeBtn"],MouseEvent.CLICK,this.on_mc2_changeBtn);
         EventManager.removeEvent(bg["mc2"]["transBtn"],MouseEvent.CLICK,this.on_mc2_transBtn);
         EventManager.removeEvent(bg["mc2"]["sureBtn"],MouseEvent.CLICK,this.on_mc2_sureBtn);
         EventManager.removeEvent(bg["battleBtn"],MouseEvent.CLICK,this.openGoForBattleView);
         EventManager.removeEvent(this.mlist,ItemClickEvent.ITEMCLICKEVENT,this.on_clickItem);
         for(var i:int = 0; i < 3; i++)
         {
            EventManager.removeEvent(bg["btn" + i],MouseEvent.CLICK,this.on_btn);
            EventManager.removeEvent(bg["mc2"]["bbtn" + i],MouseEvent.CLICK,this.on_bbtn);
         }
         EventManager.removeEvent(PhpConnection.instance(),PhpEventConst.RANK_SEARCH,this.onPhpBack);
         if(this.mlist != null)
         {
            this.mlist.dataProvider = [];
            this.mlist = null;
         }
         if(this.mbar != null)
         {
            this.mbar.dipos();
            this.mbar = null;
         }
         if(Boolean(this.badge) && this.contains(this.badge))
         {
            this.badge.dispos();
            this.badge = null;
         }
         if(Boolean(this.changeBadge) && this.contains(this.changeBadge))
         {
            EventManager.removeEvent(this.changeBadge,EventConst.RECORD_CHANGE_BADGE,this.on_ChangeBadge);
            this.changeBadge.disport();
         }
         if(Boolean(this.transLeader) && this.contains(this.transLeader))
         {
            EventManager.removeEvent(this.transLeader,EventConst.RECORD_TRANSFORM_LEADER,this.on_TransformLeader);
            this.transLeader.disport();
         }
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

