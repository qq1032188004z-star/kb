package com.game.util
{
   import com.game.locators.GameData;
   import com.game.modules.view.WindowLayer;
   
   public class PersonInfoUtil
   {
      
      private static const ARENA_SINGLE_LIST:Array = [{
         "low":1,
         "up":1,
         "id":8
      },{
         "low":2,
         "up":100,
         "id":7
      },{
         "low":101,
         "up":300,
         "id":6
      },{
         "low":301,
         "up":1000,
         "id":5
      },{
         "low":1001,
         "up":3000,
         "id":4
      },{
         "low":3001,
         "up":10000,
         "id":3
      },{
         "low":10001,
         "up":20000,
         "id":2
      },{
         "low":20001,
         "up":-1,
         "id":1
      }];
      
      private static const ARENA_MUL_LIST:Array = [{
         "low":1,
         "up":1,
         "id":8
      },{
         "low":2,
         "up":100,
         "id":7
      },{
         "low":101,
         "up":300,
         "id":6
      },{
         "low":301,
         "up":1000,
         "id":5
      },{
         "low":1001,
         "up":3000,
         "id":4
      },{
         "low":3001,
         "up":5000,
         "id":3
      },{
         "low":5001,
         "up":10000,
         "id":2
      },{
         "low":10001,
         "up":-1,
         "id":1
      }];
      
      public static var levelList:Array = [120,140,180,230,280,350,430,520,610,720,840,960,1100,1250,1400,1570,1750,1940,2130];
      
      public function PersonInfoUtil()
      {
         super();
      }
      
      public static function checkBaiShi(params1:Object, params2:Object) : Boolean
      {
         var value1:int = int(params1.historyValue);
         var value2:int = int(params2.historyValue);
         var value3:int = int(params1.kabuLevel);
         var value4:int = int(params2.kabuLevle);
         var value5:int = int(params1.signTime);
         var value6:int = int(params2.signTime);
         if(params1.maxLevel >= 100)
         {
            if(value1 > value2)
            {
               return true;
            }
            if(value1 == value2)
            {
               if(value3 > value4)
               {
                  return true;
               }
               if(value3 == value4 && value5 < value6)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function rankToFrame(type:int, rank:int) : int
      {
         var id:int = 0;
         var obj:Object = null;
         if(type == 1)
         {
            for each(obj in ARENA_SINGLE_LIST)
            {
               if(rank >= obj.low)
               {
                  if(obj.up != -1)
                  {
                     if(rank <= obj.up)
                     {
                        id = int(obj.id);
                     }
                  }
                  else
                  {
                     id = int(obj.id);
                  }
               }
            }
         }
         else
         {
            for each(obj in ARENA_MUL_LIST)
            {
               if(rank >= obj.low)
               {
                  if(obj.up != -1)
                  {
                     if(rank <= obj.up)
                     {
                        id = int(obj.id);
                     }
                  }
                  else
                  {
                     id = int(obj.id);
                  }
               }
            }
         }
         return id;
      }
      
      public static function getLittleGameLevelName(score:int) : String
      {
         if(score <= 50)
         {
            return "新手上路";
         }
         if(score <= 99)
         {
            return "初露苗头";
         }
         if(score <= 499)
         {
            return "小有名气";
         }
         if(score <= 999)
         {
            return "登堂入室";
         }
         if(score <= 1999)
         {
            return "游戏高手";
         }
         if(score <= 4999)
         {
            return "游戏达人";
         }
         if(score <= 9999)
         {
            return "游戏大师";
         }
         if(score <= 19999)
         {
            return "游戏尊者";
         }
         if(score <= 49999)
         {
            return "游戏之王";
         }
         return "不败之神";
      }
      
      public static function fomatTime(time:int) : String
      {
         var str:String = "";
         var date:Date = new Date(time * 1000);
         return date.getFullYear() + "/" + (date.getMonth() + 1) + "/" + date.getDate();
      }
      
      public static function dressUp(data:Object, clothData:Object) : void
      {
         var left:int = clothData.type % 10;
         if(BitValueUtil.getBitValue(clothData.usableStatus,9))
         {
            if(data.taozhuangId != clothData.id)
            {
               data.taozhuangId = clothData.id;
            }
            else
            {
               data.taozhuangId = 0;
            }
            return;
         }
         data.taozhuangId = 0;
         if(left == 1)
         {
            if(Boolean(data.hasOwnProperty("hatId")) && data.hatId != 0)
            {
               if(data.hatId == clothData.id)
               {
                  data.hatId = 0;
               }
               else
               {
                  data.hatId = clothData.id;
               }
            }
            else
            {
               data.hatId = clothData.id;
            }
         }
         if(left == 2)
         {
            if(Boolean(data.hasOwnProperty("clothId")) && data.clothId != 0)
            {
               if(data.clothId == clothData.id)
               {
                  data.clothId = 0;
               }
               else
               {
                  data.clothId = clothData.id;
               }
            }
            else
            {
               data.clothId = clothData.id;
            }
         }
         if(left == 4)
         {
            if(Boolean(data.hasOwnProperty("footId")) && data.footId != 0)
            {
               if(data.footId == clothData.id)
               {
                  data.footId = 0;
               }
               else
               {
                  data.footId = clothData.id;
               }
            }
            else
            {
               data.footId = clothData.id;
            }
         }
         if(left == 3)
         {
            if(Boolean(data.hasOwnProperty("weaponId")) && data.weaponId != 0)
            {
               if(data.weaponId == clothData.id)
               {
                  data.weaponId = 0;
               }
               else
               {
                  data.weaponId = clothData.id;
               }
            }
            else
            {
               data.weaponId = clothData.id;
            }
         }
         if(left == 8)
         {
            if(Boolean(data.hasOwnProperty("wingId")) && data.wingId != 0)
            {
               if(data.wingId == clothData.id)
               {
                  data.wingId = 0;
               }
               else
               {
                  data.wingId = clothData.id;
               }
            }
            else
            {
               data.wingId = clothData.id;
            }
         }
         if(left == 6)
         {
            if(Boolean(data.hasOwnProperty("glassId")) && data.glassId != 0)
            {
               if(data.glassId == clothData.id)
               {
                  data.glassId = 0;
               }
               else
               {
                  data.glassId = clothData.id;
               }
            }
            else
            {
               data.glassId = clothData.id;
            }
         }
         if(left == 9)
         {
            if(Boolean(data.hasOwnProperty("leftWeapon")) && data.leftWeapon != 0)
            {
               if(data.leftWeapon == clothData.id)
               {
                  data.leftWeapon = 0;
               }
               else
               {
                  data.leftWeapon = clothData.id;
               }
            }
            else
            {
               data.leftWeapon = clothData.id;
            }
         }
      }
      
      public static function dressToArray(data:Object) : Array
      {
         var dressArr:Array = [];
         if(Boolean(data))
         {
            if(Boolean(data.hasOwnProperty("backgroundId")) && data.backgroundId != 0)
            {
               dressArr.push(data.backgroundId);
            }
            if(Boolean(data.hasOwnProperty("taozhuangId")) && data.taozhuangId != 0)
            {
               dressArr.push(data.taozhuangId);
               return dressArr;
            }
            if(Boolean(data.hasOwnProperty("hatId")) && data.hatId != 0)
            {
               dressArr.push(data.hatId);
            }
            if(Boolean(data.hasOwnProperty("clothId")) && data.clothId != 0)
            {
               dressArr.push(data.clothId);
            }
            if(Boolean(data.hasOwnProperty("footId")) && data.footId != 0)
            {
               dressArr.push(data.footId);
            }
            if(Boolean(data.hasOwnProperty("weaponId")) && data.weaponId != 0)
            {
               dressArr.push(data.weaponId);
            }
            if(Boolean(data.hasOwnProperty("wingId")) && data.wingId != 0)
            {
               dressArr.push(data.wingId);
            }
            if(Boolean(data.hasOwnProperty("glassId")) && data.glassId != 0)
            {
               dressArr.push(data.glassId);
            }
            if(Boolean(data.hasOwnProperty("leftWeapon")) && data.leftWeapon != 0)
            {
               dressArr.push(data.leftWeapon);
            }
            if(Boolean(data.hasOwnProperty("faceId")) && data.faceId != 0)
            {
               dressArr.push(data.faceId);
            }
         }
         return dressArr;
      }
      
      public static function toDecorationTips(id:int) : String
      {
         var name:String = null;
         var charm:int = 0;
         var xml:XML = ToolTipStringUtil.getToolXML(id);
         var desc:String = "";
         if(Boolean(xml))
         {
            name = xml.name;
            charm = int(xml.charm);
            desc += HtmlUtil.getHtmlText(12,"#000000","名称: ");
            desc += HtmlUtil.getHtmlText(12,"#FF0000",name) + "\n";
            if(charm > 0)
            {
               desc += HtmlUtil.getHtmlText(12,"#000000","魅力: ");
               desc += HtmlUtil.getHtmlText(12,"#FF0000",charm + "") + "\n";
            }
            return desc;
         }
         return null;
      }
      
      public static function checkScene() : Boolean
      {
         if(GameData.instance.playerData["sceneType"] == 2)
         {
            new FloatAlert().show(WindowLayer.instance,300,200,"请离开副本再执行此操作哦！ ");
            return false;
         }
         if(GameData.instance.playerData["sceneType"] >= 10000 || GameData.instance.playerData.currentScenenId == 15000)
         {
            new FloatAlert().show(WindowLayer.instance,300,200,"请离开战场再执行此操作哦！ ");
            return false;
         }
         return true;
      }
   }
}

