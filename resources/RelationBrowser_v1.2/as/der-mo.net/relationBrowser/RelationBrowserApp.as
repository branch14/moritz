#include "../as/der-mo.net/relationBrowser/RelationBrowserClasses.as"


RelationBrowserSettings={};

// if no external data source is set, use default
RelationBrowserSettings.dataSource=(!dataSource?"relationBrowser.xml":dataSource);

/*
	APP INSTANCE
*/

RelationBrowserApp={};

onEnterFrame=function (){
	if (getBytesLoaded()==getBytesTotal()) {
		onEnterFrame=null;
		RelationBrowserApp.setState("loaded");
		RelationBrowserApp.setUp();
	}
};

RelationBrowserApp.setUp=function(){
  	trace("RelationBrowserApp APP");

	gView = attachMovie("GraphViewMC", "GraphViewMC", 1);
  	gModel = new GraphModel();

  	gXMLadapter= new XMLadapter(this);
	gXMLadapter.loadAndParseData(RelationBrowserSettings.dataSource);
}

RelationBrowserApp.startDisplay=function(nodesResult, relationsResult, nodeTypes){
	// go to display frame
	this.setState("display");
	
	// create model
	gModel.setUp(nodesResult, relationsResult, nodeTypes);
	gView.init(gModel);
	
	// display default item (identified by startID) in center
	gView.switchView();
}


// set application states
RelationBrowserApp.setState=function(s){
	trace("RelationBrowserApp.setState "+s);
  
	switch(s){
    	case "loaded":
	      	break;
	    case "loading XML":
			_root.menu.messageWindow.textfield_mc.message_tf.text="Loading Data.";
			break;
	    case "XMLloaded":
			_root.menu.messageWindow.textfield_mc.message_tf.text="Data loaded.";
			break;
	    case "error":
			_root.menu.messageWindow.textfield_mc.message_tf.text="Error loading data.";
			break;
	    case "display":  
			_root.menu.init();
			_root.menu.messageWindow.textfield_mc.message_tf.text="";
			break;
	  }
}

// resizing

onResize = function () {
	var w=Math.floor(Stage.width);
	var h=Math.floor(Stage.height);
	
	_root.bg._width=w;
	_root.bg._height=h;
	
	_root.menu.bg._width=w;
	
	_root.menu.cBox_cb._x=w-_root.menu.cBox_cb._width-10;
	_root.sidebar._x=_root.menu.cBox_cb._x;
	
	_root.copyrightNote._x=w-10;
	_root.copyrightNote._y=h;
	gView.setComponentPositions();
}

Stage.scaleMode = "noScale";
Stage.align="TL";
onResize();

Stage.addListener(this);
