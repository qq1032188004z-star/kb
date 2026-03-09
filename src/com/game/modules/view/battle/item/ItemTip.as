package com.game.modules.view.battle.item
{
   import com.game.modules.view.MapView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol629")]
   public class ItemTip extends Sprite
   {
      
      private static var _instance:ItemTip;
      
      public var bg:MovieClip;
      
      private var tipname:TextField;
      
      private var tipdesc:TextField;
      
      private var tipnamestr:String;
      
      private var tipdescstr:String;
      
      private const MAX_WIDTH:int = 250;
      
      private var info:Object;
      
      private var needshow:Boolean;
      
      private var showparent:DisplayObjectContainer;
      
      public function ItemTip()
      {
         super();
         this.init();
      }
      
      public static function get instance() : ItemTip
      {
         if(_instance == null)
         {
            _instance = new ItemTip();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this.tipname = new TextField();
         this.tipname.y = 7;
         this.tipname.x = 7;
         this.tipname.height = 20;
         this.tipname.selectable = false;
         this.addChild(this.tipname);
         this.tipdesc = new TextField();
         this.tipdesc.y = 25;
         this.tipdesc.x = 7;
         this.tipdesc.selectable = false;
         this.addChild(this.tipdesc);
         this.mouseEnabled = this.mouseChildren = false;
         if(this.needshow)
         {
            this.show(ItemTip.instance.info,this.showparent,ItemTip.instance.x,ItemTip.instance.y);
         }
      }
      
      public function show(info:Object, parent:DisplayObjectContainer, x:int, y:int) : void
      {
         var textWidth:Number = NaN;
         ItemTip.instance.info = info;
         this.needshow = true;
         if(parent == null)
         {
            parent = MapView.instance.stage;
         }
         this.showparent = parent;
         this.tipnamestr = info.toolname + "";
         this.tipdescstr = info.tooldesc + "";
         ItemTip.instance.x = x;
         ItemTip.instance.y = y;
         if(this.bg == null)
         {
            return;
         }
         if(this.tipdescstr != "")
         {
            this.tipname.htmlText = "<font color=\'#FF9900\'>" + this.tipnamestr + "</font>";
            this.tipname.width = this.tipname.textWidth + 6;
            this.tipdesc.htmlText = this.tipdescstr + "";
            this.tipdesc.visible = true;
            this.tipdesc.wordWrap = false;
            this.tipdesc.width = NaN;
            textWidth = this.tipdesc.textWidth + 6;
            if(textWidth > this.MAX_WIDTH)
            {
               this.tipdesc.width = this.MAX_WIDTH;
               this.tipdesc.wordWrap = true;
               this.tipdesc.height = this.tipdesc.textHeight + 4;
            }
            else
            {
               this.tipdesc.width = textWidth;
               this.tipdesc.wordWrap = false;
               this.tipdesc.height = this.tipdesc.textHeight + 4;
            }
            ItemTip.instance.bg.height = 38 + this.tipdesc.textHeight + 10;
            ItemTip.instance.bg.width = this.tipdesc.width + 20;
            ItemTip.instance.y -= ItemTip.instance.bg.height - 78;
         }
         else
         {
            this.tipdesc.visible = false;
            this.tipname.htmlText = "<font color=\'#ffffff\'>" + this.tipnamestr + "</font>";
            this.tipname.wordWrap = false;
            this.tipname.width = NaN;
            textWidth = this.tipname.textWidth + 6;
            if(textWidth > this.MAX_WIDTH)
            {
               this.tipname.width = this.MAX_WIDTH;
               this.tipname.wordWrap = true;
               this.tipname.height = this.tipname.textHeight + 4;
            }
            else if(textWidth < 50)
            {
               this.tipname.width = 50;
            }
            else
            {
               this.tipname.width = textWidth;
               this.tipname.wordWrap = false;
               this.tipname.height = this.tipname.textHeight + 4;
            }
            ItemTip.instance.bg.height = this.tipname.textHeight + 30;
            ItemTip.instance.bg.width = this.tipname.width + 10;
            ItemTip.instance.y -= ItemTip.instance.bg.height;
         }
         ItemTip.instance.x -= 20;
         this.showparent.addChild(ItemTip.instance);
      }
      
      public function hide() : void
      {
         this.needshow = false;
         if(Boolean(this.showparent) && this.showparent.contains(ItemTip.instance))
         {
            this.showparent.removeChild(ItemTip.instance);
         }
         this.showparent = null;
      }
   }
}

