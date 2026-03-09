package com.game.modules.view.family
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.modules.view.WindowLayer;
   import com.game.util.CacheUtil;
   import com.game.util.FloatAlert;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import phpcon.PhpConnection;
   import phpcon.PhpEvent;
   import phpcon.PhpEventConst;
   
   public class FamilyInfoRead extends HLoaderSprite
   {
      
      private var body:Object;
      
      private var badge:FamilyBadge;
      
      private const NUM:Array = ["一","二","三","四","五","六","七","八","九"];
      
      public function FamilyInfoRead()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         if(params != null && this.bg == null)
         {
            if(params.f_number > 0)
            {
               this.body = params;
               this.url = "assets/family/familyInfoRead.swf";
               GreenLoading.loading.visible = true;
               EventManager.attachEvent(PhpConnection.instance(),PhpEventConst.RANK_SEARCH,this.onPhpBack);
            }
            else
            {
               new FloatAlert().show(WindowLayer.instance,350,250,"找不到该家族！");
            }
         }
      }
      
      private function onPhpBack(evt:PhpEvent) : void
      {
         bg["countTxt5"].text = evt.data.rank > 0 ? "第" + evt.data.rank + "名" : "300名以外";
         bg["countTxt7"].text = evt.data.starRank > 0 ? "第" + evt.data.starRank + "名" : "300名以外";
      }
      
      override public function setShow() : void
      {
         if(this.body == null)
         {
            return;
         }
         this.bg.cacheAsBitmap = true;
         this.badge = new FamilyBadge();
         this.badge.setBadge(this.body.midid,this.body.smallid,this.body._name,this.body.midcolor,this.body.circolor);
         this.badge.x = 375;
         this.badge.y = 145;
         this.badge.mouseEnabled = false;
         this.addChildAt(this.badge,this.numChildren);
         bg["nameTxt"].text = this.body.f_name;
         bg["numberTxt"].text = this.body.f_number;
         bg["leaderTxt"].text = this.body.f_leader;
         bg["countTxt1"].text = this.body.f_members;
         bg["countTxt2"].text = this.body.f_monsters;
         bg["countTxt3"].text = this.body.f_upLevels;
         bg["countTxt4"].text = this.body.f_shili;
         bg["countTxt6"].text = this.NUM[int(Math.max(1,this.body.star_level)) - 1];
         EventManager.attachEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
         EventManager.attachEvent(bg["gotoBtn"],MouseEvent.CLICK,this.on_gotoBtn);
         var urlvar:URLVariables = new URLVariables();
         urlvar.fid = this.body.f_number;
         PhpConnection.instance().getdata("family/search_rank.php",urlvar);
         GreenLoading.loading.visible = false;
      }
      
      private function on_closeBtn(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_gotoBtn(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.currentScenenId == 10005)
         {
            new Alert().showSureOrCancel("你确定退出盘丝洞？",this.leaveTeamCopyOrNotForFamily);
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ENTER_FAMILY_BASE,this.body.f_number);
            this.disport();
         }
      }
      
      private function leaveTeamCopyOrNotForFamily(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            ApplicationFacade.getInstance().dispatch(EventConst.LEAVE_TEAMCOPY,{
               "callBack":null,
               "sceneId":1014
            });
            ApplicationFacade.getInstance().dispatch(EventConst.ENTER_FAMILY_BASE,this.body.f_number);
            this.disport();
         }
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(FamilyInfoRead);
         if(bg)
         {
            EventManager.removeEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
            EventManager.removeEvent(bg["gotoBtn"],MouseEvent.CLICK,this.on_gotoBtn);
            EventManager.removeEvent(PhpConnection.instance(),PhpEventConst.RANK_SEARCH,this.onPhpBack);
         }
         if(this.badge != null)
         {
            this.badge.dispos();
            this.badge = null;
         }
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

