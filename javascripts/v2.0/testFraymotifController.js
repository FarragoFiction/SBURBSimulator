var globalFraymotifCreator = new FraymotifCreator(null);
loadNavbar();
function makeFraymotif(){
		var tier = $('[name="tier"] option:selected');
		var aspects = [];
		$('#aspects :selected').each(function(i, selected){
			aspects.push($(selected).text());
		});
		//in real sim, won't be shuffled, first player will be first element
		var fraymotif = globalFraymotifCreator.makeFraymotif(shuffle(aspects), tier.val());
		$("#fraymotifs").append("<br>" + fraymotif);
}


function shuffle(array) {
	  var currentIndex = array.length, temporaryValue, randomIndex;

	  // While there remain elements to shuffle...
	  while (0 !== currentIndex) {

		// Pick a remaining element...
		randomIndex = Math.floor(Math.random() * currentIndex);
		currentIndex -= 1;

		// And swap it with the current element.
		temporaryValue = array[currentIndex];
		array[currentIndex] = array[randomIndex];
		array[randomIndex] = temporaryValue;
	}

return array;
}