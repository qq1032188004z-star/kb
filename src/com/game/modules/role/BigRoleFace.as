package com.game.modules.role
{
   import com.game.util.ComponetUtil;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Sprite;
   import org.dress.enum.EffectEnum;
   import org.dress.ui.BaseDecoration;
   import org.dress.ui.BaseWing;
   import org.dress.ui.BaseWingTeXiao;
   
   public class BigRoleFace extends Sprite
   {
      
      private var starTaoZhuang:Array = [551059,551060];
      
      private var _head:BaseDecoration;
      
      private var _face:BaseDecoration;
      
      private var _glass:BaseDecoration;
      
      private var _cloth:BaseDecoration;
      
      private var _shoe:BaseDecoration;
      
      private var _weapon:BaseDecoration;
      
      private var _leftWeapon:BaseDecoration;
      
      private var _body:BaseDecoration;
      
      private var _curBodyID:int;
      
      private var _curShoeID:int;
      
      private var _curFaceID:int;
      
      private var _curGlasID:int;
      
      private var weaponXML:XML;
      
      private var leftWeaponXML:XML;
      
      private var wingXML:XML;
      
      private var clothXML:XML;
      
      private var hatXML:XML;
      
      private var _wing:BaseDecoration;
      
      private var _headEffct:BaseWingTeXiao;
      
      private var _weaponEffect:BaseWingTeXiao;
      
      private var _leftWeaponEffect:BaseWingTeXiao;
      
      private var _wingEffect:BaseWingTeXiao;
      
      private var _clothEffct:BaseWingTeXiao;
      
      private var _dressParams:Object = {};
      
      public function BigRoleFace()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._cloth = new BaseDecoration();
         this._face = new BaseDecoration();
         this._shoe = new BaseDecoration();
         this._head = new BaseDecoration();
         this._body = new BaseDecoration();
         this._glass = new BaseDecoration();
         addChild(this._body);
         addChild(this._face);
         addChild(this._shoe);
         addChild(this._cloth);
         addChild(this._head);
         addChild(this._glass);
      }
      
      public function setBody(id:int) : void
      {
         if(id == 0)
         {
            this._curShoeID = 0;
            this._body.bitmapData = null;
         }
         else if(this._curBodyID != id)
         {
            this._curBodyID = id;
            this._body.load("assets/role/" + id + ".big","body");
         }
      }
      
      public function tackAllOff() : void
      {
         this.setBody(0);
         this.setCloth(0);
         this.setFace(0);
         this.setHead(0);
         this.setShoe(0);
         this.setWeapon(0);
         this.setGlass(0);
         this.setLeftWeapon(0);
         this.setWing(0);
      }
      
      public function setRole(params:Object, withHorseCloth:Boolean = true) : void
      {
         var color:int = 0;
         var sex:int = 1;
         if(Boolean(params.hasOwnProperty("taozhuangId")) && params.taozhuangId != 0)
         {
            if(this.starTaoZhuang.indexOf(params.taozhuangId) == -1)
            {
               if(this._curBodyID != params.taozhuangId)
               {
                  this.tackAllOff();
               }
               this.setBody(params.taozhuangId);
            }
            else
            {
               this.tackAllOff();
               if(params.hasOwnProperty("roleType"))
               {
                  if(params.roleType <= 9)
                  {
                     sex = params.roleType & 1;
                     sex *= 10;
                     color = params.roleType >> 1;
                     this.setBody(1000 + sex + color);
                  }
               }
               if(Boolean(params.hasOwnProperty("faceId")) && params.faceId != 0)
               {
                  this.setFace(params.faceId);
               }
               else
               {
                  this.setFace(1000 + sex + 7);
               }
               this.setCloth(params.taozhuangId);
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
            this.setBody(1000 + sex + color);
         }
         if(withHorseCloth && Boolean(params.hasOwnProperty("horseID")) && params.horseID != 0)
         {
            if(EffectEnum.HORSE_WITH_CLOTH.indexOf(params.horseID) != -1)
            {
               if(sex > 0)
               {
                  this.setCloth(params.horseID);
               }
               else
               {
                  this.setCloth(-params.horseID);
               }
               this.setHead(0);
               this.setShoe(0);
            }
            else
            {
               this.setHead(60000 + sex + 1);
               this.setCloth(60000 + sex + 2);
               this.setShoe(60000 + sex + 3);
            }
         }
         else
         {
            if(Boolean(params.hasOwnProperty("hatId")) && params.hatId != 0)
            {
               this.setHead(params.hatId);
            }
            else
            {
               this.setHead(1000 + sex + 4);
            }
            if(Boolean(params.hasOwnProperty("clothId")) && params.clothId != 0)
            {
               this.setCloth(params.clothId);
            }
            else
            {
               this.setCloth(1000 + sex + 5);
            }
            if(Boolean(params.hasOwnProperty("footId")) && params.footId != 0)
            {
               this.setShoe(params.footId);
            }
            else
            {
               this.setShoe(1000 + sex + 6);
            }
         }
         if(params.hasOwnProperty("weaponId"))
         {
            this.setWeapon(params.weaponId);
         }
         if(Boolean(params.hasOwnProperty("faceId")) && params.faceId != 0)
         {
            this.setFace(params.faceId);
         }
         else
         {
            this.setFace(1000 + sex + 7);
         }
         if(params.hasOwnProperty("wingId"))
         {
            this.setWing(params.wingId);
         }
         if(params.hasOwnProperty("glassId"))
         {
            this.setGlass(params.glassId);
         }
         if(params.hasOwnProperty("leftWeapon"))
         {
            this.setLeftWeapon(params.leftWeapon);
         }
         this.update();
      }
      
      public function render() : void
      {
         if(Boolean(this._wing))
         {
            this._wing.render();
         }
         if(Boolean(this._wingEffect))
         {
            this._wingEffect.render();
         }
         if(Boolean(this._headEffct))
         {
            this._headEffct.render();
         }
         if(Boolean(this._leftWeaponEffect))
         {
            this._leftWeaponEffect.render();
         }
         if(Boolean(this._clothEffct))
         {
            this._clothEffct.render();
         }
         if(Boolean(this._weaponEffect))
         {
            this._weaponEffect.render();
         }
      }
      
      public function setHead(id:int) : void
      {
         this._head.visible = id > 0;
         if(id > 0)
         {
            if(Boolean(this.hatXML) && this.hatXML.@id == id)
            {
               return;
            }
            this._head.load("assets/head/" + id + ".big","head");
            this._head.visible = true;
            this.hatXML = XMLLocator.getInstance().getTool(id);
            if(Boolean(this.hatXML) && this.hatXML.effect == 1)
            {
               if(this._headEffct == null)
               {
                  this._headEffct = new BaseWingTeXiao();
                  addChild(this._headEffct);
               }
               this._headEffct.load("assets/head/texiao/" + id + ".big","headEffect");
               return;
            }
         }
         else
         {
            this.hatXML = null;
         }
         if(Boolean(this._headEffct))
         {
            this._headEffct.dispos();
            this._headEffct = null;
         }
      }
      
      public function setCloth(id:int) : void
      {
         this._cloth.visible = id != 0;
         if(id != 0)
         {
            if(Boolean(this.clothXML) && this.clothXML.@id == id)
            {
               return;
            }
            this._cloth.load("assets/cloth/" + id + ".big","cloth");
            this.clothXML = XMLLocator.getInstance().getTool(id);
            if(Boolean(this.clothXML) && this.clothXML.effect == 1)
            {
               if(this._clothEffct == null)
               {
                  this._clothEffct = new BaseWingTeXiao();
                  addChild(this._clothEffct);
               }
               this._clothEffct.load("assets/cloth/texiao/" + id + ".big","clothEffct");
               return;
            }
         }
         else
         {
            this.clothXML = null;
         }
         if(Boolean(this._clothEffct))
         {
            this._clothEffct.dispos();
            this._clothEffct = null;
         }
      }
      
      public function setShoe(id:int) : void
      {
         if(id == 0)
         {
            this._curShoeID = 0;
            this._shoe.bitmapData = null;
         }
         else if(this._curShoeID != id)
         {
            this._curShoeID = id;
            this._shoe.load("assets/foot/" + id + ".big","foot");
         }
      }
      
      public function setFace(id:int) : void
      {
         if(id == 0)
         {
            this._curFaceID = 0;
            this._face.bitmapData = null;
         }
         else if(this._curFaceID != id)
         {
            this._curFaceID = id;
            this._face.load("assets/face/" + id + ".big","face");
         }
      }
      
      public function setWeapon(id:int) : void
      {
         if(id > 0)
         {
            if(Boolean(this.weaponXML) && this.weaponXML.@id == id)
            {
               return;
            }
            if(this._weapon == null)
            {
               this._weapon = new BaseDecoration();
               addChild(this._weapon);
            }
            this._weapon.bitmapData = null;
            this._weapon.load("assets/weapon/" + id + ".big","weapon");
            this.weaponXML = XMLLocator.getInstance().getTool(id);
            if(this.weaponXML.effect == 1)
            {
               if(this._weaponEffect == null)
               {
                  this._weaponEffect = new BaseWingTeXiao();
                  if(this.weaponXML.effect_swap == 1)
                  {
                     addChildAt(this._weaponEffect,getChildIndex(this._weapon) - 1);
                  }
                  else
                  {
                     addChild(this._weaponEffect);
                  }
               }
               this._weaponEffect.load("assets/weapon/texiao/" + id + ".big","weaponEffect");
               return;
            }
         }
         else
         {
            if(Boolean(this._weapon))
            {
               this._weapon.dispos();
               this._weapon = null;
            }
            this.weaponXML = null;
         }
         if(Boolean(this._weaponEffect))
         {
            this._weaponEffect.dispos();
            this._weaponEffect = null;
         }
      }
      
      public function setLeftWeapon(id:int) : void
      {
         if(id > 0)
         {
            if(Boolean(this.leftWeaponXML) && this.leftWeaponXML.@id == id)
            {
               return;
            }
            if(this._leftWeapon == null)
            {
               this._leftWeapon = new BaseDecoration();
               addChild(this._leftWeapon);
            }
            this._leftWeapon.bitmapData = null;
            this._leftWeapon.load("assets/weapon/" + id + ".big","weapon");
            this.leftWeaponXML = XMLLocator.getInstance().getTool(id);
            if(this.leftWeaponXML.effect == 1)
            {
               if(this._leftWeaponEffect == null)
               {
                  this._leftWeaponEffect = new BaseWingTeXiao();
                  if(this.leftWeaponXML.effect_swap == 1)
                  {
                     addChildAt(this._leftWeaponEffect,getChildIndex(this._leftWeapon) - 1);
                  }
                  else
                  {
                     addChild(this._leftWeaponEffect);
                  }
               }
               this._leftWeaponEffect.load("assets/weapon/texiao/" + id + ".big","weaponEffect");
               return;
            }
         }
         else
         {
            if(Boolean(this._leftWeapon))
            {
               this._leftWeapon.dispos();
               this._leftWeapon = null;
            }
            this.leftWeaponXML = null;
         }
         if(Boolean(this._leftWeaponEffect))
         {
            this._leftWeaponEffect.dispos();
            this._leftWeaponEffect = null;
         }
      }
      
      public function setWing(id:int) : void
      {
         if(id > 0)
         {
            if(Boolean(this.wingXML) && this.wingXML.@id == id)
            {
               return;
            }
            if(this._wing == null)
            {
               this._wing = new BaseWing();
               addChild(this._wing);
            }
            this._wing.bitmapData = null;
            this._wing.load("assets/wing/" + id + ".big","wing");
            this.wingXML = XMLLocator.getInstance().getTool(id);
            if(this.wingXML.effect == 1)
            {
               if(this._wingEffect == null)
               {
                  this._wingEffect = new BaseWingTeXiao();
                  if(this.wingXML.effect_swap != 0)
                  {
                     addChildAt(this._wingEffect,getChildIndex(this._wing) - 1);
                  }
                  else
                  {
                     addChild(this._wingEffect);
                  }
               }
               this._wingEffect.load("assets/wingtexiao/" + id + ".big","wingtexiao");
               return;
            }
         }
         else
         {
            if(Boolean(this._wing))
            {
               this._wing.dispos();
               this._wing = null;
            }
            this.wingXML = null;
         }
         if(Boolean(this._wingEffect))
         {
            this._wingEffect.dispos();
            this._wingEffect = null;
         }
      }
      
      public function setGlass(id:int) : void
      {
         if(id == 0)
         {
            this._curGlasID = 0;
            this._glass.bitmapData = null;
         }
         else if(this._curGlasID != id)
         {
            this._curGlasID = id;
            this._glass.load("assets/glasses/" + id + ".big","glass");
         }
      }
      
      public function getHoverPartUrl(x:int, y:int) : String
      {
         var decor:BaseDecoration = this.checkHover(this._leftWeapon,x,y) || this.checkHover(this._glass,x,y) || this.checkHover(this._head,x,y) || this.checkHover(this._cloth,x,y) || this.checkHover(this._shoe,x,y) || this.checkHover(this._face,x,y) || this.checkHover(this._weapon,x,y) || this.checkHover(this._wing,x,y) || this.checkHover(this._body,x,y);
         if(Boolean(decor))
         {
            return decor.url;
         }
         return null;
      }
      
      private function checkHover(decor:BaseDecoration, x:int, y:int) : BaseDecoration
      {
         if(ComponetUtil.isHoverBmp(decor,x,y))
         {
            return decor;
         }
         return null;
      }
      
      public function update() : void
      {
         var childIndex:int = 0;
         if(Boolean(this._body))
         {
            if(this.getChildIndex(this._body) != childIndex)
            {
               addChildAt(this._body,childIndex);
            }
            childIndex++;
         }
         if(Boolean(this._wing))
         {
            if(this.getChildIndex(this._wing) != childIndex)
            {
               addChildAt(this._wing,childIndex);
            }
            childIndex++;
         }
         if(Boolean(this._wingEffect))
         {
            if(this.getChildIndex(this._wingEffect) != childIndex)
            {
               addChildAt(this._wingEffect,childIndex);
            }
            childIndex++;
         }
         if(Boolean(this._weapon))
         {
            if(this.getChildIndex(this._weapon) != childIndex)
            {
               addChildAt(this._weapon,childIndex);
            }
            childIndex++;
         }
         if(Boolean(this._weaponEffect))
         {
            if(this.getChildIndex(this._weaponEffect) != childIndex)
            {
               addChildAt(this._weaponEffect,childIndex);
            }
            childIndex++;
         }
         if(Boolean(this._face))
         {
            if(this.getChildIndex(this._face) != childIndex)
            {
               addChildAt(this._face,childIndex);
            }
            childIndex++;
         }
         if(Boolean(this._shoe))
         {
            if(this.getChildIndex(this._shoe) != childIndex)
            {
               addChildAt(this._shoe,childIndex);
            }
            childIndex++;
         }
         if(Boolean(this._cloth))
         {
            if(this.getChildIndex(this._cloth) != childIndex)
            {
               addChildAt(this._cloth,childIndex);
            }
            childIndex++;
         }
         if(Boolean(this._head))
         {
            if(this.getChildIndex(this._head) != childIndex)
            {
               addChildAt(this._head,childIndex++);
            }
            childIndex++;
         }
         if(Boolean(this._headEffct))
         {
            if(this.getChildIndex(this._headEffct) != childIndex)
            {
               addChildAt(this._headEffct,childIndex);
            }
            childIndex++;
         }
         if(Boolean(this._glass))
         {
            if(this.getChildIndex(this._glass) != childIndex)
            {
               addChildAt(this._glass,childIndex);
            }
            childIndex++;
         }
         if(Boolean(this._leftWeapon))
         {
            if(this.getChildIndex(this._leftWeapon) != childIndex)
            {
               addChildAt(this._leftWeapon,childIndex);
            }
            childIndex++;
         }
         if(Boolean(this._leftWeaponEffect))
         {
            if(this.getChildIndex(this._leftWeaponEffect) != childIndex)
            {
               addChildAt(this._leftWeaponEffect,childIndex);
            }
            childIndex++;
         }
         if(Boolean(this._clothEffct))
         {
            if(this.getChildIndex(this._clothEffct) != childIndex)
            {
               addChildAt(this._clothEffct,childIndex);
            }
            childIndex++;
         }
         if(this.weaponId == 500143)
         {
            if(Boolean(this._weapon))
            {
               addChild(this._weapon);
            }
         }
      }
      
      public function get weaponId() : int
      {
         if(this.weaponXML == null)
         {
            return 0;
         }
         return int(this.weaponXML.@id);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._head))
         {
            this._head.dispos();
            this._head = null;
         }
         if(Boolean(this._headEffct))
         {
            this._headEffct.dispos();
            this._headEffct = null;
         }
         if(Boolean(this._face))
         {
            this._face.dispos();
            this._face = null;
         }
         if(Boolean(this._glass))
         {
            this._glass.dispos();
            this._glass = null;
         }
         if(Boolean(this._wing))
         {
            this._wing.dispos();
            this._wing = null;
         }
         if(Boolean(this._wingEffect))
         {
            this._wingEffect.dispos();
            this._wingEffect = null;
         }
         if(Boolean(this._weapon))
         {
            this._weapon.dispos();
            this._weapon = null;
         }
         if(Boolean(this._weaponEffect))
         {
            this._weaponEffect.dispos();
            this._weaponEffect = null;
         }
         if(Boolean(this._leftWeapon))
         {
            this._leftWeapon.dispos();
            this._leftWeapon = null;
         }
         if(Boolean(this._leftWeaponEffect))
         {
            this._leftWeaponEffect.dispos();
            this._leftWeaponEffect = null;
         }
         if(Boolean(this._cloth))
         {
            this._cloth.dispos();
            this._cloth = null;
         }
         if(Boolean(this._shoe))
         {
            this._shoe.dispos();
            this._shoe = null;
         }
         if(Boolean(this._body))
         {
            this._body.dispos();
            this._body = null;
         }
         if(Boolean(this._clothEffct))
         {
            this._clothEffct.dispos();
            this._clothEffct = null;
         }
      }
   }
}

