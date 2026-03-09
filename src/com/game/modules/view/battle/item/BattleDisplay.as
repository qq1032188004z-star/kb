package com.game.modules.view.battle.item
{
   import com.game.locators.GameData;
   import com.xygame.module.battle.data.SpiritData;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol672")]
   public class BattleDisplay extends Sprite
   {
      
      public var txtRound:TextField;
      
      public var spSkillInfo:MovieClip;
      
      public var btnSkillIcon:SimpleButton;
      
      private var _itemList:Vector.<BattleDisplayItem>;
      
      private var _curRound:int;
      
      private var _curInfo:SpiritData;
      
      public function BattleDisplay(da:SpiritData)
      {
         super();
         this._curInfo = da;
         this._itemList = new Vector.<BattleDisplayItem>();
         var ary:Array = da.skillArr;
         for(var i:int = 0; i < ary.length; i++)
         {
            this._itemList.push(new BattleDisplayItem());
            this._itemList[i].x = i % 2 == 0 ? -160 : 3;
            this._itemList[i].y = int(i / 2) * 70 - 76;
            this.spSkillInfo.addChild(this._itemList[i]);
         }
         this.spSkillInfo["bg"].height = Math.ceil(ary.length / 2) * 70 + 76;
         this._curRound = GameData.instance.lookBattle == 1 ? -1 : 0;
         this.spSkillInfo.visible = false;
         this.btnSkillIcon.addEventListener(MouseEvent.ROLL_OUT,this.onSkillRoll);
         this.btnSkillIcon.addEventListener(MouseEvent.ROLL_OVER,this.onSkillRoll);
         this.spSkillInfo["txtName"]["text"] = this._curInfo.name;
         this.update(da.skillArr);
      }
      
      public function disose() : void
      {
         var item:BattleDisplayItem = null;
         if(Boolean(this._itemList))
         {
            for each(item in this._itemList)
            {
               item.disose();
            }
            this._itemList = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function onSkillRoll(event:MouseEvent) : void
      {
         this.spSkillInfo.visible = event.type == MouseEvent.ROLL_OVER;
      }
      
      public function newRound() : void
      {
         ++this._curRound;
         this.txtRound.text = this._curRound.toString();
      }
      
      public function update(ary:Array) : void
      {
         var item:BattleDisplayItem = null;
         for(var i:int = 0; i < this._itemList.length; i++)
         {
            item = this._itemList[i];
            item.visible = ary.length > i;
            if(item.visible)
            {
               item.setData(ary[i]);
            }
         }
      }
      
      public function get curInfo() : SpiritData
      {
         return this._curInfo;
      }
   }
}

