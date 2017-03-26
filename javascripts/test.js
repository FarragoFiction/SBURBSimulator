window.onload = function() {
  var html = ""
	for(var i = 0; i<12; i++){
      var e = "item number " + i;
      html += " <input type='radio' name='decision' value='" + i + "' id='" +i+"'>"+e + "<br>";
  }
   html += "<button onclick='test()'>Decide</button>"
  $("#test").append(html);
}

function test(){
  var a =$("input[name='decision']:checked").val()
  alert(a);
}
