package com.kb.util
{
   import com.kb.components.list.CommonRankData;
   import com.kb.components.list.CommonRankItemData;
   import org.green.server.data.ByteArray;
   
   public class CommonRankUtil
   {
      
      public function CommonRankUtil()
      {
         super();
      }
      
      public static function transformation(ba:ByteArray) : CommonRankData
      {
         var rank:int = 0;
         var item:CommonRankItemData = null;
         var rankData:CommonRankData = new CommonRankData();
         rankData.uid = ba.readInt();
         rankData.myRank = ba.readInt();
         rankData.curPage = ba.readInt();
         rankData.maxPage = ba.readInt();
         rankData.curPageLen = ba.readInt();
         rankData.curPageAry = new Vector.<CommonRankItemData>();
         for(var i:int = 0; i < rankData.curPageLen; i++)
         {
            rank = ba.readInt();
            if(rank <= 0)
            {
               break;
            }
            item = new CommonRankItemData();
            item.rank = rank;
            item.socre = ba.readInt();
            item.other = ba.readUTF();
            rankData.curPageAry.push(item);
         }
         return rankData;
      }
   }
}

