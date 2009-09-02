/*
   
	GraphView class 
   	displays the graph data by using node groups (e.g. circle sectors)

*/

/*
	CONSTRUCTOR
*/

function GraphView(){
	
	// dict to store movieClip reference by ID
	this.mcDictionary = {};
	

	// initialize depthmanager
	this.depthManager = new DepthManager({relations:500, items:5000, labels:2000});
	this.drawTarget=this.createEmptyMovieClip("drawTarget", 3);
	this.spotLightDrawTarget=this.createEmptyMovieClip("spotLightDrawTarget", 1);

}

GraphView.prototype = new MovieClip();

Object.registerClass("GraphViewMC", GraphView);

/*
	INSTANCE METHODS
*/

// -----------------------------------------------------
// INIT

// init function called by application script
GraphView.prototype.init = function(model){	
	// store reference to model and menu movieclip
	this.model = model;
	
	// set layoutManagerClassName
	this.defineLayoutStrategy();
	this.layoutManager= new _root[this.layoutManagerClassName](this, this.drawTarget);	
	
	if(!this.layoutManager){
		trace("!!!!!! GraphView.init: invalid layout strategy: "+this.layoutManagerClassName);
		this.layoutManager=new RadialLayoutManager(this, this.drawTarget);	
	}
	
	if(this.layoutManagerParams){
		this.layoutManager.adoptProps(this.layoutManagerParams);
	}
	
	this.menu=_root.menu;	
  	this.setComponentPositions();
};

// called by init function
GraphView.prototype.defineLayoutStrategy =function (){
	// this function is used to define the way the layout of the nodes is calculated
	// you can overwrite it for your custom implementations
	
	// DEFAULT SETTING -------------------------------------
	
	// PARAMETERS
	
	// maximum number of total nodes displayed, 
	// however level 1 connected nodes are ALWAYS displayed
	// regardless of max. number
	this.maxNodes=0;
	
	// how deep shall we look for connected nodes
	this.connectionDepth=1;

	// shall only relations to center node or all relations be displayed?
	this.showAllRelations=false;

	// classical radial layout  
	this.layoutManagerClassName="RadialLayoutManager";
	
	// iterative springs and repulsion layout
	// this.layoutManagerClassName="SpringsLayoutManager";
	
	// first springs layout, then radial based on the calculated positions
	// this.layoutManagerClassName="CombinedLayoutManager";
	
	// END DEFAULT SETTING ---------------------------------
};

// called by init function and on resize
GraphView.prototype.setComponentPositions = function(model){
	// set UI element positions and depths
	var sideBarWidth=sidebar._width?sidebar._width:0;
	var menuHeight=menu._height?30:0
	
	this.displayWidth=Stage.width-sideBarWidth-30;
	this.displayHeight=Stage.height-menuHeight;
	
	this._x = (this.displayWidth)*0.5;
	this._y = menuHeight+(this.displayHeight)*0.5;
	
	this.layoutManager.setSizes(this.displayWidth, this.displayHeight);
	this.drawSpotlight();
}


// -----------------------------------------------------
// CHANGE OF FOCUS

// puts a new item in the center
GraphView.prototype.switchView = function(id){
	trace("-------------------------");
	trace("GraphView.switchView "+id);
	
	if(id == this.centerClip.id && id != null){
		// no layout change since the already centered clip is reselected
		trace("centerClip selected")
		this.centerClip.setSelected(true);
		return false;
	}
	
	// get connected nodes
	var result=this.model.getConnectedNodes(id, this.connectionDepth, this.showAllRelations, this.maxNodes);

	// hide spotlight
	this.spotLightDrawTarget.clear();

	// count nodes, if only 2 -> leave layout the same
	var numNodes=result.nodes.length;
	var toBeDisplayedClip=this.getMCbyID(id);
	if(numNodes<=2 && toBeDisplayedClip && !toBeDisplayedClip.dataURL.length){
		// no layout change
		toBeDisplayedClip.setSelected(true);
		// track click nevertheless
		this.menu.addClickToHistory(id);
		return false;
	}
	
	// otherwise: bring selection to center
	this.display(result);
	return true;
};

GraphView.prototype.onMoreDataLoaded = function(id){
	// get connected nodes
	
	var result=this.model.getConnectedNodes(id, this.connectionDepth, this.showAllRelations, this.maxNodes);

	// hide spotlight
	this.spotLightDrawTarget.clear();
	this.display(result);
	return true;
}

//
// displays the new data

// diplay object of the following form:
// {nodes:nodesResult, relations:relationResult, center:centerItem};
// nodesResult is a dictionary (by _type property) of node arrays
// relations is an array of relation objects

