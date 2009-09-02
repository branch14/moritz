//include the main app

#include "../as/der-mo.net/relationBrowser/RelationBrowserApp.as"

// include special patches and extensions from local folder

#include "NodeClasses.as"
#include "RelationClasses.as"

// see readme.txt for tips on extending the basic functionality

GraphView.prototype.defineLayoutStrategy =function (){
	// this function is used to define the way the layout of the nodes is calculated
	
	// DEFAULT SETTING -------------------------------------
	
	// PARAMETERS
	
	// maximum number of total nodes displayed, 
	// however level 1 connected nodes are ALWAYS displayed
	// regardless of max. number
	this.maxNodes=10;
	
	// how deep shall we look for connected nodes
	this.connectionDepth=2;

	// shall only relations to center node or all relations be displayed?
	this.showAllRelations=true;

	// classical radial layout  
	//this.layoutManagerClassName="RadialLayoutManager";
	
	// iterative springs and repulsion layout
	// this.layoutManagerClassName="SpringsLayoutManager";
	
	// first springs layout, then radial based on the calculated positions
	 this.layoutManagerClassName="CombinedLayoutManager";
	
	// END DEFAULT SETTING ---------------------------------
	
	// ADDITIONAL SETTINGS for spring based layout ---------

	
	// ADDITIONAL SETTINGS for spring based layout ---------

	this.layoutManagerParams={};
	
	
	
	// relative speed decrease per frame 
	this.layoutManagerParams.friction=.5;

	// maximum speed per frame (pixels)
	this.layoutManagerParams.maxSpeed=20;

	// duration on frames
	this.layoutManagerParams.frameDuration=85;

	// motion smooting: 0 (no smoothing) to 1 (no motion)
	// to avoid jerky movement in very connected graphs
	this.layoutManagerParams.motionSmoothing=.5;
	
};