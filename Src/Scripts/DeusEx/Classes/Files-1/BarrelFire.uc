//=============================================================================
// BarrelFire.
//=============================================================================
class BarrelFire extends Containers;

var float lastDamageTime;

function DamageOther(Actor Other)
{
	if ((Other != None) && !Other.IsA('ScriptedPawn'))
	{
		// only take damage every second
		if (Level.TimeSeconds - lastDamageTime >= 1.0)
		{
			Other.TakeDamage(2, None, Location, vect(0,0,0), 'Burned');
			lastDamageTime = Level.TimeSeconds;
		}
	}
}

function PostBeginPlay()
{
super.PostBeginPlay();

if (FRand() < 0.6)      //CyberP:
  AmbientSound=Sound'Ambient.Ambient.FireSmall1';
}

singular function SupportActor(Actor Other)
{
	DamageOther(Other);
	Super.SupportActor(Other);
}

singular function Bump(Actor Other)
{
	DamageOther(Other);
	Super.Bump(Other);
}

defaultproperties
{
     HitPoints=40
     bInvincible=True
     bFlammable=False
     ItemName="Burning Barrel"
     bBlockSight=True
     Mesh=LodMesh'HDTPDecos.HDTPBarrelFire'
     ScaleGlow=2.000000
     bUnlit=True
     SoundRadius=20
     SoundVolume=255
     AmbientSound=Sound'Ambient.Ambient.FireSmall2'
     CollisionRadius=20.000000
     CollisionHeight=29.000000
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=128
     LightHue=32
     LightSaturation=64
     LightRadius=6
     Mass=300.000000
     Buoyancy=270.000000
}
