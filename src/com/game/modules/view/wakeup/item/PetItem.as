package com.game.modules.view.wakeup.item
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.list.ItemRender;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol425")]
   public class PetItem extends ItemRender
   {
      
      public var spiritname:TextField;
      
      public var spiritlevel:TextField;
      
      public var hpTxt:TextField;
      
      public var spirithp:MovieClip;
      
      public var touxiang:MovieClip;
      
      public var bg:MovieClip;
      
      public var index:int;
      
      private var loader:Loader;
      
      public function PetItem()
      {
         super();
         this.loader = new Loader();
      }
      
      override public function set data(params:Object) : void
      {
         var temp:int = 0;
         if(params.id != 0)
         {
            this.bg.gotoAndStop(1);
            this.spiritname.text = params.name;
            this.spiritlevel.text = "Lv." + params.level;
            this.hpTxt.text = params.hp + "/" + params.strength;
            temp = params.hp / params.strength * 100 >> 0;
            this.spirithp.gotoAndStop(temp);
            this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterimg/" + params.iid + ".swf")));
            this.loader.scaleX = 1.5;
            this.loader.scaleY = 1.5;
            this.touxiang.container.addChild(this.loader);
            this.buttonMode = true;
            super.data = params;
         }
         else
         {
            this["gotoAndStop"](2);
         }
      }
      
      public function clearLoader() : void
      {
         this.loader.unloadAndStop();
         this.touxiang.removeChildAt(0);
         this.loader = null;
      }
   }
}

