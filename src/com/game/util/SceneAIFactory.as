package com.game.util
{
   import com.game.modules.view.person.ClickAndGetNPC;
   import com.game.modules.view.person.NPCWithOutScene;
   import com.game.modules.view.person.SceneAIClick;
   import com.game.modules.view.person.SpecialArea;
   import com.game.modules.view.person.WalkableNPC;
   import com.game.modules.view.person.actAI.Act638AI;
   import com.game.modules.view.person.actAI.NPC14017;
   import com.game.modules.view.person.actAI.NPC161706;
   import com.game.modules.view.person.actAI.NPC211409;
   import com.game.modules.view.person.actAI.NPC22013;
   import com.game.modules.view.person.actAI.OrderClickNPC;
   import flash.utils.Dictionary;
   
   public class SceneAIFactory
   {
      
      public static var instance:SceneAIFactory = new SceneAIFactory();
      
      private var _aiDic:Dictionary;
      
      public function SceneAIFactory()
      {
         super();
         if(instance != null)
         {
            new Error("场景AI工厂已经实例化.....");
         }
      }
      
      public function produce(type:int, param:Object) : *
      {
         var ai:* = undefined;
         if(!this._aiDic)
         {
            this._aiDic = new Dictionary();
         }
         var sequenceID:int = int(param["sequenceID"]);
         switch(type)
         {
            case 4:
               ai = new DynamicBuild(param);
               break;
            case 7:
               ai = new ActionAI(param);
               break;
            case 8:
               ai = new SceneAIClick(param);
               break;
            case 9:
               ai = new SpecialArea(param);
               break;
            case 10:
               ai = new MouseCursorAI(param);
               break;
            case 11:
               ai = this._aiDic[sequenceID];
               if(ai && Boolean(ai.ui) && Boolean(ai.hasOwnProperty("dispos")))
               {
                  ai.dispos();
               }
               ai = new NPCWithOutScene(param);
               this._aiDic[param["sequenceID"]] = ai;
               break;
            case 12:
               ai = new ClickAndGetNPC(param);
               (ai as ClickAndGetNPC).load();
               break;
            case 13:
               ai = new WalkableNPC(param);
               break;
            case 15:
               ai = new Act638AI(param);
               break;
            case 16:
               ai = new NPC14017(param);
               break;
            case 17:
               ai = new NPC161706(param);
               break;
            case 18:
               ai = new OrderClickNPC(param);
               break;
            case 19:
               ai = new NPC22013(param);
               break;
            case 20:
               ai = new NPC211409(param);
         }
         return ai;
      }
   }
}

