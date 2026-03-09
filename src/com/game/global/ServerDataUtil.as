package com.game.global
{
   import com.game.manager.AlertManager;
   
   public class ServerDataUtil
   {
      
      public function ServerDataUtil()
      {
         super();
      }
      
      public static function getRewardInfo(rewardObj:Object) : BonusInfo
      {
         var itemType:int = int(rewardObj["itemtype"]);
         var id:int = int(rewardObj["itemid"]);
         var num:int = int(rewardObj["itemnum"]);
         var rewardName:String = "";
         var toolId:int = 0;
         switch(itemType)
         {
            case ItemType.ITEM_TYPE_COIN:
               toolId = int(ItemType.TOOL_KEY_ID[itemType]);
               break;
            case ItemType.ITEM_TYPE_EXP:
               toolId = int(ItemType.TOOL_KEY_ID[itemType]);
               break;
            case ItemType.ITEM_TYPE_PRACTICE:
               toolId = int(ItemType.PRACTICE_LIST[id]);
               break;
            case ItemType.ITEM_TYPE_RAND_PRACTICE:
               toolId = int(ItemType.TOOL_KEY_ID[itemType]);
               break;
            case ItemType.ITEM_TYPE_RAND_HLD:
               toolId = int(ItemType.TOOL_KEY_ID[itemType]);
               break;
            case ItemType.ITEM_TYPE_SXXSD:
               toolId = int(ItemType.TOOL_KEY_ID[itemType]);
               break;
            case ItemType.ITEM_TYPE_PROP_NORMAL:
               toolId = id;
               break;
            case ItemType.ITEM_TYPE_PROP_SGHALL:
               toolId = id;
               break;
            case ItemType.ITEM_TYPE_PROP_FARM:
               toolId = id;
               break;
            case ItemType.ITEM_TYPE_MONSTER:
               toolId = id;
               break;
            case ItemType.ITEM_TYPE_VIP_TIME:
               toolId = id;
               break;
            case ItemType.ITEM_TYPE_MAX:
               toolId = id;
               break;
            case ItemType.ITEM_TYPE_ACT_MEDAL:
               toolId = int(ItemType.TOOL_KEY_ID[itemType]);
         }
         var bonusInfo:BonusInfo = new BonusInfo();
         bonusInfo.toolid = toolId;
         bonusInfo.itemType = itemType;
         bonusInfo.num = num;
         return bonusInfo;
      }
      
      public static function showBonusList(bonus:Object) : Vector.<BonusInfo>
      {
         var bonusInfo:BonusInfo = null;
         var value:Object = null;
         var bonusList:Vector.<BonusInfo> = new Vector.<BonusInfo>();
         if(Boolean(bonus))
         {
            for each(value in bonus)
            {
               if(value)
               {
                  bonusInfo = getRewardInfo(value);
                  bonusList.push(bonusInfo);
               }
            }
         }
         return bonusList;
      }
      
      public static function showAwardAlert(bonus:Object) : void
      {
         var bonusInfo:BonusInfo = null;
         var bonusList:Vector.<BonusInfo> = showBonusList(bonus);
         for(var i:int = 0; i < bonusList.length; i++)
         {
            bonusInfo = bonusList[i];
            if(bonusInfo.itemType == ItemType.ITEM_TYPE_EXP)
            {
               AlertManager.instance.showAwardAlert({"exp":bonusInfo.num});
            }
            else if(bonusInfo.itemType == ItemType.ITEM_TYPE_COIN)
            {
               AlertManager.instance.showAwardAlert({"money":bonusInfo.num});
            }
            else if(bonusInfo.itemType == ItemType.ITEM_TYPE_MONSTER)
            {
               AlertManager.instance.showAwardAlert({"monsterid":bonusInfo.toolid});
            }
            else
            {
               AlertManager.instance.showAwardAlert({
                  "toolid":bonusInfo.toolid,
                  "num":bonusInfo.num
               });
            }
         }
      }
   }
}

