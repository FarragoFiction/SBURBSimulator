/* Fix l8r, MUCH later, nothing uses this anymore except my secret char creator

//creates a single svg for each graph to render itself to.
//it will be whatever is ticking's responsibilty to make the graphs and update the data.
//also knows what min and max points are, 'cause a single graph can't know that.
class GraphRenderer {
	var label;
	var graphs;
	var width;
	var height;
	var svg = null;
	num minY = 0;
	num maxY = 0;		//todo, have ticking function create power and light graphs. have graph rendered at stop.

		


	GraphRenderer(this.label, this.graphs, this.width, this.height) {}


	void calculateMinY(){
			for(num i = 0; i<this.graphs.length; i++){
				this.minY = Math.min(this.minY, this.graphs[i].getMinPointValue());
			}
			for(num i = 0; i<this.graphs.length; i++){
				this.graphs[i].minY = this.minY;
			}
		}
	void calculateMaxY(){
			for(num i = 0; i<this.graphs.length; i++){
				this.maxY = Math.max(this.maxY, this.graphs[i].getMaxPointValue());
			}

			for(num i = 0; i<this.graphs.length; i++){
				this.graphs[i].maxY = this.maxY;
				this.graphs[i].width = this.width;
				this.graphs[i].height = this.height;
			}
		}
	void render(){
			if(this.minY == this.maxY){
				//print("calculateing min and max y for: " + this.label);
				this.calculateMinY();
				this.calculateMaxY();
			}
			if(this.svg == null){
				querySelector("#story").append('<svg id="svg' + this.label + '" width="' + width +'" height="' + height + '"></svg><Br><Br>');
				this.svg = querySelector("#svg'+this.label);
			}else{
				this.clearSVG();
			}

			this.drawXAxis();
			this.drawYAxis();
			for(num i = 0; i<this.graphs.length; i++){
				this.graphs[i].render(this.svg);
			}
		}
	void drawXAxis(){
			////print("drawing x axis for: " + this.label + " this.minY is: " + this.minY);
			num min = -1;
			var max =1;
			String headerthingy = 'http:;//www.w3.org/2000/svg';
			var aLine = document.createElementNS(headerthingy, 'line');
			var x1 = bobsMagic(0,this.graphs[0].points.length, 0,0, this.width);
			var x2 = bobsMagic(0,this.graphs[0].points.length, this.graphs[0].points.length, 0, this.width);
			var y1 = bobsMagic(this.minY,this.maxY, 0,this.height, 0)  ;//y is inverted. bluh.;
			var y2 = bobsMagic(this.minY,this.maxY, 0,this.height, 0);
			////print("X1 is made of: num points: " + this.graphs[0].points.length + " and width: " + this.width + ", it's: " + x1);
			aLine.setAttribute('x1',x1);
			aLine.setAttribute('y1',  y1);
			aLine.setAttribute('x2', x2);
			aLine.setAttribute('y2', y2);
			aLine.setAttribute('stroke', '#0000ff');
			aLine.setAttribute('stroke-width', 2);
			this.svg.appendChild(aLine);

			num font = 18;
			var newText = document.createElementNS(headerthingy,"text");
			newText.setAttributeNS(null,"x", x2-font*2);
			newText.setAttributeNS(null,"y", y2+font);
			newText.setAttributeNS(null,"font-size",font);
			var textNode = document.createTextNode(max + " tick");
			newText.appendChild(textNode);
			this.svg.appendChild(newText);

			newText = document.createElementNS(headerthingy,"text");
			newText.setAttributeNS(null,"x", x1-font);
			newText.setAttributeNS(null,"y", y1+font);
			newText.setAttributeNS(null,"font-size",font);
			var textNode = document.createTextNode(min + " tick");
			newText.appendChild(textNode);
			this.svg.appendChild(newText);
	}
	void drawYAxis(){
		var min = this.minY;
		var max = this.maxY;
		String headerthingy = 'http:;//www.w3.org/2000/svg';
		var aLine = document.createElementNS(headerthingy, 'line');
		var x1 = bobsMagic(0,this.graphs[0].points.length, 0,0, this.width);
		var x2 = bobsMagic(0,this.graphs[0].points.length, 0,0, this.width);
		var y1 = bobsMagic(this.minY,this.maxY, this.minY, this.height, 0);
		var y2 = bobsMagic(this.minY,this.maxY, this.maxY, this.height, 0);
		aLine.setAttribute('x1',x1);
		aLine.setAttribute('y1',  y1);
		aLine.setAttribute('x2', x2);
		aLine.setAttribute('y2', y2);
		aLine.setAttribute('stroke', '#ff0000');
		aLine.setAttribute('stroke-width', 2);
		this.svg.appendChild(aLine);

		num font = 18;
		var newText = document.createElementNS(headerthingy,"text");
		newText.setAttributeNS(null,"x", x1+font);
		newText.setAttributeNS(null,"y", y2+font);
		newText.setAttributeNS(null,"font-size",font);
		var textNode = document.createTextNode(max + " " +label);
		newText.appendChild(textNode);
		this.svg.appendChild(newText);

		newText = document.createElementNS(headerthingy,"text");
		newText.setAttributeNS(null,"x", x1+font);
		newText.setAttributeNS(null,"y", y1-font/2);
		newText.setAttributeNS(null,"font-size",font);
		var textNode = document.createTextNode(min + " " +label);
		newText.appendChild(textNode);
		this.svg.appendChild(newText);
	}
	void clearSVG(){
	    while (this.svg.children.length>1) {
	        this.svg.removeChild(svg.children[1]);
	    }
	}

}



//a graph represents a single line. render multiple graphs on top of each other for multiple lines.
class Graph {
	var label;
	var owner_title;
	var points; //array of y values. x is just array index.
	num width = 0;
	num height = 0;	//don't care about MY max min values, but all graphs on this svg.
	num minY = 0;
	num maxY = 0;
	var color;	


	Graph(this.label, this.owner_title, this.points, this.color) {}


	dynamic getMaxPointValue(){
		return this.points.reduce((a, b) {;
			return Math.max(a, b);
		});
	}
	dynamic getMinPointValue(){
		return this.points.reduce((a, b) {;
			return Math.min(a, b);
		});
	}
	void render(svg){

		var first_point = this.points[0];
		for(num i = 1; i<this.points.length; i++ ){
			var second_point = this.points[i];
			////print("first point: " + first_point + " second point: " + second_point);
			var x1 = bobsMagic(0,this.points.length, i-1, 0,this.width);
			var x2 = bobsMagic(0,this.points.length, i, 0,this.width);
			var y1 = bobsMagic(this.minY,this.maxY, first_point, this.height, 0);
			var y2 = bobsMagic(this.minY,this.maxY, second_point, this.height, 0);
			this.renderLine(svg, x1, y1, x2, y2);
			this.renderPoint(svg, x1, y1,first_point);
			this.renderPoint(svg, x2, y2,second_point);
			//init for next round
			first_point = this.points[i];
		}
	}
	void renderLine(svg, x1, y1, x2, y2){
		var aLine = document.createElementNS('http:;//www.w3.org/2000/svg', 'line');
		aLine.setAttribute('x1', x1);
		aLine.setAttribute('y1',  y1);
		aLine.setAttribute('x2', x2);
		aLine.setAttribute('y2',  y2);
		aLine.setAttribute('stroke', this.color);
		aLine.setAttribute('stroke-width', 2);
		svg.appendChild(aLine);
	}
	void renderPoint(svg, x, y, value){
		var shape = document.createElementNS('http:;//www.w3.org/2000/svg', "circle");
		shape.setAttributeNS(null, "cx", x);
		shape.setAttributeNS(null, "cy",  y);
		shape.setAttributeNS(null, "r",  4);
		shape.setAttributeNS(null, "fill", "black");
		var that = this;
		var mousetext = null;
		shape.onmouseover = (e){
			mousetext = document.createElementNS('http:;//www.w3.org/2000/svg',"text");
			mousetext.setAttributeNS(null,"x", x);
			mousetext.setAttributeNS(null,"y", y+12);
			mousetext.setAttributeNS(null,"font-size",12);
			var textNode = document.createTextNode(that.owner_title + ": " + value);
			mousetext.appendChild(textNode);
			svg.append(mousetext);
		};

		shape.onmouseout = (e){
			svg.removeChild(mousetext);
		}
		svg.appendChild( shape );


	}

}



dynamic getGraphWithLabel(graphs, label){
	for(var j= 0; j<graphs.length; j++){
		var graph = graphs[j];
		if(graph.label == label){
			return graph;
		}
	}
	return null;
}



dynamic getAllGraphsForPlayersNamed(players, label){
	List<dynamic> ret = [];
	for(num i = 0; i<players.length; i++){
		ret.add(getGraphWithLabel(players[i].graphs, label))
	}
	return ret;
}



//converts from one coordinate space to another
//I am just unbelivably shitty at coordinates. thanks, bob!
dynamic bobsMagic(fromMin, fromMax, input, toMin, toMax){
	/*
	//print("From Min: " + fromMin);
	//print("From Max: " + fromMax);
	//print("input: " + input);
	//print("toMin: " + toMin);
	//print("To Max: " + toMax);
	*/
	var tmp = (input - fromMin)/(fromMax - fromMin);
	return (toMax - toMin) * tmp + toMin;
}
*/