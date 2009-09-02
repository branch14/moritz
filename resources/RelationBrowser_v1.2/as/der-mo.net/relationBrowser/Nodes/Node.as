/*
   
	Node class 
   	extend this class to generate new node types (NodeClasses.as)

*/

/*
	CONSTRUCTOR
*/

function Node() {
}

// inheritance
Node.prototype = new MovieClip();
Object.registerClass ("Node", Node);

/*
	INSTANCE METHODS
*/

// -----------------------------------------------------
// initialize

Node.prototype.init = function(dataObj, viewManager) {
	// adopt properties from init object
	this.adoptProps(dataObj);

	this.relations = [];
	this.viewManager = viewManager;

	this.futurePosition = {_x:0, _y:0, _xscale:0, _yscale:0};
	this.adoptProps(this.futurePosition);
	
	this.defaultSize=100;
	
	this.cacheAsBitmap=true;
	
};

/*
	MOUSE EVENTS
*/

Node.prototype.onPress = function (){
	trace("Node.onPress "+this);
	this.viewManager.switchView (this.id);
};

Node.prototype.onRollOver = function() {
	this.viewManager.depthManager.bringToFront(this, "items");
};

/*
	INSTANCE METHODS
*/

Node.prototype.remove = function() {
	this.clearRelations();
	this.removeMovieClip();
};

// used for finding start- and endpoints of relations 
Node.prototype.getRadius=function (){
	if(this.radius){
		// return real radius
		return this.radius*(this._xscale/100);
	} else {
		// return radius estimation
		return Math.max(this._height, this._width)*.5+5;
	}
};


// -----------------------------------------------------
// movement


Node.prototype.putInCenter = function() {
	trace("Node.putInCenter");
	this.isInCenter=true;
	this.setSelected(true);
	this.viewManager.depthManager.bringToFront(this, "items");
	this.targetPos={_x:0, _y:0, _xscale:140, _yscale:140};
	this.tweenTo(this.targetPos);
};

// leave Center, tweening will be handled by nodegroup
Node.prototype.leaveCenter = function() {
	this.isInCenter=false;
};

// selection
Node.prototype.setSelected = function(bool) {
	if(this.isSelected && !bool){
		// unselect
		this.tweenToQuick({_xscale:this.defaultSize, _yscale:this.defaultSize});
		this.isSelected=false;
	} else if(!this.isSelected && bool){
		// select
		this.isSelected=true;
		this.viewManager.selectionChange(this);
		this.tweenToQuick({_xscale:140, _yscale:140});
	}
};


// animation:
Node.prototype.tweenTo = function(propObj) {
	this.isBeingTweened=true;	
	var tweenObj = {duration:15, callback:this+".tweenFinished"};
	for(var i in propObj) tweenObj[i] = [propObj[i], "inOut", 10];
	this.futurePosition = propObj;
	this.dynTween(tweenObj);
};

// quick animation, used for selection change without layout movement
Node.prototype.tweenToQuick = function(propObj) {
	this.isBeingTweened=true;
	var tweenObj = {duration:12, callback:this+".tweenFinished"};
	for(var i in propObj) tweenObj[i] = [propObj[i], "inOut", 10];
	this.futurePosition = propObj;
	this.dynTween(tweenObj);
};

// animation callback
Node.prototype.tweenFinished = function() {
	this.isBeingTweened=false;
	this.viewManager.layoutManager.aniFinished(this);
};

// -----------------------------------------------------
// relations

Node.prototype.clearRelations = function() {
	for(var i in this.relations) {
		this.relations[i].remove();
	}
	this.relations = new Set();
};

Node.prototype.addRelation = function(r) {
	this.relations.addItem(r);
};

Node.prototype.drawRelations = function() {
	for(var i in this.relations) {
		this.relations[i].draw();
	}
};
