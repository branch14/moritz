/* ---------------------------------------------------------
   
	SpringsLayoutManager class 
	displays items in a radial manner

--------------------------------------------------------- */

/*
	CONSTRUCTOR
*/

SpringsLayoutManager = function(view, drawtarget){
	super(view, drawtarget);
	
	// set default values
	
	// optimal distance for connected nodes
	this.optimalDistance=150;

	// optimal distance to center
	this.bestCenterDistance=200;

	// strength of relation-based spring force 
	this.attractionStrength=50;

	// strength of repulsion
	this.repulsionStrength=20;
	
	// relative speed decrease per frame 
	this.friction=.5;

	// maximum speed per frame (pixels)
	this.maxSpeed=20;

	// duration on frames
	this.frameDuration=85;

	// motion smooting: 0 (no smoothing) to 1 (no motion)
	// to avoid jerky movement in very connected graphs
	this.motionSmoothing=.2;
	
	this.clock=_root.createEmptyMovieClip("clock", 12001);
	this.clock.owner=this;
	
	this.clock.tick=function (){
		//trace("SpringsLayoutManager tick");
		this.currentTicks--;

		this.owner.updatePositions();
		this.owner.moveClips();
		this.owner.drawRelations();
		
		if(this.currentTicks<1){
			this.owner.aniFinished(this);
		}
	};
	this.clock.startTicking=function (){
		trace("SpringsLayoutManager startTicking");
		this.owner.isInMotion=true;
		this.maxTicks=this.currentTicks=this.owner.frameDuration;
		this.onEnterFrame=this.tick;
		this.startTime=getTimer();
	};
	this.clock.stopTicking=function (){
		trace("SpringsLayoutManager stopTicking");
		this.onEnterFrame=null;
	};
};
SpringsLayoutManager.prototype = new LayoutManager();

/*
	INSTANCE METHODS
*/

SpringsLayoutManager.prototype.startAnimation = function(){

	this.clock.startTicking();
	this.isInMotion=true;
	
	for(var i=0; i<this.MCArray.length; i++){
		this.MCArray[i].force=new Vector2D(0,0);
		this.MCArray[i].speed=new Vector2D(0,0);
		if(this.MCArray[i]!=this.viewManager.centerClip){
			
			while(Math.abs(this.MCArray[i]._x)+Math.abs(this.MCArray[i]._y)<10){
				this.MCArray[i]._x-=Math.random()*10-5;
				this.MCArray[i]._y-=Math.random()*10-5;				
			}
			
			this.MCArray[i]._xscale=this.MCArray[i]._yscale=100;
			this.MCArray[i].targetPos={_x:this.MCArray[i]._x, _y:this.MCArray[i]._y}			
		}
	}
	this.numCalculations=0;

};
SpringsLayoutManager.prototype.aniFinished = function(clip){
	if(clip==this.clock){
		if(this.isInMotion) {
			trace("still moving "+this.numCalculations);
			return;
		}
		this.moveClips();
		this.drawRelations();
		this.clock.stopTicking();
		this.viewManager.aniFinished();
	} else if(this.isInMotion && clip.isInCenter){
		trace("centerAni finished")
		this.isInMotion=false;
	}
};

SpringsLayoutManager.prototype.setSizes = function(w,h){
	super.setSizes(w,h);
	this.displayRadius=Math.min(Math.max(200, this.displayRadius), 300);
	this.optimalDistance=this.displayRadius*.6;
	this.bestCenterDistance=this.displayRadius-50;
	this.startAnimation();
};

// triggered by view when new layout is required
SpringsLayoutManager.prototype.startSelectionShift = function(){
	super.startSelectionShift();
	this.clock.onEnterFrame=function (){
		this.owner.drawRelations();
	};
};


