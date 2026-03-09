package com.game.modules.view.chat
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class Ball extends Sprite
   {
      
      public function Ball()
      {
         super();
         var g:Graphics = this.graphics;
         g.beginFill(16711680);
         g.drawRect(-2,-2,6,6);
         g.endFill();
      }
   }
}

