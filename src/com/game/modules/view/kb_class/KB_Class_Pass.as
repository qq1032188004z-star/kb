package com.game.modules.view.kb_class
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.utils.clearInterval;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setInterval;
   import phpcon.PhpConnection;
   import phpcon.PhpEvent;
   import phpcon.PhpEventConst;
   
   public class KB_Class_Pass extends HLoaderSprite
   {
      
      public static var Flag:int = 1;
      
      public static var Times:int = 0;
      
      public var data:Object;
      
      public var Questions:Array;
      
      private const Exp:Array = [10,20,30,40,50,100,110,120,130,140,200,250,300,350,500];
      
      private var tid:int;
      
      private var seconds:int = 60;
      
      private var answer:int = 0;
      
      private var currentIndex:int = 0;
      
      private var currentTime:int = -1;
      
      public function KB_Class_Pass()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         if(params == null)
         {
            return;
         }
         this.data = params;
         this.Questions = params.list as Array;
         GreenLoading.loading.visible = true;
         this.url = "assets/kbclass/passgame/pass.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         bg.btn5.addEventListener(MouseEvent.CLICK,this.on_btn5);
         bg.btn6.addEventListener(MouseEvent.CLICK,this.on_btn6);
         bg.btn7.addEventListener(MouseEvent.CLICK,this.on_btn7);
         bg.btn8.addEventListener(MouseEvent.CLICK,this.on_btn8);
         bg.btn9.addEventListener(MouseEvent.CLICK,this.on_btn9);
         var j:int = 1;
         while(j <= 9)
         {
            bg["txt" + j].mouseEnabled = false;
            j++;
         }
         for(var i:int = 1; i <= 4; i++)
         {
            bg["btn" + i].addEventListener(MouseEvent.CLICK,this.on_btn1_4);
            bg["txt" + i].text = "" + this.Questions[0]["choice" + i];
            bg["mc" + i].gotoAndStop(2);
            if(i < 4)
            {
               bg["tmc" + i].visible = false;
            }
         }
         bg.tmc1.visible = true;
         this.startAnswer(0,60);
         GreenLoading.loading.visible = false;
         PhpConnection.instance().addEventListener(PhpEventConst.QUESTION_LIST,this.onPhpListBack);
         PhpConnection.instance().addEventListener(PhpEventConst.ANSWER,this.onPhpAnswerBack);
         PhpConnection.instance().addEventListener(PhpEventConst.HELP_PHP,this.onHelpBack);
         var urlvar:URLVariables = new URLVariables();
         urlvar.type = this.Questions[0].type;
         urlvar.uid = GameData.instance.playerData.userId;
         urlvar.firstid = this.Questions[0].id;
         PhpConnection.instance().getdata("knowledge/question.php",urlvar);
      }
      
      private function startAnswer(i:int, time:int) : void
      {
         this.currentIndex = i;
         bg.mc0.gotoAndStop(i + 1);
         if(this.Questions[i] == null)
         {
            clearInterval(this.tid);
            new Alert().show("搞毛，题目都木有~");
            return;
         }
         bg.txt6.text = "" + this.Questions[i].question;
         bg.txt7.text = "" + this.Questions[i].source;
         bg.txt8.text = Boolean("" + (this.Questions[i].attribute == 2)) ? "转载" : "原创";
         var temp:int = 0;
         var p:int = 0;
         while(p <= i)
         {
            temp += this.Exp[p];
            p++;
         }
         bg.txt9.text = "" + temp;
         this.seconds = time;
         clearInterval(this.tid);
         this.tid = setInterval(this.loopHandler,1000);
      }
      
      private function loopHandler() : void
      {
         var i:int = 0;
         if(this.seconds > 0)
         {
            --this.seconds;
         }
         else
         {
            clearInterval(this.tid);
            if(this.currentTime >= 0)
            {
               i = 1;
               while(i < 4)
               {
                  bg["tmc" + i].visible = false;
                  i++;
               }
               bg.tmc1.visible = true;
               this.startAnswer(this.currentIndex,this.currentTime);
               this.currentTime = -1;
            }
            else
            {
               this.getSeverExp(2);
            }
         }
         bg.txt5.text = this.seconds + "";
      }
      
      private function on_btn1_4(evt:MouseEvent) : void
      {
         var index:int = int(String(evt.currentTarget.name).charAt(3));
         for(var i:int = 1; i <= 4; i++)
         {
            if(bg["mc" + i].currentFrame != 3)
            {
               bg["mc" + i].gotoAndStop(2);
            }
         }
         bg["mc" + index].gotoAndStop(1);
         this.answer = index;
      }
      
      private function on_btn5(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.JUSTSENDTOSERVER);
         this.disport();
      }
      
      private function on_btn6(evt:MouseEvent) : void
      {
         var i:int = 1;
         while(i < 4)
         {
            bg["tmc" + i].visible = false;
            i++;
         }
         bg.tmc1.visible = true;
         bg.btn6.mouseEnabled = false;
         bg.btn6.filters = ColorUtil.getColorMatrixFilterGray();
         var urlvar:URLVariables = new URLVariables();
         urlvar.type = this.Questions[this.currentIndex].type;
         urlvar.qid = this.Questions[this.currentIndex].id;
         urlvar.del = 1;
         PhpConnection.instance().getdata("knowledge/help.php",urlvar);
      }
      
      private function on_btn7(evt:MouseEvent) : void
      {
         bg.btn7.mouseEnabled = false;
         bg.btn7.filters = ColorUtil.getColorMatrixFilterGray();
         var i:int = 1;
         while(i < 4)
         {
            bg["tmc" + i].visible = false;
            i++;
         }
         bg.tmc2.visible = true;
         var urlvar:URLVariables = new URLVariables();
         urlvar.type = this.Questions[this.currentIndex].type;
         urlvar.qid = this.Questions[this.currentIndex].id;
         urlvar.choice1 = this.Questions[this.currentIndex].choice1;
         urlvar.choice2 = this.Questions[this.currentIndex].choice2;
         urlvar.choice3 = this.Questions[this.currentIndex].choice3;
         urlvar.choice4 = this.Questions[this.currentIndex].choice4;
         PhpConnection.instance().getdata("knowledge/help.php",urlvar);
      }
      
      private function on_btn8(evt:MouseEvent) : void
      {
         bg.btn8.mouseEnabled = false;
         bg.btn8.filters = ColorUtil.getColorMatrixFilterGray();
         var i:int = 1;
         while(i < 4)
         {
            bg["tmc" + i].visible = false;
            i++;
         }
         bg.tmc3.visible = true;
         this.currentTime = int(bg.txt5.text);
         this.startAnswer(this.currentIndex,60);
      }
      
      private function on_btn9(evt:MouseEvent) : void
      {
         var urlvar:URLVariables = null;
         if(this.answer > 0 && this.answer < 5)
         {
            if(this.Questions[this.currentIndex] == null)
            {
               new Alert().show("没题目了啊，搞毛~");
               return;
            }
            urlvar = new URLVariables();
            urlvar.uid = GameData.instance.playerData.userId;
            urlvar.type = this.Questions[this.currentIndex].type;
            urlvar.qid = this.Questions[this.currentIndex].id;
            urlvar.answer = escape(this.Questions[this.currentIndex]["choice" + this.answer]);
            PhpConnection.instance().getdata("knowledge/answer.php",urlvar);
            this.answer = -1;
         }
      }
      
      private function onPhpAnswerBack(evt:PhpEvent) : void
      {
         var j:int = 0;
         var i:int = 0;
         if(evt.data.done == 1)
         {
            if(this.currentIndex == 14)
            {
               trace("太有才了！GAME OVER.");
               this.getSeverExp(1,evt.data.passAll);
            }
            else
            {
               j = 1;
               while(j < 4)
               {
                  bg["tmc" + j].visible = false;
                  j++;
               }
               bg.tmc1.visible = true;
               this.answer = 0;
               ++this.currentIndex;
               for(i = 1; i <= 4; i++)
               {
                  bg["txt" + i].text = "" + this.Questions[this.currentIndex]["choice" + i];
                  bg["mc" + i].gotoAndStop(2);
                  bg["btn" + i].mouseEnabled = true;
               }
               this.currentTime = -1;
               this.startAnswer(this.currentIndex,60);
            }
         }
         else
         {
            trace("太遗憾了，答错了！GAME OVER.");
            this.getSeverExp(2);
         }
      }
      
      private function onPhpListBack(evt:PhpEvent) : void
      {
         if(evt.data.done > 5)
         {
            new Alert().show("你今天已经闯关五次了吧~" + evt.data.done);
            this.disport();
            return;
         }
         this.Questions = this.Questions.concat(evt.data.list);
      }
      
      private function onHelpBack(evt:PhpEvent) : void
      {
         var i:int = 0;
         var j:int = 0;
         var list:Object = evt.data.list;
         if(!list.hasOwnProperty("length"))
         {
            for(i = 1; i <= 4; i++)
            {
               bg.tmc2["mc" + i].gotoAndStop(list["choice" + i]);
               bg.tmc2["txt" + i].text = list["choice" + i] + "%";
            }
         }
         else
         {
            for(j = 1; j <= 4; j++)
            {
               if(bg["txt" + j].text == list[0] || bg["txt" + j].text == list[1])
               {
                  bg["mc" + j].gotoAndStop(3);
                  bg["btn" + j].mouseEnabled = false;
               }
            }
         }
      }
      
      private function getSeverExp(pass:int, times:int = 0) : void
      {
         Times = times;
         Flag = pass;
         clearInterval(this.tid);
         this.mouseEnabled = false;
         if(this.currentIndex < 5)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
               "exp":0,
               "showX":0,
               "showY":0
            },null,getQualifiedClassName(PassAlert));
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.GETCLASSPASSEXP,this.data.done);
         }
      }
      
      override public function disport() : void
      {
         clearInterval(this.tid);
         PhpConnection.instance().removeEventListener(PhpEventConst.QUESTION_LIST,this.onPhpListBack);
         PhpConnection.instance().removeEventListener(PhpEventConst.ANSWER,this.onPhpAnswerBack);
         PhpConnection.instance().removeEventListener(PhpEventConst.HELP_PHP,this.onHelpBack);
         for(var i:int = 1; i <= 4; i++)
         {
            bg["btn" + i].removeEventListener(MouseEvent.CLICK,this.on_btn1_4);
         }
         bg.btn5.removeEventListener(MouseEvent.CLICK,this.on_btn5);
         bg.btn6.removeEventListener(MouseEvent.CLICK,this.on_btn6);
         bg.btn7.removeEventListener(MouseEvent.CLICK,this.on_btn7);
         bg.btn8.removeEventListener(MouseEvent.CLICK,this.on_btn8);
         bg.btn9.removeEventListener(MouseEvent.CLICK,this.on_btn9);
         CacheUtil.deleteObject(KB_Class_Pass);
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

