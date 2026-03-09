package com.game.modules.view.monster
{
   import com.game.util.HtmlUtil;
   import com.publiccomponent.loading.XMLLocator;
   
   public class SymmEnum
   {
      
      public static const E_Box_Type_Exp:int = 3;
      
      public static const E_Box_Type_Coin:int = 2;
      
      public static const E_Box_Type_Item:int = 1;
      
      public static const E_Box_Type_Decor:int = 4;
      
      public static const E_Box_Type_Spirit:int = 5;
      
      public static const E_Box_Type_STUDY:int = 6;
      
      public static var nativeList:Array = [{
         "id":25,
         "name":"体力"
      },{
         "id":21,
         "name":"攻击"
      },{
         "id":22,
         "name":"防御"
      },{
         "id":23,
         "name":"法术"
      },{
         "id":24,
         "name":"抗性"
      },{
         "id":26,
         "name":"速度"
      },{
         "id":11,
         "name":"威力"
      },{
         "id":12,
         "name":"PP"
      }];
      
      private static var nativeType:Array = [{
         "min":51,
         "max":99
      },{
         "min":1,
         "max":20
      },{
         "min":100,
         "max":200
      },{
         "min":201,
         "max":9999
      }];
      
      public function SymmEnum()
      {
         super();
      }
      
      public static function hasNative(itemData:Object, type:int) : int
      {
         var list:Array = null;
         var symmObj:Object = null;
         var nativeList:Array = null;
         var obj:Object = null;
         var flag:int = -1;
         if(itemData.hasOwnProperty("symmList"))
         {
            list = itemData.symmList;
            if(list.length > 0)
            {
               for each(symmObj in list)
               {
                  if(symmObj.hasOwnProperty("nativeList"))
                  {
                     nativeList = symmObj.nativeList;
                     for each(obj in nativeList)
                     {
                        if(obj.nativeEnum == type)
                        {
                           return type;
                        }
                     }
                  }
               }
            }
         }
         return flag;
      }
      
      public static function getName(id:int) : String
      {
         var obj:Object = null;
         for each(obj in nativeList)
         {
            if(obj.id == id)
            {
               return obj.name;
            }
         }
         return "";
      }
      
      public static function getContentColor(msg:String, type:int = 1) : String
      {
         if(type == 1)
         {
            return "<font color=\'#35DD22\'>" + msg + "</font>";
         }
         return msg;
      }
      
      public static function getSymmTye(id:int) : int
      {
         if(id >= 1 && id <= 20)
         {
            return 1;
         }
         if(id >= 51 && id <= 99)
         {
            return 2;
         }
         if(id >= 100 && id <= 200)
         {
            return 4;
         }
         return -1;
      }
      
      public static function getTipWhite(params:Object, color:String = "#FFFFFF", font:int = 12) : String
      {
         var native:Object = null;
         var desc:String = "";
         for each(native in params.nativeList)
         {
            desc += HtmlUtil.getHtmlText(font,color,native.nativeName + "：");
            desc += HtmlUtil.getHtmlText(font,color," +" + native.nativeValue);
            desc += "\n";
         }
         return desc;
      }
      
      public static function getTips(params:Object, isDesc:Boolean = true) : String
      {
         var desc:* = null;
         var xml:* = null;
         var native:* = null;
         params = params;
         isDesc = isDesc;
         desc = "";
         xml = XMLLocator.getInstance().getTool(params.symmId);
         if(xml != null)
         {
            desc += HtmlUtil.getHtmlText(13,"#FF0000",xml.name) + "\n";
            desc += HtmlUtil.getHtmlText(13,"#596204","描述：");
            desc += HtmlUtil.getHtmlText(13,"#000000",xml.desc) + "\n";
            desc += "\n";
         }
         for each(native in params.nativeList)
         {
            desc += HtmlUtil.getHtmlText(13,"#596204",native.nativeName + "：");
            desc += HtmlUtil.getHtmlText(13,"#000000","   +" + native.nativeValue);
            desc += "\n";
         }
         if(Boolean(params.symmFlag) && Boolean(params.petName) && params.petName != "")
         {
            desc += HtmlUtil.getHtmlText(13,"#FF0000",params.petName + "已装备") + "\n";
         }
         return desc;
      }
   }
}

