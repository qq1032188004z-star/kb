package com.game.modules.view.chat
{
   import caurina.transitions.Tweener;
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.modules.control.chat.ChatControl;
   import com.game.modules.view.FaceView;
   import com.game.util.ChatUtil;
   import com.game.util.ColorUtil;
   import com.game.util.FloatAlert;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.smile.SmileView;
   import com.publiccomponent.ui.ToolTip;
   import com.publiccomponent.util.RegExpUtil;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.getTimer;
   import org.dress.ui.RoleFace;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol325")]
   public class ChatView extends Sprite
   {
      
      public var pkBtn:SimpleButton;
      
      public var nameTxt:TextField;
      
      public var moveUpBtn:SimpleButton;
      
      public var moveDownBtn:SimpleButton;
      
      public var rollClip:MovieClip;
      
      public var closeBtn:SimpleButton;
      
      public var sendBtn:SimpleButton;
      
      public var dragClip:MovieClip;
      
      public var bgClip:MovieClip;
      
      public var faceBtn:SimpleButton;
      
      public var snapBtn:SimpleButton;
      
      public var inviteTeamBtn:SimpleButton;
      
      public var checkWhereBtn:SimpleButton;
      
      public var gotoHouseBtn:SimpleButton;
      
      public var checkInfoBtn:SimpleButton;
      
      public var minBtn:SimpleButton;
      
      public var minBtn2:SimpleButton;
      
      public var closeBtn2:SimpleButton;
      
      public var ibg:MovieClip;
      
      public var obg:MovieClip;
      
      public var unfamilyTxt:TextField;
      
      private var output:ChatTextField;
      
      private var input:TextField;
      
      public var params:Object;
      
      private var smile:SmileView;
      
      private var selfRoleFace:RoleFace;
      
      private var playerRoleFace:RoleFace;
      
      private var loader:Loader;
      
      private var lastClickTime:Number = 0;
      
      public var friendName:String = "";
      
      public var checkParams:Object;
      
      private var index:int = 0;
      
      public function ChatView()
      {
         super();
         ApplicationFacade.getInstance().registerViewLogic(new ChatControl(this));
         this.cacheAsBitmap = true;
         this.init();
         this.initToolTip();
         this.initEvent();
      }
      
      private function init() : void
      {
         this.loader = new Loader();
         this.output = new ChatTextField(290,160);
         this.output.x = -210;
         this.output.y = -90;
         this.addChild(this.output);
         this.getUIScrollBar();
         this.input = new TextField();
         this.input.width = 290;
         this.input.height = 58;
         this.input.type = TextFieldType.INPUT;
         this.input.x = -208;
         this.input.y = 120;
         this.input.wordWrap = true;
         this.input.maxChars = 50;
         this.addChild(this.input);
         this.selfRoleFace = new RoleFace(195,216,4);
         this.selfRoleFace.mouseEnabled = false;
         this.selfRoleFace.scaleX = 0.5;
         this.selfRoleFace.scaleY = 0.5;
         addChild(this.selfRoleFace);
         this.playerRoleFace = new RoleFace(195,40,4);
         this.playerRoleFace.mouseEnabled = false;
         this.playerRoleFace.scaleX = 0.5;
         this.playerRoleFace.scaleY = 0.5;
         addChild(this.playerRoleFace);
         this.smile = new SmileView(-170,40);
         this.smile.visible = false;
         this.addChild(this.smile);
         if(GameData.instance.playerData.isInWarCraft)
         {
            this.pkBtn.mouseEnabled = false;
            this.pkBtn.filters = ColorUtil.getColorMatrixFilterGray();
         }
         else
         {
            this.pkBtn.mouseEnabled = true;
            this.pkBtn.filters = null;
         }
         this.unfamilyTxt.visible = false;
      }
      
      private function initRoleFace(params:Object, roleFace:RoleFace) : void
      {
         roleFace.setRole(params,"big",false);
         dispatchEvent(new MessageEvent(ChatEvent.REQUEST_UNFAMILY_CHAT));
      }
      
      public function initPlayerFace(params:Object) : void
      {
         this.initRoleFace(params,this.playerRoleFace);
      }
      
      private function initToolTip() : void
      {
         this.snapBtn.visible = false;
         ToolTip.BindDO(this.faceBtn,"插入表情");
         ToolTip.BindDO(this.snapBtn,"截图发送");
         ToolTip.BindDO(this.pkBtn,"发起挑战");
         ToolTip.BindDO(this.dragClip,"点击拖动窗口");
         ToolTip.BindDO(this.inviteTeamBtn,"邀请组队");
         ToolTip.BindDO(this.checkWhereBtn,"查看位置");
         ToolTip.BindDO(this.gotoHouseBtn,"进入家园");
         ToolTip.BindDO(this.checkInfoBtn,"查看详细信息");
         ToolTip.BindDO(this.minBtn,"最小化窗口");
         ToolTip.BindDO(this.closeBtn,"关闭窗口");
      }
      
      private function initEvent() : void
      {
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeWindow);
         this.dragClip.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.dragClip.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.sendBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onSendMsg);
         this.faceBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.openFace);
         this.pkBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.startPk);
         this.smile.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onClickSmile);
         this.snapBtn.addEventListener(MouseEvent.CLICK,this.onSnap);
         this.output.addEventListener(TextEvent.LINK,this.onLinkClick);
         this.input.addEventListener(FocusEvent.FOCUS_IN,this.onFocusOutText);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplement);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.inviteTeamBtn.addEventListener(MouseEvent.CLICK,this.onInviteTeamBtn);
         this.checkWhereBtn.addEventListener(MouseEvent.CLICK,this.onCheckWhereBtn);
         this.gotoHouseBtn.addEventListener(MouseEvent.CLICK,this.onGotoHouseBtn);
         this.checkInfoBtn.addEventListener(MouseEvent.CLICK,this.onCheckInfoBtn);
         this.closeBtn2.addEventListener(MouseEvent.CLICK,this.closeWindow);
         this.minBtn.addEventListener(MouseEvent.CLICK,this.onMinimizeWindow);
         this.minBtn2.addEventListener(MouseEvent.CLICK,this.onMinimizeWindow);
      }
      
      private function startPk(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.isNewHand < 9)
         {
            new FloatAlert().show(this.stage,100,100,"乖乖做完新手指引先吧");
            return;
         }
         dispatchEvent(new ChatEvent(ChatEvent.PKEVENT,{
            "userId":this.params.userId,
            "userName":this.params.userName,
            "sex":this.params.sex
         }));
      }
      
      private function getUIScrollBar() : void
      {
         this.output.initStyle(this.getChildByName("moveUpBtn"),this.getChildByName("moveDownBtn"),this.getChildByName("rollClip"),this.getChildByName("bgClip"));
      }
      
      private function onFocusOutText(evt:FocusEvent) : void
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
            this.sendMsg(this.input.text);
            this.input.text = "";
         }
      }
      
      private function onLinkClick(evt:TextEvent) : void
      {
         var url:String = "http://" + evt.text;
         this.loader.load(new URLRequest(url));
      }
      
      private function onComplement(evt:Event) : void
      {
         var bitmapData:BitmapData = new BitmapData(this.loader.width,this.loader.height,true,0);
         bitmapData.draw(this.loader);
         ApplicationFacade.getInstance().dispatch(EventConst.SHOWVIEW,bitmapData);
      }
      
      private function onSnap(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         ScreenSnapshot.style[ScreenSnapshot.POINT] = Ball;
         ScreenSnapshot.style[ScreenSnapshot.BAR] = SnapshotBar;
         ScreenSnapshot.phpurl = "http://kbxy.wanwan4399.com/snapshot/savebitmap.php";
         var ss:ScreenSnapshot = new ScreenSnapshot(200,200);
         ss.addEventListener(SnapShotEvent.SAVE,this.onSave);
         ss.addEventListener(SnapShotEvent.CLOSE,this.onClose);
         ss.x = 400;
         ss.y = 200;
         this.stage.addChild(ss);
         this.visible = false;
      }
      
      private function onSave(e:SnapShotEvent) : void
      {
         var i:int = 0;
         var msg:String = "<a href=\'" + e.bitmapurl + "\'><font color=\'#0000ff\'>西游截图</font></a>";
         this.sendMsg(msg);
         this.visible = true;
         if(this.stage.contains(e.target as DisplayObject))
         {
            this.stage.removeChild(e.target as DisplayObject);
         }
      }
      
      private function onClose(e:SnapShotEvent) : void
      {
         this.visible = true;
         this.stage.removeChild(e.target as DisplayObject);
      }
      
      private function onRemovedFromStage(evt:Event) : void
      {
         if(Boolean(this.params.hasOwnProperty("family")) && this.params.family > 0)
         {
            GameData.instance.playerData.fisOpening[this.params.userId] = false;
         }
         else
         {
            GameData.instance.playerData.isOpening[this.params.userId] = false;
         }
      }
      
      public function buildChat() : void
      {
         var obj:Object = null;
         this.initRoleFace(GameData.instance.playerData,this.selfRoleFace);
         this.params.userName = RegExpUtil.instance.replaceSpecialWord(this.params.userName);
         this.nameTxt.text = "正在和" + this.params.userName + "聊天中";
         this.friendName = this.params.userName;
         var cache:Array = [];
         if(Boolean(this.params.hasOwnProperty("family")) && this.params.family > 0)
         {
            GameData.instance.playerData.fisOpening[this.params.userId] = true;
            cache = GameData.instance.playerData.fmsgCache[this.params.userId];
         }
         else
         {
            GameData.instance.playerData.isOpening[this.params.userId] = true;
            cache = GameData.instance.playerData.msgCache[this.params.userId];
            FaceView.clip.bottomClip.stopShakeFriend(this.params.userId);
            if(this.params.isOnline != undefined)
            {
               this.params.isOnline;
            }
            this.params.shakeFlag = 2;
            this.params.from_id = this.params.userId;
            this.params.from_name = this.params.userName;
            FaceView.clip.bottomClip.addChatFriend(this.params);
         }
         if(cache == null)
         {
            return;
         }
         for each(obj in cache)
         {
            this.output.appendMessage("",obj.from_name,"",0,obj.content,false);
         }
         cache.length = 0;
      }
      
      public function isShowRefuseUnfamilyTis(bShow:Boolean) : void
      {
         this.unfamilyTxt.visible = bShow;
         if(this.checkFriendList())
         {
            this.unfamilyTxt.visible = false;
         }
      }
      
      private function checkFriendList() : Boolean
      {
         var list:Object = null;
         for each(list in GameData.instance.friendsList)
         {
            if(uint(this.params.userId) == list.userId)
            {
               return true;
            }
         }
         return false;
      }
      
      private function onMouseDown(evt:MouseEvent) : void
      {
         this.startDrag();
      }
      
      private function onMouseUp(evt:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      private function removeAllEvent() : void
      {
         this.closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeWindow);
         this.dragClip.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.dragClip.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.removeChild(this.input);
         this.input = null;
         this.removeChild(this.output);
         this.output = null;
      }
      
      public function addMsg(msg:Object) : void
      {
         this.output.appendMessage("",msg.from_name,"",0,msg.content,false);
      }
      
      private function onSendMsg(evt:MouseEvent) : void
      {
         this.sendMsg(this.input.text);
         this.input.text = "";
      }
      
      private function sendMsg(msg:String) : void
      {
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
         this.lastClickTime = tempClickTime;
         var body:Object = {};
         body.type = 0;
         body.flag = 0;
         body.to_id = this.params.userId;
         body.to_online = this.params.isOnline == undefined ? 0 : this.params.isOnline;
         body.see = true;
         body.roleType = GameData.instance.playerData.roleType;
         if(Boolean(this.params.hasOwnProperty("family")) && this.params.family > 0)
         {
            body.type = 3;
         }
         if(this.unfamilyTxt.visible && body.type == 0)
         {
            O.o("该玩家屏蔽陌生人聊天");
            return;
         }
         if(ChatUtil.isOpenChat())
         {
            ChatUtil.onCompanyCheck(msg,this.onCheck,body);
         }
      }
      
      private function onCheck(msg:String, body:Object) : void
      {
         body.content = msg;
         body.say = msg;
         this.output.appendMessage("",GameData.instance.playerData.userName,"",0,msg,true);
         dispatchEvent(new MessageEvent("onSendMessage",body));
      }
      
      private function closeWindow(evt:MouseEvent) : void
      {
         if(Boolean(this.params.hasOwnProperty("family")) && this.params.family > 0)
         {
            GameData.instance.playerData.fisOpening[GlobalConfig.userId + "_" + this.params.userId] = false;
         }
         else
         {
            GameData.instance.playerData.isOpening[GlobalConfig.userId + "_" + this.params.userId] = false;
         }
         this.parent.removeChild(this);
         FaceView.clip.bottomClip.delChatFriend(this.params);
      }
      
      private function openFace(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.smile.visible = this.smile.visible == true ? false : true;
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
      
      private function onInviteTeamBtn(evt:MouseEvent) : void
      {
         this.dispatchEvent(new Event("onInviteTeamBtn"));
      }
      
      private function onCheckWhereBtn(evt:MouseEvent) : void
      {
         this.dispatchEvent(new Event("onCheckWhereBtn"));
      }
      
      private function onGotoHouseBtn(evt:MouseEvent) : void
      {
         this.dispatchEvent(new Event("onGotoHouseBtn"));
      }
      
      private function onCheckInfoBtn(evt:MouseEvent) : void
      {
         this.dispatchEvent(new Event("onCheckInfoBtn"));
      }
      
      private function onMinimizeWindow(evt:MouseEvent) : void
      {
         dispatchEvent(new MessageEvent(ChatEvent.REQUEST_UNFAMILY_CHAT));
         Tweener.addTween(this,{
            "alpha":alpha - 1,
            "x":x + 250,
            "y":y + 90,
            "time":0.3,
            "delay":0,
            "transition":"linear",
            "onComplete":this.onTweenerComplete
         });
      }
      
      private function onTweenerComplete() : void
      {
         if(Boolean(this.params.hasOwnProperty("family")) && this.params.family > 0)
         {
            GameData.instance.playerData.fisOpening[GlobalConfig.userId + "_" + this.params.userId] = false;
         }
         else
         {
            GameData.instance.playerData.isOpening[GlobalConfig.userId + "_" + this.params.userId] = false;
         }
         this.parent.removeChild(this);
         this.x = 400;
         this.y = 280;
         this.alpha = 1;
      }
   }
}

