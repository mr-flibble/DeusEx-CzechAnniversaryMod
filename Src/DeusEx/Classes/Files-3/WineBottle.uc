//=============================================================================
// WineBottle.
//=============================================================================
class WineBottle extends DeusExPickup;

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
			player.drugEffectTimer += 5.0;
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
     ItemName="Wine"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPWineBottle'
     PickupViewMesh=LodMesh'HDTPItems.HDTPWineBottle'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPWineBottle'
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconWineBottle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWineBottle'
     largeIconWidth=36
     largeIconHeight=48
     Description="A nice bottle of wine."
     beltDescription="WINE"
     Texture=Texture'HDTPItems.Skins.HDTPWineBottletex2'
     Mesh=LodMesh'HDTPItems.HDTPWineBottle'
     CollisionRadius=5.060000
     CollisionHeight=16.180000
     bCollideWorld=True
     bBlockPlayers=True
     Mass=10.000000
     Buoyancy=8.000000
}
