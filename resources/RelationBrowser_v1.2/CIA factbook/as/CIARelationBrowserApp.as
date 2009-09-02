#include "../as/der-mo.net/relationBrowser/RelationBrowserApp.as"
#include "NodeClasses.as"
#include "RelationClasses.as"

GraphView.prototype.defineLayoutStrategy =function (){
	// this function is used to define the way the layout of the nodes is calculated
	// you can overwrite it for your custom implementations
	
	// DEFAULT SETTING -------------------------------------
	
	// PARAMETERS
	
	// maximum number of total nodes displayed, 
	// however level 1 connected nodes are ALWAYS displayed
	// regardless of max. number
	this.maxNodes=15;
	
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

/*
	
	// ADDITIONAL SETTINGS for spring based layout ---------

	this.layoutManagerParams={};
	
	// optimal distance for connected nodes
	this.layoutManagerParams.optimalDistance=150;

	// optimal distance to center
	this.layoutManagerParams.bestCenterDistance=200;

	// strength of relation-based spring force 
	this.layoutManagerParams.attractionStrength=50;

	// strength of repulsion
	this.layoutManagerParams.repulsionStrength=20;
	
	// relative speed decrease per frame 
	this.layoutManagerParams.friction=.5;

	// maximum speed per frame (pixels)
	this.layoutManagerParams.maxSpeed=20;

	// duration on frames
	this.layoutManagerParams.frameDuration=85;

	// motion smooting: 0 (no smoothing) to 1 (no motion)
	// to avoid jerky movement in very connected graphs
	this.layoutManagerParams.motionSmoothing=.2;
*/
	
};