package com.game.modules.view.task
{
   import caurina.transitions.Tweener;
   import com.game.locators.GameData;
   import com.game.manager.MonsterManger;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.control.task.util.Task;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.modules.view.task.dialog.DialogFunctionItem;
   import com.game.util.GameDynamicUI;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Hloader;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   
   public class TaskDialog extends Sprite
   {
      
      private var dialogCls:Class;
      
      private var mc:MovieClip;
      
      private var loader:Loader;
      
      private var currentTask:Task;
      
      private var taskObj:Object;
      
      private var totalLength:int = 0;
      
      private var index:int = 0;
      
      private var personSayArr:Array;
      
      private var imgIndex:int;
      
      private var position:int;
      
      private var currentDesc:Object;
      
      private var currentIndex:int;
      
      private var usernameRegExp:RegExp = /username/i;
      
      private var wragRegExp:RegExp = /newline/g;
      
      private var highlightFormat:TextFormat = new TextFormat("宋体",14,16776960,false);
      
      private var defaultFormat:TextFormat = new TextFormat("宋体",14,16777215,false);
      
      private var npcNameTextFormat:TextFormat = new TextFormat("宋体",26,16776960,true);
      
      private var shape:Sprite;
      
      private var uiLoader:Hloader;
      
      private var bossXML:XML;
      
      private var needSendChoose:int = 0;
      
      private var sendChooseId:int = 0;
      
      private var aniEffect:Object;
      
      private var colorList:Array;
      
      private var _COLORFLAGFRONT:String = "|f";
      
      private var _COLORFLAGBEHIND:String = "|b";
      
      private var changColorRegExp:RegExp = /\|f0x(\w{6})(.*?)\|b/;
      
      private var changeMapColorReReg:RegExp = /\|【(.*?)\|】/;
      
      private var colorFormatList:Dictionary;
      
      public function TaskDialog()
      {
         super();
         this.shape = new Sprite();
         this.shape.graphics.beginFill(16777215,0);
         this.shape.graphics.drawRect(0,0,970,570);
         this.shape.graphics.endFill();
         this.shape.mouseChildren = false;
         this.addChildAt(this.shape,0);
         this.shape.x = 0;
         this.shape.y = 0;
         GreenLoading.loading.visible = true;
         this.uiLoader = new Hloader("assets/material/dialog.swf");
         this.uiLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.cacheAsBitmap = true;
         this.initBossXML();
      }
      
      private function initBossXML() : void
      {
         this.bossXML = <node>
				<boss id="10060">
					<name>巨木将军</name>
				</boss>
				<boss id="10067">
					<name>赤炎鸟</name>
				</boss>
				<boss id="10068">
					<name>冥图古犀</name>
				</boss>
				<boss id="10069">
					<name>海龙马</name>
				</boss>
				<boss id="10070">
					<name>傲天</name>
				</boss>
				<boss id="10071">
					<name>紫云太岁</name>
				</boss>
				<boss id="10072">
					<name>冲霄</name>
				</boss>
				<boss id="10081">
					<name>夜刃闪</name>
				</boss>
			</node>;
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         GreenLoading.loading.visible = false;
         var domain:ApplicationDomain = this.uiLoader.contentLoaderInfo.applicationDomain;
         this.uiLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         if(domain == null)
         {
            this.dispos();
            return;
         }
         var cls:Class = domain.getDefinition("taskDialog") as Class;
         this.mc = new cls() as MovieClip;
         this.addChild(this.mc);
         this.visible = false;
         this.mc.x = 85;
         this.mc.y = 470;
         (this.mc.nameMC.npcName as TextField).defaultTextFormat = this.npcNameTextFormat;
         this.mc.lastDialog.visible = false;
         this.mc.nextDialog.visible = false;
         this.dialogCls = domain.getDefinition("dialogItem") as Class;
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         GameDynamicUI.removeUI("loading");
         if(this.currentTask && this.currentTask.describe != null && this.currentTask.describe.length > 0)
         {
            TaskUtils.getInstance().dispatchEvent(TaskEvent.SHOW_OR_HIDE_BOTTOM,false);
         }
         if(Boolean(this.mc.lastDialog.visible))
         {
            this.mc.lastDialog.visible = false;
            this.mc.lastDialog.removeEventListener(MouseEvent.CLICK,this.onClickLastDialog);
         }
         if(GameData.instance.playerData.isNewHand != -100)
         {
            this.mc.close.visible = false;
            if(Boolean(this.mc.close.hasEventListener(MouseEvent.CLICK)))
            {
               this.mc.close.removeEventListener(MouseEvent.CLICK,this.onMouseClickClose);
            }
         }
         else
         {
            this.mc.close.visible = true;
            this.mc.close.addEventListener(MouseEvent.CLICK,this.onMouseClickClose);
         }
         if(this.loader == null)
         {
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadImgComplete);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadImgError);
            this.mc.imgBG.addChild(this.loader);
         }
         if(this.currentTask != null)
         {
            if((this.currentTask.describe == null || this.currentTask.describe.length == 0) && (this.currentTask.flash == null || this.currentTask.flash.length == 0) && this.currentTask.battle == null && (this.currentTask.otherpopup == null || this.currentTask.otherpopup.length == 0))
            {
               this.onAccept(true);
               return;
            }
            if(this.currentTask.describe != null && this.currentTask.describe.length > 0)
            {
               this.totalLength = this.currentTask.describe.length;
               if(this.position != 0)
               {
                  this.currentTask.describe.splice(0,this.position);
               }
               this.imgIndex = this.currentTask.describe[0].id;
               if(this.imgIndex == -1 || this.imgIndex == -2 || this.imgIndex == 43994399)
               {
                  this.mc.nameMC.npcName.text = GameData.instance.playerData.userName;
               }
               this.loadNPCIMG(this.imgIndex);
            }
            this.spliceView();
         }
      }
      
      public function setData(task:Task, position:int = 0, needchoose:int = 0) : void
      {
         if(Boolean(this.parent))
         {
            GameDynamicUI.addUI(this.parent,200,200,"loading");
         }
         this.setFreshManFlag(task.dialogID,task.subtaskID);
         this.sendChooseId = 0;
         this.dispos(true);
         this.visible = true;
         this.currentTask = task;
         this.currentTask.dialogID = task.dialogID;
         this.currentTask.subtaskID = task.subtaskID;
         this.currentTask.taskID = task.taskID;
         this.currentTask.taskName = task.taskName;
         this.currentTask.condition = task.condition;
         this.currentTask.state = task.state;
         this.currentTask.battle = task.battle;
         this.currentTask.flash = task.flash;
         this.currentTask.targetScene = task.targetScene;
         this.currentTask.ai = task.ai;
         this.currentTask.otherpopup = task.otherpopup;
         this.currentTask.describe = task.describe;
         this.position = position;
         this.index = 0;
         this.needSendChoose = needchoose;
         if(this.mc != null)
         {
            this.initEvent();
         }
      }
      
      private function spliceView() : void
      {
         var i:int = 0;
         var len:int = 0;
         var fla:Object = null;
         var flag:Boolean = false;
         if(this.currentTask.otherpopup != null && this.currentTask.otherpopup.length > 0 || this.currentTask.flash != null && this.currentTask.flash.length > 0 || this.currentTask.battle != null)
         {
            i = 0;
            len = 0;
            if(this.currentTask.otherpopup != null && this.currentTask.otherpopup.length > 0)
            {
               len = int(this.currentTask.otherpopup.length);
               for(i = 0; i < len; i++)
               {
                  if(this.currentTask.otherpopup[i].position == this.index && this.currentTask.otherpopup[i].afterChoose == 0)
                  {
                     this.openPopUp(this.index);
                     return;
                  }
               }
            }
            if(this.currentTask.flash != null && this.currentTask.flash.length > 0 || this.currentTask.battle != null)
            {
               if(this.currentTask.flash != null && this.currentTask.flash.length > 0 && this.currentTask.battle != null)
               {
                  flag = false;
                  len = int(this.currentTask.flash.length);
                  if(this.currentTask.battle.position == this.index)
                  {
                     flag = true;
                  }
                  for(i = 0; i < len; i++)
                  {
                     fla = this.currentTask.flash[i];
                     if(fla.position == this.index)
                     {
                        if(Boolean(fla.afterbattle) && flag)
                        {
                           this.startBattle();
                           return;
                        }
                        this.playAnimation(fla);
                        return;
                     }
                  }
                  if(flag)
                  {
                     this.startBattle();
                     return;
                  }
               }
               else if(this.currentTask.battle == null)
               {
                  len = int(this.currentTask.flash.length);
                  for(i = 0; i < len; i++)
                  {
                     fla = this.currentTask.flash[i];
                     if(fla.position == this.index)
                     {
                        this.playAnimation(fla);
                        return;
                     }
                  }
               }
               else if(this.currentTask.battle.position == this.index)
               {
                  this.startBattle();
                  return;
               }
            }
            if(this.index < this.totalLength)
            {
               this.taskObj = this.currentTask.describe[this.index];
               ++this.index;
               this.initView();
            }
            else
            {
               this.onAccept(true);
            }
         }
         else if(this.currentTask.describe != null && this.currentTask.describe.length > 0 && this.index < this.totalLength)
         {
            this.taskObj = this.currentTask.describe[this.index];
            ++this.index;
            this.initView();
         }
         else if(this.currentTask.describe == null || this.currentTask.describe.length == 0 || this.index >= this.totalLength)
         {
            this.onAccept(true);
         }
      }
      
      private function playAnimation(fla:Object) : void
      {
         this.visible = false;
         this.mc.visible = false;
         var i:int = 0;
         var len:int = int(this.currentTask.flash.length);
         for(i = 0; i < len; i++)
         {
            if(this.currentTask.flash[i].url == fla.url)
            {
               this.aniEffect = this.currentTask.flash.splice(i,1)[0];
               break;
            }
         }
         TaskUtils.getInstance().dispatchEvent(TaskEvent.PLAYANIMATION,{
            "url":fla.url,
            "targetFunction":this.animationPlayComplete,
            "x":fla.x,
            "y":fla.y,
            "type":fla.type,
            "npcid":fla.npcid,
            "effectName":fla.effectName
         });
      }
      
      private function animationPlayComplete(param:Object = null) : void
      {
         if(this.currentTask.flash == null || this.currentTask.flash.length == 0)
         {
            this.currentTask.flash = null;
         }
         if(this.currentTask.describe != null && this.currentIndex < this.currentTask.describe.length)
         {
            TaskUtils.getInstance().dispatchEvent(TaskEvent.SHOW_OR_HIDE_BOTTOM,false);
         }
         if(this.aniEffect == null || this.aniEffect.effect == null || this.aniEffect.effect.length == 1 && this.aniEffect.effect[0] == 0)
         {
            this.spliceView();
         }
         else if(this.aniEffect.effect != null && !(this.aniEffect.effect.length == 1 && this.aniEffect.effect[0] == 0))
         {
            TaskUtils.getInstance().dispatchEvent(TaskEvent.PLAY_NPC_EFFECT,{
               "id":this.aniEffect.effect,
               "type":this.aniEffect.effectType,
               "callback":this.effectAfterAnimation
            });
         }
      }
      
      private function effectAfterAnimation(npcname:String = "") : void
      {
         if(this.aniEffect != null && this.aniEffect.remove != null && !(this.aniEffect.remove.length == 1 && this.aniEffect.remove[0] == 0))
         {
            TaskUtils.getInstance().dispatchEvent(TaskEvent.REMOVESOMETHING,this.aniEffect.remove);
         }
         this.aniEffect = null;
         TaskUtils.getInstance().dispatchEvent(TaskEvent.SHOW_OR_HIDE_BOTTOM,false);
         this.spliceView();
      }
      
      private function initView() : void
      {
         var tempXML:XML = null;
         this.mc.visible = true;
         this.visible = true;
         if(this.taskObj.id != -1 && this.taskObj.id != -2 && this.taskObj.id != 43994399)
         {
            if(this.taskObj.id > 10000)
            {
               tempXML = XMLLocator.getInstance().getNPC(this.taskObj.id);
            }
            else
            {
               tempXML = XMLLocator.getInstance().getSprited(this.taskObj.id);
            }
            if(tempXML != null)
            {
               this.mc.nameMC.npcName.text = tempXML.name;
            }
         }
         else
         {
            this.mc.nameMC.npcName.text = GameData.instance.playerData.userName;
         }
         if(this.taskObj.id != this.imgIndex || this.loader == null)
         {
            if(this.loader == null)
            {
               this.loader = new Loader();
               this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadImgComplete);
               this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadImgError);
               this.mc.imgBG.addChild(this.loader);
            }
            this.imgIndex = this.taskObj.id;
            this.loader.unloadAndStop();
            this.loadNPCIMG(this.imgIndex);
         }
         if(this.index < this.totalLength || this.index == this.totalLength && (this.taskObj.id == -1 || this.taskObj.id == -2))
         {
            this.showDialog(this.taskObj);
         }
      }
      
      private function usernameFilter(str:String) : Object
      {
         var i:int = 0;
         var tmpStart:int = 0;
         var len:int = 0;
         var indexArr:Array = null;
         var endindexArr:Array = null;
         var tmpStr:String = null;
         this.colorList = null;
         str = str.replace(this.wragRegExp,"\n");
         var tmpArr:Array = this.buildFilterList(str);
         str = HtmlUtil.getRealHtmlStr(str);
         if(tmpArr.length > 0)
         {
            if(str.indexOf(this._COLORFLAGFRONT) != -1)
            {
               this.colorList = [];
            }
            i = 0;
            len = int(tmpArr.length);
            indexArr = [];
            endindexArr = [];
            for(i = 0; i < len; i++)
            {
               tmpStart = int(str.indexOf(tmpArr[i].type,0));
               if(tmpArr[i].type != this._COLORFLAGFRONT)
               {
                  indexArr.push(tmpStart);
               }
               if(tmpArr[i].type == "userid")
               {
                  tmpStr = GameData.instance.playerData.userId + "";
                  endindexArr.push(tmpStart + tmpStr.length);
                  indexArr[endindexArr.length - 1] -= 1;
                  str = str.replace(/userid/i,tmpStr);
               }
               else if(tmpArr[i].type == "username")
               {
                  endindexArr.push(tmpStart + 1 + GameData.instance.playerData.userName.length);
                  str = str.replace(this.usernameRegExp,"<font color=\'#ffff00\'>【" + GameData.instance.playerData.userNamehtml + "】</font>");
               }
               else if(tmpArr[i].type == "instead")
               {
                  tmpStr = this.insteadFilter(int(str.substr(tmpStart + 7,2)));
                  endindexArr.push(tmpStart + tmpStr.length - 1);
                  str = str.replace(/instead[0-9]*/i,tmpStr);
               }
               else if(tmpArr[i].type == this._COLORFLAGFRONT)
               {
                  str = str.replace(this.changColorRegExp,"<font color=\'#$1\'>$2</font>");
                  str = str.replace(this.changeMapColorReReg,"<font color=\'#$ff0000\'>$1</font>");
               }
            }
            return {
               "content":str,
               "indexs":indexArr,
               "endindexs":endindexArr
            };
         }
         return {"content":str};
      }
      
      private function removeCharsFromStr(str:String, start:int, len:int) : String
      {
         if(len <= 0 || len > str.length || len + start > str.length || start < 0 || start >= str.length)
         {
            return str;
         }
         var frontStr:String = "";
         if(start > 0)
         {
            frontStr = str.substr(0,start);
         }
         var behindStr:String = str.substring(start + len);
         return frontStr + behindStr;
      }
      
      private function insteadFilter(cin:int) : String
      {
         var item:Object = null;
         var itemXML:XML = null;
         var str:String = "";
         if(this.currentTask && this.currentTask.argument && this.currentTask.argument.length > cin)
         {
            item = this.currentTask.argument[cin];
            switch(item.type)
            {
               case 1:
                  itemXML = XMLLocator.getInstance().getMap(item.id);
                  str = "【" + itemXML.@name.toString() + "】";
                  break;
               case 2:
                  itemXML = XMLLocator.getInstance().getTool(item.id);
                  str = "【" + itemXML.name.toString() + "】";
                  break;
               case 3:
                  itemXML = this.bossXML.children().(@id == item.id)[0] as XML;
                  str = "【" + itemXML.name.toString() + "】";
                  break;
               case 4:
                  itemXML = XMLLocator.getInstance().getNPC(item.id);
                  str = "【" + itemXML.name.toString() + "】";
                  break;
               case 5:
                  str = item.id + "";
            }
         }
         return str;
      }
      
      private function buildFilterList(str:String) : Array
      {
         var tmpArr:Array = [];
         var i:int = 0;
         this.getStartList(str,"userid",tmpArr);
         this.getStartList(str,"username",tmpArr);
         this.getStartList(str,this._COLORFLAGFRONT,tmpArr);
         if(this.currentTask.argument != null && this.currentTask.argument.length > 0)
         {
            this.getStartList(str,"instead",tmpArr);
         }
         return tmpArr.sortOn("start",Array.NUMERIC);
      }
      
      private function getStartList(str:String, reg:String, arr:Array) : void
      {
         var i:int = 0;
         if(str.indexOf(reg) != -1)
         {
            i = int(str.indexOf(reg));
            while(i != -1)
            {
               arr.push({
                  "start":i,
                  "type":reg
               });
               i = int(str.indexOf(reg,i + 1));
            }
         }
      }
      
      private function printEffect() : void
      {
         if(this.currentDesc == null)
         {
            return;
         }
         this.mc.sayTxt.text = "";
         this.mc.sayTxt.htmlText = this.currentDesc.content as String;
         this.printComplete();
         this.mc.sayTxt.addEventListener(MouseEvent.CLICK,this.onClickNPCSay);
         this.shape.addEventListener(MouseEvent.CLICK,this.onClickNPCSay);
      }
      
      private function onClickNPCSay(evt:MouseEvent) : void
      {
         var indexobj:Object = null;
         var indexList:Array = null;
         if(Boolean(this.mc.sayTxt.hasEventListener(MouseEvent.CLICK)))
         {
            this.mc.sayTxt.removeEventListener(MouseEvent.CLICK,this.onClickNPCSay);
         }
         if(this.shape.hasEventListener(MouseEvent.CLICK))
         {
            this.shape.removeEventListener(MouseEvent.CLICK,this.onClickNPCSay);
         }
         if(this.currentDesc == null)
         {
            return;
         }
         this.mc.sayTxt.appendText((this.currentDesc.content as String).substring(this.currentIndex));
         this.mc.sayTxt.setTextFormat(this.defaultFormat,0,this.mc.sayTxt.length);
         var i:int = 0;
         var len:int = 0;
         if(Boolean(this.currentDesc.hasOwnProperty("indexs")) && this.currentDesc.indexs.length > 0)
         {
            if(indexList == null)
            {
               indexList = [];
            }
            len = int(this.currentDesc.indexs.length);
            while(len != 0)
            {
               indexobj = {};
               indexobj.startIndex = (this.currentDesc.indexs as Array)[0] + 1;
               indexobj.endIndex = this.currentDesc.endindexs[0];
               indexobj.highlight = -1;
               this.currentDesc.indexs.splice(0,1);
               this.currentDesc.endindexs.splice(0,1);
               indexList.push(indexobj);
               if(this.currentDesc.indexs.length == 0)
               {
                  len = 0;
               }
               else
               {
                  len--;
               }
            }
         }
         if(Boolean(this.colorList) && this.colorList.length > 0)
         {
            if(indexList == null)
            {
               indexList = [];
            }
            len = int(this.colorList.length);
            for(i = 0; i < len; i++)
            {
               indexobj = {};
               indexobj.startIndex = this.colorList[i].start;
               indexobj.endIndex = this.colorList[i].end;
               indexobj.highlight = i;
               indexList.push(indexobj);
            }
         }
         if(indexList != null && indexList.length > 0)
         {
            indexList.sortOn("startIndex",Array.NUMERIC);
            len = int(indexList.length);
            for(i = 0; i < len; i++)
            {
               indexobj = indexList[i];
               this.mc.sayTxt.setTextFormat(indexobj.highlight == -1 ? this.highlightFormat : this.makeColorFormat(indexobj.highlight),indexobj.startIndex,indexobj.endIndex);
            }
         }
         this.printComplete();
      }
      
      private function printComplete() : void
      {
         this.currentIndex = 0;
         this.currentDesc = null;
         if(this.checkNextStatus())
         {
            this.mc.nextDialog.visible = true;
            this.mc.nextDialog.addEventListener(MouseEvent.CLICK,this.onClickNextSay);
         }
         else
         {
            this.taskObj = this.currentTask.describe[this.index];
            ++this.index;
            if(Boolean(this.mc.nextDialog.visible))
            {
               this.mc.nextDialog.visible = false;
               this.mc.nextDialog.removeEventListener(MouseEvent.CLICK,this.onClickNextSay);
            }
            this.showOpSay(this.taskObj);
         }
      }
      
      private function checkNextStatus() : Boolean
      {
         if(this.currentTask.describe[this.index] == null)
         {
            return true;
         }
         if(this.currentTask.describe[this.index].id > 0)
         {
            return true;
         }
         if(this.index != 0 && this.currentTask.describe[this.index].id == this.currentTask.describe[this.index - 1].id)
         {
            return true;
         }
         if(this.currentTask.describe.length > this.index + 1 && this.currentTask.describe[this.index + 1].id < 1)
         {
            return this.currentTask.describe[this.index + 1].id == this.currentTask.describe[this.index].id;
         }
         return false;
      }
      
      private function isInIndexs(index:int) : int
      {
         var len:int = 0;
         var i:int = 0;
         if(this.colorList != null && this.colorList.length > 0)
         {
            len = int(this.colorList.length);
            for(i = 0; i < len; i++)
            {
               if(index >= this.colorList[i].start && index < this.colorList[i].end)
               {
                  return 3 + i;
               }
            }
         }
         if(this.currentDesc == null || !this.currentDesc.hasOwnProperty("indexs") || this.currentDesc.indexs.length == 0)
         {
            return 0;
         }
         len = int(this.currentDesc.indexs.length);
         for(i = 0; i < len; i++)
         {
            if(this.currentDesc.endindexs[i] > index)
            {
               if(this.currentDesc.indexs[i] <= index)
               {
                  return 1;
               }
               return 2;
            }
            if(i >= len - 1)
            {
               return 2;
            }
            if(this.currentDesc.indexs[i + 1] > index)
            {
               return 2;
            }
         }
         return 0;
      }
      
      private function makeColorFormat(tmpindex:int) : TextFormat
      {
         if(this.colorFormatList == null)
         {
            this.colorFormatList = new Dictionary(true);
         }
         if(this.colorFormatLength() > tmpindex)
         {
            return this.colorFormatList[this.colorList[tmpindex].color];
         }
         this.colorFormatList[this.colorList[tmpindex].color] = new TextFormat("宋体",14,this.colorList[tmpindex].color,true);
         return this.colorFormatList[this.colorList[tmpindex].color];
      }
      
      private function colorFormatLength() : int
      {
         var str:String = null;
         var clen:int = 0;
         if(this.colorFormatList == null)
         {
            return 0;
         }
         for each(str in this.colorFormatList)
         {
            clen++;
         }
         return clen;
      }
      
      private function deleteColorFormatList() : void
      {
         var str:String = null;
         if(this.colorFormatList == null)
         {
            return;
         }
         for each(str in this.colorFormatList)
         {
            this.colorFormatList[str] = null;
            delete this.colorFormatList[str];
         }
         this.colorFormatList = null;
      }
      
      private function showDialog(fir:Object) : void
      {
         (this.mc.sayTxt as TextField).defaultTextFormat = this.defaultFormat;
         if(this.personSayArr == null || this.personSayArr.length > 0)
         {
            this.personSayArr = [];
         }
         if(fir.id != 0)
         {
            this.currentDesc = this.usernameFilter(fir.desc);
            this.printEffect();
         }
         else
         {
            this.showOpSay(fir);
            this.printComplete();
         }
      }
      
      private function onClickNextSay(evt:MouseEvent) : void
      {
         this.mc.lastDialog.visible = true;
         this.mc.lastDialog.addEventListener(MouseEvent.CLICK,this.onClickLastDialog);
         this.mc.nextDialog.visible = false;
         this.spliceView();
      }
      
      private function onClickLastDialog(evt:MouseEvent) : void
      {
         if(this.index > 2)
         {
            this.index -= 2;
            if(this.currentTask.describe[this.index - 1].id == -1 || this.currentTask.describe[this.index - 1].id == 0)
            {
               this.mc.lastDialog.visible = false;
               this.mc.lastDialog.removeEventListener(MouseEvent.CLICK,this.onClickLastDialog);
            }
         }
         else
         {
            this.mc.lastDialog.visible = false;
            this.mc.lastDialog.removeEventListener(MouseEvent.CLICK,this.onClickLastDialog);
            this.index = 0;
         }
         this.spliceView();
      }
      
      private function showOpSay(opsay:Object) : void
      {
         var personDia:DialogFunctionItem = null;
         var obj:Object = null;
         var destY:Number = NaN;
         if(Boolean(this.mc.lastDialog.visible))
         {
            this.mc.lastDialog.visible = false;
            this.mc.lastDialog.removeEventListener(MouseEvent.CLICK,this.onClickLastDialog);
         }
         var i:int = 0;
         var len:int = 0;
         if(Boolean(opsay.hasOwnProperty("choose")) && opsay.choose.length > 0)
         {
            len = int(opsay.choose.length);
            for(i = 0; i < len; i++)
            {
               obj = opsay.choose[i];
               if(obj.effectName == "")
               {
                  personDia = new DialogFunctionItem(this.dialogCls,this.usernameFilter(obj.desc),obj.flag,this.onClickPersonSay);
               }
               else
               {
                  personDia = new DialogFunctionItem(this.dialogCls,this.usernameFilter(obj.desc),obj.flag,this.onClickPersonSay,obj.effectName,obj.effectID,obj.effectType);
               }
               this.personSayArr.push(personDia);
            }
         }
         else
         {
            personDia = new DialogFunctionItem(this.dialogCls,this.usernameFilter(opsay.desc),0,this.onClickPersonSay);
            this.personSayArr.push(personDia);
         }
         if(this.personSayArr.length > 0)
         {
            len = int(this.personSayArr.length);
            destY = 95;
            this.personSayArr.reverse();
            for(i = 0; i < len; i++)
            {
               this.mc.addChildAt(this.personSayArr[i],this.numChildren);
               this.personSayArr[i].x = 619;
               this.personSayArr[i].y = 300;
               destY = destY - this.personSayArr[i].height - 5;
               Tweener.addTween(this.personSayArr[i],{
                  "x":this.personSayArr[i].x,
                  "y":destY,
                  "time":0.5,
                  "transition":"easeInOutBack"
               });
            }
         }
      }
      
      private function onClickPersonSay(flag:int, effectName:String = "", effectID:Array = null, effectType:int = 0) : void
      {
         var j:int = 0;
         var leng:int = 0;
         var len:int = 0;
         var i:int = 0;
         if(this.personSayArr != null)
         {
            if(this.personSayArr.length > 0)
            {
               j = 0;
               leng = int(this.personSayArr.length);
               for(j = 0; j < leng; j++)
               {
                  (this.personSayArr[j] as DialogFunctionItem).dispos();
               }
            }
            this.personSayArr.length = 0;
         }
         switch(flag)
         {
            case -1:
               if(this.taskObj != null && this.taskObj.effectID != null && this.taskObj.effectID.length > 0 && this.taskObj.effectid[0] != 0)
               {
                  TaskUtils.getInstance().dispatchEvent(TaskEvent.PLAY_NPC_EFFECT,{
                     "id":this.taskObj.effectID,
                     "type":this.taskObj.type,
                     "callback":this.opNPCEffectComplete
                  });
               }
               else
               {
                  this.onAccept(true);
               }
               break;
            case 0:
               this.opClickPersonSay();
               break;
            case 1:
               if(this.taskObj != null && this.taskObj.effectID != null && this.taskObj.effectID.length > 0 && this.taskObj.effectID[0] != 0)
               {
                  TaskUtils.getInstance().dispatchEvent(TaskEvent.PLAY_NPC_EFFECT,{
                     "id":this.taskObj.effectID,
                     "type":this.taskObj.type,
                     "callback":this.opNPCEffectComplete
                  });
               }
               else
               {
                  this.onAccept();
               }
               break;
            case 2:
               if(effectName == "")
               {
                  this.onNotAccept();
               }
               else
               {
                  TaskUtils.getInstance().dispatchEvent(TaskEvent.PLAY_NPC_EFFECT,{
                     "id":effectID,
                     "type":effectType,
                     "callback":this.onNotAccept,
                     "efname":effectName
                  });
               }
               break;
            case 3:
               if(effectName == "")
               {
                  this.opClickPersonSay();
               }
               else
               {
                  this.mc.visible = false;
                  TaskUtils.getInstance().dispatchEvent(TaskEvent.PLAY_NPC_EFFECT,{
                     "id":effectID,
                     "type":effectType,
                     "callback":this.opNPCEffectComplete
                  });
               }
               break;
            case 4:
               if(this.currentTask.otherpopup != null && this.currentTask.otherpopup.length > 0)
               {
                  len = int(this.currentTask.otherpopup.length);
                  i = 0;
                  for(i = 0; i < len; i++)
                  {
                     if(this.currentTask.otherpopup[i].position == this.index && this.currentTask.otherpopup[i].afterChoose == 4)
                     {
                        this.openPopUp(this.index);
                        return;
                     }
                  }
               }
               this.opClickPersonSay();
               break;
            case 5:
               this.onNeedSpecialOp(5);
               this.dispos();
               break;
            case 6:
               this.onNeedSpecialOp(6);
               this.dispos();
               break;
            case 7:
               this.onNeedSpecialOp(7);
               this.dispos();
               break;
            case 8:
               this.onNeedSpecialOp(8);
               this.dispos();
               break;
            default:
               if(this.needSendChoose != 0)
               {
                  this.sendChooseId = flag - 8;
               }
               if(this.currentTask.dialogID == 401400103 && this.sendChooseId == 2)
               {
                  new Alert().showGiveUpHBTaskOrNot(this.giveUpHBTask);
               }
               else
               {
                  this.onAccept(true);
               }
         }
      }
      
      private function giveUpHBTask(... rest) : void
      {
         if(rest[0] == "拒绝" || rest[0] == "取消")
         {
            this.onNotAccept();
         }
         else
         {
            this.onAccept(true);
         }
      }
      
      private function onNeedSpecialOp(spindex:int) : void
      {
         TaskUtils.getInstance().dispatchEvent(TaskEvent.SET_DIALOG_VIEW_FALSE);
         TaskUtils.getInstance().dispatchEvent(TaskEvent.NEED_SPECIAL_OP_TO_VIEW,spindex);
      }
      
      private function opClickPersonSay() : void
      {
         this.mc.visible = false;
         if(this.taskObj.effectID != null && this.taskObj.effectID.length > 0)
         {
            TaskUtils.getInstance().dispatchEvent(TaskEvent.PLAY_NPC_EFFECT,{
               "id":this.taskObj.effectID,
               "type":this.taskObj.type,
               "callback":this.opNPCEffectComplete
            });
         }
         else
         {
            this.opNPCEffectComplete();
         }
      }
      
      private function opNPCEffectComplete(npcname:String = "") : void
      {
         TaskUtils.getInstance().dispatchEvent(TaskEvent.SHOW_OR_HIDE_BOTTOM,false);
         if(this.taskObj != null)
         {
            if(this.taskObj.remove != null && this.taskObj.remove.length > 0)
            {
               TaskUtils.getInstance().dispatchEvent(TaskEvent.REMOVESOMETHING,this.taskObj.remove);
            }
            if(this.taskObj.targetScene != 0)
            {
               TaskUtils.getInstance().dispatchEvent(TaskEvent.SENDTOOTHERSCENE,this.taskObj.targetScene);
            }
         }
         this.opNPCEffect(npcname);
      }
      
      private function opNPCEffect(npcname:String = "") : void
      {
         if(this.index >= this.totalLength)
         {
            this.onAccept();
         }
         else
         {
            this.spliceView();
         }
      }
      
      private function onAccept(flag:Boolean = false) : void
      {
         if(!flag)
         {
            this.spliceView();
            return;
         }
         var curindex:int = this.currentTask.dialogID / 100000000 >> 0;
         if(curindex >= 1 && curindex < 4 || this.currentTask.taskID == 4006000 || curindex == 7 || curindex == 9)
         {
            TaskList.getInstance().updateTask(this.currentTask);
         }
         this.dialogComplete();
      }
      
      private function dialogComplete() : void
      {
         this.dispos();
         if(this.currentTask.ai != null && this.currentTask.ai.length > 0)
         {
            TaskUtils.getInstance().dispatchEvent(TaskEvent.DIALOGFINISHED,{
               "dialogId":this.currentTask.dialogID,
               "sceneId":this.currentTask.targetScene,
               "ai":this.currentTask.ai,
               "needchoose":this.sendChooseId
            });
         }
         else
         {
            TaskUtils.getInstance().dispatchEvent(TaskEvent.DIALOGFINISHED,{
               "dialogId":this.currentTask.dialogID,
               "sceneId":this.currentTask.targetScene,
               "needchoose":this.sendChooseId
            });
         }
         if(this.currentTask.dialogID == 600600201)
         {
            GameData.instance.playerData.active_status = 1;
         }
      }
      
      private function startBattle() : void
      {
         var sid:int = 0;
         this.mc.visible = false;
         var uid:int = 0;
         if(this.currentTask.battle.useID != 0)
         {
            if(this.currentTask.battle.id != -1)
            {
               sid = MonsterManger.instance.combine2(10,int(this.currentTask.battle.id));
            }
            else if(TaskView.instance.currentNPCID == 0)
            {
               sid = 1;
            }
            else
            {
               sid = TaskView.instance.currentNPCID;
            }
            uid = MonsterManger.instance.combine2(10,int(this.currentTask.battle.useID));
         }
         else if(this.currentTask.battle.id == -1)
         {
            if(TaskView.instance.currentNPCID == 0)
            {
               O.o("当前NPC的id为0.....有问题....TaskDialog -> startBattle");
               sid = 1;
            }
            else
            {
               sid = TaskView.instance.currentNPCID;
            }
         }
         else if(this.currentTask.battle.id < 10000)
         {
            sid = MonsterManger.instance.combine1(1,0,this.currentTask.battle.id,int(this.currentTask.battle.level));
         }
         else
         {
            sid = MonsterManger.instance.combine2(2,int(this.currentTask.battle.id));
         }
         var obj:Object = {};
         obj.sid = sid;
         obj.callback = this.onBattleBack;
         obj.useID = uid;
         obj.spiritid = int(this.currentTask.battle.id);
         TaskUtils.getInstance().dispatchEvent(TaskEvent.STARTBATTLE,obj);
      }
      
      private function onBattleBack(win:Boolean) : void
      {
         var battleeffect:Boolean = false;
         if(this.parent == null)
         {
            battleeffect = false;
         }
         if(win || Boolean(this.currentTask.battle.ignore))
         {
            if(this.currentTask.battle.effectId != null && !(this.currentTask.battle.effectId.length == 1 && this.currentTask.battle.effectId[0] == 0))
            {
               battleeffect = true;
               TaskUtils.getInstance().dispatchEvent(TaskEvent.PLAY_NPC_EFFECT,{
                  "id":this.currentTask.battle.effectId,
                  "type":this.currentTask.battle.effectType,
                  "callback":this.effectAfterBattle
               });
            }
            if(Boolean(this.currentTask.battle) && this.currentTask.battle.removeID != 0)
            {
               TaskUtils.getInstance().dispatchEvent(TaskEvent.REMOVESOMETHING,this.currentTask.battle.removeID);
            }
         }
         if(!battleeffect)
         {
            this.currentTask.battle = null;
            this.spliceView();
         }
      }
      
      private function effectAfterBattle(npcname:String = "") : void
      {
         if(this.currentTask.battle != null && this.currentTask.battle.removeID != 0)
         {
            TaskUtils.getInstance().dispatchEvent(TaskEvent.REMOVESOMETHING,this.currentTask.battle.removeID);
         }
         this.currentTask.battle = null;
         TaskUtils.getInstance().dispatchEvent(TaskEvent.SHOW_OR_HIDE_BOTTOM,false);
         this.spliceView();
      }
      
      private function onNotAccept(spritename:String = "") : void
      {
         this.dispos();
         this.releaseCurrentTask();
      }
      
      private function loadNPCIMG(npcid:int) : void
      {
         var url:String = null;
         var tempXML:XML = null;
         if(npcid == -1 || npcid == -2 || npcid == 43994399)
         {
            if(Boolean(GameData.instance.playerData.roleType & 1))
            {
               url = "assets/dialogimg/half/" + 1 + ".swf";
            }
            else
            {
               url = "assets/dialogimg/half/" + 0 + ".swf";
            }
         }
         else
         {
            if(npcid == 21801 && TaskView.instance.currentNPCID == 21812)
            {
               npcid = 21812;
            }
            tempXML = XMLLocator.getInstance().getNPC(npcid);
            if(tempXML != null)
            {
               url = URLUtil.getSvnVer("assets/dialogimg/half/" + tempXML.enname + ".swf");
            }
            else
            {
               url = URLUtil.getSvnVer("assets/dialogimg/half/jicangzhushou.swf");
            }
         }
         this.loader.load(new URLRequest(url));
      }
      
      private function onLoadImgComplete(evt:Event) : void
      {
         this.loader.x = 153.5 - this.loader.width;
         this.loader.y = 123.7 - this.loader.height;
      }
      
      private function onLoadImgError(evt:IOErrorEvent) : void
      {
         var url:String = URLUtil.getSvnVer("assets/dialogimg/half/jicangzhushou.swf");
         this.loader.load(new URLRequest(url));
      }
      
      private function releaseCurrentTask() : void
      {
         this.currentTask = null;
      }
      
      private function onMouseClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.currentIndex = 0;
         this.mc.close.removeEventListener(MouseEvent.CLICK,this.onMouseClickClose);
         this.dispos();
         if(this.shape.parent != null && this.shape.parent.parent != null)
         {
            O.o("【对话框已经移除了...但是遮罩还在...】");
         }
      }
      
      public function dispos(flag:Boolean = false) : void
      {
         var j:int = 0;
         var leng:int = 0;
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
         if(this.mc == null)
         {
            return;
         }
         this.visible = false;
         if(this.loader != null)
         {
            if(Boolean(this.mc.imgBG.contains(this.loader)))
            {
               this.mc.imgBG.removeChild(this.loader);
            }
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadImgComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadImgError);
            this.loader.unloadAndStop(true);
            this.loader = null;
         }
         if(this.uiLoader != null)
         {
            this.uiLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.uiLoader.unloadAndStop();
            this.uiLoader = null;
         }
         if(this.personSayArr != null)
         {
            j = 0;
            leng = int(this.personSayArr.length);
            for(j = 0; j < leng; j++)
            {
               (this.personSayArr[j] as DialogFunctionItem).dispos();
            }
            this.personSayArr = null;
         }
         this.taskObj = null;
         this.aniEffect = null;
         this.currentIndex = 0;
         this.needSendChoose = 0;
         this.colorList = null;
         this.deleteColorFormatList();
         this.mc.sayTxt.removeEventListener(MouseEvent.CLICK,this.onClickNPCSay);
         if(!flag)
         {
            if(this.currentTask.dialogID > 25 || this.currentTask.dialogID < 21)
            {
               TaskUtils.getInstance().dispatchEvent(TaskEvent.SHOW_OR_HIDE_BOTTOM,true);
            }
            TaskUtils.getInstance().dispatchEvent(TaskEvent.SET_DIALOG_VIEW_FALSE);
         }
      }
      
      private function openPopUp(count:int) : void
      {
         var obj:Object = null;
         this.visible = false;
         this.mc.visible = false;
         var i:int = 0;
         var len:int = int(this.currentTask.otherpopup.length);
         for(i = 0; i < len; i++)
         {
            if(this.currentTask.otherpopup[i].position == count)
            {
               obj = {};
               obj.opdata = this.currentTask.otherpopup[i];
               obj.callback = this.onPopUpBack;
               this.currentTask.otherpopup.splice(i,1);
               if(GameData.instance.playerData.active_status == 1 && this.currentTask.dialogID == 600600201)
               {
                  this.onPopUpBack(null);
               }
               else
               {
                  TaskUtils.getInstance().dispatchEvent(TaskEvent.OPENOTHERPOPUP,obj);
               }
               return;
            }
         }
      }
      
      private function onPopUpBack(params:*) : void
      {
         if(params is Boolean && !params)
         {
            this.onAccept(true);
            return;
         }
         if(params is String && params == "closedialog")
         {
            this.dispos();
            return;
         }
         if(this.currentTask.dialogID == 201600201)
         {
            if(!GameData.instance.playerData.activeTmpData.hasOwnProperty("dialogID"))
            {
               this.dispos();
               return;
            }
         }
         if(this.currentTask.dialogID == 600600201)
         {
            GameDynamicUI.excute("texiao2","gotoAndStop",2,33);
         }
         TaskUtils.getInstance().dispatchEvent(TaskEvent.SHOW_OR_HIDE_BOTTOM,false);
         if(Boolean(this.currentTask.otherpopup) && this.currentTask.otherpopup.length == 0)
         {
            this.currentTask.otherpopup = null;
         }
         if(this.currentTask.describe != null && this.currentTask.describe.length > 0 && this.index < this.totalLength)
         {
            this.spliceView();
         }
         else
         {
            this.onAccept();
         }
      }
      
      private function setFreshManFlag(dialogId:int, subtaskID:int) : void
      {
         if(subtaskID >= 1003001 && subtaskID <= 1003003)
         {
            TaskList.getInstance().freshManTaskFlag = dialogId % 1000;
         }
         else if(subtaskID == 1004002 && dialogId == 100400201 || subtaskID == 1005003 && dialogId == 100500301)
         {
            TaskList.getInstance().freshManTaskFlag = dialogId % 10000000;
         }
         else
         {
            TaskList.getInstance().freshManTaskFlag = 0;
         }
      }
   }
}