SpringsLayoutManager.prototype.updatePositions=function (){
	//trace("update "+this.MCArray);

	var center=this.viewManager.centerClip;
	var middle = new Vector2D(0,0);
	var m;
	var t;
	var diffVec;
	var dist;
	var strength;
	var diffUnity;
	var alreadyCalculatedRepulsion={};	

	var ratio=(this.clock.currentTicks/this.clock.maxTicks);
	var decay=.5*(ratio)+.1;	
	var centerAttractionStrength=this.attractionStrength*(1.5-ratio)*4;
		
	for(var i =0; i<this.MCArray.length; i++){
		// first loop: calculate all forces
		
		m=this.MCArray[i];
		t=m.targetPos;
		
		for(var j=0; j<m.relations.length; j++){
			// spring force for each relation
			var thisRelation = m.relations[j];
			var mc1 = thisRelation.toMC;
			var mc2 = thisRelation.fromMC;
			
			var force=this.springForce(mc1.targetPos, mc2.targetPos, this.attractionStrength, this.optimalDistance);
			Vector2D.addVec(mc1.force, force);
			Vector2D.substrVec(mc2.force, force);
		}
		
		// skip if clip is moved or blocked otherwise
		if(m.isInCenter || m.isSelected) continue;		
		
		// spring attraction to center
		var force=this.springForce(t, middle, centerAttractionStrength, this.bestCenterDistance);
		Vector2D.addVec(m.force, force);
		
		for(var j in this.MCArray){
			// anti-gravity (quadratic repulsion) between nodes
			if(i==j || alreadyCalculatedRepulsion[j+"_"+i]) continue;
			alreadyCalculatedRepulsion[i+"_"+j]=true;

			mc2=this.MCArray[j];
			var force=this.inverseSquareForce(t, mc2.targetPos, this.repulsionStrength, this.optimalDistance);
			
			Vector2D.addVec(m.force, force);
			Vector2D.substrVec(mc2.force, force);
		}
	}
	
	for(var i in this.MCArray){
		// second loop: apply forces
		m=this.MCArray[i];
		t=m.targetPos;
		
		if(m.isInCenter || m.isSelected) continue;		
		
		m.speed._x+=(m.force._x-m.speed._x)*decay;
		m.speed._y+=(m.force._y-m.speed._y)*decay;
		
		// apply this.maxSpeed
		Vector2D.constrainToBox(m.speed,-this.maxSpeed,-this.maxSpeed,this.maxSpeed,this.maxSpeed);		
		
		Vector2D.addVec(t, m.speed);			
		
		m.speed=Vector2D.scalarMult(m.speed, 1-this.friction);
		m.force=new Vector2D(0,0);
	}
};

SpringsLayoutManager.prototype.moveClips=function (){
	for(var i in this.MCArray){
		
		if(this.MCArray[i]==this.viewManager.centerClip) continue;
		
		// smooth movement
		this.MCArray[i]._x+=(this.MCArray[i].targetPos._x-this.MCArray[i]._x)*(1-this.motionSmoothing);
		this.MCArray[i]._y+=(this.MCArray[i].targetPos._y-this.MCArray[i]._y)*(1-this.motionSmoothing);

		/*
		// direct positioning
		this.MCArray[i]._x=this.MCArray[i].targetPos._x;
		this.MCArray[i]._y=this.MCArray[i].targetPos._y;
		*/
	}	
};

SpringsLayoutManager.prototype.springForce=function (mc1, mc2, attractionStrength, optimalDistance){
	var diffVec=Vector2D.diffVec(mc1, mc2);
	var dist=Vector2D.vecLength(diffVec);
	var diffUnity=Vector2D.normalize(diffVec);

	var relDist=(dist-optimalDistance)/optimalDistance;
	var strength=-attractionStrength*relDist;	
	return new Vector2D(diffUnity._x*strength, diffUnity._y*strength);
};

SpringsLayoutManager.prototype.inverseSquareForce=function (mc1, mc2, repulsionStrength, optimalDistance){
	var diffVec=Vector2D.diffVec(mc1, mc2);
	var dist=Vector2D.vecLength(diffVec);
	var diffUnity=Vector2D.normalize(diffVec);

	var relDist=dist/optimalDistance;
	var strength=repulsionStrength/(relDist*relDist);
	return new Vector2D(diffUnity._x*strength, diffUnity._y*strength);
};