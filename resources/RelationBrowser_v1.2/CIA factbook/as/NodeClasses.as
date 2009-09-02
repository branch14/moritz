/* ---------------------------------------------------------
   
	   Continent class
	   
--------------------------------------------------------- */

// constructor
Continent = function () {
	this.radius=65;
};
//
// inherits from Node
Continent.prototype = new Node();
Object.registerClass("Continent", Continent);


/* ---------------------------------------------------------
   
	   Country class
	   
--------------------------------------------------------- */
// constructor

Country = function (){
};
//
// inherits from Node
Country.prototype = new Node ();
Object.registerClass ("Country", Country);
// special click Action
Country.prototype.onPress = function ()
{
	// bring to center, or showDetails or hideDetails
	// TODO:states or exceptions would be nicer here
	return this.viewManager.switchView (this.id);
};

Country.prototype.getDetails=function (){
	var s=[];
	s.push({label:"Capital", value:this.capital});
	s.push({label:"Government", value:this.government});
	s.push({label:"Date of independence", value:this.indep_date});
	s.push({label:"GDP", value:"$ "+this.gdp_total + " million"});
	s.push({label:"Inflation", value:this.inflation+" %"});
	s.push({label:"Infant Mortality", value:this.infant_mortality+"/1000"});
	s.push({label:"Population Growth", value:this.population_growth +"%"});
	s.push({label:"Population", value:this.population});
	s.push({label:"Area", value:this.total_area + " sq km"});
	return s;
};


/* ---------------------------------------------------------
   
	   Ocean class
	   
--------------------------------------------------------- */
// constructor
Ocean = function () {
	this.radius=50;
};
//
// inherits from Node
Ocean.prototype = new Node();
Object.registerClass("Ocean", Ocean);

/* ---------------------------------------------------------
   
	   SpokenLanguage class
	   
--------------------------------------------------------- */

// constructor
SpokenLanguage = function () {
	this.radius=45;
};
//
// inherits from Node
SpokenLanguage.prototype = new Node();
Object.registerClass("SpokenLanguage", SpokenLanguage);
