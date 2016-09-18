//=============================================================================
// AmmoDart.
//=============================================================================
class AmmoDart extends DeusExAmmo;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
      AmmoAmount = 6;
}

defaultproperties
{
     bShowInfo=True
     AmmoAmount=3
     MaxAmmo=60
     ItemName="Darts"
     ItemArticle="some"
     PickupViewMesh=LodMesh'DeusExItems.AmmoDart'
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     Icon=Texture'GMDXSFX.Icons.BeltIconSteelDart'
     largeIcon=Texture'GMDXSFX.Icons.LargeIconSteelDart'
     largeIconWidth=20
     largeIconHeight=47
     Description="The mini-crossbow dart is a favored weapon for many 'wet' operations; however, silent kills require a high degree of skill."
     beltDescription="DART"
     Skin=Texture'GMDXSFX.Skins.DartAmmo'
     Mesh=LodMesh'DeusExItems.AmmoDart'
     CollisionRadius=8.500000
     CollisionHeight=2.000000
     bCollideActors=True
}
