/* ---------------------------------------------------------

	LoadingQueue class
	used to manage sequential clip loading
	
--------------------------------------------------------- */

function LoadingQueue(){
	this.q=[];
	this.isRunning=false;
	this.clipLoader=new MovieClipLoader();
	this.clipLoader.addListener(this);
	trace("new LoadingQueue");
	// check every two seconds for problems
	setInterval(this.checkLoading, 2000, this);
}

LoadingQueue.prototype=new Object();


//
// Instance methods
//
LoadingQueue.prototype.checkLoading=function (_this){

	var p=_this.clipLoader.getProgress(_this.currentTarget.target);
	//trace(".. check "+[p.bytesLoaded,p.bytesTotal, _this.currentTarget.notifyTarget.name, _this.currentTarget.url]);
	if(p.bytesTotal==null && _this.q.length){
		trace("!! something broken in current loading");
		_this.loadNext();
	};

};

LoadingQueue.prototype.enqueue=function (target, url, notifyTarget){
	//trace("LoadingQueue ENQ "+[target,url, notifyTarget]);
	this.q.unshift({target:target, url:url, notifyTarget:notifyTarget});
	if(!this.isRunning) this.loadNext();
};

LoadingQueue.prototype.loadNext=function (){
	if(!this.q.length){
		this.isRunning=false;
		return; 
	}
	this.isRunning=true;
	this.currentTarget=this.q.shift();
	// check for correct url features
	//var isPic=(this.currentTarget.url.indexOf(".png")>-1) || (this.currentTarget.url.indexOf(".jpg")>-1) || (this.currentTarget.url.indexOf(".jpeg")>-1) || (this.currentTarget.url.indexOf(".gif")>-1);
	
	if(this.currentTarget.target  && this.currentTarget.target._visible){
		// OK
		//trace("LoadingQueue loadClip "+this.currentTarget.notifyTarget.name + " "+this.currentTarget.url);
		this.clipLoader.loadClip(this.currentTarget.url, this.currentTarget.target);		
	} else {
		// error
		//trace("LoadingQueue could not load "+this.currentTarget.notifyTarget.name + " "+this.currentTarget.url);
		this.currentTarget.notifyTarget.onLoadError();
		this.loadNext();
	}
};

// the following events could be passed to 
// this.currentTarget.notifyTarget to play loading animations etc.

LoadingQueue.prototype.onLoadStart = function (targetMC) {
	//trace ("LoadingQueue.onLoadStart " + targetMC);
}
LoadingQueue.prototype.onLoadProgress = function (targetMC, loadedBytes, totalBytes) {
}
LoadingQueue.prototype.onLoadComplete = function (targetMC) {
	//trace ("LoadingQueue.onLoadComplete " + targetMC);
}
LoadingQueue.prototype.onLoadInit = function (targetMC) {
	//trace ("LoadingQueue.onLoadInit " + targetMC);
	this.currentTarget.notifyTarget.onLoadInit();
	this.loadNext();
} 
LoadingQueue.prototype.onLoadError = function (targetMC, errorCode) {
	trace ("! LoadingQueue.onLoadError " + targetMC);
	trace ("ERROR = " + errorCode);
	this.currentTarget.notifyTarget.onLoadError();
	this.loadNext();
}