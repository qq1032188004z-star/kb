package com.game.modules.view.battle.item
{
   import com.game.Tools.AttributeCharacterIcon;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   
   public class BattleSkillItem extends Sprite
   {
      
      private static const GREY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.6,0,0,0,0.3,0.6,0,0,0,0.3,0.6,0,0,0,0,0,0,1,0]);
      
      private var uiSkin:MovieClip;
      
      public var skillname:TextField;
      
      public var skilltimes:TextField;
      
      public var skillpower:TextField;
      
      public var spAtt:Sprite;
      
      public var bgmc:MovieClip;
      
      private var _attIcon:AttributeCharacterIcon;
      
      private var _curXML:XML;
      
      private var _isBOSS:Boolean;
      
      private var _index:int;
      
      public function BattleSkillItem(index:int)
      {
         super();
         this._index = index;
         this.uiSkin = new (ApplicationDomain.currentDomain.getDefinition("skillmc") as Object)();
         this.addChild(this.uiSkin);
         this.spAtt = this.uiSkin["spAtt"];
         this.skillname = this.uiSkin["skillname"];
         this.skilltimes = this.uiSkin["skilltimes"];
         this.skillpower = this.uiSkin["skillpower"];
         this.bgmc = this.uiSkin["bgmc"];
         this._attIcon = new AttributeCharacterIcon();
         this._attIcon.isShowAttWord = false;
         this._attIcon.tipsType = 1;
         this.spAtt.addChild(this._attIcon);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onRollHandler);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onRollHandler);
      }
      
      private function onRollHandler(event:MouseEvent) : void
      {
         this.bgmc.gotoAndStop(event.type == MouseEvent.ROLL_OUT ? 1 : 2);
      }
      
      public function setData(xml:XML, cur:int, max:int, isBOSS:Boolean) : void
      {
         this._curXML = xml;
         this._isBOSS = isBOSS;
         this.skillname.text = "" + this._curXML.name;
         this.skillpower.text = "威力：" + (int(this._curXML.power) == 0 ? "--" : this._curXML.power);
         this._attIcon.id = xml.elem;
         this.updatePP(cur,max);
      }
      
      public function getCurXML() : XML
      {
         return this._curXML;
      }
      
      public function updatePP(cur:int, max:int) : void
      {
         if(this._isBOSS)
         {
            this.skillpower.text = "威力：???";
            this.skilltimes.text = "PP：??/??";
         }
         else
         {
            this.skilltimes.text = "PP：" + cur + "/" + max;
         }
      }
      
      public function isBeUsed(value:Boolean) : void
      {
         if(value)
         {
            this.filters = [];
         }
         else
         {
            this.filters = [GREY_FILTER];
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._attIcon))
         {
            this._attIcon.dispose();
            this._attIcon = null;
         }
         this._curXML = null;
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onRollHandler);
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onRollHandler);
      }
      
      public function get index() : int
      {
         return this._index;
      }
   }
}

