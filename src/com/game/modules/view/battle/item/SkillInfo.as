package com.game.modules.view.battle.item
{
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol795")]
   public class SkillInfo extends Sprite
   {
      
      private static var _instance:SkillInfo;
      
      public var skill1name:TextField;
      
      public var skill2name:TextField;
      
      public var skill3name:TextField;
      
      public var skill4name:TextField;
      
      public var skill1time:TextField;
      
      public var skill2time:TextField;
      
      public var skill3time:TextField;
      
      public var skill4time:TextField;
      
      public var skill1power:TextField;
      
      public var skill2power:TextField;
      
      public var skill3power:TextField;
      
      public var skill4power:TextField;
      
      public var skill1a:MovieClip;
      
      public var skill2a:MovieClip;
      
      public var skill3a:MovieClip;
      
      public var skill4a:MovieClip;
      
      private var tipparent:*;
      
      public function SkillInfo()
      {
         super();
      }
      
      public static function instance() : SkillInfo
      {
         if(_instance == null)
         {
            _instance = new SkillInfo();
         }
         return _instance;
      }
      
      public function setShow(showSkill:Array, parent:DisplayObjectContainer, x:int, y:int) : void
      {
         var i:int = 0;
         var xml:XML = null;
         var l:int = int(showSkill.length);
         for(i = 0; i < l; i++)
         {
            xml = XMLLocator.getInstance().getSkill(showSkill[i].skillid);
            if(Boolean(xml))
            {
               this["skill" + (i + 1) + "name"].text = "" + xml.name;
               this["skill" + (i + 1) + "time"].text = "PP:" + showSkill[i].time + "/" + showSkill[i].maxtime;
               this["skill" + (i + 1) + "power"].text = "威力值:" + (int(xml.power) == 0 ? "--" : xml.power);
               this["skill" + (i + 1) + "a"].gotoAndStop(int(xml.elem) + 1);
               this["skill" + (i + 1) + "name"].visible = true;
               this["skill" + (i + 1) + "time"].visible = true;
               this["skill" + (i + 1) + "power"].visible = true;
               this["skill" + (i + 1) + "a"].visible = true;
            }
         }
         for(i = 3; i >= l; i--)
         {
            this["skill" + (i + 1) + "name"].visible = false;
            this["skill" + (i + 1) + "time"].visible = false;
            this["skill" + (i + 1) + "power"].visible = false;
            this["skill" + (i + 1) + "a"].gotoAndStop(1);
            this["skill" + (i + 1) + "a"].visible = false;
         }
         SkillInfo.instance().x = x;
         SkillInfo.instance().y = y;
         parent.addChild(SkillInfo.instance());
         this.tipparent = parent;
      }
      
      public function destroy() : void
      {
         this.skill1a.stop();
         this.skill2a.stop();
         this.skill3a.stop();
         this.skill4a.stop();
      }
      
      public function hide() : void
      {
         var b:Boolean = false;
         if(this.tipparent)
         {
            b = Boolean(this.tipparent.contains(SkillInfo.instance()));
            if(b)
            {
               this.tipparent.removeChild(SkillInfo.instance());
               this.tipparent = null;
            }
         }
      }
   }
}

