//=============================================================================
// DeusExFragment.
//=============================================================================
class DeusExFragment expands Fragment;

var bool bSmoking;
var Vector lastHitLoc;
var float smokeTime;
var ParticleGenerator smokeGen;

//
// copied from Engine.Fragment
//
simulated function HitWall (vector HitNormal, actor HitWall)
{
	local Sound sound;
	local float volume, radius;
	local DeusExPlayer playa;
    local vector offs;

	playa = DeusExPlayer(GetPlayerPawn());

	if (IsA('FleshFragment') && bFirstHit)   //CyberP: for gore up the walls
	{
	offs=Location;
	offs.Z+=3;
	if (Velocity.Z > 0) //cyberP: you need to make frag rotation match velocity
    spawn(class'FleshFragmentWall',,,offs,Rotation);
    //else if (FRand() < 0.1)
    //spawn(class'FleshFragmentWallSliding',,,Location,Rotation);
    //else
    //spawn(class'FleshFragmentWall',,,Location);
	}

	// if we are stuck, stop moving
	if ((lastHitLoc == Location) && (!IsA('FleshFragmentWallSliding')))
		Velocity = vect(0,0,0);
	else if (!IsA('FleshFragmentWallSliding'))
		Velocity = Elasticity*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	speed = VSize(Velocity);
	if (bFirstHit && speed<400)
	{
		bFirstHit=False;
		bRotatetoDesired=True;
		bFixedRotationDir=False;
		DesiredRotation.Pitch=0;
		DesiredRotation.Yaw=FRand()*65536;
		DesiredRotation.roll=0;
	}
	RotationRate.Yaw = RotationRate.Yaw*0.75;
	RotationRate.Roll = RotationRate.Roll*0.75;
	RotationRate.Pitch = RotationRate.Pitch*0.75;
	if ( ( (speed < 60) && (HitNormal.Z > 0.7) ) || (speed == 0) )
	{
		SetPhysics(PHYS_none, HitWall);
		if (Physics == PHYS_None)
		{
			bBounce = false;
			GoToState('Dying');
		}
	}

    if (speed > 20)
    {
	volume = 0.5+FRand()*0.5;
	radius = 1024; //CyberP: was 758
	if (FRand()<0.5)
		sound = ImpactSound;
	else
		sound = MiscSound;
	if (IsA('FleshFragmentWall'))
 	PlaySound(sound, SLOT_None, 0.2,, radius, 0.85+FRand()*0.3);
 	else
	PlaySound(sound, SLOT_None, volume,, radius, 0.85+FRand()*0.3);
	if (sound != None)
		AISendEvent('LoudNoise', EAITYPE_Audio, volume, radius * 1.5); // lower AI sound radius for gameplay balancing //CyberP: increase as GMDX is harder and more realistic
    }
	lastHitLoc = Location;
}

state Dying
{
	simulated function HitWall (vector HitNormal, actor HitWall)
	{
		// if we are stuck, stop moving
		if ((lastHitLoc == Location) && (!IsA('FleshFragmentWallSliding')))
			Velocity = vect(0,0,0);
		else if (!IsA('FleshFragmentWallSliding'))
			Velocity = Elasticity*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
		speed = VSize(Velocity);
		if (bFirstHit && speed<400)
		{
			bFirstHit=False;
			bRotatetoDesired=True;
			bFixedRotationDir=False;
			DesiredRotation.Pitch=0;
			DesiredRotation.Yaw=FRand()*65536;
			DesiredRotation.roll=0;
		}
		RotationRate.Yaw = RotationRate.Yaw*0.75;
		RotationRate.Roll = RotationRate.Roll*0.75;
		RotationRate.Pitch = RotationRate.Pitch*0.75;
		if ( (Velocity.Z < 50) && (HitNormal.Z > 0.7) )
		{
			SetPhysics(PHYS_none, HitWall);
			if (Physics == PHYS_None)
				bBounce = false;
		}
        if (ImpactSound==Sound'DeusExSounds.Generic.FleshHit1')
        {
        if (FRand()<0.2)
			PlaySound(ImpactSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
		else if (FRand()<0.4)
			PlaySound(MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
        }
        else
        {
		if (FRand()<0.5)
			PlaySound(ImpactSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
		else
			PlaySound(MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
        }
		lastHitLoc = Location;
	}

	function BeginState()
	{
		Super.BeginState();

		if (smokeGen != None)
			smokeGen.DelayedDestroy();
	}
}

function Destroyed()
{
	if (smokeGen != None)
		smokeGen.DelayedDestroy();

	Super.Destroyed();
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// randomize the lifespan a bit so things don't all disappear at once
	speed *= 1.1;
	if (!IsA('GMDXImpactSpark') && !IsA('GMDXImpactSpark2'))
	LifeSpan += FRand()*1.5; //CyberP: was 1.0
}

simulated function AddSmoke()
{
	smokeGen = Spawn(class'ParticleGenerator', Self);
	if (smokeGen != None)
	{
		smokeGen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		smokeGen.particleDrawScale = 0.075 + (DrawScale*0.01);
		smokeGen.riseRate = 40.0 + (DrawScale*9);    //CyberP: drawscale influences rise rate
		smokeGen.checkTime = 0.08;
		smokeGen.frequency = 6.0;
		smokeGen.ejectSpeed = 0.0;
		smokeGen.particleLifeSpan = 1 + (DrawScale/11); //CyberP
		smokeGen.bRandomEject = True;
		smokeGen.bFade = True;
		smokeGen.SetBase(Self);
	}
}

simulated function Tick(float deltaTime)
{
   if ((bSmoking) && (smokeGen == None))
		AddSmoke();

	// fade out the object smoothly 2 seconds before it dies completely
	if (LifeSpan <= 2 && !IsA('GMDXImpactSpark') && !IsA('GMDXImpactSpark2'))
	{
		if (Style != STY_Translucent)
			Style = STY_Translucent;

		ScaleGlow = LifeSpan / 2.0;
	}
}

defaultproperties
{
}
