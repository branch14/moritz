/* ---------------------------------------------------------

	Set class
	Array with unique members
		
--------------------------------------------------------- */
// constructor
 
function Set (){
}
 
// ----------------------------------------------------- 
// inheritance

Set.prototype = new Array();
 
// -----------------------------------------------------
// instance methods
Set.prototype.removeItem = function (o){
	for(var i=0;i<this.length; i++){
      if(this[i]==o) {
          this.splice(i,1);
          return true;
        }
   }
   return false;
}
Set.prototype.addItem = function (o){
	for(var i=0;i<this.length; i++){
      if(this[i]==o) {
          return false;
        }
   }
   this.push(o);
   return true;
}

Set.prototype.addItems = function (o){
	for(var i=0;i<o.length; i++){
		this.addItem(o[i]);
   }
}