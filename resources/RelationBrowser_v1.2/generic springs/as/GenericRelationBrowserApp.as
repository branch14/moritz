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
	this.maxNodes=100;
	
	// how deep shall we look for connected nodes
	this.connectionDepth=2;

	// shall only relations to center node or all relations be displayed?
	this.showAllRelations=true;

	// classical radial layout  
	//this.layoutManagerClassName="RadialLayoutManager";
	
	// iterative springs and repulsion layout
	 this.layoutManagerClassName="SpringsLayoutManager";
	
	// first springs layout, then radial based on the calculated positions
	// this.layoutManagerClassName="CombinedLayoutManager";
	
	// END DEFAULT SETTING ---------------------------------
	
	// ADDITIONAL SETTINGS for spring based layout ---------

	this.layoutManagerParams={};
	
	//this.layoutManagerParams.optimalDistance=150;
	//this.layoutManagerParams.bestCenterDistance=200;
	this.layoutManagerParams.attractionStrength=50;
	this.layoutManagerParams.repulsionStrength=20;
	this.layoutManagerParams.friction=.5;
	this.layoutManagerParams.maxSpeed=20;
	this.layoutManagerParams.frameDuration=85;
	this.layoutManagerParams.motionSmoothing=.5;
	
};