GraphView.prototype.display = function(data){
	trace("GraphView.display");
  	RelationBrowserApp.setState("display");

	this.nodes = data.nodes;
	this.relations = data.relations;

	this.nodes.sortOn(["_type", "name"], Array.ASCENDING);
	
	// remove unused clips
	this.cleanUpClips();

	// create new clips and relations
	this.nodeMCs=this.createNodeClips();

	this.layoutManager.unCenterNode(this.centerClip);
	this.centerClip = this.getMCbyID(data.center.id);
	this.layoutManager.centerNode(this.centerClip);
	
	// create relations, relies on having a centerClip
	this.createRelations();
	
	// tell layoutManager to calc positioning
	this.layoutManager.setMCArray(this.nodeMCs);
	this.layoutManager.startAnimation();

	// track click
	this.menu.addClickToHistory(data.center.id);

	if(this.centerClip.dataURL.length){
		this.model.loadMoreData(this.centerClip.dataURL);
	}
};

// ----------------------------------
// selection management and spotlight

GraphView.prototype.selectionChange = function(clip){
	trace("GraphView.selectionChange "+clip);
	this.selectedClip.setSelected(false);
	this.selectedClip=clip;
	this.spotLightDrawTarget.clear();
	this.layoutManager.startSelectionShift();
}

GraphView.prototype.drawSpotlight = function(){
	// cancel if no sidebar is present
	if(!sidebar._visible) return;
	
	this.spotLightDrawTarget.clear();
	this.spotLightDrawTarget.lineStyle();
	var from=this.selectedClip.nodeOutline.getBounds(this.spotLightDrawTarget);
	var to=_root.sidebar.bg1.getBounds(this.spotLightDrawTarget);
	this.spotLightDrawTarget.beginGradientFill("linear", [0xFFFFFF, 0xFFFFFF], [50,20], [0,0xFF], { matrixType:"box", x:this.selectedClip._x, y:0, w:to.xMin-from.xMin, h:400, r:0});
	
	this.spotLightDrawTarget.moveTo(from.xMin + (from.xMax-from.xMin)*.5, from.yMin);
	this.spotLightDrawTarget.lineTo(to.xMin, to.yMin);
	this.spotLightDrawTarget.lineTo(to.xMin, to.yMax);
	this.spotLightDrawTarget.lineTo(from.xMin + (from.xMax-from.xMin)*.5, from.yMax);
	
	this.spotLightDrawTarget.endFill();
};

// -----------------------------------------------------
// layout management

// ebent triggered by layoutManager when transition animation is finished

GraphView.prototype.aniFinished = function(){
	sidebar._visible=1;
	sidebar.update(this.selectedClip);
	this.menu.onSelectionChange(this.selectedClip.id);
	this.drawSpotlight();
}

// -----------------------------------------------------
// clip management

GraphView.prototype.createNodeClips = function(){
	var nodeMCs=[];
	for(var i=0;i<this.nodes.length; i++){
 		var n = this.nodes[i];
		var mc=this.getMCbyID(n.id);
 		if(!mc){
 			var depth = this.depthManager.getNext("items");
 			
 			// tricky: dynamically picks symbol identifier by _type
 			var mc = this.attachMovie(n._type, n._type+"_"+depth, depth);
 			mc.init(n, this);

 			if(mc == null){
 				// could implement a fallback to a generic Node symbol here
 				trace("!!! Missing library symbol -> could not create "+n._type);
 			}
 			
 			if(!eval(n._type)){
 				// could implement a fallback to a generic Node class here
 				trace("!!! Missing class definition -> could not create "+n._type);
 			} 			
 			if(mc) this.addMCtoDictionary(n.id, mc);
		}
		if(mc) nodeMCs.push(mc);
	}
	return nodeMCs;
};

GraphView.prototype.createRelations = function(){
	for(var i=0;i<this.relations.length; i++){
     	var r = this.relations[i];
     	r.toMC = this.getMCbyID(r.toID);
     	var mc = this.getMCbyID(r.fromID);
  
     	// tricky: dynamically instatiate class by _type
     	var classRef=eval(r._type);
     	// fallback: unknown class, take generic Relation class
     	if (!classRef) classRef=Relation;
     	
     	var o=new classRef(r, mc, r.toMC, this, this.drawTarget);
     	mc.addRelation(o);		
	}
};

GraphView.prototype.cleanUpClips = function(){

	for(var i in this.mcDictionary){
		if(!this.getNodeByID(i)){
			// clip is not needed anymore
			// trace ("remove " + this.mcDictionary[i]);
			this.mcDictionary[i].remove();
			this.mcDictionary[i].removeMovieClip();
			this.mcDictionary[i]=null;
		}
		else{
			// we can reuse this clip
			// trace ("reuse " + this.mcDictionary[i]);
			this.mcDictionary[i].clearRelations();
		}
	}
};

// -----------------------------------------------------
// HELPERS


GraphView.prototype.getNodeByID = function(id){
	if(id == null){
		return false;
	}
	for(var i in this.nodes){
		if(this.nodes[i].id == id) return this.nodes[i];
	}
	return false;
};
GraphView.prototype.addMCtoDictionary = function(id, mc){
	this.mcDictionary[id] = mc;
};

GraphView.prototype.getMCbyID = function(id){
	return this.mcDictionary[id];
};
