package com.game.modules.view.menology
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.control.menology.MenologyControl;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.gameexchange.EnterDoorView;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.DateUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.events.InterfaceEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class MenologyView extends HLoaderSprite
   {
      
      private var duihuanlist:TileList;
      
      private var today:int;
      
      private var zhanbuloader:Loader;
      
      private var activity:Activity;
      
      private var mydate:DateUtil;
      
      private var minute:int;
      
      public var score:int;
      
      public var getzhanbu:int;
      
      public var time:int;
      
      public var present:int;
      
      private var waittime:int;
      
      private var todayarr:Array = [{
         "x":677.9,
         "y":264.9
      },{
         "x":677.9,
         "y":326.9
      },{
         "x":677.9,
         "y":390.8
      },{
         "x":677.9,
         "y":453.8
      },{
         "x":561.6,
         "y":294.9
      },{
         "x":561.6,
         "y":356.9
      },{
         "x":561.6,
         "y":420.8
      }];
      
      private var duihuanarr:Array = [100028,100003,100013,151];
      
      private var duihuanobj:Array = [{
         "name":"幻法灵石*1",
         "money":50
      },{
         "name":"白银葫芦*1",
         "money":80
      },{
         "name":"洗髓丹*1",
         "money":100
      },{
         "name":"妖怪一个",
         "money":120
      }];
      
      private var zhanbuarr:Array = [{
         "name":"神明果",
         "id":300030
      },{
         "name":"小历练丹",
         "id":100024
      },{
         "name":"娱乐币",
         "id":100030
      },{
         "name":"白银葫芦",
         "id":100003
      },{
         "name":"大历练丹",
         "id":100023
      },{
         "name":"洗髓丹",
         "id":100013
      }];
      
      private var _opType:Array;
      
      private var _opValue:Array;
      
      private var entercode:int;
      
      private var temp:int = 0;
      
      private var bol:Boolean = true;
      
      private var mytimer:Timer;
      
      private var checktime:Boolean;
      
      public function MenologyView()
      {
         super();
         GreenLoading.loading.visible = true;
         this.url = "assets/menology/Menology.swf";
      }
      
      private function onGo(evt:MouseEvent) : void
      {
         var index:int = int(evt.currentTarget.name.substring(5));
         if(Boolean(this._opType) && this._opType.length > 0)
         {
            this.doOnGo(index);
         }
      }
      
      private function doOnGo(index:int) : void
      {
         var gotoUrl:String = null;
         if(this._opType[index] == 1)
         {
            if(index <= this._opValue.length && this._opValue[index] > 0)
            {
               this.enterScene(this._opValue[index]);
            }
         }
         else if(this._opType[index] == 2)
         {
            gotoUrl = String(this._opValue[index]);
            ApplicationFacade.getInstance().dispatch(EventConst.CLEARUI);
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
               "url":gotoUrl,
               "xCoord":0,
               "yCoord":0
            });
         }
         else if(this._opType[index] == 3)
         {
            this.gotoFarm();
         }
         else if(this._opType[index] == 4)
         {
            this.gotoGameHall();
         }
         else if(this._opType[index] == 5)
         {
            this.gotoMall();
         }
      }
      
      private function gotoFarm() : void
      {
         GameData.instance.playerData["enterFarmFlag"] = true;
         ApplicationFacade.getInstance().dispatch(EventConst.ENTERSHENSHOU);
         this.disport();
      }
      
      private function gotoGameHall() : void
      {
         if(URLUtil["gamehallweihu"] == "true")
         {
            new Alert().show("亲爱的小卡布，游戏大厅维护中哦~~请稍候再来~");
            return;
         }
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":-5
         },null,getQualifiedClassName(EnterDoorView));
      }
      
      private function gotoMall() : void
      {
         FaceView.clip.dispatchEvent(new InterfaceEvent(InterfaceEvent.FACECLIPCLICK,{"code":41}));
      }
      
      private function xmlLoader(xml:XML) : void
      {
         var i:int = 0;
         var element:XML = null;
         if(Boolean(xml))
         {
            this._opType = [];
            this._opValue = [];
            i = 1;
            for each(element in xml.elements("node"))
            {
               this._opType[i] = element.@opType;
               this._opValue[i] = element.@opValue;
               i++;
            }
         }
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         this.zhanbuloader = new Loader();
         this.zhanbuloader.x = 5;
         this.zhanbuloader.y = -50;
         this.bg["newmc"].addChild(this.zhanbuloader);
         this.bg["newmc"].visible = false;
         this.stopmc();
         this.initDate();
         this.initTxt();
         this.initAct();
         this.initList();
         this.initEvents();
         ApplicationFacade.getInstance().registerViewLogic(new MenologyControl(this));
         GreenLoading.loading.visible = false;
      }
      
      private function stopmc() : void
      {
         this.bg.zhanbumc.gotoAndStop(1);
         for(var i:int = 1; i < 8; i++)
         {
            this.bg["actmc" + i].gotoAndStop(1);
            this.bg["actmc" + i].buttonMode = true;
         }
      }
      
      private function initTxt() : void
      {
         var tempday:Number = NaN;
         var maxday:Number = NaN;
         this.bg.zhanbumc.waittxt.visible = false;
         var xingqiarr:Array = ["五","六","日","一","二","三","四"];
         for(var j:int = 1; j < 8; j++)
         {
            this.bg["actmc" + j].gotoAndStop(1);
            this.bg["actmc" + j].txt2.text = "星期" + xingqiarr[j - 1];
         }
         var year:Number = this.mydate.getFullYear();
         var month:Number = this.mydate.getMonth() + 1;
         var day:Number = this.mydate.getDate();
         var xingqi:Number = this.mydate.getDay();
         var index:int = 1;
         if(xingqi == 0)
         {
            xingqi = 7;
         }
         this.today = xingqi;
         if(xingqi >= 5)
         {
            tempday = day - (xingqi - 5);
            maxday = day + (11 - xingqi);
         }
         else
         {
            tempday = day - (xingqi + 2);
            maxday = day + (4 - xingqi);
         }
         this.bg["todaymc"].x = this.todayarr[xingqi - 1].x;
         this.bg["todaymc"].y = this.todayarr[xingqi - 1].y;
         while(tempday <= 0)
         {
            if(month == 1)
            {
               month = 13;
            }
            this.bg["actmc" + index].txt1.text = month - 1 + "月" + (this.judgeDay(month - 1,year) - Math.abs(tempday)) + "日";
            tempday += 1;
            index += 1;
         }
         while(tempday > 0 && tempday <= maxday)
         {
            if(tempday > this.judgeDay(month,year))
            {
               if(month == 12 && tempday > 31)
               {
                  this.bg["actmc" + index].txt1.text = 1 + "月" + (tempday - this.judgeDay(month,year)) + "日";
               }
               else
               {
                  this.bg["actmc" + index].txt1.text = month + 1 + "月" + (tempday - this.judgeDay(month,year)) + "日";
               }
            }
            else
            {
               if(month == 13)
               {
                  month = 1;
               }
               this.bg["actmc" + index].txt1.text = month + "月" + tempday + "日";
            }
            tempday += 1;
            index += 1;
         }
      }
      
      private function judgeYear(year:Number) : Boolean
      {
         var bol:Boolean = false;
         if(year % 4 == 0 && year % 100 != 0 || year % 100 == 0)
         {
            bol = true;
         }
         else
         {
            bol = false;
         }
         return bol;
      }
      
      private function judgeDay(month:Number, year:Number) : Number
      {
         var num:Number = NaN;
         switch(month)
         {
            case 1:
               num = 31;
               break;
            case 3:
               num = 31;
               break;
            case 5:
               num = 31;
               break;
            case 7:
               num = 31;
               break;
            case 8:
               num = 31;
               break;
            case 10:
               num = 31;
               break;
            case 12:
               num = 31;
               break;
            case 4:
               num = 30;
               break;
            case 6:
               num = 30;
               break;
            case 9:
               num = 30;
               break;
            case 11:
               num = 30;
               break;
            case 2:
               if(this.judgeYear(year))
               {
                  num = 29;
               }
               else
               {
                  num = 28;
               }
         }
         return num;
      }
      
      private function initDate() : void
      {
         this.mydate = new DateUtil();
         var my_xingqi:Array = ["日","一","二","三","四","五","六"];
         var myhaoshu:Number = this.mydate.getDate();
         this.bg["datetxt1"].text = this.mydate.getFullYear() + "年" + (this.mydate.getMonth() + 1) + "月" + myhaoshu + "日";
         this.bg["datetxt2"].text = "星期" + my_xingqi[this.mydate.getDay()];
         this.bg["datetxt3"].text = this.mydate.getTaoJMonth() + "月" + this.mydate.getTaoJDay() + "日";
         this.bg["festivaltxt2"].text = this.mydate.getJieQi();
         this.bg["festivaltxt1"].text = this.mydate.getJieri();
         if(this.bg["festivaltxt2"].text == "" && this.bg["festivaltxt1"].text == "")
         {
            this.bg["festivaltxt1"].text = "节日";
         }
      }
      
      private function initAct() : void
      {
         this.activity = new Activity(this.getXmlDataBack);
         this.addChild(this.activity);
      }
      
      private function getXmlDataBack(actxml:XMLList) : void
      {
         var item:XML = null;
         for(var i:int = 1; i <= 5; i++)
         {
            bg["actname" + i].text = "";
            bg["actDesc" + i].text = "";
         }
         this._opType = [1,1,1,1,1,1,1];
         this._opValue = [];
         var tf:TextField = new TextField();
         var str:String = "";
         var reg:RegExp = /:|：/;
         var nameDesc:Array = [];
         var myhaoshu:Number = this.mydate.getDate();
         for each(item in actxml)
         {
            if(item.@id == myhaoshu)
            {
               this._opValue[1] = int(item.@sid1);
               this._opValue[2] = int(item.@sid2);
               this._opValue[3] = int(item.@sid3);
               this._opValue[4] = int(item.@sid4);
               this._opValue[5] = int(item.@sid5);
               tf.htmlText = item.txt1;
               str = tf.text;
               nameDesc = this.splitNameDesc(str,reg);
               bg.actname1.text = nameDesc[0];
               bg.actDesc1.text = nameDesc[1];
               tf.htmlText = item.txt2;
               str = tf.text;
               nameDesc = this.splitNameDesc(str,reg);
               bg.actname2.text = nameDesc[0];
               bg.actDesc2.text = nameDesc[1];
               tf.htmlText = item.txt3;
               str = tf.text;
               nameDesc = this.splitNameDesc(str,reg);
               bg.actname3.text = nameDesc[0];
               bg.actDesc3.text = nameDesc[1];
               tf.htmlText = item.txt4;
               str = tf.text;
               nameDesc = this.splitNameDesc(str,reg);
               bg.actname4.text = nameDesc[0];
               bg.actDesc4.text = nameDesc[1];
               tf.htmlText = item.txt5;
               str = tf.text;
               nameDesc = this.splitNameDesc(str,reg);
               bg.actname5.text = nameDesc[0];
               bg.actDesc5.text = nameDesc[1];
               break;
            }
         }
         trace("_opValue : " + this._opValue);
      }
      
      private function splitNameDesc(str:String, reg:RegExp) : Array
      {
         var list:Array = [];
         list = str.split(reg);
         if(list.length < 2)
         {
            list[0] = "";
            list[1] = "";
         }
         return list;
      }
      
      private function initList() : void
      {
         this.duihuanlist = new TileList(441.6,109.9);
         this.duihuanlist.build(4,1,65,65,9,9,DuihuanItem);
         bg.addChild(this.duihuanlist);
         this.setlist();
      }
      
      private function setlist() : void
      {
         this.duihuanlist.dataProvider = this.duihuanarr;
      }
      
      private function initEvents() : void
      {
         this.bg["closebtn"].addEventListener(MouseEvent.CLICK,this.onClickCloseHandler);
         for(var j:int = 1; j < 8; j++)
         {
            this.bg["actmc" + j].gotoAndStop(1);
            this.bg["actmc" + j].addEventListener(MouseEvent.CLICK,this.onActClick);
            this.bg["actmc" + j].addEventListener(MouseEvent.ROLL_OVER,this.onActOver);
            this.bg["actmc" + j].addEventListener(MouseEvent.ROLL_OUT,this.onActOut);
         }
         this.addEventListener(MouseEvent.CLICK,this.onCloseAct);
         for(var i:int = 1; i < 7; i++)
         {
            if(Boolean(this.bg.hasOwnProperty("gobtn" + i)))
            {
               this.bg["gobtn" + i].addEventListener(MouseEvent.MOUSE_DOWN,this.onGo);
            }
         }
      }
      
      private function enterScene(value:int) : void
      {
         GameData.instance.playerData.currentScenenId = value;
         if(Boolean(GameData.instance.playerData.bobOwner))
         {
            this.entercode = value;
            new Alert().showSureOrCancel("是否要离开擂台？",this.onCloseBobHandler);
            return;
         }
         if(GameData.instance.playerData.refineState)
         {
            new Alert().showSureOrCancel("确定停止炼制？",this.onRefineAlerClose);
            return;
         }
         ApplicationFacade.getInstance().dispatch(EventConst.ENTERSCENE,value);
         this.disport();
      }
      
      private function onCloseBobHandler(... rest) : void
      {
         if("确定" == rest[0])
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ENTERSCENE,this.entercode);
            this.disport();
         }
      }
      
      private function onRefineAlerClose(... rest) : void
      {
         if("确定" == rest[0])
         {
            GameData.instance.playerData.refineState = false;
            ApplicationFacade.getInstance().dispatch(EventConst.STOPREFINE);
            this.disport();
         }
      }
      
      private function removeEvents() : void
      {
         var j:int = 0;
         var i:int = 0;
         if(bg)
         {
            this.bg["closebtn"].removeEventListener(MouseEvent.CLICK,this.onClickCloseHandler);
            for(j = 1; j < 8; j++)
            {
               this.bg["actmc" + j].removeEventListener(MouseEvent.CLICK,this.onActClick);
               this.bg["actmc" + j].removeEventListener(MouseEvent.ROLL_OVER,this.onActOver);
               this.bg["actmc" + j].removeEventListener(MouseEvent.ROLL_OUT,this.onActOut);
            }
            this.removeEventListener(MouseEvent.CLICK,this.onCloseAct);
            for(i = 1; i < 5; i++)
            {
               if(Boolean(this.bg["duihuanbtn" + i].hasEventListener(MouseEvent.CLICK)))
               {
                  this.bg["duihuanbtn" + i].removeEventListener(MouseEvent.CLICK,this.onDuihuanClick);
               }
            }
            if(Boolean(this.bg["qiandaobtn"].hasEventListener(MouseEvent.CLICK)))
            {
               this.bg["qiandaobtn"].removeEventListener(MouseEvent.CLICK,this.onQiandaoClick);
            }
            if(Boolean(this.bg["zhanbubtn"].hasEventListener(MouseEvent.CLICK)))
            {
               this.bg["zhanbubtn"].removeEventListener(MouseEvent.CLICK,this.onZhanbuClick);
            }
            if(Boolean(this.bg["newmc"]["jieshoubtn"].hasEventListener(MouseEvent.CLICK)))
            {
               this.bg["newmc"]["jieshoubtn"].removeEventListener(MouseEvent.CLICK,this.onZhanburesult);
            }
            if(Boolean(this.bg["newmc"]["jujuebtn"].hasEventListener(MouseEvent.CLICK)))
            {
               this.bg["newmc"]["jujuebtn"].removeEventListener(MouseEvent.CLICK,this.onZhanburesult);
            }
         }
      }
      
      private function onDuihuanClick(evt:MouseEvent) : void
      {
         var flag:int = int(evt.currentTarget.name.substr(10,1));
         new Alert().showSureOrCancel("是否要用" + this.duihuanobj[flag - 1].money + "积分兑换" + this.duihuanobj[flag - 1].name,this.closeHandler,{"flag":flag});
      }
      
      private function closeHandler(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            this.dispatchEvent(new MenologyEvent(MenologyEvent.DUIHUAN,data.flag));
         }
      }
      
      private function onZhanbuClick(evt:MouseEvent) : void
      {
         this.dispatchEvent(new MenologyEvent(MenologyEvent.ZHANBU));
         this.getgray();
      }
      
      private function onQiandaoClick(evt:MouseEvent) : void
      {
         this.dispatchEvent(new MenologyEvent(MenologyEvent.QIANDAO));
      }
      
      private function onClickCloseHandler(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function onActClick(evt:MouseEvent) : void
      {
         var istoday:Boolean = false;
         evt.stopImmediatePropagation();
         var flag:int = int(evt.currentTarget.name.substr(5,1));
         if(this.temp == flag)
         {
            this.bol = true;
         }
         else
         {
            this.bol = false;
         }
         this.temp = flag;
         for(var j:int = 1; j < 8; j++)
         {
            this.bg["actmc" + j].gotoAndStop(1);
         }
         if(evt.currentTarget.currentFrame == 1)
         {
            evt.currentTarget.gotoAndStop(2);
         }
         else
         {
            evt.currentTarget.gotoAndStop(1);
         }
         if(this.bol == false)
         {
            if(flag <= 3)
            {
               flag += 4;
            }
            else
            {
               flag -= 3;
            }
            istoday = flag == this.today ? true : false;
            this.activity.showbg(istoday,String(evt.currentTarget.txt1.text),String(evt.currentTarget.txt2.text),flag);
         }
         else
         {
            this.activity.hidebg();
            this.temp = 0;
         }
      }
      
      private function onActOver(evt:MouseEvent) : void
      {
         var istoday:Boolean = false;
         evt.stopImmediatePropagation();
         var flag:int = int(evt.currentTarget.name.substr(5,1));
         if(this.temp == flag)
         {
            this.bol = true;
         }
         else
         {
            this.bol = false;
         }
         this.temp = flag;
         for(var j:int = 1; j < 8; j++)
         {
            this.bg["actmc" + j].gotoAndStop(1);
         }
         if(evt.currentTarget.currentFrame == 1)
         {
            evt.currentTarget.gotoAndStop(2);
         }
         else
         {
            evt.currentTarget.gotoAndStop(1);
         }
         if(flag <= 3)
         {
            flag += 4;
         }
         else
         {
            flag -= 3;
         }
         istoday = flag == this.today ? true : false;
         this.activity.showbg(istoday,String(evt.currentTarget.txt1.text),String(evt.currentTarget.txt2.text),flag);
      }
      
      private function onActOut(evt:MouseEvent) : void
      {
         this.activity.hidebg();
         this.temp = 0;
      }
      
      private function onCloseAct(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.bol == false)
         {
            this.activity.bg.visible = false;
            this.temp = 0;
         }
      }
      
      private function onZhanburesult(evt:MouseEvent) : void
      {
         var flag:int = 0;
         switch(evt.currentTarget.name)
         {
            case "jieshoubtn":
               flag = 1;
               break;
            case "jujuebtn":
               flag = 0;
         }
         this.dispatchEvent(new MenologyEvent(MenologyEvent.ZHANBUJIEGUO,flag));
      }
      
      public function initDuihuan(updatearr:Array) : void
      {
         var arr:Array = null;
         var i:int = 0;
         var len:int = 0;
         var j:int = 0;
         var len2:int = 0;
         var k:int = 0;
         if(updatearr == null)
         {
            arr = [];
            for(i = 1; i < 5; i++)
            {
               this.bg["duihuanbtn" + i].removeEventListener(MouseEvent.CLICK,this.onDuihuanClick);
               this.bg["duihuanbtn" + i].filters = ColorUtil.getColorMatrixFilterGray();
               this.bg["duihuanbtn" + i].mouseEnabled = false;
            }
            if(this.score >= 50)
            {
               arr.push(1);
            }
            if(this.score >= 80)
            {
               arr.push(2);
            }
            if(this.score >= 100)
            {
               arr.push(3);
            }
            if(this.score >= 120)
            {
               arr.push(4);
            }
            len = int(arr.length);
            for(j = 0; j < len; j++)
            {
               this.bg["duihuanbtn" + arr[j]].addEventListener(MouseEvent.CLICK,this.onDuihuanClick);
               this.bg["duihuanbtn" + arr[j]].filters = [];
               this.bg["duihuanbtn" + arr[j]].mouseEnabled = true;
            }
         }
         else
         {
            len2 = int(updatearr.length);
            for(k = 0; k < len2; k++)
            {
               this.bg["duihuanbtn" + updatearr[k]].removeEventListener(MouseEvent.CLICK,this.onDuihuanClick);
               this.bg["duihuanbtn" + updatearr[k]].filters = ColorUtil.getColorMatrixFilterGray();
               this.bg["duihuanbtn" + updatearr[k]].mouseEnabled = false;
            }
         }
      }
      
      public function showpresent(value:int) : void
      {
         if(Boolean(this.duihuanobj[value - 1]))
         {
            new Alert().showOne("成功获得" + this.duihuanobj[value - 1].name);
            this.score -= this.duihuanobj[value - 1].money;
            this.bg["duihuanbtn" + value].removeEventListener(MouseEvent.CLICK,this.onDuihuanClick);
            this.bg["duihuanbtn" + value].filters = ColorUtil.getColorMatrixFilterGray();
            this.bg["duihuanbtn" + value].mouseEnabled = false;
            this.initJifen(this.score);
         }
      }
      
      public function initJifen(value:int) : void
      {
         if(value != -1)
         {
            this.score = value;
         }
         this.bg["jifentxt"].text = "累计积分：" + this.score + "分";
      }
      
      public function initZhanbu(value:int) : void
      {
         var url:String = null;
         if(value > 0)
         {
            this.bg["zhanbubtn"].removeEventListener(MouseEvent.CLICK,this.onZhanbuClick);
            this.bg["zhanbubtn"].filters = ColorUtil.getColorMatrixFilterGray();
            this.bg["zhanbubtn"].mouseEnabled = false;
            if(this.getzhanbu == 0)
            {
               this.bg["zhanbumc"].visible = false;
               this.bg["newmc"].visible = true;
               this.bg["newmc"]["jieshoubtn"].filters = [];
               this.bg["newmc"]["jieshoubtn"].addEventListener(MouseEvent.CLICK,this.onZhanburesult);
               this.bg["newmc"]["jieshoubtn"].mouseEnabled = true;
               this.bg["newmc"]["jujuebtn"].filters = [];
               this.bg["newmc"]["jujuebtn"].addEventListener(MouseEvent.CLICK,this.onZhanburesult);
               this.bg["newmc"]["jujuebtn"].mouseEnabled = true;
            }
            else
            {
               this.bg["zhanbumc"].visible = false;
               this.bg["newmc"].visible = true;
               this.bg["newmc"].txt.text = "你今天已经占卜过了，明天再来吧。";
               this.bg["newmc"]["jieshoubtn"].filters = ColorUtil.getColorMatrixFilterGray();
               this.bg["newmc"]["jieshoubtn"].removeEventListener(MouseEvent.CLICK,this.onZhanburesult);
               this.bg["newmc"]["jieshoubtn"].mouseEnabled = false;
               this.bg["newmc"]["jujuebtn"].filters = ColorUtil.getColorMatrixFilterGray();
               this.bg["newmc"]["jujuebtn"].removeEventListener(MouseEvent.CLICK,this.onZhanburesult);
               this.bg["newmc"]["jujuebtn"].mouseEnabled = false;
            }
            if(value == 1)
            {
               this.bg["newmc"]["jieguobtn"].gotoAndStop(3);
            }
            if(value >= 2 && value <= 4)
            {
               this.bg["newmc"]["jieguobtn"].gotoAndStop(2);
            }
            if(value >= 5 && value <= 6)
            {
               this.bg["newmc"]["jieguobtn"].gotoAndStop(1);
            }
            url = URLUtil.getSvnVer("assets/tool/" + this.zhanbuarr[value - 1].id + ".swf");
            try
            {
               this.zhanbuloader.unload();
               this.zhanbuloader.load(new URLRequest(url));
            }
            catch(e:*)
            {
            }
            this.setToolTip(this.zhanbuarr[value - 1].id);
         }
         else
         {
            this.bg["zhanbumc"].visible = true;
            this.bg.zhanbumc.waittxt.visible = false;
            this.bg["newmc"].visible = false;
            this.bg["zhanbumc"].gotoAndStop(1);
            this.bg["zhanbubtn"].addEventListener(MouseEvent.CLICK,this.onZhanbuClick);
            this.bg["zhanbubtn"].filters = [];
            this.bg["zhanbubtn"].mouseEnabled = true;
         }
      }
      
      public function getgray() : void
      {
         this.bg["zhanbubtn"].removeEventListener(MouseEvent.CLICK,this.onZhanbuClick);
         this.bg["zhanbubtn"].filters = ColorUtil.getColorMatrixFilterGray();
         this.bg["zhanbubtn"].mouseEnabled = false;
      }
      
      private function setToolTip(idx:int) : void
      {
         var xml:XML = null;
         var desc:String = "";
         xml = XMLLocator.getInstance().getTool(idx);
         desc += HtmlUtil.getHtmlText(12,"#FF0000","名称: ");
         desc += HtmlUtil.getHtmlText(12,"#000000",xml.name) + "\n";
         desc += HtmlUtil.getHtmlText(12,"#000000",xml.desc) + "\n";
         ToolTip.BindDO(this.zhanbuloader,desc);
      }
      
      public function initZhanbuback(result:int, present:int) : void
      {
         if(present != 0)
         {
            new Alert().showOne("获得" + this.zhanbuarr[present - 1].name);
            this.bg["newmc"].txt.text = "你今天已经占卜过了，明天再来吧。";
            this.bg["newmc"]["jieshoubtn"].filters = ColorUtil.getColorMatrixFilterGray();
            this.bg["newmc"]["jieshoubtn"].removeEventListener(MouseEvent.CLICK,this.onZhanburesult);
            this.bg["newmc"]["jieshoubtn"].mouseEnabled = false;
            this.bg["newmc"]["jujuebtn"].filters = ColorUtil.getColorMatrixFilterGray();
            this.bg["newmc"]["jujuebtn"].removeEventListener(MouseEvent.CLICK,this.onZhanburesult);
            this.bg["newmc"]["jujuebtn"].mouseEnabled = false;
         }
         if(present == 0)
         {
            this.initZhanbu(0);
         }
      }
      
      public function initQiandao(value:int) : void
      {
         if(value == 0)
         {
            this.bg["qiandaobtn"].addEventListener(MouseEvent.CLICK,this.onQiandaoClick);
            this.bg["qiandaobtn"].filters = [];
            this.bg["qiandaobtn"].mouseEnabled = true;
         }
         else
         {
            this.bg["qiandaobtn"].removeEventListener(MouseEvent.CLICK,this.onQiandaoClick);
            this.bg["qiandaobtn"].filters = ColorUtil.getColorMatrixFilterGray();
            this.bg["qiandaobtn"].mouseEnabled = false;
         }
      }
      
      public function initTime(value:int) : void
      {
         this.getgray();
         if(value != 0)
         {
            this.bg.zhanbumc.gotoAndStop(1);
            value = Math.ceil(value / 60);
            this.bg.zhanbumc.waittxt.visible = true;
            this.bg.zhanbumc.waittxt.text = "请静待" + value + "分钟";
            this.minute = value;
            this.mytimer = new Timer(60000,value);
            this.mytimer.addEventListener(TimerEvent.TIMER,this.ontime);
            this.mytimer.start();
         }
         else
         {
            this.initZhanbu(this.present);
         }
      }
      
      private function ontime(e:TimerEvent) : void
      {
         this.minute -= 1;
         if(this.minute == 0)
         {
            this.mytimer.removeEventListener(TimerEvent.TIMER,this.ontime);
            this.mytimer.stop();
            this.mytimer = null;
            this.dispatchEvent(new MenologyEvent(MenologyEvent.CHECKTIME));
            return;
         }
         if(this.bg["zhanbumc"].visible == true && Boolean(this.bg["zhanbumc"].hasOwnProperty("waittxt")))
         {
            this.bg.zhanbumc.waittxt.text = "请静待" + this.minute + "分钟";
         }
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(MenologyView);
         ApplicationFacade.getInstance().removeViewLogic(MenologyControl.NAME);
         if(Boolean(this.duihuanlist) && Boolean(this.bg.contains(this.duihuanlist)))
         {
            this.bg.removeChild(this.duihuanlist);
            this.duihuanlist.dataProvider = [];
            this.duihuanlist = null;
         }
         this.removeEvents();
         if(Boolean(this.zhanbuloader))
         {
            this.zhanbuloader.unloadAndStop(false);
         }
         this.zhanbuloader = null;
         this.todayarr = null;
         this.duihuanarr = null;
         this.duihuanobj = null;
         this.zhanbuarr = null;
         this.mydate = null;
         if(Boolean(this.activity))
         {
            this.activity.disport();
         }
         this.activity = null;
         if(Boolean(this.mytimer) && this.mytimer.hasEventListener(TimerEvent.TIMER))
         {
            this.mytimer.removeEventListener(TimerEvent.TIMER,this.ontime);
         }
         this.mytimer = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

