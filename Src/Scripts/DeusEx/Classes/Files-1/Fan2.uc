//=============================================================================
// Fan2.
//=============================================================================
class Fan2 extends DeusExDecoration;

defaultproperties
{
     bHighlight=False
     ItemName="Fan"
     bPushable=False
     Physics=PHYS_Rotating
     Mesh=LodMesh'HDTPDecos.HDTPFan2'
     SoundRadius=10
     AmbientSound=Sound'GMDXSFX.Ambient.fanairduct'
     CollisionRadius=17.660000
     CollisionHeight=16.240000
     bCollideWorld=False
     bFixedRotationDir=True
     Mass=500.000000
     Buoyancy=100.000000
     RotationRate=(Roll=65535)
     BindName="Fan"
}