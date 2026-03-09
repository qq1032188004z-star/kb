package com.game.modules.archives.base
{
   import flash.display.Loader;
   import flash.display.Sprite;
   
   public class ArchivesContainerBase extends Sprite
   {
      
      public function ArchivesContainerBase()
      {
         super();
      }
      
      public function disport() : void
      {
         if(Boolean(parent))
         {
            if(parent is Loader)
            {
               (parent as Loader).unloadAndStop();
            }
            else
            {
               parent.removeChild(this);
            }
         }
      }
   }
}

