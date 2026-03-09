package com.game.modules.view.family
{
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.modules.control.family.FamilyControl;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.HtmlUtil;
   import com.game.util.TimeTransform;
   import com.publiccomponent.ui.ToolTip;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import phpcon.PhpConnection;
   import phpcon.PhpEvent;
   import phpcon.PhpEventConst;
   
   public class FamilyContribution extends HLoaderSprite
   {
      
      private var body:Object = {};
      
      private var Fcontrol:FamilyControl;
      
      private var boxList:Array;
      
      private var countList:Array = [];
      
      private var itemId:Array = [400145,400146,400147,400251,400253,400252];
      
      private var badge:FamilyBadge;
      
      private var current:int = 1;
      
      private var total:int = 40;
      
      public function FamilyContribution()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.body = params;
         this.url = "assets/family/farmily_contribution.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         this.initEvent();
         this.initBG();
         this.initTips();
         this.Fcontrol = ApplicationFacade.getInstance().retrieveViewLogic(FamilyControl.NAME) as FamilyControl;
         this.Fcontrol.ContributionOption(0);
         EventManager.attachEvent(PhpConnection.instance(),PhpEventConst.FAMILY_EVENT,this.onPhpBack);
         this.getPhpData(1);
      }
      
      public function checkContributionOption() : void
      {
         this.Fcontrol.ContributionOption(0);
      }
      
      public function initBox(params:Object) : void
      {
         for(var i:int = 0; i < 6; i++)
         {
            if(params.fid == GameData.instance.playerData.family_id)
            {
               bg["putBtn" + i].filters = null;
               bg["putBtn" + i].mouseEnabled = true;
            }
            else
            {
               bg["putBtn" + i].filters = ColorUtil.getColorMatrixFilterGray();
               bg["putBtn" + i].mouseEnabled = false;
            }
            bg["countTxt" + i].text = params["num" + i] + "个";
            this.countList[i] = params["num" + i];
         }
         if(params.todayNum >= 10)
         {
            bg.boxTxt0.text = "10/10";
         }
         else
         {
            bg.boxTxt0.text = params.todayNum + "/10";
         }
         if(params.todayNum >= 30)
         {
            bg.boxTxt1.text = "30/30";
         }
         else
         {
            bg.boxTxt1.text = params.todayNum + "/30";
         }
         if(params.todayNum >= 50)
         {
            bg.boxTxt2.text = "50/50";
         }
         else
         {
            bg.boxTxt2.text = params.todayNum + "/50";
         }
         bg.manzu1.visible = params.pboxstate == 2;
         bg.manzu2.visible = params.mboxstate == 2;
         bg.manzu3.visible = params.hboxstate == 2;
         var frame1:int = params.pboxstate >= 2 ? 3 : int(params.pboxstate + 1);
         bg.getClip_1.gotoAndStop(frame1);
         if(frame1 == 2)
         {
            EventManager.attachEvent(bg.getClip_1,MouseEvent.CLICK,this.onGetAward);
         }
         else
         {
            EventManager.removeEvent(bg.getClip_1,MouseEvent.CLICK,this.onGetAward);
         }
         var frame2:int = params.mboxstate >= 2 ? 3 : int(params.mboxstate + 1);
         bg.getClip_2.gotoAndStop(frame2);
         if(frame2 == 2)
         {
            EventManager.attachEvent(bg.getClip_2,MouseEvent.CLICK,this.onGetAward);
         }
         else
         {
            EventManager.removeEvent(bg.getClip_2,MouseEvent.CLICK,this.onGetAward);
         }
         var frame3:int = params.hboxstate >= 2 ? 3 : int(params.hboxstate + 1);
         bg.getClip_3.gotoAndStop(frame3);
         if(frame3 == 2)
         {
            EventManager.attachEvent(bg.getClip_3,MouseEvent.CLICK,this.onGetAward);
         }
         else
         {
            EventManager.removeEvent(bg.getClip_3,MouseEvent.CLICK,this.onGetAward);
         }
         bg.boxTxt3.text = params.todayTimes + "/10";
      }
      
      public function lingjiangBack(result:int) : void
      {
         this.Fcontrol.ContributionOption(0);
         if(result == 1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1035,
               "flag":4
            });
            bg.valueTxt.text = int(int(bg.valueTxt.text) + 10) + "";
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1035,
               "flag":3
            });
            bg.valueTxt.text = int(int(bg.valueTxt.text) + 2) + "";
         }
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(bg.btn0,MouseEvent.CLICK,this.onbtn0);
         EventManager.attachEvent(bg.btn1,MouseEvent.CLICK,this.onbtn1);
         EventManager.attachEvent(bg.btn2,MouseEvent.CLICK,this.onbtn2);
         for(var i:int = 0; i < 6; i++)
         {
            EventManager.attachEvent(bg["putBtn" + i],MouseEvent.CLICK,this.onPutBtns);
         }
         EventManager.attachEvent(bg.kaiqiBtn,MouseEvent.CLICK,this.onKaiqiBtn);
      }
      
      private function onbtn0(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function onbtn1(evt:MouseEvent) : void
      {
         if(this.current > 1)
         {
            this.getPhpData(this.current - 1);
         }
      }
      
      private function onbtn2(evt:MouseEvent) : void
      {
         if(this.current < this.total)
         {
            this.getPhpData(this.current + 1);
         }
      }
      
      private function onPutBtns(evt:MouseEvent) : void
      {
         var i:int = int(String(evt.currentTarget.name).charAt(6));
         this.Fcontrol.ContributionOption(2,[this.itemId[i]]);
      }
      
      private function onKaiqiBtn(evt:MouseEvent) : void
      {
         this.Fcontrol.ContributionOption(1);
      }
      
      private function initBG() : void
      {
         this.badge = new FamilyBadge();
         this.badge.setBadge(this.body.midid,this.body.smallid,this.body._name,this.body.midcolor,this.body.circolor,0.5);
         this.badge.x = 164;
         this.badge.y = 288;
         addChild(this.badge);
         this.badge.mouseEnabled = false;
         bg.nameTxt.text = "" + this.body.f_name;
         bg.leaderTxt.text = "" + this.body.f_leader;
         bg.valueTxt.text = "" + this.body.f_shili;
      }
      
      private function initTips() : void
      {
         ToolTip.setDOInfo(bg.mc0,"绿色半月碧：\n捐献家族可提升家族实力的绿色奇玉");
         ToolTip.setDOInfo(bg.mc1,"蓝色半月碧：\n捐献家族可提升家族实力的蓝色奇玉");
         ToolTip.setDOInfo(bg.mc2,"红色半月碧：\n捐献家族可提升家族实力的红色奇玉");
         ToolTip.setDOInfo(bg.mc3,"黄色半月碧：\n捐献家族可提升家族实力的黄色奇玉");
         ToolTip.setDOInfo(bg.mc4,"黑色半月碧：\n捐献家族可提升家族实力的黑色奇玉");
         ToolTip.setDOInfo(bg.mc5,"白色半月碧：\n捐献家族可提升家族实力的白色奇玉");
         ToolTip.setDOInfo(bg.bx0,"初级家族宝箱：\n有几率获得以下物品之一：天香丸、女娲石、升级丹、铜钱 ");
         ToolTip.setDOInfo(bg.bx1,"中级家族宝箱：\n有几率获得以下物品之一：3级灵玉精华、洗髓丹、女娲石、铜钱 ");
         ToolTip.setDOInfo(bg.bx2,"高级家族宝箱：\n有几率获得以下物品之一：随机获得4级灵玉精华、造化丹、女娲石、铜钱 ");
         ToolTip.setDOInfo(bg.bx3,"每收集齐一套半月碧（每种颜色各一个），则家族族长或者副族长可以开启此宝箱，为家族增加实力值，开启实力宝箱会相应扣除一套半月碧。");
      }
      
      private function onGetAward(evt:MouseEvent) : void
      {
         var index:int = int(String(evt.currentTarget.name).charAt(8));
         this.Fcontrol.getBoxAward(index);
      }
      
      private function getPhpData(i:int) : void
      {
         this.current = i;
         var urlvar:URLVariables = new URLVariables();
         urlvar.page = this.current;
         PhpConnection.instance().getdata("family/event_list.php",urlvar);
      }
      
      private function onPhpBack(evt:PhpEvent) : void
      {
         var params:Object = evt.data;
         this.total = int(params.total_page);
         bg.pageTxt.text = this.current + "/" + this.total;
         bg.btn1.mouseEnabled = !Boolean(this.current <= 1);
         bg.btn1.filters = this.current <= 1 ? ColorUtil.getColorMatrixFilterGray() : [];
         bg.btn2.mouseEnabled = !Boolean(this.current >= this.total);
         bg.btn2.filters = this.current >= this.total ? ColorUtil.getColorMatrixFilterGray() : [];
         var list:Array = params.list as Array;
         if(list == null)
         {
            list = [];
         }
         for(var i:int = 0; i < 5; i++)
         {
            if(list[i] == null)
            {
               bg["txt" + i].htmlText = "";
            }
            else if(list[i].type == 1)
            {
               bg["txt" + i].htmlText = HtmlUtil.getHtmlText(12,"#990000","【" + list[i].uname + "】") + "在" + TimeTransform.getInstance().transDate(list[i].time) + "捐献了半月碧给" + HtmlUtil.getHtmlText(12,"#990000","【" + list[i].fname + "】") + "，使家族实力得到提升，人人称赞！（共已捐献" + HtmlUtil.getHtmlText(12,"#990000","" + list[i].times) + "次）";
            }
            else if(list[i].type == 2)
            {
               bg["txt" + i].htmlText = HtmlUtil.getHtmlText(12,"#990000","【" + list[i].fname + "】") + "在" + TimeTransform.getInstance().transDate(list[i].time) + "开启了" + HtmlUtil.getHtmlText(12,"#990000","【家族宝箱】") + "，家族成员获得丰厚奖励，可喜可贺！";
            }
         }
      }
      
      override public function disport() : void
      {
         var i:int = 0;
         CacheUtil.deleteObject(FamilyContribution);
         if(bg)
         {
            EventManager.removeEvent(bg.btn0,MouseEvent.CLICK,this.onbtn0);
            EventManager.removeEvent(bg.btn1,MouseEvent.CLICK,this.onbtn1);
            EventManager.removeEvent(bg.btn2,MouseEvent.CLICK,this.onbtn2);
            for(i = 0; i < 6; i++)
            {
               EventManager.removeEvent(bg["putBtn" + i],MouseEvent.CLICK,this.onPutBtns);
            }
            EventManager.removeEvent(bg.kaiqiBtn,MouseEvent.CLICK,this.onKaiqiBtn);
            EventManager.removeEvent(PhpConnection.instance(),PhpEventConst.FAMILY_EVENT,this.onPhpBack);
            ToolTip.LooseDO(bg.mc0);
            ToolTip.LooseDO(bg.mc1);
            ToolTip.LooseDO(bg.mc2);
            ToolTip.LooseDO(bg.mc3);
            ToolTip.LooseDO(bg.mc4);
            ToolTip.LooseDO(bg.mc5);
            ToolTip.LooseDO(bg.bx0);
            ToolTip.LooseDO(bg.bx1);
            ToolTip.LooseDO(bg.bx2);
            ToolTip.LooseDO(bg.bx3);
         }
         super.disport();
      }
   }
}

