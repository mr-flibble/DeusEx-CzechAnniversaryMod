//=============================================================================
// Earth.
//=============================================================================
class Earth expands OutdoorThings;

defaultproperties
{
     bStatic=False
     Physics=PHYS_Rotating
     Mesh=LodMesh'DeusExDeco.Earth'
     MultiSkins(0)=Texture'HDTPDecos.Skins.HDTPEarthTex1'
     MultiSkins(1)=Texture'HDTPDecos.Skins.HDTPEarthTex2'
     CollisionRadius=48.000000
     CollisionHeight=48.000000
     bCollideActors=False
     bCollideWorld=False
     bFixedRotationDir=True
     Mass=10.000000
     Buoyancy=5.000000
     RotationRate=(Yaw=-128)
}
