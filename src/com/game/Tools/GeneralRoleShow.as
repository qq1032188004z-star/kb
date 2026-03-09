package com.game.Tools
{
   import com.game.Tools.other.GeneralRole;
   import com.game.newBase.BaseSprite;
   import com.publiccomponent.URLUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class GeneralRoleShow extends BaseSprite
   {
      
      public static const PREVIEW_ROLEFACE:int = 1;
      
      public static const PREVIEW_YIGUI:int = 4;
      
      public static const PREVIEW_HOME:int = 3;
      
      public static const PREVIEW_GARDEN:int = 2;
      
      private var _previewMode:int;
      
      private var _role:GeneralRole;
      
      private var yiguiLoader:Loader;
      
      public var btnRecover:RectButton;
      
      public var btnRecover1:RectButton;
      
      public var btnClear:RectButton;
      
      public var mcBG:MovieClip;
      
      private var _poiX:Number;
      
      private var _poiY:Number;
      
      private var gardonLoader:URLLoader;
      
      private var tempByteBuf:ByteArray;
      
      private var xCoord:Number;
      
      private var yCoord:Number;
      
      private var pWidth:Number;
      
      private var pHeight:Number;
      
      private var myBitmapdata:BitmapData;
      
      private var myBitmap:Bitmap;
      
      private var myBitmapMask:Shape;
      
      private var houseLoader:Loader;
      
      private var gardonObj:Object;
      
      private const gardonOffset:Array = [{
         "id":800328,
         "y":-91
      },{
         "id":800327,
         "y":-104
      },{
         "id":800326,
         "y":-69
      },{
         "id":800282,
         "y":-72
      },{
         "id":800281,
         "y":-92
      },{
         "id":800248,
         "y":-74
      },{
         "id":800246,
         "y":-50
      },{
         "id":800242,
         "y":-101
      },{
         "id":800245,
         "y":-101
      },{
         "id":800209,
         "y":-62
      },{
         "id":800330,
         "scale":0.5,
         "x":40,
         "y":210
      },{
         "id":800279,
         "scale":0.75,
         "x":50,
         "y":70
      },{
         "id":800277,
         "scale":0.5,
         "x":65,
         "y":-45
      },{
         "id":800258,
         "scale":0.75,
         "x":20,
         "y":130
      },{
         "id":800219,
         "scale":0.75,
         "x":35,
         "y":50
      },{
         "id":800201,
         "scale":0.75,
         "x":55,
         "y":70
      },{
         "id":800202,
         "scale":0.75,
         "y":95
      },{
         "id":800203,
         "scale":0.75,
         "y":-5
      },{
         "id":800217,
         "scale":0.5,
         "x":90,
         "y":140
      },{
         "id":800218,
         "scale":0.5,
         "x":130,
         "y":150
      },{
         "id":800220,
         "scale":0.5,
         "x":25,
         "y":-80
      },{
         "id":800222,
         "scale":0.75,
         "y":80
      },{
         "id":800225,
         "scale":0.5,
         "x":120,
         "y":155
      },{
         "id":800223,
         "scale":0.5,
         "x":60,
         "y":180
      },{
         "id":800224,
         "scale":0.5,
         "x":70,
         "y":140
      },{
         "id":800226,
         "scale":0.5,
         "x":93,
         "y":126
      },{
         "id":800227,
         "scale":0.5,
         "x":70,
         "y":80
      },{
         "id":800228,
         "scale":0.5,
         "x":123,
         "y":42
      },{
         "id":800022,
         "scale":0.5,
         "x":18,
         "y":166
      },{
         "id":800275,
         "x":-20,
         "y":25
      },{
         "id":800252,
         "x":-40,
         "y":40
      },{
         "id":800261,
         "x":-40
      },{
         "id":800214,
         "x":-10,
         "y":-100
      },{
         "id":800215,
         "x":20,
         "y":-75
      },{
         "id":800229,
         "x":50,
         "y":50
      }];
      
      public function GeneralRoleShow(mc:MovieClip, poi_x:Number = 192, poi_y:Number = 240)
      {
         this._poiX = poi_x;
         this._poiY = poi_y;
         super(mc);
      }
      
      override protected function initView() : void
      {
         super.initView();
         if(uiSkin.hasOwnProperty("btnRecover"))
         {
            relateRectBtns("btnRecover");
         }
         if(uiSkin.hasOwnProperty("btnRecover1"))
         {
            relateRectBtns("btnRecover1");
         }
         if(uiSkin.hasOwnProperty("btnClear"))
         {
            relateRectBtns("btnClear");
         }
         if(uiSkin.hasOwnProperty("mcBG"))
         {
            relateDisplayObjectContainer("mcBG");
         }
         this._role = new GeneralRole(this._poiX,this._poiY);
         uiSkin.addChildAt(this._role,1);
         this.previewChange(PREVIEW_ROLEFACE);
      }
      
      override protected function onMyBtnMouseClick(event:MouseEvent) : void
      {
         super.onMyBtnMouseClick(event);
         switch(event.currentTarget)
         {
            case this.btnRecover:
               this._role.recoverEquipment();
               break;
            case this.btnRecover1:
               if(Boolean(this.yiguiLoader))
               {
                  this.yiguiLoader.unload();
                  this.yiguiLoader.visible = false;
               }
               if(Boolean(this.myBitmap))
               {
                  this.myBitmap.visible = false;
               }
               if(Boolean(this.myBitmapMask))
               {
                  this.myBitmapMask.visible = false;
               }
               if(Boolean(this.houseLoader))
               {
                  this.houseLoader.visible = false;
               }
               break;
            case this.btnClear:
               this._role.getOffEquipment();
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._role))
         {
            this._role.dipos();
         }
      }
      
      private function previewChange(mode:int) : void
      {
         if(this._previewMode != mode)
         {
            this._previewMode = mode;
            if(Boolean(this.mcBG))
            {
               this.mcBG.gotoAndStop(this._previewMode);
            }
            if(Boolean(this.yiguiLoader))
            {
               this.yiguiLoader.unload();
               this.yiguiLoader.visible = false;
            }
            if(Boolean(this.myBitmap))
            {
               this.myBitmap.visible = false;
            }
            if(Boolean(this.myBitmapMask))
            {
               this.myBitmapMask.visible = false;
            }
            if(Boolean(this.houseLoader))
            {
               this.houseLoader.visible = false;
            }
            if(Boolean(this.btnRecover))
            {
               this.btnRecover.visible = this._previewMode == PREVIEW_ROLEFACE;
            }
            if(Boolean(this.btnClear))
            {
               this.btnClear.visible = this._previewMode == PREVIEW_ROLEFACE;
            }
            if(Boolean(this.btnRecover1))
            {
               this.btnRecover1.visible = this._previewMode != PREVIEW_ROLEFACE;
            }
            this._role.visible = this._previewMode == PREVIEW_ROLEFACE;
            if(this._previewMode == PREVIEW_YIGUI && Boolean(this.yiguiLoader))
            {
               this.yiguiLoader.visible = true;
            }
         }
      }
      
      public function tryClothWarehouse(id:int) : void
      {
         if(Boolean(this.yiguiLoader))
         {
            this.yiguiLoader.load(new URLRequest(URLUtil.getSvnVer("assets/clothwarehouse/yiguiface/face" + id + ".swf")));
         }
         else
         {
            this.yiguiLoader = new Loader();
            if(Boolean(uiSkin))
            {
               uiSkin.addChildAt(this.yiguiLoader,uiSkin.numChildren - 4);
            }
            this.yiguiLoader.mouseEnabled = false;
            this.yiguiLoader.x = -20;
            this.yiguiLoader.y = 140;
            this.yiguiLoader.load(new URLRequest(URLUtil.getSvnVer("assets/clothwarehouse/yiguiface/face" + id + ".swf")));
         }
      }
      
      public function tryItem(data:Object) : void
      {
         var clothList:Array = null;
         this.previewChange(data.preview);
         if(data.preview == PREVIEW_ROLEFACE)
         {
            if(data.type == 2)
            {
               clothList = data.clothList;
               if(clothList.length == 0)
               {
                  this._role.renderEquipMent(data.goodId);
               }
               else
               {
                  this._role.tryTaoZhuang(clothList);
               }
            }
            else if(data.type == 1)
            {
               this._role.tryFaceOrBorder(data.goodId);
            }
            else
            {
               this._role.renderEquipMent(data.goodId);
            }
         }
         else if(data.preview == PREVIEW_YIGUI)
         {
            this.tryClothWarehouse(data.goodId);
         }
         else if(data.preview == PREVIEW_HOME)
         {
            this.tryHourseDress(data);
         }
         else if(data.preview == PREVIEW_GARDEN)
         {
            this.tryGardon(data);
         }
      }
      
      public function tryGardon(data:Object) : void
      {
         var house:Object = null;
         this.gardonObj = data;
         if(data.type == 4 && data.subType == 0)
         {
            if(!this.myBitmapMask)
            {
               this.myBitmapMask = new Shape();
               this.myBitmapMask.graphics.beginFill(16711680,1);
               this.myBitmapMask.graphics.drawRect(0,0,225,275);
               this.myBitmapMask.graphics.endFill();
               this.myBitmapMask.x = 8;
               this.myBitmapMask.y = 15;
               if(Boolean(uiSkin) && !uiSkin.contains(this.myBitmapMask))
               {
                  uiSkin.addChildAt(this.myBitmapMask,uiSkin.numChildren - 4);
               }
            }
            if(this.houseLoader == null)
            {
               this.houseLoader = new Loader();
               if(Boolean(uiSkin))
               {
                  uiSkin.addChildAt(this.houseLoader,uiSkin.numChildren - 4);
               }
               this.houseLoader.mouseEnabled = false;
               this.houseLoader.scaleX = 0.35;
               this.houseLoader.scaleY = 0.35;
               this.houseLoader.mask = this.myBitmapMask;
            }
            this.houseLoader.x = 50;
            this.houseLoader.y = 100;
            this.houseLoader.load(new URLRequest(URLUtil.getSvnVer("assets/build/xiaowu" + data.goodId + ".swf")));
            this.houseLoader.visible = true;
            for each(house in this.gardonOffset)
            {
               if(house.id == data.goodId)
               {
                  if(house.hasOwnProperty("x"))
                  {
                     this.houseLoader.x += house.x;
                  }
                  if(house.hasOwnProperty("y"))
                  {
                     this.houseLoader.y += house.y;
                  }
                  break;
               }
            }
            if(Boolean(this.myBitmap))
            {
               this.myBitmap.visible = false;
            }
            if(Boolean(this.myBitmapMask))
            {
               this.myBitmapMask.visible = false;
            }
         }
         else
         {
            this.tryHourseDress(data);
         }
      }
      
      private function tryHourseDress(data:Object) : void
      {
         this.gardonObj = data;
         if(Boolean(this.houseLoader))
         {
            this.houseLoader.visible = false;
         }
         if(Boolean(this.gardonLoader))
         {
            this.gardonLoader.load(new URLRequest(URLUtil.getSvnVer("assets/basedress/prop/prop" + data.goodId + ".dress")));
         }
         else
         {
            this.gardonLoader = new URLLoader();
            this.gardonLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this.gardonLoader.addEventListener(Event.COMPLETE,this.onGardonLoaderComplete);
            this.gardonLoader.load(new URLRequest(URLUtil.getSvnVer("assets/basedress/prop/prop" + data.goodId + ".dress")));
         }
      }
      
      private function onGardonLoaderComplete(evt:Event) : void
      {
         var temp_byte:ByteArray = null;
         var rec:Rectangle = null;
         var num:int = 0;
         var gardon:Object = null;
         this.tempByteBuf = this.gardonLoader.data as ByteArray;
         if(this.tempByteBuf != null)
         {
            this.tempByteBuf.uncompress();
            this.tempByteBuf.position = 0;
            this.xCoord = this.tempByteBuf.readInt();
            this.yCoord = this.tempByteBuf.readInt();
            this.pWidth = this.tempByteBuf.readInt();
            this.pHeight = this.tempByteBuf.readInt();
            temp_byte = new ByteArray();
            this.tempByteBuf.readBytes(temp_byte,0,this.tempByteBuf.bytesAvailable);
            rec = new Rectangle(0,0,this.pWidth,this.pHeight);
            if(Boolean(this.myBitmapdata))
            {
               this.myBitmapdata.dispose();
            }
            this.myBitmapdata = new BitmapData(this.pWidth,this.pHeight);
            this.myBitmapdata.setPixels(rec,temp_byte);
            if(!this.myBitmapMask)
            {
               this.myBitmapMask = new Shape();
               this.myBitmapMask.graphics.beginFill(16711680,1);
               this.myBitmapMask.graphics.drawRect(0,0,225,275);
               this.myBitmapMask.graphics.endFill();
               this.myBitmapMask.x = 8;
               this.myBitmapMask.y = 15;
               if(Boolean(uiSkin) && !uiSkin.contains(this.myBitmapMask))
               {
                  uiSkin.addChildAt(this.myBitmapMask,uiSkin.numChildren - 4);
               }
            }
            this.myBitmap = new Bitmap(this.myBitmapdata);
            if(Boolean(uiSkin) && !uiSkin.contains(this.myBitmap))
            {
               num = uiSkin.getChildIndex(this.myBitmapMask);
               uiSkin.addChildAt(this.myBitmap,num - 1);
               this.myBitmap.y = this.yCoord + 180;
               this.myBitmap.x = this.xCoord + 130;
               this.myBitmap.mask = this.myBitmapMask;
               for each(gardon in this.gardonOffset)
               {
                  if(gardon.id == this.gardonObj.goodId)
                  {
                     if(gardon.hasOwnProperty("x"))
                     {
                        this.myBitmap.x += gardon.x;
                     }
                     if(gardon.hasOwnProperty("y"))
                     {
                        this.myBitmap.y += gardon.y;
                     }
                     if(gardon.hasOwnProperty("scale"))
                     {
                        this.myBitmap.scaleX = gardon.scale;
                        this.myBitmap.scaleY = gardon.scale;
                     }
                     else
                     {
                        this.myBitmap.scaleX = 1;
                        this.myBitmap.scaleY = 1;
                     }
                     break;
                  }
               }
            }
         }
      }
   }
}

