package com.game.modules.view
{
   import com.game.facade.ApplicationFacade;
   import com.game.modules.control.FaceControl;
   import com.game.modules.view.chat.PublicChatPanel;
   import com.publiccomponent.loading.Hloader;
   import com.publiccomponent.ui.InterFaceUI;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class FaceView
   {
      
      private static var _hloader:Hloader;
      
      private static var _teamMc:Sprite;
      
      private static var _paperHorseLoader:Hloader;
      
      private static var _paperHorseMc:Sprite;
      
      private static var _clip:InterFaceUI = new InterFaceUI();
      
      public function FaceView()
      {
         super();
      }
      
      public static function get clip() : InterFaceUI
      {
         return _clip;
      }
      
      public static function set clip(value:InterFaceUI) : void
      {
         _clip = value;
      }
      
      public static function registerParent(parent:DisplayObjectContainer, xCoord:int, yCoord:int) : void
      {
         parent.addChild(_clip);
         _clip.visible = false;
         _clip.x = xCoord;
         _clip.y = yCoord;
         _clip.addEventListener(Event.COMPLETE,onComplement);
      }
      
      private static function onComplement(evt:Event) : void
      {
         _clip.removeEventListener(Event.COMPLETE,onComplement);
         ApplicationFacade.getInstance().registerViewLogic(new FaceControl(_clip));
         _clip.visible = false;
         _clip.chatClip = new PublicChatPanel();
         _clip.chatClip.y = 33;
         _clip.chatClip.x = 42;
         _clip.bottomClip.statePanel_mc.addChildAt(_clip.chatClip,_clip.bottomClip.statePanel_mc.numChildren);
      }
      
      private static function get hloader() : Hloader
      {
         if(_hloader == null)
         {
            _hloader = new Hloader();
            _hloader.addEventListener(Event.COMPLETE,onTeamCompleteHandler);
         }
         return _hloader;
      }
      
      private static function onTeamCompleteHandler(e:Event) : void
      {
         e.stopImmediatePropagation();
         if(_hloader != null && _hloader.content != null)
         {
            _teamMc = hloader.content as Sprite;
            _clip.addChild(_teamMc);
         }
      }
      
      public static function addTeamMessageView() : void
      {
         if(ApplicationFacade.getInstance().hasViewLogic("TeamMessageControl"))
         {
            return;
         }
         if(_hloader == null && _teamMc == null)
         {
            hloader.url = "assets/module/TeamMeesageView.swf";
         }
      }
      
      public static function remoeTeamMessageView() : void
      {
         if(Boolean(_teamMc))
         {
            if(Boolean(_teamMc.parent))
            {
               _teamMc.parent.removeChild(_teamMc);
            }
            if(_teamMc.hasOwnProperty("disport"))
            {
               _teamMc["disport"]();
            }
            _teamMc = null;
         }
         if(Boolean(_hloader))
         {
            _hloader.removeEventListener(Event.COMPLETE,onTeamCompleteHandler);
            _hloader.unloadAndStop(true);
            _hloader = null;
         }
      }
      
      public static function addPaperHorse() : void
      {
         if(ApplicationFacade.getInstance().hasViewLogic("paperHorse_main_control"))
         {
            return;
         }
         if(_paperHorseLoader == null && _teamMc == null)
         {
            paperHorseLoader.url = "assets/paperhorse/PaperHorse.swf";
         }
      }
      
      private static function get paperHorseLoader() : Hloader
      {
         if(_paperHorseLoader == null)
         {
            _paperHorseLoader = new Hloader();
            _paperHorseLoader.addEventListener(Event.COMPLETE,onPaperHorseCompleteHandler);
         }
         return _paperHorseLoader;
      }
      
      private static function onPaperHorseCompleteHandler(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         if(_paperHorseLoader != null && _paperHorseLoader.content != null)
         {
            _paperHorseMc = _paperHorseLoader.content as Sprite;
            _clip.addChild(_paperHorseMc);
            _paperHorseLoader.removeEventListener(Event.COMPLETE,onPaperHorseCompleteHandler);
            _paperHorseLoader.unloadAndStop(true);
            _paperHorseLoader = null;
         }
      }
      
      public static function removePaperHorse() : void
      {
         if(Boolean(_paperHorseMc))
         {
            if(Boolean(_paperHorseMc.parent))
            {
               _paperHorseMc.parent.removeChild(_teamMc);
            }
            if(_paperHorseMc.hasOwnProperty("disport"))
            {
               _paperHorseMc["disport"]();
            }
            _paperHorseMc = null;
         }
         if(Boolean(_paperHorseLoader))
         {
            _paperHorseLoader.removeEventListener(Event.COMPLETE,onPaperHorseCompleteHandler);
            _paperHorseLoader.unloadAndStop(true);
            _paperHorseLoader = null;
         }
      }
   }
}

