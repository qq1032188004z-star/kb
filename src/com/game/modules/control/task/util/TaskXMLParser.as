package com.game.modules.control.task.util
{
   import com.game.locators.GameData;
   import com.game.util.PropertyPool;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.XMLLocator;
   
   public class TaskXMLParser
   {
      
      private static var instance:TaskXMLParser;
      
      private static var baseNumOfDialog:int = 100000000;
      
      private static var goodsRegExp:RegExp = /zhuangbei/g;
      
      private var _toGetXML:Function;
      
      public function TaskXMLParser()
      {
         super();
         if(instance != null)
         {
            throw new Error("任务解析单例类已经实例化了...");
         }
      }
      
      public static function getInstance() : TaskXMLParser
      {
         if(instance == null)
         {
            instance = new TaskXMLParser();
         }
         return instance;
      }
      
      public function parseXML(xml:XML, subtaskID:int = 0, taskID:int = 0, dialogID:int = 0, ... rest) : *
      {
         var i:int;
         var task:Task;
         var len:int = 0;
         var alert:Object = null;
         var imgUrl:String = null;
         var normalDesc:Object = null;
         var battle:Object = null;
         var flaArr:Array = null;
         var fla:Object = null;
         var tmpurl:String = null;
         var aiArr:Array = null;
         var aiItem:Object = null;
         var num:int = 0;
         var cur:int = 0;
         var popupArr:Array = null;
         var otherPopup:Object = null;
         var otherDescArr:Array = null;
         var descArr:Array = null;
         var descItem:Object = null;
         var choose:Array = null;
         var j:int = 0;
         var leng:int = 0;
         var chooseItem:Object = null;
         var effectArr:Array = null;
         var removeArr:Array = null;
         var condition:Array = null;
         var condItem:Object = null;
         if(xml == null)
         {
            return null;
         }
         if(Boolean(xml.hasOwnProperty("alert")))
         {
            alert = {};
            alert.tName = xml.@name;
            alert.sceneId = int(xml.@targetScene);
            if(rest.length > 0)
            {
               alert.imgUrl = "assets/dialogimg/" + this.getSexUrl(rest[0]) + ".swf";
               alert.desc = this.goodsFilter(xml.alert.toString(),rest[0]);
            }
            else
            {
               imgUrl = xml.alert.@imgurl.toString();
               if(imgUrl.length == 0 || imgUrl == "" || imgUrl == "null")
               {
                  alert.imgUrl = "null";
               }
               else
               {
                  alert.imgUrl = "assets/dialogimg/" + this.getSexUrl(imgUrl) + ".swf";
               }
               alert.desc = this.followMonsterFilter(xml.alert.toString());
            }
            try
            {
               alert.opname = xml.alert.@opname.toString();
               alert.opid = int(xml.alert.@opid);
            }
            catch(e:*)
            {
               alert.opname = "";
               alert.opid = 0;
            }
            return alert;
         }
         i = 0;
         if(int(dialogID / baseNumOfDialog) < 1)
         {
            len = int(xml.elements("desc").length());
            for(i = 0; i < len; i++)
            {
               normalDesc = {};
               normalDesc.id = int(xml.desc[i].@id);
               normalDesc.desc = xml.desc[i].toString();
            }
         }
         task = new Task();
         task.dialogID = dialogID;
         task.subtaskID = subtaskID;
         task.taskID = taskID;
         task.taskName = xml.@name;
         if(Boolean(xml.hasOwnProperty("battle")))
         {
            battle = {};
            battle.id = int(xml.battle.@id);
            battle.level = int(xml.battle.@level);
            battle.position = int(xml.battle.@position);
            battle.removeID = this.stringUtil(xml.battle.@removeid,",");
            battle.useID = int(xml.battle.@useid);
            if(Boolean(int(xml.battle.@afterflash == 1)))
            {
               battle.afterflash = true;
            }
            else
            {
               battle.afterflash = false;
            }
            if(int(xml.battle.@ignore) == 1)
            {
               battle.ignore = true;
            }
            else
            {
               battle.ignore = false;
            }
            try
            {
               battle.effectId = this.stringUtil(xml.battle.@effectId,",");
               battle.effectType = int(xml.battle.@effectType);
            }
            catch(e:*)
            {
               battle.effectId = null;
               battle.effectType = 0;
            }
            task.battle = battle;
         }
         if(Boolean(xml.hasOwnProperty("flash")))
         {
            len = int(xml.elements("flash").length());
            flaArr = [];
            for(i = 0; i < len; i++)
            {
               fla = {};
               fla.url = xml.flash[i].@url.toString();
               fla.position = int(xml.flash[i].@position);
               fla.x = Number(xml.flash[i].@xCoord);
               fla.y = Number(xml.flash[i].@yCoord);
               fla.type = 0;
               try
               {
                  fla.type = int(xml.flash[i].@type);
               }
               catch(e:*)
               {
                  fla.type = 0;
               }
               try
               {
                  fla.npcid = int(xml.flash[i].@npcid);
               }
               catch(e:*)
               {
                  fla.npcid = 0;
               }
               try
               {
                  fla.effectName = xml.flash[i].@effectName.toString();
               }
               catch(e:*)
               {
                  fla.effectName = "";
               }
               if(int(xml.flash[i].@afterbattle) == 1)
               {
                  fla.afterbattle = true;
               }
               else
               {
                  fla.afterbattle = false;
               }
               try
               {
                  fla.effect = this.stringUtil(xml.flash[i].@effectId,",");
                  fla.effectType = int(xml.flash[i].@effectType);
               }
               catch(e:*)
               {
                  fla.effect = null;
                  fla.effectType = 0;
               }
               try
               {
                  if(Boolean(xml.flash[i].@sexual) && int(xml.flash[i].@sexual) == 1)
                  {
                     tmpurl = fla.url.substring(0,fla.url.length - 4);
                     if(Boolean(GameData.instance.playerData.roleType & 1 == 1))
                     {
                        tmpurl += "_" + 1;
                     }
                     else
                     {
                        tmpurl += "_" + 2;
                     }
                     fla.url = tmpurl + ".swf";
                  }
               }
               catch(e:*)
               {
               }
               fla.url = URLUtil.getSvnVer(fla.url);
               flaArr.push(fla);
            }
            task.flash = flaArr;
         }
         if(Boolean(xml.hasOwnProperty("ai")))
         {
            len = int(xml.ai.elements("sceneai").length());
            aiArr = [];
            for(i = 0; i < len; i++)
            {
               aiItem = {};
               aiItem.id = int(xml.ai.sceneai[i].@id);
               aiItem.targetId = int(xml.ai.sceneai[i].@target);
               aiItem.opname = xml.ai.sceneai[i].@opname;
               aiArr.push(aiItem);
            }
            task.ai = aiArr;
         }
         if(Boolean(xml.hasOwnProperty("otherpopup")))
         {
            num = int(xml.elements("otherpopup").length());
            cur = 0;
            popupArr = [];
            for(cur = 0; cur < num; cur++)
            {
               otherPopup = {};
               otherPopup.position = int(xml.otherpopup[cur].@position);
               otherPopup.opName = xml.otherpopup[cur].@opname.toString();
               otherPopup.popid = int(xml.otherpopup[cur].@id);
               otherPopup.opurl = xml.otherpopup[cur].@opurl.toString();
               otherPopup.afterChoose = int(xml.otherpopup[cur].@afterChoose);
               len = int(xml.otherpopup[cur].elements("desc").length());
               if(len != 0)
               {
                  otherDescArr = [];
                  for(i = 0; i < len; i++)
                  {
                     otherDescArr.push(xml.otherpopup[cur].desc[i].toString());
                  }
                  otherPopup.desc = otherDescArr;
               }
               popupArr.push(otherPopup);
            }
            task.otherpopup = popupArr;
         }
         if(Boolean(xml.hasOwnProperty("desc")))
         {
            len = int(xml.elements("desc").length());
            descArr = [];
            for(i = 0; i < len; i++)
            {
               descItem = {};
               if(Boolean(xml.desc[i].hasOwnProperty("choose")))
               {
                  choose = [];
                  j = 0;
                  leng = int(xml.desc[i].elements("choose").length());
                  for(j = 0; j < leng; j++)
                  {
                     chooseItem = {};
                     chooseItem.flag = int(xml.desc[i].choose[j].@flag);
                     chooseItem.desc = xml.desc[i].choose[j].toString();
                     try
                     {
                        chooseItem.effectName = xml.desc[i].choose[j].@effctName;
                        chooseItem.effectID = this.stringUtil(xml.desc[i].choose[j].@effectID,",");
                        chooseItem.effectType = int(xml.desc[i].choose[j].@type);
                     }
                     catch(e:*)
                     {
                        chooseItem.effectName = "";
                        chooseItem.effectID = [0];
                        chooseItem.effectType = 3;
                     }
                     choose.push(chooseItem);
                  }
                  descItem.choose = choose;
               }
               else
               {
                  descItem.desc = xml.desc[i].toString();
               }
               descItem.id = int(xml.desc[i].@id);
               try
               {
                  descItem.targetScene = int(xml.desc[i].@targetScene);
                  effectArr = this.stringUtil(xml.desc[i].@effectid,",");
                  if(effectArr != null && effectArr.length == 1 && effectArr[0] == 0)
                  {
                     effectArr = null;
                  }
                  descItem.effectID = effectArr;
                  descItem.type = int(xml.desc[i].@type);
                  removeArr = this.stringUtil(xml.desc[i].@removeid,",");
                  if(removeArr != null && removeArr.length == 1 && removeArr[0] == 0)
                  {
                     removeArr = null;
                  }
                  descItem.remove = removeArr;
               }
               catch(e:*)
               {
                  descItem.targetScene = 0;
               }
               descArr.push(descItem);
            }
            task.describe = descArr;
         }
         if(Boolean(xml.hasOwnProperty("condition")))
         {
            len = int(xml.condition.elements("cond").length());
            condition = [];
            for(i = 0; i < len; i++)
            {
               condItem = {};
               condItem.id = int(xml.condition.cond[i].@id);
               condItem.type = int(xml.condition.cond[i].@type);
               condItem.number = int(xml.condition.cond[i].@number);
               condition.push(condItem);
            }
            task.condition = condition;
         }
         if(Boolean(xml.hasOwnProperty("targetScene")))
         {
            task.targetScene = int(xml.targetScene);
         }
         task.taskDifficult = TaskInfoXMLParser.instance.parseDiff(XMLLocator.getInstance().getTaskInfo(task.taskID));
         return task;
      }
      
      private function goodsFilter(str:String, id:int) : String
      {
         return str;
      }
      
      private function followMonsterFilter(str:String) : String
      {
         var fnReg:RegExp = /followMonster/g;
         return str.replace(fnReg,GameData.instance.playerData.mname);
      }
      
      private function stringUtil(str:String, split:String) : Array
      {
         var result:Array = null;
         var i:int = 0;
         var len:int = 0;
         if(str.indexOf(split) != -1)
         {
            result = str.split(split);
            i = 0;
            len = int(result.length);
            for(i = 0; i < len; i++)
            {
               result[i] = int(result[i]);
            }
            return result;
         }
         return [int(str)];
      }
      
      public function parseAlert(dialogID:int, callback:Function) : void
      {
         if(dialogID == 0)
         {
            return;
         }
         this._toGetXML = callback;
         PropertyPool.instance.getTaskProps(dialogID,this.getPropBack,dialogID);
      }
      
      private function getPropBack(props:XML, arr:Array) : void
      {
         var xml:XML;
         var alert:Object = null;
         var imgUrl:String = null;
         if(props == null)
         {
            return;
         }
         xml = props.children().(@id == arr[0])[0] as XML;
         if(Boolean(xml.hasOwnProperty("alert")))
         {
            alert = {};
            imgUrl = xml.alert.@imgurl.toString();
            if(imgUrl.length == 0 || imgUrl == "" || imgUrl == "null")
            {
               alert.imgUrl = "null";
            }
            else
            {
               alert.imgUrl = "assets/dialogimg/" + this.getSexUrl(imgUrl) + ".swf";
            }
            alert.title = xml.@name.toString();
            alert.sceneId = int(xml.@targetScene);
            alert.desc = xml.alert.toString();
         }
         if(this._toGetXML != null)
         {
            this._toGetXML.apply(null,[alert]);
         }
         this._toGetXML = null;
      }
      
      private function getSexUrl(str:String) : String
      {
         var t_sex:int = 0;
         try
         {
            t_sex = int(str);
         }
         catch(e:*)
         {
            t_sex = 0;
         }
         if(t_sex != 0)
         {
            if(Boolean(GameData.instance.playerData.roleType & 1 == 1))
            {
               str += "1";
            }
            else
            {
               str += "2";
            }
         }
         return str;
      }
   }
}

