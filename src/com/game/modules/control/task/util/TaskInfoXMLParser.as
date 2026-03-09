package com.game.modules.control.task.util
{
   import com.game.locators.GameData;
   import com.game.modules.control.task.TaskList;
   import com.publiccomponent.loading.XMLLocator;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class TaskInfoXMLParser
   {
      
      public static var instance:TaskInfoXMLParser = new TaskInfoXMLParser();
      
      private var loader:URLLoader;
      
      private var newestXML:XML;
      
      public function TaskInfoXMLParser()
      {
         super();
         if(instance != null)
         {
            throw new Error("单例类TaskInfoXMLParser已经实例化了..");
         }
      }
      
      public function parse() : Array
      {
         var sublist:XMLList = null;
         var leng:int = 0;
         var task:Task = null;
         var xmllist:XMLList = XMLLocator.getInstance().taskInfo.child("task");
         var i:int = 0;
         var j:int = 0;
         var len:int = int(xmllist.length());
         var result:Array = [];
         for(i = 0; i < len; i++)
         {
            sublist = xmllist[i].children();
            leng = int(sublist.length());
            for(j = 0; j < leng; j++)
            {
               task = new Task();
               task.taskID = int(xmllist[i].@id);
               task.taskName = xmllist[i].@name;
               task.subtaskID = int(sublist[j].@id);
               task.taskDifficult = this.parseDiff(xmllist[i]);
               task.currentState = 0;
               task.off = int(xmllist[i].@off) == 1 ? true : false;
               result.push(task);
            }
         }
         return result;
      }
      
      public function parseCurrent(taskID:int, subtaskID:int) : Object
      {
         var subXML:XML;
         var xml:XML = null;
         var result:Object = null;
         xml = XMLLocator.getInstance().getTaskInfo(taskID);
         if(xml == null)
         {
            return null;
         }
         subXML = xml.children().(@id == subtaskID)[0] as XML;
         if(subXML == null)
         {
            return null;
         }
         result = {};
         result.taskId = taskID;
         result.taskName = xml.@name;
         result.subtaskId = subtaskID;
         result.subtaskName = subXML.@name;
         result.taskdiff = this.parseDiff(xml);
         return result;
      }
      
      public function parseNewest() : Array
      {
         var sublist:XMLList = null;
         var task:Object = null;
         if(!TaskList.getInstance().hasBeenComplete(1003003))
         {
            return [{
               "id":1003000,
               "taskname":"新手任务",
               "taskdiff":this.getDiffStr(3)
            }];
         }
         if(this.newestXML == null)
         {
            return null;
         }
         var xmllist:XMLList = this.newestXML.children();
         if(xmllist == null)
         {
            return null;
         }
         var i:int = 0;
         var len:int = int(xmllist.length());
         var result:Array = [];
         for(i = 0; i < len; i++)
         {
            task = {};
            task.id = int(xmllist[i].@id);
            task.taskname = xmllist[i].@name;
            task.taskdiff = this.parseDiff(xmllist[i]);
            result.push(task);
         }
         return result;
      }
      
      public function parseClassfy(index:int) : Array
      {
         var flag:int = 0;
         var task:Object = null;
         var afterID:int = 0;
         var beforeID:int = 0;
         var t_tid:int = 0;
         var xmllist:XMLList = XMLLocator.getInstance().taskInfo.child("task");
         var i:int = 0;
         var len:int = int(xmllist.length());
         var result:Array = [];
         for(i = 0; i < len; i++)
         {
            if(int(xmllist[i].@off) > 0)
            {
               if(!TaskList.getInstance().getSpecifiedAcceptTask(int(xmllist[i].@id)))
               {
                  continue;
               }
            }
            flag = int(xmllist[i].@id) / 1000000 >> 0;
            if(flag == index)
            {
               if(flag == 1 || flag == 7)
               {
                  t_tid = int(xmllist[i].@id);
                  if(TaskList.getInstance().getStateOfSpecifiedTask(t_tid) == 2)
                  {
                     continue;
                  }
               }
               afterID = int(xmllist[i].@after);
               beforeID = int(xmllist[i].@before);
               if(afterID != 0)
               {
                  if(!(afterID % 100 == 0 && afterID % 1000 == 1))
                  {
                     if(!this.canInputOrNot(false,afterID,xmllist[i]))
                     {
                        continue;
                     }
                  }
               }
               if(beforeID != 0 && beforeID % 100 != 0)
               {
                  if(!this.canInputOrNot(true,beforeID,xmllist[i]))
                  {
                     continue;
                  }
               }
               task = {};
               task.id = int(xmllist[i].@id);
               task.taskname = xmllist[i].@name.toString();
               task.taskdiff = this.parseDiff(xmllist[i]);
               result.push(task);
            }
         }
         return result;
      }
      
      public function canInputOrNot(before:Boolean, tmpid:int, listxml:XML) : Boolean
      {
         var afterTaskID:int = 0;
         var beforeTaskID:int = 0;
         var beforeLen:int = 0;
         var beforeI:int = 0;
         var beforeStr:String = null;
         var beforeTmpList:Array = null;
         var tmpList:Array = [];
         var tmpCount:int = 0;
         if(!before)
         {
            tmpList = this.getPrefixListByAfterID(tmpid,listxml);
            for each(afterTaskID in tmpList)
            {
               if(TaskList.getInstance().getStateOfSpecifiedTask(afterTaskID) != 2)
               {
                  tmpCount++;
               }
            }
         }
         else
         {
            switch(tmpid / 100 >> 0)
            {
               case 1:
                  tmpList.push(2000000 + tmpid % 100 * 1000);
                  break;
               case 2:
                  tmpList.push(3000000 + tmpid % 100 * 1000);
                  break;
               case 3:
                  tmpList.push(7000000 + tmpid % 100 * 1000);
                  break;
               case 4:
                  beforeLen = tmpid % 100;
                  beforeI = 0;
                  beforeStr = listxml.@list.toString();
                  beforeTmpList = beforeStr.split(",");
                  for(beforeI = 0; beforeI < beforeLen; beforeI++)
                  {
                     tmpList.push(int(beforeTmpList[beforeI]));
                  }
            }
            for each(beforeTaskID in tmpList)
            {
               if(TaskList.getInstance().getStateOfSpecifiedTask(beforeTaskID) != 0)
               {
                  tmpCount++;
               }
            }
         }
         if(tmpCount != 0)
         {
            return false;
         }
         return true;
      }
      
      public function distinguishCountry(list:Array) : Dictionary
      {
         var xml:XML = null;
         var countryID:int = 0;
         var i:int = 0;
         var len:int = int(list.length);
         var dic:Dictionary = new Dictionary();
         for(i = 0; i < len; i++)
         {
            xml = XMLLocator.getInstance().getTaskInfo(list[i].id);
            countryID = int((xml.children()[0] as XML).country);
            if(countryID != 1 && countryID != 110 && countryID != 150 && countryID != -1)
            {
               if(dic[countryID] == null)
               {
                  dic[countryID] = [];
               }
               (dic[countryID] as Array).push(list[i]);
            }
         }
         return dic;
      }
      
      public function parseDiff(xml:XML) : String
      {
         if(xml == null)
         {
            return "";
         }
         var len:int = int(xml.@diff);
         return this.getDiffStr(len);
      }
      
      private function getDiffStr(len:int) : String
      {
         var str:String = "";
         var j:int = 0;
         for(j = 0; j < len; j++)
         {
            str += "★";
         }
         return str;
      }
      
      public function loadNewest(url:String) : void
      {
         this.loader = new URLLoader();
         this.loader.dataFormat = URLLoaderDataFormat.TEXT;
         this.loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.load(new URLRequest(url));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         if(this.loader == null)
         {
            return;
         }
         this.newestXML = new XML(this.loader.data);
         this.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader = null;
      }
      
      public function parseAwardToString(taskID:int, subtaskID:int) : String
      {
         var xml:XML = this.getSubxml(taskID,subtaskID);
         if(xml == null)
         {
            return "";
         }
         var str:String = "";
         str += int(xml.award.exp) + "历练\t" + int(xml.award.coin) + "铜钱";
         if(int(xml.award.cultive) != 0)
         {
            str += int(xml.award.cultive) + "修为";
         }
         return str;
      }
      
      public function parseAwardCoin(taskID:int, subtaskID:int) : int
      {
         var xml:XML = this.getSubxml(taskID,subtaskID);
         if(xml == null)
         {
            return 0;
         }
         return int(xml.award.coin);
      }
      
      public function parseAwardExp(taskID:int, subtaskID:int) : int
      {
         var xml:XML = this.getSubxml(taskID,subtaskID);
         if(xml == null)
         {
            return 0;
         }
         return int(xml.award.exp);
      }
      
      public function parseAwardCultive(taskID:int, subtaskID:int) : int
      {
         var xml:XML = this.getSubxml(taskID,subtaskID);
         if(xml == null)
         {
            return 0;
         }
         return int(xml.award.cultive);
      }
      
      public function parseTargetScene(taskID:int, subtaskID:int) : int
      {
         var xml:XML = this.getSubxml(taskID,subtaskID);
         if(xml == null)
         {
            return 0;
         }
         return int(xml.targets.target);
      }
      
      private function getSubxml(taskID:int, subtaskID:int) : XML
      {
         var subxml:XML;
         var xml:XML = null;
         xml = XMLLocator.getInstance().getTaskInfo(taskID);
         if(xml == null)
         {
            return null;
         }
         subxml = xml.child("subtask").(@id == subtaskID)[0] as XML;
         if(subxml == null)
         {
            return null;
         }
         return subxml;
      }
      
      public function getTaskName(taskID:int) : String
      {
         var xml:XML = XMLLocator.getInstance().getTaskInfo(taskID);
         if(xml == null)
         {
            return "";
         }
         return xml.@name.toString();
      }
      
      public function getGoodsInTaskInfo(taskID:int, subtaskID:int) : Array
      {
         var obj:Object = null;
         var i:int = 0;
         var len:int = 0;
         var result:Array = [];
         var xml:XML = this.getSubxml(taskID,subtaskID);
         if(xml == null)
         {
            return result;
         }
         var goods:XML = xml.award.goods[0] as XML;
         if(goods == null)
         {
            return result;
         }
         var subxml:XML = xml.award.goods[0] as XML;
         if(subxml.children().length() > 0 && subxml.children()[0].@id != 0)
         {
            i = 0;
            len = int(subxml.children().length());
            for(i = 0; i < len; i++)
            {
               obj = {};
               obj.key = int(subxml.children()[i].@id);
               obj.number = int(subxml.children()[i].@number);
               obj.type = int(subxml.children()[i].@type);
               result.push(obj);
            }
         }
         return result;
      }
      
      public function getTaskInfoDescribe(taskID:int, subtaskID:int) : String
      {
         var str:String = "";
         var xml:XML = this.getSubxml(taskID,subtaskID);
         if(xml != null)
         {
            str = xml.describe.toString();
         }
         return str;
      }
      
      public function getTaskCanAcceptOrNot(taskID:int) : Boolean
      {
         var xml:XML = XMLLocator.getInstance().getTaskInfo(taskID);
         if(xml == null)
         {
            return false;
         }
         return this.canInputOrNot(false,int(xml.@after),xml);
      }
      
      public function getPrefixTask(taskID:int) : Task
      {
         var xml:XML = XMLLocator.getInstance().getTaskInfo(taskID);
         if(xml == null)
         {
            return null;
         }
         var prefix:int = int(xml.@after);
         var tmpList:Array = this.getPrefixListByAfterID(prefix,xml);
         if(tmpList == null || tmpList.length == 0)
         {
            return null;
         }
         var tid:int = int(tmpList[0]);
         return this.getTaskByTaskID(tid);
      }
      
      private function getTaskByTaskID(taskID:int) : Task
      {
         var xml:XML = XMLLocator.getInstance().getTaskInfo(taskID);
         if(xml == null)
         {
            return null;
         }
         var task:Task = new Task();
         task.taskID = taskID;
         task.taskName = xml.@name.toString();
         task.taskDifficult = this.parseDiff(xml);
         return task;
      }
      
      private function getPrefixListByAfterID(tmpid:int, listxml:XML) : Array
      {
         var afterlen:int = 0;
         var afterI:int = 0;
         var afterStr:String = null;
         var afterTmpList:Array = null;
         var tmpList:Array = [];
         var step:int = tmpid % 100;
         var subprefix:int = tmpid / 100 >> 0;
         if(subprefix > 10)
         {
            step += (subprefix - subprefix % 10) * 10;
         }
         if(step == 0)
         {
            return tmpList;
         }
         var type:int = subprefix % 10;
         switch(type)
         {
            case 1:
               tmpList.push(2000000 + step * 1000);
               break;
            case 2:
               tmpList.push(3000000 + step * 1000);
               break;
            case 3:
               tmpList.push(7000000 + step * 1000);
               break;
            case 4:
               afterlen = tmpid % 100;
               afterI = 0;
               afterStr = listxml.@list.toString();
               afterTmpList = afterStr.split(",");
               for(afterI = 0; afterI < afterlen; afterI++)
               {
                  tmpList.push(int(afterTmpList[afterI]));
               }
         }
         return tmpList;
      }
      
      public function getTalkMsgBySequenceID(sid:int) : XML
      {
         var i:int = 0;
         var len:int = 0;
         var time:Number = NaN;
         var subxml:XML = null;
         var readable:Boolean = false;
         var startTime:Number = NaN;
         var endTime:Number = NaN;
         var tempXML:XML = XMLLocator.getInstance().getNPCDialogDic(sid);
         if(tempXML != null)
         {
            if(tempXML != null)
            {
               i = 0;
               len = int(tempXML.child("node").length());
               time = GameData.instance.playerData.systemTimes;
               readable = false;
               startTime = 0;
               endTime = 0;
               for(i = 0; i < len; i++)
               {
                  subxml = tempXML.child("node")[i] as XML;
                  startTime = this.parseStringToNumber(subxml.@start_time);
                  endTime = this.parseStringToNumber(subxml.@end_time);
                  if(startTime != 0 && endTime != 0)
                  {
                     if(startTime <= time && endTime > time)
                     {
                        readable = true;
                        return subxml;
                     }
                  }
               }
               if(!readable)
               {
                  subxml = tempXML.child("node").(@start_time == 0)[0] as XML;
                  return subxml;
               }
            }
         }
         return null;
      }
      
      private function parseStringToNumber(str:String) : Number
      {
         try
         {
            return Number(str);
         }
         catch(e:*)
         {
            return 0;
         }
      }
      
      public function getAllBrenchAward(taskID:int) : Object
      {
         var xml:XML = XMLLocator.getInstance().getTaskInfo(taskID);
         if(xml == null)
         {
            return null;
         }
         var sublist:XMLList = xml.children();
         var len:int = int(sublist.length());
         var i:int = 0;
         var obj:Object = {};
         var coin:int = 0;
         var exp:int = 0;
         var cultive:int = 0;
         for(i = 0; i < len; i++)
         {
            coin += int(sublist[i].award.coin);
            exp += int(sublist[i].award.exp);
            cultive += int(sublist[i].award.cultive);
         }
         obj.coin = coin;
         obj.exp = exp;
         obj.cultive = cultive;
         return obj;
      }
   }
}

