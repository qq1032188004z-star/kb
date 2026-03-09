package com.publiccomponent.tips
{
   import flash.utils.Dictionary;
   
   public class TipInfoLib
   {
      
      public static var instance:TipInfoLib = new TipInfoLib();
      
      private var tips:Dictionary;
      
      public function TipInfoLib()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.tips = new Dictionary();
         this.tips["battleClip"] = {
            "tips":"阻击年兽",
            "place":2
         };
         this.tips["weekBtn"] = {
            "tips":"西游时报",
            "place":4
         };
         this.tips["handbookBtn"] = {
            "tips":"西游图鉴",
            "place":1
         };
         this.tips["kabuguideBtn"] = {
            "tips":"卡布指南",
            "place":1
         };
         this.tips["areamapbtn"] = {
            "tips":"区域地图",
            "place":2
         };
         this.tips["taskBtn"] = {
            "tips":"任务档案",
            "place":1
         };
         this.tips["dailyTaskClip"] = {
            "tips":"日常任务",
            "place":1
         };
         this.tips["badgeBtn"] = {
            "tips":"荣耀之路",
            "place":1
         };
         this.tips["systemBtn"] = {
            "tips":"隐藏其他玩家",
            "place":1
         };
         this.tips["autobattleBtn"] = {
            "tips":"自动战斗",
            "place":4
         };
         this.tips["kabuguideBtn"] = {
            "tips":"卡布指南",
            "place":1
         };
         this.tips["bigMapBtn"] = {
            "tips":"大地图",
            "place":2
         };
         this.tips["vipweekBtn"] = {
            "tips":"VIP报刊",
            "place":1
         };
         this.tips["weeklyActivityMc"] = {
            "tips":"超进化",
            "place":1
         };
         this.tips["dailyCompass"] = {
            "tips":"每日必做",
            "place":1
         };
         this.tips["clearClip"] = {
            "tips":"隐藏其他玩家",
            "place":1
         };
         this.tips["sendBtn"] = {
            "tips":"发言",
            "place":2
         };
         this.tips["systemBtn"] = {
            "tips":"系统设置",
            "place":2
         };
         this.tips["bbsBtn"] = {
            "tips":"论坛",
            "place":1
         };
         this.tips["settingBtn"] = {
            "tips":"系统设置",
            "place":1
         };
         this.tips["helpBtn"] = {
            "tips":"帮助",
            "place":1
         };
         this.tips["bugBtn"] = {
            "tips":"给叮叮博士写信",
            "place":1
         };
         this.tips["shopBtn"] = {
            "tips":"商城",
            "place":1
         };
         this.tips["friendClikBtn"] = {
            "tips":"我的好友",
            "place":2
         };
         this.tips["teamBtn"] = {
            "tips":"我的队伍",
            "place":2
         };
         this.tips["homebtn"] = {
            "tips":"进入家园",
            "place":2
         };
         this.tips["shenshoubtn"] = {
            "tips":"进入神兽园",
            "place":2
         };
         this.tips["familyFilesBtn"] = {
            "tips":"家族档案",
            "place":2
         };
         this.tips["temLeave"] = {
            "tips":"暂离",
            "place":2
         };
         this.tips["familyFilesBtn"] = {
            "tips":"家族档案",
            "place":2
         };
         this.tips["familyBtn1"] = {
            "tips":"加入家族",
            "place":2
         };
         this.tips["familyBtn2"] = {
            "tips":"家族基地",
            "place":2
         };
         this.tips["chatClip"] = {
            "tips":"家族群聊",
            "place":2
         };
         this.tips["betaActBtn"] = {
            "tips":"总动员",
            "place":1
         };
         this.tips["awardClip"] = {
            "tips":"礼盒",
            "place":1
         };
         this.tips["fincaBtn"] = {
            "tips":"进入庄园",
            "place":2
         };
         this.tips["presureBtn"] = {
            "tips":"寻宝罗盘",
            "place":1
         };
         this.tips["regressBtn"] = {
            "tips":"卡布回归",
            "place":1
         };
         this.tips["ghostBtn"] = {
            "tips":"幽冥战神",
            "place":1
         };
         this.tips["birthdayBtn"] = {
            "tips":"周年回馈",
            "place":1
         };
         this.tips["vip12Btn"] = {
            "tips":"王道十二宫",
            "place":1
         };
         this.tips["mentorBtn"] = {
            "tips":"我的师徒",
            "place":2
         };
         this.tips["buddyBtn"] = {
            "tips":"新手伙伴大集结",
            "place":1
         };
         this.tips["arenaBtn"] = {
            "tips":"封神之战",
            "place":1
         };
         this.tips["freshManAwardBtn"] = {
            "tips":"新人大礼包",
            "place":1
         };
      }
      
      public function getTipByName(name:String) : Object
      {
         var need:Object = null;
         if(this.tips != null && this.tips[name] != null)
         {
            need = this.tips[name];
         }
         return need;
      }
   }
}

