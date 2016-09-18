//=============================================================================
// LiquorBottle.
//=============================================================================
class LiquorBottle extends DeusExPickup;

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local DeusExPlayer player;

		Super.BeginState();

		player = DeusExPlayer(GetPlayerPawn());

		if (player != none && player.fullUp >= 15)
		{
		player.ClientMessage(player.fatty);
		return;
		}

		if (player != None)
		{
			player.HealPlayer(2, False);
			player.drugEffectTimer += 4.0;
			player.PlaySound(sound'drinkwine',SLOT_None);
		}

		UseOnce();
	}
Begin:
}

defaultproperties
{
     bBreakable=True
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Liquor"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPLiquorBottle'
     PickupViewMesh=LodMesh'HDTPItems.HDTPLiquorBottle'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPLiquorBottle'
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconLiquorBottle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconLiquorBottle'
     largeIconWidth=20
     largeIconHeight=48
     Description="The label is torn off, but it looks like some of the good stuff."
     beltDescription="LIQUOR"
     Texture=Texture'HDTPItems.Skins.HDTPLiquorBottletex2'
     Mesh=LodMesh'HDTPItems.HDTPLiquorBottle'
     CollisionRadius=5.620000
     CollisionHeight=12.500000
     bCollideWorld=True
     bBlockPlayers=True
     Mass=10.000000
     Buoyancy=8.000000
}
