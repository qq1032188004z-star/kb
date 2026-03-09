package caurina.transitions
{
   public class PropertyInfoObj
   {
      
      public var modifierParameters:Array;
      
      public var isSpecialProperty:Boolean;
      
      public var valueComplete:Number;
      
      public var modifierFunction:Function;
      
      public var extra:Object;
      
      public var valueStart:Number;
      
      public var hasModifier:Boolean;
      
      public var arrayIndex:Number;
      
      public var originalValueComplete:Object;
      
      public function PropertyInfoObj(p_valueStart:Number, p_valueComplete:Number, p_originalValueComplete:Object, p_arrayIndex:Number, p_extra:Object, p_isSpecialProperty:Boolean, p_modifierFunction:Function, p_modifierParameters:Array)
      {
         super();
         valueStart = p_valueStart;
         valueComplete = p_valueComplete;
         originalValueComplete = p_originalValueComplete;
         arrayIndex = p_arrayIndex;
         extra = p_extra;
         isSpecialProperty = p_isSpecialProperty;
         hasModifier = Boolean(p_modifierFunction);
         modifierFunction = p_modifierFunction;
         modifierParameters = p_modifierParameters;
      }
      
      public function toString() : String
      {
         var returnStr:String = "\n[PropertyInfoObj ";
         returnStr += "valueStart:" + String(valueStart);
         returnStr += ", ";
         returnStr += "valueComplete:" + String(valueComplete);
         returnStr += ", ";
         returnStr += "originalValueComplete:" + String(originalValueComplete);
         returnStr += ", ";
         returnStr += "arrayIndex:" + String(arrayIndex);
         returnStr += ", ";
         returnStr += "extra:" + String(extra);
         returnStr += ", ";
         returnStr += "isSpecialProperty:" + String(isSpecialProperty);
         returnStr += ", ";
         returnStr += "hasModifier:" + String(hasModifier);
         returnStr += ", ";
         returnStr += "modifierFunction:" + String(modifierFunction);
         returnStr += ", ";
         returnStr += "modifierParameters:" + String(modifierParameters);
         return returnStr + "]\n";
      }
      
      public function clone() : PropertyInfoObj
      {
         return new PropertyInfoObj(valueStart,valueComplete,originalValueComplete,arrayIndex,extra,isSpecialProperty,modifierFunction,modifierParameters);
      }
   }
}

