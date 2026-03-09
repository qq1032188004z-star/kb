package com.game.modules.action
{
   import com.game.manager.AiManager;
   import com.game.util.IdName;
   import flash.geom.Point;
   import org.engine.core.GameSprite;
   
   public class SpecialAreaAction
   {
      
      public static var instance:SpecialAreaAction = new SpecialAreaAction();
      
      private var specialID:int = 0;
      
      private var hasSendMsg:Boolean;
      
      public function SpecialAreaAction()
      {
         super();
      }
      
      public function checkPosition(gameSprite:GameSprite) : void
      {
         var canSendMsg:Boolean = false;
         var name:String = null;
         var i:int = 0;
         if(gameSprite.ui.parent == null)
         {
            return;
         }
         var displayArr:Array = gameSprite.ui.parent.getObjectsUnderPoint(new Point(gameSprite.x,gameSprite.y));
         var l:int = int(displayArr.length);
         if(l < 1)
         {
            if(this.specialID != 0)
            {
               AiManager.instance().masterIsOutSpecialArea(this.specialID);
            }
            this.specialID = 0;
            this.hasSendMsg = false;
         }
         else
         {
            for(canSendMsg = false; i < l; )
            {
               if(Boolean(displayArr[i].parent) && Boolean(AiManager.instance().hasOwnProperty(IdName.name(displayArr[i].parent.name) + "Handler")))
               {
                  canSendMsg = true;
                  name = displayArr[i].parent.name;
               }
               else if(Boolean(displayArr[i].parent) && Boolean(displayArr[i].parent.parent))
               {
                  if(AiManager.instance().hasOwnProperty(IdName.name(displayArr[i].parent.parent.name) + "Handler"))
                  {
                     canSendMsg = true;
                     name = displayArr[i].parent.parent.name;
                  }
               }
               i++;
            }
            if(canSendMsg)
            {
               if(!this.hasSendMsg && Boolean(AiManager.instance().hasOwnProperty(IdName.name(name) + "Handler")))
               {
                  AiManager.instance()[IdName.name(name) + "Handler"].apply(null,[name]);
                  this.specialID = IdName.id(name);
                  this.hasSendMsg = true;
               }
            }
            else if(this.hasSendMsg)
            {
               if(this.specialID != 0)
               {
                  AiManager.instance().masterIsOutSpecialArea(this.specialID);
               }
               this.specialID = 0;
               this.hasSendMsg = false;
            }
         }
      }
   }
}

