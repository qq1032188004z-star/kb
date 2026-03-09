package com.game.modules.view.item
{
   import com.game.Tools.AttributeCharacterIcon;
   import com.game.util.HtmlUtil;
   import com.game.util.LuaObjUtil;
   import com.game.util.NewTipManager;
   import com.publiccomponent.list.ItemRender;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol466")]
   public class SkillItem extends ItemRender
   {
      
      public var nameTxt:TextField;
      
      public var numTxt:TextField;
      
      public var powerTxt:TextField;
      
      public var spAtt:Sprite;
      
      private var _attIcon:AttributeCharacterIcon;
      
      private var _curData:XML;
      
      private var _repelAry:Array;
      
      public function SkillItem()
      {
         super();
         this.init();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         if(Boolean(this._attIcon))
         {
            this._attIcon.dispose();
            this._attIcon = null;
         }
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         NewTipManager.getInstance().removeToolTip(this);
         super.dispos();
      }
      
      private function init() : void
      {
         this["stop"]();
         this._attIcon = new AttributeCharacterIcon();
         this._attIcon.isShowAttWord = false;
         this._attIcon.isShowTip = false;
         this.spAtt.addChild(this._attIcon);
         this.nameTxt.selectable = false;
         this.numTxt.selectable = false;
         this.powerTxt.selectable = false;
      }
      
      override public function set data(params:Object) : void
      {
         var desc:String = null;
         if(params.skillid != 0)
         {
            if(Boolean(this._curData) && this._curData.idx == params.skillid)
            {
               return;
            }
            this._curData = XMLLocator.getInstance().getSkill(params.skillid);
            params.type = this._curData.type;
            if(!params.hasOwnProperty("skillnum"))
            {
               params.skillnum = this._curData.count;
            }
            if(!params.hasOwnProperty("skillmaxnum"))
            {
               params.skillmaxnum = this._curData.count;
            }
            params.skillname = this._curData.name;
            params.power = this._curData.power;
            params.count = this._curData.count;
            params.desc = this._curData.desc;
            params.elem = int(this._curData.elem);
            this._repelAry = LuaObjUtil.getLuaObjArr(this._curData.repel);
            desc = "";
            if(params.type == "法术技能")
            {
               desc += HtmlUtil.getHtmlText(12,"#6600FF","法术技能" + "\n");
            }
            else
            {
               desc += HtmlUtil.getHtmlText(12,"#FF3300",params.type + "\n");
            }
            desc += HtmlUtil.getHtmlText(12,"#000000","效果：" + params.desc + "\n");
            NewTipManager.getInstance().addToolTip(this,desc);
            this.nameTxt.text = params.skillname;
            this.numTxt.text = params.skillnum + "/" + params.skillmaxnum + "";
            this.powerTxt.text = params.power == 0 ? "--" : params.power + "";
            this._attIcon.id = params.elem;
            if(Boolean(params.hasOwnProperty("canclick")) && params["canclick"] == true)
            {
               this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverSkillItem);
               this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutSkillItem);
            }
            else
            {
               this.closeListener();
            }
            super.data = params;
         }
         else
         {
            NewTipManager.getInstance().removeToolTip(this);
            this._curData = null;
            this._repelAry = null;
            this["gotoAndStop"](2);
         }
      }
      
      private function onMouseOverSkillItem(event:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.BUTTON;
      }
      
      private function onMouseOutSkillItem(event:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.AUTO;
      }
      
      public function getRepel() : Array
      {
         if(Boolean(this._repelAry))
         {
            return this._repelAry;
         }
         return [];
      }
      
      public function getName() : String
      {
         if(Boolean(this._curData))
         {
            return this._curData.name;
         }
         return "";
      }
      
      public function getSkillId() : int
      {
         if(Boolean(this._curData))
         {
            return this._curData.idx;
         }
         return 0;
      }
   }
}

