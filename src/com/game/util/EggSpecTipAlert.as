package com.game.util
{
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol727")]
   public class EggSpecTipAlert extends Sprite
   {
      
      public var nameTf:TextField;
      
      public var skillNameTf:TextField;
      
      public var skillPowerTf:TextField;
      
      public var skillTimesTf:TextField;
      
      public var typeClip:MovieClip;
      
      public var backClip:MovieClip;
      
      public var lvClip:MovieClip;
      
      public var skillNextBtn:SimpleButton;
      
      public var skillPreBtn:SimpleButton;
      
      private var _data:Object;
      
      private var _selectSkillIndex:int;
      
      public function EggSpecTipAlert()
      {
         super();
         this.clearData();
         mouseEnabled = true;
         mouseChildren = true;
      }
      
      public function set data($data:Object) : void
      {
         this._data = $data;
         this._selectSkillIndex = 0;
         if(this._data == null)
         {
            this.clearData();
            return;
         }
         var eggType:int = int($data.eggType);
         var character:int = int($data.character);
         var frame:int = eggType == 1 ? 1 : 2;
         this.typeClip.gotoAndStop(frame);
         if(character > 0 && character <= 6)
         {
            this.lvClip.gotoAndStop(character);
         }
         this.nameTf.text = "【" + this._data.name + "】" + "精魄";
         this.updateSkill();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this.backClip.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.skillNextBtn.addEventListener(MouseEvent.CLICK,this.onSelectNextSkill);
         this.skillPreBtn.addEventListener(MouseEvent.CLICK,this.onSelectPreSkill);
      }
      
      private function removeEvent() : void
      {
         this.backClip.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.skillNextBtn.removeEventListener(MouseEvent.CLICK,this.onSelectNextSkill);
         this.skillPreBtn.removeEventListener(MouseEvent.CLICK,this.onSelectPreSkill);
      }
      
      private function onSelectNextSkill($e:MouseEvent) : void
      {
         if(this._data == null || this._selectSkillIndex >= this._data.skillList.length - 1)
         {
            return;
         }
         ++this._selectSkillIndex;
         this.updateSkill();
      }
      
      private function onSelectPreSkill($e:MouseEvent) : void
      {
         if(this._data == null || this._selectSkillIndex < 0)
         {
            return;
         }
         --this._selectSkillIndex;
         this.updateSkill();
      }
      
      private function updateSkill() : void
      {
         if(this._data == null)
         {
            this.clearData();
            return;
         }
         var skillList:Array = this._data.skillList;
         if(skillList.length == 0)
         {
            this.skillNameTf.text = "无";
            this.skillPowerTf.text = "";
            this.skillTimesTf.text = "";
            this.disableBtn(this.skillNextBtn);
            this.disableBtn(this.skillPreBtn);
            return;
         }
         var id:int = skillList[this._selectSkillIndex] as int;
         var tempxml:XML = XMLLocator.getInstance().getSkill(id);
         if(Boolean(tempxml))
         {
            this.skillNameTf.text = tempxml.name;
            this.skillPowerTf.text = tempxml.power == 0 ? "威力:" + "--" : "威力:" + tempxml.power + "";
            this.skillTimesTf.text = "pp:" + tempxml.count + "";
         }
         if(this._selectSkillIndex == skillList.length - 1 && this._selectSkillIndex == 0)
         {
            this.disableBtn(this.skillNextBtn);
            this.disableBtn(this.skillPreBtn);
         }
         else if(this._selectSkillIndex >= skillList.length - 1)
         {
            this.disableBtn(this.skillNextBtn);
            this.enableBtn(this.skillPreBtn);
         }
         else if(this._selectSkillIndex <= 0)
         {
            this.disableBtn(this.skillPreBtn);
            this.enableBtn(this.skillNextBtn);
         }
         else
         {
            this.enableBtn(this.skillNextBtn);
            this.enableBtn(this.skillPreBtn);
         }
      }
      
      private function disableBtn($btn:SimpleButton) : void
      {
         $btn.enabled = false;
         $btn.mouseEnabled = false;
         $btn.filters = [new ColorMatrixFilter([0.4,0.4,0.4,0,0,0.4,0.4,0.4,0,0,0.4,0.4,0.4,0,0,0,0,0,1,0])];
      }
      
      private function enableBtn($btn:SimpleButton) : void
      {
         $btn.enabled = true;
         $btn.mouseEnabled = true;
         $btn.filters = [];
      }
      
      private function onMouseOver($e:MouseEvent) : void
      {
         $e.stopImmediatePropagation();
      }
      
      public function set visibleStatus($value:Boolean) : void
      {
         if(this._data == null)
         {
            this.clearData();
            this.visible = false;
            return;
         }
         this.visible = $value;
      }
      
      private function clearData() : void
      {
         this.typeClip.gotoAndStop(1);
         this.lvClip.gotoAndStop(1);
         this.disableBtn(this.skillNextBtn);
         this.disableBtn(this.skillPreBtn);
         this._selectSkillIndex = 0;
         this.nameTf.text = "没有数据";
         this.skillNameTf.text = "无";
         this.skillPowerTf.text = "";
         this.skillTimesTf.text = "";
      }
      
      public function dispos() : void
      {
         this.clearData();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._data = null;
      }
   }
}

