//=============================================================================
// DeusExProjectile.
//=============================================================================
class DeusExProjectile extends Projectile
	abstract;

var bool bExplodes;				// does this projectile explode?
var bool bBlood;				// does this projectile cause blood?
var bool bDebris;				// does this projectile cause debris?
var bool bStickToWall;			// does this projectile stick to walls?
var bool bStuck;				// is this projectile stuck to the wall?
var vector initDir;				// initial direction of travel
var float blastRadius;			// radius to explode
var Actor damagee;				// who is being damaged
var name damageType;			// type of damage that this projectile does
var int AccurateRange;			// maximum accurate range in world units (feet * 16)
var int MaxRange;				// maximum range in world units (feet * 16)
var vector initLoc;				// initial location for range tracking
var bool bTracking;				// should this projectile track a target?
var Actor Target;				// what target we are tracking
var float time;					// misc. timer
var float MinDrawScale;
var float MaxDrawScale;

var vector LastSeenLoc;    // Last known location of target
var vector NetworkTargetLoc; // For network propagation (non relevant targets)
var bool bHasNetworkTarget;
var bool bHadLocalTarget;

var int gradualHurtSteps;		// how many separate explosions for the staggered HurtRadius
var int gradualHurtCounter;		// which one are we currently doing

var bool bEmitDanger;
var class<DeusExWeapon>	spawnWeaponClass;	// weapon to give the player if this projectile is disarmed and frobbed
var class<Ammo>			spawnAmmoClass;		// weapon to give the player if this projectile is disarmed and frobbed

var bool bIgnoresNanoDefense; //True if the aggressive defense aug does not blow this up.

var bool bAggressiveExploded; //True if exploded by Aggressive Defense

var localized string itemName;		// human readable name
var localized string	itemArticle;	// article much like those for weapons

var float WarningTimer;              //GMDX: send projectile warning again
var bool bContactDetonation;            //CyberP: explode upon contact
// network replication
replication
{
	//server to client
	reliable if (Role == ROLE_Authority)
	  bTracking, Target, bAggressiveExploded, bHasNetworkTarget, NetworkTargetLoc;
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (bEmitDanger)
		AIStartEvent('Projectile', EAITYPE_Visual);
}

//
// Let the player pick up stuck projectiles
//
function Frob(Actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	// if the player frobs it and it's stuck, the player can grab it
	if (bStuck)
		GrabProjectile(DeusExPlayer(Frobber));
}

function GrabProjectile(DeusExPlayer player)
{
	local Inventory item;

	if (player != None)
	{
		if (spawnWeaponClass != None)		// spawn the weapon
		{
			item = Spawn(spawnWeaponClass);
			if (item != None)
			{
				if ( (Level.NetMode != NM_Standalone ) && Self.IsA('Shuriken'))
					DeusExWeapon(item).PickupAmmoCount = DeusExWeapon(item).PickupAmmoCount * 3;
				else
					DeusExWeapon(item).PickupAmmoCount = 1;
			}
		}
		else if (spawnAmmoClass != None)	// or spawn the ammo
		{
			item = Spawn(spawnAmmoClass);
			if (item != None)
			{
				if ( (Level.NetMode != NM_Standalone ) && Self.IsA('Dart'))
					Ammo(item).AmmoAmount = Ammo(item).AmmoAmount * 3;
				else
					Ammo(item).AmmoAmount = 1;
			}
		}
		if (item != None)
		{
			player.FrobTarget = item;

			// check to see if we can pick up the new weapon/ammo
			if (player.HandleItemPickup(item))
			{
				Destroy();				// destroy the projectile on the wall
				if ( Level.NetMode != NM_Standalone )
				{
					if ( item != None )
						item.Destroy();
				}
			}
			else
				item.Destroy();			// destroy the weapon/ammo if it can't be picked up

			player.FrobTarget = None;
		}
	}
}

