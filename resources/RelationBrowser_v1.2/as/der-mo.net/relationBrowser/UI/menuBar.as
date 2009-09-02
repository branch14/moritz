#include "../as/der-mo.net/extensions/HistoryStack.as"

// this file is included in the menubar movieclip
// it contains the drodown menu, the title bar and the history buttons

this.init = function (){
	this.swapDepths(11001);
	
	this.viewManager = _parent.gView;
	this.historyStack=new HistoryStack();
	
	// get title
	this.title_tf.text=_parent.RelationBrowserSettings.appTitle;
	
	// set up combo selection box
	var comboData = [];
	
	for (var i in _parent.gModel.nodesDict){
		comboData.push ({label:_parent.gModel.nodesDict[i].name, id:_parent.gModel.nodesDict[i].id});
	}
	
	this.cBox_cb.setDataProvider (comboData);
	this.cBox_cb.sortItemsBy ("label", "ASC");
};

this.init ();

// combobox click listener
change = function (e){
	this.viewManager.switchView(e.target.getSelectedItem().id);
};
this.cBox_cb.addEventListener("change", this);


// event sent by view when selectedClip has changed
onSelectionChange=function (id){
	for (var i in this.cBox_cb.dataProvider){
		if(this.cBox_cb.dataProvider[i].id==id){
			this.cBox_cb.selectedIndex=i;
		};
	}
};

this.addClickToHistory = function (id){
	this.historyStack.addItem(id);
	trace("addClickToHistory "+id);
	this.updateHistoryButtons ();
};


// click handler for history buttons
this.click = function (mc){
	trace("click "+this.viewManager);
	if (mc == this.forwardButton){
		this.viewManager.switchView (this.historyStack.next());
	}
	if (mc == this.backButton){
		this.viewManager.switchView (this.historyStack.prev());
	}
	this.updateHistoryButtons ();
};

// toggle history buttons
this.updateHistoryButtons = function (){
	if (!this.historyStack.isAtStart()){
		this.backButton.gotoAndStop ("active");
	}
	else{
		this.backButton.gotoAndStop ("inactive");
	}
	if (!this.historyStack.isAtEnd()){
		this.forwardButton.gotoAndStop ("active");
	}
	else{
		this.forwardButton.gotoAndStop ("inactive");
	}
};
