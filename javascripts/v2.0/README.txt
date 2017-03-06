Goals:

WAITWAITWAIT hold the phone. Do I need NEW SCENES, or do I just need to add a RENDER METHOD to old scenes that is optionally called.

I have been a foold (though not much of one 'cause it didn't start yet).  If I make new scenes, I have 2x debug COMBO. I don't want that.
Nobody wants that. If I use exactly the same scenes with a render method, then everything is great. Debug once, run twice.


Let Users enter names for players, just like in Homestuck. (and apparently hunger games simulator)

Write a new scenario controller.  Write new scenes and scene controller. Keep as much of
everything else as you can.

Focus on images. Focus on leader. Focus on dialog.

If the leader does something directly, get standard narration.
Most things happen off screen entirely.
Dramatic things either are narrated (if, say a character dies. ) or pestered.

Let's say the Heir of Time is flipping their shit about having a time clone.
They would pester the Leader and say:

"I am really freaking out about this. I showed up from the FUTURE and then vanished!!!"
but run through their speaking quirk (really replaced with hecka, for example).
You'd get that instead of narration. Also, what they say is based on their Relationship
with the leader. If they hate them, more combatitive, for example.

Dialog is in font color (does quirk have that info or is it in oc_generator? if latter, put in quirk)
and is run through the player's quirk.  Leader can respond. Possible responses kept in the scene itself and run through leader's quirk.

Should dialog be in pesterchum box? How to show which two chars are talking?

Heir of Time:  Yo, Leader dude, I am hecka freaking out about this.
Page of Breath:  What's up, man?
Heir of Time:  I totally just showed up from the future. But, like a doomed future. Not a regular future.
Page of Breath: !!!

Maybe leader on left, pesterchum dialog box in middle, Heir of Time on Right?

Create many quirks for players.  Different categories of quirks, but all go to same place.
Each player has 0 or 1 "very" replacement, "good" replacement, etc.
then a random (but large) number of other ones, like "want to " to "wanna".
Make sure conversational quirks are case insensitive. (how to do this?)

Decide how I want to handle the canvas. Should I have a single canvas whose image changes
with every new on-screen scene?  Should I have multiple that go downwards, like the
100% based story does today?  If I have multiple canvases, how do I differentiate
from one scene to another.  Does narration go on a canvas, or between canvases?

Consider having backgrounds. One background for each non-aspect land word. Pallete swap
based on aspect?

Keep track of what leader knows.  Can't flip out about a player death they are unaware of, right?

Oh man, if leader is one who started sidequest with jack (or at least matches his chump profile), he should try to argue with the
player who suggests exiling jack. YES. So tasty.

For player graphics: need base sprite with shirt in aspect color. Need Prospit/Derse sprites.
Make skin darker grey than even a troll in grimdark mode. How to show Murder Mode (gamzees eyes were red, but i don't have eyes)

Add troll players. In addition to weirder quirks and godtier modes, they need to have 2d relationships. Implement this.
Should troll players have different base sprite? Black shirt with aspect symbol in blood color maybe???


A super ambitious possibility is to render Jack as well. Along with his prototypings. Would need to do artwork. Bluh.

Multiple people have requested character names. Okay. Consider this.  Cons are that it would get rid of the genericness
of the characters, which I kind of like. But adding dialog and quirks already does that.

Shit. I'd have to pick genders. I don't want to care about things like "maids are always girls".  And holy heck: PRONOUNS.
I HATE THOSE THINGS. Why does english have so many different pronouns?  Bluh. "They" is so much easier for a sim like this.
Maybe I'll just call people by their chat handle initials
and ignore picking real names. Even if I add hair to sprites, it'll be genderless.

...
...
...
Should I bite the bullet and add hair as well? Will have to add before horns for trolls.
Hair can be black or white if human. black if troll.

And, as always, kill Hitler. Shit. I mean bugs.

BUGS:

confirm dead queens can't be exiled anymore

best bug: "My witch of light entered murder mode somehow, killed two people, got resurrected, and then blamed the non-dream version of herself for the deaths as though they were a different person."
SHOULD only blame their worst enemy, and shouldn't be your own worst enemy....hrrmrmmm

Why....why are players sometimes spawning dead? cause of death was "after being shown too many stabs from Jack"... ...what the hell? probably a timing issue....

"The Murder Mode Grim Dark Page of Rage brutally murders that asshole, the Sylph of Light's Corpse. The Witch of Mind is pretty pissed that their friend was killed. "
