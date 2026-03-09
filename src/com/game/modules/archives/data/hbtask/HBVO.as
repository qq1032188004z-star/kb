package com.game.modules.archives.data.hbtask
{
   import com.publiccomponent.loading.XMLLocator;
   
   public class HBVO
   {
      
      public var taskType:int;
      
      public var acceptCount:int;
      
      public var completeCount:int;
      
      public var difficultLevel:int;
      
      public var taskIndex:int;
      
      public var awardLevel:int;
      
      public var progress:int;
      
      public var targetID:int;
      
      public var targetNum:int;
      
      public var content:String;
      
      public var targetSceneID:int;
      
      public var isAccepted:Boolean = false;
      
      private var PRE_OF_TYPE_1:String = "收集物品：";
      
      private var PRE_OF_TYPE_2:String = "消灭妖怪：";
      
      private var PRE_OF_TYPE_3:String = "击败大王：";
      
      private var PRE_OF_TYPE_4:String = "秘境闯关：";
      
      private var PRE_OF_TYPE_5:String = "战场试炼：";
      
      public function HBVO()
      {
         super();
      }
      
      public function deserialize() : void
      {
         if(this.taskType == 0 || this.targetID == 0)
         {
            trace("出错咯....");
            return;
         }
         var tmpProgress:int = 0;
         if(this.progress > this.targetNum)
         {
            tmpProgress = this.targetNum;
         }
         else
         {
            tmpProgress = this.progress;
         }
         this.content = this.addPreStr(this.taskType,this.targetID) + "( " + tmpProgress + "/" + this.targetNum + " )\n";
      }
      
      private function addPreStr(type:int, id:int) : String
      {
         var tmpxml:XML = null;
         var tmpArr:Array = null;
         var str:String = "";
         var nameStr:String = "";
         switch(type)
         {
            case 1:
               str += this.PRE_OF_TYPE_1;
               tmpxml = XMLLocator.getInstance().getTool(id);
               nameStr = tmpxml.name.toString();
               break;
            case 2:
               str += this.PRE_OF_TYPE_2;
               tmpxml = XMLLocator.getInstance().getSprited(id);
               nameStr = tmpxml.name.toString();
               break;
            case 3:
               str += this.PRE_OF_TYPE_3;
               tmpxml = XMLLocator.getInstance().getSprited(id);
               nameStr = tmpxml.name.toString();
               break;
            case 4:
               str += this.PRE_OF_TYPE_4;
               tmpArr = ["万妖洞第二十五层","双台谷第二层","万妖洞第三十层","双台谷第五层"];
               nameStr = tmpArr[id - 1];
               break;
            case 5:
               str += this.PRE_OF_TYPE_5;
               tmpArr = ["苍炼岛战场胜利","藏龙渊战场胜利"];
               nameStr = tmpArr[id - 1];
         }
         return str + nameStr;
      }
   }
}

