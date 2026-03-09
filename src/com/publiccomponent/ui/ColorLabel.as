package com.publiccomponent.ui
{
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import mx.utils.StringUtil;
   
   public class ColorLabel extends Sprite
   {
      
      private var borderClip:MovieClip;
      
      private var nameText:String = "";
      
      private var materialLib:*;
      
      private var _isHidden:Boolean = false;
      
      private var currentAttr:Object = {};
      
      private var isVip:Boolean = false;
      
      private const VIP_COLOR:uint = 15728895;
      
      public function ColorLabel(xCoord:Number, yCoord:Number)
      {
         super();
         mouseChildren = false;
         mouseEnabled = false;
         this.materialLib = getDefinitionByName("com.publiccomponent.loading.MaterialLib");
      }
      
      public function set isHide(value:Boolean) : void
      {
         this._isHidden = value;
         this.updateVisibility();
      }
      
      public function get isHide() : Boolean
      {
         return this._isHidden;
      }
      
      public function setBorder(id:int = 1, oldId:int = 0) : int
      {
         this.removeBorder();
         var xml:XML = this.getBorderXML(id,oldId);
         if(Boolean(xml))
         {
            this.currentAttr = {
               "id":int(xml.@id),
               "color":uint(xml.color),
               "left":int(xml.left),
               "top":int(xml.top),
               "nameTxtWidth":int(xml.nameTxtWidth),
               "bgClipWidth":int(xml.bgClipWidth),
               "wingClipX":int(xml.wingClipX)
            };
         }
         NameLabelLoader.instance.load("assets/nameboder/boder" + this.currentAttr["id"] + ".swf",this.onBorderLoaded,"boder" + this.currentAttr["id"]);
         this.updateVisibility();
         return this.currentAttr["id"];
      }
      
      private function getBorderXML(id:int, oldId:int) : XML
      {
         var xml:XML = null;
         var locator:XMLLocator = null;
         try
         {
            locator = XMLLocator.getInstance();
            if(oldId > 0 && oldId < 1000)
            {
               xml = locator.npctransformDic[oldId];
            }
            else
            {
               xml = locator.npctransform.children().(@id == id)[0];
            }
            if(!xml)
            {
               xml = locator.npctransformDic[3];
            }
         }
         catch(e:Error)
         {
            trace("[ColorLabel] 获取外框XML失败:",e.message);
         }
         return xml;
      }
      
      private function onBorderLoaded(value:Object) : void
      {
         this.removeBorder();
         this.borderClip = value as MovieClip;
         if(!this.borderClip)
         {
            return;
         }
         this.borderClip.y = this.currentAttr.top;
         this.borderClip.mouseEnabled = false;
         addChild(this.borderClip);
         this.refreshName();
      }
      
      private function removeBorder() : void
      {
         if(Boolean(this.borderClip) && contains(this.borderClip))
         {
            removeChild(this.borderClip);
         }
         this.borderClip = null;
      }
      
      public function set text(value:String) : void
      {
         this.nameText = StringUtil.trim(value);
         this.updateVisibility();
         if(Boolean(this.borderClip))
         {
            this.refreshName();
         }
      }
      
      private function updateVisibility() : void
      {
         visible = !this._isHidden && this.nameText.length > 0;
      }
      
      public function setFlag(str:String) : void
      {
         if(Boolean(this.borderClip) && Boolean(this.borderClip.hasOwnProperty("flagTxt")))
         {
            this.borderClip["flagTxt"].text = str;
         }
      }
      
      public function txtFilter(value:* = null) : void
      {
         this.setVipColor();
      }
      
      public function setVipColor() : void
      {
         this.isVip = true;
         if(Boolean(this.borderClip) && Boolean(this.borderClip.hasOwnProperty("nameTxt")))
         {
            TextField(this.borderClip["nameTxt"]).textColor = this.VIP_COLOR;
         }
      }
      
      private function refreshName() : void
      {
         var wing:MovieClip = null;
         if(!this.borderClip || this.nameText == "")
         {
            return;
         }
         var txtField:TextField = this.borderClip["nameTxt"];
         if(!txtField)
         {
            return;
         }
         var displayName:String = this.nameText.length > 9 ? this.nameText.substr(0,8) : this.nameText;
         txtField.text = displayName;
         if(this.isVip)
         {
            txtField.textColor = this.VIP_COLOR;
         }
         txtField.width = txtField.textWidth + 30;
         this.borderClip["bgClip"].width = Math.max(60,txtField.width + this.currentAttr.bgClipWidth);
         txtField.width += this.currentAttr.nameTxtWidth;
         if(this.borderClip.hasOwnProperty("wingClip"))
         {
            wing = this.borderClip["wingClip"];
            wing.x = this.borderClip["bgClip"].x + this.borderClip["bgClip"].width + this.currentAttr.wingClipX;
            if(this.currentAttr.id == 100289)
            {
               wing.x -= 10;
            }
            else if(this.currentAttr.id == 100290)
            {
               wing.x -= 20;
            }
         }
         this.borderClip.x = -this.borderClip.width / 2 - this.currentAttr.left;
      }
      
      public function dispos() : void
      {
         this.removeBorder();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

