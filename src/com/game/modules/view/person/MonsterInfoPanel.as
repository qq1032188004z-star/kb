package com.game.modules.view.person
{
   import com.game.Tools.AttributeCharacterIcon;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.manager.EventManager;
   import com.game.modules.control.monster.SpiritGenius;
   import com.game.modules.view.MapView;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.TimeTransform;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class MonsterInfoPanel extends HLoaderSprite
   {
      
      private var mloader:Loader;
      
      public var showData:Object;
      
      private var _attIcon:AttributeCharacterIcon;
      
      public function MonsterInfoPanel()
      {
         GreenLoading.loading.visible = true;
         super();
         this.url = "assets/material/monsterinfo.swf";
      }
      
      override public function setShow() : void
      {
         this.mloader = new Loader();
         this.mloader.x = 45;
         this.mloader.y = 50;
         addChild(this.mloader);
         this._attIcon = new AttributeCharacterIcon();
         bg["spAtt"].addChild(this._attIcon);
         bg.masterBtn.buttonMode = true;
         EventManager.attachEvent(bg.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.attachEvent(bg.masterBtn,MouseEvent.CLICK,this.onMasterViewHandler);
         this.startShow();
         GreenLoading.loading.visible = false;
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.setData(params);
      }
      
      public function setData(params:Object) : void
      {
         this.showData = params;
         this.startShow();
      }
      
      private function startShow() : void
      {
         if(!this.showData || !this.mloader)
         {
            return;
         }
         this.mloader.unload();
         this.mloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + this.showData.tid + ".swf")));
         var xml:XML = XMLLocator.getInstance().getSprited(this.showData.tid);
         if(!xml)
         {
            return;
         }
         this._attIcon.id = this.showData.type;
         bg.snTxt.text = xml.sequence;
         bg.bignameTxt.text = xml.name;
         bg.nameTxt.text = xml.name;
         bg.levelTxt.text = this.showData.level;
         bg.moldTxt.text = CommonDefine.moldList[this.showData.mold - 1] + "";
         bg.timeTxt.text = TimeTransform.getInstance().transDate(this.showData.time);
         bg.masterTxt.text = this.showData.master;
         bg.descTxt.text = xml.introduce;
         var starCount:int = SpiritGenius.countGeniusTotal(this.showData.starCount);
         if(starCount >= 6)
         {
            bg.aptClip.gotoAndStop(starCount);
            bg.aptMc.play();
            bg.aptMc.visible = true;
            bg.aptTxt.visible = false;
            bg.aptClip.visible = true;
         }
         else
         {
            bg.aptClip.stop();
            bg.aptClip.visible = false;
            bg.aptTxt.text = CommonDefine.aptLit[starCount];
            bg.aptTxt.visible = true;
            bg.aptMc.stop();
            bg.aptMc.visible = false;
         }
         if(this.showData.masterSex == 1)
         {
            bg.masterBtn.gotoAndStop(1);
         }
         else
         {
            bg.masterBtn.gotoAndStop(2);
         }
         if(Boolean(this.showData.hasOwnProperty("hasSymm")) && Boolean(this.showData.hasSymm))
         {
            ToolTip.setDOInfo(bg.symm,"已装备灵玉");
            bg.symm.filters = null;
         }
         else
         {
            bg.symm.filters = ColorUtil.getColorMatrixFilterGray();
            ToolTip.setDOInfo(bg.symm,"未装备灵玉");
         }
      }
      
      private function onMasterViewHandler(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         if(this.showData.masterid != GlobalConfig.userId)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPENPERSONINFOVIEW,{
               "userId":this.showData.masterid,
               "isOnline":1,
               "source":0,
               "userName":this.showData.master,
               "sex":this.showData.masterSex
            });
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPENPERSONDETAILVIEW,{
               "userId":this.showData.masterid,
               "isOnline":1,
               "source":0,
               "userName":this.showData.master,
               "sex":this.showData.masterSex,
               "body":MapView.instance.masterPerson.showData
            });
         }
      }
      
      private function closeWindow(evt:MouseEvent) : void
      {
         this.showData = null;
         bg.aptMc.stop();
         this.parent.removeChild(this);
      }
      
      override public function disport() : void
      {
         this.showData = null;
         bg.aptMc.stop();
         if(Boolean(this._attIcon))
         {
            this._attIcon.dispose();
            this._attIcon = null;
         }
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

