package com.game.modules.view.battle.item
{
   import com.game.Tools.AttributeCharacterIcon;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol743")]
   public class BattleDisplayItem extends Sprite
   {
      
      public var spAtt:Sprite;
      
      public var txtName:TextField;
      
      public var txtPowe:TextField;
      
      public var txtPP:TextField;
      
      private var _attIcon:AttributeCharacterIcon;
      
      private var _curData:Object;
      
      public function BattleDisplayItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._attIcon = new AttributeCharacterIcon();
         this._attIcon.isShowAttWord = false;
         this._attIcon.tipsType = 1;
         this.spAtt.addChild(this._attIcon);
      }
      
      public function setData(obj:Object) : void
      {
         this._curData = obj;
         var xml:XML = this._curData.xml;
         this.txtName.text = String(xml.name);
         this.txtPowe.text = "威力：" + (int(xml.power) == 0 ? "--" : int(xml.power));
         this._attIcon.id = xml.elem;
         this.updatePP(this._curData["time"]);
      }
      
      public function updatePP(cur:int) : void
      {
         this.txtPP.text = "PP：" + cur;
      }
      
      public function updatePPAndMax(cur:int, max:int) : void
      {
         this.txtPP.text = "PP：" + cur + "/" + max;
      }
      
      public function disose() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

