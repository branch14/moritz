/*
  Vector2D class
*/
 
// ----------------------------------------------------- 
// constructor
 
Vector2D =function (x,y){
	if(!Number(x)) x=0;
	if(!Number(y)) y=0;
	this._x=x; this._y=y;
}
 
// ----------------------------------------------------- 
// inheritance


Vector2D.prototype = new Object();
 
// -----------------------------------------------------
// Class methods

Vector2D.dist = function (a, b) {
	var diffx = a._x-b._x;
	var diffy = a._y-b._y;
	return Math.sqrt(diffx*diffx+diffy*diffy);
}
Vector2D.sqdist= function(a, b) {
	var diffx = a._x-b._x;
	var diffy = a._y-b._y;
	return (diffx*diffx+diffy*diffy);
}
Vector2D.diffVec= function(a, b) {
	var diffx = a._x-b._x;
	var diffy = a._y-b._y;
	return new Vector2D(diffx,diffy);
}
Vector2D.addVec= function(a, b) {
	a._x += b._x;
	a._y += b._y;
}
Vector2D.substrVec= function(a, b) {
	a._x -= b._x;
	a._y -= b._y;
}
Vector2D.vecLength= function(b) {
	return Math.sqrt(b._x*b._x+b._y*b._y);
}
Vector2D.normalize= function(b) {
	var d = Vector2D.vecLength(b);
	return new Vector2D(b._x/d, b._y/d);
}
Vector2D.scalarMult= function(a, b) {
	return new Vector2D(a._x*b, a._y*b);
}
Vector2D.constrainToBox=function (o,l,t,r,b){
	o._x=Math.min(r,Math.max(o._x,l));
	o._y=Math.min(b,Math.max(o._y,t));
}
Vector2D.stretchBounds=function (vectorList, l, t, r, b, nestedPropertyString){
	var xList=[];
	var yList=[];
	var minX=100000;
	var minY=100000;
	var maxX=-100000;
	var maxY=-100000;
	var o;
	for (var i in vectorList) {
		if (nestedPropertyString!=null){
			o=vectorList[i][nestedPropertyString];
		} else {
			o=vectorList[i];
		}
		minX=Math.min(o._x, minX);
		minY=Math.min(o._y, minY);
		maxX=Math.max(o._x, maxX);
		maxY=Math.max(o._y, maxY);
	}
	var xscale=(maxX-minX)/(r-l);
	var yscale=(maxY-minY)/(b-t);
	for (var i in vectorList) {
		if (nestedPropertyString!=null){
			o=vectorList[i][nestedPropertyString];
		} else {
			o=vectorList[i];
		}
		o._x=l+ (o._x-minX)/xscale;
		o._y=t+ (o._y-minY)/yscale;
	}
}
Vector2D.prototype.toString=function (){
	return "Vector2D ("+this._x+","+this._y+")";
};
// -----------------------------------------------------
// instance methods
