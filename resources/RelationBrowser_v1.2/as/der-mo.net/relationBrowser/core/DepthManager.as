/*
  	DepthManager class

	manages z-Sorting of attached clips for multiple groups with individual z-Offsets
*/
 
/*
	CONSTRUCTOR
*/
 
function DepthManager(o){
	
	// dictionary to store depth counters by string identifier
	this.depthsByGroup = {};

	trace("init depthmanager");

	// initialize 
	for(var i in o){
		this.depthsByGroup[i] = o[i];
	}
}

/*
	INSTANCE METHODS
*/

// get next available depth for a group
DepthManager.prototype.getNext = function(group){
	this.depthsByGroup[group]++;
	return(this.depthsByGroup[group]);
};

// bring an MC to the top z-layer in its group
// if no group is specified, globally
DepthManager.prototype.bringToFront = function(mc, group){
	var targetDepth = this.depthsByGroup[group];
	if(!targetDepth){
		targetDepth=0;
		for(var i in this.depthsByGroup){
			targetDepth = Math.max(targetDepth, this.depthsByGroup[i]);
		}
	}
	mc.swapDepths(targetDepth);
};