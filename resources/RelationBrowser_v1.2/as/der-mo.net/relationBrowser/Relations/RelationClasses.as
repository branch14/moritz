/*

	Base classes for your custom relations
	
*/

/* ---------------------------------------------------------
   
	UndirectedRelation class 
	has an arrowhead attached

--------------------------------------------------------- */

function UndirectedRelation(relObj, fromMC, toMC, drawTarget, viewManager){
	super(relObj, fromMC, toMC, drawTarget, viewManager);
}

UndirectedRelation.prototype=new Relation();

UndirectedRelation.prototype.draw = function(){
	super.draw();
};


/* ---------------------------------------------------------
   
	DirectedRelation class 
	has an arrowhead attached
	
--------------------------------------------------------- */

// constructor
//
function DirectedRelation(relObj, fromMC, toMC, drawTarget, viewManager){
	super(relObj, fromMC, toMC, drawTarget, viewManager);
}

DirectedRelation.prototype=new Relation();

DirectedRelation.prototype.draw = function(){

	super.draw();

	var scale=Math.max(50, Math.min(this.lineSize*25, 130));
	this.arrowHead._rotation=this.angleDegrees;
	this.arrowHead._x=this.toX;
	this.arrowHead._y=this.toY;
	this.arrowHead._xscale=this.arrowHead._yscale=scale;
};

DirectedRelation.prototype.remove = function(){
	
	super.remove();
	
	this.arrowHead.removeMovieClip();
};

DirectedRelation.prototype.createClips = function(){
	
	super.createClips();
	
	var myDepth = this.viewManager.depthManager.getNext("relations");
	this.arrowHead = this.drawTarget.attachMovie("arrowHead", "arrowHead" + myDepth, myDepth);
	new Color(this.arrowHead).setRGB(this.color);

};



