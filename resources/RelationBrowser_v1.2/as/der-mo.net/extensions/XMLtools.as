// XMLtools.as
// collected by me@der-mo.net

trace("XMLtools loaded.");

/*
	byName:
	
	returns the first XML Node with a given name

*/
XML.prototype.__proto__.byName = function(node_name){
	if(this.nodeName != node_name){
		return this.nextSibling.byName(node_name) || this.firstChild.byName(node_name);
	} else {
		return this;
	}	
}
ASSetPropFlags(XML.prototype.__proto__,["byName"],1);

//*************************************************************************


/* 	XML.makeObj  

	author: me@der-mo.net
	
   	converts an XML Object to a corresponding dot-syntax object.
   	NodeName and NodeValue are translated to _type and _text properties.
   	child nodes are stored in a children array of the parent node.
   	deep recursion.
   	
   	example:
   	trace(new XML("<folder name="folder1"><page attName="attVal">text inside tag</page></folder>").makeObj());
   
   	output:--
   	{
	_type: null
	children: 
		[
			{
			name: folder1
			_type: folder
			children: 
				[
					{
					_text: text inside tag
					attName: attVal
					_type: page
					}
				]
			}
		]
	}

  
	
*/

XML.prototype.__proto__.makeObj = function(){
	// create a result object
	var obj ={};
	
	// set _type property to nodeName
	obj._type=this.nodeName;
	
	// adopt all attributes and their values as properties
	for(var i in this.attributes) obj[i]=this.attributes[i];
	
	// add all children objects to children property Array
	
	if(this.firstChild.nodeType==3){
		// textNode, so we won't have any other children
		//(flash does not support mixed-mode)
		obj._text=this.firstChild.nodeValue;
	} else {
		// loop through children and recursively store them as objects
		var tempChildren=[];
		for(var i in this.childNodes){	
			var childObj=this.childNodes[i].makeObj();
			if(childObj._type!=null) tempChildren.unshift(childObj);
		}
		if(tempChildren.length) obj.children=tempChildren;
	}
	//for(var i in obj) trace(i + " : " + obj[i])
	return obj;
};
ASSetPropFlags(XML.prototype.__proto__,["makeObj"],1);
