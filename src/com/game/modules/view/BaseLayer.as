package com.game.modules.view
{
   import com.game.locators.GameData;
   import com.game.modules.control.task.util.TaskListItems;
   import com.game.modules.view.achieve.GetAchieve;
   import com.game.modules.view.task.DailyTask;
   import com.game.modules.view.task.TaskDialog;
   import com.game.util.CacheUtil;
   import com.game.util.GamePersonControl;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BaseLayer extends Sprite
   {
      
      private var speialUrlList:Array = ["HeavenFuruiBox.swf","perishEvilModule.swf"];
      
      public function BaseLayer()
      {
         super();
      }
      
      private function setDrageAble(value:Boolean, ui:DisplayObject) : void
      {
      }
      
      public function disPos() : void
      {
         this.clear();
      }
      
      public function showUI(display:DisplayObject, xCoord:int = 0, yCoord:int = 0, isDragable:Boolean = true) : void
      {
         if(!display)
         {
            return;
         }
         var hasDisplay:Boolean = this.contains(display);
         if(hasDisplay)
         {
            if("dispos" in display && display["dispos"] is Function)
            {
               display["dispos"]();
            }
            else if("unloadAndStop" in display && display["unloadAndStop"] is Function)
            {
               display["unloadAndStop"]();
            }
            else if("disport" in display && display["disport"] is Function)
            {
               display["disport"]();
            }
            else if(GameData.instance.playerData.isNewHand > 8)
            {
               this.removeChild(display);
            }
         }
         else
         {
            display.x = xCoord;
            display.y = yCoord;
            this.addChild(display);
         }
      }
      
      public function clear() : void
      {
         var num:int;
         var notClearCount:int;
         var i:int;
         var disPlay:DisplayObject = null;
         if(GamePersonControl.instance.isEnterTeamCopy())
         {
            return;
         }
         if(GameData.instance.playerData.isInWarCraft)
         {
            return;
         }
         if(GameData.instance.playerData.isInCrazyRecordRoom)
         {
            return;
         }
         if(GameData.instance.playerData.isInMazeIsland)
         {
            return;
         }
         if(GameData.instance.playerData.isNoClearModel)
         {
            return;
         }
         num = this.numChildren;
         if(num == 0)
         {
            return;
         }
         notClearCount = 0;
         for(i = 0; i < num; i++)
         {
            disPlay = this.getChildAt(0 + notClearCount);
            if(disPlay == null)
            {
               break;
            }
            if(this.contains(disPlay))
            {
               if(disPlay is GetAchieve)
               {
                  notClearCount++;
                  continue;
               }
               if(disPlay.hasOwnProperty("dispos"))
               {
                  disPlay["dispos"]();
               }
               else if(Boolean(disPlay.hasOwnProperty("unloadAndStop")) || Boolean(disPlay.hasOwnProperty("unload")))
               {
                  if(Boolean(Loader(disPlay).content) && Boolean(disPlay["content"].hasOwnProperty("disport")))
                  {
                     disPlay["content"]["disport"]();
                  }
                  try
                  {
                     if(disPlay.hasOwnProperty("unloadAndStop"))
                     {
                        disPlay["unloadAndStop"]();
                     }
                     else
                     {
                        disPlay["unload"]();
                     }
                     if(this.contains(disPlay))
                     {
                        this.removeChild(disPlay);
                     }
                  }
                  catch(e:*)
                  {
                     O.o(e);
                  }
               }
               else if(disPlay.hasOwnProperty("disport"))
               {
                  if(disPlay is DomainView && DomainView(disPlay).url && this.specialModule(disPlay))
                  {
                     notClearCount++;
                     continue;
                  }
                  if(!disPlay.hasEventListener(Event.REMOVED_FROM_STAGE))
                  {
                     CacheUtil.deleteObject(disPlay as Class);
                     disPlay["disport"]();
                  }
                  else
                  {
                     CacheUtil.deleteObject(disPlay as Class);
                     this.removeChild(disPlay);
                  }
               }
               else
               {
                  this.removeChild(disPlay);
               }
            }
            disPlay = null;
         }
         FaceView.clip.showBottom();
      }
      
      private function specialModule(disPlay:DisplayObject) : Boolean
      {
         var len:int = int(this.speialUrlList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(DomainView(disPlay).url.indexOf(this.speialUrlList[i]) != -1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function clearPopUpBox(dis:DisplayObject = null) : void
      {
         if(dis == null)
         {
            this.clear();
         }
         else if(this.contains(dis))
         {
            if(dis is TaskDialog)
            {
               TaskDialog(dis).dispos();
            }
            else if(dis is TaskListItems)
            {
               TaskListItems(dis).dispos();
            }
            else if(dis is DailyTask)
            {
               DailyTask(dis).dispos();
            }
            else
            {
               if(dis is Loader)
               {
                  Loader(dis).unloadAndStop();
               }
               this.removeChild(dis);
            }
         }
      }
      
      public function showExtraUI(disPlay:DisplayObject, xCoord:int = 0, yCoord:int = 0) : void
      {
         disPlay.x = xCoord;
         disPlay.y = yCoord;
         this.addChild(disPlay);
      }
      
      public function nonContainsThenAdd(dis:DisplayObject, xCoord:int = 0, yCoord:int = 0) : void
      {
         if(this.contains(dis))
         {
            return;
         }
         this.showUI(dis,xCoord,yCoord);
      }
      
      public function haveSame(value:String = "", remove:Boolean = false) : Boolean
      {
         var index:int = 0;
         var num:int = 0;
         var i:int = 0;
         var disPlay:DisplayObject = null;
         var rb:Boolean = false;
         if(Boolean(value) && value != "")
         {
            index = int(value.indexOf("?"));
            if(index != -1)
            {
               value = value.slice(0,index);
            }
            num = this.numChildren;
            for(i = 0; i < num; i++)
            {
               disPlay = this.getChildAt(i);
               if(Boolean(disPlay.hasOwnProperty("url")) && Boolean(String(disPlay["url"])))
               {
                  if(String(disPlay["url"]).indexOf(value) != -1)
                  {
                     if(!remove)
                     {
                        return true;
                     }
                     if(disPlay is DomainView)
                     {
                        this.removeChild(disPlay);
                        num--;
                        rb = false;
                     }
                  }
               }
            }
         }
         return rb;
      }
   }
}

