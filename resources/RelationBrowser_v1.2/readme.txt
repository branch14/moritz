	Relation Browser code and .fla files
	by Moritz Stefaner (http://der-mo.net)
	v1.1

	Creative Commons Attribution-NonCommercial-ShareAlike 2.5 License
	(http://creativecommons.org/licenses/by-nc-sa/2.5/)
	please read the license.txt file for more details.
	
-
	SAMPLE APPLICATIONS included in this .zip file: 
	
	>	generic/
		is a good starting point for understanding the XML syntax used 
		and to build your own application.
		
	> 	CIA factbook/
		is a popular example depicting the dependencies between countries,
		continents, oceans and languages.
		
	>	generic springs
		demonstrates how to use the newly added spring based layout mechanism
	
	>	generic combined
		demonstrates how to use the newly added combined based layout mechanism
		It first applies a spring layout and then uses a radial layout best 
		matching the spring-based coordinates.
	
	>	social network/
		is in an experimental state right now, but shows how the Relation
		Browser can be extended to loading images for nodes and how to draw
		arcs instead of straight lines.

-
	SOME TIPS to get you started in adjusting the applications 
	to your needs:
	
 	> 	You want to display a graph structure using the built-in 
		node types (person, document, comment)?
		
 		>	Make a copy of the folder 'generic' and open the
 			relationBrowser.xml file. In there, you will find instructions
			on how to describe your graph structure. 
	
	
	> 	You want to add a new relation type?
	
		>	Add an XML node with the relation type name to the 
			RelationTypes node in the XML file. You can set default values
			for lineSize, color, tooltip text and letter symbol there. 
			
		> 	Add a class with the name of the relation type to
			"RelationClasses.as". It should extend the Relation class
			or any subclass of it.
			
		>	Recompile the Flash movie.
		
		
	> 	You want to add a new node type?  
			
	 	>	Add an XML node with the node type name to the 
	 		NodeTypes in the XML file.  
	 	
	 	>	Add a class with the name of the node type to
	 		"NodeClasses.as". It should extend the Node class
	 		or any subclass of it.
		
		>	Create a Flash symbol in the library with the same name as
			the node type and export it under that name. 
			("export for actionscript").
			
		>	Don't forget to register the symbol name to the class
			(Object.registerClass("linkage_identifier", className))
	 	
	 	>	Recompile the Flash movie.
	
	
	> 	You want to load your data from a script?  
		
		> 	The default path for the XML file is ./relationViewer.xml
			You can specify a different data source by adding 
			
			?dataSource=<your script url here>
			
			after both occurrences of "RelationBrowser.swf" in the 
			HTML file containing the flash movie. You can also set a
			different startID in this way.
			
-

	DEVELOPERS: 
	
	>	The basic object structure is 

		RelationBrowserApp: 
			contains references and initializes model and view, 
			loads the data via XMLadapter
		
		GraphModel:
			stores the graph model, i.e. node and relation data
			delivers node and relation subsets per centered item
			
		GraphView:
			manages interplay of UI elements
			creates and destroy node and relation movieclips
			(see folders Nodes and Relations for corresponding classes)
			contains LayoutManager
			
		LayoutManager:
			manages the repositioning of movieclips after the focus has changed
			
	> 	Caution: The whole event model is very much based on early versions of
		the relation browser and is a bit confusing. I hope I can clean it up soon.
		At the moment, the general procedure is:
		
		 	- user clicks a node
		 	- view.switchView(id)
			
			- if a new layout is necessary: view.display(id)
			- layoutManager.startAnimation()
			
			- or: if no new layout is necessary: layoutManager.startSelectionShift()
			
			- when tweening of clips or springs animation is finished:
			  layoutManager.aniFinished()
			- view.aniFinished()
			
	TODOS in order of preference:
	
	> 	Implement incremental loading instead of loading all at once
	>	Clean up event model, esp. interplay of layoutmanager and view
	>	Working on display for deeper linked nodes (combined layout 
		strategy + different radii should be a good start)
	>	Integrate JavaScript interface
	>	General overhaul and port to AS3 (not before winter)
			