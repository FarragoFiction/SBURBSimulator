//just loads the navbar.text into the appropriate div.
function loadNavbar(){
	$.ajax({
		url: "navbar.txt",
		success:(function(data){
		 $("#navbar").html(data)
		}),
		dataType: "text"
	});
}
