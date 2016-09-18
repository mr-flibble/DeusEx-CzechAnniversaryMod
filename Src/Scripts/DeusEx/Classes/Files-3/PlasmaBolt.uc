//=============================================================================
// PlasmaBolt.
//=============================================================================
class PlasmaBolt extends DeusExProjectile;

var ParticleGenerator pGen1;
var ParticleGenerator pGen2;

var float mpDamage;
var float mpBlastRadius;

#exec OBJ LOAD FILE=Effects

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ParticleGenerator gen;
	local ExplosionLight bright;

    PlaySound(Sound'DeusExSounds.Generic.MediumExplosion1',SLOT_None,1.5,,2048);
	// create a particle generator shooting out plasma spheres
	Spawn(class'SphereEffectPlasma');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	gen = Spawn(class'ParticleGenerator',,, HitLocation, Rotator(HitNormal));
	if (gen != None)
	{
		bright = Spawn(class'ExplosionLight',,,HitLocation+(Vector(Rotation)*4.5), Rotation);
		bright.size = 16;


     		bright.LightBrightness=255;
     		bright.LightHue=80;
     		bright.LightSaturation=96;

		gen.RemoteRole = ROLE_None;
		gen.particleDrawScale = 1.0;
		gen.checkTime = 0.10;
		gen.frequency = 1.0;
		gen.ejectSpeed = 200.0;
		gen.bGravity = True;
		gen.bRandomEject = True;
		gen.particleLifeSpan = 0.75;
		gen.particleTexture =Texture'Effects.Fire.Proj_PRifle';
		gen.LifeSpan = 1.3;

	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ((Level.NetMode == NM_Standalone) || (Level.NetMode == NM_ListenServer))
		SpawnPlasmaEffects();
}

simulated function PostNetBeginPlay()
{
	if (Role < ROLE_Authority)
		SpawnPlasmaEffects();
}

// DEUS_EX AMSD Should not be called as server propagating to clients.
simulated function SpawnPlasmaEffects()
{
	local Rotator rot;
	rot = Rotation;
	rot.Yaw -= 32768;

	pGen2 = Spawn(class'ParticleGenerator', Self,, Location, rot);
	if (pGen2 != None)
	{
		pGen2.RemoteRole = ROLE_None;
		pGen2.particleTexture = Texture'Effects.Fire.Proj_PRifle';
		pGen2.particleDrawScale = 0.1;
		pGen2.checkTime = 0.01; //Cyber: was 0.04
		pGen2.riseRate = 0.0;
		pGen2.ejectSpeed = 100.0;
		pGen2.particleLifeSpan = 0.6; //CyberP: was check
		pGen2.bRandomEject = True;
		pGen2.SetBase(Self);
	}
}

simulated function Destroyed()
{
	if (pGen1 != None)
		pGen1.DelayedDestroy();
	if (pGen2 != None)
		pGen2.DelayedDestroy();

	Super.Destroyed();
}

defaultproperties
{
     mpDamage=20.000000
     mpBlastRadius=288.000000
     bExplodes=True
     blastRadius=192.000000
     DamageType=Burned
     AccurateRange=14400
     maxRange=24000
     bIgnoresNanoDefense=True
     ItemName="Plasma Bolt"
     ItemArticle="a"
     speed=1500.000000
     Damage=20.000000
     MomentumTransfer=5000
     SpawnSound=Sound'DeusExSounds.Weapons.PlasmaRifleFire'
     ImpactSound=Sound'DeusExSounds.Weapons.PlasmaRifleHit'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     Skin=Texture'HDTPDecos.Skins.HDTPAlarmLightTex4'
     Mesh=LodMesh'DeusExItems.PlasmaBolt'
     DrawScale=2.200000
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=224
     LightHue=80
     LightSaturation=128
     LightRadius=8
     bFixedRotationDir=True
}
