/* ---------------------------------------------------------
   
	RadialLayoutManager class 
	displays items in a radial manner

--------------------------------------------------------- */

/*
	CONSTRUCTOR
*/

RadialLayoutManager = function(view, drawtarget){
	super(view, drawtarget);
	
	this.clock=_root.createEmptyMovieClip("clock", 12001);
	this.clock.owner=this;
};
RadialLayoutManager.prototype = new LayoutManager();

/*
	INSTANCE METHODS
*/

RadialLayoutManager.prototype.setSizes = function(w,h){
	super.setSizes(w,h);
	this.displayRadius=Math.min(Math.max(150, this.displayRadius), 250);
	this.maxRadius=this.displayRadius;
	this.mediumRadius=this.displayRadius-30;
	this.minRadius=this.displayRadius-60;
	this.startAnimation();
};

RadialLayoutManager.prototype.setRange = function(range){
	this.range = range;
};
RadialLayoutManager.prototype.setOffset = function(offset){
	this.offset = offset;
};


// triggered by view when new layout is required
RadialLayoutManager.prototype.startAnimation = function(){
	super.startAnimation();
	this.clock.onEnterFrame=function (){
		this.owner.drawRelations();
	};
};

// triggered by view when new layout is required
RadialLayoutManager.prototype.startSelectionShift = function(){
	super.startSelectionShift();
	this.clock.onEnterFrame=function (){
		this.owner.drawRelations();
	};
};


RadialLayoutManager.prototype.calcTargetPositions = function(){
	var numItems = this.MCArray.length-1; 
	var centerClipSkipped=false;
	for(var i = 0; i < this.MCArray.length;i ++){
		var thisMC = this.MCArray[i];
		if(thisMC.isInCenter){
			thisMC.targetPos={_x:0, _y:0, _xscale:140, _yscale:140};
			centerClipSkipped=true;
			continue;
		}
		var num=i-1.0*(centerClipSkipped==true);
		this.setTargetPosition(thisMC, num/numItems*1.0, this.mediumRadius, numItems, this.offset, this.range, num);
	}
};

RadialLayoutManager.prototype.setTargetPosition = function(mc, ratio, radius, numItems, offset, range, num){
	if(!range){
		range = 1;
	}
	if(!offset){
		offset = 0;
	}
	//trace("LayoutManager.setTargetPosition" + [mc, ratio, radius, numItems, offset, range, num]);
	var angle =(range *(1-ratio)+ offset) *(2.0 * Math.PI);

	var scale = 100;
	
	if(range / numItems < 0.05){
		scale = mc.defaultSize*.8;
	}
	
	if(range / numItems < 0.10){
		if(((num+1) % 2)>0){
			radius=this.maxRadius;
		} else {
			radius=this.minRadius;
		}
	}	
	mc.targetPos=({_x:Math.cos(angle-Math.PI*.5)*radius, _y:Math.sin(angle-Math.PI*.5)*radius, _xscale:scale, _yscale:scale});
};


