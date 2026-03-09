package com.publiccomponent.ui
{
   import com.game.util.HtmlUtil;
   import com.publiccomponent.tips.MainUIToolTip;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class BottomClip extends Sprite
   {
      
      public var bigMapBtn:SimpleButton;
      
      public var areamapbtn:SimpleButton;
      
      public var quickBtn:SimpleButton;
      
      public var faceBtn:SimpleButton;
      
      public var actionBtn:SimpleButton;
      
      public var magicBtn:SimpleButton;
      
      public var msgTxt:TextField;
      
      public var sendBtn:SimpleButton;
      
      public var chatClipBtn:MovieClip;
      
      public var statePanel_mc:MovieClip;
      
      public var familyBtn:SimpleButton;
      
      public var familyBtn1:SimpleButton;
      
      public var familyBtn2:SimpleButton;
      
      public var btnCreateFamily:SimpleButton;
      
      public var familyBtn3:SimpleButton;
      
      public var familyClip3:SimpleButton;
      
      public var familyFilesBtn:SimpleButton;
      
      public var fincaBtn:SimpleButton;
      
      public var packBtn:SimpleButton;
      
      public var friendClikBtn:SimpleButton;
      
      public var teamBtn:SimpleButton;
      
      public var friendClick:MovieClip;
      
      public var friendApplyTips:MovieClip;
      
      public var petBtn:SimpleButton;
      
      public var houseBtn:SimpleButton;
      
      public var bottomMask:MovieClip;
      
      private var tid:int;
      
      private var leftTime:int;
      
      public var fTip:MovieClip;
      
      public var fTip2:MovieClip;
      
      private var tid2:int;
      
      private var tid4:int;
      
      public var systemBtn:SimpleButton;
      
      public var systemClip:MovieClip;
      
      public var chatClip:MovieClip;
      
      public var homebtn:SimpleButton;
      
      public var shenshoubtn:SimpleButton;
      
      public var newsclip:MovieClip;
      
      public var shopBtn:MovieClip;
      
      private var chatList:ChatList;
      
      public var mentorBtn:SimpleButton;
      
      public var newMsgClip:MovieClip;
      
      public var packTipClip:MovieClip;
      
      public var btnPer:SimpleButton;
      
      public var bottomList:Dictionary = new Dictionary();
      
      public var mcclip:MovieClip;
      
      private var onlineLength:int;
      
      private var f:ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0]);
      
      private var tempcount:int = 0;
      
      private var GameData:* = getDefinitionByName("com.game.locators.GameData");
      
      private var PhpConnection:* = getDefinitionByName("phpcon.PhpConnection");
      
      private var msgCount:int = 0;
      
      private var msgTid:int = 0;
      
      private var shopTid:int;
      
      private var firendTid:int = 0;
      
      public function BottomClip()
      {
         super();
      }
      
      public function init(clip:MovieClip, dataList:Array) : void
      {
         this.initTips(clip,dataList);
         clip.cacheAsBitmap = true;
         this.mcclip = clip;
         this.addChild(clip);
         this.chatClipBtn = clip.chatClipBtn;
         this.sendBtn = clip.sendBtn;
         this.msgTxt = clip.msgTxt;
         this.bigMapBtn = clip.bigMapBtn;
         this.areamapbtn = clip.areamapbtn;
         this.quickBtn = clip.quickBtn;
         this.faceBtn = clip.faceBtn;
         this.actionBtn = clip.actionBtn;
         this.magicBtn = clip.magicBtn;
         this.familyBtn = clip.familyBtn;
         this.familyBtn1 = clip.familyBtn1;
         this.familyBtn2 = clip.familyBtn2;
         this.btnCreateFamily = clip.btnCreateFamily;
         this.familyFilesBtn = clip.familyFilesBtn;
         this.familyClip3 = clip.familyClip3;
         this.familyBtn3 = clip.familyBtn3;
         this.packBtn = clip.packBtn;
         this.packTipClip = clip.packTip;
         this.packTipClip.visible = false;
         this.friendClick = clip.friendClick;
         this.friendClick.buttonMode = true;
         this.friendClick.gotoAndStop(1);
         this.friendClikBtn = clip.friendClikBtn;
         this.friendClikBtn.visible = false;
         this.fincaBtn = clip.fincaBtn;
         this.mentorBtn = clip.mentorBtn;
         this.mentorBtn.visible = false;
         this.btnPer = clip.btnPer;
         this.btnPer.visible = false;
         if(Boolean(clip.hasOwnProperty("teamBtn")) && Boolean(clip.teamBtn))
         {
            this.teamBtn = clip.teamBtn;
            this.teamBtn.visible = false;
         }
         else
         {
            this.friendClikBtn.visible = true;
         }
         this.petBtn = clip.petBtn;
         this.houseBtn = clip.houseBtn;
         this.bottomMask = clip.bottomMask;
         this.bottomMask.visible = false;
         this.fTip = clip.fTip;
         this.fTip.visible = false;
         this.fTip2 = clip.fTip2;
         this.fTip2.visible = false;
         this.systemBtn = clip.systemBtn;
         this.systemClip = clip.systemClip;
         this.statePanel_mc = clip.statePanel_mc;
         this.systemClip.visible = false;
         this.chatClip = clip.chatClip;
         this.chatClip.gotoAndStop(1);
         this.chatClip.visible = false;
         this.homebtn = clip.homebtn;
         this.shenshoubtn = clip.shenshoubtn;
         this.newsclip = clip.newsclip;
         this.newsclip.buttonMode = true;
         this.newsclip.gotoAndStop(1);
         this.newsclip.emailClip.visible = false;
         this.shopBtn = clip.shopBtn;
         this.shopBtn.gotoAndStop(2);
         this.friendApplyTips = clip.tipsMc;
         this.friendApplyTips.mouseChildren = false;
         this.friendApplyTips.buttonMode = true;
         this.newMsgClip = clip.newMsgClip;
         this.newMsgClip.mouseChildren = false;
         this.newMsgClip.buttonMode = true;
         (this.newMsgClip.msgTxt as TextField).mouseEnabled = false;
         this.chatList = new ChatList(clip.chatlistMC);
         this.chatList.hide();
         this.msgTxt.restrict = "A-Za-z0-9一-龥…，。、！？《》；：“”";
         this.msgTxt.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.hideJoinFamily();
         this.hideFamilyBase();
         this.hideFamilyMsg();
         this.setOnlineNumTxt(0);
         this.hideNewsTipApply();
         this.setNewsTipApply(0);
         this.hideHouse();
      }
      
      private function onClickHandler(event:MouseEvent) : void
      {
         this.msgTxt.text = "";
      }
      
      private function initTips(clip:MovieClip, dataList:Array) : void
      {
         var data:Array = null;
         var len:int = int(dataList.length);
         var name:String = "";
         for(var i:int = 0; i < len; i++)
         {
            data = [];
            name = dataList[i].name;
            if(dataList[i].type == 1)
            {
               if(Boolean(clip[name]))
               {
                  this.bottomList[name] = {
                     "item":clip[name],
                     "showPhares":dataList[i].showPhares,
                     "tips":dataList[i].desc
                  };
               }
               if(dataList[i].desc != "" && Boolean(clip[name]))
               {
                  MainUIToolTip.showTips(clip[name],dataList[i].desc,4,1);
               }
            }
            else
            {
               if(Boolean(clip.systemClip[name]))
               {
                  this.bottomList[name] = {
                     "item":clip.systemClip[name],
                     "showPhares":dataList[i].showPhares,
                     "tips":dataList[i].desc
                  };
               }
               if(dataList[i].desc != "" && Boolean(clip.systemClip[name]))
               {
                  MainUIToolTip.showTips(clip.systemClip[name],dataList[i].desc,4,1);
               }
            }
         }
      }
      
      public function showFriend() : void
      {
         this.friendClikBtn.visible = true;
         this.teamBtn.visible = true;
         this.mentorBtn.visible = true;
         this.btnPer.visible = true;
      }
      
      public function hideFriend() : void
      {
         this.friendClikBtn.visible = false;
         this.teamBtn.visible = false;
         this.mentorBtn.visible = false;
         this.btnPer.visible = false;
      }
      
      public function setNewsclipState(bool:Boolean) : void
      {
         if(this.msgCount > 0)
         {
            if(this.GameData.instance.playerData.isNewHand >= 6)
            {
               this.newsclip.gotoAndStop(2);
            }
         }
         else if(bool)
         {
            if(this.onlineLength > 0)
            {
               if(this.GameData.instance.playerData.isNewHand >= 6)
               {
                  this.newsclip.gotoAndStop(2);
               }
            }
            else
            {
               this.newsclip.gotoAndStop(1);
            }
         }
         else
         {
            this.newsclip.gotoAndStop(1);
         }
      }
      
      public function setOnlineNumTxt($count:int) : void
      {
         this.onlineLength = $count;
         var len:int = $count + this.msgCount;
         if(len > 0)
         {
            this.newsclip.numClip.visible = true;
            this.newsclip.numClip.numTxt.text = this.msgCount + $count + "";
            this.haveNews();
         }
         else
         {
            this.newsclip.numClip.visible = false;
            this.newsclip.numClip.numTxt.text = 0 + "";
            this.noNews();
         }
      }
      
      public function haveNews() : void
      {
         if(Boolean(this.newsclip) && this.GameData.instance.playerData.isNewHand >= 9)
         {
            if(this.msgCount > 0)
            {
               this.newsclip.gotoAndStop(2);
            }
            else
            {
               this.newsclip.gotoAndStop(1);
            }
         }
      }
      
      public function noNews() : void
      {
         if(Boolean(this.newsclip))
         {
            this.newsclip.gotoAndStop(1);
         }
      }
      
      public function showJoinFamily() : void
      {
         this.btnCreateFamily.visible = this.familyBtn1.visible = true;
         this.btnCreateFamily.mouseEnabled = this.familyBtn1.mouseEnabled = true;
      }
      
      public function hideJoinFamily() : void
      {
         this.btnCreateFamily.visible = this.familyBtn1.visible = false;
         this.btnCreateFamily.mouseEnabled = this.familyBtn1.mouseEnabled = false;
      }
      
      public function showFamilyBase() : void
      {
         this.familyBtn2.visible = true;
         this.familyBtn2.mouseEnabled = true;
         this.familyFilesBtn.visible = true;
         this.familyFilesBtn.mouseEnabled = true;
      }
      
      public function hideFamilyBase() : void
      {
         this.familyBtn2.visible = false;
         this.familyBtn2.mouseEnabled = false;
         this.familyFilesBtn.visible = false;
         this.familyFilesBtn.mouseEnabled = false;
      }
      
      public function showHouse() : void
      {
         this.homebtn.visible = true;
         this.shenshoubtn.visible = true;
         this.fincaBtn.visible = true;
      }
      
      public function hideHouse() : void
      {
         this.homebtn.visible = false;
         this.shenshoubtn.visible = false;
         this.fincaBtn.visible = false;
      }
      
      public function showFamilyMsg() : void
      {
         clearInterval(this.tid4);
         this.tid4 = setInterval(this.loopTip,500);
         this.familyBtn3.visible = true;
         this.familyBtn3.mouseEnabled = true;
         this.familyClip3.visible = true;
      }
      
      public function hideFamilyMsg() : void
      {
         clearInterval(this.tid4);
         this.familyBtn3.visible = false;
         this.familyBtn3.mouseEnabled = false;
         this.familyClip3.visible = false;
      }
      
      private function loopTip() : void
      {
         this.familyClip3.visible = this.familyClip3.visible == true ? false : true;
      }
      
      public function disableUIByName(uiName:String) : void
      {
         if(Boolean(this.hasOwnProperty(uiName)) && this[uiName] != null)
         {
            if(Boolean(this[uiName].hasOwnProperty("currentFrame")))
            {
               this[uiName]["mouseEnabled"] = false;
               this[uiName]["gotoAndStop"](2);
               this[uiName]["filters"] = [this.f];
            }
            else
            {
               this[uiName]["filters"] = [this.f];
               this[uiName]["mouseEnabled"] = false;
            }
         }
      }
      
      public function enableUIByName(uiName:String) : void
      {
         if(Boolean(this.hasOwnProperty(uiName)) && this[uiName] != null)
         {
            if(Boolean(this[uiName].hasOwnProperty("currentFrame")))
            {
               this[uiName]["mouseEnabled"] = true;
               this[uiName]["gotoAndStop"](1);
               this[uiName]["filters"] = null;
            }
            else
            {
               this[uiName]["filters"] = null;
               this[uiName]["mouseEnabled"] = true;
            }
         }
      }
      
      public function hideUIByName(uiName:String) : void
      {
         if(Boolean(this.hasOwnProperty(uiName)) && this[uiName] != null)
         {
            this[uiName]["visible"] = false;
         }
      }
      
      public function showUIByName(uiName:String) : void
      {
         if(Boolean(this.hasOwnProperty(uiName)) && this[uiName] != null)
         {
            this[uiName]["visible"] = true;
         }
      }
      
      public function showMsgTip() : void
      {
         this.fTip.visible = true;
         clearInterval(this.tid2);
         this.tid2 = setInterval(this.showOrHide,500);
      }
      
      private function showOrHide() : void
      {
      }
      
      public function stopMsgTip() : void
      {
         this.fTip.visible = false;
         clearInterval(this.tid2);
      }
      
      public function enableMask() : void
      {
         this.bottomMask.visible = true;
      }
      
      public function disableMask() : void
      {
         this.bottomMask.visible = false;
      }
      
      public function showTime(state:int) : void
      {
         clearInterval(this.tid);
         this.leftTime = state;
         this.tid = setInterval(this.loopDuce,1000);
      }
      
      public function stopTime() : void
      {
         clearInterval(this.tid);
      }
      
      private function loopDuce() : void
      {
         --this.GameData.instance.playerData.playerSurplus;
         ++this.GameData.instance.playerData.systemTimes;
         ++this.tempcount;
         if(this.tempcount >= 60)
         {
            this.tempcount = 0;
            --this.GameData.instance.playerData.doubleExpTimes;
            if(this.GameData.instance.playerData.doubleExpTimes >= 0 && ExternalInterface.available)
            {
               ExternalInterface.call("taskStateFunction",int(this.GameData.instance.playerData.doubleExpTimes),-1,-1,-1,-1);
            }
         }
         this.GameData.instance.playerData.onlineTime += 1;
         if(this.GameData.instance.playerData.onlineTime == 1800)
         {
            if(Boolean(this.PhpConnection.instance().hasOwnProperty("loginScore")))
            {
               this.PhpConnection.instance()["loginScore"]("30min");
            }
         }
      }
      
      public function addChatFriend(friend:Object) : void
      {
         this.chatList.show();
         this.chatList.addFriend(friend);
      }
      
      public function delChatFriend(friend:Object) : void
      {
         this.chatList.delFriend(friend);
      }
      
      public function addChatFriendDress(dress:Object = null) : void
      {
         this.chatList.addFriendDress(dress);
      }
      
      public function stopShakeFriend(uid:int) : void
      {
         this.chatList.stopShakeFriend(uid);
      }
      
      public function hasChatDress(uid:int) : Boolean
      {
         return this.chatList.getDressById(uid) != null;
      }
      
      public function onMallActivityBack(params:Object) : void
      {
         if(params.result == 0)
         {
            if(params.step > 3)
            {
               clearTimeout(this.shopTid);
               this.shopTid = 0;
               this.shopBtn.gotoAndStop(1);
            }
            else if(params.time <= 0)
            {
               clearTimeout(this.shopTid);
               this.shopTid = 0;
               this.shopBtn.gotoAndStop(2);
            }
            else
            {
               this.shopBtn.gotoAndStop(1);
               clearTimeout(this.shopTid);
               this.shopTid = setTimeout(this.shopTimeOutHandler,params.time * 1000);
            }
         }
         else
         {
            clearTimeout(this.shopTid);
            this.shopTid = 0;
            this.shopBtn.gotoAndStop(1);
         }
      }
      
      public function setNewsTipApply($count:int) : void
      {
         this.newMsgClip.msgTxt.htmlText = "你有" + HtmlUtil.getHtmlText(14,"#CC0000",$count + "") + "条系统消息哦！";
         this.msgCount = $count;
         this.setOnlineNumTxt(this.onlineLength);
      }
      
      public function showNewsTipApply() : void
      {
         this.clearTimeOut();
         if(this.msgCount > 0)
         {
            this.mcclip.addChild(this.newMsgClip);
         }
         else
         {
            this.hideNewsTipApply();
         }
      }
      
      private function clearTimeOut() : void
      {
         if(this.msgCount != -1)
         {
            clearTimeout(this.msgTid);
            this.msgTid = -1;
         }
      }
      
      public function hideNewsTipApply() : void
      {
         this.clearTimeOut();
         if(this.mcclip.contains(this.newMsgClip))
         {
            this.mcclip.removeChild(this.newMsgClip);
         }
      }
      
      public function hideNewsTipDelay() : void
      {
         this.clearTimeOut();
         this.msgTid = setTimeout(this.hideNewsTipApply,500);
      }
      
      private function shopTimeOutHandler() : void
      {
         clearTimeout(this.shopTid);
         this.shopTid = 0;
         this.shopBtn.gotoAndStop(2);
      }
      
      public function showFriendApplyTips(msg:String = null) : void
      {
         if(msg != null)
         {
            this.friendApplyTips.msgTxt.text = msg;
         }
         this.friendApplyTips.visible = true;
         if(this.firendTid != 0)
         {
            clearTimeout(this.firendTid);
         }
      }
      
      public function setFriendClickType(type:int) : void
      {
         if(type == 2)
         {
            this.friendClick.gotoAndStop(2);
         }
         else
         {
            this.friendClick.gotoAndStop(1);
         }
      }
      
      public function hideFriendApplyTipsDelay() : void
      {
         if(this.firendTid != 0)
         {
            clearTimeout(this.firendTid);
            this.firendTid = 0;
         }
         this.firendTid = setTimeout(this.hideFriendApplyTips,1000);
      }
      
      public function hideFriendApplyTips() : void
      {
         this.friendApplyTips.visible = false;
         if(this.firendTid != 0)
         {
            clearTimeout(this.firendTid);
            this.firendTid = 0;
         }
      }
      
      public function setNewEmail(type:int) : void
      {
         if(type == 2)
         {
            this.newsclip.emailClip.visible = true;
            this.newsclip.emailClip.gotoAndPlay(1);
         }
         else
         {
            this.newsclip.emailClip.visible = false;
         }
      }
      
      private function onEmailNewClipStop() : void
      {
         var interval:uint = 0;
         if(Boolean(this.newsclip.emailClip))
         {
            this.newsclip.emailClip.visible = false;
            this.newsclip.emailClip.gotoAndStop(1);
            interval = setInterval(function():void
            {
               newsclip.emailClip.gotoAndPlay(1);
               newsclip.emailClip.addFrameScript(newsclip.emailClip.totalFrames - 1,onEmailNewClipStop);
               newsclip.emailClip.visible = true;
               clearInterval(interval);
            },300000);
         }
      }
      
      public function setPackTip(type:int) : void
      {
         O.o("============设置背包提示是=============",type);
         if(type == 1 || type == 2)
         {
            this.packTipClip.visible = true;
            this.packTipClip.tips1.visible = false;
            this.packTipClip.tips2.visible = false;
            this.packTipClip.gotoAndPlay(1);
            if(type == 1)
            {
               this.packTipClip.tips1.visible = true;
               this.packTipClip.tips2.visible = false;
               this.packTipClip.tips1.addFrameScript(this.packTipClip.tips1.totalFrames - 1,null);
               this.packTipClip.tips1.addFrameScript(this.packTipClip.tips1.totalFrames - 1,this.onPackClipStop);
            }
            else
            {
               this.packTipClip.tips1.visible = false;
               this.packTipClip.tips2.visible = true;
               this.packTipClip.tips2.addFrameScript(this.packTipClip.tips2.totalFrames - 1,null);
               this.packTipClip.tips2.addFrameScript(this.packTipClip.tips2.totalFrames - 1,this.onPackClipStop);
            }
         }
         else
         {
            this.packTipClip.visible = false;
            this.packTipClip.gotoAndPlay(1);
            this.packTipClip.tips1.addFrameScript(this.packTipClip.tips1.totalFrames - 1,null);
            this.packTipClip.tips2.addFrameScript(this.packTipClip.tips2.totalFrames - 1,null);
         }
      }
      
      private function onPackClipStop() : void
      {
         if(Boolean(this.packTipClip.tips1))
         {
            this.packTipClip.tips1.gotoAndStop(1);
            this.packTipClip.visible = false;
         }
         if(Boolean(this.packTipClip.tips2))
         {
            this.packTipClip.visible = false;
            this.packTipClip.tips2.gotoAndStop(1);
         }
      }
   }
}