//GMDX scale velocity, eaiser implementation for rocket mod
function float SpeedMod()
{
   return 1;
}
//GMDX normal drop based on ranges
//function vector CalculateDrop(float dist)
//{
//   local vector acc;
//   if (dist > 20000)		// start descent due to "gravity"
//		acc = Region.Zone.ZoneGravity / 2; //cyberP: was 100
//	return acc;


//}
//
// update our flight path based on our ranges and tracking info
//
simulated function Tick(float deltaTime)
{
	local float dist, size;
	local Rotator dir;
	local vector TargetLocation;
	local vector vel;
	local vector NormalHeading;
	local vector NormalDesiredHeading;
	local float HeadingDiffDot;
	local vector zerovec;

	local DeusExPlayer dxPlayer;
	local vector rx,ry,rz;

	if (bStuck)
		return;

	Super.Tick(deltaTime);

	if ((bEmitDanger)&&(WarningTimer<=0.0))
	{
		AIStartEvent('Projectile', EAITYPE_Visual);
		WarningTimer=default.WarningTimer;
	} else WarningTimer-=deltaTime;

	if (VSize(LastSeenLoc) < 1)
	{
	  LastSeenLoc = Location + Normal(Vector(Rotation)) * 10000;
	}

	if (Role == ROLE_Authority)
	{
	  bHasNetworkTarget = (Target != None);
	}
	else
	{
	  bHadLocalTarget = (bHadLocalTarget || (Target != None));
	}

	dxPlayer=DeusExPlayer(Owner);

	if (bTracking && ((Target != None) || ((Level.NetMode != NM_Standalone) && (bHasNetworkTarget)) || ((Level.Netmode != NM_Standalone) && (bHadLocalTarget))))
	{
		// check it's range
		dist = Abs(VSize(Target.Location - Location));
		if ((dist > MaxRange)&&(!(IsA('Rocket')&&(dxPlayer!=none)&&(dxPlayer.RocketTarget!=none))))
		{
				// if we're out of range, lose the lock and quit tracking
			bTracking = False;
			Target = None;
			return;
		}
		else
		{
			// get the direction to the target
		 if (Level.NetMode == NM_Standalone)
			TargetLocation = Target.Location;
		 else
			TargetLocation = AcquireMPTargetLocation();
		 if (Role == ROLE_Authority)
			NetworkTargetLoc = TargetLocation;
		 LastSeenLoc = TargetLocation;
			dir = Rotator(TargetLocation - Location);
			dir.Roll = 0;

		 if (Level.Netmode != NM_Standalone)
		 {
			NormalHeading = Normal(Vector(Rotation));
			NormalDesiredHeading = Normal(TargetLocation - Location);
			HeadingDiffDot = NormalHeading Dot NormalDesiredHeading;
		 }

			// set our new rotation
			bRotateToDesired = True;
			DesiredRotation = dir;

			// move us in the new direction that we are facing
			size = VSize(Velocity);
			vel = Normal(Vector(Rotation));

		 if (Level.NetMode != NM_Standalone)
		 {
			size = FMax(HeadingDiffDot,0.4) * Speed;
		 }
			Velocity = vel * size;
		}
	}
	else
	{
		if ((IsA('Rocket'))&&(dxPlayer!=none)&&(dxPlayer.bGEPprojectileInflight)&&(Rocket(self).bGEPInFlight))
		{
			if (dxPlayer.bGEPzoomActive)
			{
				dxPlayer.UpdateTrackingSteering(DeltaTime);

				GetAxes(Rotator(Velocity),rx,ry,rz);
				dir=Rotator(rx*25.0+ry*dxPlayer.GEPSteeringX*0.8-rz*dxPlayer.GEPSteeringY*0.8);

				dir.Roll = 0;
				bRotateToDesired = True;
				DesiredRotation=dir;

				size = VSize(Velocity);
				vel = Normal(Vector(Rotation));
				Velocity = vel * size * SpeedMod();
			}
		} //else if (!IsA('RubberBullet'))
	  // make the rotation match the velocity direction
  	//if (IsA('Shuriken') && (bBounce || IsInState('Ricocheted')))
  //	{
  	//}
  	//else
		SetRotation(Rotator(Velocity));
	}

	dist = Abs(VSize(initLoc - Location));

   //Acceleration=CalculateDrop(dist);

dist = Abs(VSize(initLoc - Location));

	if (dist > AccurateRange/100 && IsA('SpiderConstructorLaunched'))		// start descent due to "gravity"
		Acceleration = Region.Zone.ZoneGravity / 2.2;
    else if (dist > AccurateRange/3 && IsA('Dart') && Owner.IsA('DeusExPlayer'))
        Acceleration = Region.Zone.ZoneGravity / 2;
    else if (dist > AccurateRange/1.5 && IsA('RubberBullet'))
        Acceleration = Region.Zone.ZoneGravity / 2;
    else if (dist > AccurateRange)		// start descent due to "gravity"
		Acceleration = Region.Zone.ZoneGravity / 2;

    if ((Role < ROLE_Authority) && (bAggressiveExploded))
	  Explode(Location, vect(0,0,1));
}

