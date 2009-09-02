/* ---------------------------------------------------------
   
	CombinedLayoutManager class 
	displays items in a radial manner

--------------------------------------------------------- */

/*
	CONSTRUCTOR
*/

CombinedLayoutManager = function(view, drawtarget){
	super(view, drawtarget);
	this.clock=_root.createEmptyMovieClip("clock", 12002);
	this.clock.owner=this;
	
	this.clock.maxTicks=35;
	
	this.clock.tick=function (){
		this.currentTicks--;
		this.owner.updatePositions();
		this.owner.moveClips();
		this.owner.drawRelations();
		
		if(!this.currentTicks){
			this.owner.aniFinished(this);
		}
	};
	this.clock.startTicking=function (){
		this.owner.isInMotion=true;
		this.currentTicks=this.maxTicks;
		this.onEnterFrame=this.tick;
		this.startTime=getTimer();
	};
	this.clock.stopTicking=function (){
		this.onEnterFrame=null;
	};
	
	this.radialManager=new RadialLayoutManager(this.view, this.drawTarget);

};
CombinedLayoutManager.prototype = new SpringsLayoutManager();

/*
	INSTANCE METHODS
*/

CombinedLayoutManager.prototype.setSizes=function (w,h){
	super.setSizes(w,h);
	this.radialManager.setSizes(w,h);
};

CombinedLayoutManager.prototype.startAnimation = function(){
	trace("CombinedLayoutManager.startAnimation");
		
	this.isInMotion=true;
	this.firstStageOver=this.secondStageOver=false;

	if(this.tooManyNodes) {
		// if too many nodes: don't even try springs layout
		this.aniFinished(this.clock);
		return;
	}
			
	for(var i=0; i<this.MCArray.length; i++){
		this.MCArray[i].force=new Vector2D(0,0);
		this.MCArray[i].speed=new Vector2D(0,0);
		if(this.MCArray[i]!=this.viewManager.centerClip){
			this.MCArray[i].targetPos={_x:this.MCArray[i]._x, _y:this.MCArray[i]._y}

			// HACK: remove items from center
			while(Math.abs(this.MCArray[i].targetPos._x)+Math.abs(this.MCArray[i].targetPos._y)<10){
				this.MCArray[i].targetPos._x-=Math.random()*10-5;
				this.MCArray[i].targetPos._y-=Math.random()*10-5;				
			}
			
			this.MCArray[i]._xscale=this.MCArray[i]._yscale=100;			
		}
	}
	this.clock.startTicking();

};
CombinedLayoutManager.prototype.aniFinished = function(clip){
	//trace("CombinedLayoutManager.aniFinished "+clip);
	if(clip==this.clock){	
		trace("CombinedLayoutManager.aniFinished: firstStage");
		this.firstStageOver=true;
		this.isInMotion=false;
		this.clock.stopTicking();

		// calculate angles 
		var indices=[];
		var angles=[];
		for(var j=0;j<this.MCArray.length;j++){
			var d=Vector2D.vecLength(this.MCArray[j]);
			var a=-Math.atan2(this.MCArray[j].targetPos._x/d, this.MCArray[j].targetPos._y/d);
			angles.push(a);
			this.MCArray[j].angle=a;
		}

		// sort MCs by angle
		angleIndices=angles.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY | Array.DESCENDING);
		
		var newlyOrdered=[];
		for(var j=0;j<this.MCArray.length;j++){
			newlyOrdered[j]=this.MCArray[angleIndices[j]];
			
		}
		// apply radial layout based on angles
		this.radialManager.setMCArray(newlyOrdered);
		this.radialManager.calcTargetPositions();
		this.tweenMCsToTargetPositions();
		
		// if not too many clips -> draw relations during animation
  		if(!this.tooManyNodes) {
			this.clock.onEnterFrame=function (){
  				this.owner.drawRelations();	
  			};
		}

  	} else if(this.firstStageOver && !this.secondStageOver) {
		// tweening to radial positions finished
		trace("CombinedLayoutManager.aniFinished: secondStage");
		this.secondStageOver=true;
		this.drawRelations();
  		this.viewManager.aniFinished();
  		this.clock.stopTicking();
  	}
};

// triggered by view when new layout is required
CombinedLayoutManager.prototype.startSelectionShift = function(){
	super.startSelectionShift();
	this.clock.onEnterFrame=function (){
		this.owner.drawRelations();
	};
};

/*
		
*/