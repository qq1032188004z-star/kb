package com.game.modules.view.item
{
   import com.game.Tools.AttributeCharacterIcon;
   import com.game.util.HtmlUtil;
   import com.game.util.NewTipManager;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol466")]
   public class NewSkillItem extends MovieClip
   {
      
      public var nameTxt:TextField;
      
      public var numTxt:TextField;
      
      public var powerTxt:TextField;
      
      public var spAtt:Sprite;
      
      private var _attIcon:AttributeCharacterIcon;
      
      public function NewSkillItem()
      {
         super();
         this.init();
      }
      
      public function dispos() : void
      {
         if(Boolean(this._attIcon))
         {
            this._attIcon.dispose();
            this._attIcon = null;
         }
         NewTipManager.getInstance().removeToolTip(this);
      }
      
      private function init() : void
      {
         stop();
         this._attIcon = new AttributeCharacterIcon();
         this._attIcon.isShowAttWord = false;
         this._attIcon.isShowTip = false;
         this.spAtt.addChild(this._attIcon);
         this.nameTxt.selectable = false;
         this.numTxt.selectable = false;
         this.powerTxt.selectable = false;
      }
      
      public function set data(params:Object) : void
      {
         var tempxml:XML = null;
         var desc:String = null;
         if(params.skillid != 0)
         {
            gotoAndStop(1);
            tempxml = XMLLocator.getInstance().getSkill(params.skillid);
            params.type = tempxml.type;
            if(!params.hasOwnProperty("skillnum"))
            {
               params.skillnum = tempxml.count;
            }
            if(!params.hasOwnProperty("skillmaxnum"))
            {
               params.skillmaxnum = tempxml.count;
            }
            params.skillname = tempxml.name;
            params.power = tempxml.power;
            params.count = tempxml.count;
            params.desc = tempxml.desc;
            params.elem = int(tempxml.elem);
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
         }
         else
         {
            NewTipManager.getInstance().removeToolTip(this);
            gotoAndStop(2);
         }
      }
   }
}

