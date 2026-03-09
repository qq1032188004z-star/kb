package com.publiccomponent.loading
{
   import com.game.util.LuaObjUtil;
   import com.publiccomponent.loading.data.BufInfoTypeData;
   import com.publiccomponent.loading.data.SiteBuffDescTypeData;
   import com.publiccomponent.loading.data.SiteBuffTypeData;
   import flash.utils.Dictionary;
   import org.green.server.data.ByteArray;
   
   public class XMLLocator
   {
      
      private static var instance:XMLLocator;
      
      private var dealarr:Array = [];
      
      private var dealing:Boolean = false;
      
      public var dailyTask:XML;
      
      private var _errorInfo:XML;
      
      private var _errorInfoDic:Dictionary = new Dictionary();
      
      private var _sprite:XML;
      
      private var _spritedic:Dictionary = new Dictionary();
      
      private var _npcdialog:XML;
      
      private var _npcdialogDic:Dictionary = new Dictionary();
      
      private var _bufInfo:XML;
      
      private var _bufInfoDic:Dictionary = new Dictionary();
      
      private var _siteBuff:XML;
      
      private var _siteBuffDic:Dictionary = new Dictionary();
      
      private var _siteBuffDesc:XML;
      
      private var _siteBuffDescDic:Dictionary = new Dictionary();
      
      private var _npc:XML;
      
      private var _npcdic:Dictionary = new Dictionary();
      
      public var _npctransform:XML;
      
      public var npctransformDic:Dictionary = new Dictionary();
      
      private var _map:XML;
      
      private var scenes:XMLList;
      
      public var mapdic:Dictionary = new Dictionary();
      
      private var _skill:XML;
      
      private var _skilldic:Dictionary = new Dictionary();
      
      private var _tool:XML;
      
      public var tooldic:Dictionary = new Dictionary();
      
      private var _taskInfo:XML;
      
      private var _taskInfoDic:Dictionary = new Dictionary();
      
      private var _nature:XML;
      
      private var _natureDic:Dictionary;
      
      public var otherBA:Dictionary = new Dictionary();
      
      public function XMLLocator()
      {
         super();
         if(instance != null)
         {
            throw new Error("单例类只能被实例化一次");
         }
         instance = this;
      }
      
      public static function getInstance() : XMLLocator
      {
         if(instance == null)
         {
            instance = new XMLLocator();
         }
         return instance;
      }
      
      public function set sprite(value:XML) : void
      {
         this._sprite = value;
      }
      
      private function addsXtD(xv:String, sd:String, tp:int, nk:String = "id") : void
      {
         if(!this.dealing)
         {
            this.dealing = true;
            this.sXtD(xv,sd,tp,nk);
         }
         else
         {
            this.dealarr.push({
               "xv":xv,
               "sd":sd,
               "tp":tp,
               "nk":nk
            });
         }
      }
      
      public function get errorInfo() : XML
      {
         return this._errorInfo;
      }
      
      public function set errorInfo(value:XML) : void
      {
         this._errorInfo = value;
      }
      
      public function get tool() : XML
      {
         return this._tool;
      }
      
      public function set skill(value:XML) : void
      {
         this._skill = value;
      }
      
      public function set tool(value:XML) : void
      {
         this._tool = value;
         this.addsXtD("_tool","tooldic",1,"id");
      }
      
      public function set map(value:XML) : void
      {
         this._map = value;
         this.scenes = value.scenes;
         this.addsXtD("_map","mapdic",1,"id");
         this.addsXtD("scenes","mapdic",1,"id");
      }
      
      public function set npc(value:XML) : void
      {
         this._npc = value;
      }
      
      public function get npctransform() : XML
      {
         return this._npctransform;
      }
      
      public function get skill() : XML
      {
         return this._skill;
      }
      
      public function get sprite() : XML
      {
         return this._sprite;
      }
      
      private function sXtD(xv:String, sd:String, tp:int, nk:String = "id") : void
      {
         var obj:Object = null;
         var i:int = 0;
         var xmllist:XMLList = this[xv].children();
         var l:int = int(xmllist.length());
         if(tp == 1)
         {
            i = 0;
            while(i < l)
            {
               this[sd][int(xmllist[i].attribute(nk))] = xmllist[i];
               i++;
            }
         }
         else if(tp == 2)
         {
            i = 0;
            while(i < l)
            {
               if(int(xmllist[i][nk]) > 0)
               {
                  this[sd][int(xmllist[i][nk])] = xmllist[i];
               }
               i++;
            }
         }
         this.dealing = false;
         if(Boolean(this.dealarr) && this.dealarr.length > 0)
         {
            obj = this.dealarr.shift();
            if(Boolean(obj))
            {
               this.sXtD(obj.xv,obj.sd,obj.tp,obj.nk);
            }
         }
      }
      
      public function spriteitem(value:int) : XML
      {
         return this.getSprited(value);
      }
      
      public function get map() : XML
      {
         return this._map;
      }
      
      public function set npctransform(value:XML) : void
      {
         this._npctransform = value;
         this.addsXtD("_npctransform","npctransformDic",2,"oldid");
      }
      
      public function get npc() : XML
      {
         return this._npc;
      }
      
      public function skillitem(value:int) : XML
      {
         return this.getSkill(value);
      }
      
      public function getOther(key:String) : ByteArray
      {
         var target:ByteArray = null;
         if(this.otherBA.hasOwnProperty(key))
         {
            target = new ByteArray();
            this.otherBA[key].position = 0;
            while(this.otherBA[key].bytesAvailable > 0)
            {
               target.writeByte(this.otherBA[key].readByte());
            }
            return target;
         }
         return null;
      }
      
      public function getSkill(skillid:int) : XML
      {
         if(this._skilldic.hasOwnProperty(skillid.toString()))
         {
            return this._skilldic[skillid];
         }
         this._skilldic[skillid] = this.binarySearchXML2(this._skill.children(),skillid,"idx");
         return this._skilldic[skillid];
      }
      
      public function getSprited(targetId:int) : XML
      {
         if(this._spritedic.hasOwnProperty(targetId.toString()))
         {
            return this._spritedic[targetId];
         }
         this._spritedic[targetId] = this.binarySearchXML(this._sprite.children(),targetId,"id");
         return this._spritedic[targetId];
      }
      
      public function getNature(type:int, key:String, key2:String = "") : Object
      {
         var obj:Object = null;
         var obj2:Object = null;
         if(this._natureDic == null)
         {
            this.natureParser();
         }
         switch(type)
         {
            case 2:
               obj = this._natureDic[type + "-" + key];
               obj2 = this._natureDic[type + "-" + key2];
               if(obj[key2] > obj2[key])
               {
                  return 1;
               }
               if(obj[key2] < obj2[key])
               {
                  return 2;
               }
               return 0;
               break;
            default:
               return this._natureDic[type + "-" + key];
         }
      }
      
      private function natureParser() : void
      {
         var items0:XMLList = null;
         var item0:XML = null;
         var items1:XMLList = null;
         var item1:XML = null;
         var items2:XMLList = null;
         var node:XML = null;
         var personalityObj:Object = null;
         var attributeObj:Object = null;
         var nodeId:int = 0;
         var nodeObj:Object = null;
         var attr:XML = null;
         var attrId:int = 0;
         var effectValue:Number = NaN;
         this._natureDic = new Dictionary();
         items0 = this._nature.items.(@type == "0").item;
         for each(item0 in items0)
         {
            personalityObj = {
               "name":item0.@name,
               "id1":int(item0.@id1),
               "id2":int(item0.@id2),
               "id3":int(item0.@id3),
               "id4":int(item0.@id4),
               "id5":int(item0.@id5),
               "tips":item0.@tips
            };
            this._natureDic["0-" + personalityObj.name] = personalityObj;
         }
         items1 = this._nature.items.(@type == "1").item;
         for each(item1 in items1)
         {
            attributeObj = {
               "name":item1.@name,
               "tips1":item1.@tips1,
               "tips2":item1.@tips2
            };
            this._natureDic["1-" + attributeObj.name] = attributeObj;
         }
         items2 = this._nature.items.(@type == "2").node;
         for each(node in items2)
         {
            nodeId = int(node.@id);
            nodeObj = {};
            for each(attr in node.attr)
            {
               attrId = int(attr.@id);
               effectValue = Number(attr.@effectValue);
               nodeObj[attrId] = effectValue;
            }
            this._natureDic["2-" + nodeId] = nodeObj;
         }
      }
      
      public function getSiteDesc(targetId:int) : SiteBuffDescTypeData
      {
         var td:SiteBuffDescTypeData = null;
         if(this._siteBuffDescDic.hasOwnProperty(targetId.toString()))
         {
            return this._siteBuffDescDic[targetId];
         }
         var xml:XML = this.binarySearchXML(this._siteBuffDesc.children(),targetId,"id");
         if(Boolean(xml))
         {
            td = new SiteBuffDescTypeData();
            td.id = int(xml.@id);
            td.desc = String(xml.desc);
            this._siteBuffDescDic[targetId] = td;
         }
         else
         {
            this._siteBuffDescDic[targetId] = null;
         }
         return this._siteBuffDescDic[targetId];
      }
      
      public function getSiteInfo(targetId:int) : SiteBuffTypeData
      {
         var td:SiteBuffTypeData = null;
         if(this._siteBuffDic.hasOwnProperty(targetId.toString()))
         {
            return this._siteBuffDic[targetId];
         }
         var xml:XML = this.binarySearchXML(this._siteBuff.children(),targetId,"id");
         if(Boolean(xml))
         {
            td = new SiteBuffTypeData();
            td.id = int(xml.@id);
            td.name = String(xml.name);
            td.monster_desc = LuaObjUtil.getLuaObj(String(xml.monster_desc));
            this._siteBuffDic[targetId] = td;
         }
         else
         {
            this._siteBuffDic[targetId] = null;
         }
         return this._siteBuffDic[targetId];
      }
      
      public function getBufInfo(targetId:int) : BufInfoTypeData
      {
         var td:BufInfoTypeData = null;
         if(this._bufInfoDic.hasOwnProperty(targetId.toString()))
         {
            return this._bufInfoDic[targetId];
         }
         var xml:XML = this.binarySearchXML(this._bufInfo.children(),targetId,"id");
         if(Boolean(xml))
         {
            td = new BufInfoTypeData();
            td.id = int(xml.@id);
            td.name = String(xml.name);
            td.combat_desc = String(xml.combat_desc);
            if(Boolean(xml.hasOwnProperty("other_desc")))
            {
               td.other_desc = LuaObjUtil.getLuaObj(String(xml.other_desc));
            }
            if(Boolean(xml.hasOwnProperty("no_buf_blood")))
            {
               td.no_buf_blood = int(xml.no_buf_blood);
            }
            if(Boolean(xml.hasOwnProperty("hide")))
            {
               td.hide = int(xml.hide);
            }
            if(Boolean(xml.hasOwnProperty("buf_blood_desc")))
            {
               td.buf_blood_desc = String(xml.buf_blood_desc);
            }
            if(Boolean(xml.hasOwnProperty("other")))
            {
               td.other = LuaObjUtil.getLuaObj(String(xml.other));
            }
            this._bufInfoDic[targetId] = td;
         }
         else
         {
            this._bufInfoDic[targetId] = null;
         }
         return this._bufInfoDic[targetId];
      }
      
      public function getNPC(npcid:int) : XML
      {
         if(this._npcdic.hasOwnProperty(npcid.toString()))
         {
            return this._npcdic[npcid];
         }
         this._npcdic[npcid] = this.binarySearchXML(this._npc.children(),npcid,"id");
         return this._npcdic[npcid];
      }
      
      public function getTool(toolid:int) : XML
      {
         if(this.tooldic.hasOwnProperty(toolid.toString()))
         {
            return this.tooldic[toolid];
         }
         this.tooldic[toolid] = this.binarySearchXML(this._tool.children(),toolid,"id");
         return this.tooldic[toolid];
      }
      
      private function binarySearchXML(xmlList:XMLList, targetId:int, key:String) : XML
      {
         var mid:int = 0;
         var currentItem:XML = null;
         var currentId:int = 0;
         var low:int = 0;
         var high:int = xmlList.length() - 1;
         while(low <= high)
         {
            mid = Math.floor((low + high) / 2);
            currentItem = xmlList[mid];
            currentId = int(currentItem.attribute(key));
            if(currentId == targetId)
            {
               return currentItem;
            }
            if(currentId < targetId)
            {
               low = mid + 1;
            }
            else
            {
               high = mid - 1;
            }
         }
         return null;
      }
      
      private function binarySearchXML2(xmlList:XMLList, targetId:int, key:String) : XML
      {
         var mid:int = 0;
         var currentItem:XML = null;
         var currentId:int = 0;
         var low:int = 0;
         var high:int = xmlList.length() - 1;
         while(low <= high)
         {
            mid = Math.floor((low + high) / 2);
            currentItem = xmlList[mid];
            currentId = int(currentItem[key]);
            if(currentId == targetId)
            {
               return currentItem;
            }
            if(currentId < targetId)
            {
               low = mid + 1;
            }
            else
            {
               high = mid - 1;
            }
         }
         return null;
      }
      
      public function getMap(mapid:int) : XML
      {
         var x:XML;
         if(this.mapdic.hasOwnProperty(mapid.toString()))
         {
            return this.mapdic[mapid];
         }
         x = this._map.child("scenes").(attribute("id") == "-1").children().(attribute("id") == mapid.toString())[0];
         this.mapdic[mapid] = x;
         return x;
      }
      
      public function getTaskInfo(taskid:int) : XML
      {
         if(this._taskInfoDic.hasOwnProperty(taskid.toString()))
         {
            return this._taskInfoDic[taskid];
         }
         this._taskInfoDic[taskid] = this.binarySearchXML(this._taskInfo.children(),taskid,"id");
         return this._taskInfoDic[taskid];
      }
      
      public function set nature(value:XML) : void
      {
         this._nature = value;
      }
      
      public function set siteBuff(value:XML) : void
      {
         this._siteBuff = value;
      }
      
      public function set siteBuffDesc(value:XML) : void
      {
         this._siteBuffDesc = value;
      }
      
      public function set bufInfo(value:XML) : void
      {
         this._bufInfo = value;
      }
      
      public function get npcdialog() : XML
      {
         return this._npcdialog;
      }
      
      public function set npcdialog(value:XML) : void
      {
         this._npcdialog = value;
      }
      
      public function getNPCDialogDic(targetId:int) : XML
      {
         if(this._npcdialogDic.hasOwnProperty(targetId.toString()))
         {
            return this._npcdialogDic[targetId];
         }
         this._npcdialogDic[targetId] = this.binarySearchXML(this._npcdialog.children(),targetId,"id");
         return this._npcdialogDic[targetId];
      }
      
      public function getErrofInfo(targetId:int) : XML
      {
         if(this._errorInfoDic.hasOwnProperty(targetId.toString()))
         {
            return this._errorInfoDic[targetId];
         }
         this._errorInfoDic[targetId] = this.binarySearchXML(this._errorInfo.children(),targetId,"id");
         return this._errorInfoDic[targetId];
      }
      
      public function get taskInfo() : XML
      {
         return this._taskInfo;
      }
      
      public function set taskInfo(value:XML) : void
      {
         this._taskInfo = value;
      }
   }
}