function Timer()
{
	if (bStuck)
	  Destroy();
}

simulated function vector AcquireMPTargetLocation()
{
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor hit, retval;

	if (Target == None)
	{
	  if (bHasNetworkTarget)
		 return NetworkTargetLoc;
	  else
		 return LastSeenLoc;
	}

	StartTrace = Location;
	EndTrace = Target.Location;

	if (!Target.IsA('Pawn'))
	  return Target.Location;

	foreach TraceActors(class'Actor', hit, HitLocation, HitNormal, EndTrace, StartTrace)
	{
		if (hit == Target)
			return Target.Location;
	}

	// adjust for eye height
	EndTrace.Z += Pawn(Target).BaseEyeHeight;

	foreach TraceActors(class'Actor', hit, HitLocation, HitNormal, EndTrace, StartTrace)
	{
		if (hit == Target)
			return EndTrace;
	}

	return LastSeenLoc;
}

function SpawnBlood(Vector HitLocation, Vector HitNormal)
{
	local int i;

	if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
	  return;

    if (IsA('DartPoison'))
    return;

	spawn(class'BloodSpurt',,,HitLocation+HitNormal);
	for (i=0; i<Damage/5; i++)
	{
		if (FRand() < 0.6)
			spawn(class'BloodDrop',,,HitLocation+HitNormal*4);
	}
}

