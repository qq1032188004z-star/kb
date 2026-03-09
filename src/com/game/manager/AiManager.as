package com.game.manager
{
   import com.game.modules.view.MapView;
   import com.game.modules.view.person.SpecialArea;
   import com.game.util.IdName;
   
   public class AiManager
   {
      
      private static var _instance:AiManager;
      
      private var _displayArr:Array;
      
      public function AiManager()
      {
         super();
      }
      
      public static function instance() : AiManager
      {
         if(_instance == null)
         {
            _instance = new AiManager();
         }
         return _instance;
      }
      
      public function set displayArr(value:Array) : void
      {
         this._displayArr = value;
      }
      
      public function get displayArr() : Array
      {
         return this._displayArr;
      }
      
      public function specialareaHandler(name:String) : void
      {
         var sp:SpecialArea = null;
         try
         {
            sp = MapView.instance.findGameSprite(name) as SpecialArea;
            sp.operate(true);
         }
         catch(e:*)
         {
            O.o("没找到东西。。。。。AiManager -->  specialareaHandler");
         }
      }
      
      public function npcHnadler() : void
      {
      }
      
      public function masterIsOutSpecialArea(sequenceId:int) : void
      {
         var sp:SpecialArea = null;
         try
         {
            sp = MapView.instance.findGameSprite(IdName.specialArea(sequenceId)) as SpecialArea;
            sp.operate(false);
         }
         catch(e:*)
         {
            O.o("找不到东西。。。。。AiManager --> masterIsOutSpecialArea");
         }
      }
   }
}

