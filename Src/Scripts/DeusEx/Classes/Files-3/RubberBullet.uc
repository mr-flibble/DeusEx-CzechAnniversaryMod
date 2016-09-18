//=============================================================================
// PlasmaBolt.
//=============================================================================
class RubberBullet extends DeusExProjectile;

#exec OBJ LOAD FILE=Effects

event Bump( Actor Other )
{
local float speed2;

speed2 = VSize(Velocity);
if (speed2 > 1000)
  if (Other.IsA('Pawn') || Other.IsA('DeusExDecoration') || Other.IsA('DeusExPickup'))
         Other.TakeDamage(18,Pawn(Owner),Other.Location,0.5*Velocity,'KnockedOut');
}
/*event HitWall(vector HitNormal, actor HitWall)
{
	local float speed;

	Velocity = 0.8*((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	speed = VSize(Velocity);
	bFixedRotationDir = True;
	RotationRate = RotRand(False);
	if ((speed > 0) && (speed < 30) && (HitNormal.Z > 0.7))
	{
		SetPhysics(PHYS_None);
		bStickToWall=True;
		bStuck = True;
		if (Physics == PHYS_None)
			bFixedRotationDir = False;
	}
	else if (speed > 20)
	{
		PlaySound(sound'BasketballBounce', SLOT_Interact);
		AISendEvent('LoudNoise', EAITYPE_Audio);
	}
} */

defaultproperties
{
     blastRadius=6.000000
     DamageType=KnockedOut
     AccurateRange=14400
     maxRange=24000
     spawnAmmoClass=Class'DeusEx.AmmoRubber'
     bIgnoresNanoDefense=True
     ItemName="Rubber Bullet"
     ItemArticle="a"
     speed=12000.000000
     Damage=20.000000
     MomentumTransfer=5000
     SpawnSound=Sound'GMDXSFX.Weapons.ShotgunFire'
     ImpactSound=Sound'DeusExSounds.Generic.BasketballBounce'
     Physics=PHYS_Falling
     LifeSpan=0.000000
     Skin=Texture'HDTPDecos.Skins.HDTPPoolballtex16'
     Mesh=LodMesh'DeusExDeco.Basketball'
     DrawScale=0.200000
     CollisionRadius=1.650000
     CollisionHeight=1.650000
     bBlockActors=True
     bBounce=True
}
