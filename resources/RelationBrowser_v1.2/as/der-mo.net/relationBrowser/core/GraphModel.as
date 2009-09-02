/*
   
	GraphModel class
	
	loads and manages the graph data
	call getConnectedNodes with an id to get a level1 connection map

*/

/*
	CONSTRUCTOR
*/

function GraphModel(){
	// store nodes in nodesDict by id
	this.nodesDict = {};
	
	// array of relation objects
	this.relations = [];
	// array of node type strings
	this.nodeTypes = [];
	
	// dictionaries of arrays for fast relation lookup
	this.toRelationsByID={};
	this.fromRelationsByID={};
	
	// dictionary to keep track of already loaded data URLs
	this.alreadyLoaded={};
}

/*
	INSTANCE METHODS
*/

GraphModel.prototype.setUp = function(nodesDict, relations, nodeTypes){

	this.nodesDict = nodesDict;
	this.relations = relations;
	this.nodeTypes = nodeTypes;

	this.storeRelationTargets(relations);

};


GraphModel.prototype.loadMoreData=function (url){
	trace("GraphModel.loadMoreData id="+url);
	if(!this.alreadyLoaded[url]){
		gXMLadapter.loadMoreData(url);		
		this.alreadyLoaded[url]=true;
	} else {
		trace("!! already loaded data for url: "+url)
	}


};

GraphModel.prototype.onMoreDataLoaded=function (nodesDict, relations){
	trace("GraphModel.onMoreDataLoaded");
	for(var i in nodesDict) this.nodesDict[nodesDict[i].id]=nodesDict[i];
	for(var i in relations) this.relations.push(relations[i]);
	this.storeRelationTargets(relations);
	
	gView.onMoreDataLoaded(gView.centerClip.id);
};

GraphModel.prototype.storeRelationTargets=function (relations){
	// redundant relation storage for fast lookup 
	for (var i in relations){
		var r = relations[i];
		var id = r.toID;
		if(this.toRelationsByID[id]==null){
			this.toRelationsByID[id]=[];
		}
		this.toRelationsByID[id].push(r);
		
		var id = r.fromID;
		if(this.fromRelationsByID[id]==null){
			this.fromRelationsByID[id]=[];
		}
		this.fromRelationsByID[id].push(r);
	}
};

// -----------------------------------------------------
// DATA ACCESS

// extract a data subset based on level 1 neighborhood given a selection (id)
GraphModel.prototype.getConnectedNodes = function(id, depth, allRelations, nodesLeft){
	
	if(id == null){
		if(!RelationBrowserSettings.startID){
			trace("!! getConnectedNodes failed - no ID specified");
			return false;
		} else {
			trace("getConnectedNodes: deaulft startID "+RelationBrowserSettings.startID);
			id = RelationBrowserSettings.startID;
		}
	}
	trace("getConnectedNodes "+id);
	
	// result object to store subset of nodesDict
	var nodesResult = new Set();
	// result object to store subset of relations
	var relationResult = new Set();
	// get full data for centered item
	var centerItem = this.getItemByID(id);
	
	var nodesDict={};
	
	// add centered item in any case
	nodesResult.addItem(centerItem);
	nodesDict[id]=true;		
	
	for(var i in this.nodesDict) delete this.nodesDict[i].linkType;
	
	// collect LEVEL 1 connections
	var toRelations=this.getToRelationsByID(id);
	for(var i in toRelations){
		var r=toRelations[i];
		relationResult.addItem(r);	
		var node=this.getItemByID(r.fromID);
		node.linkType="incoming";
		nodesResult.addItem(node);
		nodesDict[r.fromID]=true;
		nodesLeft--;
	}	

	var fromRelations=this.getFromRelationsByID(id);
	for(var i in fromRelations){
		var r=fromRelations[i];
		relationResult.addItem(r);	
		
		var node=this.getItemByID(r.toID);
		if(node.linkType=="incoming") {
			node.linkType="mutual";
		} else {
			node.linkType="outgoing";
		}
		nodesResult.addItem(node);
		
		nodesDict[r.toID]=true;
		nodesLeft--;
	}	
	// Collect further nodes
	
	while(--depth && nodesLeft>=0){
		var newNodes=new Set();
		for(var i in nodesResult){
			var s=this.getConnectedNodes(nodesResult[i].id,1,false);
			newNodes.addItems(s.nodes);
			relationResult.addItems(s.relations);
		}
		for(var i in newNodes){
			if(nodesResult.addItem(newNodes[i])) {
				nodesLeft--;
				nodesDict[newNodes[i].id]=true;
			}
			if(!nodesLeft || nodesLeft<0) break;
		};
	}
	
	// if all relations should be returned, 
	// collect all relations for collected nodes.
	
	if(allRelations){
		for (var i=0; i<nodesResult.length; i++ ){
			// since we loop over all nodes, only toRelations are considered
			var a=this.getToRelationsByID(nodesResult[i].id);
			for(var j in a){
				if(nodesDict[a[j].fromID] && nodesDict[a[j].toID]) {
					relationResult.addItem(a[j]);			
				}
			}
		}		
	}
	return {nodes:nodesResult, relations:relationResult, center:centerItem};
};




// -----------------------------------------------------
// HELPERS

// return node by id
GraphModel.prototype.getItemByID = function(id){
	return this.nodesDict[id];
};

// return node by id
GraphModel.prototype.getRelationsByID = function(id){
	//trace("getRelationsByID "+id);
	var to=this.getToRelationsByID(id);
	var from=this.getFromRelationsByID(id);
	var all=to.concat(from);
	return all;
};

GraphModel.prototype.getToRelationsByID = function(id){
	var a=this.toRelationsByID[id];
	if(a==null) a=[];
	return a;
};

GraphModel.prototype.getFromRelationsByID = function(id){
	var a=this.fromRelationsByID[id];
	if(a==null) a=[];
	return a;
};

GraphModel.prototype.getNumRelationsByID = function(id){
	return this.getRelationsByID(id).length;
};
