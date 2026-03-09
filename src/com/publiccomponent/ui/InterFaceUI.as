package com.publiccomponent.ui
{
   import caurina.transitions.Tweener;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.util.ChatUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.base.UIComponentConfig;
   import com.publiccomponent.events.InterfaceEvent;
   import com.publiccomponent.smile.SmileView;
   import com.publiccomponent.tips.MainUIToolTip;
   import com.publiccomponent.tips.NewToolTip;
   import com.publiccomponent.util.ButtonEffectUtil;
   import com.publiccomponent.util.SimpleTweener;
   import com.publiccomponent.util.SpeciaLib;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   
   public class InterFaceUI extends Sprite
   {
      
      private var _topClip:TopClip;
      
      public var topMiddleClip:TopMiddleClip;
      
      public var middleClip:MiddleClip;
      
      public var bottomClip:BottomClip;
      
      public var newHand:NewHandControl;
      
      public var speciaLib:SpeciaLib;
      
      public var chatClip:*;
      
      public var smile:SmileView;
      
      private var _uidata:UIComponentConfig;
      
      private var loader:Loader;
      
      private var domain:ApplicationDomain;
      
      private var actDomain:ApplicationDomain;
      
      private var chatList:Array = [];
      
      private var chatIndex:int = -1;
      
      private var st:int = -1000;
      
      private var sn:String = "";
      
      public function InterFaceUI()
      {
         super();
         this._uidata = new UIComponentConfig(this.onCongigComplete);
      }
      
      public function get topClip() : TopClip
      {
         return this._topClip;
      }
      
      public function set topClip(value:TopClip) : void
      {
         this._topClip = value;
      }
      
      private function onCongigComplete(param:Object) : void
      {
         var clipVisible:Boolean = false;
         switch(param.type)
         {
            case -1:
               this.init();
               break;
            case 1:
               if(Boolean(this.getTopButton(param.name)))
               {
                  clipVisible = this.getTopButton(param.name).visible;
               }
               if(!clipVisible)
               {
                  this._topClip.showBtnByName(param.name);
               }
               if(param.effect == 1 && !CacheData.instance.uiEffectDic[param.name])
               {
                  ButtonEffectUtil.registerEffect(this.getTopButton(param.name),ButtonEffect.EFFECT_WEEKLY,true);
               }
               break;
            case 2:
               if(Boolean(this.getTopButton(param.name)))
               {
                  clipVisible = this.getTopButton(param.name).visible;
               }
               if(clipVisible)
               {
                  CacheData.instance.uiEffectDic[param.name] = false;
                  ButtonEffectUtil.delEffect(this.getTopButton(param.name));
                  this._topClip.hideBtnByName(param.name);
               }
         }
      }
      
      private function init() : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadIcon);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/login/ui.swf")));
      }
      
      private function onLoadIcon(evt:Event) : void
      {
         this.domain = evt.currentTarget.applicationDomain as ApplicationDomain;
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadIcon);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/login/ActivityIcon.swf")));
      }
      
      private function onLoaded(evt:Event) : void
      {
         NewToolTip.init(stage);
         MainUIToolTip.init(stage);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
         this.actDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         this._topClip = new TopClip(this.actDomain,this._uidata.dataList["typelist0"]);
         this.topMiddleClip = new TopMiddleClip();
         this.bottomClip = new BottomClip();
         this.middleClip = new MiddleClip();
         this.smile = new SmileView(240,465);
         var cls2:Class = this.domain.getDefinition("BottomMC") as Class;
         this.bottomClip.init(new cls2() as MovieClip,this._uidata.dataList["typelist2"]);
         var cls3:Class = this.domain.getDefinition("middleMc") as Class;
         this.middleClip.init(new cls3() as MovieClip);
         var cls4:Class = this.domain.getDefinition("topMiddleMc") as Class;
         this.topMiddleClip.init(new cls4() as MovieClip,this._uidata.dataList["typelist1"]);
         this.newHand = new NewHandControl(this._topClip.topList,this.bottomClip,this.topMiddleClip);
         dispatchEvent(new Event(Event.COMPLETE));
         this.middleClip.x = -66.6;
         this.middleClip.y = 180;
         this.bottomClip.x = 475.4;
         this.bottomClip.y = 520;
         this.smile.visible = false;
         this.addChild(this.smile);
         this.addChild(this._topClip);
         this.addChild(this.bottomClip);
         this.addChild(this.middleClip);
         this.addChild(this.topMiddleClip);
         this.loader.unload();
         this.loader = null;
         this.speciaLib = new SpeciaLib();
         this.initEvent();
      }
      
      public function getSpecia() : MovieClip
      {
         var cls:Class = this.domain.getDefinition("specia") as Class;
         return new cls() as MovieClip;
      }
      
      public function getBtnEffect(effectType:int) : MovieClip
      {
         var cls:Class = this.domain.getDefinition("effect" + effectType) as Class;
         var mc:MovieClip = new cls() as MovieClip;
         if(mc == null)
         {
            cls = this.domain.getDefinition("effect1") as Class;
            mc = new cls() as MovieClip;
         }
         return mc;
      }
      
      public function checkIsInActiveTime() : void
      {
         if(GameData.instance.playerData.isNewHand > 8)
         {
            this._uidata.checkActiveTime();
         }
      }
      
      public function controlNewHand(phares:int) : void
      {
         this.newHand.controlUI(phares);
      }
      
      public function getTopButton(name:String) : TopButton
      {
         return this._topClip.getButtonByName(name);
      }
      
      private function initEvent() : void
      {
         var iconbtn:Object = null;
         var topMiddleObj:Object = null;
         var key:String = null;
         for each(iconbtn in this._topClip.topList)
         {
            if(Boolean(iconbtn.item))
            {
               iconbtn.item.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            }
            else
            {
               O.o("上方按钮不存在");
            }
         }
         for each(topMiddleObj in this.newHand.topMiddleList)
         {
            if(Boolean(topMiddleObj.item))
            {
               topMiddleObj.item.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
               topMiddleObj.item.addEventListener(MouseEvent.ROLL_OVER,this.onRollOverHandler);
               topMiddleObj.item.addEventListener(MouseEvent.ROLL_OUT,this.onRollOutHandler);
            }
            else
            {
               O.o(topMiddleObj.tips);
            }
         }
         for(key in this.newHand.bottomList)
         {
            if(key == "msgTxt")
            {
               this.newHand.bottomList[key].item.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
               this.newHand.bottomList[key].item.maxChars = 50;
            }
            else if(key == "chatClipBtn")
            {
               this.newHand.bottomList[key].item.addEventListener(MouseEvent.CLICK,this.onClickChatClipBtn);
               this.newHand.bottomList[key].item.gotoAndStop(1);
            }
            else if(key == "statePanel_mc")
            {
               this.newHand.bottomList[key].item.visible = false;
               this.newHand.bottomList[key].item.y += 291;
            }
            else if(Boolean(this.newHand.bottomList[key].item))
            {
               this.newHand.bottomList[key].item.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
               this.newHand.bottomList[key].item.addEventListener(MouseEvent.ROLL_OVER,this.onRollOverHandler);
               this.newHand.bottomList[key].item.addEventListener(MouseEvent.ROLL_OUT,this.onRollOutHandler);
            }
            else
            {
               O.o(key);
            }
         }
      }
      
      private function onRollOverHandler(event:MouseEvent) : void
      {
         var tipstr:String = null;
         var customX:Number = NaN;
         var customY:Number = NaN;
         var tipObjb:Object = null;
         var tipstrBattle:String = null;
         var msg:String = null;
         var body:Object = null;
         var tipName:String = event.currentTarget.name;
         if(tipName == "newsclip" || tipName == "newMsgClip")
         {
            this.bottomClip.showNewsTipApply();
         }
         else if(tipName == "battleClip")
         {
            tipObjb = this.newHand.getTipByName(tipName);
            tipstrBattle = tipObjb.tips;
            customX = event.currentTarget.x + event.currentTarget.width / 2 + 25;
            customY = event.currentTarget.y + 67;
         }
         else if(tipName == "friendClick")
         {
            if(Boolean(GameData.instance.playerData.addFriendMsgList) && GameData.instance.playerData.addFriendMsgList.length > 0)
            {
               msg = "";
               if(GameData.instance.playerData.addFriendMsgList.length == 1)
               {
                  body = GameData.instance.playerData.addFriendMsgList[0];
                  msg = ChatUtil.onCheckStr(body.cName) + " 请求加你为好友!";
               }
               else
               {
                  msg = "有" + GameData.instance.playerData.addFriendMsgList.length + "位小卡布请求加你为好友!";
               }
               this.bottomClip.showFriendApplyTips(msg);
            }
         }
         else if(tipName == "tipsMc")
         {
            this.bottomClip.showFriendApplyTips();
         }
         else if("effectName" == tipName)
         {
            this.topMiddleClip.showEffect();
         }
      }
      
      public function onRollOutHandler(event:MouseEvent) : void
      {
         if(event != null && event.currentTarget == this.bottomClip.friendClick)
         {
            this.bottomClip.hideFriendApplyTipsDelay();
         }
         else if(event != null && event.currentTarget == this.bottomClip.newMsgClip)
         {
            this.bottomClip.hideNewsTipApply();
         }
         else if(event != null && event.currentTarget == this.bottomClip.newsclip)
         {
            this.bottomClip.hideNewsTipDelay();
         }
         else if(event != null && this.topMiddleClip.effectName == event.currentTarget)
         {
            this.topMiddleClip.hideEffect();
         }
         else
         {
            this.hidetip();
         }
      }
      
      public function hidetip() : void
      {
         if(this.bottomClip && this.bottomClip.friendApplyTips && this.bottomClip.friendApplyTips.visible)
         {
            this.bottomClip.hideFriendApplyTips();
         }
         this.checkIsInActiveTime();
      }
      
      public function showNewEmail(counts:int = 0) : void
      {
         if(counts > 0)
         {
            this.bottomClip.setNewEmail(2);
         }
         else
         {
            this.bottomClip.setNewEmail(1);
         }
      }
      
      private function onClickChatClipBtn(event:MouseEvent) : void
      {
         var tx:int = 0;
         var ty:int = 0;
         if(MovieClip(this.bottomClip.chatClipBtn).currentFrame == 1)
         {
            MovieClip(this.bottomClip.chatClipBtn).gotoAndStop(2);
            this.bottomClip.chatClipBtn.mouseEnabled = false;
            this.bottomClip.chatClipBtn.mouseChildren = false;
            tx = this.bottomClip.statePanel_mc.x;
            ty = this.bottomClip.statePanel_mc.y - 250;
            Tweener.addTween(this.bottomClip.chatClipBtn,{
               "x":this.bottomClip.chatClipBtn.x,
               "y":this.bottomClip.chatClipBtn.y - 192,
               "time":0.5,
               "transition":"easeInOutBack"
            });
            Tweener.addTween(this.bottomClip.statePanel_mc,{
               "scaleX":1,
               "scaleY":1,
               "x":tx,
               "y":ty,
               "time":0.4,
               "transition":"easeInOutBack",
               "onComplete":this.afterInOutHandler
            });
         }
         else if(MovieClip(this.bottomClip.chatClipBtn).currentFrame == 2)
         {
            MovieClip(this.bottomClip.chatClipBtn).gotoAndStop(1);
            this.bottomClip.chatClipBtn.mouseEnabled = false;
            this.bottomClip.chatClipBtn.mouseChildren = false;
            tx = this.bottomClip.statePanel_mc.x;
            ty = this.bottomClip.statePanel_mc.y + 250;
            Tweener.addTween(this.bottomClip.chatClipBtn,{
               "x":this.bottomClip.chatClipBtn.x,
               "y":this.bottomClip.chatClipBtn.y + 192,
               "time":0.5,
               "transition":"easeInOutBack"
            });
            Tweener.addTween(this.bottomClip.statePanel_mc,{
               "scaleX":1,
               "scaleY":1,
               "x":tx,
               "y":ty,
               "time":0.4,
               "transition":"easeInOutBack",
               "onComplete":this.afterInOutHandler
            });
         }
      }
      
      private function afterInOutHandler() : void
      {
         this.bottomClip.statePanel_mc.visible = !this.bottomClip.statePanel_mc.visible;
         this.bottomClip.chatClipBtn.mouseChildren = true;
         this.bottomClip.chatClipBtn.mouseEnabled = true;
      }
      
      private function onMouseDownTopClick(evt:MouseEvent) : void
      {
         var item:Object = evt.target as Object;
         if(getTimer() - this.st < 1000 && this.sn == String(item.name))
         {
            return;
         }
         this.st = getTimer();
         this.sn = String(item.name);
         evt.stopImmediatePropagation();
         if(evt.currentTarget["mouseEnabled"] == false)
         {
            return;
         }
         this.dispatchEvent(new InterfaceEvent(InterfaceEvent.FACECLIPCLICK,{
            "code":this.sn,
            "msg":this.bottomClip.msgTxt.text
         }));
      }
      
      private function onMouseDown(evt:MouseEvent) : void
      {
         var tar:TopButton = null;
         if(getTimer() - this.st < 1000 && this.sn == String(evt.currentTarget.name))
         {
            return;
         }
         this.st = getTimer();
         this.sn = String(evt.currentTarget.name);
         evt.stopImmediatePropagation();
         if(evt.currentTarget["mouseEnabled"] == false)
         {
            return;
         }
         if(CacheData.instance.uiEffectDic[this.sn] != null && !CacheData.instance.uiEffectDic[this.sn])
         {
            CacheData.instance.uiEffectDic[this.sn] = true;
            ButtonEffectUtil.delEffect(this.getTopButton(this.sn));
         }
         var data:Object = {
            "code":this.sn,
            "msg":this.bottomClip.msgTxt.text
         };
         if(evt.currentTarget is TopButton)
         {
            tar = evt.currentTarget as TopButton;
            if(tar.jump != null && tar.jump != "")
            {
               data["jump"] = tar.jump;
            }
            if(Boolean(tar.targetScene) && tar.targetScene > 0)
            {
               data["targetScene"] = tar.targetScene;
            }
         }
         this.dispatchEvent(new InterfaceEvent(InterfaceEvent.FACECLIPCLICK,data));
      }
      
      private function onKeyDown(evt:KeyboardEvent) : void
      {
         evt.stopImmediatePropagation();
         if(evt.keyCode == 13)
         {
            this.dispatchEvent(new InterfaceEvent(InterfaceEvent.FACECLIPCLICK,{
               "code":"sendBtn",
               "msg":this.bottomClip.msgTxt.text
            }));
         }
         else if(evt.keyCode == Keyboard.UP)
         {
            if(this.chatList.length > 0 && this.chatIndex > 0)
            {
               this.chatIndex = this.chatIndex == 0 ? this.chatIndex : this.chatIndex - 1;
               this.bottomClip.msgTxt.text = "" + this.chatList[this.chatIndex];
            }
         }
         else if(evt.keyCode == Keyboard.DOWN)
         {
            if(this.chatList.length > 1 && this.chatIndex < this.chatList.length - 1)
            {
               this.chatIndex = this.chatIndex == this.chatList.length - 1 ? this.chatList.length - 1 : this.chatIndex + 1;
               this.bottomClip.msgTxt.text = "" + this.chatList[this.chatIndex];
            }
         }
      }
      
      public function sendChatMsg() : void
      {
         if(this.chatList.length >= 5)
         {
            this.chatList.shift();
         }
         this.chatList.push(this.bottomClip.msgTxt.text);
         this.chatIndex = this.chatList.length;
         this.bottomClip.msgTxt.text = "";
      }
      
      public function showOrHidePlayer() : void
      {
         var frame:int = this.topMiddleClip.clearClip.currentFrame == 1 ? 2 : 1;
         this.topMiddleClip.clearClip.gotoAndStop(frame);
      }
      
      private function onFaceClick(evt:InterfaceEvent) : void
      {
         this.dispatchEvent(new InterfaceEvent(InterfaceEvent.FACESEND,evt.params));
      }
      
      public function hideBottom() : void
      {
         SimpleTweener.instance.addTweener(this.bottomClip,800,false);
      }
      
      public function showBottom() : void
      {
         SimpleTweener.instance.addTweener(this.bottomClip,520,true);
      }
      
      public function setEffectList(params:Array, open:Boolean = false) : void
      {
         this.middleClip.setDataList(params,open);
      }
      
      public function setEffectTip(name:String, tips:String = "") : void
      {
         this.topMiddleClip.setMsgEffect(name,tips);
      }
      
      private function onEffectRollOver(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         this.topMiddleClip.showEffect();
      }
      
      private function onEffectRollOut(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         this.topMiddleClip.hideEffect();
      }
      
      public function updataTips(tipName:String, updateStr:String) : void
      {
         var tipObj:Object = this._topClip.getTipByName(tipName);
         if(tipObj != null)
         {
            tipObj.tips = updateStr;
         }
      }
   }
}

