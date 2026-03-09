package com.game.Tools
{
   import com.kb.util.CommonDefine;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.tips.NewToolTip;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1195")]
   public class AttributeCharacterIcon extends Sprite
   {
      
      public static const TIPS_XML:int = 0;
      
      public static const TIPS_WORLD:int = 1;
      
      private var _isShowTip:Boolean = true;
      
      private var _curID:int;
      
      public var mcAttribute:MovieClip;
      
      public var mcWorld:MovieClip;
      
      public var mcTips:MovieClip;
      
      private var _isShowAttWord:Boolean = true;
      
      private var _tipsType:int;
      
      public function AttributeCharacterIcon()
      {
         super();
         this.mcTips.visible = false;
         this.mcTips.gotoAndStop(1);
         this.mcWorld.gotoAndStop(1);
         this.mcAttribute.gotoAndStop(1);
         this.mcAttribute.addEventListener(MouseEvent.ROLL_OVER,this.onRollHandler);
         this.mcAttribute.addEventListener(MouseEvent.ROLL_OUT,this.onRollHandler);
      }
      
      public function set isShowAttWord(value:Boolean) : void
      {
         this._isShowAttWord = value;
         this.mcWorld.visible = this._isShowAttWord;
      }
      
      private function onRollHandler(event:MouseEvent) : void
      {
         if(this._tipsType == TIPS_WORLD)
         {
            this.mcTips.visible = event.type == MouseEvent.ROLL_OVER;
         }
      }
      
      public function set id(id:int) : void
      {
         id++;
         if(id == this._curID)
         {
            return;
         }
         this._curID = id;
         this.mcAttribute.gotoAndStop(this._curID);
         if(this.mcWorld.visible)
         {
            this.mcWorld.gotoAndStop(this._curID);
         }
         this.initTip();
      }
      
      private function initTip() : void
      {
         var obj:Object = null;
         if(!this._isShowTip)
         {
            return;
         }
         switch(this._tipsType)
         {
            case TIPS_XML:
               obj = XMLLocator.getInstance().getNature(1,CommonDefine.departList[this._curID - 1]);
               NewToolTip.ChangeDOInfo(this,"系别：" + obj.name + "\n" + obj.tips1 + "\n" + obj.tips2);
               break;
            case TIPS_WORLD:
               this.mcTips.gotoAndStop(this._curID);
         }
      }
      
      public function set isShowTip(value:Boolean) : void
      {
         this._isShowTip = value;
         if(!this._isShowTip)
         {
            NewToolTip.LooseDO(this);
         }
      }
      
      public function get elemTips() : String
      {
         if(!CommonDefine.departList[this._curID])
         {
            return null;
         }
         var obj:Object = XMLLocator.getInstance().getNature(1,CommonDefine.departList[this._curID]);
         return "系别：" + obj.name + "\n" + obj.tips1 + "\n" + obj.tips2;
      }
      
      public function dispose() : void
      {
         NewToolTip.LooseDO(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function set tipsType(value:int) : void
      {
         this._tipsType = value;
      }
   }
}

