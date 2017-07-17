

window.onload = () {
  String html = "";
	for(int i = 0; i<12; i++){
      String e = "item number " + i;
      html += " <input type;='radio' name='decision' value;='" + i + "' id='" +i+"'>"+e + "<br>";
  }
   html += "<button onclick;='test()'>Decide</button>"
  querySelector("#test").append(html);
}

void test(){
  var a =querySelector("input[name;='decision']:checked").val();
  alert(a);
}
