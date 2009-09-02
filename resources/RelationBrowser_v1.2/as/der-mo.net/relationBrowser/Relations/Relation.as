/* ---------------------------------------------------------
   
	Relation class 
	extend this class to create new relation types

--------------------------------------------------------- */

/*
	CONSTRUCTOR
*/

function Relation(relObj, fromMC, toMC, viewManager, drawTarget){
	this.viewManager = viewManager;
	this.adoptProps(relObj);
	this.fromMC = fromMC;
	this.toMC = toMC;
	this.drawTarget = drawTarget;
	
	this.setStyles();
}


/*
	INSTANCE METHODS
*/

// copy values from style definition in XML file (stored as static class variables in XMLadapter.as)
// TODO: no inheritance supported, redefinitions are necessary for each relation class
// problem is, I do not know how to walk up the inheritance chain in this case.

Relation.prototype.setStyles = function(){
	if(this.color==null){
		this.color=eval(this._type).color;
	}
	if(this.lineSize==null){
		this.lineSize=eval(this._type).lineSize;
	}
	if(this.letterSymbol==null){
		this.letterSymbol=eval(this._type).letterSymbol;
	}
	if(this.labelText==null){
		this.labelText=eval(this._type).labelText;
	}
}


// draw the relation
Relation.prototype.draw = function(){
	
	if (!this.clipsCreated){
		this.createClips();
		this.clipsCreated=true;
	}
	
	if (this.viewManager.layoutManager.isInMotion){
		this.label._visible=false;
	} else if (!this.label._visible){
		this.label._visible=true;
		this.label._xscale=this.label._yscale=10;
		var scale=Math.max(70, Math.min(this.lineSize*25, 130));
		this.label.tweenTo({duration:5, _xscale:[scale, "inOut", 20], _yscale:[scale, "inOut", 20]});
		this.label.tooltip._xscale=this.label.tooltip._yscale=10000/scale;
	} 
	
	
	this.updateCoords();

	this.drawTarget.lineStyle (this.lineSize, this.color, 100);
	this.drawTarget.moveTo (this.fromX, this.fromY);
	this.drawTarget.lineTo (this.toX, this.toY);
	
	this.label._x = this.middleX;
	this.label._y = this.middleY;
};

Relation.prototype.remove = function(){
	this.label.removeMovieClip();
};

Relation.prototype.createClips = function(){
	if(this.labelText){
		var myDepth = this.viewManager.depthManager.getNext("labels");
		this.label = this.drawTarget.attachMovie("relationLabel", "relationLabel" + myDepth, myDepth, {viewManager:this.viewManager});
		new Color(this.label.ring).setRGB(this.color);
		this.label.letterSymbol.letterSymbol_tf.text=this.letterSymbol;
		new Color(this.label.letterSymbol).setRGB(this.color);
		this.label.tooltip.tooltip_tf.text=this.labelText;
		this.label.tooltip.tooltipBG._width=this.label.tooltip.tooltip_tf.textWidth+6;
	}
};

Relation.prototype.updateCoords=function (){
	this.fromXCenter = this.fromMC._x;
	this.toXCenter = this.toMC._x;
	this.fromYCenter = this.fromMC._y;
	this.toYCenter = this.toMC._y;

	this.angleArc=Math.atan2(this.toYCenter-this.fromYCenter, this.toXCenter-this.fromXCenter);
	this.angleDegrees=180*this.angleArc/Math.PI;
	
	// get predefined or guesstimated radius
	var fromRadius=this.fromMC.getRadius();
	var toRadius=this.toMC.getRadius();	

	this.fromX = this.fromXCenter+Math.cos(this.angleArc)*fromRadius;
	this.toX = this.toXCenter-Math.cos(this.angleArc)*toRadius;
	
	this.fromY = this.fromYCenter+Math.sin(this.angleArc)*fromRadius;
	this.toY = this.toYCenter-Math.sin(this.angleArc)*toRadius;
	
	this.middleX=this.fromX+(this.toX-this.fromX)*0.5;
	this.middleY = this.fromY+(this.toY-this.fromY)*0.5;
	
};