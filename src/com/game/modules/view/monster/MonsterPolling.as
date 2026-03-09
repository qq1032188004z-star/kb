package com.game.modules.view.monster
{
   import com.game.locators.GameData;
   import com.game.modules.view.MapView;
   import com.game.modules.view.battle.AIMonster;
   import com.game.util.IdName;
   import org.engine.frame.FrameTimer;
   
   public class MonsterPolling
   {
      
      public static var instance:MonsterPolling = new MonsterPolling();
      
      private var countryList:Array = [3001,4001,5002,6001,7002,9001,10001,19001,21001];
      
      private var xyCoord:Array = [[269,371,463,340],[472,424,242,378],[242,378,534,381],[636,278,522,406],[720,454,257,443],[567,401,329,385],[497,343,250,470],[497,343,250,470],[795,399,600,470]];
      
      private var currentIndex:int;
      
      private var countryLen:int;
      
      private var aiMonster:AIMonster;
      
      private var count:int;
      
      public function MonsterPolling()
      {
         super();
         this.countryLen = this.countryList.length - 1;
         FrameTimer.getInstance().addCallBack(this.timeUp);
      }
      
      private function timeUp() : void
      {
         ++this.count;
         if(this.count >= 105)
         {
            this.count = 0;
            if(this.currentIndex < this.countryLen)
            {
               ++this.currentIndex;
            }
            else
            {
               this.currentIndex = 0;
            }
            if(Boolean(this.aiMonster))
            {
               this.aiMonster.dispos();
               this.aiMonster = null;
            }
            if(this.countryList[this.currentIndex] == GameData.instance.playerData.sceneId)
            {
               FrameTimer.getInstance().removeCallBack(this.timeUp);
               if(Math.random() > 0.5)
               {
                  this.createAiMonster(100,[9,10,8],"小翼犬",1);
               }
               else
               {
                  this.createAiMonster(1234,[3,4,5],"喵喵",1);
               }
            }
         }
      }
      
      public function check() : void
      {
         if(this.countryList[this.currentIndex] == GameData.instance.playerData.sceneId)
         {
            FrameTimer.getInstance().removeCallBack(this.timeUp);
            if(Math.random() > 0.5)
            {
               this.createAiMonster(100,[9,10,8],"小翼犬",1);
            }
            else
            {
               this.createAiMonster(1234,[3,4,5],"喵喵",1);
            }
            if(this.currentIndex < this.countryLen)
            {
               ++this.currentIndex;
            }
            else
            {
               this.currentIndex = 0;
            }
         }
      }
      
      private function createAiMonster(spriteId:int, levelList:Array, spriteName:String, monsterType:int) : void
      {
         var obj2:Object = new Object();
         obj2.placeList = this.xyCoord[this.currentIndex];
         obj2.monsterId = spriteId;
         obj2.monsterType = monsterType;
         obj2.levelList = levelList;
         obj2.monsterLevel = int(obj2.levelList[int(Math.random() * 3)]);
         obj2.iscontinuemove = 0;
         obj2.sid = this.combine1(int(obj2.monsterType),0,int(obj2.monsterId),int(obj2.monsterLevel));
         obj2.monsterName = IdName.monster(Math.random() * 10 + Math.random() * 100 + Math.random() * 1000);
         obj2.labelName = spriteName;
         obj2.isCopySence = false;
         obj2.israte = 1;
         obj2.count = 1;
         this.aiMonster = new AIMonster(obj2);
         this.aiMonster.name = IdName.monster(obj2.monsterId);
         MapView.instance.addGameSprite(this.aiMonster);
         this.count = 0;
         FrameTimer.getInstance().addCallBack(this.timeUp);
      }
      
      public function disposAiMonster() : void
      {
         if(Boolean(this.aiMonster))
         {
            this.aiMonster.dispos();
            this.aiMonster = null;
         }
      }
      
      private function combine1(type:int, val:int, spiritid:int, level:int) : int
      {
         return int(type << 28 & 0xF0000000) | val << 22 & 0x0FB00000 | spiritid << 8 & 0x3FFF00 | level;
      }
   }
}