simulated function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other)
{
	local int i;
	local DeusExDecal mark;
	local Rockchip chip;

	// don't draw damage art on destroyed movers
	if (DeusExMover(Other) != None)
		if (DeusExMover(Other).bDestroyed)
			ExplosionDecal = None;

	// draw the explosion decal here, not in Engine.Projectile
	if (ExplosionDecal != None)
	{
		mark = DeusExDecal(Spawn(ExplosionDecal, Self,, HitLocation, Rotator(HitNormal)));
		if (mark != None)
		{
			mark.DrawScale *= FClamp(damage/24, 0.5, 4.0); //CyberP: was divided by 30, last param was 3
			mark.ReattachDecal();
		}

		ExplosionDecal = None;
	}

	//DEUS_EX AMSD Don't spawn these on the server.
	if ((Level.NetMode == NM_DedicatedServer) && (Role == ROLE_Authority))
	  return;

	if (bDebris)
	{
		for (i=0; i<Damage/5; i++)
			if (FRand() < 0.8)
		 {
				chip = spawn(class'Rockchip',,,HitLocation+HitNormal);
			//DEUS_EX AMSD In multiplayer, don't propagate these to
			//other players (or from the listen server to clients).
			if (chip != None)
			   chip.RemoteRole = ROLE_None;
		 }
	}
}

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ShockRing ring;
	local SphereEffect sphere;
	local ExplosionLight light, light2;
	local AnimatedSprite expeffect;

	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, HitLocation);
	if (light != None)
	  light.RemoteRole = ROLE_None;
    light2 = Spawn(class'ExplosionLight',,, HitLocation+vect(0,0,16));
	if (light2 != None)
	  light2.RemoteRole = ROLE_None;

	if (blastRadius < 128 || IsA('GasGrenade'))
	{
		expeffect = Spawn(class'ExplosionSmall',,, HitLocation);
		Spawn(class'ExplosionMedium',,, HitLocation);
		light.size = 6;
		light2.size = 6;
	}
	else if (blastRadius < 352)
	{
		expeffect = Spawn(class'ExplosionMedium',,, HitLocation);
		Spawn(class'ExplosionExtra',,, HitLocation);
		light.size = 12;
		light2.size = 12;
	}
	else if (blastRadius < 544)
	{
		expeffect = Spawn(class'ExplosionLarge',,, HitLocation);
		Spawn(class'ExplosionMedium',,, HitLocation);
		light.size = 24;
		light2.size = 24;
	}
	else
	{
		expeffect = Spawn(class'SFXExplosionLarge',,, HitLocation);
		Spawn(class'ExplosionMedium',,, HitLocation);
		//Spawn(class'ExplosionSmall',,, HitLocation);
		light.size = 32;
		light2.size = 32;
	}

    //if (BlastRadius >= 352 || ItemName == "GEP Rocket")
    //    Spawn(class'ExplosionLarge',,, HitLocation);
	if (expeffect != None)
	  expeffect.RemoteRole = ROLE_None;

	// draw a pretty shock ring
	// For nano defense we are doing something else.
	if ((!bAggressiveExploded) || (Level.NetMode == NM_Standalone))
	{
	  ring = Spawn(class'ShockRing',,, HitLocation, rot(16384,0,0));
	  if (ring != None)
	  {
		 ring.RemoteRole = ROLE_None;
		 ring.size = blastRadius / 32.0;
	  }
	  ring = Spawn(class'ShockRing',,, HitLocation, rot(0,0,0));
	  if (ring != None)
	  {
		 ring.RemoteRole = ROLE_None;
		 ring.size = blastRadius / 32.0;
	  }
	  ring = Spawn(class'ShockRing',,, HitLocation, rot(0,16384,0));
	  if (ring != None)
	  {
		 ring.RemoteRole = ROLE_None;
		 ring.size = blastRadius / 32.0;
	  }
	}
	else
	{
	  sphere = Spawn(class'SphereEffect',,, HitLocation, rot(16384,0,0));
	  if (sphere != None)
	  {
		 sphere.RemoteRole = ROLE_None;
		 sphere.size = blastRadius / 32.0;
	  }
	  sphere = Spawn(class'SphereEffect',,, HitLocation, rot(0,0,0));
	  if (sphere != None)
	  {
		 sphere.RemoteRole = ROLE_None;
		 sphere.size = blastRadius / 32.0;
	  }
	  sphere = Spawn(class'SphereEffect',,, HitLocation, rot(0,16384,0));
	  if (sphere != None)
	  {
		 sphere.RemoteRole = ROLE_None;
		 sphere.size = blastRadius / 32.0;
	  }
	}
}

