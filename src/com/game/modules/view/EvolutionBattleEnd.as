package com.game.modules.view
{
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import flash.events.MouseEvent;
   
   public class EvolutionBattleEnd extends HLoaderSprite
   {
      
      private var _hurt:int;
      
      private var _score:int;
      
      private var _exp:int;
      
      private var _coin:int;
      
      public function EvolutionBattleEnd()
      {
         super();
         this.url = URLUtil.getSvnVer("assets/activity/201503/Active20150326Evolution/BattleEnd.swf");
      }
      
      override public function setShow() : void
      {
         if(bg)
         {
            bg.hurtTxt.text = this._hurt + "";
            bg.scoreTxt.text = this._score + "";
            bg.expTxt.text = this._exp + "";
            bg.coinTxt.text = this._coin + "";
         }
         this.initEvents();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this._hurt = params.hurt;
         this._score = params.score;
         this._exp = params.exp;
         this._coin = params.coin;
         if(bg)
         {
            bg.hurtTxt.text = this._hurt + "";
            bg.scoreTxt.text = this._score + "";
            bg.expTxt.text = this._exp + "";
            bg.coinTxt.text = this._coin + "";
         }
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         if(bg)
         {
            this.bg.closebtn.addEventListener(MouseEvent.CLICK,this.onClose);
            this.bg.sureBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         }
      }
      
      private function removeEvents() : void
      {
         if(bg)
         {
            this.bg.closebtn.removeEventListener(MouseEvent.CLICK,this.onClose);
            this.bg.sureBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         }
      }
      
      private function onClose($e:MouseEvent) : void
      {
         this.disport();
      }
      
      override public function disport() : void
      {
         this.removeEvents();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this._hurt = 0;
         this._score = 0;
         this._exp = 0;
         this._coin = 0;
      }
   }
}

