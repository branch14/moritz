/* ---------------------------------------------------------
   
	XMLadapter class
	modify the parseData method if your XML specification differs 

--------------------------------------------------------- */

XMLadapter=function(owner){
	this.owner=owner;
	this.firstCall=true;
	
}
XMLadapter.prototype.loadAndParseData=function(d){

	trace("loading XML "+d);
	RelationBrowserApp.setState("loading XML");
	this.XMLObj = new XML();
	this.XMLObj.ignoreWhite = true;
	this.XMLObj.load(d);
	
	this.XMLObj.owner = this;
	this.XMLObj.onLoad = function(success){
		trace("XML loaded.")
		if(success){
			this.owner.parseData();
		}
		else{
			this.owner.owner.setState("error");
		}
	};
}


XMLadapter.prototype.loadMoreData=function (url){
	this.firstCall=false;
  	RelationBrowserApp.setState("loading XML");
	trace("--> loading XML "+url);
	
	this.XMLObj = new XML();
	this.XMLObj.ignoreWhite = true;
	//
	this.XMLObj.load(url);

	this.XMLObj.owner = this;

	this.XMLObj.onLoad = function(success){

		if(success){
			trace("... XML loaded.");
			this.owner.parseData();
		}
		else{
			this.owner.owner.setState("error");
		}
	};
};

_mainTimeLine=this;

XMLadapter.prototype.parseData=function(){

  	trace ("starting to parse the data");
  	RelationBrowserApp.setState("XMLloaded");

	// get root node
  	var indexNode = this.XMLObj.byName ("RelationViewerData");

	// temporarily store node types
	var nodeTypesDict={};
	// collect different node types
	var nodeTypes=[];
	// collect node objects in dictionary by id  
	// (and the _type property determines class and symbol ID!)
	var nodesResult = {};
	// collect relation objects (_type property determines class and symbol ID)
	var relationsResult = [];

	// get settings
	if(this.firstCall){
		var settingsNode=indexNode.byName("Settings");
		var o=settingsNode.makeObj();
		RelationBrowserSettings.adoptProps(o);
		RelationBrowserSettings.maxRadius=Number(o.maxRadius);
		RelationBrowserSettings.defaultRadius=Number(o.defaultRadius);
	
		// startID handed over by embed will override XML startID
		if(startID){
			RelationBrowserSettings.startID=startID;
		}
	
		// copy settings into corresponding class objects (Relation, Node, etc.)
		var o=settingsNode.firstChild.byName("RelationTypes").makeObj().children;
		for (var i in o){
			_root[o[i]._type].adoptProps(o[i]);
		}
		var o=settingsNode.firstChild.byName("NodeTypes").makeObj().children;
		for (var i in o){
			_root[o[i]._type].adoptProps(o[i]);
			nodeTypes.push(o[i]._type);
	}
	}
	// get nodes
	var nodes=indexNode.byName("Nodes").makeObj().children;
	for(var i in nodes) {
		//trace(i+" "+nodes[i].name);
		nodesResult[nodes[i].id] = nodes[i];
		nodeTypesDict[nodes[i]._type]=true;
	}
	
	// get relations	
	
//	relationsResult=indexNode.byName("Relations").makeObj().children;
	for (var i in indexNode.childNodes){
		//trace(i+" "+indexNode.childNodes[i].nodeName);
		if(indexNode.childNodes[i].nodeName=="Relations"){
			var list=indexNode.childNodes[i].childNodes;
			for(var j in list)	relationsResult.push(list[j].makeObj());
		}
	}

	trace(relationsResult.length+" relations parsed.");
	// free space
	delete(this.XMLObj);

	if(this.firstCall){
		RelationBrowserApp.startDisplay(nodesResult, relationsResult, nodeTypes);		
	} else {
		gModel.onMoreDataLoaded(nodesResult, relationsResult);
	}
}