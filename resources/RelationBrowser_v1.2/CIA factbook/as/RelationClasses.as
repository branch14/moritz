// special relation classes for displaying the CIA world factbook data

/* ---------------------------------------------------------
   
	   hasBorderTo class
	   
--------------------------------------------------------- */

function hasBorderTo(relObj, fromMC, toMC, drawTarget, viewManager){
	super(relObj, fromMC, toMC, drawTarget, viewManager);
	if(!this.color){
		this.color=hasBorderTo.color;
	}
	if(!this.lineSize){
		this.lineSize=hasBorderTo.lineSize;
	}
	if(!this.letterSymbol){
		this.letterSymbol=hasBorderTo.letterSymbol;
	}
	if(!this.labelText){
		this.labelText=hasBorderTo.labelText;
	}
}

hasBorderTo.prototype=new UndirectedRelation();

/* ---------------------------------------------------------
   
	   isSpokenIn class
	   
--------------------------------------------------------- */

function isSpokenIn(relObj, fromMC, toMC, drawTarget, viewManager){
	super(relObj, fromMC, toMC, drawTarget, viewManager);
	if(!this.color){
		this.color=isSpokenIn.color;
	}
	if(!this.lineSize){
		this.lineSize=isSpokenIn.lineSize;
	}
	if(!this.letterSymbol){
		this.letterSymbol=isSpokenIn.letterSymbol;
	}
	if(!this.labelText){
		this.labelText=isSpokenIn.labelText;
	}
}

isSpokenIn.prototype=new DirectedRelation();

/* ---------------------------------------------------------
   
	   isPartOf class
	   
--------------------------------------------------------- */

function isPartOf(relObj, fromMC, toMC, drawTarget, viewManager){
	
	super(relObj, fromMC, toMC, drawTarget, viewManager);
	if(!this.color){
		this.color=isPartOf.color;
	}
	if(!this.lineSize){
		this.lineSize=isPartOf.lineSize;
	}
	if(!this.letterSymbol){
		this.letterSymbol=isPartOf.letterSymbol;
	}
	if(!this.labelText){
		this.labelText=isPartOf.labelText;
	}
}

isPartOf.prototype=new DirectedRelation();