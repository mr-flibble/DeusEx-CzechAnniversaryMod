//=============================================================================
// AttackHelicopter.
//=============================================================================
class AttackHelicopter extends Vehicles;

auto state Flying
{
	function BeginState()
	{
		Super.BeginState();
		LoopAnim('Fly');
	}
}

singular function SupportActor(Actor standingActor)
{
	// kill whatever lands on the blades
	if (standingActor != None)
		standingActor.TakeDamage(10000, None, standingActor.Location, vect(0,0,0), 'Exploded');
}

defaultproperties
{
     ItemName="Attack Helicopter"
     Mesh=LodMesh'DeusExDeco.AttackHelicopter'
     SoundRadius=160
     SoundVolume=255
     AmbientSound=Sound'Ambient.Ambient.Helicopter'
     CollisionRadius=461.230011
     CollisionHeight=87.839996
     Mass=6000.000000
     Buoyancy=1000.000000
}
