//=============================================================================
// AIPrototype.
//=============================================================================
class GMDXUnatcoDamHelmet extends DeusExDecoration;

function timer()
{
  SetCollisionSize(4.200000,3.300000);
}

defaultproperties
{
     bInvincible=True
     ItemName="Damaged Helmet"
     Mesh=LodMesh'GMDXSFX.UnatcoHelmet'
     MultiSkins(1)=Texture'GMDXSFX.Skins.hUNATCOTroopTex3'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     Mass=20.000000
}
