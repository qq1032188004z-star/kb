package caurina.transitions
{
   public class TweenListObj
   {
      
      public var hasStarted:Boolean;
      
      public var onUpdate:Function;
      
      public var useFrames:Boolean;
      
      public var count:Number;
      
      public var onOverwriteParams:Array;
      
      public var timeStart:Number;
      
      public var timeComplete:Number;
      
      public var onStartParams:Array;
      
      public var onUpdateScope:Object;
      
      public var rounded:Boolean;
      
      public var onUpdateParams:Array;
      
      public var properties:Object;
      
      public var onComplete:Function;
      
      public var transitionParams:Object;
      
      public var updatesSkipped:Number;
      
      public var onStart:Function;
      
      public var onOverwriteScope:Object;
      
      public var skipUpdates:Number;
      
      public var onStartScope:Object;
      
      public var scope:Object;
      
      public var isCaller:Boolean;
      
      public var timePaused:Number;
      
      public var transition:Function;
      
      public var onCompleteParams:Array;
      
      public var onError:Function;
      
      public var timesCalled:Number;
      
      public var onErrorScope:Object;
      
      public var onOverwrite:Function;
      
      public var isPaused:Boolean;
      
      public var waitFrames:Boolean;
      
      public var onCompleteScope:Object;
      
      public function TweenListObj(p_scope:Object, p_timeStart:Number, p_timeComplete:Number, p_useFrames:Boolean, p_transition:Function, p_transitionParams:Object)
      {
         super();
         scope = p_scope;
         timeStart = p_timeStart;
         timeComplete = p_timeComplete;
         useFrames = p_useFrames;
         transition = p_transition;
         transitionParams = p_transitionParams;
         properties = new Object();
         isPaused = false;
         timePaused = undefined;
         isCaller = false;
         updatesSkipped = 0;
         timesCalled = 0;
         skipUpdates = 0;
         hasStarted = false;
      }
      
      public static function makePropertiesChain(p_obj:Object) : Object
      {
         var chainedObject:Object = null;
         var chain:Object = null;
         var currChainObj:Object = null;
         var len:Number = NaN;
         var i:Number = NaN;
         var k:Number = NaN;
         var baseObject:Object = p_obj.base;
         if(Boolean(baseObject))
         {
            chainedObject = {};
            if(baseObject is Array)
            {
               chain = [];
               k = 0;
               while(k < baseObject.length)
               {
                  chain.push(baseObject[k]);
                  k++;
               }
            }
            else
            {
               chain = [baseObject];
            }
            chain.push(p_obj);
            len = Number(chain.length);
            for(i = 0; i < len; i++)
            {
               if(Boolean(chain[i]["base"]))
               {
                  currChainObj = AuxFunctions.concatObjects(makePropertiesChain(chain[i]["base"]),chain[i]);
               }
               else
               {
                  currChainObj = chain[i];
               }
               chainedObject = AuxFunctions.concatObjects(chainedObject,currChainObj);
            }
            if(Boolean(chainedObject["base"]))
            {
               delete chainedObject["base"];
            }
            return chainedObject;
         }
         return p_obj;
      }
      
      public function clone(omitEvents:Boolean) : TweenListObj
      {
         var pName:String = null;
         var nTween:TweenListObj = new TweenListObj(scope,timeStart,timeComplete,useFrames,transition,transitionParams);
         nTween.properties = new Array();
         for(pName in properties)
         {
            nTween.properties[pName] = properties[pName].clone();
         }
         nTween.skipUpdates = skipUpdates;
         nTween.updatesSkipped = updatesSkipped;
         if(!omitEvents)
         {
            nTween.onStart = onStart;
            nTween.onUpdate = onUpdate;
            nTween.onComplete = onComplete;
            nTween.onOverwrite = onOverwrite;
            nTween.onError = onError;
            nTween.onStartParams = onStartParams;
            nTween.onUpdateParams = onUpdateParams;
            nTween.onCompleteParams = onCompleteParams;
            nTween.onOverwriteParams = onOverwriteParams;
            nTween.onStartScope = onStartScope;
            nTween.onUpdateScope = onUpdateScope;
            nTween.onCompleteScope = onCompleteScope;
            nTween.onOverwriteScope = onOverwriteScope;
            nTween.onErrorScope = onErrorScope;
         }
         nTween.rounded = rounded;
         nTween.isPaused = isPaused;
         nTween.timePaused = timePaused;
         nTween.isCaller = isCaller;
         nTween.count = count;
         nTween.timesCalled = timesCalled;
         nTween.waitFrames = waitFrames;
         nTween.hasStarted = hasStarted;
         return nTween;
      }
      
      public function toString() : String
      {
         var i:String = null;
         var returnStr:String = "\n[TweenListObj ";
         returnStr += "scope:" + String(scope);
         returnStr += ", properties:";
         var isFirst:Boolean = true;
         for(i in properties)
         {
            if(!isFirst)
            {
               returnStr += ",";
            }
            returnStr += "[name:" + properties[i].name;
            returnStr += ",valueStart:" + properties[i].valueStart;
            returnStr += ",valueComplete:" + properties[i].valueComplete;
            returnStr += "]";
            isFirst = false;
         }
         returnStr += ", timeStart:" + String(timeStart);
         returnStr += ", timeComplete:" + String(timeComplete);
         returnStr += ", useFrames:" + String(useFrames);
         returnStr += ", transition:" + String(transition);
         returnStr += ", transitionParams:" + String(transitionParams);
         if(Boolean(skipUpdates))
         {
            returnStr += ", skipUpdates:" + String(skipUpdates);
         }
         if(Boolean(updatesSkipped))
         {
            returnStr += ", updatesSkipped:" + String(updatesSkipped);
         }
         if(Boolean(onStart))
         {
            returnStr += ", onStart:" + String(onStart);
         }
         if(Boolean(onUpdate))
         {
            returnStr += ", onUpdate:" + String(onUpdate);
         }
         if(Boolean(onComplete))
         {
            returnStr += ", onComplete:" + String(onComplete);
         }
         if(Boolean(onOverwrite))
         {
            returnStr += ", onOverwrite:" + String(onOverwrite);
         }
         if(Boolean(onError))
         {
            returnStr += ", onError:" + String(onError);
         }
         if(Boolean(onStartParams))
         {
            returnStr += ", onStartParams:" + String(onStartParams);
         }
         if(Boolean(onUpdateParams))
         {
            returnStr += ", onUpdateParams:" + String(onUpdateParams);
         }
         if(Boolean(onCompleteParams))
         {
            returnStr += ", onCompleteParams:" + String(onCompleteParams);
         }
         if(Boolean(onOverwriteParams))
         {
            returnStr += ", onOverwriteParams:" + String(onOverwriteParams);
         }
         if(Boolean(onStartScope))
         {
            returnStr += ", onStartScope:" + String(onStartScope);
         }
         if(Boolean(onUpdateScope))
         {
            returnStr += ", onUpdateScope:" + String(onUpdateScope);
         }
         if(Boolean(onCompleteScope))
         {
            returnStr += ", onCompleteScope:" + String(onCompleteScope);
         }
         if(Boolean(onOverwriteScope))
         {
            returnStr += ", onOverwriteScope:" + String(onOverwriteScope);
         }
         if(Boolean(onErrorScope))
         {
            returnStr += ", onErrorScope:" + String(onErrorScope);
         }
         if(rounded)
         {
            returnStr += ", rounded:" + String(rounded);
         }
         if(isPaused)
         {
            returnStr += ", isPaused:" + String(isPaused);
         }
         if(Boolean(timePaused))
         {
            returnStr += ", timePaused:" + String(timePaused);
         }
         if(isCaller)
         {
            returnStr += ", isCaller:" + String(isCaller);
         }
         if(Boolean(count))
         {
            returnStr += ", count:" + String(count);
         }
         if(Boolean(timesCalled))
         {
            returnStr += ", timesCalled:" + String(timesCalled);
         }
         if(waitFrames)
         {
            returnStr += ", waitFrames:" + String(waitFrames);
         }
         if(hasStarted)
         {
            returnStr += ", hasStarted:" + String(hasStarted);
         }
         return returnStr + "]\n";
      }
   }
}

