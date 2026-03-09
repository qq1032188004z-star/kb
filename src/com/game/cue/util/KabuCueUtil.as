package com.game.cue.util
{
   import com.game.cue.base.CueEnum;
   import com.game.cue.base.CuePath;
   import com.game.cue.intf.ICueBase;
   import com.game.cue.view.CueNotCoin;
   import com.game.cue.view.CueNotKbCoin;
   import com.game.locators.CacheData;
   import com.game.modules.view.WindowLayer;
   import com.game.util.AwardAlert;
   import com.game.util.FloatAlert;
   import com.game.util.HtmlUtil;
   import com.game.util.ToolTipStringUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import flash.display.DisplayObjectContainer;
   
   public class KabuCueUtil
   {
      
      private static var _instance:KabuCueUtil;
      
      public function KabuCueUtil()
      {
         super();
      }
      
      public static function get instance() : KabuCueUtil
      {
         if(_instance == null)
         {
            _instance = new KabuCueUtil();
         }
         return _instance;
      }
      
      public function showOtherCue($cueIndex:int, $cueName:String, $container:DisplayObjectContainer = null, $data:Object = null) : void
      {
         var cue:ICueBase = null;
         var url:String = null;
         if($container == null)
         {
            $container = WindowLayer.instance;
         }
         switch($cueIndex)
         {
            case CueEnum.CUE_NOT_COIN:
               cue = new CueNotCoin();
               break;
            case CueEnum.CUE_NOT_KBCOIN:
               cue = new CueNotKbCoin();
         }
         if(Boolean(cue))
         {
            url = CuePath.ROOT_PATH + $cueName;
            cue.build(url,$container,$data);
         }
      }
      
      public function showAwardCue($cueIndex:int, $data:Object, $container:DisplayObjectContainer = null) : void
      {
         var url:String = null;
         var msg:String = null;
         var cue:AwardAlert = new AwardAlert();
         var id:int = int($data.id);
         var value:int = $data.hasOwnProperty("value") ? int($data.value) : 1;
         var callback:Function = $data.hasOwnProperty("callback") ? $data.callback : null;
         switch($cueIndex)
         {
            case CueEnum.CUE_AWARD_EXP:
               cue.showExpAward($data.value,$container,$data.callback);
               break;
            case CueEnum.CUE_AWARD_MONEY:
               cue.showMoneyAward($data.value,$container);
               break;
            case CueEnum.CUE_AWARD_MONSTER:
               url = this.toSvnSerString(CuePath.MONSTER_PATH + id + ".swf");
               msg = "恭喜你，获得" + HtmlUtil.getHtmlText(12,"#FF0000",value + "只" + CacheData.instance.monsterIntroList.getMonsterIntroById(id).name);
               cue.showMonsterAward(url,$container,msg,true,callback);
               break;
            case CueEnum.CUE_AWARD_GOOD:
               url = this.toSvnSerString(CuePath.TOOL_PATH + id + ".swf");
               msg = "恭喜你，获得" + HtmlUtil.getHtmlText(12,"#FF0000",value + "个" + ToolTipStringUtil.getToolName(id));
               cue.showGoodsAward(url,$container,msg,true,callback,id);
         }
      }
      
      public function showMsg($type:int, $msg:String, $params:Object = null) : void
      {
         var data:Object = null;
         var linkHandler:Function = null;
         var speed:int = 0;
         var floatDistance:Number = NaN;
         var func:Function = $params != null && Boolean($params.hasOwnProperty("callback")) ? $params.callback : null;
         switch($type)
         {
            case CueEnum.CUE_ALERT_COMMON:
               new Alert().show($msg,func);
               break;
            case CueEnum.CUE_ALERT_SUREORCANCEL:
               data = $params != null && Boolean($params.hasOwnProperty("data")) ? $params.data : null;
               linkHandler = $params != null && Boolean($params.hasOwnProperty("linkHandler")) ? $params.linkHandler : null;
               new Alert().showSureOrCancel($msg,func,data,linkHandler);
               break;
            case CueEnum.CUE_ALERT_FLOAT:
               speed = $params != null && Boolean($params.hasOwnProperty("speed")) ? int($params.speed) : 3;
               floatDistance = $params != null && Boolean($params.hasOwnProperty("floatDistance")) ? Number($params.floatDistance) : 100;
               new FloatAlert().show(WindowLayer.instance,350,250,$msg,speed,floatDistance);
         }
      }
      
      private function toSvnSerString($path:String) : String
      {
         return URLUtil.getSvnVer($path);
      }
   }
}

