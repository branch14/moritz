/* ---------------------------------------------------------
   
	LayoutManager class 
	displays array of items 

--------------------------------------------------------- */

/*
	CONSTRUCTOR
*/

LayoutManager = function(view, drawtarget){
	this.viewManager=view;
	this.drawTarget=drawtarget;
	this.tooManyNodes=false;
};
LayoutManager.prototype = new Object();

/*
	INSTANCE METHODS
*/

// triggered by view when new layout is required
LayoutManager.prototype.setSizes = function(w,h){
	this.displayWidth=w;
	this.displayHeight=h;
	this.displayRadius=Math.min(w,h)*.5-30;
};

// triggered by view when new layout is required
LayoutManager.prototype.startAnimation = function(){
	this.isInMotion=true;
	this.drawTarget.clear();
	// set the mc positions (mc.targetPos) and start tweening animation (this.tweenMCsToTargetPositions)
	// you have to implement the calcTargetPositions method for a new layoutManager!
	this.calcTargetPositions();
	this.tweenMCsToTargetPositions();
};



// triggered by view when new layout is required
LayoutManager.prototype.startSelectionShift = function(){
	this.isInMotion=true;
	this.drawTarget.clear();
};


// callback function triggered when transition animation has finished
LayoutManager.prototype.aniFinished = function(clip){
	trace("LayoutManager.aniFinished");	
	if(this.isInMotion && clip.isInCenter){
		trace("LayoutManager.aniFinished centerClip");
		this.isInMotion=false;
		this.drawRelations();
		this.viewManager.aniFinished();		
	}
};

// overwrite this function to change the way of position calculations
LayoutManager.prototype.calcTargetPositions = function(){};

LayoutManager.prototype.setMCArray = function(MCArray){
	trace("LayoutManager.setMCArray");
	this.MCArray = MCArray;
	if(this.MCArray.length>20){
		this.tooManyNodes=true;
	} else {
		this.tooManyNodes=false;
	}
};

LayoutManager.prototype.getNumElements = function(){
	return this.MCArray.length;
};

LayoutManager.prototype.centerNode = function(c){
	c.putInCenter();
};

LayoutManager.prototype.unCenterNode = function(c){
	c.leaveCenter();
};

LayoutManager.prototype.drawRelations = function(){
	//trace("drawRelations");
	this.drawTarget.clear();
	
	for(var i in this.MCArray){
		this.MCArray[i].drawRelations();
	}
};

LayoutManager.prototype.tweenMCsToTargetPositions = function(){	
	for(var i in this.MCArray){
		if(!this.MCArray[i].isSelected && !this.MCArray[i].isInCenter){
			this.MCArray[i].tweenTo(this.MCArray[i].targetPos);
		}
	}
	
};
