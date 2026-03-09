package com.game.modules.view.challenge
{
   import com.core.observer.MessageEvent;
   import com.game.modules.view.WindowLayer;
   import com.game.util.ColorUtil;
   import com.game.util.FloatAlert;
   import com.publiccomponent.list.ItemRender;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol592")]
   public class ChanllengeItem extends ItemRender
   {
      
      public var litgamenameTxt:TextField;
      
      public var scoreTxt:TextField;
      
      public var challengeBtn:SimpleButton;
      
      public var bgMc:MovieClip;
      
      private var obj:Object = {};
      
      public function ChanllengeItem()
      {
         super();
      }
      
      override public function set data(params:Object) : void
      {
         this.obj = params;
         this.bgMc.gotoAndStop(1);
         this.litgamenameTxt.text = params.gamename;
         this.scoreTxt.text = params.score;
         if(Boolean(params.chaShow))
         {
            this.challengeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.challenge);
            this.challengeBtn.filters = [];
         }
         else
         {
            this.challengeBtn.filters = ColorUtil.getColorMatrixFilterGray();
            this.challengeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.errorAlert);
         }
      }
      
      private function challenge(evt:Event) : void
      {
         this.dispatchEvent(new MessageEvent("challegeclick",this.obj));
      }
      
      private function errorAlert(evt:Event) : void
      {
         new FloatAlert().show(WindowLayer.instance.stage,300,300,"该玩家的积分太低，不能挑战哦!");
      }
   }
}

