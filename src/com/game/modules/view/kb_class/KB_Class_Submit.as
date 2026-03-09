package com.game.modules.view.kb_class
{
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import phpcon.PhpConnection;
   import phpcon.PhpEvent;
   import phpcon.PhpEventConst;
   
   public class KB_Class_Submit extends HLoaderSprite
   {
      
      private var type:int = 0;
      
      private var attribute:int = 0;
      
      private var list:Array = [0,0,0,0,0,0];
      
      public function KB_Class_Submit()
      {
         GreenLoading.loading.visible = true;
         super();
         this.url = "assets/kbclass/passgame/submit.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         bg.btn1.addEventListener(MouseEvent.CLICK,this.on_btn1);
         bg.btn2.addEventListener(MouseEvent.CLICK,this.on_btn2);
         bg.btn3.addEventListener(MouseEvent.CLICK,this.on_btn3);
         bg.btn4.addEventListener(MouseEvent.CLICK,this.on_btn4);
         bg.btn5.addEventListener(MouseEvent.CLICK,this.on_btn5);
         bg.btn6.addEventListener(MouseEvent.CLICK,this.on_btn6);
         bg.btn7.addEventListener(MouseEvent.CLICK,this.on_btn7);
         for(var i:int = 1; i <= 5; i++)
         {
            bg["txt" + i].addEventListener(MouseEvent.CLICK,this.on_txt);
         }
         GreenLoading.loading.visible = false;
         PhpConnection.instance().addEventListener(PhpEventConst.ADD_QUESTION,this.onPhpBack);
      }
      
      private function on_btn1(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_btn2(evt:MouseEvent) : void
      {
         var i:int = 2;
         while(i <= 4)
         {
            bg["btn" + i].filters = [];
            i++;
         }
         bg.btn2.filters = ColorUtil.getColorMatrixFilterGray();
         this.type = 1;
      }
      
      private function on_btn3(evt:MouseEvent) : void
      {
         var i:int = 2;
         while(i <= 4)
         {
            bg["btn" + i].filters = [];
            i++;
         }
         bg.btn3.filters = ColorUtil.getColorMatrixFilterGray();
         this.type = 2;
      }
      
      private function on_btn4(evt:MouseEvent) : void
      {
         var i:int = 2;
         while(i <= 4)
         {
            bg["btn" + i].filters = [];
            i++;
         }
         bg.btn4.filters = ColorUtil.getColorMatrixFilterGray();
         this.type = 3;
      }
      
      private function on_btn5(evt:MouseEvent) : void
      {
         bg.btn6.filters = [];
         bg.btn5.filters = ColorUtil.getColorMatrixFilterGray();
         this.attribute = 1;
      }
      
      private function on_btn6(evt:MouseEvent) : void
      {
         bg.btn5.filters = [];
         bg.btn6.filters = ColorUtil.getColorMatrixFilterGray();
         this.attribute = 2;
      }
      
      private function on_btn7(evt:MouseEvent) : void
      {
         var urlvar:URLVariables = new URLVariables();
         urlvar.type = this.type;
         urlvar.uid = GameData.instance.playerData.userId;
         urlvar.uname = GameData.instance.playerData.userName;
         urlvar.attribute = this.attribute;
         urlvar.question = bg.txt1.text;
         urlvar.answer = bg.txt2.text;
         urlvar.choice1 = bg.txt3.text;
         urlvar.choice2 = bg.txt4.text;
         urlvar.choice3 = bg.txt5.text;
         if(urlvar.type == 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1066,
               "flag":1,
               "stage":this.stage
            });
         }
         else if(urlvar.attribute == 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1066,
               "flag":2,
               "stage":this.stage
            });
         }
         else if(urlvar.question == "" || this.list[1] == 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1066,
               "flag":3,
               "stage":this.stage
            });
         }
         else if(urlvar.answer == "" || urlvar.choice1 == "" || urlvar.choice2 == "" || urlvar.choice3 == "" || this.list[2] == 0 || this.list[3] == 0 || this.list[4] == 0 || this.list[5] == 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1066,
               "flag":4,
               "stage":this.stage
            });
         }
         else
         {
            bg.btn7.mouseEnabled = false;
            PhpConnection.instance().getdata("knowledge/add_question.php",urlvar);
         }
      }
      
      private function onPhpBack(evt:PhpEvent) : void
      {
         if(evt.data.done <= 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1066,
               "flag":5
            });
         }
         else if(evt.data.done >= 4)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1066,
               "flag":6
            });
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1066,
               "flag":7
            });
         }
         this.disport();
      }
      
      private function on_txt(evt:MouseEvent) : void
      {
         var i:int = int(String(evt.currentTarget.name).charAt(3));
         bg["txt" + i].text = "";
         bg["txt" + i].removeEventListener(MouseEvent.CLICK,this.on_txt);
         this.list[i] = 1;
      }
      
      override public function disport() : void
      {
         bg.btn1.removeEventListener(MouseEvent.CLICK,this.on_btn1);
         bg.btn2.removeEventListener(MouseEvent.CLICK,this.on_btn2);
         bg.btn3.removeEventListener(MouseEvent.CLICK,this.on_btn3);
         bg.btn4.removeEventListener(MouseEvent.CLICK,this.on_btn4);
         bg.btn5.removeEventListener(MouseEvent.CLICK,this.on_btn5);
         bg.btn6.removeEventListener(MouseEvent.CLICK,this.on_btn6);
         bg.btn7.removeEventListener(MouseEvent.CLICK,this.on_btn7);
         for(var i:int = 1; i <= 5; i++)
         {
            bg["txt" + i].removeEventListener(MouseEvent.CLICK,this.on_txt);
         }
         PhpConnection.instance().removeEventListener(PhpEventConst.ADD_QUESTION,this.onPhpBack);
         CacheUtil.deleteObject(KB_Class_Submit);
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

