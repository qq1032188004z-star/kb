package com.game.facade
{
   import com.core.manager.Facade;
   import com.game.modules.control.TemLeaveControl;
   import com.game.modules.model.ActivityModel;
   import com.game.modules.model.BattleModel;
   import com.game.modules.model.ChatModel;
   import com.game.modules.model.FamilyModel;
   import com.game.modules.model.FlashProxy;
   import com.game.modules.model.FriendModel;
   import com.game.modules.model.GameHallModel;
   import com.game.modules.model.MainModel;
   import com.game.modules.model.MapModel;
   import com.game.modules.model.PersonInfoModel;
   import com.game.modules.model.ShenShouModel;
   import com.game.modules.model.TaskModel;
   import com.game.modules.model.TeamModel;
   
   public class ApplicationFacade extends Facade
   {
      
      public function ApplicationFacade()
      {
         super();
      }
      
      public static function getInstance() : ApplicationFacade
      {
         if(instance == null)
         {
            instance = new ApplicationFacade();
         }
         return instance as ApplicationFacade;
      }
      
      override public function startUp() : void
      {
         super.startUp();
         registerModel(new MainModel());
         registerModel(new ChatModel());
         registerModel(new FriendModel());
         registerModel(new BattleModel());
         registerModel(new FlashProxy());
         registerModel(new TaskModel());
         registerModel(new MapModel());
         registerModel(new PersonInfoModel());
         registerModel(new ShenShouModel("shenshoumodel"));
         registerModel(new FamilyModel());
         registerModel(new GameHallModel());
         registerModel(new TeamModel());
         registerModel(new ActivityModel());
         registerViewLogic(new TemLeaveControl());
      }
   }
}

