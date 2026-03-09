package com.game.modules.view.team
{
   import flash.utils.Dictionary;
   
   public class TeamNotScene
   {
      
      private static var _listScene:Dictionary;
      
      public function TeamNotScene()
      {
         super();
      }
      
      private static function get listScene() : Dictionary
      {
         if(_listScene == null)
         {
            _listScene = new Dictionary();
            _listScene[1002] = {
               "id":1002,
               "name":"家园"
            };
            _listScene[1013] = {
               "id":1013,
               "name":"神兽园"
            };
            _listScene[1041] = {
               "id":1041,
               "name":"家族广场"
            };
            _listScene[1042] = {
               "id":1042,
               "name":"家族广场"
            };
            _listScene[1043] = {
               "id":1043,
               "name":"家族广场"
            };
            _listScene[1044] = {
               "id":1044,
               "name":"家族广场"
            };
            _listScene[1051] = {
               "id":1051,
               "name":"家族大厅"
            };
            _listScene[1052] = {
               "id":1052,
               "name":"家族大厅"
            };
            _listScene[1053] = {
               "id":1053,
               "name":"家族大厅"
            };
            _listScene[1054] = {
               "id":1054,
               "name":"家族大厅"
            };
            _listScene[1018] = {
               "id":1018,
               "name":"卡布庄园"
            };
            _listScene[1023] = {
               "id":1023,
               "name":"后花园"
            };
            _listScene[1024] = {
               "id":1024,
               "name":"家园小屋"
            };
            _listScene[15000] = {
               "id":15000,
               "name":"藏龙渊"
            };
            _listScene[3000] = {
               "id":3000,
               "name":"万妖洞"
            };
            _listScene[4000] = {
               "id":4000,
               "name":"双台谷"
            };
            _listScene[200001] = {
               "id":200001,
               "name":"(战场)苍炼山坡"
            };
            _listScene[200002] = {
               "id":200001,
               "name":"(战场)苍炼沼泽"
            };
            _listScene[200003] = {
               "id":200001,
               "name":"(战场)苍蓝岭"
            };
            _listScene[200004] = {
               "id":200001,
               "name":"(战场)赤炼滩"
            };
            _listScene[10005] = {
               "id":10005,
               "name":"盘丝洞",
               "desc":"副本进行中,不能打开队伍列表"
            };
            _listScene[9005] = {
               "id":9005,
               "name":"七绝密林",
               "desc":"副本进行中,不能打开队伍列表"
            };
            _listScene[200005] = {
               "id":200005,
               "name":"镖师大考验",
               "desc":"副本进行中,不能打开队伍列表"
            };
            _listScene[200007] = {
               "id":200007,
               "name":"镖师大考验",
               "desc":"副本进行中,不能打开队伍列表"
            };
         }
         return _listScene;
      }
      
      public static function hitScene(sceneId:int) : Boolean
      {
         return listScene[sceneId] == null ? false : true;
      }
      
      public static function getScene(sceneId:int) : Object
      {
         return listScene[sceneId];
      }
   }
}

