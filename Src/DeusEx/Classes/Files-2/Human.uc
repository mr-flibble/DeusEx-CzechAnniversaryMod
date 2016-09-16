//=============================================================================
// Human.
//=============================================================================
class Human extends DeusExPlayer
	abstract;

var float mpGroundSpeed;
var float mpWaterSpeed;
var float humanAnimRate;
var bool isMantling;
var float mantleTimer;
var float negaTime;

replication
{
	reliable if (( Role == ROLE_Authority ) && bNetOwner )
		humanAnimRate;
}

function Bool IsFiring()
{
	if ((Weapon != None) && ( Weapon.IsInState('NormalFire') || Weapon.IsInState('ClientFiring') ) )
		return True;
	else
		return False;
}

function Bool HasTwoHandedWeapon()
{
	if ((Weapon != None) && (Weapon.Mass >= 30))
		return True;
	else
		return False;
}

//
// animation functions
//
function PlayTurning()
{
//	ClientMessage("PlayTurning()");
	if (bForceDuck || bCrouchOn || IsLeaning())
		TweenAnim('CrouchWalk', 0.1);
	else
	{
		if (HasTwoHandedWeapon())
			TweenAnim('Walk2H', 0.1);
		else
			TweenAnim('Walk', 0.1);
	}
}

function TweenToWalking(float tweentime)
{
//	ClientMessage("TweenToWalking()");
	if (bForceDuck || bCrouchOn)
		TweenAnim('CrouchWalk', tweentime);
	else
	{
		if (HasTwoHandedWeapon())
			TweenAnim('Walk2H', tweentime);
		else
			TweenAnim('Walk', tweentime);
	}
}

function PlayWalking()
{
	local float newhumanAnimRate;

	newhumanAnimRate = humanAnimRate;

	// UnPhysic.cpp walk speed changed by proportion 0.7/0.3 (2.33), but that looks too goofy (fast as hell), so we'll try something a little slower
	if ( Level.NetMode != NM_Standalone )
		newhumanAnimRate = humanAnimRate * 1.75;

	//	ClientMessage("PlayWalking()");
	if (bForceDuck || bCrouchOn)
		LoopAnim('CrouchWalk', newhumanAnimRate);
	else
	{
		if (HasTwoHandedWeapon())
			LoopAnim('Walk2H', newhumanAnimRate);
		else
			LoopAnim('Walk', newhumanAnimRate);
	}
}

function TweenToRunning(float tweentime)
{
//	ClientMessage("TweenToRunning()");
	if (bIsWalking)
	{
		TweenToWalking(0.1);
		return;
	}

	if (IsFiring())
	{
		if (aStrafe != 0)
		{
			if (HasTwoHandedWeapon())
				PlayAnim('Strafe2H',humanAnimRate, tweentime);
			else
				PlayAnim('Strafe',humanAnimRate, tweentime);
		}
		else
		{
			if (HasTwoHandedWeapon())
				PlayAnim('RunShoot2H',humanAnimRate, tweentime);
			else
				PlayAnim('RunShoot',humanAnimRate, tweentime);
		}
	}
	else if (bOnFire)
		PlayAnim('Panic',humanAnimRate, tweentime);
	else
	{
		if (HasTwoHandedWeapon())
			PlayAnim('RunShoot2H',humanAnimRate, tweentime);
		else
			PlayAnim('Run',humanAnimRate, tweentime);
	}
}

function PlayRunning()
{
//	ClientMessage("PlayRunning()");
	if (IsFiring())
	{
		if (aStrafe != 0)
		{
			if (HasTwoHandedWeapon())
				LoopAnim('Strafe2H', humanAnimRate);
			else
				LoopAnim('Strafe', humanAnimRate);
		}
		else
		{
			if (HasTwoHandedWeapon())
				LoopAnim('RunShoot2H', humanAnimRate);
			else
				LoopAnim('RunShoot', humanAnimRate);
		}
	}
	else if (bOnFire)
		LoopAnim('Panic', humanAnimRate);
	else
	{
		if (HasTwoHandedWeapon())
			LoopAnim('RunShoot2H', humanAnimRate);
		else
			LoopAnim('Run', humanAnimRate);
	}
}

