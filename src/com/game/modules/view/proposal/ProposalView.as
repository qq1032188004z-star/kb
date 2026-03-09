package com.game.modules.view.proposal
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.modules.control.proposal.ProposalControl;
   import com.game.util.ChractorFilter;
   import com.game.util.HLoaderSprite;
   import com.game.util.IPTool;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   
   public class ProposalView extends HLoaderSprite
   {
      
      private var proposalMc:MovieClip;
      
      private var option:int;
      
      private var type:int = 1;
      
      private var iptool:IPTool;
      
      private var ipadress:String;
      
      public function ProposalView()
      {
         super();
         this.url = "assets/material/proposal.swf";
      }
      
      override public function setShow() : void
      {
         this.proposalMc = this.bg;
         this.proposalMc.cacheAsBitmap = true;
         this.proposalMc.detailTxt.maxChars = 200;
         this.proposalMc.titleTxt.maxChars = 10;
         this.proposalMc.qqText.maxChars = 11;
         this.proposalMc.qqText.text = "";
         this.proposalMc.qqText.restrict = "0-9";
         ApplicationFacade.getInstance().registerViewLogic(new ProposalControl(this));
      }
      
      public function initEventListener() : void
      {
         EventManager.attachEvent(this.proposalMc.questionBtn,MouseEvent.CLICK,this.clickMenu);
         EventManager.attachEvent(this.proposalMc.ideaBtn,MouseEvent.CLICK,this.clickMenu);
         EventManager.attachEvent(this.proposalMc.complainBtn,MouseEvent.CLICK,this.clickMenu);
         EventManager.attachEvent(this.proposalMc.otherBtn,MouseEvent.CLICK,this.clickMenu);
         EventManager.attachEvent(this.proposalMc.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.attachEvent(this.proposalMc.sendBtn,MouseEvent.CLICK,this.sendMsg);
         EventManager.attachEvent(this.proposalMc.detailTxt,MouseEvent.CLICK,this.clickclearTxt);
         EventManager.attachEvent(this.proposalMc.titleTxt,MouseEvent.CLICK,this.clickclearTxt);
         EventManager.attachEvent(this.proposalMc.helpBtn,MouseEvent.CLICK,this.openHelpView);
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(this.proposalMc.questionBtn,MouseEvent.CLICK,this.clickMenu);
         EventManager.removeEvent(this.proposalMc.ideaBtn,MouseEvent.CLICK,this.clickMenu);
         EventManager.removeEvent(this.proposalMc.complainBtn,MouseEvent.CLICK,this.clickMenu);
         EventManager.removeEvent(this.proposalMc.otherBtn,MouseEvent.CLICK,this.clickMenu);
         EventManager.removeEvent(this.proposalMc.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.removeEvent(this.proposalMc.sendBtn,MouseEvent.CLICK,this.sendMsg);
         EventManager.removeEvent(this.proposalMc.detailTxt,MouseEvent.CLICK,this.clickclearTxt);
         EventManager.removeEvent(this.proposalMc.titleTxt,MouseEvent.CLICK,this.clickclearTxt);
         EventManager.removeEvent(this.proposalMc.helpBtn,MouseEvent.CLICK,this.openHelpView);
      }
      
      private function clickclearTxt(evt:MouseEvent) : void
      {
         if(evt.currentTarget.text == "请输入主题" || evt.currentTarget.text == "请在这里输入内容(不超过200字)\r")
         {
            evt.currentTarget.text = "";
         }
      }
      
      private function clickMenu(evt:Event) : void
      {
         switch(evt.currentTarget)
         {
            case this.proposalMc.questionBtn:
               this.proposalMc.menuMc.gotoAndStop(1);
               this.proposalMc.textMenuMc.gotoAndStop(1);
               this.type = 1;
               break;
            case this.proposalMc.ideaBtn:
               this.type = 2;
               this.proposalMc.menuMc.gotoAndStop(2);
               this.proposalMc.textMenuMc.gotoAndStop(2);
               break;
            case this.proposalMc.complainBtn:
               this.type = 3;
               this.proposalMc.menuMc.gotoAndStop(3);
               this.proposalMc.textMenuMc.gotoAndStop(3);
               break;
            case this.proposalMc.otherBtn:
               this.type = 4;
               this.proposalMc.menuMc.gotoAndStop(4);
               this.proposalMc.textMenuMc.gotoAndStop(4);
         }
      }
      
      private function openHelpView(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPENSWFWINDOWS,{
            "url":"assets/login/helpbook.swf",
            "xCoord":130,
            "yCoord":0
         });
      }
      
      private function closeWindow(evt:Event) : void
      {
         this.parent.removeChild(this);
         this.type = 1;
         this.option = 0;
         this.proposalMc.menuMc.gotoAndStop(1);
         this.proposalMc.textMenuMc.gotoAndStop(1);
      }
      
      private function sendMsg(evt:Event) : void
      {
         if(ChractorFilter.allSpaceAndHuanhang(this.proposalMc.titleTxt.text) || this.proposalMc.titleTxt.text == "请输入主题")
         {
            AlertManager.instance.showTipAlert({
               "systemid":1070,
               "flag":1
            });
            return;
         }
         if(ChractorFilter.allSpaceAndHuanhang(this.proposalMc.detailTxt.text) || this.proposalMc.detailTxt.text == "请在这里输入内容(不超过200字)\r")
         {
            AlertManager.instance.showTipAlert({
               "systemid":1070,
               "flag":2
            });
            return;
         }
         if(ChractorFilter.countMsgLength(this.proposalMc.detailTxt.text) < 5)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1070,
               "flag":3
            });
            return;
         }
         var urlvar:URLVariables = new URLVariables();
         urlvar.user_id = GameData.instance.playerData.userId;
         urlvar.user_name = GameData.instance.playerData.userName;
         if(this.proposalMc.qqText.text != null)
         {
            urlvar.qq = this.proposalMc.qqText.text;
         }
         else
         {
            urlvar.qq = "";
         }
         urlvar.w_type = this.type;
         urlvar.mtitle = this.proposalMc.titleTxt.text;
         urlvar.content = this.proposalMc.detailTxt.text;
         urlvar.content = ChractorFilter.replaceHtml(urlvar.content);
         this.dispatchEvent(new MessageEvent(EventConst.STARTSENDPROPOSAL,urlvar));
         this.parent.removeChild(this);
      }
      
      private function getPersonIp(ip:String) : void
      {
         this.ipadress = ip;
      }
      
      public function clearTxt() : void
      {
         this.proposalMc.titleTxt.text = "";
         this.proposalMc.detailTxt.text = "";
      }
   }
}

