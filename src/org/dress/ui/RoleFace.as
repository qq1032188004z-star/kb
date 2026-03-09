package org.dress.ui
{
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import org.dress.enum.EffectEnum;
   
   public class RoleFace extends Sprite
   {
      
      public static const MOVESTATE:int = 0;
      
      public static const STOPSTATE:int = 1;
      
      public static const ACTIONSTATE:int = 2;
      
      public static const PETSTATE:int = 3;
      
      public var direction:int;
      
      public var pointer:int;
      
      private var body:BaseBody;
      
      private var bodyFlag:Boolean;
      
      private var bodyTexiao:BaseWingTeXiao;
      
      private var bodyTexiaoFlag:Boolean;
      
      private var hat:BaseHat;
      
      private var hatFlag:Boolean;
      
      private var hatTeXiao:BaseWingTeXiao;
      
      private var hatTeXiaoFlag:Boolean;
      
      private var cloth:BaseCloth;
      
      private var clothFlag:Boolean;
      
      private var clothTexiao:BaseWingTeXiao;
      
      private var clothTexiaoFlag:Boolean;
      
      private var shoe:BaseShoe;
      
      private var shoeFlag:Boolean;
      
      private var weapon:BaseWeapon;
      
      private var weaponFlag:Boolean;
      
      private var face:BaseFace;
      
      private var faceFlag:Boolean;
      
      private var pet:BasePet;
      
      private var petFlag:Boolean;
      
      private var wing:BaseWing;
      
      private var wingFlag:Boolean;
      
      private var glass:BaseGlass;
      
      private var glassFlag:Boolean;
      
      private var teXiao:BaseWingTeXiao;
      
      private var teXiaoFlag:Boolean;
      
      private var weaponTexiao:BaseWingTeXiao;
      
      private var weaponTexiaoFlag:Boolean;
      
      private var leftWeapon:BaseLeftWeapon;
      
      private var leftFlag:Boolean;
      
      private var leftWeaponTexiao:BaseWingTeXiao;
      
      private var leftTexiaoFlag:Boolean;
      
      private var timeDelayCount:int;
      
      private var bodyCallBack:Function;
      
      public var currentState:int;
      
      private var type:String;
      
      private var rowCount:int;
      
      private var weaponXML:XML;
      
      private var leftWeaponXML:XML;
      
      private var wingXML:XML;
      
      private var clothXML:XML;
      
      private var hatXML:XML;
      
      private var petId:int;
      
      private var specialPetList:Array = [90001,90002,610004,610005,610006];
      
      private var alphaObject:BaseAlphaObject;
      
      private var topPetList:Array = [610004];
      
      private var starTaoZhuang:Array = [551059,551060];
      
      private var tempPointer:int;
      
      private var countstop:int = 0;
      
      public function RoleFace(xCoord:Number = 0, yCoord:Number = 0, rowCount:int = 4)
      {
         super();
         this.x = xCoord;
         this.y = yCoord;
         this.rowCount = rowCount;
         this.currentState = 1;
         this.build();
         this.addMouseHandler();
      }
      
      public function addMouseHandler() : void
      {
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.onRollOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
      }
      
      public function removeMouseHandler() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_MOVE,this.onRollOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
      }
      
      private function onRollOver(evt:MouseEvent) : void
      {
         if(this.getIsMouseEnable(evt.stageX,evt.stageY))
         {
            this.buttonMode = true;
            this.filters = [new GlowFilter(16777215,1,10,10,2,1,false,false)];
         }
         else
         {
            this.buttonMode = false;
            this.filters = null;
         }
      }
      
      private function onRollOut(evt:MouseEvent) : void
      {
         this.filters = null;
         this.buttonMode = false;
      }
      
      private function build() : void
      {
         this.pet = new BasePet(this.rowCount);
         addChild(this.pet);
         this.body = new BaseBody(this.rowCount);
         addChild(this.body);
         this.wing = new BaseWing(this.rowCount);
         addChild(this.wing);
         this.teXiao = new BaseWingTeXiao(this.rowCount);
         addChild(this.teXiao);
         this.weapon = new BaseWeapon(this.rowCount);
         addChild(this.weapon);
         this.face = new BaseFace(this.rowCount);
         addChild(this.face);
         this.shoe = new BaseShoe(this.rowCount);
         addChild(this.shoe);
         this.cloth = new BaseCloth(this.rowCount);
         addChild(this.cloth);
         this.hat = new BaseHat(this.rowCount);
         addChild(this.hat);
         this.glass = new BaseGlass(this.rowCount);
         addChild(this.glass);
         this.leftWeapon = new BaseLeftWeapon(this.rowCount);
         addChild(this.leftWeapon);
      }
      
      public function getIsMouseEnable(xCoord:Number, yCoord:Number) : Boolean
      {
         if(this.isActive(this.pet,xCoord,yCoord))
         {
            return true;
         }
         if(this.isActive(this.body,xCoord,yCoord))
         {
            return true;
         }
         if(this.isActive(this.wing,xCoord,yCoord))
         {
            return true;
         }
         if(this.isActive(this.weapon,xCoord,yCoord))
         {
            return true;
         }
         if(this.isActive(this.leftWeapon,xCoord,yCoord))
         {
            return true;
         }
         if(this.isActive(this.face,xCoord,yCoord))
         {
            return true;
         }
         if(this.isActive(this.shoe,xCoord,yCoord))
         {
            return true;
         }
         if(this.isActive(this.cloth,xCoord,yCoord))
         {
            return true;
         }
         if(this.isActive(this.hat,xCoord,yCoord))
         {
            return true;
         }
         if(this.isActive(this.glass,xCoord,yCoord))
         {
            return true;
         }
         if(this.isActive(this.teXiao,xCoord,yCoord))
         {
            return true;
         }
         return false;
      }
      
      private function isActive(bmp:Bitmap, xCoord:Number, yCoord:Number) : Boolean
      {
         var active:Boolean = false;
         if(bmp == null || bmp.bitmapData == null)
         {
            return false;
         }
         var localpos:Point = bmp.globalToLocal(new Point(xCoord,yCoord));
         var color:uint = bmp.bitmapData.getPixel32(localpos.x,localpos.y);
         color >>= 24;
         if(color != 0)
         {
            active = true;
         }
         return active;
      }
      
      public function setState(roleState:int) : void
      {
         if(this.currentState == roleState)
         {
            return;
         }
         this.currentState = roleState;
         this.setEffectVisible(false);
         switch(roleState)
         {
            case MOVESTATE:
               this.pointer = 0;
               this.countstop = 0;
               break;
            case STOPSTATE:
               this.pointer = 4;
               this.setEffectVisible(true);
               break;
            case ACTIONSTATE:
               this.pointer = 6;
               break;
            case PETSTATE:
               this.pointer = 4;
               this.setEffectVisible(true);
         }
      }
      
      private function setEffectVisible(visible:Boolean) : void
      {
         if(Boolean(this.weaponTexiao))
         {
            this.weaponTexiao.visible = visible && this.weaponTexiaoFlag && this.weapon.visible;
         }
         if(Boolean(this.leftWeaponTexiao))
         {
            this.leftWeaponTexiao.visible = visible && this.leftTexiaoFlag && this.leftWeapon.visible;
         }
         if(Boolean(this.clothTexiao))
         {
            this.clothTexiao.visible = visible && this.clothTexiaoFlag && this.cloth.visible;
         }
      }
      
      public function setBody(id:int, type:String = "green", callBack:Function = null) : void
      {
         this.type = type;
         this.bodyCallBack = callBack;
         this.body.visible = id != 0;
         this.bodyFlag = false;
         if(!this.body.visible)
         {
            return;
         }
         if(Boolean(this.alphaObject))
         {
            this.alphaObject.dispos();
            this.alphaObject = null;
         }
         if(type == "green")
         {
            this.alphaObject = new BaseAlphaObject();
            addChild(this.alphaObject);
            if(EffectEnum.BODY_ADD_TEXIAO.indexOf(id) != -1)
            {
               if(!this.bodyTexiao)
               {
                  this.initBodyTexiao();
               }
               this.bodyTexiao.visible = true;
               this.bodyTexiao.load("assets/role/texiao/" + id + ".green","role",this.bodyTexiaoLoaded);
            }
            else if(Boolean(this.bodyTexiao))
            {
               this.bodyTexiao.url = "";
               this.bodyTexiao.visible = false;
               this.bodyTexiaoFlag = false;
            }
         }
         this.body.load("assets/role/" + id + "." + type,"role",function(params:Object):void
         {
            onBodyLoaded(params,callBack);
         });
      }
      
      private function initBodyTexiao() : void
      {
         if(!this.bodyTexiao)
         {
            this.bodyTexiao = new BaseWingTeXiao();
            addChildAt(this.bodyTexiao,getChildIndex(this.body) + 1);
         }
      }
      
      private function onBodyLoaded(params:Object, callBack:Function = null) : void
      {
         if(!this.body)
         {
            return;
         }
         this.body.visible = true;
         this.bodyFlag = true;
         if(callBack != null)
         {
            callBack();
         }
         var frame:int = this.rowCount == 1 ? 0 : 4;
         this.body.render(this.direction,frame);
         if(Boolean(this.alphaObject))
         {
            this.alphaObject.dispos();
            this.alphaObject = null;
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function bodyTexiaoLoaded(params:Object) : void
      {
         if(Boolean(this.bodyTexiao))
         {
            this.bodyTexiao.render(this.direction,0);
            this.bodyTexiaoFlag = true;
            this.bodyTexiao.visible = true;
         }
      }
      
      public function setWing(id:int, type:String = "green") : void
      {
         var hasEffect:Boolean = false;
         this.wing.visible = id != 0;
         if(!this.wing.visible)
         {
            this.clearWing();
            return;
         }
         if(this.wingXML == null || this.wingXML.@id != id)
         {
            this.wingXML = XMLLocator.getInstance().getTool(id);
            if(this.wingXML == null)
            {
               O.o("装扮错误","未找到翅膀配置: " + id);
               this.clearWing();
               return;
            }
            this.wing.load("assets/wing/" + this.wingXML.@id + "." + type,"wing",this.wingLoaded);
            hasEffect = this.wingXML.effect == 1;
            this.teXiao.visible = hasEffect;
            if(hasEffect)
            {
               this.teXiao.load("assets/wingtexiao/" + id + "." + type,"wingtexiao",this.onTeXiaoLoaded);
            }
         }
         else
         {
            this.teXiao.visible = this.wingXML.effect == 1;
         }
      }
      
      private function wingLoaded(params:Object) : void
      {
         if(!this.wing)
         {
            return;
         }
         this.wing.visible = true;
         var frame:int = this.rowCount == 1 ? 0 : 4;
         this.wing.render(this.direction,frame);
         this.wingFlag = true;
      }
      
      private function onTeXiaoLoaded(params:Object) : void
      {
         if(!this.teXiao)
         {
            return;
         }
         this.teXiao.render(this.direction,0);
         this.teXiaoFlag = true;
         this.teXiao.visible = true;
      }
      
      private function clearWing() : void
      {
         this.wingXML = null;
         if(Boolean(this.wing))
         {
            this.wing.url = "";
         }
         if(Boolean(this.teXiao))
         {
            this.teXiao.url = "";
            this.teXiao.visible = false;
         }
         this.wingFlag = false;
         this.teXiaoFlag = false;
      }
      
      public function setGlass(id:int, type:String = "green") : void
      {
         var basePath:String = null;
         if(!this.glass)
         {
            return;
         }
         if(id == 0)
         {
            this.glass.visible = false;
            this.glass.url = "";
            this.glassFlag = false;
            return;
         }
         basePath = "assets/glasses/";
         var filePath:String = basePath + id + "." + type;
         this.glass.visible = true;
         this.glass.load(filePath,"glass",this.glassLoaded);
      }
      
      private function glassLoaded(params:Object) : void
      {
         if(!this.glass)
         {
            return;
         }
         this.glass.visible = true;
         var frameIndex:int = this.rowCount == 1 ? 0 : 4;
         this.glass.render(this.direction,frameIndex);
         this.glassFlag = true;
      }
      
      public function setShoe(id:int, type:String = "green") : void
      {
         this.type = type;
         if(id == 0)
         {
            this.shoe.visible = false;
            this.shoe.url = "";
            this.shoeFlag = false;
            return;
         }
         var path:String = "assets/foot/" + id + "." + type;
         this.shoe.visible = true;
         this.shoe.load(path,"foot",this.shoeLoaded);
      }
      
      private function shoeLoaded(params:Object) : void
      {
         if(!this.shoe)
         {
            return;
         }
         this.shoe.visible = true;
         var frameIndex:int = this.rowCount == 1 ? 0 : 4;
         this.shoe.render(this.direction,frameIndex);
         this.shoeFlag = true;
         this.check();
      }
      
      private function check() : void
      {
         if(this.bodyFlag && Boolean(this.alphaObject))
         {
            this.alphaObject.dispos();
            this.alphaObject = null;
         }
      }
      
      public function setCloth(id:int, type:String = "green") : void
      {
         this.type = type;
         if(id == 0)
         {
            this.clearCloth();
            return;
         }
         this.cloth.visible = true;
         if(Boolean(this.clothXML) && this.clothXML.@id == id)
         {
            this.updateClothEffectVisibility();
            return;
         }
         this.clothXML = XMLLocator.getInstance().getTool(id);
         if(this.clothXML == null)
         {
            O.o("装扮错误","cloth未有" + id + "配置！！！");
            this.clearCloth();
            return;
         }
         this.cloth.load("assets/cloth/" + id + "." + type,"cloth",this.clothLoaded);
         if(this.clothXML.effect == 1)
         {
            this.ensureClothTexiao();
            this.clothTexiao.visible = true;
            this.clothTexiao.load("assets/cloth/texiao/" + id + "." + type,"texiao",this.clothTexiaoLoaded);
         }
         else
         {
            this.disableClothTexiao();
         }
      }
      
      private function clearCloth() : void
      {
         this.cloth.visible = false;
         this.cloth.url = "";
         this.clothXML = null;
         this.clothFlag = false;
         this.disableClothTexiao();
      }
      
      private function ensureClothTexiao() : void
      {
         if(this.clothTexiao == null)
         {
            this.initClothTeXiao();
         }
      }
      
      private function disableClothTexiao() : void
      {
         if(Boolean(this.clothTexiao))
         {
            this.clothTexiao.visible = false;
            this.clothTexiao.url = "";
         }
         this.leftTexiaoFlag = false;
      }
      
      private function updateClothEffectVisibility() : void
      {
         if(Boolean(this.clothTexiao))
         {
            this.clothTexiao.visible = this.clothXML.effect == 1;
         }
      }
      
      private function clothLoaded(params:Object) : void
      {
         if(!this.cloth)
         {
            return;
         }
         this.cloth.visible = true;
         this.cloth.render(this.direction,this.rowCount == 1 ? 0 : 4);
         this.clothFlag = true;
         this.check();
      }
      
      private function clothTexiaoLoaded(params:Object) : void
      {
         if(!this.clothTexiao)
         {
            return;
         }
         this.clothTexiao.visible = true;
         this.clothTexiao.render(this.direction,this.rowCount == 1 ? 0 : 4);
         this.clothTexiaoFlag = true;
      }
      
      public function setHat(id:int, type:String = "green") : void
      {
         this.type = type;
         this.hat.visible = id != 0;
         if(!this.hat.visible)
         {
            this.clearHat();
            return;
         }
         if(this.hatXML == null || this.hatXML.@id != id)
         {
            this.hatXML = XMLLocator.getInstance().getTool(id);
            if(this.hatXML == null)
            {
               O.o("装扮错误","head未有" + id + "配置！！！");
               this.hat.visible = false;
               return;
            }
            this.hat.load("assets/head/" + id + "." + type,"head",this.hatLoaded);
            this.setupHatEffect(id,type,this.hatXML.effect == 1);
         }
         else if(Boolean(this.hatTeXiao))
         {
            this.hatTeXiao.visible = this.hatXML.effect == 1;
         }
      }
      
      private function setupHatEffect(id:int, type:String, hasEffect:Boolean) : void
      {
         if(hasEffect)
         {
            if(this.hatTeXiao == null)
            {
               this.initHatTexiao();
            }
            this.hatTeXiao.visible = true;
            this.hatTeXiao.load("assets/head/texiao/" + id + "." + type,"hattexiao",this.onHatTeXiaoLoaded);
         }
         else
         {
            if(this.hatTeXiao != null)
            {
               this.hatTeXiao.url = "";
               this.hatTeXiao.visible = false;
            }
            this.hatTeXiaoFlag = false;
         }
      }
      
      private function clearHat() : void
      {
         this.hatXML = null;
         this.hat.url = "";
         this.hat.visible = false;
         if(this.hatTeXiao != null)
         {
            this.hatTeXiao.url = "";
            this.hatTeXiao.visible = false;
         }
         this.hatTeXiaoFlag = false;
         this.hatFlag = false;
      }
      
      private function hatLoaded(params:Object) : void
      {
         if(this.hat != null)
         {
            this.hat.visible = true;
            this.hat.render(this.direction,this.rowCount == 1 ? 0 : 4);
            this.hatFlag = true;
         }
         this.check();
      }
      
      private function onHatTeXiaoLoaded(params:Object) : void
      {
         if(this.hatTeXiao != null)
         {
            this.hatTeXiao.render(this.direction,0);
            this.hatTeXiaoFlag = true;
            this.hatTeXiao.visible = true;
         }
      }
      
      public function setWeapon(id:int, type:String = "green") : void
      {
         this.type = type;
         this.weapon.visible = id != 0;
         if(!this.weapon.visible)
         {
            this.clearWeapon();
            return;
         }
         if(this.weaponXML == null || this.weaponXML.@id != id)
         {
            this.weaponXML = XMLLocator.getInstance().getTool(id);
            if(this.weaponXML == null)
            {
               O.o("装扮错误","weapon未有" + id + "配置！！！");
               this.weapon.visible = false;
               return;
            }
            this.weapon.load("assets/weapon/" + id + "." + type,"weapon",this.weaponLoaded);
            this.setupWeaponEffect(id,type,this.weaponXML.effect == 1);
         }
         else if(Boolean(this.weaponTexiao))
         {
            this.weaponTexiao.visible = this.weaponXML.effect == 1;
         }
      }
      
      private function setupWeaponEffect(id:int, type:String, hasEffect:Boolean) : void
      {
         if(hasEffect)
         {
            if(this.weaponTexiao == null)
            {
               this.initWeaponTexiao();
            }
            this.weaponTexiao.visible = true;
            this.weaponTexiao.load("assets/weapon/texiao/" + id + "." + type,"weapontexiao",this.onWeaponTeXiaoLoaded);
         }
         else
         {
            if(this.weaponTexiao != null)
            {
               this.weaponTexiao.url = "";
               this.weaponTexiao.visible = false;
            }
            this.weaponTexiaoFlag = false;
         }
      }
      
      private function clearWeapon() : void
      {
         this.weaponXML = null;
         this.weapon.url = "";
         this.weapon.visible = false;
         if(this.weaponTexiao != null)
         {
            this.weaponTexiao.url = "";
            this.weaponTexiao.visible = false;
         }
         this.weaponTexiaoFlag = false;
         this.weaponFlag = false;
      }
      
      private function weaponLoaded(params:Object) : void
      {
         if(this.weapon != null)
         {
            this.weapon.visible = true;
            this.weapon.render(this.direction,this.rowCount == 1 ? 0 : 4);
            this.weaponFlag = true;
         }
      }
      
      private function onWeaponTeXiaoLoaded(params:Object) : void
      {
         if(this.weaponTexiao != null)
         {
            this.weaponTexiao.render(this.direction,0);
            this.weaponTexiaoFlag = true;
            this.weaponTexiao.visible = true;
         }
      }
      
      private function initHatTexiao() : void
      {
         this.hatTeXiao = new BaseWingTeXiao();
         addChildAt(this.hatTeXiao,getChildIndex(this.hat) + 1);
      }
      
      private function initWeaponTexiao() : void
      {
         this.weaponTexiao = new BaseWingTeXiao();
         addChildAt(this.weaponTexiao,getChildIndex(this.weapon) + 1);
      }
      
      public function setLeftWeapon(id:int, type:String = "green") : void
      {
         this.type = type;
         this.leftWeapon.visible = id != 0;
         if(!this.leftWeapon.visible)
         {
            this.clearLeftWeapon();
            return;
         }
         if(this.leftWeaponXML == null || this.leftWeaponXML.@id != id)
         {
            this.leftWeaponXML = XMLLocator.getInstance().getTool(id);
            if(this.leftWeaponXML == null)
            {
               O.o("装扮错误","weapon未有" + id + "配置！！！");
               this.leftWeapon.visible = false;
               return;
            }
            this.leftWeapon.load("assets/weapon/" + id + "." + type,"weapon",this.leftWeaponLoaded);
            this.setupLeftWeaponEffect(id,type,this.leftWeaponXML.effect == 1);
         }
         else if(Boolean(this.leftWeaponTexiao))
         {
            this.leftWeaponTexiao.visible = this.leftWeaponXML.effect == 1;
         }
      }
      
      private function setupLeftWeaponEffect(id:int, type:String, hasEffect:Boolean) : void
      {
         if(hasEffect)
         {
            if(this.leftWeaponTexiao == null)
            {
               this.initLeftTexiao();
            }
            this.leftWeaponTexiao.visible = true;
            this.leftWeaponTexiao.load("assets/weapon/texiao/" + id + "." + type,"texiao",this.leftTexiaoLoaded);
         }
         else
         {
            if(Boolean(this.leftWeaponTexiao))
            {
               this.leftWeaponTexiao.visible = false;
               this.leftWeaponTexiao.url = "";
            }
            this.leftTexiaoFlag = false;
         }
      }
      
      private function clearLeftWeapon() : void
      {
         this.leftWeaponXML = null;
         this.leftWeapon.url = "";
         this.leftWeapon.visible = false;
         if(Boolean(this.leftWeaponTexiao))
         {
            this.leftWeaponTexiao.url = "";
            this.leftWeaponTexiao.visible = false;
         }
         this.leftFlag = false;
         this.leftTexiaoFlag = false;
      }
      
      private function leftWeaponLoaded(params:Object) : void
      {
         if(this.leftWeapon != null)
         {
            this.leftWeapon.visible = true;
            this.leftWeapon.render(this.direction,this.rowCount == 1 ? 0 : 4);
            this.leftFlag = true;
         }
      }
      
      private function leftTexiaoLoaded(params:Object) : void
      {
         if(this.leftWeaponTexiao != null)
         {
            this.leftWeaponTexiao.visible = true;
            this.leftWeaponTexiao.render(this.direction,this.rowCount == 1 ? 0 : 4);
            this.leftTexiaoFlag = true;
         }
      }
      
      private function initClothTeXiao() : void
      {
         if(this.clothTexiao == null)
         {
            this.clothTexiao = new BaseWingTeXiao();
            addChildAt(this.clothTexiao,getChildIndex(this.cloth) + 1);
         }
      }
      
      private function initLeftTexiao() : void
      {
         if(this.leftWeaponTexiao == null)
         {
            this.leftWeaponTexiao = new BaseWingTeXiao();
            addChildAt(this.leftWeaponTexiao,getChildIndex(this.leftWeapon) + 1);
         }
      }
      
      public function setFace(id:int, type:String = "green") : void
      {
         this.type = type;
         this.face.visible = id != 0;
         if(!this.face.visible)
         {
            this.clearFace();
            return;
         }
         this.face.load("assets/face/" + id + "." + type,"face",this.faceLoaded);
      }
      
      private function clearFace() : void
      {
         this.face.url = "";
         this.face.visible = false;
         this.faceFlag = false;
      }
      
      private function faceLoaded(params:Object) : void
      {
         if(this.face != null)
         {
            this.face.visible = true;
            this.face.render(this.direction,this.rowCount == 1 ? 0 : 4);
            this.faceFlag = true;
         }
      }
      
      public function setPet(id:int, type:String = "green") : void
      {
         this.type = type;
         this.petId = id;
         this.pet.visible = id != 0 && type == "green";
         if(this.pet.visible)
         {
            this.pet.load("assets/pet/" + id + "." + type,"pet",this.petLoaded);
            this.pet.setPetId(id);
            if(this.topPetList.indexOf(id) != -1)
            {
               this.addChildAt(this.pet,numChildren - 5);
            }
         }
         else
         {
            this.petFlag = false;
         }
      }
      
      private function petLoaded(params:Object) : void
      {
         if(this.pet != null)
         {
            this.pet.visible = true;
            if(this.rowCount == 1)
            {
               this.pet.render(this.direction,0);
            }
            else
            {
               this.pet.render(this.direction,this.pointer);
            }
            this.petFlag = true;
         }
      }
      
      public function move(direction:int, isMove:Boolean = true) : void
      {
         this.direction = direction;
         this.timeDelayCount = 0;
         this.render(direction,this.pointer);
         if(isMove)
         {
            if(this.pointer < 3)
            {
               ++this.pointer;
            }
            else
            {
               this.pointer = 0;
            }
         }
         else
         {
            this.pointer = 4;
         }
      }
      
      public function standRender(direction:int) : void
      {
         this.direction = direction;
         this.pointer = 4;
         this.timeDelayCount += 1;
         if(this.tempPointer < 3)
         {
            ++this.tempPointer;
         }
         else
         {
            this.tempPointer = 0;
         }
         if(this.pet != null && this.petFlag)
         {
            this.pet.render(direction,this.tempPointer);
         }
         this.render(direction,this.pointer);
         if(this.timeDelayCount >= 20)
         {
            this.timeDelayCount = 0;
            this.pointer = 5;
            this.render(direction,this.pointer);
         }
      }
      
      public function playAction(direction:int) : void
      {
         this.timeDelayCount = 0;
         this.direction = direction;
         this.render(direction,this.pointer);
         if(this.pointer < 8)
         {
            ++this.pointer;
         }
         else if(this.petFlag)
         {
            this.setState(PETSTATE);
         }
         else
         {
            this.setState(STOPSTATE);
         }
      }
      
      public function hasPetMove(direction:int) : void
      {
         this.direction = direction;
         this.timeDelayCount = 0;
         if(this.body != null && this.bodyFlag)
         {
            this.body.render(direction,4);
         }
         if(this.hat != null && this.hatFlag)
         {
            this.hat.render(direction,4);
         }
         if(this.shoe != null && this.shoeFlag)
         {
            this.shoe.render(direction,4);
         }
         if(this.cloth != null && this.clothFlag)
         {
            this.cloth.render(direction,4);
         }
         if(this.weapon != null && this.weaponFlag)
         {
            this.weapon.render(direction,4);
         }
         if(this.leftWeapon != null && this.leftFlag)
         {
            this.leftWeapon.render(direction,4);
         }
         if(this.face != null && this.faceFlag)
         {
            this.face.render(direction,4);
         }
         if(this.pet != null && this.petFlag)
         {
            this.pet.render(direction,this.pointer);
         }
         if(this.wing != null && this.wingFlag)
         {
            this.wing.render(direction,this.pointer);
         }
         if(this.glass != null && this.glassFlag)
         {
            this.glass.render(direction,4);
         }
         if(this.teXiao != null && this.teXiaoFlag)
         {
            this.teXiao.render(direction,4);
         }
         if(this.weaponTexiao != null && this.weaponTexiaoFlag)
         {
            this.weaponTexiao.render(direction,4);
         }
         if(this.hatTeXiao != null && this.hatTeXiaoFlag)
         {
            this.hatTeXiao.render(direction,4);
         }
         if(this.leftWeaponTexiao != null && this.leftTexiaoFlag)
         {
            this.leftWeaponTexiao.render(direction,4);
         }
         if(this.clothTexiao != null && this.clothTexiaoFlag)
         {
            this.clothTexiao.render(direction,4);
         }
         if(this.pointer < 3)
         {
            ++this.pointer;
         }
         else
         {
            this.pointer = 0;
         }
         this.change();
      }
      
      public function changeBody(id:int, value:Boolean = false, callBack:Function = null) : void
      {
         if(this.body != null)
         {
            this.setBody(id,"green",callBack);
         }
         if(this.shoe != null)
         {
            this.shoe.visible = value;
         }
         if(this.cloth != null)
         {
            this.cloth.visible = value;
         }
         if(this.hat != null)
         {
            this.hat.visible = value;
         }
         if(this.weapon != null)
         {
            this.weapon.visible = value;
         }
         if(this.leftWeapon != null)
         {
            this.leftWeapon.visible = value;
         }
         if(this.pet != null)
         {
            if(this.specialPetList.indexOf(this.petId) != -1)
            {
               this.pet.visible = true;
            }
            else
            {
               this.pet.visible = value;
            }
         }
         if(this.wing != null)
         {
            this.wing.visible = value;
         }
         if(this.face != null)
         {
            this.face.visible = value;
         }
         if(this.glass != null)
         {
            this.glass.visible = value;
         }
         if(this.teXiao != null)
         {
            this.teXiao.visible = value;
         }
         if(this.weaponTexiao != null)
         {
            this.weaponTexiao.visible = value;
         }
         if(this.leftWeaponTexiao != null)
         {
            this.leftWeaponTexiao.visible = value;
         }
         if(this.clothTexiao != null)
         {
            this.clothTexiao.visible = value;
         }
         if(this.hatTeXiao != null)
         {
            this.hatTeXiao.visible = value;
         }
      }
      
      public function clear() : void
      {
         if(this.body != null)
         {
            this.body.url = "";
            this.body.visible = false;
         }
         if(this.shoe != null)
         {
            this.shoe.url = "";
            this.shoe.visible = false;
         }
         if(this.cloth != null)
         {
            this.cloth.url = "";
            this.cloth.visible = false;
         }
         if(this.hat != null)
         {
            this.hat.url = "";
            this.hat.visible = false;
         }
         if(this.weapon != null)
         {
            this.weapon.url = "";
            this.weapon.visible = false;
         }
         if(this.leftWeapon != null)
         {
            this.leftWeapon.url = "";
            this.leftWeapon.visible = false;
         }
         if(this.pet != null)
         {
            this.pet.visible = false;
         }
         if(this.wing != null)
         {
            this.wing.url = "";
            this.wing.visible = false;
         }
         if(this.face != null)
         {
            this.face.url = "";
            this.face.visible = false;
         }
         if(this.glass != null)
         {
            this.glass.url = "";
            this.glass.visible = false;
         }
         if(this.teXiao != null)
         {
            this.teXiao.url = "";
            this.teXiao.visible = false;
         }
         if(this.weaponTexiao != null)
         {
            this.weaponTexiao.url = "";
            this.weaponTexiao.visible = false;
         }
         if(this.leftWeaponTexiao != null)
         {
            this.leftWeaponTexiao.url = "";
            this.leftWeaponTexiao.visible = false;
         }
         if(this.clothTexiao != null)
         {
            this.clothTexiao.url = "";
            this.clothTexiao.visible = false;
         }
         if(this.hatTeXiao != null)
         {
            this.hatTeXiao.url = "";
            this.hatTeXiao.visible = false;
         }
      }
      
      public function show(flag:int = 1) : void
      {
         if(this.body != null)
         {
            this.body.visible = true;
         }
         var vFlag:Boolean = flag != 2;
         if(this.shoe != null)
         {
            this.shoe.visible = vFlag;
         }
         if(this.cloth != null)
         {
            this.cloth.visible = vFlag;
         }
         if(this.hat != null)
         {
            this.hat.visible = vFlag;
         }
         if(this.weapon != null)
         {
            this.weapon.visible = vFlag;
         }
         if(this.leftWeapon != null)
         {
            this.leftWeapon.visible = vFlag;
         }
         if(this.pet != null)
         {
            this.pet.visible = vFlag;
         }
         if(this.wing != null)
         {
            this.wing.visible = vFlag;
         }
         if(this.face != null)
         {
            this.face.visible = vFlag;
         }
         if(this.glass != null)
         {
            this.glass.visible = vFlag;
         }
         if(this.teXiao != null)
         {
            this.teXiao.visible = vFlag;
         }
         if(this.weaponTexiao != null)
         {
            this.weaponTexiao.visible = vFlag;
         }
         if(this.leftWeaponTexiao != null)
         {
            this.leftWeaponTexiao.visible = vFlag;
         }
         if(this.clothTexiao != null)
         {
            this.clothTexiao.visible = flag != 2;
         }
         if(this.hatTeXiao != null)
         {
            this.hatTeXiao.visible = vFlag;
         }
      }
      
      public function resetDirection(direction:int) : void
      {
         this.direction = direction;
      }
      
      public function dispos() : void
      {
         if(Boolean(this.alphaObject))
         {
            this.alphaObject.dispos();
         }
         this.alphaObject = null;
         this.filters = null;
         this.removeEventListener(MouseEvent.MOUSE_MOVE,this.onRollOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
         if(this.body != null)
         {
            this.body.dispos();
            this.body = null;
         }
         if(this.shoe != null)
         {
            this.shoe.dispos();
            this.shoe = null;
         }
         if(this.cloth != null)
         {
            this.cloth.dispos();
            this.cloth = null;
         }
         if(this.hat != null)
         {
            this.hat.dispos();
            this.hat = null;
         }
         if(this.weapon != null)
         {
            this.weapon.dispos();
            this.weapon = null;
         }
         if(this.pet != null)
         {
            this.pet.dispos();
            this.pet = null;
         }
         if(this.wing != null)
         {
            this.wing.dispos();
            this.wing = null;
         }
         if(this.face != null)
         {
            this.face.dispos();
            this.face = null;
         }
         if(this.glass != null)
         {
            this.glass.dispos();
            this.glass = null;
         }
         if(this.leftWeapon != null)
         {
            this.leftWeapon.dispos();
            this.leftWeapon = null;
         }
         if(this.teXiao != null)
         {
            this.teXiao.dispos();
            this.teXiao = null;
         }
         if(this.weaponTexiao != null)
         {
            this.weaponTexiao.dispos();
            this.weaponTexiao = null;
         }
         if(this.hatTeXiao != null)
         {
            this.hatTeXiao.dispos();
            this.hatTeXiao = null;
         }
         if(this.leftWeaponTexiao != null)
         {
            this.leftWeaponTexiao.dispos();
            this.leftWeaponTexiao = null;
         }
         if(this.clothTexiao != null)
         {
            this.clothTexiao.dispos();
            this.clothTexiao = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function render(d:int = 0, p:int = 0, forceUpdate:Boolean = false) : void
      {
         if(forceUpdate)
         {
            this.onForceUpdate();
         }
         if(this.body != null && this.bodyFlag)
         {
            this.body.render(d,p);
         }
         if(this.hat != null && this.hatFlag)
         {
            this.hat.render(d,p);
         }
         if(this.shoe != null && this.shoeFlag)
         {
            this.shoe.render(d,p);
         }
         if(this.cloth != null && this.clothFlag)
         {
            this.cloth.render(d,p);
         }
         if(this.weapon != null && this.weaponFlag)
         {
            this.weapon.render(d,p);
         }
         if(this.leftWeapon != null && this.leftFlag)
         {
            this.leftWeapon.render(d,p);
         }
         if(this.face != null && this.faceFlag)
         {
            this.face.render(d,p);
         }
         if(this.pet != null && this.petFlag)
         {
            this.pet.render(d,p);
         }
         if(this.wing != null && this.wingFlag)
         {
            this.wing.render(d,p);
         }
         if(this.glass != null && this.glassFlag)
         {
            this.glass.render(d,p);
         }
         if(Boolean(this.teXiao) && this.teXiaoFlag)
         {
            this.teXiao.render(d,p);
         }
         if(Boolean(this.weaponTexiao) && this.weaponTexiaoFlag)
         {
            this.weaponTexiao.render(d,p);
         }
         if(Boolean(this.leftWeaponTexiao) && this.leftTexiaoFlag)
         {
            this.leftWeaponTexiao.render(d,p);
         }
         if(Boolean(this.clothTexiao) && this.clothTexiaoFlag)
         {
            this.clothTexiao.render(d,p);
         }
         if(Boolean(this.hatTeXiao) && this.hatTeXiaoFlag)
         {
            this.hatTeXiao.render(d,p);
         }
         if(Boolean(this.bodyTexiao) && this.bodyTexiaoFlag)
         {
            this.bodyTexiao.render(d,p);
         }
         this.change();
      }
      
      private function onForceUpdate() : void
      {
         if(this.body != null && this.bodyFlag)
         {
            this.body.onForceUpdates();
         }
         if(this.hat != null && this.hatFlag)
         {
            this.hat.onForceUpdates();
         }
         if(this.shoe != null && this.shoeFlag)
         {
            this.shoe.onForceUpdates();
         }
         if(this.cloth != null && this.clothFlag)
         {
            this.cloth.onForceUpdates();
         }
         if(this.weapon != null && this.weaponFlag)
         {
            this.weapon.onForceUpdates();
         }
         if(this.leftWeapon != null && this.leftFlag)
         {
            this.leftWeapon.onForceUpdates();
         }
         if(this.face != null && this.faceFlag)
         {
            this.face.onForceUpdates();
         }
         if(this.pet != null && this.petFlag)
         {
            this.pet.onForceUpdates();
         }
         if(this.wing != null && this.wingFlag)
         {
            this.wing.onForceUpdates();
         }
         if(this.glass != null && this.glassFlag)
         {
            this.glass.onForceUpdates();
         }
         if(Boolean(this.teXiao) && this.teXiaoFlag)
         {
            this.teXiao.onForceUpdates();
         }
         if(Boolean(this.weaponTexiao) && this.weaponTexiaoFlag)
         {
            this.weaponTexiao.onForceUpdates();
         }
         if(Boolean(this.leftWeaponTexiao) && this.leftTexiaoFlag)
         {
            this.leftWeaponTexiao.onForceUpdates();
         }
         if(Boolean(this.clothTexiao) && this.clothTexiaoFlag)
         {
            this.clothTexiao.onForceUpdates();
         }
         if(Boolean(this.hatTeXiao) && this.hatTeXiaoFlag)
         {
            this.hatTeXiao.onForceUpdates();
         }
         if(Boolean(this.bodyTexiao) && this.bodyTexiaoFlag)
         {
            this.bodyTexiao.onForceUpdates();
         }
      }
      
      public function change() : void
      {
         var weaponIndex:int = 0;
         var wingIndex:int = 0;
         var dirFlag:Boolean = this.direction == 0 || this.direction == 2;
         if(dirFlag)
         {
            if(this.getChildIndex(this.wing) != 1)
            {
               this.setChildIndex(this.wing,1);
            }
            if(this.weaponId == 500143)
            {
               if(this.getChildIndex(this.weapon) != this.numChildren - 1)
               {
                  this.setChildIndex(this.weapon,this.numChildren - 1);
               }
            }
            else if(this.weaponId == 550699)
            {
               if(this.getChildIndex(this.weapon) != 0)
               {
                  this.setChildIndex(this.weapon,0);
               }
            }
            else if(this.getChildIndex(this.weapon) != 4)
            {
               this.setChildIndex(this.weapon,4);
            }
         }
         else
         {
            weaponIndex = this.getChildIndex(this.weapon);
            if(this.weaponId == 500143)
            {
               if(this.getChildIndex(this.weapon) != 0)
               {
                  this.setChildIndex(this.weapon,0);
               }
            }
            else if(this.weaponTexiaoFlag)
            {
               if(weaponIndex != this.numChildren - 2)
               {
                  weaponIndex = numChildren - 2;
                  this.setChildIndex(this.weapon,weaponIndex);
               }
            }
            else if(weaponIndex != this.numChildren - 1)
            {
               weaponIndex = numChildren - 1;
               this.setChildIndex(this.weapon,weaponIndex);
            }
            wingIndex = weaponIndex - 2;
            if(this.wingId == 551129 || this.weaponId == 551492 || this.weaponId == 552298)
            {
               addChild(this.wing);
            }
            else if(this.getChildIndex(this.wing) != wingIndex && wingIndex >= 0)
            {
               this.setChildIndex(this.wing,wingIndex);
            }
         }
         if(Boolean(this.weaponTexiao) && Boolean(this.weaponXML))
         {
            if(this.weaponXML.effect_swap == 1)
            {
               addChildAt(this.weaponTexiao,getChildIndex(this.weapon) + (dirFlag ? -1 : 1));
            }
            else
            {
               addChildAt(this.weaponTexiao,getChildIndex(this.weapon) + (dirFlag ? 1 : -1));
            }
         }
         if(Boolean(this.leftWeaponTexiao) && Boolean(this.leftWeaponXML))
         {
            if(this.leftWeaponXML.effect_swap == 1)
            {
               addChildAt(this.leftWeaponTexiao,getChildIndex(this.leftWeapon) + (dirFlag ? -1 : 1));
            }
            else
            {
               addChildAt(this.leftWeaponTexiao,getChildIndex(this.leftWeapon) + (dirFlag ? 1 : -1));
            }
         }
         if(Boolean(this.teXiao) && Boolean(this.wingXML))
         {
            switch(int(this.wingXML.effect_swap))
            {
               case 1:
                  addChildAt(this.teXiao,getChildIndex(this.wing) + (dirFlag ? -1 : 1));
                  break;
               case 2:
                  addChildAt(this.teXiao,getChildIndex(this.wing) + 1);
                  break;
               case 3:
                  addChildAt(this.teXiao,getChildIndex(this.wing) - 1);
                  break;
               default:
                  addChildAt(this.teXiao,getChildIndex(this.wing) + (dirFlag ? 1 : -1));
            }
         }
      }
      
      public function get wingId() : int
      {
         if(this.wingXML == null)
         {
            return 0;
         }
         return int(this.wingXML.@id);
      }
      
      public function get weaponId() : int
      {
         if(this.weaponXML == null)
         {
            return 0;
         }
         return int(this.weaponXML.@id);
      }
      
      override public function set mouseEnabled(enabled:Boolean) : void
      {
         this.removeEventListener(MouseEvent.MOUSE_MOVE,this.onRollOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
         super.mouseEnabled = false;
      }
      
      public function setRole(params:Object, showType:String = "green", horseFlag:Boolean = false, callback:Function = null, forceUpdates:Boolean = false) : void
      {
         var color:int = 0;
         var sex:int = 1;
         if(Boolean(params.hasOwnProperty("taozhuangId")) && params.taozhuangId != 0)
         {
            this.clear();
            if(this.starTaoZhuang.indexOf(params.taozhuangId) == -1)
            {
               this.setBody(params.taozhuangId,showType);
            }
            else
            {
               if(params.hasOwnProperty("roleType"))
               {
                  if(params.roleType <= 9)
                  {
                     sex = params.roleType & 1;
                     sex *= 10;
                     color = params.roleType >> 1;
                     this.setBody(1000 + sex + color,showType,callback);
                  }
               }
               if(Boolean(params.hasOwnProperty("faceId")) && params.faceId != 0)
               {
                  this.setFace(params.faceId,showType);
               }
               else
               {
                  this.setFace(1000 + sex + 7,showType);
               }
               this.setCloth(params.taozhuangId,showType);
            }
            return;
         }
         if(params.hasOwnProperty("roleType"))
         {
            if(params.roleType > 9)
            {
               return;
            }
            sex = params.roleType & 1;
            sex *= 10;
            color = params.roleType >> 1;
            this.setBody(1000 + sex + color,showType,callback);
         }
         if(horseFlag)
         {
            if(EffectEnum.HORSE_WITH_CLOTH.indexOf(params.horseID) != -1)
            {
               if(sex > 0)
               {
                  this.setCloth(params.horseID,showType);
               }
               else
               {
                  this.setCloth(-params.horseID,showType);
               }
               this.setHat(0);
               this.setShoe(0);
            }
            else
            {
               this.setHat(60000 + sex + 1,showType);
               this.setCloth(60000 + sex + 2,showType);
               this.setShoe(60000 + sex + 3,showType);
            }
         }
         else
         {
            if(Boolean(params.hasOwnProperty("hatId")) && params.hatId != 0)
            {
               this.setHat(params.hatId,showType);
            }
            else
            {
               this.setHat(1000 + sex + 4,showType);
            }
            if(Boolean(params.hasOwnProperty("clothId")) && params.clothId != 0)
            {
               this.setCloth(params.clothId,showType);
            }
            else
            {
               this.setCloth(1000 + sex + 5,showType);
            }
            if(Boolean(params.hasOwnProperty("footId")) && params.footId != 0)
            {
               this.setShoe(params.footId,showType);
            }
            else
            {
               this.setShoe(1000 + sex + 6,showType);
            }
         }
         if(params.hasOwnProperty("weaponId"))
         {
            this.setWeapon(params.weaponId,showType);
         }
         if(Boolean(params.hasOwnProperty("faceId")) && params.faceId != 0)
         {
            this.setFace(params.faceId,showType);
         }
         else
         {
            this.setFace(1000 + sex + 7,showType);
         }
         if(params.hasOwnProperty("wingId"))
         {
            this.setWing(params.wingId,showType);
         }
         if(params.hasOwnProperty("glassId"))
         {
            this.setGlass(params.glassId,showType);
         }
         if(params.hasOwnProperty("leftWeapon"))
         {
            this.setLeftWeapon(params.leftWeapon,showType);
         }
         if(params.hasOwnProperty("horseID"))
         {
            this.setPet(params.horseID,showType);
         }
         this.render(this.direction,4,forceUpdates);
      }
   }
}

