package com.game.modules.view.chat
{
   import com.core.observer.MessageEvent;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.modules.control.chat.MutilChatControl;
   import com.game.modules.view.family.FamilyBadge;
   import com.game.util.ChatUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.MaterialLib;
   import com.publiccomponent.smile.SmileView;
   import com.publiccomponent.ui.ToolTip;
   import fl.controls.List;
   import fl.data.DataProvider;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.getTimer;
   
   public class MutilChatView extends HLoaderSprite
   {
      
      public static const SENDMUTIMSG:String = "sendmutimsg";
      
      public static const EDITNOTIC:String = "editnotice";
      
      private var mutilClip:MovieClip;
      
      private var uiScroll:List;
      
      private var output:ChatTextField;
      
      private var input:TextField;
      
      private var smile:SmileView;
      
      private var familyInfo:Object;
      
      private var memberList:Array = [];
      
      private var dp:DataProvider;
      
      private var upBtn:SimpleButton;
      
      private var downBtn:SimpleButton;
      
      private var scrollBtn:MovieClip;
      
      private var scroll_bg_mc:MovieClip;
      
      private var lastClickTime:Number = 0;
      
      private var badge:FamilyBadge;
      
      public function MutilChatView()
      {
         GreenLoading.loading.visible = true;
         super();
         this.url = "assets/material/mutichat.swf";
      }
      
      override public function setShow() : void
      {
         GreenLoading.loading.visible = false;
         this.mutilClip = this.bg["getChildAt"](0);
         this.mutilClip.cacheAsBitmap = true;
         this.mutilClip.editClip.gotoAndStop(1);
         this.mutilClip.forbidClip.gotoAndStop(1);
         this.mutilClip.editClip.visible = false;
         this.output = new ChatTextField(270,190);
         this.output.x = 242;
         this.output.y = 150;
         addChild(this.output);
         this.input = new TextField();
         this.input.maxChars = 50;
         this.input.x = 240;
         this.input.y = 389;
         this.input.width = 275;
         this.input.height = 56;
         this.input.wordWrap = true;
         this.input.type = TextFieldType.INPUT;
         addChild(this.input);
         this.smile = new SmileView(323,300);
         this.smile.visible = false;
         addChild(this.smile);
         this.uiScroll = new List();
         this.uiScroll.mouseEnabled = false;
         this.uiScroll.mouseChildren = true;
         this.uiScroll.x = 539;
         this.uiScroll.y = 238;
         this.uiScroll.setStyle("cellRenderer",MutilChatItem);
         this.addChild(this.uiScroll);
         this.dp = new DataProvider();
         this.addEvent();
         this.initStyle();
         this.initScrollStyle();
         ToolTip.setDOInfo(this.mutilClip.dragClip,"拖动界面");
         ApplicationFacade.getInstance().registerViewLogic(new MutilChatControl(this));
      }
      
      private function initCacheMsg() : void
      {
         var body:Object = null;
         while(GameData.instance.playerData.familyMsgCache.length > 0)
         {
            body = GameData.instance.playerData.familyMsgCache.shift();
            this.output.appendMessage("",body.userName,"",0,body.msg,false);
         }
      }
      
      private function initScrollStyle() : void
      {
         this.upBtn = MaterialLib.getInstance().getMaterial("archupbtn") as SimpleButton;
         this.uiScroll.setStyle("upArrowDisabledSkin",this.upBtn);
         this.uiScroll.setStyle("upArrowDownSkin",this.upBtn);
         this.uiScroll.setStyle("upArrowOverSkin",this.upBtn);
         this.uiScroll.setStyle("upArrowUpSkin",this.upBtn);
         this.downBtn = MaterialLib.getInstance().getMaterial("archdownbtn") as SimpleButton;
         this.uiScroll.setStyle("downArrowDisabledSkin",this.downBtn);
         this.uiScroll.setStyle("downArrowDownSkin",this.downBtn);
         this.uiScroll.setStyle("downArrowOverSkin",this.downBtn);
         this.uiScroll.setStyle("downArrowUpSkin",this.downBtn);
         this.scrollBtn = MaterialLib.getInstance().getMaterial("archscrollbtn") as MovieClip;
         this.uiScroll.setStyle("thumbIcon",this.scrollBtn);
         this.uiScroll.setStyle("thumbUpSkin",this.scrollBtn);
         this.uiScroll.setStyle("thumbOverSkin",this.scrollBtn);
         this.uiScroll.setStyle("thumbDownSkin",this.scrollBtn);
         this.uiScroll.setStyle("thumbDisabledSkin",this.scrollBtn);
         this.scroll_bg_mc = MaterialLib.getInstance().getMaterial("archscbg") as MovieClip;
         this.uiScroll.setStyle("trackUpSkin",this.scroll_bg_mc);
         this.uiScroll.setStyle("trackDisabledSkin",this.scroll_bg_mc);
         this.uiScroll.setStyle("trackDownSkin",this.scroll_bg_mc);
         this.uiScroll.setStyle("trackOverSkin",this.scroll_bg_mc);
         this.uiScroll.setStyle("skin",new Shape());
         this.uiScroll.setStyle("contentPadding",5);
         this.uiScroll.invalidateList();
      }
      
      private function addEvent() : void
      {
         EventManager.attachEvent(this.mutilClip.sendBtn,MouseEvent.MOUSE_DOWN,this.sendMsg);
         EventManager.attachEvent(this.mutilClip.forbidClip,MouseEvent.MOUSE_DOWN,this.forbidReciveMsg);
         EventManager.attachEvent(this.mutilClip.closeBtn,MouseEvent.MOUSE_DOWN,this.closeWindow);
         EventManager.attachEvent(this.mutilClip.editClip,MouseEvent.MOUSE_DOWN,this.editNotic);
         EventManager.attachEvent(this.mutilClip.dragClip,MouseEvent.MOUSE_DOWN,this.startDragView);
         EventManager.attachEvent(this.mutilClip.faceBtn,MouseEvent.MOUSE_DOWN,this.openFaceView);
         EventManager.attachEvent(this.input,FocusEvent.FOCUS_IN,this.inputFocusIn);
         EventManager.attachEvent(this.smile,ItemClickEvent.ITEMCLICKEVENT,this.onClickSmile);
         EventManager.attachEvent(stage,MouseEvent.MOUSE_UP,this.stopDragView);
      }
      
      private function removeEvent() : void
      {
         EventManager.removeEvent(this.mutilClip.sendBtn,MouseEvent.MOUSE_DOWN,this.sendMsg);
         EventManager.removeEvent(this.mutilClip.forbidClip,MouseEvent.MOUSE_DOWN,this.forbidReciveMsg);
         EventManager.removeEvent(this.mutilClip.closeBtn,MouseEvent.MOUSE_DOWN,this.closeWindow);
         EventManager.removeEvent(this.mutilClip.editClip,MouseEvent.MOUSE_DOWN,this.editNotic);
         EventManager.removeEvent(this.mutilClip.dragClip,MouseEvent.MOUSE_DOWN,this.startDragView);
         EventManager.removeEvent(this.mutilClip.faceBtn,MouseEvent.MOUSE_DOWN,this.openFaceView);
         EventManager.removeEvent(this.input,FocusEvent.FOCUS_IN,this.inputFocusIn);
         EventManager.removeEvent(this.input,KeyboardEvent.KEY_DOWN,this.onKeyDown);
         EventManager.removeEvent(this.smile,ItemClickEvent.ITEMCLICKEVENT,this.onClickSmile);
         EventManager.removeEvent(stage,MouseEvent.MOUSE_UP,this.stopDragView);
      }
      
      override public function disport() : void
      {
         GameData.instance.playerData.familyisOpen = false;
         if(Boolean(this.badge) && this.contains(this.badge))
         {
            this.badge.dispos();
            this.badge = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function closeWindow(evt:Event) : void
      {
         this.disport();
      }
      
      private function initStyle() : void
      {
         this.output.initStyle(MaterialLib.getInstance().getMaterial("archupbtn"),MaterialLib.getInstance().getMaterial("archdownbtn"),MaterialLib.getInstance().getMaterial("archscrollbtn"),MaterialLib.getInstance().getMaterial("archscbg"));
      }
      
      private function sendMsg(evt:MouseEvent) : void
      {
         var msg:String = this.input.text;
         var tempClickTime:Number = getTimer();
         if(tempClickTime - this.lastClickTime < 500)
         {
            this.lastClickTime = tempClickTime;
            this.output.appendMessage("","你发送的太快了!","",0,"",true);
            return;
         }
         if(msg.length == 0)
         {
            this.output.appendMessage("","不能发送空信息!","",0,"",true);
            return;
         }
         if(ChatUtil.isOpenChat())
         {
            this.lastClickTime = tempClickTime;
            ChatUtil.onCompanyCheck(msg,this.onCheckMutiMsg);
         }
      }
      
      private function onCheckMutiMsg(con:String, other:Object) : void
      {
         dispatchEvent(new MessageEvent(SENDMUTIMSG,{
            "id":GlobalConfig.userId,
            "name":GameData.instance.playerData.userName,
            "msg":con
         }));
         this.output.appendMessage("",GameData.instance.playerData.userName,"",0,con,true);
         this.input.text = "";
      }
      
      private function editNotic(evt:MouseEvent) : void
      {
         if(this.mutilClip.editClip.currentFrame == 1)
         {
            this.mutilClip.noticeTxt.type = TextFieldType.INPUT;
            stage.focus = this.mutilClip.noticeTxt;
            this.mutilClip.editClip.gotoAndStop(2);
         }
         else if(ChatUtil.isOpenChange())
         {
            ChatUtil.onCompanyCheck(this.mutilClip.noticeTxt.text,this.onCheckNotice);
         }
      }
      
      private function onCheckNotice(con:String, other:Object) : void
      {
         this.mutilClip.editClip.gotoAndStop(1);
         dispatchEvent(new MessageEvent(EDITNOTIC,con));
         this.mutilClip.noticeTxt.type = TextFieldType.DYNAMIC;
         this.mutilClip.noticeTxt.text = con;
      }
      
      private function startDragView(evt:MouseEvent) : void
      {
         this.stopDrag();
         this.startDrag();
      }
      
      private function stopDragView(evt:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      private function openFaceView(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         var result:Boolean = this.smile.visible == true ? false : true;
         this.smile.visible = result;
      }
      
      private function onClickSmile(evt:ItemClickEvent) : void
      {
         var code:int = int(evt.params);
         if(code < 10)
         {
            this.input.appendText("/:0" + code);
         }
         else
         {
            this.input.appendText("/:" + code);
         }
         this.input.setSelection(this.input.length,this.input.length);
      }
      
      public function initFamilyInfo(obj:Object) : void
      {
         if(!GameData.instance.playerData.family_msg_forbid)
         {
            this.mutilClip.forbidClip.gotoAndStop(1);
         }
         else
         {
            this.mutilClip.forbidClip.gotoAndStop(2);
         }
         GameData.instance.playerData.familyisOpen = true;
         this.initCacheMsg();
         this.familyInfo = obj;
         this.mutilClip.tipTxt.text = "你正在 " + obj.f_name + " 家族聊天中";
         this.mutilClip.noticeTxt.text = obj.notice + "";
         this.setBadge(obj);
         if(obj.f_leaderId == GlobalConfig.userId)
         {
            this.mutilClip.editClip.visible = true;
         }
      }
      
      public function initFamilyMemberList(memberList:Array) : void
      {
         this.memberList = memberList;
         this.sort();
      }
      
      private function forbidReciveMsg(evt:MouseEvent) : void
      {
         var forbidValue:Boolean = GameData.instance.playerData.family_msg_forbid;
         if(GameData.instance.playerData.family_msg_forbid = forbidValue == true ? false : true)
         {
            this.disport();
            this.mutilClip.forbidClip.gotoAndStop(2);
         }
         else
         {
            this.mutilClip.forbidClip.gotoAndStop(1);
         }
      }
      
      private function inputFocusIn(evt:FocusEvent) : void
      {
         if(!this.input.hasEventListener(KeyboardEvent.KEY_DOWN))
         {
            this.input.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
      }
      
      private function onKeyDown(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == 13)
         {
            this.sendMsg(null);
         }
      }
      
      public function chatBack(body:Object) : void
      {
         if(body.uid != GlobalConfig.userId)
         {
            this.output.appendMessage("",body.userName,"",0,body.msg,false);
         }
      }
      
      private function sort() : void
      {
         var obj:Object = null;
         var item:Object = null;
         var onlineList:Array = [];
         var notOnlineList:Array = [];
         for each(obj in this.memberList)
         {
            if(obj.isOnline > 0)
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
         this.memberList = onlineList.concat(notOnlineList);
         this.dp.removeAll();
         for each(item in this.memberList)
         {
            this.dp.addItem(item);
         }
         this.uiScroll.setSize(220,192);
         this.uiScroll.rowCount = 8;
         this.uiScroll.rowHeight = 31;
         this.uiScroll.dataProvider = this.dp;
         this.uiScroll.invalidateList();
         this.uiScroll.setSize(220,192);
         this.uiScroll.rowCount = 8;
         this.uiScroll.rowHeight = 31;
         this.uiScroll.dataProvider = this.dp;
         this.uiScroll.invalidateList();
      }
      
      private function setBadge(body:Object) : void
      {
         this.badge = new FamilyBadge();
         this.badge.setBadge(body.midid,body.smallid,body._name,body.midcolor,body.circolor,0.6);
         this.addChildAt(this.badge,this.numChildren);
         this.badge.x = 195;
         this.badge.y = 28;
         var tips:String = HtmlUtil.getHtmlText(14,"#FF0000","【" + body.f_name + "】");
         ToolTip.setDOInfo(this.badge,tips);
      }
   }
}

