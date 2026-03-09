package com.game.modules.view.kb_class
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import phpcon.PhpConnection;
   import phpcon.PhpEvent;
   import phpcon.PhpEventConst;
   
   public class KB_Class_Train extends HLoaderSprite
   {
      
      private var body:Object;
      
      private var question:Object;
      
      private var tid:int;
      
      private var seconds:int = 60;
      
      private var answer:int = 0;
      
      public function KB_Class_Train()
      {
         GreenLoading.loading.visible = true;
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         if(!params.hasOwnProperty("id"))
         {
            GreenLoading.loading.visible = false;
            return;
         }
         this.body = params;
         this.url = "assets/kbclass/passgame/train.swf";
      }
      
      override public function setShow() : void
      {
         PhpConnection.instance().addEventListener(PhpEventConst.FIRST_QUESETION,this.onPhpBack);
         PhpConnection.instance().addEventListener(PhpEventConst.SPECIALTRAIN,this.onPhpAnswerBack);
         var urlvar:URLVariables = new URLVariables();
         urlvar.uid = GameData.instance.playerData.userId;
         urlvar.type = int(Math.random() * 2) + 1;
         urlvar.selectType = 1;
         PhpConnection.instance().getdata("knowledge/question.php",urlvar);
         for(var i:int = 0; i <= 5; i++)
         {
            if(bg["txt" + i] != null)
            {
               bg["txt" + i].mouseEnabled = false;
            }
            if(bg["btn" + i] != null)
            {
               bg["btn" + i].addEventListener(MouseEvent.CLICK,this.on_btns);
            }
         }
      }
      
      private function onPhpBack(evt:PhpEvent) : void
      {
         this.question = evt.data.list[0];
         bg.txt0.text = this.question.question;
         var i:int = 1;
         while(i <= 4)
         {
            bg["txt" + i].text = "" + this.question["choice" + i];
            i++;
         }
         GreenLoading.loading.visible = false;
         this.tid = setInterval(this.loopHandler,1000);
      }
      
      private function loopHandler() : void
      {
         if(this.seconds > 0)
         {
            --this.seconds;
            bg.txt5.text = this.seconds + "秒";
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1066,
               "flag":8
            });
            ApplicationFacade.getInstance().dispatch(EventConst.REQ_DENGLONG_INFO,{
               "param":3,
               "id":this.body.id,
               "done":0
            });
            this.disport();
         }
      }
      
      private function on_btns(evt:MouseEvent) : void
      {
         var urlvar:URLVariables = null;
         var i:int = 0;
         var code:int = int(String(evt.currentTarget.name).charAt(3));
         if(code == 0)
         {
            this.disport();
         }
         else if(code == 5)
         {
            if(this.question != null && this.answer > 0 && this.answer < 5)
            {
               urlvar = new URLVariables();
               urlvar.uid = GameData.instance.playerData.userId;
               urlvar.type = int(this.question.type);
               urlvar.qid = int(this.question.id);
               urlvar.answer = escape(this.question["choice" + this.answer]);
               urlvar.specialTrain = 1;
               PhpConnection.instance().getdata("knowledge/answer.php",urlvar);
               this.answer = -1;
            }
         }
         else
         {
            this.answer = code;
            for(i = 1; i <= 4; i++)
            {
               bg["btn" + i].filters = [];
            }
            bg["btn" + this.answer].filters = ColorUtil.getGrowFilter();
         }
      }
      
      private function onPhpAnswerBack(evt:PhpEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.REQ_DENGLONG_INFO,{
            "param":3,
            "id":this.body.id,
            "done":evt.data.done
         });
         this.disport();
      }
      
      override public function disport() : void
      {
         clearInterval(this.tid);
         PhpConnection.instance().removeEventListener(PhpEventConst.FIRST_QUESETION,this.onPhpBack);
         PhpConnection.instance().removeEventListener(PhpEventConst.SPECIALTRAIN,this.onPhpAnswerBack);
         var i:int = 0;
         while(i <= 5)
         {
            bg["btn" + i].removeEventListener(MouseEvent.CLICK,this.on_btns);
            i++;
         }
         CacheUtil.deleteObject(KB_Class_Train);
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

