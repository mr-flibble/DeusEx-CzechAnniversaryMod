//=============================================================================
// Flare.
//=============================================================================
class Flare extends DeusExPickup;

#exec import file=Effects
#exec import file=HDTPanim

var ParticleGenerator gen, gen2, flaregen;
var effects flamething; //trying very hard not to introduce extra classes
var() float flaretime; //added DDL: because hardcoded numbers are TEH STUPID

//ok for this one I've actually done a fair bit of coding
//it's basically the vastly nicer looking one I made for QE,
//but since that's still miles off release point, what the hell

function ExtinguishFlare()
{
	LightType = LT_None;
	AmbientSound = None;
	if (gen != None)
		gen.DelayedDestroy();
	if (gen2 != None)
		gen2.DelayedDestroy();
	if (flaregen != None)
		flaregen.DelayedDestroy();
	if(flamething != none)
		flamething.Destroy();
}

function tick(float DT)
{
	if(gen != none)
		UpdateGens();

	super.Tick(dt);
}


function UpdateGens()
{
	local vector loc, loc2;
	local rotator rota;

	if(gen != none)
	{
		loc2.Y += collisionradius*1.05;
		loc = loc2 >> rotation;
		loc += location;
		gen.SetLocation(loc);
		gen.SetRotation(rotator(loc - location));
	}

    if(gen2 != none)
	{
		loc2.Y += collisionradius*1.05;
		loc = loc2 >> rotation;
		loc += location;
		gen2.SetLocation(loc);
		gen2.SetRotation(rotator(loc - location));
	}

	if(flaregen != none)
	{
		loc2.Y += collisionradius*0.8;
		loc = loc2 >> rotation;
		loc += location;
		//rota = rotation;
		//rota.Roll = 0;
		//rota.Yaw += 16384;
		flaregen.SetLocation(loc);
		//flaregen.SetRotation(rota);
		flaregen.SetRotation(rotator(loc - location));

//		if(FF != none)
//		{
//			FF.SetLocation(locac);
//			FF.SetRotation(rotator(loc - location));
//		}
	}
	if(flamething != none)
	{
		if(flamething.location != Location)
			flamething.setlocation(Location); //bah!

		rota = rotation;
		rota.pitch += 4096*(frand()-0.5);
		flamething.setrotation(rota);
		if(lifespan > 2)
			flamething.DrawScale = 0.1 + 0.3*lifespan/flaretime;
		else
		{
			flamething.Destroy();
			Spawn(class'FlareShell',,,Location,Rotation);
			Destroy();
		}
	}
}

auto state Pickup
{
	function ZoneChange(ZoneInfo NewZone)
	{
		//if (NewZone.bWaterZone)
		//if (gen != None)
		//gen.DelayedDestroy(); //CyberP: flares work in water.
			//ExtinguishFlare();

		Super.ZoneChange(NewZone);
	}

    function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{

		if ((DamageType == 'Shot') || (DamageType == 'Exploded'))
        LightFlare();

        super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
    }

	function Frob(Actor Frobber, Inventory frobWith)
	{
		// we can't pick it up again if we've already activated it
		if (gen == None)
			Super.Frob(Frobber, frobWith);
		else if (Frobber.IsA('Pawn'))
			Pawn(Frobber).ClientMessage(ExpireMessage);
	}
}

state Activated
{
	function ZoneChange(ZoneInfo NewZone)
	{
		//if (NewZone.bWaterZone)
		//	ExtinguishFlare();

		Super.ZoneChange(NewZone);
	}

	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local Flare flare;

		Super.BeginState();

		// Create a Flare and throw it
		flare = Spawn(class'Flare', Owner);
		flare.LightFlare();

		UseOnce();
	}
Begin:
}

