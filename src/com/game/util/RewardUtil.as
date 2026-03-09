package com.game.util
{
   import com.game.modules.view.WindowLayer;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.XMLLocator;
   
   public class RewardUtil
   {
      
      public function RewardUtil()
      {
         super();
      }
      
      public static function showAward(exp:int = 0, coin:int = 0, cultivate:int = 0, goods:Array = null, callback:Function = null) : void
      {
         var i:int = 0;
         var len:int = 0;
         var str:String = null;
         var showFlag:Boolean = false;
         if(cultivate > 0)
         {
            new AwardAlert().showCultivateAward(cultivate,WindowLayer.instance.stage,callback);
            if(callback != null)
            {
               showFlag = true;
            }
         }
         if(goods != null && goods.length > 0)
         {
            i = 0;
            len = int(goods.length);
            str = "";
            for(i = 0; i < len; i++)
            {
               if(goods[i].id != 0)
               {
                  if(goods[i].type == 1)
                  {
                     try
                     {
                        str = String(XMLLocator.getInstance().getTool(goods[i].id).name);
                     }
                     catch(e:*)
                     {
                        str = goods[i].id + "   不知道是什么";
                     }
                     if(!showFlag && callback != null)
                     {
                        new AwardAlert().showGoodsAward("assets/tool/" + goods[i].id + ".swf",WindowLayer.instance," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",goods[i].number + "个" + str),true,callback);
                        showFlag = true;
                     }
                     else
                     {
                        new AwardAlert().showGoodsAward("assets/tool/" + goods[i].id + ".swf",WindowLayer.instance," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",goods[i].number + "个" + str),true);
                     }
                  }
                  else if(goods[i].type == 2)
                  {
                     try
                     {
                        str = String(XMLLocator.getInstance().getSprited(goods[i].id).name);
                     }
                     catch(e:*)
                     {
                        str = goods[i].id + "   不知道是神马";
                     }
                     if(!showFlag && callback != null)
                     {
                        new AwardAlert().showMonsterAward("assets/monsterimg/" + goods[i].id + ".swf",WindowLayer.instance," 获得 " + str,true,callback);
                        showFlag = true;
                     }
                     else
                     {
                        new AwardAlert().showMonsterAward("assets/monsterimg/" + goods[i].id + ".swf",WindowLayer.instance," 获得 " + str,true);
                     }
                  }
                  else if(goods[i].type == 3)
                  {
                     try
                     {
                        str = String(XMLLocator.getInstance().getTool(goods[i].number).name);
                     }
                     catch(e:*)
                     {
                        str = goods[i].number + "   不知道是什么";
                     }
                     if(!showFlag && callback != null)
                     {
                        new AwardAlert().showMultipleAward(URLUtil.getSvnVer("assets/tool/" + goods[i].id + ".swf"),URLUtil.getSvnVer("assets/tool/" + goods[i].number + ".swf"),WindowLayer.instance," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",str),true,callback);
                        showFlag = true;
                     }
                     else
                     {
                        new AwardAlert().showMultipleAward(URLUtil.getSvnVer("assets/tool/" + goods[i].id + ".swf"),URLUtil.getSvnVer("assets/tool/" + goods[i].number + ".swf"),WindowLayer.instance," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",str),true);
                     }
                  }
                  else if(goods[i].type == 4)
                  {
                     getXiuwei({
                        "xiuweiType":goods[i].id,
                        "xiuweiNum":goods[i].number
                     });
                  }
                  else if(goods[i].type == 5)
                  {
                     str = goods[i].id + "点";
                     new Alert().showOne(" 获得 " + str + "点券， 请注意查看!");
                  }
                  else if(goods[i].type == 6)
                  {
                     try
                     {
                        str = String(XMLLocator.getInstance().getTool(goods[i].id).name);
                     }
                     catch(e:*)
                     {
                        str = goods[i].number + "   不知道是什么";
                     }
                     new AwardAlert().showMultipleAward(URLUtil.getSvnVer("assets/tool/" + goods[i].id + ".swf"),URLUtil.getSvnVer("assets/material/storeage.swf"),WindowLayer.instance," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",str),true);
                  }
               }
            }
         }
         if(coin > 0)
         {
            if(!showFlag && callback != null)
            {
               new AwardAlert().showMoneyAward(coin,WindowLayer.instance,callback);
               showFlag = true;
            }
            else
            {
               new AwardAlert().showMoneyAward(coin,WindowLayer.instance);
            }
         }
         if(exp > 0)
         {
            if(!showFlag && callback != null)
            {
               new AwardAlert().showExpAward(exp,WindowLayer.instance,callback);
            }
            else
            {
               new AwardAlert().showExpAward(exp,WindowLayer.instance);
            }
         }
      }
      
      public static function getXiuwei(param:Object) : void
      {
         var str:String = "获得" + param.xiuweiNum;
         switch(param.xiuweiType)
         {
            case 1:
               str += "攻击";
               break;
            case 2:
               str += "防御";
               break;
            case 3:
               str += "法术";
               break;
            case 4:
               str += "抗性";
               break;
            case 5:
               str += "体力";
               break;
            case 6:
               str += "速度";
         }
         str += "修为，已经放入你的贝贝，请使用贝贝自行分配！";
         new Alert().showOne(str);
      }
   }
}

