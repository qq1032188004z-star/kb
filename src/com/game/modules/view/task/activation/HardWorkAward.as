package com.game.modules.view.task.activation
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.util.AwardAlert;
   import com.game.util.GameDynamicUI;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Hloader;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   
   public class HardWorkAward extends Sprite
   {
      
      private var uiLoader:Hloader;
      
      private var mc:MovieClip;
      
      private var currentIndex:int = 0;
      
      private var statusList:Array;
      
      private var toGetFlag:Boolean = false;
      
      private var awardList:XML = <node>
										<award id="1">
											<good id="100006" num="5"></good>
											<exp>10000</exp>
											<cul id="1" num="20"></cul>
										</award>
										<award id="2">
											<good id="100002" num="2"></good>
											<coin>2000</coin>
											<exp>15000</exp>
										</award>
										<award id="3">
											<coin>3000</coin>
											<exp>30000</exp>
											<cul id="2" num="20"></cul>
										</award>
										<award id="4">
											<good id="100003" num="2"></good>
											<exp>35000</exp>
											<cul id="3" num="40"></cul>
										</award>
										<award id="5">
											<good id="100005" num="2"></good>
											<exp>40000</exp>
											<cul id="4" num="40"></cul>
										</award>
										<award id="6">
											<good id="100013" num="1"></good>
											<exp>45000</exp>
											<cul id="5" num="60"></cul>
										</award>
										<award id="7">
											<good id="100004" num="1"></good>
											<coin>3500</coin>
											<exp>50000</exp>
										</award>
										<award id="8">
											<good id="100013" num="2"></good>
											<exp>55000</exp>
											<cul id="6" num="60"></cul>
										</award>
									</node>;
      
      public function HardWorkAward()
      {
         super();
         GreenLoading.loading.visible = true;
         this.uiLoader = new Hloader("assets/material/hardworkaward.swf");
         this.uiLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.uiLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         this.mc = this.uiLoader.content as MovieClip;
         this.mc.stop();
         this.mc.bg.stop();
         this.uiLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.uiLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         this.init();
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         evt.stopImmediatePropagation();
         this.disport();
      }
      
      private function init() : void
      {
         if(this.mc == null)
         {
            this.disport();
            return;
         }
         if(this.statusList == null || this.statusList.length == 0)
         {
            this.disport();
            return;
         }
         this.mc.bg.bgalert.visible = false;
         this.mc.bg.bgalert.stop();
         this.mc.bg.bgalert.awardtf.text = "00";
         this.initEvent();
         GreenLoading.loading.visible = false;
      }
      
      private function initEvent() : void
      {
         if(this.mc == null)
         {
            return;
         }
         this.mc.bg.bgalert.surebtn.addEventListener(MouseEvent.CLICK,this.onClickSure);
         this.mc.bg.bgalert.awardtip.gotoAndStop(1);
         this.mc.bg.bgalert.closealert.addEventListener(MouseEvent.CLICK,this.onClickCloseAlert);
         this.mc.bg.award1.addEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award2.addEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award3.addEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award4.addEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award5.addEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award6.addEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award7.addEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award8.addEventListener(MouseEvent.CLICK,this.onClickAward);
      }
      
      private function releaseEvent() : void
      {
         if(this.mc == null)
         {
            return;
         }
         this.mc.bg.bgalert.surebtn.removeEventListener(MouseEvent.CLICK,this.onClickSure);
         this.mc.bg.bgalert.awardtip.gotoAndStop(1);
         this.mc.bg.bgalert.closealert.removeEventListener(MouseEvent.CLICK,this.onClickCloseAlert);
         this.mc.bg.award1.removeEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award2.removeEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award3.removeEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award4.removeEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award5.removeEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award6.removeEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award7.removeEventListener(MouseEvent.CLICK,this.onClickAward);
         this.mc.bg.award8.removeEventListener(MouseEvent.CLICK,this.onClickAward);
      }
      
      private function onClickSure(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.stage != null)
         {
            GameDynamicUI.addUI(this.stage,200,200,"loading");
         }
         var levelInt:int = this.currentIndex * 10 + 20;
         ApplicationFacade.getInstance().dispatch(EventConst.TO_REQ_HARDWORKAWARD,levelInt);
         this.mc.bg.bgalert.visible = false;
         this.toGetFlag = true;
      }
      
      private function onClickAward(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.toGetFlag)
         {
            return;
         }
         var str:String = evt.currentTarget.name;
         this.currentIndex = int(str.charAt(str.length - 1));
         if(this.currentIndex <= 0 || this.currentIndex > this.mc.bg.bgalert.awardtip.totalFrames)
         {
            return;
         }
         if(this.statusList != null && this.currentIndex - 1 < this.statusList.length && this.currentIndex > 0)
         {
            if(this.statusList[this.currentIndex - 1] > 0)
            {
               new Alert().showOne("你已经领取过这个奖励哦...^_^");
               return;
            }
         }
         var levelInt:int = this.currentIndex * 10 + 20;
         var level:String = String(levelInt);
         this.mc.bg.bgalert.awardtf.text = level;
         this.mc.bg.bgalert.awardtip.gotoAndStop(this.currentIndex);
         this.mc.bg.bgalert.visible = true;
      }
      
      private function parseAward() : void
      {
         var award:Object = null;
         var tempXML:XML = null;
         var str:String = null;
         var goodXML:XML = null;
         var toolName:String = null;
         award = {};
         tempXML = this.awardList.child("award").(@id == this.currentIndex)[0] as XML;
         if(Boolean(tempXML.hasOwnProperty("coin")))
         {
            award.coin = int(tempXML.coin);
         }
         if(Boolean(tempXML.hasOwnProperty("exp")))
         {
            award.exp = int(tempXML.exp);
         }
         if(Boolean(tempXML.hasOwnProperty("good")))
         {
            award.goodid = int(tempXML.good.@id);
            award.goodnum = int(tempXML.good.@num);
         }
         if(Boolean(tempXML.hasOwnProperty("cul")))
         {
            str = "";
            switch(int(tempXML.cul.@id))
            {
               case 1:
                  str = "抗性";
                  break;
               case 2:
                  str = "体力";
                  break;
               case 3:
                  str = "防御";
                  break;
               case 4:
                  str = "法术";
                  break;
               case 5:
                  str = "速度";
                  break;
               case 6:
                  str = "攻击";
            }
            award.culName = str;
            award.culnum = int(tempXML.cul.@num);
         }
         if(award == null)
         {
            return;
         }
         if(Boolean(award.hasOwnProperty("culName")) && award.culName != "")
         {
            new Alert().showOne(award.culnum + award.culName + "修为，已经放入你的贝贝，请使用贝贝自行分配！");
         }
         if(award.hasOwnProperty("coin"))
         {
            new AwardAlert().showMoneyAward(award.coin,this.stage);
         }
         if(award.hasOwnProperty("exp"))
         {
            new AwardAlert().showExpAward(award.exp,this.stage);
         }
         if(Boolean(award.hasOwnProperty("goodid")) && award.goodid != 0)
         {
            goodXML = XMLLocator.getInstance().getTool(award.goodid);
            toolName = goodXML.name;
            new AwardAlert().showGoodsAward(URLUtil.getSvnVer("assets/tool/" + award.goodid + ".swf"),this.stage,"获得" + award.goodnum + "个" + HtmlUtil.getHtmlText(12,"#FF0000",toolName),true);
         }
      }
      
      private function onClickCloseAlert(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.bg.bgalert.visible = false;
         this.currentIndex = 0;
         this.toGetFlag = false;
      }
      
      public function setData(param:Object = null) : void
      {
         if(param == null)
         {
            this.disport();
            return;
         }
         if(Boolean(param.hasOwnProperty("list")) && param.list != null)
         {
            this.statusList = param.list as Array;
            if(this.mc != null)
            {
               GreenLoading.loading.visible = true;
               this.init();
            }
            return;
         }
         this.disport();
      }
      
      public function dataBack(param:Object) : void
      {
         GameDynamicUI.removeUI("loading");
         this.toGetFlag = false;
         if(param.beSucces > 0)
         {
            if(this.currentIndex <= 0 || this.currentIndex > this.awardList.children().length())
            {
               return;
            }
            this.parseAward();
            this.statusList[this.currentIndex - 1] = 1;
         }
         else if(param.beSucces == -1)
         {
            if(param.hasOwnProperty("levelM"))
            {
               new Alert().showOne("你的宠物的等级还不能够领取这个奖励哦.只差" + param.levelM + "级了哦..加油！～");
            }
            else
            {
               new Alert().showOne("你的宠物的等级还不能够领取这个奖励哦.");
            }
         }
         else
         {
            new Alert().showOne("你已经领取过这个奖励哦...^_^");
         }
      }
      
      public function disport() : void
      {
         this.releaseEvent();
         if(Boolean(this.uiLoader))
         {
            this.uiLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.uiLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this.uiLoader.unloadAndStop();
            this.uiLoader = null;
         }
         this.currentIndex = 0;
         this.toGetFlag = false;
         this.statusList = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

