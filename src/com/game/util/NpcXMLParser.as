package com.game.util
{
   import com.game.modules.vo.NPCVo;
   import com.publiccomponent.loading.XMLLocator;
   
   public class NpcXMLParser
   {
      
      public function NpcXMLParser()
      {
         super();
      }
      
      public static function parse(npcid:int) : NPCVo
      {
         var node:XML = null;
         var param:NPCVo = null;
         node = XMLLocator.getInstance().getNPC(npcid);
         if(node != null)
         {
            param = new NPCVo();
            param.x = int(node.@x);
            param.y = int(node.@y);
            param.special = int(node.special);
            param.enname = node.enname;
            param.istask = int(node.istask);
            param.mapid = int(node.mapid);
            param.url = node.url;
            param.sequenceID = npcid;
            param.name = node.name.toString();
            param.type = int(node.type);
            try
            {
               if(Boolean(node.hasOwnProperty("sex")))
               {
                  param.sexual = int(node.sex);
               }
               if(Boolean(node.hasOwnProperty("watchURL")))
               {
                  param.watchURL = node.watchURL.toString();
               }
               param.dymaicY = int(node.@dynamicY);
               if(Boolean(node.@tx) && Number(node.@tx) > 0)
               {
                  param.targetx = Number(node.@tx);
               }
               if(Boolean(node.@ty) && Number(node.@ty) > 0)
               {
                  param.targety = Number(node.@ty);
               }
               if(Boolean(node.@removeid) && node.@removeid.toString().length > 0)
               {
                  param.removeNPCList = makeRemoveList(node.@removeid.toString());
               }
            }
            catch(e:*)
            {
            }
         }
         return param;
      }
      
      public static function makeRemoveList(str:String) : Array
      {
         var rtmparr:Array = str.split(",");
         var i:int = 0;
         var len:int = int(rtmparr.length);
         for(i = 0; i < len; i++)
         {
            rtmparr[i] = int(rtmparr[i]);
         }
         return rtmparr;
      }
   }
}

