/***
 Copyright 2008 Chris Hoffman
 
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


  Color algorithms are from http://www.cs.rit.edu/~ncs/color/t_convert.html
  and http://www.tecgraf.puc-rio.br/~mgattass/color/HSVtoRGB.htm.
***/

(function(){

var Color = window.Color = function(inColor) {
  /******
   inColor can take any of the following forms:
   
   Strings -
    rgb(r,g,b)
     Case-insensitive, where r, g & b are integers from 0 to 255, inclusive.
     
    #rgb
     r, g & b are hex digits. Red is expanded to rr, green to gg, blue to bb.
     
    #rrggbb
     r, g & b are hex digits.
   
   Object -
    {red: r, green: g, blue: b}
     r, g & b are integers from 0 to 255, inclusive. A Color object, for example.
     
   Any other (or no) value produces #000 (black).
  ******/

  if (this instanceof Color) {
    this.init(inColor);
    return this;
  } else {
    return new Color(inColor);
  }
}

var checkRGBRange = function(n) {
  n = parseInt(n);
  if (!n) {
    return 0;
  }
  
  n = Math.round(n);
  
  if (n < 0) {
    return 0;
  } else if (n > 255) {
    return 255;
  } else {
    return n;
  }
};

var fixRGBRange = function(obj) {
  obj.red = checkRGBRange(obj.red);
  obj.green = checkRGBRange(obj.green);
  obj.blue = checkRGBRange(obj.blue);
};

Color.prototype.init = function(inColor) {

  if (typeof inColor == "string") {
    var colorRegex = {
  	   triplet : /^rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)$/i,
	   shortHash : /^#([0-9a-f])([0-9a-f])([0-9a-f])$/i,
	   longHash : /^#([0-9a-f]{2,2})([0-9a-f]{2,2})([0-9a-f]{2,2})$/i
    };
    
    var reResult;
    
    if (reResult = colorRegex.triplet.exec(inColor)) {
      this.red = checkRGBRange(reResult[1]);
      this.green = checkRGBRange(reResult[2]);
      this.blue = checkRGBRange(reResult[3]);
    } else if (reResult = colorRegex.shortHash.exec(inColor)) {
      this.red = parseInt(reResult[1] + reResult[1], 16);
      this.green = parseInt(reResult[2] + reResult[2], 16);
      this.blue = parseInt(reResult[3] + reResult[3], 16);
    } else if (reResult = colorRegex.longHash.exec(inColor)) {
      this.red = parseInt(reResult[1], 16);
      this.green = parseInt(reResult[2], 16);
      this.blue = parseInt(reResult[3], 16);
    } else {
      this.red = this.green = this.blue = 0;
    }
  } else if (typeof inColor == "object") {
    this.red = checkRGBRange(inColor.red || 0);
    this.green = checkRGBRange(inColor.green || 0);
    this.blue = checkRGBRange(inColor.blue || 0);
  } else {
    this.red = this.green = this.blue = 0;
  }
};

Color.prototype.toString = function() {
  fixRGBRange(this);
  return "rgb(" + this.red + "," + this.green + "," + this.blue + ")";
};

Color.prototype.getHue = function() {
  fixRGBRange(this);
  
  var r = this.red/255;
  var g = this.green/255;
  var b = this.blue/255;
  
  var max = Math.max(r,g,b);
  var min = Math.min(r,g,b);
  
  if (max == min) {
    return 0;
  }
  
  var h;
  
  if (r == max) {
    h = (g - b) / (max - min);
  } else if (g == max) {
    h = 2 + (b - r) / (max - min);
  } else {
    h = 4 + (r - g) / (max - min);
  }
  
  h *= 60;
  
  if (h < 0) {
    h += 360;
  }
  
  return Math.floor(h);
};

Color.prototype.getSaturation = function() {
  fixRGBRange(this);
  
  var r = this.red/255;
  var g = this.green/255;
  var b = this.blue/255;
  
  var max = Math.max(r,g,b);
  var min = Math.min(r,g,b);
  
  if (max != 0) {
    return Math.floor((100 * (max - min))/max);
  }
  
  return 0;
};

Color.prototype.getValue = function() {
  fixRGBRange(this);
  
  return Math.floor((Math.max(this.red, this.green, this.blue) * 100)/255);
};

var setHSV = function(obj, h, s, v) {
  s /= 100;
  v  /= 100;
   
  if (s == 0) {
    obj.red = obj.green = obj.blue = v * 255;
    return;
  }
  
  h /= 60;
  
  var i = Math.floor(h);
  var f = h - i;
  var p = v * (1 - s) * 255;
  var q = v * (1 - s * f) * 255;
  var t = v * (1 - s * (1 - f)) * 255;

  switch(i) {
  case 0:
    obj.red = v * 255;
    obj.green = t;
    obj.blue = p;
    break;
  case 1:
    obj.red = q;
    obj.green = v * 255;
    obj.blue = p;
    break;
  case 2:
    obj.red = p;
    obj.green = v * 255;
    obj.blue = t;
    break;
  case 3:
    obj.red = p;
    obj.green = q;
    obj.blue = v * 255;
    break;
  case 4:
    obj.red = t;
    obj.green = p;
    obj.blue = v * 255;
    break;
  default:
    obj.red = v * 255;
    obj.green = p;
    obj.blue = q;
    break;
  }
};

Color.prototype.setHue = function(h) {
  fixRGBRange(this);
  h = parseInt(h);
  
  if (isNaN(h) || h < 0 || h > 360) {
    return this;
  }
  
  setHSV(this, h, this.getSaturation(), this.getValue());
  return this;
};

Color.prototype.setSaturation = function(s) {
  fixRGBRange(this);
  s = parseInt(s);
  
  if (isNaN(s) || s < 0 || s > 100) {
    return this;
  }
  
  setHSV(this, this.getHue(), s, this.getValue());
  return this;
};

Color.prototype.setValue = function(v) {
  fixRGBRange(this);
  v = parseInt(v);
  
  if (isNaN(v) || v < 0 || v > 100) {
    return this;
  }
  
  setHSV(this, this.getHue(), this.getSaturation(), v);
  return this;
};

Color.prototype.rgb = function() {
  return this.toString();
};

Color.prototype.getComplement = function() {
  return Color(this).setHue((this.getHue() + 180) % 360);
};

})();