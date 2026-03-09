package fl.data
{
   public dynamic class SimpleCollectionItem
   {
      
      [Inspectable]
      public var label:String;
      
      [Inspectable]
      public var data:String;
      
      public function SimpleCollectionItem()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[SimpleCollectionItem: " + label + "," + data + "]";
      }
   }
}

