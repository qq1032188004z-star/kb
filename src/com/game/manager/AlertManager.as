package com.game.manager
{
   import com.game.modules.view.WindowLayer;
   import com.game.util.AnnouncementAlert;
   import com.game.util.AwardAlert;
   import com.game.util.FloatAlert;
   import com.game.util.HtmlUtil;
   import com.game.util.PropertyPool;
   import com.game.util.ToolTipStringUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.alert.AlertContainer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class AlertManager
   {
      
      private static var _instance:AlertManager;
      
      public static const sureBtn:String = "确定";
      
      public static const cancelBtn:String = "取消";
      
      public static const acceptBtn:String = "接受";
      
      public static const refuseBtn:String = "拒绝";
      
      private var _alertQueue:Array;
      
      private var _isAlert:Boolean;
      
      private var alertList:Array = [];
      
      private var tipsList:Array = [];
      
      private var replaceRegExp:RegExp = /replaceStr/g;
      
      private var replaceRegExp1:RegExp = /replaceNum/g;
      
      private var timestate:Boolean = false;
      
      private var ttid:int = 0;
      
      public function AlertManager()
      {
         super();
         if(_instance != null)
         {
            throw new Error("提示类是单例类,已经实例化了.");
         }
         this._alertQueue = [];
      }
      
      public static function get instance() : AlertManager
      {
         if(_instance == null)
         {
            _instance = new AlertManager();
         }
         return _instance;
      }
      
      public function addTipAlert(obj:Object) : void
      {
         if(obj == null)
         {
            return;
         }
         if(!obj.hasOwnProperty("speed"))
         {
            obj.speed = 3.5;
         }
         if(!obj.hasOwnProperty("floatDistance"))
         {
            obj.floatDistance = 150;
         }
         this.showTips(obj);
      }
      
      public function showTipAlert(obj:Object) : void
      {
         if(obj == null)
         {
            return;
         }
         if(!obj.hasOwnProperty("flag"))
         {
            obj.flag = 0;
         }
         if(!obj.hasOwnProperty("params"))
         {
            obj.params = 0;
         }
         if(!obj.hasOwnProperty("speed"))
         {
            obj.speed = 3.5;
         }
         if(!obj.hasOwnProperty("floatDistance"))
         {
            obj.floatDistance = 150;
         }
         this.alertList.push(obj);
         this.alertList.sortOn(Array.NUMERIC);
         var arr:Array = [];
         var i:int = 0;
         var len:int = int(this.alertList.length);
         for(i = 0; i < len; i++)
         {
            arr.push(this.alertList[i].systemid);
         }
         PropertyPool.instance.getXMLList("assets/alertTips/",arr,this.loadPropsListBack,this.alertList);
      }
      
      private function loadPropsListBack(arr:Array) : void
      {
         var xml:XML = null;
         var tempXML:XML = null;
         var subXML:XML = null;
         var i:int = 0;
         var len:int = int(this.alertList.length);
         var param:Object = {};
         while(len > 0)
         {
            param = this.alertList.shift();
            xml = PropertyPool.instance.getSpecifiedProp(String(param.systemid)) as XML;
            if(xml == null)
            {
               O.o("该模块的配置没加载进来：",param.systemid);
               return;
            }
            tempXML = xml.children().(@systemid == param.systemid)[0] as XML;
            subXML = this.getItemByFlag(tempXML,param.flag);
            if(subXML == null)
            {
               if(Boolean(param.defaultTip))
               {
                  subXML = tempXML.children().(@flag == -1000)[0] as XML;
               }
            }
            this.searchTips(subXML,param);
            len = int(this.alertList.length);
         }
         if(!this.timestate)
         {
            this.timestate = true;
            this.doFloadtAlert();
         }
      }
      
      private function getItemByFlag(xml:XML, flag:int) : XML
      {
         var item:XML = null;
         for each(item in xml.children())
         {
            if(int(item.@flag) == flag)
            {
               return item;
            }
         }
         return null;
      }
      
      private function searchTips(xml:XML, obj:Object) : void
      {
         var i:int = 0;
         var len:int = 0;
         var tempStr:String = null;
         var tempStr1:String = null;
         if(obj == null || xml == null)
         {
            O.o("在指定XML里查找不到提示",obj,xml);
            return;
         }
         if(!this.checkTipsFromXML(xml,obj))
         {
            if(Boolean(obj.defaultTip))
            {
               obj.params = -1000;
               O.o("params 开启默认提示",obj.defaultTip,obj.params);
            }
         }
         var data:Object = {};
         if(xml.children().length() > 0)
         {
            i = 0;
            len = int(xml.children().length());
            for(i = 0; i < len; i++)
            {
               if(xml.children()[i].@params == obj.params)
               {
                  data.type = int(xml.children()[i].@type);
                  if(Boolean(xml.children()[i].hasOwnProperty("tipType")))
                  {
                     data.tip = String(xml.children()[i].tip).replace(/[\n]/g,"").replace(/([\s\r\n　]+)(?=<)|(?<=<)([\s\r\n　]+)/g,"").replace(/([\s\r\n　]+)(?=>)|(?<=>)([\s\r\n　]+)/g,"");
                  }
                  else
                  {
                     data.tip = String(xml.children()[i].tip);
                  }
                  obj.replace = String(obj.replace);
                  obj.replaceNum = String(obj.replaceNum);
                  if(obj.replace != null)
                  {
                     tempStr = data.tip;
                     data.tip = tempStr.replace(this.replaceRegExp,obj.replace);
                  }
                  if(Boolean(obj.replaceNum))
                  {
                     tempStr1 = data.tip;
                     data.tip = tempStr1.replace(this.replaceRegExp1,obj.replaceNum);
                  }
                  if(Boolean(obj.stage))
                  {
                     data.stage = obj.stage;
                  }
                  if(Boolean(obj.callback))
                  {
                     data.callback = obj.callback;
                  }
                  if(Boolean(obj.data))
                  {
                     data.data = obj.data;
                  }
                  if(Boolean(obj.speed))
                  {
                     data.speed = obj.speed;
                  }
                  if(Boolean(obj.floatDistance))
                  {
                     data.floatDistance = obj.floatDistance;
                  }
                  this.tipsList.push(data);
               }
            }
         }
      }
      
      private function checkTipsFromXML(xml:XML, obj:Object) : Boolean
      {
         var i:int = 0;
         var len:int = 0;
         if(xml.children().length() > 0)
         {
            i = 0;
            len = int(xml.children().length());
            for(i = 0; i < len; i++)
            {
               if(xml.children()[i].@params == obj.params)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function doFloadtAlert() : void
      {
         var xml:XML = null;
         var obj:Object = null;
         if(this.tipsList.length > 0)
         {
            clearTimeout(this.ttid);
            this.ttid = setTimeout(this.doFloadtAlert,1000);
         }
         else
         {
            this.timestate = false;
         }
         if(this.tipsList.length > 0)
         {
            this.timestate = true;
            obj = this.tipsList.shift() as Object;
            this.showTips(obj);
         }
      }
      
      private function showTips(obj:Object) : void
      {
         var showX:Number = NaN;
         var showY:Number = NaN;
         if(!obj.hasOwnProperty("data"))
         {
            obj["data"] = null;
         }
         if(!obj.hasOwnProperty("type"))
         {
            obj["type"] = 1;
         }
         switch(obj.type)
         {
            case 1:
               showX = obj.hasOwnProperty("showX") ? Number(obj["showX"]) : 265;
               showY = obj.hasOwnProperty("showY") ? Number(obj["showY"]) : 400;
               if(Boolean(obj.stage))
               {
                  new FloatAlert().show(obj.stage,showX,showY,obj.tip,obj.speed,obj.floatDistance);
               }
               else
               {
                  new FloatAlert().show(AlertContainer.instance.stage,showX,showY,obj.tip,obj.speed,obj.floatDistance);
               }
               break;
            case 2:
               this._alertQueue.push(obj);
               this.onShowAlert();
               break;
            case 3:
               new Alert().showOne(obj.tip,obj.callback,obj.data);
               break;
            case 4:
               new Alert().showVip(obj.tip);
               break;
            case 5:
               new Alert().showSureOrCancel(obj.tip,obj.callback,obj.data);
               break;
            case 6:
               new Alert().showAcceptOrRefuse(obj.tip,obj.callback,obj.data);
               break;
            case 7:
               new Alert().showBattleOrNo(obj.tip,obj.callback);
               break;
            case 8:
               new Alert().showSureLink(obj.tip,obj.callback,obj.data);
               break;
            case 9:
               new AnnouncementAlert().show(WindowLayer.instance,220,125,obj.tip,obj.speed);
         }
      }
      
      private function onShowAlert() : void
      {
         var obj:Object = null;
         if(!this._isAlert && this._alertQueue.length > 0)
         {
            obj = this._alertQueue.shift();
            new Alert().show(obj.tip,this.onQueueBack,obj);
            this._isAlert = true;
         }
      }
      
      private function onQueueBack(... arg) : void
      {
         var obj:Object = arg[1];
         if(obj.hasOwnProperty("callback"))
         {
            obj.callback.apply(null,[arg[0]]);
         }
         this._isAlert = false;
         this.onShowAlert();
      }
      
      public function showAwardAlertList(list:Array) : void
      {
         var obj:Object = null;
         var len:int = int(list.length);
         while(len > 0)
         {
            obj = list.shift() as Object;
            if(Boolean(obj))
            {
               this.showAwardAlert(obj);
            }
            len = int(list.length);
         }
      }
      
      public function showAwardAlert(obj:Object) : void
      {
         var url:String = null;
         var name:String = null;
         if(obj.arrows == null)
         {
            obj.arrows = true;
         }
         if(obj.stage == null)
         {
            obj.stage = WindowLayer.instance.stage;
         }
         if(Boolean(obj.money))
         {
            new AwardAlert().showMoneyAward(obj.money,obj.stage,obj.callback);
         }
         if(Boolean(obj.exp))
         {
            new AwardAlert().showExpAward(obj.exp,obj.stage,obj.callback);
         }
         if(Boolean(obj.toolid))
         {
            url = "assets/tool/" + obj.toolid + ".swf";
            name = ToolTipStringUtil.getToolName(obj.toolid);
            if(name == null)
            {
               name = obj.name;
            }
            if(obj.num == null)
            {
               new AwardAlert().showGoodsAward(url,obj.stage,"获得 " + HtmlUtil.getHtmlText(14,"#FF0000",name),obj.arrows,obj.callback);
            }
            else
            {
               new AwardAlert().showGoodsAward(url,obj.stage,"获得 " + HtmlUtil.getHtmlText(14,"#FF0000",name) + "*" + obj.num,obj.arrows,obj.callback);
            }
         }
         if(Boolean(obj.monsterid))
         {
            url = "assets/monsterimg/" + obj.monsterid + ".swf";
            name = ToolTipStringUtil.getSpriteName(obj.monsterid);
            new AwardAlert().showMonsterAward(url,obj.stage,"获得 " + HtmlUtil.getHtmlText(14,"#FF0000",name),obj.arrows);
         }
      }
      
      public function showAwardAlertListEX($list:Array) : void
      {
         var i:int = 0;
         var obj:Object = null;
         for(var len:int = int($list.length); i < len; )
         {
            obj = $list[i] as Object;
            if(Boolean(obj))
            {
               this.showAwardAlertEX(obj);
            }
            i++;
         }
      }
      
      private function showAwardAlertEX($obj:Object) : void
      {
         var url:String = null;
         var name:String = null;
         if($obj.arrows == null)
         {
            $obj.arrows = true;
         }
         if($obj.stage == null)
         {
            $obj.stage = WindowLayer.instance.stage;
         }
         if(Boolean($obj.money))
         {
            new AwardAlert().showMoneyAward($obj.money,$obj.stage,$obj.callback);
         }
         if(Boolean($obj.exp))
         {
            new AwardAlert().showExpAward($obj.exp,$obj.stage,$obj.callback);
         }
         if(Boolean($obj.toolid1))
         {
            url = "assets/tool/" + $obj.toolid1 + ".swf";
            name = ToolTipStringUtil.getToolName($obj.toolid1);
            if(name == null)
            {
               name = $obj.name;
            }
            if($obj.num == null)
            {
               new AwardAlert().showGoodsAward(url,$obj.stage,"获得 " + HtmlUtil.getHtmlText(14,"#FF0000",name),$obj.arrows,$obj.callback);
            }
            else
            {
               new AwardAlert().showGoodsAward(url,$obj.stage,"获得 " + HtmlUtil.getHtmlText(14,"#FF0000",name) + "*" + $obj.num,$obj.arrows,$obj.callback);
            }
         }
         if(Boolean($obj.toolid2))
         {
            url = "assets/tool/" + $obj.toolid2 + ".swf";
            name = ToolTipStringUtil.getToolName($obj.toolid2);
            if(name == null)
            {
               name = $obj.name;
            }
            if($obj.num == null)
            {
               new AwardAlert().showGoodsAward(url,$obj.stage,"获得 " + HtmlUtil.getHtmlText(14,"#FF0000",name),$obj.arrows,$obj.callback);
            }
            else
            {
               new AwardAlert().showGoodsAward(url,$obj.stage,"获得 " + HtmlUtil.getHtmlText(14,"#FF0000",name) + "*" + $obj.num,$obj.arrows,$obj.callback);
            }
         }
         if(Boolean($obj.toolid3))
         {
            url = "assets/tool/" + $obj.toolid3 + ".swf";
            name = ToolTipStringUtil.getToolName($obj.toolid3);
            if(name == null)
            {
               name = $obj.name;
            }
            if($obj.num == null)
            {
               new AwardAlert().showGoodsAward(url,$obj.stage,"获得 " + HtmlUtil.getHtmlText(14,"#FF0000",name),$obj.arrows,$obj.callback);
            }
            else
            {
               new AwardAlert().showGoodsAward(url,$obj.stage,"获得 " + HtmlUtil.getHtmlText(14,"#FF0000",name) + "*" + $obj.num,$obj.arrows,$obj.callback);
            }
         }
         if(Boolean($obj.monsterid))
         {
            url = "assets/monsterimg/" + $obj.monsterid + ".swf";
            name = ToolTipStringUtil.getSpriteName($obj.monsterid);
            new AwardAlert().showMonsterAward(url,$obj.stage,"获得 " + HtmlUtil.getHtmlText(14,"#FF0000",name),$obj.arrows);
         }
      }
   }
}

