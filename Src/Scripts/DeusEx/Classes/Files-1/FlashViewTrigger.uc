//=============================================================================
// EnterWorldTrigger.
//=============================================================================
class FlashViewTrigger extends Trigger;

//CyberP: player red flash event event when touched only. Lazy trigger. May expand

function Touch(Actor Other)
{
	local DeusExPlayer player;

		if(Other.IsA('DeusExPlayer'))
		{
			DeusExPlayer(Other).ClientFlash(0.1, vect(64,0,0));
			DeusExPlayer(Other).IncreaseClientFlashLength(3);
			Destroy();
		}

}

defaultproperties
{
}
