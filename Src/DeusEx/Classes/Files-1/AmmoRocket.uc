//=============================================================================
// AmmoRocket.
//=============================================================================
class AmmoRocket extends DeusExAmmo;

function PostBeginPlay()
{
local DeusExPlayer player;

        super.PostBeginPlay();

        player=DeusExPlayer(GetPlayerPawn());

   if ((player != none) && (player.bHardCoreMode == True))
      if (Owner == None)
    	AmmoAmount = 2;  //CyberP: less ammo on hardcore
}

defaultproperties
{
     bShowInfo=True
     AmmoAmount=3
     MaxAmmo=20
     ItemName="Rockets"
     ItemArticle="some"
     PickupViewMesh=LodMesh'HDTPItems.HDTPgepammo'
     LandSound=Sound'DeusExSounds.Generic.WoodHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoRockets'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoRockets'
     largeIconWidth=46
     largeIconHeight=36
     Description="A gyroscopically stabilized rocket with limited onboard guidance systems for in-flight course corrections. Engineered for use with the GEP gun."
     beltDescription="ROCKET"
     Mesh=LodMesh'HDTPItems.HDTPgepammo'
     CollisionRadius=18.000000
     CollisionHeight=7.800000
     bCollideActors=True
}
