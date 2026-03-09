package com.game.util
{
   import com.publiccomponent.loading.XMLLocator;
   
   public class ToolTipStringUtil
   {
      
      public function ToolTipStringUtil()
      {
         super();
      }
      
      public static function getToolXML($id:int) : XML
      {
         return XMLLocator.getInstance().tooldic[$id] as XML;
      }
      
      public static function getSpriteXML($id:int) : XML
      {
         return XMLLocator.getInstance().getSprited($id);
      }
      
      public static function getSkillXML(id:int) : XML
      {
         return XMLLocator.getInstance().getSkill(id);
      }
      
      public static function toPackTipString($id:int) : String
      {
         var name:String = null;
         var charm:int = 0;
         var descStr:String = null;
         var desc:String = "";
         var xml:XML = getToolXML($id);
         if(Boolean(xml))
         {
            name = xml.name;
            descStr = xml.desc;
            charm = int(xml.charm);
         }
         else if($id == 1)
         {
            name = "铜钱";
            descStr = "铜钱";
         }
         else
         {
            name = "未知";
            descStr = "未知";
         }
         desc += HtmlUtil.getHtmlText(12,"#000000","名称: ");
         desc += HtmlUtil.getHtmlText(12,"#FF0000",name) + "\n";
         if(charm > 0)
         {
            desc += HtmlUtil.getHtmlText(12,"#000000","魅力: ");
            desc += HtmlUtil.getHtmlText(12,"#FF0000",charm + "") + "\n";
         }
         desc += HtmlUtil.getHtmlText(12,"#000000","描述: ");
         return desc + (HtmlUtil.getHtmlText(12,"#000000",descStr) + "\n");
      }
      
      public static function getToolName($id:int) : String
      {
         var targetName:String = null;
         var xml:XML = getToolXML($id);
         if(Boolean(xml))
         {
            targetName = String(xml.name);
         }
         else
         {
            targetName = "未知";
         }
         return targetName;
      }
      
      public static function getSkillName(id:int) : String
      {
         var targetName:String = null;
         var xml:XML = getSkillXML(id);
         if(Boolean(xml))
         {
            targetName = String(xml.name);
         }
         else
         {
            targetName = "未知";
         }
         return targetName;
      }
      
      public static function getToolDesc($id:int) : String
      {
         var desc:String = null;
         var xml:XML = getToolXML($id);
         if(Boolean(xml))
         {
            desc = String(xml.desc);
         }
         else
         {
            desc = $id + "未知描述";
         }
         return desc;
      }
      
      public static function toSpriteTipString($id:int) : String
      {
         var name:String = null;
         var duceStr:String = null;
         var introduce:String = "";
         var xml:XML = getSpriteXML($id);
         if(Boolean(xml))
         {
            name = xml.name;
            duceStr = xml.introduce;
         }
         else
         {
            name = "未知";
            duceStr = "未知";
         }
         introduce += HtmlUtil.getHtmlText(12,"#000000","名字: ");
         introduce += HtmlUtil.getHtmlText(12,"#FF0000",name) + "\n";
         introduce += HtmlUtil.getHtmlText(12,"#000000","简介: ");
         return introduce + (HtmlUtil.getHtmlText(12,"#000000",duceStr) + "\n");
      }
      
      public static function getSpriteName($id:int) : String
      {
         var targetName:String = null;
         var xml:XML = getSpriteXML($id);
         if(Boolean(xml))
         {
            targetName = String(xml.name);
         }
         else
         {
            targetName = "未知";
         }
         return targetName;
      }
      
      public static function getSpriteDesc($id:int) : String
      {
         var desc:String = null;
         var xml:XML = getSpriteXML($id);
         if(Boolean(xml))
         {
            desc = String(xml.introduce);
         }
         else
         {
            desc = $id + "未知描述";
         }
         return desc;
      }
   }
}

