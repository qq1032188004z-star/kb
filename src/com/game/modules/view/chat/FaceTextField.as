package com.game.modules.view.chat
{
   import com.publiccomponent.loading.MaterialLib;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.*;
   
   public class FaceTextField extends Sprite
   {
      
      private static var _reg:RegExp;
      
      public static var _dict:Dictionary;
      
      private static const _lt:String = "/:";
      
      private var _fmtName:TextFormat;
      
      private var _fmtMsg:TextFormat;
      
      public var _txtField:TextField;
      
      public var lineHeight:Number;
      
      public var _spriteContainer:Sprite;
      
      private var _defaultTextFormat:TextFormat;
      
      private var _length:int;
      
      private var _spriteVspace:int;
      
      private var _spriteHspace:int;
      
      private var _selectBegin:int;
      
      private var _selectEnd:int;
      
      private var _replacing:Boolean;
      
      private var _widthTxt:uint;
      
      private var _bCenter:Boolean;
      
      private var PLACEHOLDER:String = "○";
      
      private var PLACEHOLDER_FONT:String = "Arial";
      
      private var PLACEHOLDER_COLOR:uint = 0;
      
      public function FaceTextField(width:Number, center:Boolean = false)
      {
         super();
         this._fmtName = new TextFormat("Arial",12,16711680,true);
         this._fmtMsg = new TextFormat("Courier New",12,16777215,false);
         this._bCenter = center;
         if(center)
         {
            this._fmtName.align = TextFormatAlign.CENTER;
            this._fmtMsg.align = TextFormatAlign.CENTER;
         }
         this._spriteContainer = new Sprite();
         this.lineHeight = 0;
         this._spriteHspace = this._spriteVspace = 1;
         this._widthTxt = width;
         _reg = /\/:[0-9][0-9]/g;
      }
      
      private function initTextField(width:Number) : void
      {
         this._txtField = new TextField();
         this._txtField.width = width;
         this._txtField.height = 400;
         this._txtField.multiline = true;
         this._txtField.wordWrap = true;
      }
      
      public function convertStringToRich(str:String) : Object
      {
         var i:int;
         var result:Object;
         var className:String = null;
         var idx:int = 0;
         var array:Array = [];
         var arrExp:Array = str.match(_reg);
         var faceObj:Object = {
            "src":null,
            "index":null
         };
         for(i = 0; i < arrExp.length; i++)
         {
            try
            {
               className = arrExp[i].slice(_lt.length,arrExp[i].length);
               idx = str.indexOf(arrExp[i]);
               faceObj = {
                  "src":className,
                  "index":idx
               };
               str = str.substring(0,idx) + str.substring(idx + arrExp[i].length,str.length);
            }
            catch(err:Error)
            {
               continue;
            }
            array.push(faceObj);
         }
         result = {
            "mess":str,
            "faces":array
         };
         return result;
      }
      
      public function get numSprite() : int
      {
         return this._spriteContainer.numChildren;
      }
      
      public function getSpriteIndexAt(depth:int) : int
      {
         var sprite:MovieClip = this.getSpriteAt(depth);
         if(Boolean(sprite))
         {
            return int(sprite.name);
         }
         return -1;
      }
      
      public function getSpriteAt(depth:int) : MovieClip
      {
         if(depth >= this._spriteContainer.numChildren)
         {
            return null;
         }
         return this._spriteContainer.getChildAt(depth) as MovieClip;
      }
      
      public function getSpriteByName(name:String) : MovieClip
      {
         return this._spriteContainer.getChildByName(name) as MovieClip;
      }
      
      public function removeSpriteByName(name:String) : void
      {
         var sp:MovieClip = this._spriteContainer.getChildByName(name) as MovieClip;
         if(Boolean(sp))
         {
            sp.stop();
            this._spriteContainer.removeChild(sp);
         }
      }
      
      public function set spriteVspace(value:int) : void
      {
         this._spriteVspace = value;
      }
      
      public function set spriteHspace(value:int) : void
      {
         this._spriteHspace = value;
      }
      
      public function set defaultTextFormat(format:TextFormat) : void
      {
         if(format.letterSpacing == null)
         {
            format.letterSpacing = 0;
         }
         this._defaultTextFormat = format;
         this._txtField.defaultTextFormat = format;
      }
      
      public function get defaultTextFormat() : TextFormat
      {
         return this._defaultTextFormat;
      }
      
      public function set placeholderColor(value:uint) : void
      {
         this.PLACEHOLDER_COLOR = value;
      }
      
      public function clear() : void
      {
         this._txtField.text = "";
         this.recoverDefaultTextFormat();
         this._spriteContainer.y = 0;
         while(this._spriteContainer.numChildren > 0)
         {
            this._spriteContainer.removeChildAt(0);
         }
      }
      
      public function appendChatText(channel:String, srcName:String, dstName:String, id:uint, content:String, bSelf:Boolean = false, autoWordWrap:Boolean = true) : void
      {
         var _arrEmote:Array = null;
         var i:int = 0;
         var item:Object = null;
         var index:int = 0;
         if(Boolean(this._txtField))
         {
            this.clear();
            removeChild(this._txtField);
         }
         this.initTextField(this._widthTxt);
         var obj:Object = this.convertStringToRich(content);
         this.appendText(channel,srcName,dstName,id,obj.mess,bSelf,this._fmtName,this._fmtMsg);
         if(Boolean(obj.faces))
         {
            _arrEmote = new Array();
            for(i = 0; i < obj.faces.length; i++)
            {
               index = int(obj.faces[i].index);
               if(index == -1)
               {
                  index = int(obj.mess.length);
               }
               else if(autoWordWrap)
               {
                  index -= 1;
               }
               index += this._txtField.length - obj.mess.length;
               if(autoWordWrap && index >= this._txtField.length)
               {
                  index = this._txtField.length - 1;
               }
               index = this.addPlaceHolder(index);
               _arrEmote.push({
                  "cname":obj.faces[i].src,
                  "idx":index
               });
            }
            for each(item in _arrEmote)
            {
               this.addSprite(item.cname,item.idx,0,this.lineHeight);
            }
         }
         this._txtField.height = int(this._txtField.textHeight) + 5;
         addChild(this._txtField);
         addChild(this._spriteContainer);
      }
      
      private function addPlaceHolder(caretIndex:int) : int
      {
         if(caretIndex == -1)
         {
            caretIndex = this._txtField.caretIndex;
         }
         if(caretIndex > this._txtField.length)
         {
            caretIndex = this._txtField.length;
         }
         var format:TextFormat = this.getPlaceholderFormat();
         this._txtField.replaceText(caretIndex,caretIndex,this.PLACEHOLDER);
         this._txtField.setTextFormat(format,caretIndex);
         return caretIndex;
      }
      
      private function addSprite(target:String, caretIndex:int = -1, width:Number = -1, height:Number = -1) : void
      {
         var rectPlaceholder:Rectangle = null;
         var x:int = 0;
         var y:int = 0;
         var s:MovieClip = null;
         if(target != null && target != "")
         {
            rectPlaceholder = this.getCharBoundaries(caretIndex);
            x = this._spriteContainer.x + rectPlaceholder.left - this._spriteHspace;
            y = rectPlaceholder.top + rectPlaceholder.height - 24 - this._spriteVspace;
            s = MaterialLib.getInstance().getMaterial("simle" + target) as MovieClip;
            s.name = String(caretIndex);
            s.x = x - 2;
            s.y = y - 5;
            this._spriteContainer.addChild(s);
         }
      }
      
      private function appendText(channel:String, srcName:String, dstName:String, id:uint, text:String, bSelf:Boolean, formatName:TextFormat = null, formatText:TextFormat = null) : void
      {
         this.recoverDefaultTextFormat();
         if(Boolean(channel))
         {
            channel = channel.replace(/</g,"&lt;");
            channel = channel.replace(/>/g,"&gt;");
         }
         if(Boolean(srcName))
         {
            srcName = srcName.replace(/</g,"&lt;");
            srcName = srcName.replace(/>/g,"&gt;");
         }
         if(Boolean(dstName))
         {
            dstName = dstName.replace(/</g,"&lt;");
            dstName = dstName.replace(/>/g,"&gt;");
         }
         if(Boolean(text))
         {
            text = text.replace(/</g,"&lt;");
            text = text.replace(/>/g,"&gt;");
         }
         var arrStr:Array = new Array();
         if(this._bCenter)
         {
            arrStr.push("<P ALIGN=\"CENTER\">");
         }
         else
         {
            arrStr.push("<P ALIGN=\"LEFT\">");
         }
         var addText:String = "";
         if(channel && channel.length > 0 || srcName && srcName.length > 0)
         {
            if(Boolean(formatName))
            {
               arrStr.push("<FONT FACE=\"");
               arrStr.push(formatName.font as String);
               arrStr.push("\" SIZE=\"");
               arrStr.push(formatName.size.toString());
               arrStr.push("\" COLOR=\"#");
               if(bSelf)
               {
                  arrStr.push("003300");
               }
               else
               {
                  arrStr.push("0033ff");
               }
               if(srcName == "你发送的太快了!" || srcName == "不能发送空信息!")
               {
                  arrStr.push("ff0000");
               }
               arrStr.push("\">");
            }
            if(Boolean(channel) && channel.length > 0)
            {
               arrStr.push(channel);
            }
            if(Boolean(srcName) && srcName.length > 0)
            {
               if(!bSelf)
               {
                  arrStr.push("<A HREF=\"event:");
                  arrStr.push(srcName + "$" + id);
                  arrStr.push("\">");
                  arrStr.push(srcName);
                  arrStr.push("</A>");
               }
               else
               {
                  arrStr.push(srcName);
               }
            }
            if(Boolean(dstName) && dstName.length > 0)
            {
               arrStr.push("悄悄地对");
               if(dstName != "你")
               {
                  arrStr.push("<A HREF=\"event:");
                  arrStr.push(dstName + "$" + id);
                  arrStr.push("\">");
                  arrStr.push(dstName);
                  arrStr.push("</A>");
               }
               else
               {
                  arrStr.push(dstName);
               }
               arrStr.push("说");
            }
            if(Boolean(srcName) && srcName.length > 0)
            {
               arrStr.push("：");
            }
            if(Boolean(formatName))
            {
               arrStr.push("</FONT>");
            }
         }
         if(Boolean(text))
         {
            if(Boolean(formatText))
            {
               arrStr.push("<FONT FACE=\"");
               arrStr.push(formatText.font as String);
               arrStr.push("\" SIZE=\"");
               arrStr.push(formatText.size.toString());
               arrStr.push("\" COLOR=\"#");
               arrStr.push("000000");
               arrStr.push("\">");
            }
            arrStr.push(text);
            if(Boolean(formatText))
            {
               arrStr.push("</FONT>");
            }
         }
         arrStr.push("</P>");
         addText = arrStr.join("");
         var arrHtml:Array = new Array();
         arrHtml.push(this._txtField.htmlText);
         arrHtml.push(addText);
         this._txtField.htmlText = arrHtml.join("");
      }
      
      private function getCharBoundaries(charIndex:int) : Rectangle
      {
         return this._txtField.getCharBoundaries(charIndex);
      }
      
      private function recoverDefaultTextFormat() : void
      {
         if(Boolean(this._defaultTextFormat))
         {
            this.defaultTextFormat = this._defaultTextFormat;
         }
      }
      
      private function getPlaceholderFormat() : TextFormat
      {
         var format:TextFormat = new TextFormat();
         format.font = this.PLACEHOLDER_FONT;
         format.color = this.PLACEHOLDER_COLOR;
         format.size = 24;
         format.underline = false;
         if(this._bCenter)
         {
            format.align = TextFormatAlign.CENTER;
         }
         return format;
      }
   }
}

