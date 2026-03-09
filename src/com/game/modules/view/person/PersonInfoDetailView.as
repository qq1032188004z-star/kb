package com.game.modules.view.person
{
   import caurina.transitions.Tweener;
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.FilterString;
   import com.game.global.GlobalConfig;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.modules.control.person.PersonDetailInfoControl;
   import com.game.modules.view.MapView;
   import com.game.modules.view.item.BossItem;
   import com.game.util.CacheUtil;
   import com.game.util.ChractorFilter;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.PhpInterFace;
   import com.game.util.TimeTransform;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLVariables;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.dress.ui.RoleFace;
   import org.json.JSON;
   
   public class PersonInfoDetailView extends HLoaderSprite
   {
      
      public static const SHOWTITLE:String = "showtitle";
      
      public static const CHANGNAME:String = "changname";
      
      public static const CHANGEBEIZHU:String = "changebeizhu";
      
      private var detailClip:MovieClip;
      
      private var moveSpeed:Number;
      
      public var checkParams:Object;
      
      public var params:Object;
      
      private var jiaoniKuangDian:Boolean;
      
      private var roleFace:RoleFace;
      
      private var shapMask:Shape;
      
      private var titlelist:TitleList;
      
      private var levelList:Array = [120,140,180,230,280,350,430,520,610,720,840,960,1100,1250,1400,1570,1750,1940,2130];
      
      private var list:TileList;
      
      private var titlexml:XMLList;
      
      private var urlloader:URLLoader;
      
      private var xmldata:XML;
      
      private var bossList:Array = [];
      
      private var bossShowList:Array = [{
         "id":"10060",
         "time":1,
         "flag":0,
         "desc":"巨木将军"
      },{
         "id":"10064",
         "time":2,
         "flag":0,
         "desc":"金甲剑狮"
      },{
         "id":"10067",
         "time":3,
         "flag":0,
         "desc":"赤炎鸟"
      },{
         "id":"10068",
         "time":4,
         "flag":0,
         "desc":"冥图古犀"
      },{
         "id":"10069",
         "time":5,
         "flag":0,
         "desc":"海龙马"
      },{
         "id":"10070",
         "time":6,
         "flag":0,
         "desc":"傲天"
      },{
         "id":"10071",
         "time":7,
         "flag":0,
         "desc":"紫云太岁"
      },{
         "id":"10072",
         "time":8,
         "flag":0,
         "desc":"冲霄"
      },{
         "id":"10077",
         "time":9,
         "flag":0,
         "desc":"绿刺蝠卫"
      },{
         "id":"10081",
         "time":10,
         "flag":0,
         "desc":"夜刃闪"
      },{
         "id":"10123",
         "time":11,
         "flag":0,
         "desc":"蓝羽大仙"
      },{
         "id":"10158",
         "time":12,
         "flag":0,
         "desc":"九幽看守者"
      },{
         "id":"10214",
         "time":13,
         "flag":0,
         "desc":"惊雷大仙"
      },{
         "id":"10231",
         "idList":["10231","10232","10233","10234","10235"],
         "time":14,
         "flag":0,
         "desc":"幻咒王"
      },{
         "id":"10381",
         "time":15,
         "flag":0,
         "desc":"冰龙神"
      },{
         "id":"10416",
         "time":16,
         "flag":0,
         "desc":"永夜王"
      },{
         "id":"10455",
         "time":17,
         "flag":0,
         "desc":"星际巡航者"
      },{
         "id":"10459",
         "time":18,
         "flag":0,
         "desc":"焚天战魂"
      },{
         "id":"10503",
         "time":19,
         "flag":0,
         "desc":"圣光天尊"
      }];
      
      private const transSingleList:Array = [{
         "low":1,
         "up":1,
         "id":8
      },{
         "low":2,
         "up":100,
         "id":7
      },{
         "low":101,
         "up":300,
         "id":6
      },{
         "low":301,
         "up":1000,
         "id":5
      },{
         "low":1001,
         "up":3000,
         "id":4
      },{
         "low":3001,
         "up":10000,
         "id":3
      },{
         "low":10001,
         "up":20000,
         "id":2
      },{
         "low":20001,
         "up":-1,
         "id":1
      }];
      
      private const transMulList:Array = [{
         "low":1,
         "up":1,
         "id":8
      },{
         "low":2,
         "up":100,
         "id":7
      },{
         "low":101,
         "up":300,
         "id":6
      },{
         "low":301,
         "up":1000,
         "id":5
      },{
         "low":1001,
         "up":3000,
         "id":4
      },{
         "low":3001,
         "up":5000,
         "id":3
      },{
         "low":5001,
         "up":10000,
         "id":2
      },{
         "low":10001,
         "up":-1,
         "id":1
      }];
      
      private var arenaData:Object;
      
      private var currentIndex:int;
      
      private var specialIDList:Array = [225311528,378177008];
      
      private var nameAlert:PersonUserNameAlert;
      
      private var prename:String = "";
      
      private var checknamestring:String = "";
      
      private var dtid:int = 0;
      
      private var gameEden:Object;
      
      private var downBadgeCompare:Boolean;
      
      public function PersonInfoDetailView()
      {
         GreenLoading.loading.visible = true;
         super();
         this.roleFace = new RoleFace(194,129,4);
         this.roleFace.mouseEnabled = false;
         this.titlelist = new TitleList();
         this.shapMask = new Shape();
         this.shapMask.graphics.beginFill(16711680,1);
         this.shapMask.graphics.drawRoundRect(156,38,80,82,40);
         this.shapMask.graphics.endFill();
         this.url = "assets/personinfo/personinfodetail.swf";
      }
      
      override public function setShow() : void
      {
         this.detailClip = this.bg;
         this.detailClip.cacheAsBitmap = true;
         this.detailClip.addChild(this.roleFace);
         this.detailClip.addChild(this.shapMask);
         this.roleFace.mask = this.shapMask;
         this.initList();
         ApplicationFacade.getInstance().registerViewLogic(new PersonDetailInfoControl(this));
         GreenLoading.loading.visible = false;
      }
      
      private function initList() : void
      {
         this.list = new TileList(194,238);
         this.list.build(4,1,35,30,14,5,BossItem);
         this.detailClip.addChild(this.list);
      }
      
      private function initToolTip() : void
      {
         ToolTip.BindDO(this.detailClip.daluanDouClip,"大乱斗");
         ToolTip.BindDO(this.detailClip.leiTaiClip,"单妖怪擂台");
         ToolTip.BindDO(this.detailClip.dleiTaiClip,"多妖怪擂台");
         ToolTip.BindDO(this.detailClip.pkmc,"游戏乐园");
         ToolTip.BindDO(this.detailClip.changnamemc.btnsure,"确认修改");
         ToolTip.BindDO(this.detailClip.beizhuBg.beizhusure,"确认修改");
         ToolTip.BindDO(this.detailClip.arenaClip,"封神之战");
      }
      
      public function initEvents() : void
      {
         this.initToolTip();
         EventManager.attachEvent(this,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         EventManager.attachEvent(this.detailClip.closeBtn,MouseEvent.CLICK,this.close);
         EventManager.attachEvent(this.detailClip.leftBtn,MouseEvent.MOUSE_DOWN,this.moveLeft);
         EventManager.attachEvent(this.detailClip.rightBtn,MouseEvent.MOUSE_DOWN,this.moveRight);
         EventManager.attachEvent(this.detailClip.titleBtn,MouseEvent.MOUSE_DOWN,this.showTitle);
         EventManager.attachEvent(this.detailClip.checkNameBtn,MouseEvent.MOUSE_DOWN,this.checkUserName);
         EventManager.attachEvent(this.detailClip.arenaDetailBtn,MouseEvent.MOUSE_DOWN,this.onArenaDetail);
         if(this.detailClip.hasOwnProperty("changnamemc"))
         {
            this.detailClip.changnamemc.visible = false;
            EventManager.attachEvent(this.detailClip.changnamemc.btnsure,MouseEvent.CLICK,this.sureChangeName);
            EventManager.attachEvent(this.detailClip.btnchange,MouseEvent.CLICK,this.changeName);
         }
         if(this.detailClip.hasOwnProperty("beizhuBg"))
         {
            TextField(this.detailClip.beizhuTxt).mouseEnabled = false;
            this.detailClip.beizhuBg.visible = false;
            this.detailClip.beizhuBtn.visible = false;
            EventManager.attachEvent(this.detailClip.beizhuBg.beizhusure,MouseEvent.CLICK,this.sureChangeBeizhu);
            EventManager.attachEvent(this.detailClip.beizhuBtn,MouseEvent.CLICK,this.changeName);
         }
         this.detailClip.checkNameBtn.visible = false;
         this.detailClip.badgeCompareMc.visible = false;
         this.detailClip.badgeCompareBtn.gotoAndStop(1);
         EventManager.attachEvent(this.detailClip.badgeCompareBtn,MouseEvent.CLICK,this.badgeCompareHandler);
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(this,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         EventManager.removeEvent(this.detailClip.closeBtn,MouseEvent.CLICK,this.close);
         EventManager.removeEvent(this.detailClip.leftBtn,MouseEvent.MOUSE_DOWN,this.moveLeft);
         EventManager.removeEvent(this.detailClip.rightBtn,MouseEvent.MOUSE_DOWN,this.moveRight);
         EventManager.removeEvent(this.detailClip.titleBtn,MouseEvent.MOUSE_DOWN,this.showTitle);
         EventManager.removeEvent(this.detailClip.checkNameBtn,MouseEvent.MOUSE_DOWN,this.checkUserName);
         EventManager.removeEvent(this.detailClip.arenaDetailBtn,MouseEvent.MOUSE_DOWN,this.onArenaDetail);
         if(this.detailClip.hasOwnProperty("changnamemc"))
         {
            EventManager.removeEvent(this.detailClip.changnamemc.btnsure,MouseEvent.CLICK,this.sureChangeName);
            EventManager.removeEvent(this.detailClip.btnchange,MouseEvent.CLICK,this.changeName);
         }
         if(this.detailClip.hasOwnProperty("beizhuBg"))
         {
            EventManager.removeEvent(this.detailClip.beizhuBg.beizhusure,MouseEvent.CLICK,this.sureChangeBeizhu);
            EventManager.removeEvent(this.detailClip.beizhuBtn,MouseEvent.CLICK,this.changeName);
         }
         EventManager.removeEvent(this.detailClip.badgeCompareBtn,MouseEvent.CLICK,this.badgeCompareHandler);
      }
      
      private function checkUserName(evt:MouseEvent) : void
      {
         if(Boolean(this.nameAlert))
         {
            this.nameAlert.dispos();
         }
         this.nameAlert = new PersonUserNameAlert();
         addChild(this.nameAlert);
         this.nameAlert.showUserName(GlobalConfig.czUserName);
      }
      
      private function onArenaDetail(evt:MouseEvent) : void
      {
         this.params.userId = this.checkParams.userId;
         ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/module/ArenaDetail.swf",
            "moduleParams":this.params
         });
      }
      
      private function showTitle(evt:MouseEvent) : void
      {
         this.detailClip.titleBtn.mouseEnabled = false;
         this.dispatchEvent(new MessageEvent(PersonInfoDetailView.SHOWTITLE));
      }
      
      public function showtitleback(data:Object) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/system/title/SelectTitleView.swf"});
         this.detailClip.titleBtn.mouseEnabled = true;
      }
      
      public function setShowTitle($uid:int, $index:int) : void
      {
         if(this.checkParams.userId == $uid)
         {
            this.params.title = $index;
            this.settitle();
         }
      }
      
      private function settitle() : void
      {
         if(CacheData.instance.titleList.isLoadComplete)
         {
            this.showTitleStr();
         }
         else
         {
            CacheData.instance.titleList.addSingleResponse({
               "id":this.params.title,
               "response":this.showTitleStr
            });
         }
      }
      
      private function showTitleStr() : void
      {
         this.detailClip.titleTxt.text = CacheData.instance.titleList.getTitleName(this.params.title);
      }
      
      private function moveRight(evt:MouseEvent) : void
      {
         if(this.bossList.length - this.currentIndex * 4 > 4)
         {
            ++this.currentIndex;
            if(this.bossList.length - this.currentIndex * 4 > 4)
            {
               this.list.dataProvider = this.bossList.slice(this.currentIndex * 4,this.currentIndex * 4 + 4);
            }
            else
            {
               this.list.dataProvider = this.bossList.slice(this.currentIndex * 4,this.bossList.length);
            }
         }
      }
      
      private function moveLeft(evt:MouseEvent) : void
      {
         if(this.currentIndex <= 0)
         {
            return;
         }
         --this.currentIndex;
         this.list.dataProvider = this.bossList.slice(this.currentIndex * 4,this.currentIndex * 4 + 4);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.detailClip.nameTxt.text = "";
         this.detailClip.idTxt.text = "";
         this.detailClip.numTxt.text = "";
         this.detailClip.maxLevelTxt.text = "";
         this.detailClip.leitaiTxt.text = "";
         this.detailClip.timeTxt.text = "";
         this.detailClip.levelTxt.text = "";
         this.detailClip.headClip.gotoAndStop(1);
         this.detailClip.expTxt.text = 0 + "/" + 0;
         this.detailClip.expClip.gotoAndStop(1);
         this.detailClip.daluandouTxt.text = "";
         this.detailClip.lianDanLevel.text = "";
         this.detailClip.achievetxt.text = "";
         this.currentIndex = 0;
         this.list.dataProvider = [];
         if(this.roleFace != null)
         {
            this.roleFace.visible = false;
         }
      }
      
      public function changNameBack(value:int) : void
      {
         if(value != 0)
         {
            TextField(this.detailClip.nameTxt).text = this.prename;
            TextField(this.detailClip.nameTxt).mouseEnabled = true;
         }
         else
         {
            MapView.instance.masterPerson.showData.userName = TextField(this.detailClip.nameTxt).text + "";
            MapView.instance.masterPerson.setPeronName(TextField(this.detailClip.nameTxt).text + "");
            GameData.instance.playerData.userName = TextField(this.detailClip.nameTxt).text + "";
            GameData.instance.playerData.canChangeName = false;
            TextField(this.detailClip.nameTxt).mouseEnabled = false;
            TextField(this.detailClip.nameTxt).autoSize = TextFieldAutoSize.CENTER;
            this.detailClip.changnamemc.visible = false;
            this.detailClip.btnchange.visible = true;
            this.detailClip.btnchange.filters = ColorUtil.getColorMatrixFilterGray();
            ToolTip.BindDO(this.detailClip.btnchange,"今天你的改名次数已经用完了哦");
         }
      }
      
      private function changeName(event:MouseEvent) : void
      {
         if(event.currentTarget == this.detailClip.beizhuBtn)
         {
            TextField(this.detailClip.beizhuTxt).mouseEnabled = true;
            this.detailClip.beizhuBtn.visible = false;
            this.detailClip.beizhuBg.visible = true;
         }
         else if(GameData.instance.playerData.canChangeName)
         {
            TextField(this.detailClip.nameTxt).mouseEnabled = true;
            this.detailClip.changnamemc.visible = true;
            this.detailClip.btnchange.visible = false;
         }
      }
      
      private function sureChangeName(event:MouseEvent) : void
      {
         var myreg:RegExp = null;
         if(this.checknamestring == "")
         {
            this.checknamestring = FilterString.filterChars;
         }
         var tempname:String = TextField(this.detailClip.nameTxt).text;
         var myPattern:RegExp = /([ ]{1})/g;
         tempname = tempname.replace(myPattern,"");
         if(this.specialIDList.indexOf(uint(GlobalConfig.userId)) == -1)
         {
            myreg = new RegExp(new XMLList(this.checknamestring),"g");
            tempname = tempname.replace(myreg,"*");
         }
         if(tempname.indexOf("*") != -1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1055,
               "flag":1
            });
            return;
         }
         tempname = ChractorFilter.filterRename(tempname,"*");
         if(tempname.indexOf("*") != -1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1055,
               "flag":2
            });
         }
         else if(tempname == "")
         {
            AlertManager.instance.showTipAlert({
               "systemid":1055,
               "flag":3
            });
         }
         else if(tempname == this.prename)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1055,
               "flag":4
            });
            TextField(this.detailClip.nameTxt).mouseEnabled = false;
            this.detailClip.changnamemc.visible = false;
            this.detailClip.btnchange.visible = true;
         }
         else
         {
            this.dispatchEvent(new MessageEvent(PersonInfoDetailView.CHANGNAME,{"userName":tempname}));
            TextField(this.detailClip.nameTxt).mouseEnabled = false;
         }
      }
      
      private function sureChangeBeizhu(evt:MouseEvent) : void
      {
         if(!GameData.instance.playerData.tempfriends.hasOwnProperty(String(this.checkParams.userId)) || GameData.instance.playerData.tempfriends[String(this.checkParams.userId)] != 1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1056,
               "flag":1
            });
            return;
         }
         if(this.checknamestring == "")
         {
            this.checknamestring = FilterString.filterChars;
         }
         var tempname:String = TextField(this.detailClip.beizhuTxt).text;
         var myPattern:RegExp = /([ ]{1})/g;
         tempname = tempname.replace(myPattern,"");
         var myreg:RegExp = new RegExp(new XMLList(this.checknamestring),"g");
         tempname = tempname.replace(myreg,"*");
         if(tempname.indexOf("*") != -1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1056,
               "flag":2
            });
            return;
         }
         tempname = ChractorFilter.filterRename(tempname,"*");
         if(tempname.indexOf("*") != -1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1056,
               "flag":3
            });
         }
         else if(tempname == "")
         {
            AlertManager.instance.showTipAlert({
               "systemid":1056,
               "flag":4
            });
         }
         else if(tempname == this.prename)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1056,
               "flag":5
            });
            TextField(this.detailClip.beizhuTxt).mouseEnabled = false;
            this.detailClip.beizhuBg.visible = false;
            this.detailClip.beizhuBtn.visible = true;
         }
         else
         {
            this.checkParams.userBeiZhu = tempname;
            this.dispatchEvent(new MessageEvent(PersonInfoDetailView.CHANGEBEIZHU,{
               "uid":this.checkParams.userId,
               "userBeizhu":tempname
            }));
            TextField(this.detailClip.beizhuTxt).mouseEnabled = false;
         }
      }
      
      public function setData(params:Object) : void
      {
         var horseTemp:int = 0;
         TextField(this.detailClip.nameTxt).maxChars = 8;
         if(this.checkParams.userId == uint(GlobalConfig.userId))
         {
            this.detailClip.beizhuBg.visible = false;
            this.detailClip.beizhuBtn.visible = false;
            this.detailClip.closeBtn.visible = true;
            this.detailClip.titleBtn.visible = true;
            this.prename = this.checkParams.userName;
            if(Boolean(this.detailClip.hasOwnProperty("btnchange")) && GameData.instance.playerData.canChangeName)
            {
               TextField(this.detailClip.nameTxt).mouseEnabled = false;
               this.detailClip.btnchange.filters = [];
               this.detailClip.btnchange.visible = true;
               ToolTip.BindDO(this.detailClip.btnchange,"修改名称，每天有一次机会");
            }
            else if(this.detailClip.hasOwnProperty("btnchange"))
            {
               TextField(this.detailClip.nameTxt).mouseEnabled = false;
               this.detailClip.btnchange.filters = ColorUtil.getColorMatrixFilterGray();
               this.detailClip.btnchange.visible = true;
               ToolTip.BindDO(this.detailClip.btnchange,"今天你的改名次数已经用完了哦");
            }
         }
         else
         {
            this.detailClip.beizhuBg.visible = false;
            this.detailClip.beizhuBtn.visible = true;
            this.detailClip.closeBtn.visible = false;
            this.detailClip.titleBtn.visible = false;
            TextField(this.detailClip.nameTxt).mouseEnabled = false;
            if(this.detailClip.hasOwnProperty("btnchange"))
            {
               this.detailClip.btnchange.visible = false;
            }
         }
         this.params = params;
         this.detailClip.nameTxt.text = this.checkParams.userName + "";
         this.detailClip.idTxt.text = uint(this.checkParams.userId) + "";
         this.detailClip.numTxt.text = params.spirit_num + "";
         this.detailClip.maxLevelTxt.text = int(params.max_spirit_level) > 100 ? "100" : params.max_spirit_level + "";
         this.detailClip.leitaiTxt.text = "" + params.arena_vc;
         this.detailClip.dleitaiTxt.text = params.arena_vcs + "";
         this.detailClip.timeTxt.text = "" + TimeTransform.getInstance().transDate(params.reg_time);
         this.detailClip.levelTxt.text = "" + params.level;
         this.detailClip.lianDanLevel.text = params.liandan + "";
         this.detailClip.achievetxt.text = params.achievepoint + "";
         this.settitle();
         if((params.holyList as Array).length > 0)
         {
            this.detailClip.singleValueTxt.text = params.holyList[(params.holyList as Array).length - 1].holySingleValue + "";
            this.detailClip.mulValueTxt.text = params.holyList[(params.holyList as Array).length - 1].holyMulValue + "";
         }
         if(this.checkParams.sex == 1)
         {
            this.detailClip.headClip.gotoAndStop(1);
         }
         else
         {
            this.detailClip.headClip.gotoAndStop(2);
         }
         this.caluExp();
         if(this.checkParams.hasOwnProperty("body"))
         {
            horseTemp = int(this.checkParams.body.horseID);
            this.checkParams.body.horseID = 0;
            this.roleFace.setRole(this.checkParams.body,"green");
            this.checkParams.body.horseID = horseTemp;
            this.roleFace.visible = true;
         }
         this.detailClip.daluandouTxt.text = params.leiDa.split("|")[1].split(":")[0];
         this.bossList = params.boss.split(":");
         this.filterHasBeat();
         if(this.checkParams.isFriend == 1 && this.checkParams.userId != uint(GlobalConfig.userId))
         {
            this.detailClip.beizhuTxt.text = this.checkParams.userBeiZhu;
         }
         else
         {
            this.detailClip.beizhuTxt.text = "";
         }
         this.isTmd();
         this.setArenRank();
         this.initBadgeCompare();
         clearTimeout(this.dtid);
         this.dtid = setTimeout(this.getGameEden,600);
      }
      
      private function getGameEden() : void
      {
         clearTimeout(this.dtid);
         var va:URLVariables = new URLVariables();
         var url:String = GlobalConfig.phpserver + "game_wall/player_score.php?gameid=0&uid=" + this.checkParams.userId + "&uname=" + this.checkParams.userName;
         new PhpInterFace().getData(url,va,this.getGameEdenBack);
      }
      
      private function getGameEdenBack(params:Object) : void
      {
         var total_score:int = 0;
         var title:String = null;
         var data:Object = JSON.decode(String(params));
         if(Boolean(data) && Boolean(data.hasOwnProperty("total_score")))
         {
            total_score = int(data.total_score);
            if(total_score <= 50)
            {
               title = "新手上路";
            }
            else if(total_score <= 99)
            {
               title = "初露苗头";
            }
            else if(total_score <= 499)
            {
               title = "小有名气";
            }
            else if(total_score <= 999)
            {
               title = "登堂入室";
            }
            else if(total_score <= 1999)
            {
               title = "游戏高手";
            }
            else if(total_score <= 4999)
            {
               title = "游戏达人";
            }
            else if(total_score <= 9999)
            {
               title = "游戏大师";
            }
            else if(total_score <= 19999)
            {
               title = "游戏尊者";
            }
            else if(total_score <= 49999)
            {
               title = "游戏之王";
            }
            else if(total_score <= 9999999)
            {
               title = "不败之神";
            }
            else
            {
               title = "不败之神";
            }
         }
         else
         {
            total_score = 0;
            title = "新手上路";
         }
         this.detailClip.intTxt.text = total_score;
         this.detailClip.titleNameTxt.text = title;
      }
      
      private function setArenRank() : void
      {
         var rankList:Array = this.params.holyList;
         var data:Object = rankList[rankList.length - 1];
         if(Boolean(data))
         {
            this.detailClip.singleClip.gotoAndStop(this.rankToFrame(1,data.singleRank));
            this.detailClip.mulClip.gotoAndStop(this.rankToFrame(2,data.multiRank));
         }
      }
      
      public function rankToFrame(type:int, rank:int) : int
      {
         var id:int = 0;
         var obj:Object = null;
         if(type == 1)
         {
            for each(obj in this.transSingleList)
            {
               if(rank >= obj.low)
               {
                  if(obj.up != -1)
                  {
                     if(rank <= obj.up)
                     {
                        id = int(obj.id);
                     }
                  }
                  else
                  {
                     id = int(obj.id);
                  }
               }
            }
         }
         else
         {
            for each(obj in this.transMulList)
            {
               if(rank >= obj.low)
               {
                  if(obj.up != -1)
                  {
                     if(rank <= obj.up)
                     {
                        id = int(obj.id);
                     }
                  }
                  else
                  {
                     id = int(obj.id);
                  }
               }
            }
         }
         return id;
      }
      
      private function isTmd() : void
      {
         if(this.checkParams.userId == uint(GlobalConfig.userId))
         {
            this.detailClip.tmdClip.gotoAndStop(3);
            this.initToMyCoord();
            this.detailClip.beizhuBtn.visible = false;
            this.detailClip.checkNameBtn.visible = true;
         }
         else
         {
            this.detailClip.checkNameBtn.visible = false;
            if(this.checkParams.isFriend == 1)
            {
               this.detailClip.beizhuBtn.visible = true;
               this.detailClip.tmdClip.gotoAndStop(1);
               this.initToOldCoord();
            }
            else
            {
               this.detailClip.beizhuBtn.visible = false;
               this.detailClip.tmdClip.gotoAndStop(2);
               this.initToNewCoord();
            }
         }
      }
      
      public function onModifyBeiZhuBack() : void
      {
         TextField(this.detailClip.beizhuTxt).mouseEnabled = false;
         this.detailClip.beizhuBg.visible = false;
         this.detailClip.beizhuBtn.visible = true;
         stage.focus = null;
      }
      
      private function initToNewCoord() : void
      {
         this.detailClip.nameTxt.y = 36.6;
         this.detailClip.btnchange.y = 30.2;
         this.detailClip.changnamemc.y = 36.6;
         this.detailClip.beizhuTxt.y = 50.6;
         this.detailClip.beizhuBtn.y = 46.3;
         this.detailClip.beizhuBg.y = 49.6;
         this.detailClip.idTxt.y = 64.5;
         this.detailClip.titleTxt.y = 89.4;
         this.detailClip.titleBtn.y = 103.1;
      }
      
      private function initToMyCoord() : void
      {
         this.detailClip.nameTxt.y = 33.6;
         this.detailClip.btnchange.y = 27.2;
         this.detailClip.changnamemc.y = 33.6;
         this.detailClip.beizhuTxt.y = 50.6;
         this.detailClip.beizhuBtn.y = 46.3;
         this.detailClip.beizhuBg.y = 49.6;
         this.detailClip.idTxt.y = 54.5;
         this.detailClip.titleTxt.y = 95.4;
         this.detailClip.titleBtn.y = 109.1;
      }
      
      private function initToOldCoord() : void
      {
         this.detailClip.nameTxt.y = 28.6;
         this.detailClip.btnchange.y = 22.2;
         this.detailClip.changnamemc.y = 28.6;
         this.detailClip.beizhuTxt.y = 50.6;
         this.detailClip.beizhuBtn.y = 46.3;
         this.detailClip.beizhuBg.y = 49.6;
         this.detailClip.idTxt.y = 72.5;
         this.detailClip.titleTxt.y = 94.4;
         this.detailClip.titleBtn.y = 108.1;
      }
      
      private function filterHasBeat() : void
      {
         this.filterInShowBossList();
         this.bossList.length = 0;
         this.bossList = this.bossShowList;
         this.bossList.sortOn("time",Array.NUMERIC);
         this.list.dataProvider = this.bossList;
      }
      
      private function filterInShowBossList() : void
      {
         var obj:Object = null;
         var o:Object = null;
         for each(obj in this.bossShowList)
         {
            if(this.bossList.indexOf(obj.id) != -1)
            {
               obj.flag = 1;
            }
            else
            {
               obj.flag = 0;
            }
            if(obj.hasOwnProperty("idList"))
            {
               for each(o in obj.idList)
               {
                  if(this.bossList.indexOf(o) != -1)
                  {
                     obj.flag = 1;
                  }
               }
            }
         }
      }
      
      private function caluExp() : void
      {
         var nextLevelneedExp:int = int(this.levelList[this.params.level - 1]);
         this.detailClip.expTxt.text = this.params.exp + "/" + nextLevelneedExp;
         var frame:int = Math.round(this.params.exp / nextLevelneedExp * 100);
         if(frame <= 0)
         {
            frame = 1;
         }
         if(frame > 100)
         {
            frame = 100;
         }
         this.detailClip.expClip.gotoAndStop(frame);
      }
      
      public function close(evt:MouseEvent = null) : void
      {
         clearTimeout(this.dtid);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this.titlelist.visible = false;
         Tweener.removeAllTweens();
      }
      
      override public function disport() : void
      {
         clearTimeout(this.dtid);
         Tweener.removeAllTweens();
         CacheUtil.deleteObject(PersonInfoDetailView);
         ApplicationFacade.getInstance().removeViewLogic(PersonDetailInfoControl.NAME);
         this.titlelist.disport();
         super.disport();
      }
      
      private function initBadgeCompare() : void
      {
         this.detailClip.badgeCompareBtn.visible = Boolean(this.checkParams.userId != GameData.instance.playerData.userId);
         this.detailClip.badgeCompareBtn.gotoAndStop(1);
         for(var i:int = 0; i < 5; i++)
         {
            this.detailClip.badgeCompareMc["myName" + i].text = "";
            this.detailClip.badgeCompareMc["hisName" + i].text = "";
            this.detailClip.badgeCompareMc["myStart" + i].text = "";
            this.detailClip.badgeCompareMc["hisStart" + i].text = "";
            this.detailClip.badgeCompareMc["myBar" + i].gotoAndStop(1);
            this.detailClip.badgeCompareMc["hisBar" + i].gotoAndStop(1);
         }
         this.downBadgeCompare = false;
      }
      
      private function badgeCompareHandler(evt:MouseEvent) : void
      {
         if(this.downBadgeCompare)
         {
            return;
         }
         this.downBadgeCompare = true;
         if(this.detailClip.badgeCompareMc.myName0.text == "")
         {
            this.dispatchEvent(new MessageEvent(EventConst.GET_BADGE_DATA,this.checkParams.userId));
            this.dispatchEvent(new MessageEvent(EventConst.GET_BADGE_DATA,GameData.instance.playerData.userId));
         }
         var infoPanel:PersonInfoPanel = CacheUtil.getObject(PersonInfoPanel) as PersonInfoPanel;
         if(Boolean(this.detailClip.badgeCompareMc.visible))
         {
            Tweener.addTween(this.detailClip.badgeCompareMc,{
               "x":134,
               "time":1.5,
               "onComplete":this.tweenCompHandler
            });
            Tweener.addTween(infoPanel,{
               "alpha":1,
               "time":1.5
            });
         }
         else
         {
            this.detailClip.badgeCompareMc.visible = true;
            Tweener.addTween(this.detailClip.badgeCompareMc,{
               "x":-180,
               "time":1.5,
               "onComplete":this.tweenCompHandler
            });
            Tweener.addTween(infoPanel,{
               "alpha":0,
               "time":1.5
            });
         }
      }
      
      private function tweenCompHandler() : void
      {
         this.detailClip.badgeCompareBtn.gotoAndStop(2);
         if(this.detailClip.badgeCompareMc.x == 134)
         {
            this.detailClip.badgeCompareMc.visible = false;
            this.detailClip.badgeCompareBtn.gotoAndStop(1);
         }
         this.downBadgeCompare = false;
      }
      
      public function onGetBadgeDataBack(params:Object) : void
      {
         var i:int = 0;
         var list:Array = [64,19,17,18,14];
         if(params.userId == GameData.instance.playerData.userId)
         {
            for(i = 0; i < 5; i++)
            {
               this.detailClip.badgeCompareMc["myName" + i].text = "" + GameData.instance.playerData.userName;
               this.detailClip.badgeCompareMc["myStart" + i].text = params.badgeList[0].mapList[i].value + "/" + list[i];
               this.detailClip.badgeCompareMc["myBar" + i].gotoAndStop(int(100 * params.badgeList[0].mapList[i].value / list[i]));
            }
         }
         else if(params.userId == this.checkParams.userId)
         {
            for(i = 0; i < 5; i++)
            {
               this.detailClip.badgeCompareMc["hisName" + i].text = "" + this.checkParams.userName;
               this.detailClip.badgeCompareMc["hisStart" + i].text = params.badgeList[0].mapList[i].value + "/" + list[i];
               this.detailClip.badgeCompareMc["hisBar" + i].gotoAndStop(int(100 * params.badgeList[0].mapList[i].value / list[i]));
            }
         }
      }
   }
}

