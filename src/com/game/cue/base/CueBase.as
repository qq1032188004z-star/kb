package com.game.cue.base
{
   import com.game.cue.intf.ICueBase;
   import com.game.util.BaseModuleView;
   import flash.display.DisplayObjectContainer;
   
   public class CueBase extends BaseModuleView implements ICueBase
   {
      
      private var _container:DisplayObjectContainer;
      
      private var _isVisible:Boolean = true;
      
      private var _url:String;
      
      private var _params:Object;
      
      public function CueBase()
      {
         super();
         this.graphics.beginFill(0,0.2);
         this.graphics.drawRect(0,0,970,570);
         this.graphics.endFill();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.visible = this._isVisible;
      }
      
      public function get container() : DisplayObjectContainer
      {
         return this._container;
      }
      
      protected function reset() : void
      {
      }
      
      public function set container($value:DisplayObjectContainer) : void
      {
         this._container = $value;
         this.visible = this._isVisible;
      }
      
      override public function set visible($value:Boolean) : void
      {
         this._isVisible = $value;
         if(this._isVisible)
         {
            this.show();
         }
         else
         {
            this.hide();
         }
      }
      
      protected function hide() : void
      {
         if(Boolean(this.container) && this.container.contains(this))
         {
            this.container.removeChild(this);
         }
      }
      
      protected function show() : void
      {
         if(Boolean(this.container) && !this.container.contains(this))
         {
            this.container.addChild(this);
         }
      }
      
      override public function get visible() : Boolean
      {
         return this._isVisible;
      }
      
      public function build($url:String, $container:DisplayObjectContainer = null, $params:Object = null) : void
      {
         this._url = $url;
         this._params = $params;
         this._container = $container;
         setURL($url);
      }
      
      public function get params() : Object
      {
         return this._params;
      }
      
      public function set params($value:Object) : void
      {
         this._params = $value;
         this.reset();
      }
      
      override public function disport() : void
      {
         this.graphics.clear();
         this._params = null;
         super.disport();
      }
   }
}

