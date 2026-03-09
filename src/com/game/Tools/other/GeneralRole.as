package com.game.Tools.other
{
   import com.game.locators.GameData;
   import com.game.modules.role.BigRoleFace;
   import com.game.util.HorseCheck;
   import com.game.util.PersonInfoUtil;
   import com.game.util.TipsUtils;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ColorLabel;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   public class GeneralRole extends BigRoleFace
   {
      
      private static var _instance:GeneralRole;
      
      private var dressParams:Object = {};
      
      public var tryParams:Object = {};
      
      private var timer:Timer;
      
      private var step:int = 0;
      
      private var nameLabel:ColorLabel;
      
      private var tempUrl:String = null;
      
      public function GeneralRole(poi_x:int, poi_y:int)
      {
         super();
         this.x = poi_x;
         this.y = poi_y;
         this.dressParams = GameData.instance.playerData;
         this.initTryParams();
         this.changeRoleFace();
         this.timer = new Timer(80,int.MAX_VALUE);
         this.timer.addEventListener(TimerEvent.TIMER,this.onRender);
         this.timer.start();
         this.nameLabel = new ColorLabel(0,0);
         this.nameLabel.mouseEnabled = false;
         this.nameLabel.mouseChildren = false;
         addChild(this.nameLabel);
         this.nameLabel.x = -70;
         this.nameLabel.y = 0;
         this.updateNameBorder(GameData.instance.playerData.nameBorderId);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         addEventListener(MouseEvent.ROLL_OUT,this.onHideTips);
      }
      
      public static function get instance() : GeneralRole
      {
         if(_instance == null)
         {
            _instance = new GeneralRole(192,240);
         }
         return _instance;
      }
      
      private function onHideTips(evt:MouseEvent) : void
      {
         TipsUtils.hideTips();
      }
      
      private function onMouseMove(evt:MouseEvent) : void
      {
         var id:int = 0;
         var tips:String = null;
         var hoverUrl:String = getHoverPartUrl(evt.stageX,evt.stageY);
         if(this.tempUrl != hoverUrl)
         {
            this.tempUrl = hoverUrl;
            if(Boolean(this.tempUrl))
            {
               id = this.mygetId(this.tempUrl);
               tips = PersonInfoUtil.toDecorationTips(id);
               if(Boolean(tips) && tips != "未知")
               {
                  TipsUtils.showTips(tips,evt.stageX,evt.stageY);
               }
               else
               {
                  TipsUtils.hideTips();
               }
            }
            else
            {
               TipsUtils.hideTips();
            }
         }
         else if(Boolean(this.tempUrl))
         {
            TipsUtils.setTipsPosition(evt.stageX,evt.stageY);
         }
      }
      
      private function mygetId(v:String) : int
      {
         var startIndex:int = int(v.lastIndexOf("/"));
         var endIndex:int = int(v.indexOf(".",startIndex));
         return int(v.substring(startIndex + 1,endIndex));
      }
      
      public function dipos() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onRender);
            this.timer = null;
         }
         removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         removeEventListener(MouseEvent.ROLL_OUT,this.onHideTips);
         if(Boolean(parent) && parent.contains(this))
         {
            parent.removeChild(this);
         }
         if(Boolean(_instance))
         {
            _instance = null;
         }
         if(Boolean(this.nameLabel))
         {
            if(contains(this.nameLabel))
            {
               removeChild(this.nameLabel);
            }
            this.nameLabel.dispos();
            this.nameLabel = null;
         }
         TipsUtils.hideTips();
         this.dressParams = null;
         this.tryParams = null;
      }
      
      public function onRender(evt:Event) : void
      {
         render();
      }
      
      public function changeRoleFace() : void
      {
         if(Boolean(this.tryParams.horseID) && this.tryParams.horseID >= 610000)
         {
            HorseCheck.instance.addCmpCallBack(this.updateRole);
         }
         else
         {
            setRole(this.tryParams);
         }
      }
      
      private function updateRole() : void
      {
         var horsrCfg:Object = HorseCheck.instance.getHorseConfig(this.tryParams.horseID);
         if(Boolean(horsrCfg))
         {
            if((horsrCfg.useState & 6) == 0)
            {
               setRole(this.tryParams,false);
            }
            else
            {
               setRole(this.tryParams,true);
            }
         }
         else
         {
            setRole(this.tryParams,false);
         }
      }
      
      public function renderEquipMent(id:int) : void
      {
         var xml:XML = null;
         var left:int = 0;
         xml = XMLLocator.getInstance().tool.children().(@id == id)[0];
         if(xml == null)
         {
            return;
         }
         left = xml.type % 10;
         if(left == 1)
         {
            this.tryParams.hatId = id;
         }
         if(left == 2)
         {
            this.tryParams.clothId = id;
         }
         if(left == 4)
         {
            this.tryParams.footId = id;
         }
         if(left == 3)
         {
            this.tryParams.weaponId = id;
         }
         if(left == 8)
         {
            this.tryParams.wingId = id;
         }
         if(left == 6)
         {
            this.tryParams.glassId = id;
         }
         if(left == 9)
         {
            this.tryParams.leftWeapon = id;
         }
         if(xml.type == 10 || xml.type == 20)
         {
            this.tryParams.taozhuangId = id;
         }
         else
         {
            this.tryParams.taozhuangId = 0;
         }
         this.changeRoleFace();
      }
      
      private function resetTry() : void
      {
         this.tryParams.hatId = 0;
         this.tryParams.clothId = 0;
         this.tryParams.footId = 0;
         this.tryParams.weaponId = 0;
         this.tryParams.wingId = 0;
         this.tryParams.glassId = 0;
         this.tryParams.leftWeapon = 0;
         this.tryParams.faceId = 0;
         this.tryParams.taozhuangId = 0;
         this.tryParams.horseID = 0;
      }
      
      public function getOffEquipment() : void
      {
         this.resetTry();
         this.changeRoleFace();
         this.updateNameBorder(0);
      }
      
      public function recoverEquipment() : void
      {
         this.initTryParams();
         this.changeRoleFace();
         this.initTryParams();
         this.updateNameBorder(GameData.instance.playerData.nameBorderId);
      }
      
      private function initTryParams() : void
      {
         this.tryParams.roleType = this.dressParams.roleType;
         this.tryParams.faceId = this.dressParams.faceId;
         this.tryParams.hatId = this.dressParams.hatId;
         this.tryParams.clothId = this.dressParams.clothId;
         this.tryParams.footId = this.dressParams.footId;
         this.tryParams.weaponId = this.dressParams.weaponId;
         this.tryParams.wingId = this.dressParams.wingId;
         this.tryParams.glassId = this.dressParams.glassId;
         this.tryParams.horseID = this.dressParams.horseID;
         this.tryParams.leftWeapon = this.dressParams.leftWeapon;
         if(this.dressParams.hasOwnProperty("taozhuangId"))
         {
            this.tryParams.taozhuangId = this.dressParams.taozhuangId;
         }
         else
         {
            this.tryParams.taozhuangId = 0;
         }
      }
      
      public function tryTaoZhuang(list:Array) : void
      {
         var xml:XML = null;
         var id:int = 0;
         var left:int = 0;
         this.resetTry();
         for each(id in list)
         {
            xml = XMLLocator.getInstance().tool.children().(@id == id)[0];
            if(xml == null)
            {
               break;
            }
            left = xml.type % 10;
            if(left == 1 && xml.type < 30)
            {
               this.tryParams.hatId = id;
            }
            if(left == 2)
            {
               this.tryParams.clothId = id;
            }
            if(left == 4)
            {
               this.tryParams.footId = id;
            }
            if(left == 3 && xml.type != 33)
            {
               this.tryParams.weaponId = id;
            }
            if(left == 8)
            {
               this.tryParams.wingId = id;
            }
            if(left == 6 && xml.type != 36)
            {
               this.tryParams.glassId = id;
            }
            if(left == 9)
            {
               this.tryParams.leftWeapon = id;
            }
            if(xml.type == 0 || xml.type == 36)
            {
               this.tryParams.faceId = id;
            }
            if(xml.type == 33)
            {
               this.tryFaceOrBorder(id);
            }
         }
         this.changeRoleFace();
      }
      
      public function tryFaceOrBorder(idx:int) : void
      {
         var xml:XML = null;
         var sex:int = 0;
         var color:int = 0;
         xml = XMLLocator.getInstance().tool.children().(@id == idx)[0] as XML;
         if(xml != null)
         {
            sex = (GameData.instance.playerData.roleType & 1) > 0 ? 1 : 0;
            color = 1;
            if(xml.type == 33)
            {
               this.updateNameBorder(idx);
            }
            else if(idx == 100021)
            {
               color = int(Math.random() * 3) + 1;
               setBody(1000 + sex * 10 + color);
            }
            else if(idx == 100169)
            {
               color = 2;
               setBody(1000 + sex * 10 + color);
            }
            else if(idx == 100170)
            {
               color = 1;
               setBody(1000 + sex * 10 + color);
            }
            else if(idx == 100171)
            {
               color = 3;
               setBody(1000 + sex * 10 + color);
            }
            else
            {
               this.tryParams.faceId = idx;
               this.changeRoleFace();
            }
         }
      }
      
      public function updateNameBorder(id:int) : void
      {
         var filter:* = undefined;
         if(this.nameLabel != null)
         {
            this.nameLabel.setBorder(id);
            filter = getDefinitionByName("com.game.util.ChractorFilter");
            this.nameLabel.text = filter.filter(GameData.instance.playerData.userName,"***");
            if(GameData.instance.playerData.isVip)
            {
               this.nameLabel.txtFilter();
            }
            if(GameData.instance.playerData.familyName != null && GameData.instance.playerData.familyName.length != 0)
            {
               this.nameLabel.setFlag(GameData.instance.playerData.familyName);
            }
         }
      }
   }
}

