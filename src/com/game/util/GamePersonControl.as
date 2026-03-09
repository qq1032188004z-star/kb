package com.game.util
{
   import com.game.locators.GameData;
   import com.publiccomponent.loading.XMLLocator;
   import org.dress.ui.RoleFace;
   
   public class GamePersonControl
   {
      
      public static var instance:GamePersonControl = new GamePersonControl();
      
      private var specilaScenenList:Array = [40002,40003,40004,40005,23002,23003];
      
      private var specialPetAreaList:Array = [{
         "id":5003,
         "pet":90001
      },{
         "id":30007,
         "pet":90002
      }];
      
      public function GamePersonControl()
      {
         super();
      }
      
      public function isInSpecialSceneList() : Boolean
      {
         if(this.specilaScenenList.indexOf(GameData.instance.playerData.sceneId) != -1)
         {
            return true;
         }
         return false;
      }
      
      public function isInPetArearList() : Boolean
      {
         var obj:Object = null;
         for each(obj in this.specialPetAreaList)
         {
            if(obj.id == GameData.instance.playerData.sceneId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getPetId() : int
      {
         var obj:Object = null;
         var petId:int = -1;
         for each(obj in this.specialPetAreaList)
         {
            if(obj.id == GameData.instance.playerData.sceneId)
            {
               petId = int(obj.pet);
               break;
            }
         }
         return petId;
      }
      
      public function updateRoleFace(roleFace:RoleFace, sex:int, params:Object, forceUpdates:Boolean = false) : Object
      {
         var obj:Object = {};
         if(params.taozhuangId != 0)
         {
            obj.taozhuangId = params.taozhuangId;
         }
         if(params.hasOwnProperty("roleType"))
         {
            obj.roleType = params.roleType;
         }
         if(params.clothId == 0)
         {
            obj.clothId = 1000 + sex + 5;
         }
         else
         {
            obj.clothId = params.clothId;
         }
         if(params.faceId == 0)
         {
            obj.faceId = 1000 + sex + 7;
         }
         else
         {
            obj.faceId = params.faceId;
         }
         if(params.hatId == 0)
         {
            obj.hatId = 1000 + sex + 4;
         }
         else
         {
            obj.hatId = params.hatId;
         }
         if(params.footId == 0)
         {
            obj.footId = 1000 + sex + 6;
         }
         else
         {
            obj.footId = params.footId;
         }
         if(params.weaponId != 0)
         {
            obj.weaponId = params.weaponId;
         }
         else
         {
            obj.weaponId = 0;
         }
         if(params.wingId != 0)
         {
            obj.wingId = params.wingId;
         }
         else
         {
            obj.wingId = 0;
         }
         if(params.glassId != 0)
         {
            obj.glassId = params.glassId;
         }
         else
         {
            obj.glassId = 0;
         }
         if(params.leftWeapon != 0)
         {
            obj.leftWeapon = params.leftWeapon;
         }
         else
         {
            obj.leftWeapon = 0;
         }
         roleFace.setRole(obj,"green",false,null,forceUpdates);
         return obj;
      }
      
      public function isInSpecialPetScene(id:int) : Boolean
      {
         var specialList:Array = [1001,1002,1003,1004,1005,1006,1007,1008,1009,1022,1013,1026,1027,1028,1029,1030,11005,1010,1011,1012,1013,1016,1017,40002,40003,40004,40005,30007,2002,2006,5003,30007,2000,3000,70001,6005,14000,14001,10005,1041,1042,1043,1044,1051,1052,1053,1054,1055,1031,1025];
         var result:Boolean = false;
         if(specialList.indexOf(id) == -1)
         {
            return false;
         }
         return true;
      }
      
      public function getOffsetX(id:int) : Number
      {
         var offset:Number = 42;
         if(id == 610015 || id == -610015)
         {
            offset = 80;
         }
         else if(id == 610018)
         {
            offset = 30;
         }
         else if(id > 610001)
         {
            offset = 0;
         }
         else if(id == 600009)
         {
            offset = 2;
         }
         return offset;
      }
      
      public function getOffsetY(id:int) : Number
      {
         var offset:Number = 0;
         if(id == 610015 || id == -610015)
         {
            offset = 45;
         }
         return offset;
      }
      
      public function getMsgOffset(id:int) : Array
      {
         var obj:Object = null;
         var result:Array = [72,-100];
         var offsetList:Array = [{
            "id":600003,
            "offset":[68,-80]
         },{
            "id":600006,
            "offset":[68,-80]
         },{
            "id":600009,
            "offset":[68,-98]
         },{
            "id":600012,
            "offset":[68,-98]
         },{
            "id":600015,
            "offset":[72,-69]
         },{
            "id":600018,
            "offset":[78,-83]
         },{
            "id":600046,
            "offset":[64,-95]
         },{
            "id":600049,
            "offset":[64,-95]
         },{
            "id":610001,
            "offset":[72,-135]
         },{
            "id":600059,
            "offset":[72,-105]
         },{
            "id":600064,
            "offset":[72,-85]
         },{
            "id":600069,
            "offset":[72,-85]
         },{
            "id":610009,
            "offset":[80,-140]
         },{
            "id":610010,
            "offset":[80,-140]
         },{
            "id":600074,
            "offset":[72,-85]
         },{
            "id":600079,
            "offset":[72,-135]
         },{
            "id":600084,
            "offset":[72,-135]
         },{
            "id":600089,
            "offset":[72,-115]
         },{
            "id":600094,
            "offset":[72,-145]
         },{
            "id":600099,
            "offset":[72,-110]
         },{
            "id":600167,
            "offset":[72,-85]
         }];
         for each(obj in offsetList)
         {
            if(obj.id == id)
            {
               result = obj.offset;
               break;
            }
         }
         return result;
      }
      
      public function getFaceOffset(id:int) : Array
      {
         var obj:Object = null;
         var result:Array = [-15,-190];
         var offsetList:Array = [{
            "id":600003,
            "offset":[-10,-168]
         },{
            "id":600006,
            "offset":[-10,-168]
         },{
            "id":600009,
            "offset":[-10,-198]
         },{
            "id":600012,
            "offset":[-10,-198]
         },{
            "id":600015,
            "offset":[-19,-170]
         },{
            "id":600018,
            "offset":[-12,-183]
         },{
            "id":600021,
            "offset":[-15,-200]
         },{
            "id":600043,
            "offset":[-15,-200]
         },{
            "id":600046,
            "offset":[-15,-170]
         },{
            "id":600049,
            "offset":[-15,-170]
         },{
            "id":610001,
            "offset":[-15,-235]
         },{
            "id":600059,
            "offset":[-15,-205]
         },{
            "id":600064,
            "offset":[-15,-185]
         },{
            "id":600069,
            "offset":[-15,-185]
         },{
            "id":610009,
            "offset":[-15,-235]
         },{
            "id":610010,
            "offset":[-15,-235]
         },{
            "id":600079,
            "offset":[-15,-205]
         },{
            "id":600084,
            "offset":[-15,-205]
         },{
            "id":600089,
            "offset":[-15,-205]
         },{
            "id":600094,
            "offset":[-15,-235]
         },{
            "id":600099,
            "offset":[-15,-205]
         },{
            "id":600167,
            "offset":[-15,-175]
         }];
         for each(obj in offsetList)
         {
            if(obj.id == id)
            {
               result = obj.offset;
               break;
            }
         }
         return result;
      }
      
      public function getCollectOffset(id:int) : Array
      {
         var obj:Object = null;
         var result:Array = [-55,-146];
         var offsetList:Array = [{
            "id":600003,
            "offset":[-70,-141]
         },{
            "id":600006,
            "offset":[-30,-141]
         },{
            "id":600009,
            "offset":[-70,-161]
         },{
            "id":600012,
            "offset":[-70,-161]
         },{
            "id":600015,
            "offset":[-42,-153]
         },{
            "id":600018,
            "offset":[-30,-138]
         },{
            "id":600021,
            "offset":[-47,-170]
         },{
            "id":600043,
            "offset":[-47,-170]
         },{
            "id":600046,
            "offset":[-64,-150]
         },{
            "id":600049,
            "offset":[-64,-150]
         },{
            "id":610001,
            "offset":[-55,-181]
         },{
            "id":600059,
            "offset":[-55,-156]
         },{
            "id":600064,
            "offset":[-65,-146]
         },{
            "id":600069,
            "offset":[-65,-146]
         },{
            "id":610009,
            "offset":[-40,-172]
         },{
            "id":610010,
            "offset":[-40,-250]
         },{
            "id":600074,
            "offset":[-65,-146]
         },{
            "id":600079,
            "offset":[-65,-146]
         },{
            "id":600084,
            "offset":[-65,-146]
         },{
            "id":600089,
            "offset":[-65,-156]
         },{
            "id":600094,
            "offset":[-65,-186]
         },{
            "id":600099,
            "offset":[-65,-161]
         }];
         for each(obj in offsetList)
         {
            if(obj.id == id)
            {
               result = obj.offset;
               break;
            }
         }
         return result;
      }
      
      public function getStatusOffset(id:int) : Array
      {
         var obj:Object = null;
         var result:Array = [6,-224];
         var offsetList:Array = [{
            "id":600003,
            "offset":[-37,-216]
         },{
            "id":600006,
            "offset":[3,-216]
         },{
            "id":600009,
            "offset":[-37,-236]
         },{
            "id":600012,
            "offset":[-37,-236]
         },{
            "id":600015,
            "offset":[-15,-235]
         },{
            "id":600018,
            "offset":[0,-220]
         },{
            "id":600021,
            "offset":[-7,-250]
         },{
            "id":600043,
            "offset":[-7,-250]
         },{
            "id":600046,
            "offset":[-29,-230]
         },{
            "id":600049,
            "offset":[-29,-230]
         },{
            "id":610001,
            "offset":[-14,-260]
         },{
            "id":600059,
            "offset":[-14,-234]
         },{
            "id":600064,
            "offset":[-4,-224]
         },{
            "id":600069,
            "offset":[-4,-224]
         },{
            "id":610009,
            "offset":[-14,-250]
         },{
            "id":610010,
            "offset":[-14,-250]
         },{
            "id":600074,
            "offset":[-4,-224]
         },{
            "id":600079,
            "offset":[-4,-224]
         },{
            "id":600084,
            "offset":[-4,-224]
         },{
            "id":600089,
            "offset":[-4,-224]
         },{
            "id":600094,
            "offset":[-4,-254]
         },{
            "id":600099,
            "offset":[-4,-234]
         }];
         for each(obj in offsetList)
         {
            if(obj.id == id)
            {
               result = obj.offset;
               break;
            }
         }
         return result;
      }
      
      public function getNewHorSeId(oldId:int, sex:int) : int
      {
         var newId:int = oldId;
         if(sex <= 0 && oldId > 0)
         {
            newId = -oldId;
         }
         return newId;
      }
      
      public function getRealBorderID(oldId:int) : int
      {
         if(oldId > 1000)
         {
            return oldId;
         }
         var boderlist:XML = XMLLocator.getInstance()["npctransformDic"][oldId];
         if(Boolean(boderlist))
         {
            return int(boderlist.@id);
         }
         return 100027;
      }
      
      public function getYOffsetByPetId(id:int) : Number
      {
         var item:Object = null;
         var yOffset:Number = 0;
         var yOffsetList:Array = [{
            "id":610003,
            "yoffset":32
         },{
            "id":610010,
            "yoffset":25
         },{
            "id":610005,
            "yoffset":25
         },{
            "id":610006,
            "yoffset":20
         },{
            "id":610007,
            "yoffset":15
         },{
            "id":610008,
            "yoffset":15
         },{
            "id":610009,
            "yoffset":-45
         },{
            "id":610010,
            "yoffset":-45
         },{
            "id":600089,
            "yoffset":-10
         },{
            "id":610011,
            "yoffset":35
         },{
            "id":610014,
            "yoffset":43
         },{
            "id":610015,
            "yoffset":48
         },{
            "id":-610015,
            "yoffset":48
         },{
            "id":610018,
            "yoffset":48
         }];
         for each(item in yOffsetList)
         {
            if(item.id == id)
            {
               yOffset = Number(item.yoffset);
               break;
            }
         }
         return yOffset;
      }
      
      public function isInNoWarScene() : Boolean
      {
         var result:Boolean = false;
         var sceneList:Array = [1002,2000,3000,1013,4000,1018,1019,1020,1021,6006,1023,1024,1041,1042,1043,1044,1051,1052,1053,1054];
         if(sceneList.indexOf(GameData.instance.playerData.currentScenenId) == -1)
         {
            result = true;
         }
         return result;
      }
      
      public function isFlyIngHorse(iid:int) : Boolean
      {
         iid = Math.abs(iid);
         return iid > 610000;
      }
      
      public function isFlyIngAndChangeHorse(iid:int) : Boolean
      {
         iid = Math.abs(iid);
         var flyChangeList:Array = [610001,610002,610009,610011,610015,-610015];
         return flyChangeList.indexOf(iid) != -1;
      }
      
      public function isDanceTaoZhuang(id:int) : Boolean
      {
         var danceList:Array = [540001,540002,540007,540008,540005,540006,550232,550233,550512,550513];
         return danceList.indexOf(id) != -1;
      }
      
      public function isInWarScene() : Boolean
      {
         var warSceneList:Array = [15000,200001,200002,200003,200004];
         return warSceneList.indexOf(GameData.instance.playerData.currentScenenId) != -1;
      }
      
      public function isEnterTeamCopy() : Boolean
      {
         var teamCopyList:Array = [10005,9005,12000,200005,200007];
         return teamCopyList.indexOf(GameData.instance.playerData.currentScenenId) != -1;
      }
   }
}

