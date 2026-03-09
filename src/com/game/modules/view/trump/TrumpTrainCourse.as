package com.game.modules.view.trump
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.modules.control.trump.TrumpEvent;
   import com.game.util.HLoaderSprite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class TrumpTrainCourse extends HLoaderSprite
   {
      
      private var mdata:Object;
      
      public var courses:Array;
      
      private const Text1:Array = ["第一天","第一天","第二天","第三天","第四天","第五天","第六天","第七天"];
      
      private const Text2:Array = ["100%\n效益","100%\n效益","90%\n效益","80%\n效益","70%\n效益","60%\n效益","50%\n效益","50%\n效益"];
      
      private const Text3:Array = ["历练\n修为","历练\n修为","体力\n修为","速度\n修为","攻击\n修为","防御\n修为","法术\n修为","抗性\n修为"];
      
      private const Value:Array = [6,6,4,5,0,1,2,3];
      
      private var f:ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0]);
      
      public function TrumpTrainCourse()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.mdata = params;
         this.url = "assets/fabao/trumptraincourse.swf";
      }
      
      override public function setShow() : void
      {
         var j:int = 0;
         EventManager.attachEvent(bg["btn0"],MouseEvent.CLICK,this.on_btn0);
         EventManager.attachEvent(bg["btn1"],MouseEvent.CLICK,this.on_btn1);
         EventManager.attachEvent(bg["btn2"],MouseEvent.CLICK,this.on_btn2);
         for(var i:int = 1; i <= 7; i++)
         {
            EventManager.attachEvent(bg["kec" + i],MouseEvent.CLICK,this.on_kec0_7);
            EventManager.attachEvent(bg["day" + i],MouseEvent.CLICK,this.on_day0_7);
            EventManager.attachEvent(bg["mc" + i],MouseEvent.CLICK,this.on_mc0_7);
            bg["txt" + i].mouseEnabled = false;
         }
         var flag:int = this.mdata.hpLearnValue + this.mdata.speedLearnVale + this.mdata.attackLearnValue + this.mdata.defenceLearnValue + this.mdata.magicLearnValue + this.mdata.resistanceLearnValue;
         if(flag >= 510)
         {
            for(j = 2; j <= 7; j++)
            {
               bg["kec" + j].mouseEnabled = false;
               bg["kec" + j].filters = [this.f];
            }
         }
         else
         {
            bg.kec2.mouseEnabled = Boolean(this.mdata.hpLearnValue < 255);
            bg.kec3.mouseEnabled = Boolean(this.mdata.speedLearnVale < 255);
            bg.kec4.mouseEnabled = Boolean(this.mdata.attackLearnValue < 255);
            bg.kec5.mouseEnabled = Boolean(this.mdata.defenceLearnValue < 255);
            bg.kec6.mouseEnabled = Boolean(this.mdata.magicLearnValue < 255);
            bg.kec7.mouseEnabled = Boolean(this.mdata.resistanceLearnValue < 255);
            bg.kec2.filters = this.mdata.hpLearnValue < 255 ? [] : [this.f];
            bg.kec3.filters = this.mdata.speedLearnVale < 255 ? [] : [this.f];
            bg.kec4.filters = this.mdata.attackLearnValue < 255 ? [] : [this.f];
            bg.kec5.filters = this.mdata.defenceLearnValue < 255 ? [] : [this.f];
            bg.kec6.filters = this.mdata.magicLearnValue < 255 ? [] : [this.f];
            bg.kec7.filters = this.mdata.resistanceLearnValue < 255 ? [] : [this.f];
         }
         bg.kec1.mouseEnabled = Boolean(this.mdata.level < 100);
         bg.kec1.filters = this.mdata.level < 100 ? [] : [this.f];
         this.on_day0_7(null);
      }
      
      private function on_btn0(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_btn1(evt:MouseEvent) : void
      {
         var j:int = 0;
         for(var m:int = 1; m <= 7; m++)
         {
            if(bg["mc" + m].buttonMode == true)
            {
               if(bg["txt" + m].text.indexOf("效益") != -1)
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1072,
                     "flag":1
                  });
                  return;
               }
            }
         }
         var len:int = int(this.courses.length);
         if(len > 0)
         {
            for(j = 0; j < len; j++)
            {
               if(this.courses[j] == null)
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1072,
                     "flag":1
                  });
                  return;
               }
            }
            this.dispatchEvent(new MessageEvent(TrumpEvent.TRAINSETCOURSEBACK,{"course":this.courses}));
            this.disport();
         }
      }
      
      private function on_btn2(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPENSWFWINDOWS,{
            "url":"assets/fabao/trumptrainmonster.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function on_kec0_7(evt:MouseEvent) : void
      {
         var i:int = int(String(evt.currentTarget.name).charAt(3));
         for(var j:int = 1; j <= 7; j++)
         {
            if(bg["mc" + j].currentFrame == 2)
            {
               bg["txt" + j].text = this.Text1[j] + this.Text3[i];
               this.courses[j - 1] = this.Value[i];
               break;
            }
         }
         var flag:Boolean = false;
         for(var m:int = 1; m <= 7; m++)
         {
            if(bg["mc" + m].buttonMode == true)
            {
               bg["mc" + m].gotoAndStop(1);
               if(bg["txt" + m].text.indexOf("效益") != -1 && !flag)
               {
                  bg["mc" + m].gotoAndStop(2);
                  flag = true;
               }
            }
         }
      }
      
      private function on_day0_7(evt:MouseEvent) : void
      {
         var i:int = 1;
         if(Boolean(evt))
         {
            i = int(String(evt.currentTarget.name).charAt(3));
         }
         for(var j:int = 1; j <= 7; j++)
         {
            if(j <= i)
            {
               bg["mc" + j].buttonMode = true;
               bg["mc" + j].gotoAndStop(1);
            }
            else
            {
               bg["mc" + j].buttonMode = false;
               bg["mc" + j].gotoAndStop(3);
            }
            bg["txt" + j].text = this.Text1[j] + this.Text2[j];
         }
         bg.mc1.gotoAndStop(2);
         this.courses = [];
         bg.dayMC.gotoAndStop(i);
      }
      
      private function on_mc0_7(evt:MouseEvent) : void
      {
         if(MovieClip(evt.currentTarget).buttonMode == false)
         {
            return;
         }
         var i:int = int(String(evt.currentTarget.name).charAt(2));
         for(var j:int = 1; j <= 7; j++)
         {
            if(bg["mc" + j].currentFrame == 2)
            {
               bg["mc" + j].gotoAndStop(1);
            }
            bg["mc" + i].gotoAndStop(2);
         }
      }
      
      override public function disport() : void
      {
         if(bg == null)
         {
            return;
         }
         this.courses = [];
         EventManager.removeEvent(bg["btn0"],MouseEvent.CLICK,this.on_btn0);
         EventManager.removeEvent(bg["btn1"],MouseEvent.CLICK,this.on_btn1);
         EventManager.removeEvent(bg["btn2"],MouseEvent.CLICK,this.on_btn2);
         for(var i:int = 1; i <= 7; i++)
         {
            EventManager.removeEvent(bg["kec" + i],MouseEvent.CLICK,this.on_kec0_7);
            EventManager.removeEvent(bg["day" + i],MouseEvent.CLICK,this.on_day0_7);
            EventManager.removeEvent(bg["mc" + i],MouseEvent.CLICK,this.on_mc0_7);
         }
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

