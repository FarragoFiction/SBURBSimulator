//creates a single svg for each graph to render itself to.
//it will be whatever is ticking's responsibilty to make the graphs and update the data.
function GraphRenderer(graphs, width, height){
		this.graphs = graphs;
		this.width = width;
		this.height = height;
}

//a graph represents a single line. render multiple graphs on top of each other for multiple lines.
function Graph(points,width, height,color){
	this.points = points; //array of y values. x is just array index.
	this.width = width;
	this.height = height;
	this.color = color;
	this.getMaxPointValue = function(){
		return this.points.reduce(function(a, b) {
			return Math.max(a, b);
		});
	}
	
	this.getMinPointValue = function(){
		return this.points.reduce(function(a, b) {
			return Math.min(a, b);
		});
	}
	
	this.render = function(){
		
	}
	
	this.renderLine = function(x1,y1,x2,y2){
		var aLine = document.createElementNS('http://www.w3.org/2000/svg', 'line');
		aLine.setAttribute('x1', x1);
		aLine.setAttribute('y1',  y1);
		aLine.setAttribute('x2', x2);
		aLine.setAttribute('y2',  y2);
		aLine.setAttribute('stroke', this.color);
		aLine.setAttribute('stroke-width', 2);
		svg.appendChild(aLine);
	}
	
	this.renderPoint = function(x,y){
		var shape = document.createElementNS('http://www.w3.org/2000/svg', "circle");
		shape.setAttributeNS(null, "cx", bobsMagic(0,this.points.length, 0, this.width));
		shape.setAttributeNS(null, "cy",  bobsMagic(this.getMinPointValue(), this.getMaxPointValue(), 0, this.height));
		shape.setAttributeNS(null, "r",  5);
		shape.setAttributeNS(null, "fill", "black");
		svg.appendChild( shape );
	}
}



//converts from one coordinate space to another
//I am just unbelivably shitty at coordinates. thanks, bob!
function bobsMagic(fromMin, fromMax, input, toMin, toMax){
	var tmp = (input - fromMin)/(fromMax - fromMin)
	return (toMax - toMin) * tmp + toMin;
}
