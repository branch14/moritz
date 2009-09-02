// this file is included into the sidebar movieclip
// used to display details of the selected node

function update(selectedClip){

	canvas=createEmptyMovieClip("canvas",1);
	
	var displayProperties=selectedClip.getDetails();
	
	var y=0;	
	var depth=0;
	
	for(var i=0; i<displayProperties.length; i++){
		
		// check if there is something to display
		if(displayProperties[i].label==null ||displayProperties[i].value==null) continue;

		// if yes: attach a key-value block		
		var mc=canvas.attachMovie("sidebarKeyValueBlock", +"clip"+depth, depth++, {label:displayProperties[i].label, value:displayProperties[i].value});
    	
		// add special click action
		if(displayProperties[i].contentType=="URL"){
			mc.onPress=function (){
				getURL(this.value, "_blank");
			};
		}

		mc.key_tf.text=mc.label;
		mc.value_tf.text=mc.value;
		mc.value_tf._height=mc.value_tf.textHeight+5;
		mc._y=y;
		y+=mc._height;
	}		
	
	if(!canvas._height){
		canvas.attachMovie("noDetailsAvailable", "noDetailsAvailable", 1);
	}
	
	bg1._height=canvas._height+5;
	
	// set sidebar y to middle of selected clip
	/*
	var yMiddle=(selectedClip.getBounds(_parent).yMin+selectedClip.getBounds(_parent).yMax)*.5;
	this._y=Math.min(Stage.height-y-30,Math.max(50,yMiddle-y*.5));
	*/	
};
setUp();


function setUp(){
	this.swapDepths(11000);	
	bg1._height=0;
};
