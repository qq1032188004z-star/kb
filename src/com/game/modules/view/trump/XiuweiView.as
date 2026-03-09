package com.game.modules.view.trump
{
   import com.game.Tools.AttributeCharacterIcon;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.modules.control.trump.XiuweiControl;
   import com.game.modules.view.item.MonsterImageItem;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   public class XiuweiView extends HLoaderSprite
   {
      
      private var xiuweiMc:MovieClip;
      
      private var monsterimgList:TileList;
      
      private var selectData:Object;
      
      private var successWindow:MovieClip;
      
      private var sucloader:Loader;
      
      private var imgloader:Loader;
      
      private var _attIcon:AttributeCharacterIcon;
      
      private var params:Object;
      
      private var onetxt:int;
      
      private var twotxt:int;
      
      private var threetxt:int;
      
      private var fourtxt:int;
      
      private var fivetxt:int;
      
      private var sixtxt:int;
      
      private var hp:Number;
      
      private var attack:Number;
      
      private var magic:Number;
      
      private var speed:Number;
      
      private var defence:Number;
      
      private var resistance:Number;
      
      public function XiuweiView()
      {
         GreenLoading.loading.visible = true;
         super();
         this.url = "assets/material/xiuwei.swf";
      }
      
      override public function setShow() : void
      {
         this.xiuweiMc = this.bg as MovieClip;
         this.xiuweiMc.cacheAsBitmap = true;
         this.addChild(this.xiuweiMc);
         this._attIcon = new AttributeCharacterIcon();
         bg["spAtt"].addChild(this._attIcon);
         this.xiuweiMc.hpMc.gotoAndStop(1);
         this.xiuweiMc.attMc.gotoAndStop(1);
         this.xiuweiMc.defMc.gotoAndStop(1);
         this.xiuweiMc.speedMc.gotoAndStop(1);
         this.xiuweiMc.magicMc.gotoAndStop(1);
         this.xiuweiMc.strMc.gotoAndStop(1);
         this.monsterimgList = new TileList(35,98);
         this.monsterimgList.build(2,3,60,60,22,18,MonsterImageItem);
         this.addChild(this.monsterimgList);
         this.xiuweiMc.tilixiuwei.restrict = "0-9";
         this.xiuweiMc.gongjixiuwei.restrict = "0-9";
         this.xiuweiMc.fangyuxiuwei.restrict = "0-9";
         this.xiuweiMc.fashuxiuwei.restrict = "0-9";
         this.xiuweiMc.kangxingxiuwei.restrict = "0-9";
         this.xiuweiMc.suduxiuwei.restrict = "0-9";
         ApplicationFacade.getInstance().registerViewLogic(new XiuweiControl(this));
         GreenLoading.loading.visible = false;
      }
      
      public function initEvents() : void
      {
         EventManager.attachEvent(this.monsterimgList,ItemClickEvent.ITEMCLICKEVENT,this.itemClick,true);
         EventManager.attachEvent(this.xiuweiMc.confirmBtn,MouseEvent.MOUSE_DOWN,this.Confirm);
         EventManager.attachEvent(this.xiuweiMc.reseatBtn,MouseEvent.MOUSE_DOWN,this.reseat);
         EventManager.attachEvent(this.xiuweiMc.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.attachEvent(this.xiuweiMc.lessBtn1,MouseEvent.MOUSE_DOWN,this.lessNum);
         EventManager.attachEvent(this.xiuweiMc.lessBtn2,MouseEvent.MOUSE_DOWN,this.lessNum);
         EventManager.attachEvent(this.xiuweiMc.lessBtn3,MouseEvent.MOUSE_DOWN,this.lessNum);
         EventManager.attachEvent(this.xiuweiMc.lessBtn4,MouseEvent.MOUSE_DOWN,this.lessNum);
         EventManager.attachEvent(this.xiuweiMc.lessBtn5,MouseEvent.MOUSE_DOWN,this.lessNum);
         EventManager.attachEvent(this.xiuweiMc.lessBtn6,MouseEvent.MOUSE_DOWN,this.lessNum);
         EventManager.attachEvent(this.xiuweiMc.moreBtn1,MouseEvent.MOUSE_DOWN,this.moreNum);
         EventManager.attachEvent(this.xiuweiMc.moreBtn2,MouseEvent.MOUSE_DOWN,this.moreNum);
         EventManager.attachEvent(this.xiuweiMc.moreBtn3,MouseEvent.MOUSE_DOWN,this.moreNum);
         EventManager.attachEvent(this.xiuweiMc.moreBtn4,MouseEvent.MOUSE_DOWN,this.moreNum);
         EventManager.attachEvent(this.xiuweiMc.moreBtn5,MouseEvent.MOUSE_DOWN,this.moreNum);
         EventManager.attachEvent(this.xiuweiMc.moreBtn6,MouseEvent.MOUSE_DOWN,this.moreNum);
         EventManager.attachEvent(this.xiuweiMc.tilixiuwei,Event.CHANGE,this.changeTxt);
         EventManager.attachEvent(this.xiuweiMc.gongjixiuwei,Event.CHANGE,this.changeTxt);
         EventManager.attachEvent(this.xiuweiMc.fangyuxiuwei,Event.CHANGE,this.changeTxt);
         EventManager.attachEvent(this.xiuweiMc.fashuxiuwei,Event.CHANGE,this.changeTxt);
         EventManager.attachEvent(this.xiuweiMc.kangxingxiuwei,Event.CHANGE,this.changeTxt);
         EventManager.attachEvent(this.xiuweiMc.suduxiuwei,Event.CHANGE,this.changeTxt);
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(this.monsterimgList,ItemClickEvent.ITEMCLICKEVENT,this.itemClick);
         EventManager.removeEvent(this.xiuweiMc.confirmBtn,MouseEvent.MOUSE_DOWN,this.Confirm);
         EventManager.removeEvent(this.xiuweiMc.reseatBtn,MouseEvent.MOUSE_DOWN,this.reseat);
         EventManager.removeEvent(this.xiuweiMc.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.removeEvent(this.xiuweiMc.lessBtn1,MouseEvent.MOUSE_DOWN,this.lessNum);
         EventManager.removeEvent(this.xiuweiMc.lessBtn2,MouseEvent.MOUSE_DOWN,this.lessNum);
         EventManager.removeEvent(this.xiuweiMc.lessBtn3,MouseEvent.MOUSE_DOWN,this.lessNum);
         EventManager.removeEvent(this.xiuweiMc.lessBtn4,MouseEvent.MOUSE_DOWN,this.lessNum);
         EventManager.removeEvent(this.xiuweiMc.lessBtn5,MouseEvent.MOUSE_DOWN,this.lessNum);
         EventManager.removeEvent(this.xiuweiMc.lessBtn6,MouseEvent.MOUSE_DOWN,this.lessNum);
         EventManager.removeEvent(this.xiuweiMc.moreBtn1,MouseEvent.MOUSE_DOWN,this.moreNum);
         EventManager.removeEvent(this.xiuweiMc.moreBtn2,MouseEvent.MOUSE_DOWN,this.moreNum);
         EventManager.removeEvent(this.xiuweiMc.moreBtn3,MouseEvent.MOUSE_DOWN,this.moreNum);
         EventManager.removeEvent(this.xiuweiMc.moreBtn4,MouseEvent.MOUSE_DOWN,this.moreNum);
         EventManager.removeEvent(this.xiuweiMc.moreBtn5,MouseEvent.MOUSE_DOWN,this.moreNum);
         EventManager.removeEvent(this.xiuweiMc.moreBtn6,MouseEvent.MOUSE_DOWN,this.moreNum);
         EventManager.removeEvent(this.xiuweiMc.tilixiuwei,Event.CHANGE,this.changeTxt);
         EventManager.removeEvent(this.xiuweiMc.gongjixiuwei,Event.CHANGE,this.changeTxt);
         EventManager.removeEvent(this.xiuweiMc.fangyuxiuwei,Event.CHANGE,this.changeTxt);
         EventManager.removeEvent(this.xiuweiMc.fashuxiuwei,Event.CHANGE,this.changeTxt);
         EventManager.removeEvent(this.xiuweiMc.kangxingxiuwei,Event.CHANGE,this.changeTxt);
         EventManager.removeEvent(this.xiuweiMc.suduxiuwei,Event.CHANGE,this.changeTxt);
      }
      
      private function lessNum(evt:MouseEvent) : void
      {
         switch(evt.currentTarget)
         {
            case this.xiuweiMc.lessBtn1:
               if(int(this.xiuweiMc.tilixiuwei.text) > 0)
               {
                  this.xiuweiMc.tilixiuwei.text = int(this.xiuweiMc.tilixiuwei.text) - 1 + "";
                  this.xiuweiMc.alltilixiuwei.text = int(this.xiuweiMc.alltilixiuwei.text) + 1 + "";
                  this.xiuweiMc.hpTxt.text = this.xiuweiMc.hpTxt.text - 1 + "";
               }
               break;
            case this.xiuweiMc.lessBtn2:
               if(int(this.xiuweiMc.gongjixiuwei.text) > 0)
               {
                  this.xiuweiMc.gongjixiuwei.text = int(this.xiuweiMc.gongjixiuwei.text) - 1 + "";
                  this.xiuweiMc.allgongjixiuwei.text = int(this.xiuweiMc.allgongjixiuwei.text) + 1 + "";
                  this.xiuweiMc.attackTxt.text = this.xiuweiMc.attackTxt.text - 1 + "";
               }
               break;
            case this.xiuweiMc.lessBtn3:
               if(int(this.xiuweiMc.fangyuxiuwei.text) > 0)
               {
                  this.xiuweiMc.fangyuxiuwei.text = int(this.xiuweiMc.fangyuxiuwei.text) - 1 + "";
                  this.xiuweiMc.allfangyuxiuwei.text = int(this.xiuweiMc.allfangyuxiuwei.text) + 1 + "";
                  this.xiuweiMc.defenceTxt.text = this.xiuweiMc.defenceTxt.text - 1 + "";
               }
               break;
            case this.xiuweiMc.lessBtn4:
               if(int(this.xiuweiMc.fashuxiuwei.text) > 0)
               {
                  this.xiuweiMc.fashuxiuwei.text = int(this.xiuweiMc.fashuxiuwei.text) - 1 + "";
                  this.xiuweiMc.allfashuxiuwei.text = int(this.xiuweiMc.allfashuxiuwei.text) + 1 + "";
                  this.xiuweiMc.magicTxt.text = this.xiuweiMc.magicTxt.text - 1 + "";
               }
               break;
            case this.xiuweiMc.lessBtn5:
               if(int(this.xiuweiMc.kangxingxiuwei.text) > 0)
               {
                  this.xiuweiMc.kangxingxiuwei.text = int(this.xiuweiMc.kangxingxiuwei.text) - 1 + "";
                  this.xiuweiMc.allkangxingxiuwei.text = int(this.xiuweiMc.allkangxingxiuwei.text) + 1 + "";
                  this.xiuweiMc.strTxt.text = this.xiuweiMc.strTxt.text - 1 + "";
               }
               break;
            case this.xiuweiMc.lessBtn6:
               if(int(this.xiuweiMc.suduxiuwei.text) > 0)
               {
                  this.xiuweiMc.suduxiuwei.text = int(this.xiuweiMc.suduxiuwei.text) - 1 + "";
                  this.xiuweiMc.allsuduxiuwei.text = int(this.xiuweiMc.allsuduxiuwei.text) + 1 + "";
                  this.xiuweiMc.speedTxt.text = this.xiuweiMc.speedTxt.text - 1 + "";
               }
         }
      }
      
      private function moreNum(evt:MouseEvent) : void
      {
         switch(evt.currentTarget)
         {
            case this.xiuweiMc.moreBtn1:
               if(int(this.xiuweiMc.tilixiuwei.text) < int(this.onetxt) && !this.cheakOverXiuwei(this.selectData.hpLearnValue,int(this.xiuweiMc.tilixiuwei.text)))
               {
                  this.xiuweiMc.tilixiuwei.text = int(this.xiuweiMc.tilixiuwei.text) + 1 + "";
                  this.xiuweiMc.alltilixiuwei.text = int(this.xiuweiMc.alltilixiuwei.text) - 1 + "";
                  this.xiuweiMc.hpTxt.text = int(this.xiuweiMc.hpTxt.text) + 1 + "";
               }
               break;
            case this.xiuweiMc.moreBtn2:
               if(int(this.xiuweiMc.gongjixiuwei.text) < this.twotxt && !this.cheakOverXiuwei(this.selectData.attackLearnValue,int(this.xiuweiMc.gongjixiuwei.text)))
               {
                  this.xiuweiMc.gongjixiuwei.text = int(this.xiuweiMc.gongjixiuwei.text) + 1 + "";
                  this.xiuweiMc.allgongjixiuwei.text = int(this.xiuweiMc.allgongjixiuwei.text) - 1 + "";
                  this.xiuweiMc.attackTxt.text = int(this.xiuweiMc.attackTxt.text) + 1 + "";
               }
               break;
            case this.xiuweiMc.moreBtn3:
               if(int(this.xiuweiMc.fangyuxiuwei.text) < this.threetxt && !this.cheakOverXiuwei(this.selectData.defenceLearnValue,int(this.xiuweiMc.fangyuxiuwei.text)))
               {
                  this.xiuweiMc.fangyuxiuwei.text = int(this.xiuweiMc.fangyuxiuwei.text) + 1 + "";
                  this.xiuweiMc.allfangyuxiuwei.text = int(this.xiuweiMc.allfangyuxiuwei.text) - 1 + "";
                  this.xiuweiMc.defenceTxt.text = int(this.xiuweiMc.defenceTxt.text) + 1 + "";
               }
               break;
            case this.xiuweiMc.moreBtn4:
               if(int(this.xiuweiMc.fashuxiuwei.text) < this.fourtxt && !this.cheakOverXiuwei(this.selectData.magicLearnValue,int(this.xiuweiMc.fashuxiuwei.text)))
               {
                  this.xiuweiMc.fashuxiuwei.text = int(this.xiuweiMc.fashuxiuwei.text) + 1 + "";
                  this.xiuweiMc.allfashuxiuwei.text = int(this.xiuweiMc.allfashuxiuwei.text) - 1 + "";
                  this.xiuweiMc.magicTxt.text = int(this.xiuweiMc.magicTxt.text) + 1 + "";
               }
               break;
            case this.xiuweiMc.moreBtn5:
               if(int(this.xiuweiMc.kangxingxiuwei.text) < this.fivetxt && !this.cheakOverXiuwei(this.selectData.resistanceLearnValue,int(this.xiuweiMc.kangxingxiuwei.text)))
               {
                  this.xiuweiMc.kangxingxiuwei.text = int(this.xiuweiMc.kangxingxiuwei.text) + 1 + "";
                  this.xiuweiMc.allkangxingxiuwei.text = int(this.xiuweiMc.allkangxingxiuwei.text) - 1 + "";
                  this.xiuweiMc.strTxt.text = int(this.xiuweiMc.strTxt.text) + 1 + "";
               }
               break;
            case this.xiuweiMc.moreBtn6:
               if(int(this.xiuweiMc.suduxiuwei.text) < this.sixtxt && !this.cheakOverXiuwei(this.selectData.speedLearnVale,int(this.xiuweiMc.suduxiuwei.text)))
               {
                  this.xiuweiMc.suduxiuwei.text = int(this.xiuweiMc.suduxiuwei.text) + 1 + "";
                  this.xiuweiMc.allsuduxiuwei.text = int(this.xiuweiMc.allsuduxiuwei.text) - 1 + "";
                  this.xiuweiMc.speedTxt.text = int(this.xiuweiMc.speedTxt.text) + 1 + "";
               }
         }
      }
      
      private function changeTxt(evt:Event) : void
      {
         switch(evt.currentTarget)
         {
            case this.xiuweiMc.tilixiuwei:
               if(int(this.xiuweiMc.tilixiuwei.text) > this.onetxt || this.cheakOverXiuwei(this.selectData.hpLearnValue,int(this.xiuweiMc.tilixiuwei.text)))
               {
                  this.xiuweiMc.tilixiuwei.text = Math.min(this.onetxt,255 - this.selectData.hpLearnValue,this.countCanMax(this.xiuweiMc.tilixiuwei));
               }
               this.xiuweiMc.alltilixiuwei.text = this.onetxt - int(this.xiuweiMc.tilixiuwei.text);
               this.xiuweiMc.hpTxt.text = this.selectData.hpLearnValue + int(this.xiuweiMc.tilixiuwei.text) + "";
               break;
            case this.xiuweiMc.gongjixiuwei:
               if(int(this.xiuweiMc.gongjixiuwei.text) > this.twotxt || this.cheakOverXiuwei(this.selectData.attackLearnValue,int(this.xiuweiMc.gongjixiuwei.text)))
               {
                  this.xiuweiMc.gongjixiuwei.text = Math.min(this.twotxt,255 - this.selectData.attackLearnValue,this.countCanMax(this.xiuweiMc.gongjixiuwei));
               }
               this.xiuweiMc.allgongjixiuwei.text = this.twotxt - int(this.xiuweiMc.gongjixiuwei.text);
               this.xiuweiMc.attackTxt.text = this.selectData.attackLearnValue + int(this.xiuweiMc.gongjixiuwei.text) + "";
               break;
            case this.xiuweiMc.fangyuxiuwei:
               if(int(this.xiuweiMc.fangyuxiuwei.text) > this.threetxt || this.cheakOverXiuwei(this.selectData.defenceLearnValue,int(this.xiuweiMc.fangyuxiuwei.text)))
               {
                  this.xiuweiMc.fangyuxiuwei.text = Math.min(this.threetxt,255 - this.selectData.defenceLearnValue,this.countCanMax(this.xiuweiMc.fangyuxiuwei));
               }
               this.xiuweiMc.allfangyuxiuwei.text = this.threetxt - int(this.xiuweiMc.fangyuxiuwei.text);
               this.xiuweiMc.defenceTxt.text = this.selectData.defenceLearnValue + int(this.xiuweiMc.fangyuxiuwei.text) + "";
               break;
            case this.xiuweiMc.fashuxiuwei:
               if(int(this.xiuweiMc.fashuxiuwei.text) > this.fourtxt || this.cheakOverXiuwei(this.selectData.magicLearnValue,int(this.xiuweiMc.fashuxiuwei.text)))
               {
                  this.xiuweiMc.fashuxiuwei.text = Math.min(this.fourtxt,255 - this.selectData.magicLearnValue,this.countCanMax(this.xiuweiMc.fashuxiuwei));
               }
               this.xiuweiMc.allfashuxiuwei.text = this.fourtxt - int(this.xiuweiMc.fashuxiuwei.text);
               this.xiuweiMc.magicTxt.text = this.selectData.magicLearnValue + int(this.xiuweiMc.fashuxiuwei.text) + "";
               break;
            case this.xiuweiMc.kangxingxiuwei:
               if(int(this.xiuweiMc.kangxingxiuwei.text) > this.fivetxt || this.cheakOverXiuwei(this.selectData.resistanceLearnValue,int(this.xiuweiMc.kangxingxiuwei.text)))
               {
                  this.xiuweiMc.kangxingxiuwei.text = Math.min(this.fivetxt,255 - this.selectData.resistanceLearnValue,this.countCanMax(this.xiuweiMc.kangxingxiuwei));
               }
               this.xiuweiMc.allkangxingxiuwei.text = this.fivetxt - int(this.xiuweiMc.kangxingxiuwei.text);
               this.xiuweiMc.strTxt.text = this.selectData.resistanceLearnValue + int(this.xiuweiMc.kangxingxiuwei.text) + "";
               break;
            case this.xiuweiMc.suduxiuwei:
               if(int(this.xiuweiMc.suduxiuwei.text) > this.sixtxt || this.cheakOverXiuwei(this.selectData.speedLearnVale,int(this.xiuweiMc.suduxiuwei.text)))
               {
                  this.xiuweiMc.suduxiuwei.text = Math.min(this.sixtxt,255 - this.selectData.speedLearnVale,this.countCanMax(this.xiuweiMc.suduxiuwei));
               }
               this.xiuweiMc.allsuduxiuwei.text = this.sixtxt - int(this.xiuweiMc.suduxiuwei.text);
               this.xiuweiMc.speedTxt.text = this.selectData.speedLearnVale + int(this.xiuweiMc.suduxiuwei.text) + "";
         }
      }
      
      private function cheakOverXiuwei(initialXiuwei:int, addXiuwei:int) : Boolean
      {
         var maxtxt:int = 255 - initialXiuwei;
         var temp1:int = this.selectData.hpLearnValue + this.selectData.attackLearnValue + this.selectData.magicLearnValue + this.selectData.speedLearnVale + this.selectData.resistanceLearnValue + this.selectData.defenceLearnValue;
         var temp2:int = int(this.xiuweiMc.tilixiuwei.text) + int(this.xiuweiMc.gongjixiuwei.text) + int(this.xiuweiMc.fangyuxiuwei.text) + int(this.xiuweiMc.fashuxiuwei.text) + int(this.xiuweiMc.kangxingxiuwei.text) + int(this.xiuweiMc.suduxiuwei.text);
         var countxiuwei:int = temp1 + temp2;
         if(addXiuwei >= maxtxt || countxiuwei >= 510)
         {
            if(countxiuwei >= 510)
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1072,
                  "flag":2
               });
            }
            return true;
         }
         return false;
      }
      
      private function countCanMax(tt:TextField) : Number
      {
         var temp1:int = this.selectData.hpLearnValue + this.selectData.attackLearnValue + this.selectData.magicLearnValue + this.selectData.speedLearnVale + this.selectData.resistanceLearnValue + this.selectData.defenceLearnValue;
         var temp2:int = int(this.xiuweiMc.tilixiuwei.text) + int(this.xiuweiMc.gongjixiuwei.text) + int(this.xiuweiMc.fangyuxiuwei.text) + int(this.xiuweiMc.fashuxiuwei.text) + int(this.xiuweiMc.kangxingxiuwei.text) + int(this.xiuweiMc.suduxiuwei.text);
         return 510 - (temp2 - int(tt.text)) - temp1;
      }
      
      private function Confirm(evt:MouseEvent) : void
      {
         if(this.xiuweiMc.tilixiuwei.text == "0" && this.xiuweiMc.gongjixiuwei.text == "0" && this.xiuweiMc.fangyuxiuwei.text == "0" && this.xiuweiMc.fashuxiuwei.text == "0" && this.xiuweiMc.kangxingxiuwei.text == "0" && this.xiuweiMc.suduxiuwei.text == "0")
         {
            AlertManager.instance.showTipAlert({
               "systemid":1072,
               "flag":3
            });
            return;
         }
         var obj:Object = {};
         obj.id = this.selectData.id;
         obj.tili = int(this.xiuweiMc.tilixiuwei.text);
         obj.gongji = int(this.xiuweiMc.gongjixiuwei.text);
         obj.fangyu = int(this.xiuweiMc.fangyuxiuwei.text);
         obj.fashu = int(this.xiuweiMc.fashuxiuwei.text);
         obj.kangxing = int(this.xiuweiMc.kangxingxiuwei.text);
         obj.sudu = int(this.xiuweiMc.suduxiuwei.text);
         ApplicationFacade.getInstance().dispatch(EventConst.CONFIRMXIUWEI,obj);
      }
      
      private function reseat(evt:MouseEvent) : void
      {
         this.xiuweiMc.tilixiuwei.text = "0";
         this.xiuweiMc.gongjixiuwei.text = "0";
         this.xiuweiMc.fangyuxiuwei.text = "0";
         this.xiuweiMc.fashuxiuwei.text = "0";
         this.xiuweiMc.kangxingxiuwei.text = "0";
         this.xiuweiMc.suduxiuwei.text = "0";
         this.xiuweiMc.alltilixiuwei.text = this.onetxt + "";
         this.xiuweiMc.allgongjixiuwei.text = this.twotxt + "";
         this.xiuweiMc.allfangyuxiuwei.text = this.threetxt + "";
         this.xiuweiMc.allfashuxiuwei.text = this.fourtxt + "";
         this.xiuweiMc.allkangxingxiuwei.text = this.fivetxt + "";
         this.xiuweiMc.allsuduxiuwei.text = this.sixtxt + "";
         this.xiuweiMc.hpTxt.text = this.selectData.hpLearnValue + "";
         this.xiuweiMc.attackTxt.text = this.selectData.attackLearnValue + "";
         this.xiuweiMc.magicTxt.text = this.selectData.magicLearnValue + "";
         this.xiuweiMc.speedTxt.text = this.selectData.speedLearnVale + "";
         this.xiuweiMc.defenceTxt.text = this.selectData.defenceLearnValue + "";
         this.xiuweiMc.strTxt.text = this.selectData.resistanceLearnValue + "";
      }
      
      private function closeWindow(evt:MouseEvent) : void
      {
         this.parent.removeChild(this);
         this.xiuweiMc.tilixiuwei.text = "0";
         this.xiuweiMc.gongjixiuwei.text = "0";
         this.xiuweiMc.fangyuxiuwei.text = "0";
         this.xiuweiMc.fashuxiuwei.text = "0";
         this.xiuweiMc.kangxingxiuwei.text = "0";
         this.xiuweiMc.suduxiuwei.text = "0";
      }
      
      public function openSuccessWindow(params:Object) : void
      {
         this.params = params;
         this.sucloader = new Loader();
         this.sucloader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.sucloaderLoadComplete);
         this.sucloader.load(new URLRequest(URLUtil.getSvnVer("assets/material/disSuccess.swf")));
      }
      
      private function backReseat() : void
      {
         this.onetxt = int(this.xiuweiMc.alltilixiuwei.text);
         this.twotxt = int(this.xiuweiMc.allgongjixiuwei.text);
         this.threetxt = int(this.xiuweiMc.allfangyuxiuwei.text);
         this.fourtxt = int(this.xiuweiMc.allfashuxiuwei.text);
         this.fivetxt = int(this.xiuweiMc.allkangxingxiuwei.text);
         this.sixtxt = int(this.xiuweiMc.allsuduxiuwei.text);
         this.xiuweiMc.tilixiuwei.text = "0";
         this.xiuweiMc.gongjixiuwei.text = "0";
         this.xiuweiMc.fangyuxiuwei.text = "0";
         this.xiuweiMc.fashuxiuwei.text = "0";
         this.xiuweiMc.kangxingxiuwei.text = "0";
         this.xiuweiMc.suduxiuwei.text = "0";
      }
      
      private function closeSucWindown(evt:Event) : void
      {
         this.backReseat();
         this.removeChild(this.successWindow);
         this.imgloader.unloadAndStop(false);
         this.sucloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.sucloaderLoadComplete);
      }
      
      private function sucloaderLoadComplete(evt:Event) : void
      {
         var onLoaderCompHandler:Function = null;
         onLoaderCompHandler = function(event:Event):void
         {
            imgloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoaderCompHandler);
            imgloader.scaleX = 1.3;
            imgloader.scaleY = 1.3;
            imgloader.x = 330;
            imgloader.y = 60;
            addChild(imgloader);
         };
         this.successWindow = this.sucloader.content as MovieClip;
         if(this.selectData == null || this.successWindow == null)
         {
            return;
         }
         this.successWindow.desc.text = this.selectData.name + "成功获得了修为！";
         this.addChild(this.successWindow);
         this.successWindow.x = 300;
         this.imgloader = new Loader();
         this.imgloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + this.selectData.iid + ".swf")));
         this.imgloader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderCompHandler);
         this.successWindow.okbtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeSucWindown);
         this.successWindow.spiritname.text = this.selectData.name;
         this.successWindow.initialtili.text = this.hp;
         this.successWindow.initialgongji.text = this.attack;
         this.successWindow.initialfangyu.text = this.defence;
         this.successWindow.initialfashu.text = this.magic;
         this.successWindow.initialkangxing.text = this.resistance;
         this.successWindow.initialsudu.text = this.speed;
         this.successWindow.addtili.text = this.params.hp - this.hp + "";
         this.successWindow.addtili.text = String(this.params.hp - this.hp);
         this.successWindow.addgongji.text = this.params.attack - this.attack + "";
         this.successWindow.addfangyu.text = this.params.defence - this.defence + "";
         this.successWindow.addfashu.text = this.params.magic - this.magic + "";
         this.successWindow.addkangxing.text = this.params.resistance - this.resistance + "";
         this.successWindow.addsudu.text = this.params.speed - this.speed + "";
         this.successWindow.counttili.text = this.params.hp + "";
         this.successWindow.countgongji.text = this.params.attack + "";
         this.successWindow.countfangyu.text = this.params.defence + "";
         this.successWindow.countfashu.text = this.params.magic + "";
         this.successWindow.countkangxing.text = this.params.resistance + "";
         this.successWindow.countsudu.text = this.params.speed + "";
         if(Boolean(this.params.hasOwnProperty("hasSymm")) && Boolean(this.params.hasSymm))
         {
            this.successWindow.symm.filters = null;
         }
         else
         {
            this.successWindow.symm.filters = ColorUtil.getColorMatrixFilterGray();
         }
         this.updateSelectData();
      }
      
      private function updateSelectData() : void
      {
         var item:MonsterImageItem = null;
         this.onetxt -= int(this.xiuweiMc.tilixiuwei.text);
         this.twotxt -= int(this.xiuweiMc.gongjixiuwei.text);
         this.threetxt -= int(this.xiuweiMc.fangyuxiuwei.text);
         this.fourtxt -= int(this.xiuweiMc.fashuxiuwei.text);
         this.fivetxt -= int(this.xiuweiMc.kangxingxiuwei.text);
         this.sixtxt -= int(this.xiuweiMc.suduxiuwei.text);
         var num:int = this.monsterimgList.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            item = this.monsterimgList.getChildAt(i) as MonsterImageItem;
            if(item.data.id == this.selectData.id)
            {
               item.data.hp = this.params.hp;
               item.data.attack = this.params.attack;
               item.data.defence = this.params.defence;
               item.data.magic = this.params.magic;
               item.data.resistance = this.params.resistance;
               item.data.speed = this.params.speed;
               item.data.hpLearnValue = this.selectData.hpLearnValue + int(this.xiuweiMc.tilixiuwei.text);
               item.data.attackLearnValue = this.selectData.attackLearnValue + int(this.xiuweiMc.gongjixiuwei.text);
               item.data.defenceLearnValue = this.selectData.defenceLearnValue + int(this.xiuweiMc.fangyuxiuwei.text);
               item.data.magicLearnValue = this.selectData.magicLearnValue + int(this.xiuweiMc.fashuxiuwei.text);
               item.data.resistanceLearnValue = this.selectData.resistanceLearnValue + int(this.xiuweiMc.kangxingxiuwei.text);
               item.data.speedLearnVale = this.selectData.speedLearnVale + int(this.xiuweiMc.suduxiuwei.text);
               this.reseat(null);
               this.setMonsterInfo(item.data);
            }
         }
      }
      
      public function initData(params:Object) : void
      {
         var item:MonsterImageItem = null;
         if(Boolean(params.monsterlist))
         {
            this.monsterimgList.dataProvider = params.monsterlist;
         }
         this.xiuweiMc.alltilixiuwei.text = params == null ? "" : params.tilixiuweizhi + "";
         this.onetxt = params.tilixiuweizhi;
         this.xiuweiMc.allgongjixiuwei.text = params == null ? "" : params.gongjixiuweizhi + "";
         this.twotxt = params.gongjixiuweizhi;
         this.xiuweiMc.allfangyuxiuwei.text = params == null ? "" : params.fangyuxiuweizhi + "";
         this.threetxt = params.fangyuxiuweizhi;
         this.xiuweiMc.allfashuxiuwei.text = params == null ? "" : params.fashuxiuweizhi + "";
         this.fourtxt = params.fashuxiuweizhi;
         this.xiuweiMc.allkangxingxiuwei.text = params == null ? "" : params.kangxingxiuweizhi + "";
         this.fivetxt = params.kangxingxiuweizhi;
         this.xiuweiMc.allsuduxiuwei.text = params == null ? "" : params.suduxiuweizhi + "";
         this.sixtxt = params.suduxiuweizhi;
         if(params.monsterlist.length != 0)
         {
            this.setMonsterInfo(params.monsterlist[0]);
            item = this.monsterimgList.getChildAt(0) as MonsterImageItem;
            item.filters = ColorUtil.getGrowFilter();
         }
      }
      
      private function setMonsterInfo(itemData:Object) : void
      {
         if(!itemData)
         {
            return;
         }
         this.selectData = itemData;
         this.hp = this.selectData.strength;
         this.attack = this.selectData.attack;
         this.magic = this.selectData.magic;
         this.speed = this.selectData.speed;
         this.defence = this.selectData.defence;
         this.resistance = this.selectData.resistance;
         this.xiuweiMc.nameTxt.text = itemData == null ? "" : itemData.name + "";
         this.xiuweiMc.levelTxt.text = itemData == null ? "" : itemData.level + "";
         this.xiuweiMc.modoTxt.text = itemData == null ? "" : CommonDefine.moldList[itemData.mold - 1] + "";
         this._attIcon.id = itemData == null ? 1 : int(itemData.type);
         this.xiuweiMc.hpTxt.text = itemData == null ? "" : itemData.hpLearnValue + "";
         this.xiuweiMc.attackTxt.text = itemData == null ? "" : itemData.attackLearnValue + "";
         this.xiuweiMc.magicTxt.text = itemData == null ? "" : itemData.magicLearnValue + "";
         this.xiuweiMc.speedTxt.text = itemData == null ? "" : itemData.speedLearnVale + "";
         this.xiuweiMc.defenceTxt.text = itemData == null ? "" : itemData.defenceLearnValue + "";
         this.xiuweiMc.strTxt.text = itemData == null ? "" : itemData.resistanceLearnValue + "";
         if(itemData != null && itemData.hpGeniusValue == 31)
         {
            this.xiuweiMc.hpMc.gotoAndStop(7);
         }
         else
         {
            this.xiuweiMc.hpMc.gotoAndStop(itemData == null ? 1 : itemData.hpGenius);
         }
         if(itemData != null && itemData.attackGeniusValue == 31)
         {
            this.xiuweiMc.attMc.gotoAndStop(7);
         }
         else
         {
            this.xiuweiMc.attMc.gotoAndStop(itemData == null ? 1 : itemData.attackGenius);
         }
         if(itemData != null && itemData.defenceGeniusValue == 31)
         {
            this.xiuweiMc.defMc.gotoAndStop(7);
         }
         else
         {
            this.xiuweiMc.defMc.gotoAndStop(itemData == null ? 1 : itemData.defenceGenius);
         }
         if(itemData != null && itemData.speedGeniusValue == 31)
         {
            this.xiuweiMc.speedMc.gotoAndStop(7);
         }
         else
         {
            this.xiuweiMc.speedMc.gotoAndStop(itemData == null ? 1 : itemData.speedGenius);
         }
         if(itemData != null && itemData.magicGeniusValue == 31)
         {
            this.xiuweiMc.magicMc.gotoAndStop(7);
         }
         else
         {
            this.xiuweiMc.magicMc.gotoAndStop(itemData == null ? 1 : itemData.magicGenius);
         }
         if(itemData != null && itemData.resistanceGeniusValue == 31)
         {
            this.xiuweiMc.strMc.gotoAndStop(7);
         }
         else
         {
            this.xiuweiMc.strMc.gotoAndStop(itemData == null ? 1 : itemData.resistanceGenius);
         }
         if(Boolean(itemData.hasOwnProperty("symmList")) && itemData.symmList.length > 0)
         {
            this.xiuweiMc.symm.filters = null;
         }
         else
         {
            this.xiuweiMc.symm.filters = ColorUtil.getColorMatrixFilterGray();
         }
      }
      
      private function itemClick(evt:ItemClickEvent) : void
      {
         var item:MonsterImageItem = null;
         this.reseat(null);
         var num:int = this.monsterimgList.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            item = this.monsterimgList.getChildAt(i) as MonsterImageItem;
            if(item.data.id == evt.params.id)
            {
               item.filters = ColorUtil.getGrowFilter();
            }
            else
            {
               item.filters = [];
            }
         }
         this.setMonsterInfo(evt.params);
      }
      
      override public function disport() : void
      {
         if(Boolean(this._attIcon))
         {
            this._attIcon.dispose();
            this._attIcon = null;
         }
         CacheUtil.deleteObject(XiuweiView);
         ApplicationFacade.getInstance().removeViewLogic(XiuweiControl.NAME);
         super.disport();
      }
   }
}

