package com.game.modules.control.task
{
   import flash.events.Event;
   
   public class TaskEvent extends Event
   {
      
      public static const TASKFINISHED:String = "taskfinisedevent";
      
      public static const RESETDESCRIBE:String = "resetdescribe";
      
      public static const DIALOGFINISHED:String = "dialogfinished";
      
      public static const PLAYANIMATION:String = "playanimation";
      
      public static const SENDTOOTHERSCENE:String = "sendtootherscene";
      
      public static const STARTBATTLE:String = "startbattle";
      
      public static const REMOVESOMETHING:String = "removesomething";
      
      public static const OPENOTHERPOPUP:String = "openotherpopup";
      
      public static const OPENDIALOG:String = "opendialog";
      
      public static const DAILYTASKOPINNOTDAILY:String = "dailytaskopinnotdaily";
      
      public static const OP_TASKMACHINE:String = "optaskmachine";
      
      public static const OP_MOUSE_ACTION_AI:String = "opmouseactionai";
      
      public static const OP_UPDATE_DAILY_TASK:String = "opupdatedailytask";
      
      public static const SHOW_OR_HIDE_BOTTOM:String = "showorhidebottom";
      
      public static const NEED_SPECIAL_OP_TO_VIEW:String = "needspecialoptoview";
      
      public static const SET_DIALOG_VIEW_FALSE:String = "setdialogviewfalse";
      
      public static const PLAY_NPC_EFFECT:String = "playnpceffect";
      
      private var params_:*;
      
      public function TaskEvent(type:String, param:*)
      {
         super(type);
         this.params_ = param;
      }
      
      public function get param() : *
      {
         return this.params_;
      }
   }
}