function LightFlare()
{
	local Vector X, Y, Z, dropVect, loc, loc2, offset;
	local Pawn P;
	local rotator rota;

	if (gen == None)
	{
		Multiskins[1]=texture'pinkmasktex';
		LifeSpan = flaretime;
		bUnlit = True;
		LightType = LT_Steady;
		AmbientSound = Sound'Flare';

		P = Pawn(Owner);
		if (P != None)
		{
			GetAxes(P.ViewRotation, X, Y, Z);
			dropVect = P.Location + 0.8 * P.CollisionRadius * X;
			dropVect.Z += P.BaseEyeHeight;
			if (P.IsA('ScriptedPawn'))
			{
			    //Velocity = Vector(P.ViewRotation) * 800 + vect(0,0,220);
			}
			else
			    Velocity = Vector(P.ViewRotation) * 500 + vect(0,0,220);
			bFixedRotationDir = True;
			RotationRate = RotRand(False);
			if (!P.IsA('ScriptedPawn'))
			    DropFrom(dropVect);

			// increase our collision height so we light up the ground better
			SetCollisionSize(CollisionRadius, CollisionHeight*2);
		}

		loc2.Y += collisionradius*1.05;
		loc = loc2 >> rotation;
		loc += location;
		gen = Spawn(class'ParticleGenerator', Self,, Loc, rot(16384,0,0));
		if (gen != None)
		{
			//gen.attachTag = Name;
			//gen.SetBase(Self);
			gen.LifeSpan = flaretime;
			gen.bRandomEject = True;
			gen.bParticlesUnlit = false;
			gen.ejectSpeed = 30;
			gen.riseRate = 10;
			gen.checkTime = 0.075;
			gen.particleLifeSpan = 5;
			gen.particleDrawScale = 0.075;
			gen.particleTexture = Texture'GMDXSFX.Effects.ef_ExpSmoke001';//Texture'Effects.Smoke.SmokePuff1';
		}
		gen2 = Spawn(class'ParticleGenerator', Self,, Loc, rot(16384,0,0));
		if (gen2 != None)
		{
			//gen.attachTag = Name;
			//gen.SetBase(Self);
			gen2.LifeSpan = flaretime;
			gen2.bRandomEject = True;
			gen2.bParticlesUnlit = false;
			gen2.ejectSpeed = 30;
			gen2.riseRate = 10;
			gen2.checkTime = 0.075;
			gen2.particleLifeSpan = 5;
			gen2.particleDrawScale = 0.1;
			gen2.particleTexture = Texture'GMDXSFX.Effects.ef_ExpSmoke002';//Texture'Effects.Smoke.SmokePuff1';
		}
		loc2.Y = collisionradius*0.8;    //I hate coordinate shifting
		loc = loc2 >> rotation;
		loc += location;
		rota = rotation;
		rota.Roll = 0;
		rota.Yaw += 16384;
		flaregen = Spawn(class'ParticleGenerator',Self,, Loc, rota);
		if (flaregen != None)
		{
			flaregen.LifeSpan = flaretime;
			flaregen.attachTag = Name;
			flaregen.SetBase(Self);
			flaregen.bRandomEject=true;
			flaregen.RandomEjectAmt=0.1;
			flaregen.bParticlesUnlit=true;
			flaregen.frequency=0.5 + 0.5*frand();
			flaregen.numPerSpawn=2;
			flaregen.bGravity=false;
			flaregen.ejectSpeed = 100;
			flaregen.riseRate = -1;
			flaregen.checkTime = 0.02;
			flaregen.particleLifeSpan = 0.6*(1 + frand());
			flaregen.particleDrawScale = 0.05 + 0.05*frand();
			flaregen.particleTexture = Texture'HDTPAnim.effects.HDTPFlarespark';
		}
		flamething = Spawn(class'Effects', Self,, Location, rotation);
		if(flamething != none)
		{
			flamething.setbase(self);
			flamething.DrawType=DT_mesh;
			flamething.mesh=lodmesh'HDTPItems.HDTPflareflame';
			flamething.multiskins[1]=texture'HDTPanim.effects.HDTPflrflame';
			flamething.Style=STY_Translucent;
			flamething.bUnlit=true;
			flamething.DrawScale=0.4;
			flamething.Scaleglow=5;
			flamething.lifespan=0;
			flamething.bHidden=false;
			flamething.LightType=LT_Steady;
            flamething.LightBrightness=96;
            flamething.LightHue=16;
            flamething.LightSaturation=96;
            flamething.LightRadius=24;
		}
	}
}

defaultproperties
{
     flaretime=80.000000
     maxCopies=30
     bCanHaveMultipleCopies=True
     ExpireMessage="It's already been used"
     bActivatable=True
     ItemName="Flare"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPflare'
     PickupViewMesh=LodMesh'HDTPItems.HDTPflare'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPflare'
     Icon=Texture'DeusExUI.Icons.BeltIconFlare'
     largeIcon=Texture'DeusExUI.Icons.LargeIconFlare'
     largeIconWidth=42
     largeIconHeight=43
     Description="A flare."
     beltDescription="FLARE"
     Mesh=LodMesh'HDTPItems.HDTPflare'
     SoundRadius=16
     SoundVolume=96
     CollisionRadius=6.200000
     CollisionHeight=1.300000
     bCollideWorld=True
     bBlockPlayers=True
     LightEffect=LE_TorchWaver
     LightBrightness=224
     LightHue=16
     LightSaturation=96
     LightRadius=16
     Mass=2.000000
     Buoyancy=1.000000
}