function TweenToWaiting(float tweentime)
{
//	ClientMessage("TweenToWaiting()");
	if (IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
	{
		if (IsFiring())
			LoopAnim('TreadShoot');
		else
			LoopAnim('Tread');
	}
	else if (IsLeaning() || bForceDuck)
		TweenAnim('CrouchWalk', tweentime);
	else if (((AnimSequence == 'Pickup') && bAnimFinished) || ((AnimSequence != 'Pickup') && !IsFiring()))
	{
		if (HasTwoHandedWeapon())
			TweenAnim('BreatheLight2H', tweentime);
		else
			TweenAnim('BreatheLight', tweentime);
	}
}

function PlayWaiting()
{
//	ClientMessage("PlayWaiting()");
	if (IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
	{
		if (IsFiring())
			LoopAnim('TreadShoot');
		else
			LoopAnim('Tread');
	}
	else if (IsLeaning() || bForceDuck)
		TweenAnim('CrouchWalk', 0.1);
	else if (!IsFiring())
	{
		if (HasTwoHandedWeapon())
			LoopAnim('BreatheLight2H');
		else
			LoopAnim('BreatheLight');
	}

}

function PlaySwimming()
{
//	ClientMessage("PlaySwimming()");
	LoopAnim('Tread');
}

function TweenToSwimming(float tweentime)
{
//	ClientMessage("TweenToSwimming()");
	TweenAnim('Tread', tweentime);
}

function PlayInAir()
{
//	ClientMessage("PlayInAir()");
	if (!bIsCrouching && (AnimSequence != 'Jump'))
		PlayAnim('Jump',3.0,0.1);
}

function PlayLanded(float impactVel)
{
//	ClientMessage("PlayLanded()");
	PlayFootStep();
	if (!bIsCrouching)
		PlayAnim('Land',3.0,0.1);
}

function PlayDuck()
{
//	ClientMessage("PlayDuck()");
	if ((AnimSequence != 'Crouch') && (AnimSequence != 'CrouchWalk'))
	{
		if (IsFiring())
			PlayAnim('CrouchShoot',,0.1);
		else
			PlayAnim('Crouch',,0.1);
	}
	else
		TweenAnim('CrouchWalk', 0.1);
}

function PlayRising()
{
//	ClientMessage("PlayRising()");
	PlayAnim('Stand',,0.1);
}

function PlayCrawling()
{
//	ClientMessage("PlayCrawling()");
	if (IsFiring())
		LoopAnim('CrouchShoot');
	else
		LoopAnim('CrouchWalk');
}

function PlayFiring()
{
	local DeusExWeapon W;
    local float comb;
//	ClientMessage("PlayFiring()");

	W = DeusExWeapon(Weapon);
    comb = AugmentationSystem.GetAugLevelValue(class'AugCombat');

    if (comb <= 1.3)
    comb = 1.3;

	if ((W != None) && (!IsInState('Dying')))
	{
		if (IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
			LoopAnim('TreadShoot',,0.1);
		else if (W.bHandToHand)
		{
			if (bAnimFinished || (AnimSequence != 'Attack'))
				PlayAnim('Attack',comb*1.25,0.1);
		}
		else if (bIsCrouching || IsLeaning())
			LoopAnim('CrouchShoot',,0.1);
		else
		{
			if (HasTwoHandedWeapon())
				LoopAnim('Shoot2H',,0.1);
			else
				LoopAnim('Shoot',,0.1);
		}
	}
}

function PlayWeaponSwitch(Weapon newWeapon)
{
//	ClientMessage("PlayWeaponSwitch()");
	if (!bIsCrouching && !bForceDuck && !bCrouchOn && !IsLeaning() && !IsInState('Dying')) //CyberP: bugfix
		PlayAnim('Reload');
}

function PlayDying(name damageType, vector hitLoc)
{
	local Vector X, Y, Z;
	local float dotp;

//	ClientMessage("PlayDying()");
	GetAxes(Rotation, X, Y, Z);
	dotp = (Location - HitLoc) dot X;

	if (Region.Zone.bWaterZone)
	{
		PlayAnim('WaterDeath',,0.1);
	}
	else
	{
		// die from the correct side
		if (dotp < 0.0)		// shot from the front, fall back
			PlayAnim('DeathBack',1.1,0.1);
		else				// shot from the back, fall front
		{
            PlayAnim('DeathFront',1.2,0.1);
        }
	}

	PlayDyingSound();
}

//
// sound functions
//

function float RandomPitch()
{
	return (1.1 - 0.2*FRand());
}

function Gasp()
{
    if (swimTimer < swimDuration * 0.3)
	PlaySound(sound'MaleGasp', SLOT_Pain,,,, RandomPitch());
}

function PlayDyingSound()
{
	if (Region.Zone.bWaterZone)
		PlaySound(sound'MaleWaterDeath', SLOT_Pain,,,, RandomPitch());
	else
		PlaySound(sound'AugDeactivate', SLOT_Pain,,,, RandomPitch());
}

function PlayTakeHitSound(int Damage, name damageType, int Mult)
{
	local float rnd;

	if ( Level.TimeSeconds - LastPainSound < FRand() + 1.1) //CyberP: was 0.9
		return;

	LastPainSound = Level.TimeSeconds;

	if (Region.Zone.bWaterZone)
	{
		if (damageType == 'Drowned')
		{
			if (FRand() < 0.8)
				PlaySound(sound'MaleDrown', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
		}
		else if (PerkNamesArray[18] != 1)
			PlaySound(sound'MalePainSmall', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
	}
	else
	{
	     if (PerkNamesArray[18] == 1)
        return;
		// Body hit sound for multiplayer only
		if (((damageType=='Shot') || (damageType=='AutoShot'))  && ( Level.NetMode != NM_Standalone ))
		{
			PlaySound(sound'BodyHit', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
		}

		if ((damageType == 'TearGas') && FRand() <0.5)
			PlaySound(sound'MaleEyePain', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
		else if (damageType == 'PoisonGas')
			PlaySound(sound'MaleCough', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
		else
		{
			rnd = FRand();
			if (rnd < 0.33)
				PlaySound(sound'MalePainSmall', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			else if (rnd < 0.86)
				PlaySound(sound'MalePainMedium', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			else
				PlaySound(sound'MalePainLarge', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
		}
		AISendEvent('LoudNoise', EAITYPE_Audio, FMax(Mult * TransientSoundVolume, Mult * 2.0));
	}
}

function UpdateAnimRate( float augValue )
{
	if ( Level.NetMode != NM_Standalone )
	{
		if ( augValue == -1.0 )
			humanAnimRate = (Default.mpGroundSpeed/320.0);
		else
			humanAnimRate = (Default.mpGroundSpeed/320.0) * augValue * 0.90;	// Scale back about 15% so were not too fast //CyberP: 10%
	}
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		GroundSpeed = mpGroundSpeed;
		WaterSpeed = mpWaterSpeed;
		humanAnimRate = (GroundSpeed/320.0);
	}
}

function DoJump( optional float F )
{
if (Physics == PHYS_Falling && !isMantling && bMantleOption)
  startMantling();

super.DoJump();
}
//CyberP: Biomod begin. Modified for GMDX

state PlayerFlying
{
    function ProcessMove ( float DeltaTime, vector newAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local actor HitActor;
		local vector HitLocation, HitNormal, checkpoint, start, checkNorm, Extent;
        local float shakeTime, shakeRoll, shakeVert;

		super.ProcessMove(DeltaTime, newAccel, DodgeMove, DeltaRot);

		//Justice: Mantling system.  Code shamelessly stolen from CheckWaterJump() in ScriptedPawn
		if (Physics == PHYS_Falling && velocity.Z != 0 && isMantling) //CyberP: PHYS_Falling && != 0
		{
			if (CarriedDecoration == None)
			{
				checkpoint = vector(Rotation);
				checkpoint.Z = 0.0;
				checkNorm = Normal(checkpoint);
				checkPoint = Location + CollisionRadius * checkNorm;
				//Extent = CollisionRadius * vect(1,1,0);
				shakeTime = 0.2;
                shakeRoll = 16.0 + 16.0;
                shakeVert = 2.0 + 2.0;
                ShakeView(shakeTime, shakeRoll, shakeVert);
				Extent = CollisionRadius * vect(0.2,0.2,0);
				Extent.Z = CollisionHeight*0.67;
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, Extent);
				if ( (HitActor != None) && (Pawn(HitActor) == None) && (HitActor == Level || HitActor.bCollideActors) && !HitActor.IsA('DeusExCarcass') && !HitActor.IsA('Inventory'))
				{
					WallNormal = -1 * HitNormal;
					start = Location;
					start.Z += 1.1 * MaxStepHeight + CollisionHeight;
					checkPoint = start + 2 * CollisionRadius * checkNorm;
					HitActor = Trace(HitLocation, HitNormal, checkpoint, start, true, Extent);
					if (HitActor == None)
						goToState('Mantling');
				}
			}
		}
	}
	event PlayerTick(float deltaTime)
	{
		if(mantleTimer <= 0)
		{
			if(mantleTimer > -1)
			{
				isMantling = true;
				mantleTimer = -1;
			}
		}
		else
			mantleTimer -= deltaTime;

		super.PlayerTick(deltaTime);
	}
}
state PlayerWalking
{
	function ProcessMove ( float DeltaTime, vector newAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local actor HitActor;
		local vector HitLocation, HitNormal, checkpoint, start, checkNorm, Extent;
        local float shakeTime, shakeRoll, shakeVert;

		super.ProcessMove(DeltaTime, newAccel, DodgeMove, DeltaRot);

		//Justice: Mantling system.  Code shamelessly stolen from CheckWaterJump() in ScriptedPawn
		if (Physics == PHYS_Falling && velocity.Z != 0 && isMantling) //CyberP: PHYS_Falling && != 0
		{
			if (CarriedDecoration == None)
			{
				checkpoint = vector(Rotation);
				checkpoint.Z = 0.0;
				checkNorm = Normal(checkpoint);
				checkPoint = Location + CollisionRadius * checkNorm;
				//Extent = CollisionRadius * vect(1,1,0);
				Extent = CollisionRadius * vect(0.3,0.3,0); //0.2
				Extent.Z = CollisionHeight*0.67;
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, Extent);
				if ( (HitActor != None) && (HitActor == Level || HitActor.IsA('DeusExDecoration')))
				{
				    if (HitActor.IsA('DeusExDecoration') && HitActor.CollisionHeight < 20)
				        return;
					WallNormal = -1 * HitNormal;
					start = Location;
					start.Z += 1.1 * MaxStepHeight + CollisionHeight;
					checkPoint = start + 2 * CollisionRadius * checkNorm;
					HitActor = Trace(HitLocation, HitNormal, checkpoint, start, true, Extent);
					if (HitActor == None)
						goToState('Mantling');
				}
			}
		}
	}

	event PlayerTick(float deltaTime)
	{
		if(mantleTimer <= 0)
		{
			if(mantleTimer > -1)
			{
				isMantling = true;
				mantleTimer = -1;
			}
		}
		else
			mantleTimer -= deltaTime;

		super.PlayerTick(deltaTime);
	}
}

State Mantling
{

	function EndState()
	{
		setPhysics(PHYS_Falling);
		stopMantling();
	}

	event PlayerTick(float deltaTime)
	{
        WallMaterial = GetWallMaterial(WallNormal);

	    if (negaTime > 0)
		{
		if (negaTime == 0.5)
		{
		    if (WallMaterial == 'Metal' || WallMaterial == 'Ladder')
		        PlaySound(sound'woodhvydrop_metal',SLOT_None,,,, 1.2);
		    else
		        PlaySound(sound'pcconcfall1',SLOT_None,,,, 1.2);
		    //ShakeView(0.1,128,0);
		}
		ViewRotation.Pitch -= deltaTime * 1024;
		negaTime -= deltaTime;
		   if (negaTime < 0.05)
		       ViewRotation.Yaw -= deltaTime * 1536;
		   else if (negaTime > 0.42)
		       ViewRotation.Yaw += deltaTime * 1536;
		}
		else if (negaTime <= 0)
		{
		ViewRotation.Pitch += deltaTime * 2048;
		negaTime -= deltaTime;
		}
	}

Begin:

	if(isMantling)
	{
	    negaTime = 0.5;
	    if (inHand != None)
        {
            if (inHand.IsA('DeusExWeapon'))
                 DeusExWeapon(inHand).GotoState('DownWeapon');
            else if (inHand.IsA('SkilledTool'))
                 SkilledTool(inHand).PutDown();
            else
                 PutInHand(None);
        }
		isMantling = False;
		mantleTimer = -1;
		//velocity.Z = 380;
		Acceleration = vect(0,0,0);
		velocity.Z = 265; //200
		//setPhysics(Phys_Falling);
		setPhysics(Phys_Flying);
		//PlaySound(JumpSound, SLOT_None, 1.5 * runSilentValue, true, 1200, (1.0 - 0.2*FRand()) * 1.0 );
		if (FRand() < 0.6)
		{
		if (PerkNamesArray[9] != 1)
		{
        AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 544);
        PlaySound(sound'MaleLand', SLOT_None, 1.5, true, 1024);
        }
        }
        swimTimer -= 0.5;
		//sleep(0.3);
		sleep(0.7);
		//velocity = wallNormal * waterSpeed / 4;
		//Acceleration = wallNormal * AccelRate / 4;
		velocity = wallNormal * waterSpeed / 4.5; //CyberP / 8
		velocity = Vector(Rotation) * 35;
		Acceleration = wallNormal * AccelRate / 5;
	}

	GoToState('PlayerWalking');
}

exec function startMantling()
{
	//isMantling = True;
	mantleTimer = 0.001; //0.2
}

exec function stopMantling()
{
	isMantling = False;
	mantleTimer = -1;
}
//CyberP: Biomod end

defaultproperties
{
     mpGroundSpeed=230.000000
     mpWaterSpeed=110.000000
     humanAnimRate=1.000000
     mantleTimer=-1.000000
     bIsHuman=True
     WaterSpeed=300.000000
     AirSpeed=4000.000000
     AccelRate=900.000000
     JumpZ=320.000000
     BaseEyeHeight=40.000000
     UnderWaterTime=20.000000
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     Mass=150.000000
     Buoyancy=155.000000
     RotationRate=(Pitch=4096,Yaw=90000,Roll=3072)
}
