package com.game.modules.view.trump
{
   import com.game.modules.view.monster.SymmEnum;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.TimeTransform;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class TrumpTrainMonster extends HLoaderSprite
   {
      
      private var swfLoader:Loader;
      
      public var body:Object;
      
      public function TrumpTrainMonster()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.body = params;
         this.swfLoader = new Loader();
         this.url = "assets/fabao/trumptrainshow.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         this.swfLoader.scaleX = 1.6;
         this.swfLoader.scaleY = 1.6;
         this.swfLoader.x = 330;
         this.swfLoader.y = 140;
         addChild(this.swfLoader);
         this.setMonsterInfo(this.body);
         bg.symm.buttonMode = true;
         bg.btn0.addEventListener(MouseEvent.CLICK,this.onbtn0);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      private function onbtn0(evt:MouseEvent) : void
      {
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function setMonsterInfo(obj:Object) : void
      {
         var xml:XML = null;
         var url:String = null;
         var i:int = 0;
         if(obj == null)
         {
            this.swfLoader.unload();
            bg["typeClip"].visible = false;
            bg["idTxt"].text = "";
            bg["nameTxt"].text = "";
            bg["levelTxt"].text = "";
            bg["modoTxt"].text = "";
            bg["geniusTxt"].text = "";
            bg["needExpTxt"].text = "";
            bg["timeTxt"].text = "";
            bg["tiliTxt"].text = "";
            bg["suduTxt"].text = "";
            bg["gongjiTxt"].text = "";
            bg["fangyuTxt"].text = "";
            bg["fashuTxt"].text = "";
            bg["kangxingTxt"].text = "";
         }
         else
         {
            xml = XMLLocator.getInstance().getSprited(obj.iid);
            url = URLUtil.getSvnVer("assets/monsterswf/" + obj.iid + ".swf");
            this.swfLoader.unload();
            this.swfLoader.load(new URLRequest(url));
            bg["typeClip"].visible = true;
            bg["typeClip"].gotoAndStop(obj.type + 1);
            bg["idTxt"].text = "" + xml.sequence;
            bg["nameTxt"].text = "" + xml.name;
            bg["levelTxt"].text = "" + obj.level;
            bg["modoTxt"].text = "" + CommonDefine.moldList[obj.mold - 1];
            bg["geniusTxt"].text = "" + obj.CountGeniuscount;
            bg["timeTxt"].text = "        " + TimeTransform.getInstance().transDate(int(obj.timetxt));
            if(obj.symmFlag > 0)
            {
               ToolTip.setDOInfo(bg["symm"],"已装备灵玉");
               bg.symm.filters = null;
               bg["tiliTxt"].htmlText = obj.addStrength > 0 ? SymmEnum.getContentColor(obj.addStrength + obj.strength + "") : obj.strength + "";
               bg["suduTxt"].htmlText = obj.addSpeed > 0 ? SymmEnum.getContentColor(obj.addSpeed + obj.speed + "") : obj.speed + "";
               bg["gongjiTxt"].htmlText = obj.addAttack > 0 ? SymmEnum.getContentColor(obj.addAttack + obj.attack + "") : obj.attack + "";
               bg["fangyuTxt"].htmlText = obj.addDefence > 0 ? SymmEnum.getContentColor(obj.addDefence + obj.magic + "") : obj.magic + "";
               bg["fashuTxt"].htmlText = obj.addMagic > 0 ? SymmEnum.getContentColor(obj.addMagic + obj.defence + "") : obj.defence + "";
               bg["kangxingTxt"].htmlText = obj.addResistance > 0 ? SymmEnum.getContentColor(obj.addResistance + obj.resistance + "") : obj.resistance + "";
            }
            else
            {
               ToolTip.setDOInfo(bg["symm"],"未装备灵玉");
               bg.symm.filters = ColorUtil.getColorMatrixFilterGray();
               bg["tiliTxt"].text = "" + obj.strength;
               bg["suduTxt"].text = "" + obj.speed;
               bg["gongjiTxt"].text = "" + obj.attack;
               bg["fangyuTxt"].text = "" + obj.magic;
               bg["fashuTxt"].text = "" + obj.defence;
               bg["kangxingTxt"].text = "" + obj.resistance;
            }
            bg.xiuTxt1.text = "" + obj.hpLearnValue;
            bg.xiuTxt2.text = "" + obj.attackLearnValue;
            bg.xiuTxt3.text = "" + obj.defenceLearnValue;
            bg.xiuTxt4.text = "" + obj.magicLearnValue;
            bg.xiuTxt5.text = "" + obj.resistanceLearnValue;
            bg.xiuTxt6.text = "" + obj.speedLearnVale;
            bg.mc1.gotoAndStop(obj.hpGeniusValue == 31 ? 7 : obj.hpGenius);
            bg.mc2.gotoAndStop(obj.attackGeniusValue == 31 ? 7 : obj.attackGenius);
            bg.mc3.gotoAndStop(obj.defenceGeniusValue == 31 ? 7 : obj.defenceGenius);
            bg.mc4.gotoAndStop(obj.magicGeniusValue == 31 ? 7 : obj.magicGenius);
            bg.mc5.gotoAndStop(obj.resistanceGeniusValue == 31 ? 7 : obj.resistanceGenius);
            bg.mc6.gotoAndStop(obj.speedGeniusValue == 31 ? 7 : obj.speedGenius);
            for(i = 1; i <= 6; i++)
            {
               ToolTip.setDOInfo(bg["mc" + i],"资质");
               ToolTip.setDOInfo(bg["xiuwei" + i],"修为");
            }
         }
      }
      
      private function onRemoved(evt:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.disport();
      }
      
      override public function disport() : void
      {
         if(bg == null)
         {
            return;
         }
         ToolTip.LooseDO(bg.symm);
         for(var i:int = 1; i <= 6; i++)
         {
            ToolTip.LooseDO(bg["mc" + i]);
            ToolTip.LooseDO(bg["xiuwei" + i]);
         }
         CacheUtil.deleteObject(TrumpTrainMonster);
         bg.btn0.removeEventListener(MouseEvent.CLICK,this.onbtn0);
         this.swfLoader.unload();
         this.swfLoader = null;
         super.disport();
      }
   }
}

