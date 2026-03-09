package com.game.comm.model
{
   import com.core.model.Model;
   import com.game.comm.AlertUtil;
   import com.game.comm.enum.AlertMessageConst;
   import com.game.comm.event.ActEventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.view.WindowLayer;
   import com.game.util.FloatAlert;
   import com.publiccomponent.alert.Alert;
   import org.green.server.data.ByteArray;
   import org.green.server.events.MsgEvent;
   
   public class ActComponentModel extends Model
   {
      
      public static const NAME:String = "actComponent_model";
      
      private var _body:ByteArray;
      
      private var _protocolId:int;
      
      private var _isRegister:Boolean;
      
      public function ActComponentModel(isRegister:Boolean = true)
      {
         this._isRegister = isRegister;
         super(NAME);
      }
      
      override public function onRegister() : void
      {
         if(this._isRegister)
         {
            con.attachSocketListener(AlertMessageConst.ACTIVE_COMPONENT.back,this.onActiveDataBack);
         }
      }
      
      override public function onRemove() : void
      {
         if(this._isRegister)
         {
            con.removeSocketListener(AlertMessageConst.ACTIVE_COMPONENT.back,this.onActiveDataBack);
         }
      }
      
      private function onActiveDataBack(evt:MsgEvent) : void
      {
         var mParams:int = evt.msg.mParams;
         var actId:int = AlertMessageConst.DEFAULT_ACTID > 0 ? AlertMessageConst.DEFAULT_ACTID : AlertMessageConst.MPARAMS;
         if(mParams == actId)
         {
            this._body = evt.msg.body;
            evt.msg.body.position = 0;
            this._protocolId = this._body.readInt();
            this.handleData();
         }
      }
      
      private function handleData() : void
      {
         var params:Object = null;
         var typeStr:String = null;
         params = new Object();
         switch(this._protocolId)
         {
            case AlertMessageConst.SPEED_CD:
               if(AlertMessageConst.DEFAULT_ACTID > 0)
               {
                  params.defaultid = this._body.readInt();
               }
               params.result = this._body.readInt();
               params.CDTime = this._body.readInt();
               params.cleanTime = this._body.readInt();
               if(params.result == 1)
               {
                  AlertUtil.showNoKbCoinView(true);
               }
               else
               {
                  if(params.result == 0)
                  {
                     new FloatAlert().show(WindowLayer.instance,250,400,"扣除 " + params.cleanTime + " 卡布币，成功补充体力！");
                  }
                  else if(params.result == 2)
                  {
                     new FloatAlert().show(WindowLayer.instance,250,400,"在游戏中");
                  }
                  else if(params.result == 3)
                  {
                     new FloatAlert().show(WindowLayer.instance,250,400,"不需要冷却");
                  }
                  else if(params.result == 4)
                  {
                     new FloatAlert().show(WindowLayer.instance,250,400,"补充体力失败");
                  }
                  ApplicationFacade.getInstance().dispatch(ActEventConst.SPEED_CD_BACK,params);
               }
               break;
            case AlertMessageConst.BUY_GOURD:
               params.result = this._body.readInt();
               params.gourdType = this._body.readInt();
               params.gourdNum = this._body.readInt();
               typeStr = params.gourdType == 1 ? "普通葫芦" : (params.gourdType == 2 ? "青铜葫芦" : "黄金葫芦");
               if(params.result == 1)
               {
                  new FloatAlert().show(WindowLayer.instance,250,400,"你背包中的" + typeStr + "已经达到上限，赶快去使用吧！");
               }
               else if(params.result == 2)
               {
                  if(params.gourdType == 3)
                  {
                     AlertUtil.showNoKbCoinView();
                  }
                  else
                  {
                     AlertUtil.showNoCopperView();
                  }
               }
               break;
            default:
               new Alert().show("活动数据异常 " + this._protocolId + ", 请联系客服");
         }
      }
   }
}

