package com.game.modules.archives.data
{
   import com.game.locators.GameData;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.control.task.util.Task;
   import com.game.modules.control.task.util.TaskInfoXMLParser;
   import com.game.util.PropertyPool;
   import com.publiccomponent.loading.XMLLocator;
   import flash.utils.Dictionary;
   
   public class SortedTaskList
   {
      
      public static var taskClipData:TaskClipData;
      
      private static var _instance:SortedTaskList;
      
      private static var taskDic:Dictionary;
      
      public var _oldReplaceThemeId:int;
      
      public var newThemeID:int;
      
      public var newTaskFlag:int = 0;
      
      private var _themeList:XML;
      
      private var _themeback:Function;
      
      private var themeIndex:int;
      
      public function SortedTaskList()
      {
         super();
         if(_instance != null)
         {
            throw new Error("任务列表类是单例类,他已经实例化了.");
         }
         taskDic = new Dictionary(true);
         taskClipData = new TaskClipData();
      }
      
      public static function get instance() : SortedTaskList
      {
         if(_instance == null)
         {
            _instance = new SortedTaskList();
         }
         return _instance;
      }
      
      public static function disport() : void
      {
         var key:String = null;
         for(key in taskDic)
         {
            taskDic[key] = null;
            delete taskDic[key];
         }
         taskDic = null;
         taskClipData = null;
         if(Boolean(_instance))
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function getThemeList(callback:Function = null) : void
      {
         this._themeback = callback;
         PropertyPool.instance.getXML("config/","tasktheme",this.onLoadPropertyBack);
      }
      
      private function onLoadPropertyBack(xml:XML) : void
      {
         this._themeList = xml;
         if(this._themeback != null)
         {
            this._themeback();
         }
         this._themeback = null;
      }
      
      public function set oldReplaceThemeId(value:int) : void
      {
         this._oldReplaceThemeId = value;
      }
      
      public function get oldReplaceThemeId() : int
      {
         return this._oldReplaceThemeId;
      }
      
      private function destroy() : void
      {
         this._themeback = null;
         this._themeList = null;
      }
      
      public function getTaskListByKey(key:String) : Array
      {
         return taskDic[key];
      }
      
      public function pushTaskInToMap(type:String, obj:Object) : void
      {
         var task:ArchivesItemData = null;
         if(taskDic[type] == null)
         {
            taskDic[type] = [];
         }
         if(taskDic != null)
         {
            if(type == ArchivesConst.COMPLETED_THEME_TASK)
            {
               task = this.getThemeItemInfo(obj);
            }
            else if(type == ArchivesConst.REPLACE_THEME_TASK)
            {
               task = this.getReplaceThemeItemInfo(obj);
            }
            else
            {
               task = this.getArchivesItemDataByTaskID(obj);
            }
            (taskDic[type] as Array).push(task);
         }
      }
      
      private function pushTaskIntoPageMap(type:String, task:ArchivesItemData) : void
      {
         if(taskDic[type] == null)
         {
            taskDic[type] = [];
         }
         if(taskDic != null)
         {
            (taskDic[type] as Array).push(task);
         }
      }
      
      public function getPrefixTask(taskID:int) : ArchivesItemData
      {
         var task:Task = TaskInfoXMLParser.instance.getPrefixTask(taskID);
         if(task == null)
         {
            return null;
         }
         var item:ArchivesItemData = new ArchivesItemData();
         item.taskID = task.taskID;
         item.taskName = task.taskName;
         item.taskDiff = task.taskDifficult;
         return item;
      }
      
      private function initUnkonwTask() : ArchivesItemData
      {
         var task:ArchivesItemData = new ArchivesItemData();
         task.taskID = 0;
         task.taskName = "未知任务";
         task.themeID = 1001;
         return task;
      }
      
      public function getArchivesItemDataByTaskID(obj:Object) : ArchivesItemData
      {
         var xml:XML = XMLLocator.getInstance().getTaskInfo(obj.taskID);
         if(xml == null)
         {
            return this.initUnkonwTask();
         }
         var taskid:int = int(xml.@id);
         var task:ArchivesItemData = new ArchivesItemData();
         task.taskID = taskid;
         task.taskName = xml.@name.toString();
         task.themeID = obj.themeID;
         if(Boolean(obj.isNewTask))
         {
            task.isNew = obj.isNewTask;
         }
         else
         {
            task.isNew = 0;
         }
         if(task.taskID == 6007000)
         {
            task.taskStatus = GameData.instance.playerData["taskArchivesVersionInfo"].valueobject.specialTaskState;
         }
         else
         {
            task.taskStatus = TaskList.getInstance().getStateOfSpecifiedTask(task.taskID);
         }
         if(task.taskID == 4006000 || task.taskID == 4014000)
         {
            task.taskTime = obj.taskTime;
         }
         if(task.taskID == 4014000)
         {
            if(task.taskTime == 0)
            {
               task.taskStatus = 0;
            }
            else if(task.taskTime > 0 && task.taskTime <= 10)
            {
               task.taskStatus = 1;
            }
            else
            {
               task.taskStatus = 2;
            }
         }
         return task;
      }
      
      public function getThemeItemInfo(obj:Object) : ArchivesItemData
      {
         var subxml:XML = null;
         var taskid:int = 0;
         var task:ArchivesItemData = null;
         if(this._themeList == null)
         {
            return null;
         }
         subxml = this._themeList.children().(@id == obj.themeID)[0] as XML;
         if(subxml == null)
         {
            return null;
         }
         taskid = int(subxml.@id);
         task = new ArchivesItemData();
         task.taskID = taskid;
         task.taskName = String(subxml.@name);
         task.taskStatus = 2;
         task.themeID = obj.themeID;
         task.taskType = obj.themeID;
         return task;
      }
      
      public function getReplaceThemeItemInfo(obj:Object) : ArchivesItemData
      {
         var subxml:XML = null;
         var taskid:int = 0;
         var task:ArchivesItemData = null;
         if(this._themeList == null)
         {
            return null;
         }
         subxml = this._themeList.children().(@id == obj.themeID)[0] as XML;
         if(subxml == null)
         {
            return null;
         }
         taskid = int(subxml.@id);
         task = new ArchivesItemData();
         task.taskID = taskid;
         task.taskName = String(subxml.@name);
         task.themeID = obj.themeID;
         task.taskType = obj.themeID;
         task.childList = this.getSubtaskByThemeID(task.themeID);
         return task;
      }
      
      public function getTaskByThemeName(value:int) : String
      {
         var subxml:XML = null;
         var tmpStr:String = null;
         if(this._themeList == null)
         {
            return "未知主题";
         }
         subxml = this._themeList.children().(@id == value)[0] as XML;
         if(subxml == null)
         {
            return "未知主题";
         }
         tmpStr = String(subxml.@name);
         if(tmpStr == null)
         {
            tmpStr = String(value);
         }
         return tmpStr;
      }
      
      public function getSubtaskByThemeID(value:int) : Array
      {
         var subxml:XML;
         var obj:Array = null;
         var node:XML = null;
         var task:ArchivesItemData = null;
         if(this._themeList == null)
         {
            return null;
         }
         subxml = this._themeList.children().(@id == value)[0] as XML;
         if(subxml == null)
         {
            return null;
         }
         obj = [];
         for each(node in subxml.children())
         {
            task = new ArchivesItemData();
            task.taskID = node.@id;
            task.taskName = node.@name;
            task.themeID = value;
            task.taskType = value;
            obj.push(task);
         }
         return obj;
      }
      
      public function getTaskByThemeState(value:int) : int
      {
         var tmpState:int = 0;
         var task:ArchivesItemData = null;
         for each(task in taskDic[ArchivesConst.COMPLETED_THEME_TASK])
         {
            if(value == task.taskID)
            {
               tmpState = 2;
            }
         }
         return tmpState;
      }
      
      public function makeRootNodes(page:int) : void
      {
         switch(page)
         {
            case 1:
               this.makePage1RootNodes();
               break;
            case 2:
               this.makePage2RootNodes();
               break;
            case 3:
               this.makePage3RootNodes();
         }
      }
      
      private function makePage1RootNodes() : void
      {
         var task:ArchivesItemData = null;
         var valueList:Array = null;
         var obj:Object = null;
         taskDic[ArchivesConst.ARCHIVES_PAGE1] = null;
         var i:int = 0;
         for(i = 1; i < 6; i++)
         {
            task = new ArchivesItemData();
            task.taskType = ArchivesConst.ITEM_PAGE1 + i;
            switch(i)
            {
               case 1:
                  valueList = taskDic[ArchivesConst.NEWHAND_TASK];
                  task.childList = taskDic[ArchivesConst.NEWHAND_TASK];
                  break;
               case 2:
                  valueList = taskDic[ArchivesConst.CURRENT_MAIN_TASK];
                  task.childList = taskDic[ArchivesConst.CURRENT_MAIN_TASK];
                  break;
               case 3:
                  valueList = taskDic[ArchivesConst.CURRENT_BRANCH_TASK];
                  if(valueList != null && valueList.length > 0)
                  {
                     obj = valueList[0];
                     task.taskType = obj.themeID;
                  }
                  task.childList = taskDic[ArchivesConst.CURRENT_BRANCH_TASK];
                  break;
               case 4:
                  valueList = taskDic[ArchivesConst.DAILY_RUN_TASK];
                  task.childList = taskDic[ArchivesConst.DAILY_RUN_TASK];
                  break;
               case 5:
                  valueList = taskDic[ArchivesConst.MONSTER_SPECIALFORCE_TASK];
                  task.childList = taskDic[ArchivesConst.MONSTER_SPECIALFORCE_TASK];
            }
            if(task.childList == null)
            {
               task = null;
            }
            this.pushTaskIntoPageMap(ArchivesConst.ARCHIVES_PAGE1,task);
         }
      }
      
      private function makePage2RootNodes() : void
      {
         var task:ArchivesItemData = null;
         taskDic[ArchivesConst.ARCHIVES_PAGE2] = null;
         var i:int = 0;
         var valueList:Array = [];
         var obj:Object = {};
         for(i = 1; i < 4; i++)
         {
            task = new ArchivesItemData();
            switch(i)
            {
               case 1:
                  valueList = taskDic[ArchivesConst.CURRENT_THEME_TASK1];
                  if(valueList != null && valueList.length > 0)
                  {
                     obj = valueList[0];
                     task.taskType = obj.themeID;
                     task.themeID = obj.themeID;
                  }
                  task.childList = taskDic[ArchivesConst.CURRENT_THEME_TASK1];
                  break;
               case 2:
                  valueList = taskDic[ArchivesConst.CURRENT_THEME_TASK2];
                  if(valueList != null && valueList.length > 0)
                  {
                     obj = valueList[0];
                     task.taskType = obj.themeID;
                     task.themeID = obj.themeID;
                  }
                  task.childList = taskDic[ArchivesConst.CURRENT_THEME_TASK2];
                  break;
               case 3:
                  valueList = taskDic[ArchivesConst.CURRENT_THEME_TASK3];
                  if(valueList != null && valueList.length > 0)
                  {
                     obj = valueList[0];
                     task.taskType = obj.themeID;
                     task.themeID = obj.themeID;
                  }
                  task.childList = taskDic[ArchivesConst.CURRENT_THEME_TASK3];
            }
            if(task.childList == null)
            {
               task = null;
            }
            this.pushTaskIntoPageMap(ArchivesConst.ARCHIVES_PAGE2,task);
         }
      }
      
      private function makePage3RootNodes() : void
      {
         var task:ArchivesItemData = null;
         taskDic[ArchivesConst.ARCHIVES_PAGE3] = null;
         var i:int = 0;
         for(i = 1; i < 3; i++)
         {
            task = new ArchivesItemData();
            task.taskType = ArchivesConst.ITEM_PAGE3 + i;
            switch(i)
            {
               case 1:
                  task.childList = taskDic[ArchivesConst.COMPLETED_MAIN_TASK];
                  break;
               case 2:
                  task.childList = taskDic[ArchivesConst.COMPLETED_THEME_TASK];
            }
            this.pushTaskIntoPageMap(ArchivesConst.ARCHIVES_PAGE3,task);
         }
      }
      
      public function replaceTaskByKeyAndThemeID(type:String, oldTheme:int, newTheme:int) : void
      {
         this.clearSpecialType(ArchivesConst.ARCHIVES_PAGE2,oldTheme,newTheme);
         this.clearTaskDicTypeList(ArchivesConst.CURRENT_THEME_TASK + (this.themeIndex + 1));
         this.replaceTheme(newTheme);
         this.clearSpecialType(ArchivesConst.REPLACE_THEME_TASK,newTheme,oldTheme);
      }
      
      private function clearSpecialType(type:String, oldTheme:int, newTheme:int) : void
      {
         var replaceIndex:int = 0;
         var key:String = null;
         var len:int = 0;
         var list:Array = null;
         var i:int = 0;
         var TopicTask:Object = null;
         for(key in taskDic)
         {
            if(key == type)
            {
               len = int(taskDic[key].length);
               list = taskDic[key];
               for(i = 0; i < len; i++)
               {
                  if(taskDic[key][i].themeID == oldTheme)
                  {
                     if(key == ArchivesConst.ARCHIVES_PAGE2)
                     {
                        this.themeIndex = i;
                     }
                     else
                     {
                        replaceIndex = i;
                     }
                     taskDic[key][i] = null;
                     delete taskDic[key][i];
                  }
               }
               if(key == ArchivesConst.ARCHIVES_PAGE2)
               {
                  (taskDic[ArchivesConst.ARCHIVES_PAGE2] as Array).splice(this.themeIndex,1);
               }
               else
               {
                  (taskDic[ArchivesConst.REPLACE_THEME_TASK] as Array).splice(replaceIndex,1);
                  TopicTask = {};
                  TopicTask.themeID = newTheme;
                  this.pushTaskInToMap(ArchivesConst.REPLACE_THEME_TASK,TopicTask);
               }
            }
         }
      }
      
      public function replaceTheme(themeId:int) : void
      {
         var curThemeTask:Object = null;
         var list:Array = null;
         var len1:int = 0;
         var j:int = 0;
         var len:int = int(taskDic[ArchivesConst.REPLACE_THEME_TASK].length);
         var key:String = ArchivesConst.CURRENT_THEME_TASK + (this.themeIndex + 1);
         for(var i:int = 0; i < len; i++)
         {
            if(taskDic[ArchivesConst.REPLACE_THEME_TASK][i].themeID == themeId)
            {
               list = taskDic[ArchivesConst.REPLACE_THEME_TASK][i].childList;
               len1 = int(list.length);
               for(j = 0; j < len1; j++)
               {
                  curThemeTask = {};
                  curThemeTask.themeID = themeId;
                  curThemeTask.subtaskID = list[j].taskID;
                  curThemeTask.taskID = curThemeTask.subtaskID - curThemeTask.subtaskID % 1000;
                  curThemeTask.taskProcess = 0;
                  curThemeTask.taskType = 6;
                  SortedTaskList.instance.pushTaskInToMap(key,curThemeTask);
               }
            }
         }
         this.resetPage2RootNodes();
      }
      
      private function resetPage2RootNodes() : void
      {
         var task:ArchivesItemData = null;
         var i:int = 0;
         var valueList:Array = [];
         var obj:Object = {};
         task = new ArchivesItemData();
         var list2:Array = taskDic[ArchivesConst.ARCHIVES_PAGE2];
         var key:String = ArchivesConst.CURRENT_THEME_TASK + (this.themeIndex + 1);
         valueList = taskDic[key];
         if(valueList != null && valueList.length > 0)
         {
            obj = valueList[0];
            task.taskType = obj.themeID;
            task.themeID = obj.themeID;
         }
         task.childList = taskDic[key];
         if(task.childList == null)
         {
            task = null;
         }
         (taskDic[ArchivesConst.ARCHIVES_PAGE2] as Array).splice(this.themeIndex,0,task);
         var list:Array = taskDic[ArchivesConst.ARCHIVES_PAGE2];
      }
      
      public function clearTaskDicTypeList(key:String) : void
      {
         var list:Array = null;
         var len:int = 0;
         var i:int = 0;
         if(Boolean(taskDic[key]))
         {
            list = taskDic[key];
            len = int(list.length);
            for(i = 0; i < len; i++)
            {
               taskDic[key][i] = null;
               delete taskDic[key][i];
            }
         }
         taskDic[key].length = 0;
      }
   }
}

