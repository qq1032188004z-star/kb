package com.game.modules.vo.monster
{
   import com.game.util.HtmlUtil;
   import com.publiccomponent.loading.XMLLocator;
   
   public class SkillIntroVo
   {
      
      public var id:int;
      
      public var name:String;
      
      public var type:String;
      
      public var skilltype:int;
      
      public var elem:int;
      
      public var effect:int;
      
      public var range:int;
      
      public var power:int;
      
      public var count:int = 10;
      
      public var desc:String;
      
      public function SkillIntroVo($id:int)
      {
         super();
         this.id = $id;
         this.initialize();
      }
      
      private function initialize() : void
      {
         var tempXml:XML = XMLLocator.getInstance().getSkill(this.id);
         if(Boolean(tempXml))
         {
            this.type = tempXml.type;
            this.name = tempXml.name;
            this.power = tempXml.power;
            this.count = tempXml.count;
            this.desc = tempXml.desc;
            this.skilltype = tempXml.skilltype;
            this.elem = tempXml.elem;
            this.effect = tempXml.effect;
            this.range = tempXml.range;
         }
         else
         {
            this.name = "未知";
            this.type = "未知";
            this.desc = "未知";
         }
      }
      
      public function toTipString() : String
      {
         var tips:String = "";
         if(this.type == "法术技能")
         {
            tips += HtmlUtil.getHtmlText(12,"#6600FF","法术技能" + "\n");
         }
         else
         {
            tips += HtmlUtil.getHtmlText(12,"#FF3300",this.type + "\n");
         }
         return tips + HtmlUtil.getHtmlText(12,"#000000","效果：" + this.desc + "\n");
      }
   }
}

