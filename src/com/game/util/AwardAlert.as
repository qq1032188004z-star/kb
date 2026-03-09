package com.game.util
{
   import caurina.transitions.Tweener;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.WindowLayer;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.MaterialLib;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.*;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol27")]
   public class AwardAlert extends Sprite
   {
      
      public var okBtn:SimpleButton;
      
      public var tipTxt:TextField;
      
      public var dirClip:MovieClip;
      
      public var leftCClip:MovieClip;
      
      public var maskClip:MovieClip;
      
      public var tb:SimpleButton;
      
      private var leftLoader:Loader;
      
      private var rightLoader:Loader;
      
      private var tipLoader:Loader;
      
      private var rightClip:MovieClip;
      
      private var callBack:Function;
      
      private var parameters:Array;
      
      private var descstr:String = "";
      
      private var baotip:Loader;
      
      private var useState:int;
      
      public function AwardAlert()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this.dirClip.gotoAndStop(1);
         this.leftLoader = new Loader();
         this.leftCClip.addChild(this.leftLoader);
         this.tipLoader = new Loader();
         this.addChild(this.tipLoader);
         this.tipLoader.mouseChildren = false;
         this.tipLoader.mouseEnabled = false;
         this.tipLoader.visible = false;
         this.leftCClip.mask = this.maskClip;
         this.tb.visible = false;
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(this.okBtn,MouseEvent.MOUSE_DOWN,this.dispos);
         EventManager.attachEvent(this.tipLoader,IOErrorEvent.IO_ERROR,this.onTipLoadError);
         EventManager.attachEvent(this.tb,MouseEvent.ROLL_OVER,this.onOverTbHandler);
         EventManager.attachEvent(this.tb,MouseEvent.ROLL_OUT,this.onOutTbHandler);
      }
      
      private function onOverTbHandler(evnet:MouseEvent) : void
      {
         if(this.baotip == null)
         {
            this.baotip = new Loader();
            this.baotip.mouseChildren = false;
            this.baotip.mouseEnabled = false;
            this.baotip.x = 340;
            this.addChild(this.baotip);
            this.baotip.load(new URLRequest(URLUtil.getSvnVer("assets/material/award10tips.swf")));
         }
         if(Boolean(this.baotip) && !this.contains(this.baotip))
         {
            this.addChild(this.baotip);
         }
      }
      
      private function onOutTbHandler(event:MouseEvent) : void
      {
         if(Boolean(this.baotip) && this.contains(this.baotip))
         {
            this.removeChild(this.baotip);
         }
      }
      
      private function onTipLoadError(e:IOErrorEvent) : void
      {
         O.o("不存在改tips");
      }
      
      public function showMoneyAward(money:int, parent:DisplayObjectContainer, callBack:Function = null) : void
      {
         this.drawGraphics();
         this.tipTxt.y = 83.2;
         this.dirClip.visible = true;
         this.callBack = callBack;
         GameData.instance.playerData.coin += money;
         this.leftLoader.x += 10;
         this.leftLoader.y += 10;
         this.leftLoader.load(new URLRequest(URLUtil.getSvnVer("assets/material/coin.swf")));
         this.tipTxt.htmlText = "获得" + HtmlUtil.getHtmlText(12,"#FF0000",money + "") + "个铜钱已放入你的背包";
         this.setRightClip("pack",parent);
      }
      
      private function setRightClip(strValue:String, parent:DisplayObjectContainer) : void
      {
         if(this.rightClip != null)
         {
            if(this.contains(this.rightClip))
            {
               this.rightClip.stop();
               this.removeChild(this.rightClip);
               this.rightClip = null;
            }
         }
         this.rightClip = MaterialLib.getInstance().getMaterial(strValue) as MovieClip;
         this.rightClip.x = 250 - this.rightClip.width / 2;
         this.rightClip.y = 50 - this.rightClip.height / 2;
         this.addChild(this.rightClip);
         EventManager.attachEvent(this.rightClip,MouseEvent.ROLL_OVER,this.onMouseRollOver);
         EventManager.attachEvent(this.rightClip,MouseEvent.ROLL_OUT,this.onMouseRollOut);
         this.x = 300;
         this.y = 150;
         setChildIndex(this.tipLoader,numChildren - 1);
         parent.addChild(this);
      }
      
      private function onMouseRollOver(e:MouseEvent) : void
      {
         this.tipLoader.visible = true;
      }
      
      private function onMouseRollOut(e:MouseEvent) : void
      {
         this.tipLoader.visible = false;
      }
      
      public function showExpAward(exp:int, parent:DisplayObjectContainer, callBack:Function = null, ... rest) : void
      {
         this.drawGraphics();
         this.callBack = callBack;
         if(rest.length > 0)
         {
            this.parameters = [];
            this.parameters = rest;
         }
         this.tipTxt.y = 83.2;
         this.dirClip.visible = true;
         this.leftCClip.mask = null;
         this.leftLoader.x += 20;
         this.leftLoader.y += 10;
         this.leftLoader.load(new URLRequest(URLUtil.getSvnVer("assets/material/exp.swf")));
         this.tipTxt.htmlText = "获得" + HtmlUtil.getHtmlText(12,"#FF0000",exp + "") + "积累历练已放入你的贝贝中";
         this.setRightClip("fabao",parent);
      }
      
      public function showGoodsAward(url:String, parent:DisplayObjectContainer, msg:String, flag:Boolean, callBack:Function = null, ... rest) : void
      {
         this.drawGraphics();
         this.callBack = callBack;
         this.tipTxt.y = 83.2;
         this.dirClip.visible = true;
         if(rest.length > 0)
         {
            this.parameters = [];
            this.parameters = rest;
         }
         this.leftLoader.load(new URLRequest(URLUtil.getSvnVer(url)));
         this.tipTxt.htmlText = msg;
         if(flag)
         {
            this.dirClip.gotoAndStop(1);
         }
         else
         {
            this.dirClip.gotoAndStop(2);
         }
         var index1:int = int(url.lastIndexOf("/"));
         var index2:int = int(url.indexOf(".swf"));
         var str:String = url.substring(index1 + 1,index2);
         var xml:XML = XMLLocator.getInstance().tooldic[int(str)];
         if(xml != null)
         {
            this.useState = xml.useState;
            this.descstr = xml.desc;
            if(this.isSpecifiedBitAvailable(this.useState,10))
            {
               this.tb.visible = true;
               this.setRightClip("award10tips",parent);
               this.tipLoader.load(new URLRequest(URLUtil.getSvnVer("assets/material/award10tips.swf")));
            }
            else if(this.isSpecifiedBitAvailable(this.useState,11))
            {
               this.setRightClip("award11tips",parent);
               this.tipLoader.load(new URLRequest(URLUtil.getSvnVer("assets/material/award11tips.swf")));
            }
            else if(this.isSpecifiedBitAvailable(this.useState,12))
            {
               this.setRightClip("pack",parent);
               this.tipLoader.load(new URLRequest(URLUtil.getSvnVer("assets/material/award12tips.swf")));
            }
            else if(this.isSpecifiedBitAvailable(this.useState,13))
            {
               this.setRightClip("award11tips",parent);
               this.tipLoader.load(new URLRequest(URLUtil.getSvnVer("assets/material/award13tips.swf")));
            }
            else if(this.isSpecifiedBitAvailable(this.useState,14))
            {
               this.setRightClip("award14tips",parent);
               this.tipLoader.load(new URLRequest(URLUtil.getSvnVer("assets/material/award14tips.swf")));
            }
            else
            {
               this.setRightClip("pack",parent);
            }
         }
         else
         {
            this.setRightClip("pack",parent);
         }
         if(Boolean(this.descstr) && this.descstr != "")
         {
            ToolTip.BindDO(this.leftLoader,this.descstr);
         }
      }
      
      public function showMonsterAward(url:String, parent:DisplayObjectContainer, msg:String, flag:Boolean, callBack:Function = null, ... rest) : void
      {
         this.drawGraphics();
         if(rest.length > 0)
         {
            this.parameters = [];
            this.parameters = rest;
         }
         this.callBack = callBack;
         this.tipTxt.y = 83.2;
         this.dirClip.visible = true;
         this.leftLoader.load(new URLRequest(URLUtil.getSvnVer(url)));
         this.tipTxt.htmlText = HtmlUtil.getHtmlText(12,"#FF0000",msg);
         this.setRightClip("mpack",parent);
      }
      
      public function showMultipleAward(leftUrl:String, rightUrl:String, parent:DisplayObjectContainer, msg:String, flag:Boolean, callBack:Function = null, ... rest) : void
      {
         this.drawGraphics();
         if(rest.length > 0)
         {
            this.parameters = [];
            this.parameters = rest;
         }
         this.callBack = callBack;
         this.tipTxt.y = 83.2;
         this.dirClip.visible = true;
         this.leftLoader.y = 14.2;
         this.leftLoader.load(new URLRequest(leftUrl));
         this.tipTxt.htmlText = msg;
         if(this.rightClip != null)
         {
            if(this.contains(this.rightClip))
            {
               this.rightClip.stop();
               this.removeChild(this.rightClip);
               this.rightClip = null;
            }
         }
         this.rightLoader = new Loader();
         this.rightLoader.load(new URLRequest(rightUrl));
         this.rightLoader.x = 215 - this.rightLoader.width / 2;
         this.rightLoader.y = 15 - this.rightLoader.height / 2;
         this.addChild(this.rightLoader);
         this.x = 300;
         this.y = 150;
         parent.addChild(this);
      }
      
      public function showCultivateAward(cultivate:int, parent:DisplayObjectContainer, callBack:Function = null) : void
      {
         this.drawGraphics();
         this.tipTxt.y = 63.2;
         this.dirClip.visible = false;
         this.callBack = callBack;
         this.tipTxt.htmlText = "获得" + HtmlUtil.getHtmlText(12,"#FF0000",cultivate + "") + "修行值";
         this.x = 300;
         this.y = 150;
         parent.addChild(this);
      }
      
      private function removeAllEvenet() : void
      {
         EventManager.removeEvent(this.okBtn,MouseEvent.MOUSE_DOWN,this.dispos);
         EventManager.removeEvent(this.rightClip,MouseEvent.ROLL_OVER,this.onMouseRollOver);
         EventManager.removeEvent(this.rightClip,MouseEvent.ROLL_OUT,this.onMouseRollOut);
      }
      
      public function removeCallBack() : void
      {
         this.callBack = null;
      }
      
      private function dispos(evt:MouseEvent) : void
      {
         this.graphics.clear();
         this.dirClip.stop();
         if(this.callBack != null)
         {
            if(this.parameters == null)
            {
               this.callBack.apply(null,[null]);
            }
            else
            {
               this.callBack.apply(null,this.parameters);
            }
         }
         this.removeAllEvenet();
         if(this.leftLoader != null)
         {
            ToolTip.LooseDO(this.leftLoader);
            if(Boolean(this.leftLoader.parent) && this.leftLoader.parent.contains(this.leftLoader))
            {
               this.leftLoader.parent.removeChild(this.leftLoader);
               if(RenderUtil.instance.renderstate && this.isSpecifiedBitAvailable(this.useState,8) && FaceView.clip && FaceView.clip.x < 10 && FaceView.clip.x > -10)
               {
                  this.useState = 0;
                  this.leftLoader.x = 378;
                  this.leftLoader.y = 170;
                  WindowLayer.instance.addChild(this.leftLoader);
                  Tweener.addTween(this.leftLoader,{
                     "x":570,
                     "y":520,
                     "alpha":0.5,
                     "time":0.8,
                     "onComplete":this.moveleftLoader
                  });
               }
               else
               {
                  this.leftLoader.unloadAndStop(false);
                  this.leftLoader = null;
               }
            }
         }
         if(Boolean(this.baotip))
         {
            this.baotip.unloadAndStop(false);
            if(this.contains(this.baotip))
            {
               this.removeChild(this.baotip);
            }
            this.baotip = null;
         }
         if(Boolean(this.tipLoader))
         {
            if(this.contains(this.tipLoader))
            {
               this.removeChild(this.tipLoader);
            }
            this.tipLoader.unloadAndStop(true);
            this.tipLoader = null;
         }
         if(this.rightLoader != null)
         {
            this.rightLoader.unloadAndStop();
            if(this.contains(this.rightLoader))
            {
               this.removeChild(this.rightLoader);
            }
            this.rightLoader = null;
         }
         if(this.rightClip != null)
         {
            if(this.contains(this.rightClip))
            {
               this.rightClip.stop();
               this.removeChild(this.rightClip);
               this.rightClip = null;
            }
         }
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
         this.callBack = null;
         this.parameters = null;
      }
      
      private function moveleftLoader(event:Event = null) : void
      {
         this.leftLoader.visible = false;
         ToolTip.LooseDO(this.leftLoader);
         if(this.leftLoader && this.leftLoader.parent && this.leftLoader.parent.contains(this.leftLoader))
         {
            this.leftLoader.parent.removeChild(this.leftLoader);
         }
         if(Boolean(this.leftLoader))
         {
            this.leftLoader.unloadAndStop(false);
            this.leftLoader = null;
         }
         this.dispos(null);
      }
      
      private function drawGraphics() : void
      {
         this.graphics.clear();
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(-1000,-1000,2000,2000);
         this.graphics.endFill();
      }
      
      private function isSpecifiedBitAvailable(bitStatus:int, bit:int) : Boolean
      {
         return (bitStatus & 1 << bit - 1) > 0 ? true : false;
      }
   }
}

