/* ---------------------------------------------------------

	HistoryStack class
	special array with a position marker 
	to manage history navigation
	
--------------------------------------------------------- */

function HistoryStack(){
	this.pos=0;
}

HistoryStack.prototype=new Array();


//
// Instance methods
//

HistoryStack.prototype.addItem=function (o){
	
	// item to be added is already at the current position -> do nothing
	if(this.getCurrent()==o) return; 
	
	// if we are in the middle of the stack, delete rest
	if(this.pos<this.length-1){
		this.splice(this.pos);
	}
	
	// delete other occurences of the same object
	for(var i=0;i<this.length; i++){
    	if(this[i]==o) {
    		this.splice(i,1);
    		i--;
		}
	}
	
	this.push(o);
	this.pos=this.length-1;
};

HistoryStack.prototype.next=function (){
	return this[++this.pos];
};

HistoryStack.prototype.prev=function (){
	return this[--this.pos];	
};

HistoryStack.prototype.isAtStart=function (){
	return this.pos==0;
};

HistoryStack.prototype.isAtEnd=function (){
	return this.pos==this.length-1;	
};

HistoryStack.prototype.getCurrent=function (){
	return this[this.pos];	
};