//
// Exploding state
//
state Ricocheted
{
	ignores ProcessTouch, Explode;

	simulated function HitWall(vector HitNormal, actor Wall)
	{
		Velocity = 0.8*((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
		//Acceleration = vect(0,0,0);
		SetPhysics(PHYS_Falling);
	}

    simulated function Landed( vector HitNormal)
	{
	 Velocity = vect(0,0,0);
	 Acceleration = vect(0,0,0);
     SetPhysics(PHYS_None);
	 bStuck = True;
	 PlaySound(sound'BulletHitFlesh',SLOT_None,,,2048,1.1);
	}

	Begin:
		SetCollision(True, False, False);
        Velocity.Z-= 600;
        bBounce=False;
        if (Velocity.Z > -600)
        Velocity.Z = -600;
		//SetPhysics(PHYS_Falling);
		bFixedRotationDir = True;
}

state Exploding
{
	ignores ProcessTouch, HitWall, Explode;

	function DamageRing()
	{
		local Pawn apawn;
		local float damageRadius;
		local Vector dist;

		if ( Level.NetMode != NM_Standalone )
		{
			damageRadius = (blastRadius / gradualHurtSteps) * gradualHurtCounter;

			for ( apawn = Level.PawnList; apawn != None; apawn = apawn.nextPawn )
			{
				if ( apawn.IsA('DeusExPlayer') )
				{
					dist = apawn.Location - Location;
					if ( VSize(dist) < damageRadius )
					{
						if ( gradualHurtCounter <= 2 )
						{
							if ( apawn.FastTrace( apawn.Location, Location ))
								DeusExPlayer(apawn).myProjKiller = Self;
						}
						else
							DeusExPlayer(apawn).myProjKiller = Self;
					}
				}
			}
		}
	  //DEUS_EX AMSD Ignore Line of Sight on the lowest radius check, only in multiplayer
		HurtRadius
		(
			(2 * Damage) / gradualHurtSteps,
			(blastRadius / gradualHurtSteps) * gradualHurtCounter,
			damageType,
			MomentumTransfer / gradualHurtSteps,
			Location,
		 ((gradualHurtCounter <= 2) && (Level.NetMode != NM_Standalone))
		);
	}

	function Timer()
	{
	ImpactSound=None;

		gradualHurtCounter++;
	  DamageRing();
		if (gradualHurtCounter >= gradualHurtSteps)
			Destroy();
	}

Begin:
	// stagger the HurtRadius outward using Timer()
	// do five separate blast rings increasing in size
	gradualHurtCounter = 1;
	gradualHurtSteps = 5;
	Velocity = vect(0,0,0);
	bHidden = True;
	LightType = LT_None;
	SetCollision(False, False, False);
	DamageRing();
	SetTimer(0.25/float(gradualHurtSteps), True);
}

function PlayImpactSound()
{
	local float rad;
    local GMDXImpactSpark AST;

		rad = Max(blastRadius*28, 2048); //CyberP: was *4
        if (IsA('Dart'))
        PlaySound(ImpactSound, SLOT_None, 2.0,, rad,1.15);
        else if (IsA('RubberBullet')) //Special case for rubber bullets as they can be problematic
        {
          if (FRand() < 0.6)
              PlaySound(ImpactSound, SLOT_Interact, 1.5,, 512);
        }
        else
        PlaySound(ImpactSound, SLOT_None, 2.0,, rad);
}

auto simulated state Flying
{
	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if (bStuck)
			return;

        //G-Flex: let's try sticking projectiles in decorations
		//G-Flex: or not, collision cylinders make it look terrible and weird and ugly //CyberP: overruled! We'll have special cases
		if ((bStickToWall && DeusExDecoration(Other) != none && DeusExDecoration(Other).bInvincible &&
           DeusExDecoration(Other).bPushable == False) || (IsA('Shuriken')&& DeusExDecoration(Other) != None))
               {
                   HitWall(normal(Velocity), Other);
               }

		if ((Other != instigator) && (DeusExProjectile(Other) == None) &&
			(Other != Owner))
		{
		    if (IsA('ThrownProjectile') && (Other.IsA('DeusExCarcass') || Other.IsA('Pickup')))
		    return;    //CyberP: don't explode when hitting carci or pickups

			damagee = Other;
			//if (damagee.IsA('ScriptedPawn') && Owner != None && Owner.IsA('DeusExPlayer'))
			    //if (DeusExPlayer(Owner).bHitmarkerOn)
			          //DeusExPlayer(Owner).hitmarkerTime = 0.2;

			Explode(HitLocation, Normal(HitLocation-damagee.Location));

		 // DEUS_EX AMSD Spawn blood server side only
		 if (Role == ROLE_Authority)
			{
			if (damagee.IsA('Pawn') && !damagee.IsA('Robot') && bBlood)
			   SpawnBlood(HitLocation, Normal(HitLocation-damagee.Location));
			}
		}
	}
	simulated function HitWall(vector HitNormal, actor Wall)
	{
local int i;
local GMDXImpactSpark s;
local GMDXImpactSpark2 t;
local GMDXSparkFade fade;
local float speed2;

   if (IsA('RubberBullet'))
   {
	Velocity = 0.8*((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	speed2 = VSize(Velocity);
	bFixedRotationDir = True;
	RotationRate = RotRand(False);
	if ((speed2 > 0) && (speed2 < 50))
	{
		SetPhysics(PHYS_None);
		bStickToWall=True;
		bStuck = True;
		Velocity = vect(0,0,0);
		if (Physics == PHYS_None)
			bFixedRotationDir = False;
	}
	else if (speed2 < 800)
	{
		if (FRand() < 0.5)
		ImpactSound=none;
		else
		ImpactSound=Sound'DeusExSounds.Generic.BasketballBounce';

	}
    }
		if (bStickToWall)
		{
		  if (IsA('Shuriken') && (Wall.IsA('DeusExDecoration') || Wall.IsA('Pickup')))
		    {
		       bBounce=True;
			   Velocity = 0.8*((Velocity dot HitNormal) * HitNormal * (-2.0) + (Velocity*0.75));   // Reflect off Wall w/damping
			   bFixedRotationDir = True;
			   RotationRate.Pitch = (32768 - Rand(65536)) * 4.0;
                RotationRate.Yaw = (32768 - Rand(65536)) * 4.0;
               if (Containers(Wall) != None && Containers(Wall).fragType == class'MetalFragment')
               PlaySound(sound'bouncemetal',SLOT_None,,,2048,1.3);
               else
               {
               Wall.TakeDamage(Damage,Pawn(Owner),Location,MomentumTransfer*Normal(Velocity)*0.001,damageType);
               PlaySound(sound'BulletHitFlesh',SLOT_None,,,2048,1.1);
               }
			   GoToState('Ricocheted');
	        }
	      else
            {
			Velocity = vect(0,0,0);
			Acceleration = vect(0,0,0);
			SetPhysics(PHYS_None);
			bStuck = True;
		   }
			if (!IsA('RubberBullet'))
			{
            ImpactSound = Sound'DeusExSounds.Weapons.CrowbarHitSoft';
		fade = spawn(class'GMDXSparkFade');
		 if (fade != None)
		 {
		 fade.DrawScale = 0.14;
		 }
       for (i=0;i<12;i++)
        {
        s = spawn(class'GMDXImpactSpark');
        t = spawn(class'GMDXImpactSpark2');
          if (s != none && t != none)
        {
        s.LifeSpan=FRand()*0.075;
        t.LifeSpan=FRand()*0.075;
        s.DrawScale = FRand() * 0.065;
        t.DrawScale = FRand() * 0.065;
        if (IsA('DartTaser'))
        {
        s.Texture =Texture'Effects.Fire.Spark_Electric';
        t.Texture =Texture'Effects.Fire.Spark_Electric';
        if(i==1)
        {
        s.AmbientSound = Sound'Ambient.Ambient.Electricity3';
        s.SoundRadius=64;
        s.SoundVolume=160;
        s.SoundPitch=64;
        }
        s.LifeSpan=FRand()*0.2;
        t.LifeSpan=FRand()*0.2;
        s.LightBrightness=255;
        s.LightSaturation=60;
        s.LightHue=146;
        s.LightRadius=1;
        s.LightType=LT_Steady;
        t.LightBrightness=255;
        t.LightSaturation=60;
        t.LightHue=146;
        t.LightRadius=1;
        t.LightType=LT_Steady;
        }
        }
        }
        }
			// MBCODE: Do this only on server side
			if ( Role == ROLE_Authority )
			{
			if (Level.NetMode != NM_Standalone)
			   SetTimer(5.0,False);

				if (Wall.IsA('Mover'))
				{
					SetBase(Wall);
					Wall.TakeDamage(Damage, Pawn(Owner), Wall.Location, MomentumTransfer*Normal(Velocity), damageType);
				}
			}
		}

		if (Wall.IsA('BreakableGlass'))
			bDebris = False;

        if (Wall.IsA('Containers') && Containers(Wall).fragType == class'DeusEx.PaperFragment')
        {
        }
        else
		SpawnEffects(Location, HitNormal, Wall);

		Super.HitWall(HitNormal, Wall);
	}
	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local bool bDestroy;
		local float rad;
        local FireballSpoof fSpoof;
        local SFXExp exp;

	  // Reduce damage on nano exploded projectiles
	  if ((bAggressiveExploded) && (Level.NetMode != NM_Standalone))
		 Damage = Damage/6;

		bDestroy = false;

		if (bExplodes)
		{
		 //DEUS_EX AMSD Don't draw effects on dedicated server
		 if ((Level.NetMode != NM_DedicatedServer) || (Role < ROLE_Authority))
			DrawExplosionEffects(HitLocation, HitNormal);

			GotoState('Exploding');
		}
		else
		{
			// Server side only
			if ( Role == ROLE_Authority )
			{
				if ((damagee != None) && (Tracer(Self) == None)) // Don't even attempt damage with a tracer
				{
					if ( Level.NetMode != NM_Standalone )
					{
						if ( damagee.IsA('DeusExPlayer') )
							DeusExPlayer(damagee).myProjKiller = Self;
					}
					damagee.TakeDamage(Damage, Pawn(Owner), HitLocation, MomentumTransfer*Normal(Velocity), damageType);
					//log("Damage =" $Damage);
				}
			}
			if (!bStuck)
				bDestroy = true;
		}

		rad = Max(blastRadius*24, 1024);

		// This needs to be outside the simulated call chain
		PlayImpactSound();

	  //DEUS_EX AMSD Only do these server side
	  if (Role == ROLE_Authority)
	  {
		 if (ImpactSound != None)
		 {
//		    log("EXPLODE:"@blastRadius);
			AISendEvent('LoudNoise', EAITYPE_Audio, 2.0, blastRadius*10);
			if (bExplodes)
			   AISendEvent('WeaponFire', EAITYPE_Audio, 2.0, blastRadius*2);
		 }
	  }
	    if (IsA('RubberBullet') || IsA('ShockRingProjectile'))
	        bDestroy=False;
	    if (IsA('Fireball'))
	    {
            fSpoof = spawn(class'FireballSpoof');
            if (fSpoof != None)
            {
            fSpoof.drawscale += (drawscale*0.6);
            }
            exp = Spawn(class'SFXExp');
	        if (exp != none)
	        {
	        exp.Velocity.Z = 4;
	        exp.scaleFactor = 1.25+DrawScale;
	        exp.Velocity.Z = 2;
	        }
        }
		if (bDestroy)
			Destroy();
	}
	simulated function BeginState()
	{
		local DeusExWeapon W;

		initLoc = Location;
		initDir = vector(Rotation);
		Velocity = speed*initDir;
		if (W != None && W.IsA('WeaponPlasmaRifle'))
		PlaySound(SpawnSound, SLOT_None,1.2,,8193);
		else
		PlaySound(SpawnSound, SLOT_None,,,2048);
	}
}

defaultproperties
{
     AccurateRange=800
     maxRange=1600
     MinDrawScale=0.050000
     maxDrawScale=2.500000
     bEmitDanger=True
     ItemName="DEFAULT PROJECTILE NAME - REPORT THIS AS A BUG"
     ItemArticle="Error"
     WarningTimer=1.000000
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=60.000000
     RotationRate=(Pitch=65536,Yaw=65536)
}
