package phpcon
{
   import flash.events.Event;
   
   public class PhpEvent extends Event
   {
      
      public var data:Object;
      
      public function PhpEvent(type:String, params:Object)
      {
         super(type);
         this.data = params;
      }
   }
}

