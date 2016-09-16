//=============================================================================
// DeusExWeapon.
//=============================================================================
class DeusExWeapon extends Weapon
	abstract;

//
// enums for weapons (duh)
//
enum EEnemyEffective
{
	ENMEFF_All,
	ENMEFF_Organic,
	ENMEFF_Robot
};

enum EEnviroEffective
{
	ENVEFF_All,
	ENVEFF_Air,
	ENVEFF_Water,
	ENVEFF_Vacuum,
	ENVEFF_AirWater,
	ENVEFF_AirVacuum,
	ENVEFF_WaterVacuum
};

enum EConcealability
{
	CONC_None,
	CONC_Visual,
	CONC_Metal,
	CONC_All
};

enum EAreaType
{
	AOE_Point,
	AOE_Cone,
	AOE_Sphere
};

enum ELockMode
{
	LOCK_None,
	LOCK_Invalid,
	LOCK_Range,
	LOCK_Acquire,
	LOCK_Locked
};

var bool				bReadyToFire;			// true if our bullets are loaded, etc.
var() int				LowAmmoWaterMark;		// critical low ammo count
var travel int			ClipCount;				// number of bullets remaining in current clip

var() Name		FireAnim[2];

var() class<Skill>		GoverningSkill;			// skill that affects this weapon
var() travel float		NoiseLevel;				// amount of noise that weapon makes when fired
var() EEnemyEffective	EnemyEffective;			// type of enemies that weapon is effective against
var() EEnviroEffective	EnviroEffective;		// type of environment that weapon is effective in
var() EConcealability	Concealability;			// concealability of weapon
var() travel bool		bAutomatic;				// is this an automatic weapon?
var() travel float		ShotTime;				// number of seconds between shots
var() travel float		ReloadTime;				// number of seconds needed to reload the clip
var() int				HitDamage;				// damage done by a single shot (or for shotguns, a single slug)
var() int				MaxRange;				// absolute maximum range in world units (feet * 16)
var() travel int		AccurateRange;			// maximum accurate range in world units (feet * 16)
var() travel float		BaseAccuracy;			// base accuracy (0.0 is dead on, 1.0 is far off)

//IRONOUT var bool          bInIronSight;         //GMDX iron sight active, removing bZoomed . test to see if bZoomed hides weapon

var bool				bCanHaveScope;			// can this weapon have a scope?
var() travel bool		bHasScope;				// does this weapon have a scope?
var() int				ScopeFOV;				// FOV while using scope
var bool				bZoomed;				// are we currently zoomed?
var bool				bWasZoomed;				// were we zoomed? (used during reloading)


var bool				bCanHaveLaser;			// can this weapon have a laser sight?
var() travel bool		bHasLaser;				// does this weapon have a laser sight?
var bool				bLasing;				// is the laser sight currently on?
var LaserEmitter		Emitter;				// actual laser emitter - valid only when bLasing == True

var bool				bCanHaveSilencer;		// can this weapon have a silencer?
var() travel bool		bHasSilencer;			// does this weapon have a silencer?

var() bool				bCanTrack;				// can this weapon lock on to a target?
var() float				LockTime;				// how long the target must stay targetted to lock
var float				LockTimer;				// used for lock checking
var float            MaintainLockTimer;   // Used for maintaining a lock even after moving off target.
var Actor            LockTarget;          // Used for maintaining a lock even after moving off target.
var Actor				Target;					// actor currently targetted
var ELockMode			LockMode;				// is this target locked?
var string				TargetMessage;			// message to print during targetting
var float				TargetRange;			// range to current target
var() Sound				LockedSound;			// sound to play when locked
var() Sound				TrackingSound;			// sound to play while tracking a target
var float				SoundTimer;				// to time the sounds correctly

var() class<Ammo>		AmmoNames[4];			// three possible types of ammo per weapon   //CyberP ammo part 1
var() class<Projectile> ProjectileNames[4];		// projectile classes for different ammo     //CyberP ammo part 1
var() EAreaType			AreaOfEffect;			// area of effect of the weapon
var() bool				bPenetrating;			// shot will penetrate and cause blood
var() float				StunDuration;			// how long the shot stuns the target
var() bool				bHasMuzzleFlash;		// does this weapon have a flash when fired?
var() bool				bHandToHand;			// is this weapon hand to hand (no ammo)?
var globalconfig vector SwingOffset;     // offsets for this weapon swing.
var() travel float		recoilStrength;			// amount that the weapon kicks back after firing (0.0 is none, 1.0 is large)
var bool				bFiring;				// True while firing, used for recoil
var bool				bOwnerWillNotify;		// True if firing hand-to-hand weapons is dependent on the owner's animations
var bool				bFallbackWeapon;		// If True, only use if no other weapons are available
var bool				bNativeAttack;			// True if weapon represents a native attack
var bool				bEmitWeaponDrawn;		// True if drawing this weapon should make NPCs react
var bool				bUseWhileCrouched;		// True if NPCs should crouch while using this weapon
var bool				bUseAsDrawnWeapon;		// True if this weapon should be carried by NPCs as a drawn weapon
var bool				bWasInFiring;

var bool bNearWall;								// used for prox. mine placement
var Vector placeLocation;						// used for prox. mine placement
var Vector placeNormal;							// used for prox. mine placement
var Mover placeMover;							// used for prox. mine placement

var float ShakeTimer;
var float ShakeYaw;
var float ShakePitch;

var float AIMinRange;							// minimum "best" range for AI; 0=default min range
var float AIMaxRange;							// maximum "best" range for AI; 0=default max range
var float AITimeLimit;							// maximum amount of time an NPC should hold the weapon; 0=no time limit
var float AIFireDelay;							// Once fired, use as fallback weapon until the timeout expires; 0=no time limit

var float standingTimer;						// how long we've been standing still (to increase accuracy)
var float currentAccuracy;						// what the currently calculated accuracy is (updated every tick)

var MuzzleFlash flash;							// muzzle flash actor

var float MinSpreadAcc;        // Minimum accuracy for multiple slug weapons (shotgun).  Affects only multiplayer,
							   // keeps shots from all going in same place (ruining shotgun effect)
var float MinProjSpreadAcc;
var float MinWeaponAcc;        // Minimum accuracy for a weapon at all.  Affects only multiplayer.
var bool bNeedToSetMPPickupAmmo;

var bool	bDestroyOnFinish;

var float	mpReloadTime;
var int		mpHitDamage;
var float	mpBaseAccuracy;
var int		mpAccurateRange;
var int		mpMaxRange;
var int		mpReloadCount;
var int		mpPickupAmmoCount;

// Used to track weapon mods accurately.
var bool bCanHaveModBaseAccuracy;
var bool bCanHaveModReloadCount;
var bool bCanHaveModAccurateRange;
var bool bCanHaveModReloadTime;
var bool bCanHaveModRecoilStrength;

//Rate of Fire Mod -- Y|yukichigai

var travel float ModBaseAccuracy;
var travel float ModReloadCount;
var travel float ModAccurateRange;
var travel float ModReloadTime;
var travel float ModRecoilStrength;

//Rate of Fire Mod -- Y|yukichigai

var localized String msgCannotBeReloaded;
var localized String msgOutOf;
var localized String msgNowHas;
var localized String msgAlreadyHas;
var localized String msgNone;
var localized String msgLockInvalid;
var localized String msgLockRange;
var localized String msgLockAcquire;
var localized String msgLockLocked;
var localized String msgRangeUnit;
var localized String msgTimeUnit;
var localized String msgMassUnit;
var localized String msgNotWorking;

//
// strings for info display
//
var localized String msgInfoAmmoLoaded;
var localized String msgInfoAmmo;
var localized String msgInfoDamage;
var localized String msgInfoClip;
var localized String msgInfoReload;
var localized String msgInfoRecoil;
var localized String msgInfoAccuracy;
var localized String msgInfoAccRange;
var localized String msgInfoMaxRange;
var localized String msgInfoMass;
var localized String msgInfoLaser;
var localized String msgInfoScope;
var localized String msgInfoSilencer;
var localized String msgInfoNA;
var localized String msgInfoYes;
var localized String msgInfoNo;
var localized String msgInfoAuto;
var localized String msgInfoSingle;
var localized String msgInfoRounds;
var localized String msgInfoRoundsPerSec;
var localized String msgInfoSkill;
var localized String msgInfoWeaponStats;

var bool		bClientReadyToFire, bClientReady, bInProcess, bFlameOn, bLooping;
var int		SimClipCount, flameShotCount, SimAmmoAmount;
var float	TimeLockSet;

//GMDX:
var transient bool bIsCloaked;

var() sound FireSilentSound;
var travel bool bContactDeton; //CyberP: toggle contact detonation
var vector RecoilShaker; //cosmetic shaking per shot, amount +/- added to dxplayers current as frand
var int maxiAmmo;  //CyberP: for frobbing weapon pickups when we have max ammo
var bool bInvisibleWhore; //CyberP: emulating the weapon movement if player near wall
var travel bool bSuperheated;
var bool bCanHaveModShotTime;
var bool bCanHaveModDamage;
var bool bCanHaveModFullAuto;
var travel float ModShotTime;
var travel float ModDamage;
var travel bool  bFullAuto; //CyberP: this is different to bAutomatic.
var localized String msgInfoROF;
var localized String msgInfoFullAuto;
var bool bExtraShaker;
var() sound ReloadMidSound;
var bool bCancelLoading;
var int LoadedShells;
var float negTime;
var bool bBeginQuickMelee;
var float quickMeleeCombo;
var vector ironSightLoc;
var float meleeStaminaDrain;
var bool activateAn;
//END GMDX:

//
// network replication
//
replication
{
	// server to client
	reliable if ((Role == ROLE_Authority) && (bNetOwner))
		ClipCount, bZoomed, bHasSilencer, bHasLaser, ModBaseAccuracy, ModReloadCount, ModAccurateRange, ModReloadTime, ModRecoilStrength;

	// Things the client should send to the server
	//reliable if ( (Role<ROLE_Authority) )
		//LockTimer, Target, LockMode, TargetMessage, TargetRange, bCanTrack, LockTarget;

	// Functions client calls on server
	reliable if ( Role < ROLE_Authority )
		ReloadAmmo, LoadAmmo, CycleAmmo, LaserOn, LaserOff, LaserToggle, ScopeOn, ScopeOff, ScopeToggle, PropagateLockState, ServerForceFire,
		  ServerGenerateBullet, ServerGotoFinishFire, ServerHandleNotify, StartFlame, StopFlame, ServerDoneReloading, DestroyOnFinish;

	// Functions Server calls in client
	reliable if ( Role == ROLE_Authority )
	  RefreshScopeDisplay, ReadyClientToFire, SetClientAmmoParams, ClientDownWeapon, ClientActive, ClientReload;
}

// ---------------------------------------------------------------------
// PropagateLockState()
// ---------------------------------------------------------------------
simulated function PropagateLockState(ELockMode NewMode, Actor NewTarget)
{
	LockMode = NewMode;
	LockTarget = NewTarget;
}

event Bump( Actor Other )
{
local float speed2, mult;
local DeusExPlayer player;
local vector any;

if (Physics == PHYS_None)
return;

player = DeusExPlayer(GetPlayerPawn());

if (player!=none && player.AugmentationSystem!=none)
mult = player.AugmentationSystem.GetAugLevelValue(class'AugMuscle');
if (mult == -1.0)
mult = 1.0;

speed2 = VSize(Velocity);

if (speed2 > 500)
{
if (Other.IsA('Pawn') || Other.IsA('Pickup') || (Other.IsA('DeusExDecoration') && DeusExDecoration(Other).minDamageThreshold < 30 && DeusExDecoration(Other).fragType != class'MetalFragment'))
  if (IsA('WeaponCrowbar'))
    Other.TakeDamage((Mass*0.5)*mult*3,player,Location,0.8*Velocity,'Shot');
  else
    Other.TakeDamage((Mass*0.5)*mult,player,Location,0.8*Velocity,'Shot');
if (Other.IsA('Pawn') && !Other.IsA('Robot'))
{
SpawnBlood(Location,any);
PlaySound(Misc1Sound,SLOT_None,,,1024);
}
}
}
// ---------------------------------------------------------------------
// SetLockMode()
// ---------------------------------------------------------------------
simulated function SetLockMode(ELockMode NewMode)
{
	if ((LockMode != NewMode) && (Role != ROLE_Authority))
	{
	  if (NewMode != LOCK_Locked)
		 PropagateLockState(NewMode, None);
	  else
		 PropagateLockState(NewMode, Target);
	}
	TimeLockSet = Level.Timeseconds;
	LockMode = NewMode;
}

// ---------------------------------------------------------------------
// PlayLockSound()
// Because playing a sound from a simulated function doesn't play it
// server side.
// ---------------------------------------------------------------------
function PlayLockSound()
{
	Owner.PlaySound(LockedSound, SLOT_None);
}

//
// install the correct projectile info if needed
//
function TravelPostAccept()
{
	local int i;

	Super.TravelPostAccept();
	// make sure the AmmoName matches the currently loaded AmmoType
	if (AmmoType != None)
		AmmoName = AmmoType.Class;

	if (!bInstantHit)
	{
		if (ProjectileClass != None)
			ProjectileSpeed = ProjectileClass.Default.speed;

		// make sure the projectile info matches the actual AmmoType
		// since we can't "var travel class" (AmmoName and ProjectileClass)
		if (AmmoType != None)
		{
			FireSound = None;
			for (i=0; i<ArrayCount(AmmoNames); i++)
			{
				if (AmmoNames[i] == AmmoName)
				{
					ProjectileClass = ProjectileNames[i];
					break;
				}
			}
		}
	}
}


//
// PreBeginPlay
//

function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Default.mpPickupAmmoCount == 0 )
	{
		Default.mpPickupAmmoCount = Default.PickupAmmoCount;
	}

	CheckWeaponSkins();
}

function SupportActor( actor StandingActor )
{
   if (!standingActor.IsA('RubberBullet')) //CyberP:
	StandingActor.SetBase( self );
}

function DropFrom(vector StartLocation)
{
	if ( !SetLocation(StartLocation) )
		return;
	checkweaponskins();

	super.dropfrom(startlocation);
}

function texture GetWeaponHandTex()
{
	local deusexplayer p;
	local texture tex;

	tex = texture'weaponhandstex';

	p = deusexplayer(owner);
	if(p != none)
	{
		switch(p.PlayerSkin)
		{
			//default, black, latino, ginger, albino, respectively
			case 0: tex = texture'weaponhandstex'; break;
			case 1: tex = texture'HDTPItems.skins.weaponhandstexblack'; break;
			case 2: tex = texture'HDTPItems.skins.weaponhandstexlatino'; break;
			case 3: tex = texture'HDTPItems.skins.weaponhandstexginger'; break;
			case 4: tex = texture'HDTPItems.skins.weaponhandstexalbino'; break;
		}
	}

	return tex;
}

//GMDX cloak weapon
function SetCloak(bool bEnableCloak,optional bool bForce)
{
	if ((Owner==none)||(!Owner.IsA('DeusExPlayer'))) return;
	if (Owner!=none && Owner.IsA('DeusExPlayer'))
	{
	if (bEnableCloak && class'DeusExPlayer'.default.bRadarTran == True &&(!bIsCloaked||bForce))
	{
	  bIsCloaked=true;
	  AmbientGlow=255;
      //Style=STY_Translucent;
	  //ScaleGlow=0.040000;
	}
    else if (bEnableCloak&&(!bIsCloaked||bForce))
	{
	  bIsCloaked=true;
      Style=STY_Translucent;
	  ScaleGlow=0.040000;
	} else
	if(!bEnableCloak&&(bIsCloaked||bForce))
	{
	  bIsCloaked=false;
	  class'DeusExPlayer'.default.bRadarTran=false;
	  //DeusExPlayer(Owner).bRadarTran=false;
	  AmbientGlow=default.AmbientGlow;
	  Style=default.Style;
	  ScaleGlow=default.ScaleGlow;
	}
    }
}
//=============================================================================
// Weapon rendering
// Draw first person view of inventory
simulated event RenderOverlays( canvas Canvas )
{
	local rotator NewRot;
	local bool bPlayerOwner;
	local int Hand;
	local PlayerPawn PlayerOwner;

	if ( bHideWeapon || (Owner == None) )
		return;

	PlayerOwner = PlayerPawn(Owner);

	if ( PlayerOwner != None )
	{
		if ( PlayerOwner.DesiredFOV != PlayerOwner.DefaultFOV )
			return;
		bPlayerOwner = true;
		Hand = PlayerOwner.Handedness;

		if (  (Level.NetMode == NM_Client) && (Hand == 2) )
		{
			bHideWeapon = true;
			return;
		}
	}

	if ( !bPlayerOwner || (PlayerOwner.Player == None) )
		Pawn(Owner).WalkBob = vect(0,0,0);

	if ( (bMuzzleFlash > 0) && bDrawMuzzleFlash && Level.bHighDetailMode && (MFTexture != None) )
	{
		MuzzleScale = Default.MuzzleScale * Canvas.ClipX/640.0;
		if ( !bSetFlashTime )
		{
			bSetFlashTime = true;
			FlashTime = Level.TimeSeconds + FlashLength;
		}
		else if ( FlashTime < Level.TimeSeconds )
			bMuzzleFlash = 0;
		if ( bMuzzleFlash > 0 )
		{
			if ( Hand == 0 )
				Canvas.SetPos(Canvas.ClipX/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipX * (-0.2 * Default.FireOffset.Y * FlashO), Canvas.ClipY/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipY * (FlashY + FlashC));
			else
				Canvas.SetPos(Canvas.ClipX/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipX * (Hand * Default.FireOffset.Y * FlashO), Canvas.ClipY/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipY * FlashY);

			Canvas.Style = 3;
			Canvas.DrawIcon(MFTexture, MuzzleScale);
			Canvas.Style = 1;
		}
	}
	else
		bSetFlashTime = false;

	SetLocation( Owner.Location + CalcDrawOffset() );
	NewRot = Pawn(Owner).ViewRotation;

	if ( Hand == 0 )
		newRot.Roll = -2 * Default.Rotation.Roll;
	else
		newRot.Roll = Default.Rotation.Roll * Hand;

	if (PlayerOwner != none) //CyberP: lets modify HDTP models to have believable rotation
    {
    //ass gun iron sights: newRot.Pitch += 360; newRot.Yaw += 2280; PlayerViewOffset(X=12.500000,Y=3.300000,Z=-10.900000)
    //pistol iron sight: {newRot.Yaw += 1400; newRot.Pitch -=1000; PlayerViewOffset=vect(1955.500000,-1170.300000,106.900000);}
    if (IsA('WeaponAssaultGun'))
    {newRot.Pitch -= 1100; newRot.Yaw += 1200; }   //p=1200 y=1400
    else if (IsA('WeaponPistol'))
    {          newRot.Yaw += 500; newRot.Pitch -=300; }
    else if ((IsA('WeaponAssaultShotgun') || IsA('WeaponFlamethrower')))
    newRot.Pitch -= 500;
    else if (IsA('WeaponRifle'))
    newRot.Pitch -=200;
    else if (IsA('WeaponMiniCrossbow'))
    { newRot.Pitch -=1800; newRot.Yaw += 400;}
    else if (IsA('WeaponStealthPistol'))
    {newRot.Yaw += 800; newRot.Pitch -=500;}
    else if (IsA('WeaponGEPGun'))
    newRot.Pitch += 600;
    else if (IsA('WeaponSawedOffShotgun'))
    {newRot.Pitch -= 2000; newRot.Yaw += 800;}
    }

	if (class'DeusExPlayer'.default.bCloakEnabled&&!bIsCloaked)
	{
	  SetCloak(true);
	} else
	if (!class'DeusExPlayer'.default.bCloakEnabled&&bIsCloaked && !class'DeusExPlayer'.default.bRadarTran == True)
	{
	  SetCloak(false);
	}

//	if (IsA('WeaponGEPmounted')) return;

	setRotation(newRot);
	Canvas.DrawActor(self, false);

}

//
// PostBeginPlay
//

function PostBeginPlay()
{
	Super.PostBeginPlay();
	if (Level.NetMode != NM_Standalone)
	{
	  bWeaponStay = True;
	  if (bNeedToSetMPPickupAmmo)
	  {
		 PickupAmmoCount = PickupAmmoCount * 3;
		 bNeedToSetMPPickupAmmo = False;
	  }
	}
}

singular function BaseChange()
{
	// Make sure we fall if we don't have a base
	if ((base == None) && (Owner == None))
		SetPhysics(PHYS_Falling);

	Super.BaseChange();
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
        local float dammult, massmult;

		if ((DamageType == 'TearGas') || (DamageType == 'PoisonGas') || (DamageType == 'Radiation'))
			return;

		if ((DamageType == 'EMP') || (DamageType == 'NanoVirus') || (DamageType == 'Shocked'))
			return;

		if (DamageType == 'HalonGas')
			return;

		if (DamageType == 'KnockedOut' && Damage < 11) //CyberP: hack for gas nades
            return;

    dammult = damage*0.1;
    if (dammult < 1.1)
    dammult = 1.1;
    else if (dammult > 20)
    dammult = 20;  //capped so objects do not fly about at light speed.


    if (mass < 10)
    massmult = 1.2;
    else if (mass < 20)
    massmult = 1.1;
    else if (mass < 30)
    massmult = 1;
    else if (mass < 50)
    massmult = 0.7;
    else if (mass < 80)
    massmult = 0.4;
    else
    massmult = 0.2;

    SetPhysics(PHYS_Falling);
    Velocity = (Momentum*0.25)*dammult*massmult;
    if (Velocity.Z <= 0)
    Velocity.Z = 80;
    bFixedRotationDir = True;
    if (mass < 40)
    {
	RotationRate.Pitch = (32768 - Rand(65536)) * dammult;
	RotationRate.Yaw = (32768 - Rand(65536)) * dammult;
	}
    }

function bool HandlePickupQuery(Inventory Item)
{
	local DeusExWeapon W;
	local DeusExPlayer player;
	local bool bResult;
	local class<Ammo> defAmmoClass;
	local Ammo defAmmo;

	// make sure that if you pick up a modded weapon that you
	// already have, you get the mods
	W = DeusExWeapon(Item);
	if ((W != None) && (W.Class == Class))
	{
		if (W.ModBaseAccuracy > ModBaseAccuracy)
			ModBaseAccuracy = W.ModBaseAccuracy;
		if (W.ModReloadCount > ModReloadCount)
			ModReloadCount = W.ModReloadCount;
		if (W.ModAccurateRange > ModAccurateRange)
			ModAccurateRange = W.ModAccurateRange;

		// these are negative
		if (W.ModReloadTime < ModReloadTime)
			ModReloadTime = W.ModReloadTime;
		if (W.ModRecoilStrength < ModRecoilStrength)
			ModRecoilStrength = W.ModRecoilStrength;

		if (W.bHasLaser)
			bHasLaser = True;
		if (W.bHasSilencer)
			bHasSilencer = True;
		if (W.bHasScope)
			bHasScope = True;
		if (W.bFullAuto)     //CyberP:
            bFullAuto = True;

		// copy the actual stats as well
		if (W.ReloadCount > ReloadCount)
			ReloadCount = W.ReloadCount;
		if (W.AccurateRange > AccurateRange)
			AccurateRange = W.AccurateRange;

		// these are negative
		if (W.BaseAccuracy < BaseAccuracy)
			BaseAccuracy = W.BaseAccuracy;
		if (W.ReloadTime < ReloadTime)
			ReloadTime = W.ReloadTime;
		if (W.RecoilStrength < RecoilStrength)
			RecoilStrength = W.RecoilStrength;

		// This is for the ROF mod
			if(W.ModShotTime < ModShotTime)
				ModShotTime = W.ModShotTime;
	   //DAM mod
            if(W.ModDamage > ModDamage)
				ModDamage = W.ModDamage;
	}

	player = DeusExPlayer(Owner);

	if (Item.Class == Class)
	{
	  if (!( (Weapon(item).bWeaponStay && (Level.NetMode == NM_Standalone)) && (!Weapon(item).bHeldItem || Weapon(item).bTossedOut)))
		{
			// Only add ammo of the default type
			// There was an easy way to get 32 20mm shells, buy picking up another assault rifle with 20mm ammo selected
			if ( AmmoType != None )
			{
				// Add to default ammo only
				if ( AmmoNames[0] == None )
					defAmmoClass = AmmoName;
				else
					defAmmoClass = AmmoNames[0];

				defAmmo = Ammo(player.FindInventoryType(defAmmoClass));
				defAmmo.AddAmmo( Weapon(Item).PickupAmmoCount );

				if ( Level.NetMode != NM_Standalone )
				{
					if (( player != None ) && ( player.InHand != None ))
					{
						if ( DeusExWeapon(item).class == DeusExWeapon(player.InHand).class )
							ReadyToFire();
					}
				}
			}
		}
	}

	bResult = Super.HandlePickupQuery(Item);

	// Notify the object belt of the new ammo
	if (player != None)
		player.UpdateBeltText(Self);

	return bResult;
}

function float SetDroppedAmmoCount()
{
	// Any weapons have their ammo set to a random number of rounds (1-4)
	// unless it's a grenade, in which case we only want to dole out one.
	// DEUS_EX AMSD In multiplayer, give everything away.
	// Grenades and LAMs always pickup 1
	if (IsA('WeaponNanoVirusGrenade') || IsA('WeaponGasGrenade') || IsA('WeaponEMPGrenade') || IsA('WeaponLAM') || IsA('WeaponHideAGun'))
		PickupAmmoCount = 1;
	else if (Level.NetMode == NM_Standalone)
    PickupAmmoCount = Rand(4) + 1;
}

function BringUp()
{
	if ( Level.NetMode != NM_Standalone )
		ReadyClientToFire( False );

	// alert NPCs that I'm whipping it out
	if (!bNativeAttack && bEmitWeaponDrawn)
		AIStartEvent('WeaponDrawn', EAITYPE_Visual);

	// reset the standing still accuracy bonus
	standingTimer = 0;

	CheckWeaponSkins();

	Super.BringUp();
}
//CyberP begin
function PlaySelect()
{
local DeusExPlayer player;
local float p, mod;

     p = 1.3;
     player = DeusExPlayer(Owner);

     if (bBeginQuickMelee)
     {
       if (IsA('WeaponNanoSword'))
       {
             Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);
             AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 416);
       }
       if (ReloadCount > 0)
			AmmoType.UseAmmo(1);

       if (meleeStaminaDrain != 0)
       {
       if (Owner.IsA('DeusExPlayer') && Owner != none)
       {
		mod = DeusExPlayer(Owner).SkillSystem.GetSkillLevel(class'SkillWeaponLowTech');
        if (mod < 3)
          mod = 1;
        else
          mod = 0.5;

             DeusExPlayer(Owner).swimTimer -= meleeStaminaDrain*mod;
          if (DeusExPlayer(Owner).swimTimer < 0)
		     DeusExPlayer(Owner).swimTimer = 0;
        }
        }

		bReadyToFire = False;
		GotoState('NormalFire');
		bPointing=True;
		if (IsA('WeaponHideAGun'))
		   ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
		if ( Owner.IsA('PlayerPawn') )
			PlayerPawn(Owner).PlayFiring();
		PlaySelectiveFiring();
		PlayFiringSound();
     }
     else
     {
     if (player != none && player.AugmentationSystem != none)
     {
     p = player.AugmentationSystem.GetAugLevelValue(class'AugCombat');
     if (p < 1.3)
     p = 1.3;
     if (p > 1.3)
     p *= 1.15;
     }
    if (IsA('WeaponNanoSword'))
    PlayAnim('Select',p*0.85,0.0);
    else
	PlayAnim('Select',p,0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);
	negTime = 0;
	}
}
//CyberP end
Function CheckWeaponSkins()
{
//empty placeholder :p
}


function bool PutDown()
{
	if ( Level.NetMode != NM_Standalone )
		ReadyClientToFire( False );

	// alert NPCs that I'm putting away my gun
	AIEndEvent('WeaponDrawn', EAITYPE_Visual);

	// reset the standing still accuracy bonus
	standingTimer = 0;

	return Super.PutDown();
}

function ReloadAmmo()
{
local string msgEKEToggle;
local string msgPlasmaToggle;
local string msgContactOn;
local string msgContactOff;

	// single use or hand to hand weapon if ReloadCount == 0  //CyberP: expanded for PS20 mode toggle
	if (ReloadCount == 0 && !IsA('WeaponHideAGun') && GoverningSkill!=class'DeusEx.SkillDemolition')
	{
		Pawn(Owner).ClientMessage(msgCannotBeReloaded);
		return;
	}
	else if (GoverningSkill == class'DeusEx.SkillDemolition')
	{
	  /*if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkNamesArray[26]!=1)
	  return;
	  msgContactOn="Contact Detonation Mode";
	  msgContactOff="Timed Detonation Mode";
	  Owner.PlaySound(sound'KeyboardClick1',SLOT_None,,,1024,1.5);
	  if (bContactDeton==False)
	  {
	  bContactDeton=True;
	  Pawn(Owner).ClientMessage(msgContactOn);
	  }
	  else if (bContactDeton==True)
	  {
	  bContactDeton=False;
	  Pawn(Owner).ClientMessage(msgContactOff);
	  } */
	  return;
	}
	else if (IsA('WeaponHideAGun') && Pawn(Owner).IsA('DeusExPlayer'))
	{
       /* msgEKEToggle = "Electrified Kinetic Energy Mode Enabled";
        msgPlasmaToggle = "Plasma Mode Enabled";
	    if (ProjectileClass == class'DeusEx.PlasmaPS20')
	    {
	    ProjectileClass = class'DeusEx.PlasmaBolt';
		Pawn(Owner).ClientMessage(msgPlasmaToggle);
		Owner.PlaySound(sound'KeyboardClick1',SLOT_None,,,1024,1.5);
		return;
		}
		else if (ProjectileClass == class'DeusEx.PlasmaBolt')
		{
		ProjectileClass = class'DeusEx.PlasmaPS20';
		Pawn(Owner).ClientMessage(msgEKEToggle);
		Owner.PlaySound(sound'KeyboardClick1',SLOT_None,,,1024,1.5);
		return;
		}*/
		return;
	}
	else if (activateAn == True)
	{
	    return;
	}

	if ((IsA('WeaponHideAGun') || GoverningSkill==class'DeusEx.SkillDemolition') && Pawn(Owner).IsA('ScriptedPawn'))
	return;

	if (AmmoType.AmmoAmount > 0) //GMDX: fix the finish anim->state idle anim
	{
		if (!IsInState('Reload'))
		{
			TweenAnim('Still', 0.1);
			GotoState('Reload');
		}
	}
}

//
// Note we need to control what's calling this...but I'll get rid of the access nones for now
//
simulated function float GetWeaponSkill()
{
	local DeusExPlayer player;
	local float value;

	value = 0;

	if ( Owner != None )
	{
		player = DeusExPlayer(Owner);
		if (player != None)
		{
			if ((player.AugmentationSystem != None ) && ( player.SkillSystem != None ))
			{
				// get the target augmentation
				value = player.AugmentationSystem.GetAugLevelValue(class'AugTarget');
				if (value == -1.0)
					value = 0;

				// get the skill
				value += player.SkillSystem.GetSkillLevelValue(GoverningSkill);
			}
		}
	}
	return value;
}

// calculate the accuracy for this weapon and the owner's damage
simulated function float CalculateAccuracy()
{
	local float accuracy;	// 0 is dead on, 1 is pretty far off
	local float tempacc, div;
	local float weapskill; // so we don't keep looking it up (slower).
	local int HealthArmRight, HealthArmLeft, HealthHead;
	local int BestArmRight, BestArmLeft, BestHead;
	local bool checkit;
	local DeusExPlayer player;

	accuracy = BaseAccuracy;		// start with the weapon's base accuracy
	weapskill = GetWeaponSkill();
    player = DeusExPlayer(Owner);

	if (player != None)
	{
		// check the player's skill
		// 0.0 = dead on, 1.0 = way off
		accuracy += weapskill;

		// get the health values for the player
		HealthArmRight = player.HealthArmRight;
		HealthArmLeft  = player.HealthArmLeft;
		HealthHead     = player.HealthHead;
		BestArmRight   = player.Default.HealthArmRight;  //GMDX !TODO :check how this affects base accuracy, if overflow when health >100
		BestArmLeft    = player.Default.HealthArmLeft;
		BestHead       = player.Default.HealthHead;
		checkit = True;
	}
	else if (ScriptedPawn(Owner) != None)
	{
		// update the weapon's accuracy with the ScriptedPawn's BaseAccuracy
		// (BaseAccuracy uses higher values for less accuracy, hence we add)
		accuracy += ScriptedPawn(Owner).BaseAccuracy;

		// get the health values for the NPC
		HealthArmRight = ScriptedPawn(Owner).HealthArmRight;
		HealthArmLeft  = ScriptedPawn(Owner).HealthArmLeft;
		HealthHead     = ScriptedPawn(Owner).HealthHead;
		BestArmRight   = ScriptedPawn(Owner).Default.HealthArmRight;
		BestArmLeft    = ScriptedPawn(Owner).Default.HealthArmLeft;
		BestHead       = ScriptedPawn(Owner).Default.HealthHead;
		checkit = True;
	}
	else
		checkit = False;

	// Disabled accuracy mods based on health in multiplayer
	if ( Level.NetMode != NM_Standalone )
		checkit = False;

	if (checkit)
	{
		if (HealthArmRight < 1)
			accuracy += 0.5;
		else if (HealthArmRight < BestArmRight * 0.34)
			accuracy += 0.2;
		else if (HealthArmRight < BestArmRight * 0.67)
			accuracy += 0.1;

		if (HealthArmLeft < 1)
			accuracy += 0.5;
		else if (HealthArmLeft < BestArmLeft * 0.34)
			accuracy += 0.2;
		else if (HealthArmLeft < BestArmLeft * 0.67)
			accuracy += 0.1;

		if (HealthHead < BestHead * 0.67)
			accuracy += 0.1;
	}

	// increase accuracy (decrease value) if we haven't been moving for awhile
	// this only works for the player, because NPCs don't need any more aiming help!
	if (player != None)
	{
		tempacc = accuracy;
		if (standingTimer > 0)
		{
			// higher skill makes standing bonus greater
			div = Max(15.0 + 29.0 * weapskill, 0.0);
			accuracy -= FClamp(standingTimer/div, 0.0, 0.6);

			// don't go too low
			if ((accuracy < 0.1) && (tempacc > 0.1))
				accuracy = 0.1;
		}
	}

	// make sure we don't go negative
	if (accuracy < 0.0)
		accuracy = 0.0;

	if (Level.NetMode != NM_Standalone)
	  if (accuracy < MinWeaponAcc)
		 accuracy = MinWeaponAcc;

	return accuracy;
}

//
// functions to change ammo types
//
function bool LoadAmmo(int ammoNum)
{
	local class<Ammo> newAmmoClass;
	local Ammo newAmmo;
	local Pawn P;

	if ((ammoNum < 0) || (ammoNum > 3))      //CyberP: ammo part 6
		return False;

	P = Pawn(Owner);

	// sorry, only pawns can have weapons
	if (P == None)
		return False;

	newAmmoClass = AmmoNames[ammoNum];

	if (newAmmoClass != None)
	{
		if (newAmmoClass != AmmoName)
		{
			newAmmo = Ammo(P.FindInventoryType(newAmmoClass));
			if (newAmmo == None)
			{
				P.ClientMessage(Sprintf(msgOutOf, newAmmoClass.Default.ItemName));
				return False;
			}

			// if we don't have a projectile for this ammo type, then set instant hit
			if (ProjectileNames[ammoNum] == None)
			{
				bInstantHit = True;
				bAutomatic = Default.bAutomatic;

				//New stuff -- ROF Mod

				if(HasROFMod())
					ShotTime = Default.ShotTime * (1.0+ModShotTime);
				else
					ShotTime = Default.ShotTime;

				if ( Level.NetMode != NM_Standalone )
				{
					if (HasReloadMod())
						ReloadTime = mpReloadTime * (1.0+ModReloadTime);
					else
						ReloadTime = mpReloadTime;
				}
				else
				{
					if (HasReloadMod())
						ReloadTime = Default.ReloadTime * (1.0+ModReloadTime);
					else
						ReloadTime = Default.ReloadTime;
				}
				FireSound = Default.FireSound;
				ProjectileClass = None;
			}
			else
			{
				// otherwise, set us to fire projectiles
				bInstantHit = False;
				bAutomatic = False;
				//ShotTime = 1.0;
				//New stuff -- ROF Mod

				if(HasROFMod())
					ShotTime = Default.ShotTime * (1.0+ModShotTime);
				else
					ShotTime = Default.ShotTime;

				if (HasReloadMod())
					ReloadTime = 2.0 * (1.0+ModReloadTime);
				else
					ReloadTime = 2.0;
				FireSound = None;		// handled by the projectile
				ProjectileClass = ProjectileNames[ammoNum];
				ProjectileSpeed = ProjectileClass.Default.Speed;
			}

			AmmoName = newAmmoClass;
			AmmoType = newAmmo;

			// AlexB had a new sound for 20mm but there's no mechanism for playing alternate sounds per ammo type
			// Same for WP rocket
			if ( Ammo20mm(newAmmo) != None )
				{
                FireSound=Sound'AssaultGunFire20mm';
                if (bHasSilencer)
                FireSilentSound=Sound'AssaultGunFire20mm';     //CyberP: if silenced also
                }
            else if ( Ammo20mmEMP(newAmmo) != None )
				{
                FireSound=Sound'MediumExplosion1';
                if (bHasSilencer)
                FireSilentSound=Sound'MediumExplosion1';     //CyberP: if silenced also
                }
            else if ( Ammo762mm(newAmmo) != None && bHasSilencer)    //CyberP: revert back to norm
                FireSilentSound=default.FireSilentSound;
			else if ( AmmoRocketWP(newAmmo) != None )
				{
                FireSound=Sound'GEPGunFireWP';
                }
			else if ( AmmoRocket(newAmmo) != None )
				{
                FireSound=Sound'GEPGunFire';
                }
            else if ( AmmoPlasmaSuperheated(newAmmo) != None )
                {
                bSuperheated=True;
                //ShotTime=1.1;
                bAutomatic=true;
                ReloadCount=50;
                //recoilStrength=0.050000;
                AltFireSound=Sound'GMDXSFX.Weapons.freezepick';
                }
            else if (AmmoPlasma(newAmmo) != None)
            {
                bSuperheated=False;
                bAutomatic=false;
                //ShotTime=Default.ShotTime;
                ReloadCount=Default.ReloadCount;
                //recoilStrength=Default.recoilStrength;
                AltFireSound=Sound'DeusExSounds.Weapons.PlasmaRifleReloadEnd';
            }

			if ( Level.NetMode != NM_Standalone )
				SetClientAmmoParams( bInstantHit, bAutomatic, ShotTime, FireSound, ProjectileClass, ProjectileSpeed );

			// Notify the object belt of the new ammo
			if (DeusExPlayer(P) != None)
				DeusExPlayer(P).UpdateBeltText(Self);

			ReloadAmmo();

			P.ClientMessage(Sprintf(msgNowHas, ItemName, newAmmoClass.Default.ItemName));
			return True;
		}
		else
		{
			P.ClientMessage(Sprintf(MsgAlreadyHas, ItemName, newAmmoClass.Default.ItemName));
		}
	}

	return False;
}

// ----------------------------------------------------------------------
//
// ----------------------------------------------------------------------

simulated function SetClientAmmoParams( bool bInstant, bool bAuto, float sTime, Sound FireSnd, class<projectile> pClass, float pSpeed )
{
	bInstantHit = bInstant;
	bAutomatic = bAuto;
	ShotTime = sTime;
	FireSound = FireSnd;
	ProjectileClass = pClass;
	ProjectileSpeed = pSpeed;
}

// ----------------------------------------------------------------------
// CanLoadAmmoType()
//
// Returns True if this ammo type can be used with this weapon
// ----------------------------------------------------------------------

simulated function bool CanLoadAmmoType(Ammo ammo)
{
	local int  ammoIndex;
	local bool bCanLoad;

	bCanLoad = False;

	if (ammo != None)
	{
		// First check "AmmoName"

		if (AmmoName == ammo.Class)
		{
			bCanLoad = True;
		}
		else
		{
			for (ammoIndex=0; ammoIndex<4; ammoIndex++)  //CyberP: ammo pt 2
			{
				if (AmmoNames[ammoIndex] == ammo.Class)
				{
					bCanLoad = True;
					break;
				}
			}
		}
	}

	return bCanLoad;
}

// ----------------------------------------------------------------------
// LoadAmmoType()
//
// Load this ammo type given the actual object
// ----------------------------------------------------------------------

function LoadAmmoType(Ammo ammo)
{
	local int i;

	if (ammo != None)
		for (i=0; i<4; i++) //CyberP: ammo part 3
			if (AmmoNames[i] == ammo.Class)
				LoadAmmo(i);
}

// ----------------------------------------------------------------------
// LoadAmmoClass()
//
// Load this ammo type given the class
// ----------------------------------------------------------------------

function LoadAmmoClass(Class<Ammo> ammoClass)
{
	local int i;

	if (ammoClass != None)
		for (i=0; i<4; i++)      //CyberP: ammo part 4
			if (AmmoNames[i] == ammoClass)
				LoadAmmo(i);
}

// ----------------------------------------------------------------------
// CycleAmmo()
// ----------------------------------------------------------------------

function CycleAmmo()
{
	local int i, last;

	if (NumAmmoTypesAvailable() < 2)
		return;

	for (i=0; i<ArrayCount(AmmoNames); i++)
		if (AmmoNames[i] == AmmoName)
			break;

	last = i;

	if (IsA('WeaponSawedOffShotgun') || IsA('WeaponAssaultShotgun')) //CyberP: cycling shottie ammo
	      ClipCount = ReloadCount;

	do
	{
		if (++i >= 4)  //Cyberp: ammo part 5
			i = 0;

		if (LoadAmmo(i))
			break;
	} until (last == i);
}

simulated function bool CanReload()
{
	if ((ClipCount > 0) && (ReloadCount != 0) && (AmmoType != None) && (AmmoType.AmmoAmount > 0) &&
	    (AmmoType.AmmoAmount > (ReloadCount-ClipCount)))
		return true;
	else
		return false;
}

simulated function bool MustReload()
{
	if ((AmmoLeftInClip() == 0) && (AmmoType != None) && (AmmoType.AmmoAmount > 0))
		return true;
	else
		return false;
}

simulated function int AmmoLeftInClip()
{
	if (ReloadCount == 0)	// if this weapon is not reloadable
		return 1;
	else if (AmmoType == None)
		return 0;
	else if (AmmoType.AmmoAmount == 0)		// if we are out of ammo
		return 0;
	else if (ReloadCount - ClipCount > AmmoType.AmmoAmount)		// if we have no clips left
		return AmmoType.AmmoAmount; //CyberP: This is why ammo goes straight into clip upon pickup.
	else
		return ReloadCount - ClipCount;
}

simulated function int NumClips()
{
	if (ReloadCount == 0)  // if this weapon is not reloadable
		return 0;
	else if (AmmoType == None)
		return 0;
	else if (AmmoType.AmmoAmount == 0)	// if we are out of ammo
		return 0;
	else  // compute remaining clips
		return ((AmmoType.AmmoAmount-AmmoLeftInClip()) + (ReloadCount-1)) / ReloadCount;
}

simulated function int AmmoAvailable(int ammoNum)
{
	local class<Ammo> newAmmoClass;
	local Ammo newAmmo;
	local Pawn P;

	P = Pawn(Owner);

	// sorry, only pawns can have weapons
	if (P == None)
		return 0;

	newAmmoClass = AmmoNames[ammoNum];

	if (newAmmoClass == None)
		return 0;

	newAmmo = Ammo(P.FindInventoryType(newAmmoClass));

	if (newAmmo == None)
		return 0;

	return newAmmo.AmmoAmount;
}

simulated function SetMaxAmmo()
{
   maxiAmmo = AmmoType.MaxAmmo;  //CyberP:
}

simulated function int NumAmmoTypesAvailable()
{
	local int i;

	for (i=0; i<ArrayCount(AmmoNames); i++)
		if (AmmoNames[i] == None)
			break;

	// to make Al fucking happy
	if (i == 0)
		i = 1;

	return i;
}

function name WeaponDamageType()
{
	local name                    damageType;
	local Class<DeusExProjectile> projClass;

	projClass = Class<DeusExProjectile>(ProjectileClass);
	if (bInstantHit)
	{
		if (StunDuration > 0)
			damageType = 'Stunned';
		else
			damageType = 'Shot';

		if (AmmoType != None)
			if (AmmoType.IsA('AmmoSabot') || AmmoType.IsA('Ammo10mmAP'))
				damageType = 'Sabot';

	}
	else if (projClass != None)
		damageType = projClass.Default.damageType;
	else
		damageType = 'None';

	return (damageType);
}


//
// target tracking info
//
simulated function Actor AcquireTarget()
{
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor hit, retval;
	local Pawn p;

	p = Pawn(Owner);
	if (p == None)
		return None;

	StartTrace = p.Location;
	if (PlayerPawn(p) != None)
		EndTrace = p.Location + (10000 * Vector(p.ViewRotation));
	else
		EndTrace = p.Location + (10000 * Vector(p.Rotation));

	// adjust for eye height
	StartTrace.Z += p.BaseEyeHeight;
	EndTrace.Z += p.BaseEyeHeight;

	foreach TraceActors(class'Actor', hit, HitLocation, HitNormal, EndTrace, StartTrace)
		if (!hit.bHidden && (hit.IsA('Decoration') || hit.IsA('Pawn')))
			return hit;

	return None;
}

//
// Used to determine if we are near (and facing) a wall for placing LAMs, etc.
//
simulated function bool NearWallCheck()
{
	local Vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor HitActor;

	// Scripted pawns can't place LAMs
	if (ScriptedPawn(Owner) != None)
		return False;

    if (IsA('WeaponHideAGun')) //CyberP
        return False;

	/*// Don't let players place grenades when they have something highlighted
	if ( Level.NetMode != NM_Standalone )
	{
		if ( Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).frobTarget != None) )
		{
			if ( DeusExPlayer(Owner).IsFrobbable( DeusExPlayer(Owner).frobTarget ) )
				return False;
		}
	} */

	// trace out one foot in front of the pawn
	StartTrace = Owner.Location;
	EndTrace = StartTrace + Vector(Pawn(Owner).ViewRotation) * 32; //CyberP: was 32

	StartTrace.Z += Pawn(Owner).BaseEyeHeight;
	EndTrace.Z += Pawn(Owner).BaseEyeHeight;

	HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace);
	if ((HitActor == Level) || ((HitActor != None) && HitActor.IsA('Mover')))
	{
		placeLocation = HitLocation;
		placeNormal = HitNormal;
		placeMover = Mover(HitActor);
		return True;
	}
    else bInvisibleWhore = False;

	return False;
}

//
// used to place a grenade on the wall
//
function PlaceGrenade()
{
	local ThrownProjectile gren;
	local float dmgX;

	gren = ThrownProjectile(spawn(ProjectileClass, Owner,, placeLocation, Rotator(placeNormal)));
	if (gren != None)
	{
		AmmoType.UseAmmo(1);
		if ( AmmoType.AmmoAmount <= 0 )
			bDestroyOnFinish = True;

		gren.PlayAnim('Open');
		gren.PlaySound(gren.MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
		gren.SetPhysics(PHYS_None);
		gren.bBounce = False;
		gren.bProximityTriggered = True;
		gren.bStuck = True;
		if (placeMover != None)
			gren.SetBase(placeMover);

		// up the damage based on the skill
		// returned value from GetWeaponSkill is negative, so negate it to make it positive
		// dmgX value ranges from 1.0 to 2.4 (max demo skill and max target aug)
		dmgX = -2.0 * GetWeaponSkill() + 1.0;
		gren.Damage *= dmgX;

		// Update ammo count on object belt
		if (DeusExPlayer(Owner) != None)
			DeusExPlayer(Owner).UpdateBeltText(Self);
	}
}

//
// scope, laser, and targetting updates are done here
//
simulated function Tick(float deltaTime)
{
	local vector loc,vel;
	local rotator rot;
	local float beepspeed, recoil,size;
	local DeusExPlayer player;
	local Actor RealTarget;
	local Pawn pawn;
    local float perkMod;

	player = DeusExPlayer(Owner);
	pawn = Pawn(Owner);

	Super.Tick(deltaTime);

	// don't do any of this if this weapon isn't currently in use
	if (pawn == None)
	{
	  LockMode = LOCK_None;
	  MaintainLockTimer = 0;
	  LockTarget = None;
	  LockTimer = 0;
		return;
	}

	if (pawn.Weapon != self)
	{
	  LockMode = LOCK_None;
	  MaintainLockTimer = 0;
	  LockTarget = None;
	  LockTimer = 0;
		return;
	}

    if (quickMeleeCombo > 0)
        quickMeleeCombo -= deltaTime;
	//GMDX: ADD PROJECTILE TEST INFLIGHT
	if ((player!=none)&&(player.aGEPProjectile!=none))
		return;
    //CyberP: moves held guns back if facing & standing next to a wall
   if (player != none && !bHandToHand && IsInState('Idle'))
   {
   if (bInvisibleWhore==True && !NearWallCheck() && player.Physics != PHYS_Falling)
            {
            player.RecoilTime=4.000000;
            bInvisibleWhore=False;
            player.RecoilShake.X-=Lerp(0.02,0,50);
            player.RecoilShaker(vect(0,0,0));
            RecoilShaker=(vect(0,0,0));
            }
   else if (NearWallCheck() && player.Physics != PHYS_Falling)
          {
          if (!bFiring)
               player.RecoilTime= 0.140000;
            bInvisibleWhore=True;
            player.RecoilShake.X-=Lerp(0.02,0,-50);
            player.RecoilShaker(vect(0,0,0));
            RecoilShaker=(vect(0,0,0));
            }
   }
	// all this should only happen IF you have ammo loaded
	if (ClipCount < ReloadCount)
	{
		// check for LAM or other placed mine placement
		if (bHandToHand && (ProjectileClass != None) && (!Self.IsA('WeaponShuriken')))
		{
			if (NearWallCheck())
			{
				if (( Level.NetMode != NM_Standalone ) && IsAnimating() && (AnimSequence == 'Select'))
				{
				}
				else
				{
					if (!bNearWall || (AnimSequence == 'Select'))
					{
						PlayAnim('PlaceBegin',, 0.1);
						bNearWall = True;
					}
				}
			}
			else
			{
				if (bNearWall)
				{
					PlayAnim('PlaceEnd',, 0.1);
					bNearWall = False;
				}
			}
		}


	  SoundTimer += deltaTime;

	  if ( (Level.Netmode == NM_Standalone) || ( (Player != None) && (Player.PlayerIsClient()) ) )
	  {
		 if (bCanTrack)
		 {
			Target = AcquireTarget();
			RealTarget = Target;

			// calculate the range
			if (Target != None)
			   TargetRange = Abs(VSize(Target.Location - Location));

			// update our timers
			//SoundTimer += deltaTime;
			MaintainLockTimer -= deltaTime;

			// check target and range info to see what our mode is
			if ((Target == None) || IsInState('Reload'))
			{
			   if (MaintainLockTimer <= 0)
			   {
				  SetLockMode(LOCK_None);
				  MaintainLockTimer = 0;
				  LockTarget = None;
			   }
			   else if (LockMode == LOCK_Locked)
			   {
				  Target = LockTarget;
			   }
			}
			else if ((Target != LockTarget) && (Target.IsA('Pawn')) && (LockMode == LOCK_Locked))
			{
			   SetLockMode(LOCK_None);
			   LockTarget = None;
			}
			else if (!Target.IsA('Pawn'))
			{
			   if (MaintainLockTimer <=0 )
			   {
				  SetLockMode(LOCK_Invalid);
			   }
			}
			else if ( (Target.IsA('DeusExPlayer')) && (Target.Style == STY_Translucent) )
			{
			   //DEUS_EX AMSD Don't allow locks on cloaked targets.
			   SetLockMode(LOCK_Invalid);
			}
			else if ( (Target.IsA('DeusExPlayer')) && (Player.DXGame.IsA('TeamDMGame')) && (TeamDMGame(Player.DXGame).ArePlayersAllied(Player,DeusExPlayer(Target))) )
			{
			   //DEUS_EX AMSD Don't allow locks on allies.
			   SetLockMode(LOCK_Invalid);
			}
			else
			{
			   if (TargetRange > MaxRange)
			   {
				  SetLockMode(LOCK_Range);
			   }
			   else
			   {
				  // change LockTime based on skill
				  // -0.7 = max skill
				  // DEUS_EX AMSD Only do weaponskill check here when first checking.
				  if (LockTimer == 0)
				  {
					 LockTime = FMax(Default.LockTime + 3.0 * GetWeaponSkill(), 0.0);
					 if ((Level.Netmode != NM_Standalone) && (LockTime < 0.25))
						LockTime = 0.25;
				  }

				  LockTimer += deltaTime;
				  if (LockTimer >= LockTime)
				  {
					 SetLockMode(LOCK_Locked);
				  }
				  else
				  {
					 SetLockMode(LOCK_Acquire);
				  }
			   }
			}

			// act on the lock mode
			switch (LockMode)
			{
			case LOCK_None:
			   TargetMessage = msgNone;
			   LockTimer -= deltaTime;
			   break;

			case LOCK_Invalid:
			   TargetMessage = msgLockInvalid;
			   LockTimer -= deltaTime;
			   break;

			case LOCK_Range:
			   TargetMessage = msgLockRange @ Int(TargetRange/16) @ msgRangeUnit;
			   LockTimer -= deltaTime;
			   break;

			case LOCK_Acquire:
			   TargetMessage = msgLockAcquire @ Left(String(LockTime-LockTimer), 4) @ msgTimeUnit;
			   beepspeed = FClamp((LockTime - LockTimer) / Default.LockTime, 0.2, 1.0);
			   if (SoundTimer > beepspeed)
			   {
				  Owner.PlaySound(TrackingSound, SLOT_None);
				  SoundTimer = 0;
			   }
			   break;

			case LOCK_Locked:
			   // If maintaining a lock, or getting a new one, increment maintainlocktimer
			   if ((RealTarget != None) && ((RealTarget == LockTarget) || (LockTarget == None)))
			   {
				  if (Level.NetMode != NM_Standalone)
					 MaintainLockTimer = default.MaintainLockTimer;
				  else
					 MaintainLockTimer = 0;
				  LockTarget = Target;
			   }
			   TargetMessage = msgLockLocked @ Int(TargetRange/16) @ msgRangeUnit;
			   // DEUS_EX AMSD Moved out so server can play it so that client knows for sure when locked.
			   /*if (SoundTimer > 0.1)
			   {
				  Owner.PlaySound(LockedSound, SLOT_None);
				  SoundTimer = 0;
			   }*/
			   break;
			}
		 }
		 else
		 {
			LockMode = LOCK_None;
			TargetMessage = msgNone;
			LockTimer = 0;
			MaintainLockTimer = 0;
			LockTarget = None;
		 }

		 if (LockTimer < 0)
			LockTimer = 0;
	  }
	}
	else
	{
	  LockMode = LOCK_None;
	  TargetMessage=msgNone;
	  MaintainLockTimer = 0;
	  LockTarget = None;
	  LockTimer = 0;
	}

	if ((LockMode == LOCK_Locked) && (SoundTimer > 0.1) && (Role == ROLE_Authority))
	{
	  PlayLockSound();
	  SoundTimer = 0;
	}

	currentAccuracy = CalculateAccuracy();

	if (player != None)
	{
		// reduce the recoil based on skill
		if (player.PerkNamesArray[22] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponPistol')
		recoil = recoilStrength * 0.5; // + GetWeaponSkill() * 2.0; //CyberP: Removed Recoil based on skill level.
		else if (player.PerkNamesArray[23] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponRifle')
		recoil = recoilStrength * 0.5;
		else if (player.PerkNamesArray[3] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponHeavy')
		recoil = recoilStrength * 0.5;
		else
		recoil = recoilStrength;

		if (recoil < 0.0)
			recoil = 0.0;

		// simulate recoil while firing
		if (bFiring  && recoil > 0.0 && player.RecoilTime > 0.0)// && ((AnimSequence == 'Shoot') ||(AnimSequence == 'idle2')))
		{
		    if (FRand() >=0.5)
			player.ViewRotation.Yaw += deltaTime * (Rand(4096) + 2048) * (recoil*0.35);  //CyberP: recoil on Yaw that actually works...
			else
			player.ViewRotation.Yaw -= deltaTime * (Rand(4096) + 2048) * (recoil*0.35);
			player.ViewRotation.Pitch += deltaTime * (Rand(4096) + 4096) * (recoil*1.5);
			if ((player.ViewRotation.Pitch > 16384) && (player.ViewRotation.Pitch < 32768))
				player.ViewRotation.Pitch = 16384;
		}
		else if (bFiring && player.RecoilTime == 0.0 && recoil > 0.05 && negTime > 0)
		{
		player.ViewRotation.Pitch -= deltaTime * (Rand(512) + 1024) * recoil;
		negTime -= deltaTime;
		}
	}

	// if were standing still, increase the timer
	if (VSize(Owner.Velocity) < 15 && player != None)
	{
	    if (player.PerkNamesArray[1]==1 && GoverningSkill==Class'DeusEx.SkillWeaponPistol')
	    {
	    standingTimer += deltaTime*1.3;
	    }
	    else if (player.PerkNamesArray[2]==1 && GoverningSkill==Class'DeusEx.SkillWeaponRifle')
	    {
	    standingTimer += deltaTime*1.3;
	    }
        else
		    standingTimer += deltaTime;
		if (player.CombatDifficulty < 1.0)  //CyberP: easy difficulty gets aiming boost
		    standingTimer += deltaTime*2;
    }
	else	// otherwise, decrease it slowly based on velocity
		standingTimer = FMax(0, standingTimer - 0.03*deltaTime*VSize(Owner.Velocity));

	if (bLasing || bZoomed)
	{
		// shake our view to simulate poor aiming
		if (ShakeTimer > 0.25)
		{
		    if (player.PerkNamesArray[22] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponPistol')
		    perkMod = 0;
		    else if (player.PerkNamesArray[23] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponRifle')
			perkMod = 0;
			else if (player.PerkNamesArray[3] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponHeavy')
			perkMod = 0;
			else
            perkMod = 0.04;

			ShakeYaw = (currentAccuracy+perkMod) * (Rand(4096) - 2048);
			ShakePitch = (currentAccuracy+perkMod) * (Rand(4096) - 2048);

            ShakeTimer -= 0.25;
		}

		ShakeTimer += deltaTime;

		if (bLasing && (Emitter != None))
		{
			loc = Owner.Location;
			loc.Z += Pawn(Owner).BaseEyeHeight;

			// add a little random jitter - looks cool!
			rot = Pawn(Owner).ViewRotation;
			rot.Yaw += Rand(5) - 2;
			rot.Pitch += Rand(5) - 2;

			Emitter.SetLocation(loc);
			Emitter.SetRotation(rot);
		}

		if ((player != None) && bZoomed)
		{
			player.ViewRotation.Yaw += deltaTime * ShakeYaw;
			player.ViewRotation.Pitch += deltaTime * ShakePitch;
		}
	}
}

function ScopeOn()
{

	if (IsInState('Reload')) return;
	if (bHasScope && !bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer'))
	{
		// Show the Scope View
		bZoomed = True;
		RefreshScopeDisplay(DeusExPlayer(Owner), False, bZoomed);
                if (Self.IsA('WeaponRifle') || Self.IsA('WeaponPlasmaRifle') || Self.IsA('WeaponMiniCrossbow')) //CyberP: if sniper or plasma, play zoom sfx
                {
                Owner.PlaySound(Sound'SniperZoom', SLOT_Misc, 0.85, ,768,1.0);
                }

	}
}

function ScopeOff()
{
	if (bHasScope && bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer'))
	{
		bZoomed = False;
		// Hide the Scope View
	  RefreshScopeDisplay(DeusExPlayer(Owner), False, bZoomed);
		//DeusExRootWindow(DeusExPlayer(Owner).rootWindow).scopeView.DeactivateView();
	}
}

simulated function ScopeToggle()
{
	//if (IsInState('Idle'))
	if (AnimSequence == 'Shoot'||IsInState('Idle'))//(!(bFiring && IsAnimating() && AnimSequence == 'Shoot')||IsInState('Idle'))
	{
		if (bHasScope && (Owner != None) && Owner.IsA('DeusExPlayer'))
		{
			if (bZoomed)
				ScopeOff();
			else
				ScopeOn();
		}
	}
}

// ----------------------------------------------------------------------
// RefreshScopeDisplay()
// ----------------------------------------------------------------------

simulated function RefreshScopeDisplay(DeusExPlayer player, bool bInstant, bool bScopeOn)
{
	local bool bIsGEP;
	if (player == None) return;

	bIsGEP=bHasScope&&(IsA('WeaponGEPGun'))&&(player.RocketTarget!=none);

	if (bScopeOn)
	{
		// Show the Scope View
		DeusExRootWindow(player.rootWindow).scopeView.ActivateViewType(ScopeFOV, False, bInstant,bIsGEP);
	}
	else
	{
	  DeusExrootWindow(player.rootWindow).scopeView.DeactivateView();
	}
}

//
// laser functions for weapons which have them
//

function LaserOn()
{
	if (bHasLaser && !bLasing)
	{
		// if we don't have an emitter, then spawn one
		// otherwise, just turn it on
		if (IsA('WeaponPistol')) WeaponPistol(self).PistolLaserOn(); else
		{

		if (Emitter == None)
		{
			Emitter = Spawn(class'LaserEmitter', Self, , Location, Pawn(Owner).ViewRotation);
			if (Emitter != None)
			{
			    if (ItemName == "UMP7.62c" || ItemName == "USP.10")
			    Emitter.bBlueBeam = True;
			    else
                Emitter.bBlueBeam = False;

				Emitter.SetHiddenBeam(True);
				Emitter.AmbientSound = None;
				Emitter.TurnOn();
			}
		}
		else
			Emitter.TurnOn();
                Owner.PlaySound(sound'KeyboardClick3', SLOT_None,,, 1024,1.5); //CyberP: suitable laser on sfx
		bLasing = True;
	  }
		if ((Owner!=none)&&(Owner.IsA('DeusExPlayer')))
		{
		   if (!DeusExPlayer(Owner).bFromCrosshair)
			DeusExPlayer(Owner).SetCrosshair(false,false);
		 DeusExPlayer(Owner).bFromCrosshair=false;
	  }
	}
}

function LaserOff()
{
	if (IsA('WeaponNanoSword')&&!IsInState('DownWeapon')) return;
	if (bHasLaser && bLasing)
	{
	  if (IsA('WeaponPistol')) WeaponPistol(self).PistolLaserOff();
	  else
	  {
		 if (Emitter != None)
			Emitter.TurnOff();
                 Owner.PlaySound(sound'KeyboardClick2', SLOT_Misc,,, 1024,1.5); //CyberP: suitable laser off sfx
		 bLasing = False;
	  }
//	  log(Owner@DeusExPlayer(Owner).bWasCrosshair@DeusExPlayer(Owner).bFromCrosshair);
	  if ((Owner!=none)&&(Owner.IsA('DeusExPlayer'))&&(DeusExPlayer(Owner).bWasCrosshair))
		{
		 if (!DeusExPlayer(Owner).bFromCrosshair)
			DeusExPlayer(Owner).SetCrosshair(true,false);
		 DeusExPlayer(Owner).bFromCrosshair=false;
	  }
	  if ((IsA('WeaponGEPGun'))&&(Owner.IsA('DeusExPlayer')))
	  {
	     if (DeusExPlayer(Owner).aGEPProjectile!=none)
	     {
	        Rocket(DeusExPlayer(Owner).aGEPProjectile).bGEPInFlight=false;
	        DeusExPlayer(Owner).aGEPProjectile.Target=none;
	        DeusExPlayer(Owner).aGEPProjectile.bTracking=false;
	        DeusExPlayer(Owner).aGEPProjectile=none;
	        if (DeusExPlayer(Owner).bAutoReload)
					ReloadAmmo();
	     }
	  }
	}
}

function LaserToggle()
{
	if (IsInState('Idle'))
	{
		if (bHasLaser)
		{
			if (bLasing)
				LaserOff();
			else
				LaserOn();
		}

	}
}

simulated function SawedOffCockSound()
{
local float shakeTime, shakeRoll, shakeVert;

	if ((AmmoType.AmmoAmount >= 0) && (WeaponSawedOffShotgun(Self) != None))  //CyberP: bugfix: was > 0, now >=
	{
    	Owner.PlaySound(SelectSound, SLOT_None,,, 1024);
    	if (Owner.IsA('DeusExPlayer')) //CyberP: add a camera effect
    	  {
    	   shakeTime = 0.1;
    	   shakeRoll = 64+64;
    	   shakeVert = 2.5+2.5;
           DeusExPlayer(Owner).ShakeView(shakeTime, shakeRoll, shakeVert);
    	  }
    }
}

//
// called from the MESH NOTIFY
//
simulated function SwapMuzzleFlashTexture()
{
	if (!bHasMuzzleFlash)
	  return;
//	if (FRand() < 0.5)
//		MultiSkins[2] = Texture'FlatFXTex34';
//	else
//		MultiSkins[2] = Texture'FlatFXTex37';

//HDTP DDL: changing to add DaveW's nice new muzzleflashes
	Multiskins[2] = GetMuzzleTex();

	MuzzleFlashLight();
	SetTimer(0.1, False);
}

//ADDED
simulated function texture GetMuzzleTex()
{
	local int i;
	local texture tex;

	if(bAutomatic)
	{
		i = rand(8);
		switch(i)
		{
			case 0: tex = texture'HDTPMuzzleflashlarge1'; break;
			case 1: tex = texture'HDTPMuzzleflashlarge2'; break;
			case 2: tex = texture'HDTPMuzzleflashlarge3'; break;
			case 3: tex = texture'HDTPMuzzleflashlarge4'; break;
			case 4: tex = texture'HDTPMuzzleflashlarge5'; break;
			case 5: tex = texture'HDTPMuzzleflashlarge6'; break;
			case 6: tex = texture'HDTPMuzzleflashlarge7'; break;
			case 7: tex = texture'HDTPMuzzleflashlarge8'; break;
		}
	}
	else
	{
		i = rand(3);
		switch(i)
		{
			case 0: tex = texture'HDTPMuzzleflashSmall1'; break;
			case 1: tex = texture'HDTPMuzzleflashSmall2'; break;
			case 2: tex = texture'HDTPMuzzleflashSmall3'; break;
		}
	}

	return tex;
}


simulated function EraseMuzzleFlashTexture()
{
	if(bHasMuzzleflash)   //things like the GEP and minicrossbow use ms2 as a weaponmod
		MultiSkins[2] = None;
}

simulated function Timer()
{
	EraseMuzzleFlashTexture();
}

simulated function MuzzleFlashLight()
{
	local Vector offset, X, Y, Z;
    local PlasmaParticleSpoof spoof;
    local FireSmoke smoke;
    local int i;

 	if (!bHasMuzzleFlash)
		return;

	if ((flash != None) && !flash.bDeleteMe)
		flash.LifeSpan = flash.Default.LifeSpan;
	else
	{
		GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
		offset = Owner.Location;
		offset += X * Owner.CollisionRadius * 2;
		flash = spawn(class'MuzzleFlash',,, offset);
		if (flash != None)
			flash.SetBase(Owner);

        if ((IsA('WeaponSawedOffShotgun') || IsA('WeaponAssaultShotgun')) && Owner.IsA('DeusExPlayer'))
    {    //CyberP: hacky, non-optimal new muzzleflash effects.
    offset.Z += Owner.CollisionHeight * 0.7;
    if (IsA('WeaponAssaultShotgun'))
    offset += Y * Owner.CollisionRadius * 0.75;
    else
    offset += Y * Owner.CollisionRadius * 0.25;
    smoke = spawn(class'FireSmoke',,, offset, Pawn(Owner).ViewRotation);
    if (smoke!=none)
    {
    smoke.LifeSpan=0.24;
    smoke.DrawScale=0.400000;
    smoke.ScaleGlow=0.400000;
    smoke.bRelinquished2=True;
    }
    for(i=0;i<13;i++)
    {
    spoof = spawn(class'PlasmaParticleSpoof',,, offset, Pawn(Owner).ViewRotation);
    if (spoof!=none)
    {
    spoof.DrawScale=0.006;
    spoof.LifeSpan=0.2;
    spoof.Texture=Texture'HDTPItems.Skins.HDTPMuzzleflashSmall2';
    spoof.Velocity=360*vector(Rotation);//vect(0,0,0);
    //spoof.Velocity.X = FRand() * 700;
    //spoof.Velocity.Z = FRand() * 60;

		if (FRand() < 0.3)
		{
		spoof.Velocity.Z += FRand() * 80;
		spoof.Velocity.X += FRand() * 65;
		spoof.Velocity.Y += FRand() * 65;
		}
		else if (FRand() < 0.6)
		{
		spoof.Velocity.Z -= FRand() * 20;
		spoof.Velocity.X -= FRand() * 55;
		spoof.Velocity.Y -= FRand() * 65;
		}
    }
    }
    }
	}
}

function ServerHandleNotify( bool bInstantHit, class<projectile> ProjClass, float ProjSpeed, bool bWarn )
{
	if (bInstantHit)
		TraceFire(0.0);
	else
		ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
}

//
// HandToHandAttack
// called by the MESH NOTIFY for the H2H weapons
//
simulated function HandToHandAttack()
{
	local bool bOwnerIsPlayerPawn;

	if (bOwnerWillNotify)
		return;

	// The controlling animator should be the one to do the tracefire and projfire
	if ( Level.NetMode != NM_Standalone )
	{
		bOwnerIsPlayerPawn = (DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn()));

		if (( Role < ROLE_Authority ) && bOwnerIsPlayerPawn )
			ServerHandleNotify( bInstantHit, ProjectileClass, ProjectileSpeed, bWarnTarget );
		else if ( !bOwnerIsPlayerPawn )
			return;
	}

	if (ScriptedPawn(Owner) != None)
		ScriptedPawn(Owner).SetAttackAngle();

	if (bInstantHit)
		TraceFire(0.0);
	else
		ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);

	// if we are a thrown weapon and we run out of ammo, destroy the weapon
	if ( bHandToHand && (ReloadCount > 0) && (SimAmmoAmount <= 0))
	{
		DestroyOnFinish();
		if ( Role < ROLE_Authority )
		{
			ServerGotoFinishFire();
			GotoState('SimQuickFinish');
		}
	}
}

//
// OwnerHandToHandAttack
// called by the MESH NOTIFY for this weapon's owner
//
simulated function OwnerHandToHandAttack()
{
	local bool bOwnerIsPlayerPawn;

	if (!bOwnerWillNotify)
		return;

	// The controlling animator should be the one to do the tracefire and projfire
	if ( Level.NetMode != NM_Standalone )
	{
		bOwnerIsPlayerPawn = (DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn()));

		if (( Role < ROLE_Authority ) && bOwnerIsPlayerPawn )
			ServerHandleNotify( bInstantHit, ProjectileClass, ProjectileSpeed, bWarnTarget );
		else if ( !bOwnerIsPlayerPawn )
			return;
	}

	if (ScriptedPawn(Owner) != None)
		ScriptedPawn(Owner).SetAttackAngle();

	if (bInstantHit)
		TraceFire(0.0);
	else
		ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
}

function ForceFire()
{
	Fire(0);
}

function ForceAltFire()
{
	AltFire(0);
}

//
// ReadyClientToFire is called by the server telling the client it's ok to fire now
//

simulated function ReadyClientToFire( bool bReady )
{
	bClientReadyToFire = bReady;
}

//
// ClientReFire is called when the client is holding down the fire button, loop firing
//

simulated function ClientReFire( float value )
{
	bClientReadyToFire = True;
	bLooping = True;
	bInProcess = False;
	ClientFire(0);
}

function StartFlame()
{
	flameShotCount = 0;
	bFlameOn = True;
	GotoState('FlameThrowerOn');
}

function StopFlame()
{
	bFlameOn = False;
}

//
// ServerForceFire is called from the client when loop firing
//
function ServerForceFire()
{
	bClientReady = True;
	Fire(0);
}

simulated function int PlaySimSound( Sound snd, ESoundSlot Slot, float Volume, float Radius )
{
	if ( Owner != None )
	{
		if ( Level.NetMode == NM_Standalone )
			return ( Owner.PlaySound( snd, Slot, Volume, , Radius ) );
		else
		{
			Owner.PlayOwnedSound( snd, Slot, Volume, , Radius );
			return 1;
		}
	}
	return 0;
}

//
// ClientFire - Attempts to play the firing anim, sounds, and trace fire hits for instant weapons immediately
//				on the client.  The server may have a different interpretation of what actually happen, but this at least
//				cuts down on preceived lag.
//
simulated function bool ClientFire( float value )
{
	local bool bWaitOnAnim;
	local vector shake;

	// check for surrounding environment
	if ((EnviroEffective == ENVEFF_Air) || (EnviroEffective == ENVEFF_Vacuum) || (EnviroEffective == ENVEFF_AirVacuum))
	{
		if (Region.Zone.bWaterZone)
		{
			if (Pawn(Owner) != None)
			{
				Pawn(Owner).ClientMessage(msgNotWorking);
				if (!bHandToHand)
					PlaySimSound( Misc1Sound, SLOT_None, TransientSoundVolume * 2.0, 1024 );
			}
			return false;
		}
	}

    if (Pawn(Owner) != None && Pawn(Owner).IsInState('Dying'))
    {bClientReadyToFire = False; bClientReady = False; return false;} //CyberP: cannot shoot when dying

	if ( !bLooping ) // Wait on animations when not looping
	{
		bWaitOnAnim = ( IsAnimating() && ((AnimSequence == 'Select') || (AnimSequence == FireAnim[0]) || (AnimSequence == FireAnim[1]) || (AnimSequence == 'ReloadBegin') || (AnimSequence == 'Reload') || (AnimSequence == 'ReloadEnd') || (AnimSequence == 'Down')));
	}
	else
	{
		bWaitOnAnim = False;
		bLooping = False;
	}

	if ( (Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).NintendoImmunityTimeLeft > 0.01)) ||
		  (!bClientReadyToFire) || bInProcess || bWaitOnAnim )
	{
		DeusExPlayer(Owner).bJustFired = False;
		bPointing = False;
		bFiring = False;
		return false;
	}

	if ( !Self.IsA('WeaponFlamethrower') )
		ServerForceFire();

	if (bHandToHand)
	{
		SimAmmoAmount = AmmoType.AmmoAmount - 1;

		bClientReadyToFire = False;
		bInProcess = True;
		GotoState('ClientFiring');
		bPointing = True;
		if ( PlayerPawn(Owner) != None )
			PlayerPawn(Owner).PlayFiring();
		PlaySelectiveFiring();
		PlayFiringSound();
	}
	else if ((ClipCount < ReloadCount) || (ReloadCount == 0))
	{
		if ((ReloadCount == 0) || (AmmoType.AmmoAmount > 0))
		{
			SimClipCount = ClipCount + 1;

			if ( AmmoType != None )
				AmmoType.SimUseAmmo();

			bFiring = True;
			bPointing = True;
			bClientReadyToFire = False;
			bInProcess = True;
			GotoState('ClientFiring');
			if ( PlayerPawn(Owner) != None )
			{
				shake.X = 0.0;
				shake.Y = 100.0 * (ShakeTime*0.5);  //CyberP: was 100
				shake.Z = 100.0 * -(currentAccuracy * ShakeVert);
				PlayerPawn(Owner).ClientShake( shake );
				PlayerPawn(Owner).PlayFiring();
			}
			// Don't play firing anim for 20mm
			if ( Ammo20mm(AmmoType) == None && Ammo20mmEMP(AmmoType) == None)
				PlaySelectiveFiring();
			PlayFiringSound();

			if ( bInstantHit &&  (( Ammo20mm(AmmoType) == None ) && ( Ammo20mmEMP(AmmoType) == None )))
				TraceFire(currentAccuracy);
			else
			{
				if ( !bFlameOn && Self.IsA('WeaponFlamethrower'))
				{
					bFlameOn = True;
					StartFlame();
				}
				ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
			}
		}
		else
		{
			if ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bAutoReload )
			{
				if ( MustReload() && CanReload() )
				{
					bClientReadyToFire = False;
					bInProcess = False;
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();

					ReloadAmmo();
				}
			}
			PlaySimSound( Misc1Sound, SLOT_None, TransientSoundVolume * 2.0, 1024 );		// play dry fire sound
		}
	}
	else
	{
		if ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bAutoReload )
		{
			if ( MustReload() && CanReload() )
			{
				bClientReadyToFire = False;
				bInProcess = False;
				if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
					CycleAmmo();
				ReloadAmmo();
			}
		}
		PlaySimSound( Misc1Sound, SLOT_None, TransientSoundVolume * 2.0, 1024 );		// play dry fire sound
	}
	return true;
}

//
// from Weapon.uc - modified so we can have the accuracy in TraceFire
//
function Fire(float Value)
{
	local float sndVolume, mod;
	local bool bListenClient;
    local DeusExPlayer player;

    if (Pawn(Owner).IsInState('Dying') || (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bGEPprojectileInflight))
    return; //CyberP: cannot shoot when dying or GEPRemote control

	bListenClient = (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient());

	sndVolume = TransientSoundVolume;

	if ( Level.NetMode != NM_Standalone )  // Turn up the sounds a bit in mulitplayer
	{
		sndVolume = TransientSoundVolume * 2.0;
		if ( Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).NintendoImmunityTimeLeft > 0.01) || (!bClientReady && (!bListenClient)) )
		{
			DeusExPlayer(Owner).bJustFired = False;
			bReadyToFire = True;
			bPointing = False;
			bFiring = False;
			return;
		}
	}
	// check for surrounding environment
	if ((EnviroEffective == ENVEFF_Air) || (EnviroEffective == ENVEFF_Vacuum) || (EnviroEffective == ENVEFF_AirVacuum))
	{
		if (Region.Zone.bWaterZone)
		{
			if (Pawn(Owner) != None)
			{
				Pawn(Owner).ClientMessage(msgNotWorking);
				if (!bHandToHand)
					PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );		// play dry fire sound
			}
			GotoState('Idle');
			return;
		}
	}


	if (bHandToHand)
	{
		if (ReloadCount > 0)
			AmmoType.UseAmmo(1);

       if (meleeStaminaDrain != 0)
       {
       if (Owner.IsA('DeusExPlayer') && Owner != none)
       {
		mod = DeusExPlayer(Owner).SkillSystem.GetSkillLevel(class'SkillWeaponLowTech');
        if (mod < 3)
          mod = 1;
        else
          mod = 0.5;

             DeusExPlayer(Owner).swimTimer -= meleeStaminaDrain*mod;
          if (DeusExPlayer(Owner).swimTimer < 0)
		     DeusExPlayer(Owner).swimTimer = 0;
        }
        }

		bReadyToFire = False;
		GotoState('NormalFire');
		bPointing=True;
		if (IsA('WeaponHideAGun'))
		   ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
		if ( Owner.IsA('PlayerPawn') )
			PlayerPawn(Owner).PlayFiring();
		PlaySelectiveFiring();
		PlayFiringSound();
	}
	// if we are a single-use weapon, then our ReloadCount is 0 and we don't use ammo
	else if ((ClipCount < ReloadCount) || (ReloadCount == 0))
	{
	    if (AmmoType.AmmoAmount == 0 && IsA('WeaponSawedOffShotgun')) //CyberP: hack for this weird bug on sawed off
	    {
	    PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );		// play dry fire sound
	    }
		else if ((ReloadCount == 0) || AmmoType.UseAmmo(1))
		{
			if (( Level.NetMode != NM_Standalone ) && !bListenClient )
				bClientReady = False;

			ClipCount++;
			bFiring = True;
			bReadyToFire = False;

			GotoState('NormalFire');
			//if (( Level.NetMode == NM_Standalone ) || (bListenClient)) //( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient()) )
			//{
				//if ( PlayerPawn(Owner) != None )		// shake us based on accuracy
				//	PlayerPawn(Owner).ShakeView(ShakeTime, currentAccuracy * ShakeMag + ShakeMag, currentAccuracy * ShakeVert);
			//}
			bPointing=True;
			if ( bInstantHit )
				TraceFire(currentAccuracy);
			else
				ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);

			if ( Owner.IsA('PlayerPawn') )
				PlayerPawn(Owner).PlayFiring();
			// Don't play firing anim for 20mm
			//if ( Ammo20mm(AmmoType) == None && Ammo20mmEMP(AmmoType) == None)
				PlaySelectiveFiring();
			PlayFiringSound();
			if ( Owner.bHidden )
				CheckVisibility();
		}
		else
			PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );		// play dry fire sound
	}
	else
		PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );		// play dry fire sound

	// Update ammo count on object belt
	if (DeusExPlayer(Owner) != None)
		DeusExPlayer(Owner).UpdateBeltText(Self);
}

function ReadyToFire()
{
	if (!bReadyToFire)
	{
		// BOOGER!
		//if (ScriptedPawn(Owner) != None)
		//	ScriptedPawn(Owner).ReadyToFire();
		bReadyToFire = True;
		if ( Level.NetMode != NM_Standalone )
			ReadyClientToFire( True );
	}
}

function PlayPostSelect()
{
	// let's not zero the ammo count anymore - you must always reload
//	ClipCount = 0;
}

simulated function PlaySelectiveFiring()
{
	local Pawn aPawn;
	local float rnd;
	local Name anim;
	//local int animNum;
	local float mod;
    local float hhspeed;

/*	animNum = 0;

	if(AmmoNames[1] != None || AmmoNames[2] != None)
	{
		for(animNum = 0; animNum < 2; animNum++)
		{
			if(ProjectileClass == ProjectileNames[animNum])
				break;
		}
		if(animNum >= 2)
			animNum = 0;
	}

	anim = FireAnim[animNum];
*/
if (bSuperheated || Ammo20mm(AmmoType) != None || Ammo20mmEMP(AmmoType) != None)
anim = 'idle2';
else
    anim = 'Shoot';

//	if(anim == '\'')
//		anim = 'Shoot';

	if (bHandToHand)
	{
		rnd = FRand();
		if (IsA('WeaponHideAGun'))
            anim = 'Shoot';
		else if (rnd < 0.33)
			anim = 'Attack';
		else if (rnd < 0.66)
			anim = 'Attack2';
		else
			anim = 'Attack3';
		if (IsA('WeaponNanoSword'))
           if (FRand() < 0.5)
               PlaySound(sound'GMDXSFX.Weapons.ebladeswipe1',SLOT_None,,,,1.3);
           else
               PlaySound(sound'GMDXSFX.Weapons.ebladeswipe2',SLOT_None,,,,1.3);
		//AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 64);
	}

	//if(anim == '')
	//	return;

	if (( Level.NetMode == NM_Standalone ) || ( DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn())) )
	{
	    if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).AugmentationSystem != none)
		hhspeed = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');

		//== Speed up the firing animation if we have the ROF mod
		//mod = 1.000000 - ModShotTime;

        if (IsA('WeaponSawedOffShotgun') || IsA('WeaponStealthPistol') || IsA('WeaponHideAGun')
        || ItemName == "USP.10" || IsA('WeaponMiniCrossbow') || IsA('WeaponAssaultShotgun'))
		mod = 1.650000 - ModShotTime;
        else
        mod = 1.000000 - ModShotTime;

		if (bAutomatic || Ammo20mm(AmmoType) != None || Ammo20mmEMP(AmmoType) != None)
		{
		    if (bSuperheated || Ammo20mm(AmmoType) != None || Ammo20mmEMP(AmmoType) != None)
		    LoopAnim(anim,18 * mod, 0.1);
		    else
			LoopAnim(anim,1 * mod, 0.1);
		}
		else if (bHandToHand && Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).AugmentationSystem != none && !IsA('WeaponHideAGun'))
		{
			if (hhspeed < 1.0)
			{
				hhspeed = 1.0;
			}
			PlayAnim(anim,1 * hhspeed,0.1); //CyberP: increase melee speed if augcombat
		}
		else
			PlayAnim(anim,1 * mod,0.1);
	}
	else if ( Role == ROLE_Authority )
	{
		for ( aPawn = Level.PawnList; aPawn != None; aPawn = aPawn.nextPawn )
		{
			if ( aPawn.IsA('DeusExPlayer') && ( DeusExPlayer(Owner) != DeusExPlayer(aPawn) ) )
			{
				// If they can't see the weapon, don't bother
				if ( DeusExPlayer(aPawn).FastTrace( DeusExPlayer(aPawn).Location, Location ))
					DeusExPlayer(aPawn).ClientPlayAnimation( Self, anim, 0.1, bAutomatic );
			}
		}
	}
}

//GMDX: cosmetic shaking only
simulated function UpdateRecoilShaker()
{
	if(Owner.IsA('DeusExPlayer'))
	{
	  DeusExPlayer(Owner).RecoilShaker(RecoilShaker);
	  if (DeusExPlayer(Owner).PerkNamesArray[23] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponRifle')
	      negTime = (RecoilStrength * default.negTime)*0.75;
	  else if (DeusExPlayer(Owner).PerkNamesArray[22] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponPistol')
	      negTime = (RecoilStrength * default.negTime)*0.75;
	  else if (DeusExPlayer(Owner).PerkNamesArray[3] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponHeavy')
	      negTime = (RecoilStrength * default.negTime)*0.75;
	  else
	      negTime = RecoilStrength * default.negTime;
	}
}

simulated function PlayFiringSound()
{
	if (bHasSilencer)
		PlaySimSound(FireSilentSound, SLOT_None, TransientSoundVolume, 2048 );
	else
	{
		// The sniper rifle sound is heard to it's range in multiplayer
		if ( ( Level.NetMode != NM_Standalone ) &&  Self.IsA('WeaponRifle') )
			PlaySimSound( FireSound, SLOT_Interface, TransientSoundVolume, class'WeaponRifle'.Default.mpMaxRange );
		else if (Self.IsA('WeaponRifle'))
                        PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, class'WeaponRifle'.Default.MaxRange );
                else
			PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, 3074 ); //CyberP: All weapons can now be heard by the player at further distances. Sniper especially so.
	}

}

simulated function PlayIdleAnim()
{
	local float rnd;

	if ( (bZoomed&&bHasScope) || bNearWall || activateAn)
		return;

	rnd = FRand();
	if (Owner.IsA('DeusExPlayer'))
	{
    if (DeusExPlayer(Owner).bIsCrouching == False && (DeusExPlayer(Owner).Velocity.X != 0 || DeusExPlayer(Owner).Velocity.Y != 0))
    {
	if (rnd < 0.1)
		PlayAnim('Idle1',1.5,0.1);
	else if (rnd < 0.2)
		PlayAnim('Idle2',1.5,0.1);
	else if (!DeusExPlayer(Owner).InHand.IsA('WeaponCrowbar') && rnd < 0.3)
		PlayAnim('Idle3',1.5,0.1);
	}
    else
    {
    if (rnd < 0.1)
		PlayAnim('Idle1',,0.1);
	else if (rnd < 0.2)
		PlayAnim('Idle2',,0.1);
	else if (rnd < 0.3)
		PlayAnim('Idle3',,0.1);
    }
    }
}

//
// SpawnBlood
//

function SpawnBlood(Vector HitLocation, Vector HitNormal)
{
local BloodDrop drop;
local int i;
	if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
	  return;


    spawn(class'BloodDrop',,,HitLocation+HitNormal);
    spawn(class'BloodDrop',,,HitLocation+HitNormal);
    if (FRand() < 0.4)
       spawn(class'BloodDrop',,,HitLocation+HitNormal);
    spawn(class'BloodSpurt',,,HitLocation+HitNormal);
    if (!bHandToHand && Owner.IsA('DeusExPlayer'))
    {
    for(i=0;i<25;i++)
    {
    drop = spawn(class'BloodDrop',,,HitLocation+HitNormal);
    if (drop!=none)
    {
    drop.LifeSpan=0.2;
    drop.Velocity*=0.8;
    }
    }
    }
	if (FRand() < 0.5)
		spawn(class'BloodDrop',,,HitLocation+HitNormal);
}

////////////////////
//  function SpawnGMDXEffects //CyberP: so deco has impact effects. More sloppy code.
////////////////////
function SpawnGMDXEffects(Vector HitLocation, Vector HitNormal)
{
local int i;
local GMDXImpactSpark s;
local GMDXImpactSpark2 t;
local GMDXSparkFade fade;
local SFXExp puff2;
spawn(class'GMDXFireSmokeFade',,,HitLocation+HitNormal);
spawn(class'GMDXSparkFade',,,HitLocation+HitNormal);
		puff2 = spawn(class'SFXExp',,,HitLocation+HitNormal);
        if ( puff2 != None )
			{
		        puff2.scaleFactor=0.01;
		        puff2.scaleFactor2=3.5;
		        puff2.GlowFactor=0.2;
		        puff2.animSpeed=0.015;
			    puff2.RemoteRole = ROLE_None;
			}
		fade = spawn(class'GMDXSparkFade',,,HitLocation+HitNormal);
		 if (fade != None)
		 {
		 fade.DrawScale = 0.12;
		 }
       for (i=0;i<11;i++)
        {
        s = spawn(class'GMDXImpactSpark',,,HitLocation+HitNormal);
        t = spawn(class'GMDXImpactSpark2',,,HitLocation+HitNormal);
          if (s != none && t != none)
        {
        s.LifeSpan=FRand()*0.042;
        t.LifeSpan=FRand()*0.042;
        s.DrawScale = FRand() * 0.04;
        t.DrawScale = FRand() * 0.04;
        }
        }
}
//
// SelectiveSpawnEffects - Continues the simulated chain for the owner, and spawns the effects for other players that can see them
//			No actually spawning occurs on the server itself.
//
simulated function SelectiveSpawnEffects( Vector HitLocation, Vector HitNormal, Actor Other, float Damage)
{
	local DeusExPlayer fxOwner;
	local Pawn aPawn;

	// The normal path before there was multiplayer
	if ( Level.NetMode == NM_Standalone )
	{
		SpawnEffects(HitLocation, HitNormal, Other, Damage);
		return;
	}

	fxOwner = DeusExPlayer(Owner);

	if ( Role == ROLE_Authority )
	{
		SpawnEffectSounds(HitLocation, HitNormal, Other, Damage );

		for ( aPawn = Level.PawnList; aPawn != None; aPawn = aPawn.nextPawn )
		{
			if ( aPawn.IsA('DeusExPlayer') && ( DeusExPlayer(aPawn) != fxOwner ) )
			{
				if ( DeusExPlayer(aPawn).FastTrace( DeusExPlayer(aPawn).Location, HitLocation ))
					DeusExPlayer(aPawn).ClientSpawnHits( bPenetrating, bHandToHand, HitLocation, HitNormal, Other, Damage );
			}
		}
	}
	if ( fxOwner == DeusExPlayer(GetPlayerPawn()) )
	{
			fxOwner.ClientSpawnHits( bPenetrating, bHandToHand, HitLocation, HitNormal, Other, Damage );
			SpawnEffectSounds( HitLocation, HitNormal, Other, Damage );
	}
}

//
//	 SpawnEffectSounds - Plays the sound for the effect owner immediately, the server will play them for the other players
//
simulated function SpawnEffectSounds( Vector HitLocation, Vector HitNormal, Actor Other, float Damage )
{
	if (bHandToHand)
	{
		// if we are hand to hand, play an appropriate sound
		if (Other.IsA('DeusExDecoration'))
			Owner.PlayOwnedSound(Misc3Sound, SLOT_None,,, 1024);
		else if (Other.IsA('Pawn'))
			Owner.PlayOwnedSound(Misc1Sound, SLOT_None,,, 1024);
		else if (Other.IsA('BreakableGlass'))
			Owner.PlayOwnedSound(sound'GlassHit1', SLOT_None,,, 1024);
		else if (GetWallMaterial(HitLocation, HitNormal) == 'Glass')
			Owner.PlayOwnedSound(sound'BulletProofHit', SLOT_None,,, 1024);
		else
			Owner.PlayOwnedSound(Misc2Sound, SLOT_None,,, 1024);
	}
}

//
//	SpawnEffects - Spawns the effects like it did in single player
//
function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other, float Damage)
{
	local TraceHitSpawner hitspawner;
	local Name damageType;

	damageType = WeaponDamageType();

//	log("weap"@Other@Damage@damageType);

	//GMDX:dasraiser fix vanilla bug with fast pc's, do i dare fix entire game spawn system....nfl
	class'TraceHitSpawner'.default.HitDamage=Damage;
	class'TraceHitSpawner'.default.damageType=damageType;

	if (IsA('WeaponNanoSword')) //hitSpawner.damageType='NanoSword';
	{
	  class'TraceHitSpawner'.default.bForceBulletHole=true;
	  class'TraceHitSpawner'.default.damageType='DTS_Strike';

	  //if ((Emitter!=none)&&(Emitter.proxy!=none))
//      {
//         HitLocation=Emitter.proxy.Location;
//      }
	} else
	  class'TraceHitSpawner'.default.damageType=damageType;

	if (bPenetrating)
	{
	  if (bHandToHand) //dasraiser meh i see why now :/   HandToHand
	  {
		 hitspawner = Spawn(class'TraceHitHandSpawner',Other,,HitLocation,Rotator(HitNormal));
		 if (Owner.IsInState('Dying'))
		 hitspawner = none; //CyberP: death overrides melee attacks
	  }
	  else
	  {
		 hitspawner = Spawn(class'TraceHitSpawner',Other,,HitLocation,Rotator(HitNormal));
	  }
	}
	else
	{
	  if (bHandToHand)  //bHandToHand
	  {
		 hitspawner = Spawn(class'TraceHitHandNonPenSpawner',Other,,HitLocation,Rotator(HitNormal));
	  }
	  else
	  {
		 hitspawner = Spawn(class'TraceHitNonPenSpawner',Other,,HitLocation,Rotator(HitNormal));
	  }
	}
//   if (hitSpawner != None)
//	{
//	  hitspawner.HitDamage = Damage;
//		hitSpawner.damageType = damageType;
//	}
	if (bHandToHand)
	{
		// if we are hand to hand, play an appropriate sound
		if (Other.IsA('DeusExDecoration'))
			Owner.PlaySound(Misc3Sound, SLOT_None,,, 1024);
		else if (Owner.IsA('Doberman') && FRand() < 0.6)
            Owner.PlaySound(Misc3Sound, SLOT_None,,, 1024);
		else if (Other.IsA('Pawn'))
			Owner.PlaySound(Misc1Sound, SLOT_None,,, 1024);
		else if (Other.IsA('BreakableGlass'))
			Owner.PlaySound(sound'GlassHit1', SLOT_None,,, 1024);
		else if (GetWallMaterial(HitLocation, HitNormal) == 'Glass')
			Owner.PlaySound(sound'BulletProofHit', SLOT_None,,, 1024);
		else
			Owner.PlaySound(Misc2Sound, SLOT_None,,, 1024);
	    if (Other != none && !Other.IsA('Pawn'))
			AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 768); //CyberP: AI hear us smacking things
	}
}


function name GetWallMaterial(vector HitLocation, vector HitNormal)
{
	local vector EndTrace, StartTrace;
	local actor target;
	local int texFlags;
	local name texName, texGroup;

	StartTrace = HitLocation + HitNormal*16;		// make sure we start far enough out
	EndTrace = HitLocation - HitNormal;

	foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, StartTrace, HitNormal, EndTrace)
		if ((target == Level) || target.IsA('Mover'))
			break;

	return texGroup;
}

simulated function SimGenerateBullet()
{
	if ( Role < ROLE_Authority )
	{
		if ((ClipCount < ReloadCount) && (ReloadCount != 0))
		{
			if ( AmmoType != None )
				AmmoType.SimUseAmmo();

			if ( bInstantHit )
				TraceFire(currentAccuracy);
			else
				ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);

			SimClipCount++;

			if ( !Self.IsA('WeaponFlamethrower') )
				ServerGenerateBullet();
		}
		else
			GotoState('SimFinishFire');
	}
}

function DestroyOnFinish()
{
	bDestroyOnFinish = True;
}

function ServerGotoFinishFire()
{
	GotoState('FinishFire');
}

function ServerDoneReloading()
{
	ClipCount = 0;
}

function ServerGenerateBullet()
{
	if ( ClipCount < ReloadCount )
		GenerateBullet();
}

function GenerateBullet()
{

	if (AmmoType.UseAmmo(1))
	{
		if ( bInstantHit )
			TraceFire(currentAccuracy);
        else
			ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);

		ClipCount++;
	}
	else
		GotoState('FinishFire');
}


function PlayLandingSound()
{
	if (LandSound != None)
	{
		if (Velocity.Z <= -170)
		{
			PlaySound(LandSound, SLOT_None, TransientSoundVolume,, 1024);
			AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 512+(Mass*3));
		}
	}
}


function GetWeaponRanges(out float wMinRange,
						 out float wMaxAccurateRange,
						 out float wMaxRange)
{
	local Class<DeusExProjectile> dxProjectileClass;

	dxProjectileClass = Class<DeusExProjectile>(ProjectileClass);
	if (dxProjectileClass != None)
	{
		wMinRange         = dxProjectileClass.Default.blastRadius;
		wMaxAccurateRange = dxProjectileClass.Default.AccurateRange;
		wMaxRange         = dxProjectileClass.Default.MaxRange;
	}
	else
	{
		wMinRange         = 0;
		wMaxAccurateRange = AccurateRange;
		wMaxRange         = MaxRange;
	}
}

//
// computes the start position of a projectile/trace
//
simulated function Vector ComputeProjectileStart(Vector X, Vector Y, Vector Z)
{
	local Vector Start;

	// if we are instant-hit, non-projectile, then don't offset our starting point by PlayerViewOffset
	if (bInstantHit)
		Start = Owner.Location + Pawn(Owner).BaseEyeHeight * vect(0,0,1);// - Vector(Pawn(Owner).ViewRotation)*(0.9*Pawn(Owner).CollisionRadius);
	else
		Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

	return Start;
}

//
// Modified to work better with scripted pawns
//
simulated function vector CalcDrawOffset()
{
	local vector		DrawOffset, WeaponBob;
	local ScriptedPawn	SPOwner;
	local Pawn			PawnOwner;
	local vector unX,unY,unZ;

	SPOwner = ScriptedPawn(Owner);
	if (SPOwner != None)
	{
		DrawOffset = ((0.9/SPOwner.FOVAngle * PlayerViewOffset) >> SPOwner.ViewRotation);
		DrawOffset += (SPOwner.BaseEyeHeight * vect(0,0,1));
	}
	else
	{
		// copied from Engine.Inventory to not be FOVAngle dependent
		PawnOwner = Pawn(Owner);
		DrawOffset = ((0.9/PawnOwner.Default.FOVAngle * PlayerViewOffset) >> PawnOwner.ViewRotation);
		DrawOffset += (PawnOwner.EyeHeight * vect(0,0,1));
		WeaponBob = BobDamping * PawnOwner.WalkBob;
		WeaponBob.Z = (0.45 + 0.55 * BobDamping) * PawnOwner.WalkBob.Z;
		DrawOffset += WeaponBob;
	}
	if (Owner.IsA('DeusExPlayer'))
	{
		if (VSize(DeusExPlayer(Owner).RecoilShake)>0.0)
		{
			GetAxes(Rotation,unX,unY,unZ);
			if (IsA('WeaponHideAGun') && bFiring)
			unX*=DeusExPlayer(Owner).RecoilShake.X*-2;
			else if (IsA('WeaponRifle') && bFiring)
			unX*=DeusExPlayer(Owner).RecoilShake.X*-1.0;
			else
			unX*=DeusExPlayer(Owner).RecoilShake.X*0.5;

			unY*=DeusExPlayer(Owner).RecoilShake.Y*0.75;
			unZ*=DeusExPlayer(Owner).RecoilShake.Z*0.75;
			DrawOffset+=(unX+unY+unZ);
		}
	}
	return DrawOffset;
}

function GetAIVolume(out float volume, out float radius)
{
	volume = 0;
	radius = 0;

	if (!bHasSilencer && !bHandToHand)
	{
		volume = NoiseLevel*Pawn(Owner).SoundDampening;
		if (Owner.IsA('DeusExPlayer'))
		{
		    if (DeusExPlayer(Owner).CombatDifficulty < 1)
		        volume *= 0.5;  //CyberP: AI are less receptive to gunshots on lower difficulty levels. easy = -50% medium = -25%
		    else if (DeusExPlayer(Owner).CombatDifficulty < 3)
                volume *= 0.75;
		}
		radius = volume * 800.0;
	}
}


//
// copied from Weapon.uc
//
simulated function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X, Y, Z;
	local DeusExProjectile proj;
	local float mult, speedMult, rangeMult;
	local float volume, radius;
	local int i, numProj;
	local Pawn aPawn;
    local PlasmaParticleSpoof spoof;

	speedMult=1.0;
	// AugCombat increases our speed (distance) if hand to hand
	mult = 1.0;
	if (bHandToHand && (DeusExPlayer(Owner) != None))
	{
		mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
		if (mult == -1.0)
			mult = 1.0;
		ProjSpeed *= mult;
	}

	rangeMult = 1;

    if (IsA('WeaponGasGrenade') || IsA('WeaponEMPGrenade') || IsA('WeaponLAM') || IsA('WeaponNanoVirusGrenade'))
              PlaySound(sound'grenadethrow', SLOT_None,,, 640);
//G-Flex: range mod previously did nothing for projectiles
//G-Flex: the game says range mods work on plasma rifles/flamethrowers, so let's make it so
//G-Flex: fireballs in particular need to go faster to go further, which makes sense
//G-Flex: don't do as much for the minicrossbow or whatever else
	if (HasRangeMod())
	{
		rangeMult += (ModAccurateRange*1.3333);
		if (IsA('WeaponPlasmaRifle') || IsA('WeaponFlamethrower') || IsA('WeaponGEPGun') || IsA('WeaponMiniCrossbow'))
		speedMult += (ModAccurateRange*1.3333);
	}

	ProjSpeed *= speedMult;

	// skill also affects our damage
	// GetWeaponSkill returns 0.0 to -0.7 (max skill/aug)
	mult += -2.0 * GetWeaponSkill() + ModDamage; //CyberP: damage mod

	// make noise if we are not silenced
	if (!bHasSilencer && !bHandToHand)
	{
		GetAIVolume(volume, radius);
		Owner.AISendEvent('WeaponFire', EAITYPE_Audio, volume, radius);
		Owner.AISendEvent('LoudNoise', EAITYPE_Audio, volume, radius);
		if (!Owner.IsA('PlayerPawn'))
			Owner.AISendEvent('Distress', EAITYPE_Audio, volume, radius);
	}
    if (bLasing || bZoomed)
		currentAccuracy = 0.0;        //CyberP: laser & scope had no effect on xbow and plasma rifle

	// should we shoot multiple projectiles in a spread?
	if (AreaOfEffect == AOE_Cone && IsA('WeaponGraySpit'))
	    numProj = 2+(4*FRand());
    else if (AreaOfEffect == AOE_Cone && !IsA('WeaponSawedOffShotgun') && !IsA('WeaponAssaultShotgun') && !bSuperheated)
		numProj = 3;
	else
		numProj = 1;

	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = ComputeProjectileStart(X, Y, Z);
    if (IsA('WeaponFlamethrower'))
    {
    for(i=0;i<13;i++)
    {
    spoof = spawn(class'PlasmaParticleSpoof',,, start, Pawn(Owner).ViewRotation);
    if (spoof!=none)
    {
    spoof.DrawScale=0.005;
    spoof.LifeSpan=0.225;
    spoof.Texture=Texture'HDTPItems.Skins.HDTPMuzzleflashSmall2';
    spoof.Velocity=320*vector(Rotation);//vect(0,0,0);
    //spoof.Velocity.X = FRand() * 700;
    //spoof.Velocity.Z = FRand() * 60;

		if (FRand() < 0.3)
		{
		spoof.Velocity.Z += FRand() * 80;
		spoof.Velocity.X += FRand() * 65;
		spoof.Velocity.Y += FRand() * 65;
		}
		else if (FRand() < 0.6)
		{
		spoof.Velocity.Z -= FRand() * 20;
		spoof.Velocity.X -= FRand() * 55;
		spoof.Velocity.Y -= FRand() * 65;
		}
    }
    }
    }

	for (i=0; i<numProj; i++)
	{
	  // If we have multiple slugs, then lower our accuracy a bit after the first slug so the slugs DON'T all go to the same place
	  if ((i > 0) && (Level.NetMode != NM_Standalone))
		 if (currentAccuracy < MinProjSpreadAcc)
			currentAccuracy = MinProjSpreadAcc;

		AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);
		AdjustedAim.Yaw += currentAccuracy * (Rand(1024) - 512);
		AdjustedAim.Pitch += currentAccuracy * (Rand(1024) - 512);

       UpdateRecoilShaker();

		if (( Level.NetMode == NM_Standalone ) || ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient()) )
		{
			proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
			if (proj != None)
			{
				// AugCombat increases our damage as well
				proj.Damage *= mult;
				//G-Flex: actually use the new projectile speed (ProjSpeed / proj.Default.Speed)
				proj.Speed *= speedMult;
				proj.MaxSpeed *= speedMult;
				proj.Velocity *= speedMult;
				//G-Flex: travel further since we're faster
				proj.MaxRange *= rangeMult;
				proj.AccurateRange *= rangeMult;

                if (GoverningSkill==class'DeusEx.SkillDemolition')
                {
                  if (Owner != None && Owner.IsA('DeusExPlayer'))
                  {
                  if (bContactDeton)
                     proj.bContactDetonation=True;
                  if (DeusExPlayer(Owner).PerkNamesArray[15]==1)
                  {
                     //proj.MaxSpeed=1650.000000;
                     //proj.Velocity*=1.4;
                     if (proj.IsA('ThrownProjectile'))
                      ThrownProjectile(proj).fuseLength = 2.0;
                  }
                  }
                }
//GMDX player GEP
				if ((IsA('WeaponGEPGun'))&&(bLasing||bZoomed)&&(DeusExPlayer(Owner)!=none)&&(DeusExPlayer(Owner).RocketTarget!=none))
				{
				 //   LockTarget=DeusExPlayer(Owner).RocketTarget;
					if (bZoomed)
					{
						LockMode=LOCK_Locked; //needed?
						DeusExPlayer(Owner).aGEPProjectile=proj;
						proj.Target=none;
						proj.bRotateToDesired=true;
						proj.bTracking = False;
						DeusExPlayer(Owner).bGEPprojectileInflight=true;
						Rocket(proj).PostSpawnInit();

					} else
					{
						LockMode=LOCK_Locked; //needed?
						proj.Target = DeusExPlayer(Owner).RocketTarget;
						proj.bTracking = True;
						DeusExPlayer(Owner).bGEPprojectileInflight=false;
						DeusExPlayer(Owner).aGEPProjectile=proj;  //never both bGEPprojectileInflight with this if laser guided, this is just a ref to proj
						Rocket(proj).PostSpawnInit();
					}

				} else
				// send the targetting information to the projectile
				if (bCanTrack && (LockTarget != None) && (LockMode == LOCK_Locked))
				{
					proj.Target = LockTarget;
					proj.bTracking = True;
				}
			}
		}
		else
		{
			if (( Role == ROLE_Authority ) || (DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn())) )
			{
				// Do it the old fashioned way if it can track, or if we are a projectile that we could pick up again
				if ( bCanTrack || Self.IsA('WeaponShuriken') || Self.IsA('WeaponMiniCrossbow') || Self.IsA('WeaponLAM') || Self.IsA('WeaponEMPGrenade') || Self.IsA('WeaponGasGrenade'))
				{
					if ( Role == ROLE_Authority )
					{
						proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
						if (proj != None)
						{
							// AugCombat increases our damage as well
								proj.Damage *= mult;
							// send the targetting information to the projectile
							if (bCanTrack && (LockTarget != None) && (LockMode == LOCK_Locked))
							{
								proj.Target = LockTarget;
								proj.bTracking = True;
							}
						}
					}
				}
				else
				{
					proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
					if (proj != None)
					{
					   proj.RemoteRole = ROLE_None;
						// AugCombat increases our damage as well
						if ( Role == ROLE_Authority )
							proj.Damage *= mult;
						else
							proj.Damage = 0;
					}
					if ( Role == ROLE_Authority )
					{
						for ( aPawn = Level.PawnList; aPawn != None; aPawn = aPawn.nextPawn )
						{
							if ( aPawn.IsA('DeusExPlayer') && ( DeusExPlayer(aPawn) != DeusExPlayer(Owner) ))
								DeusExPlayer(aPawn).ClientSpawnProjectile( ProjClass, Owner, Start, AdjustedAim );
						}
					}
				}
			}
		}

	}

	return proj;
}

//
// copied from Weapon.uc so we can add range information
//
simulated function TraceFire( float Accuracy )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X, Y, Z;
	local Rotator rot;
	local actor Other;
	local float dist, alpha, degrade;
	local int i, numSlugs;
	local float volume, radius;

	// make noise if we are not silenced
	if (!bHasSilencer && !bHandToHand)
	{
		GetAIVolume(volume, radius);
		Owner.AISendEvent('WeaponFire', EAITYPE_Audio, volume, radius);
		Owner.AISendEvent('LoudNoise', EAITYPE_Audio, volume, radius);
		if (!Owner.IsA('PlayerPawn'))
			Owner.AISendEvent('Distress', EAITYPE_Audio, volume, radius);
	}

	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	StartTrace = ComputeProjectileStart(X, Y, Z);
	AdjustedAim = pawn(owner).AdjustAim(1000000, StartTrace, 2.75*AimError, False, False);

	// check to see if we are a shotgun-type weapon
	if (AreaOfEffect == AOE_Cone)
		numSlugs = 8;  //CyberP: was 5
	else
		numSlugs = 1;

	// if there is a scope, but the player isn't using it, decrease the accuracy
	// so there is an advantage to using the scope
	if (bHasScope && !bZoomed && !bLasing)
		{
        //Accuracy += 0.2;  //CyberP: commented out. This was -20% accuracy even if game weapon info and xhairs showed 100%.
		}
	// if the laser sight is on, make this shot dead on
	// also, if the scope is on, zero the accuracy so the shake makes the shot inaccurate
	else if (bLasing || bZoomed)
		Accuracy = 0.0;

    UpdateRecoilShaker();//GMDX: bung it here, less intrusive

	for (i=0; i<numSlugs; i++)
	{
	  // If we have multiple slugs, then lower our accuracy a bit after the first slug so the slugs DON'T all go to the same place
	  if ((i > 0) && (Level.NetMode != NM_Standalone) && !(bHandToHand))
		 if (Accuracy < MinSpreadAcc)
			Accuracy = MinSpreadAcc;

	  // Let handtohand weapons have a better swing
	  if ((bHandToHand) && (NumSlugs > 1) && (Level.NetMode != NM_Standalone))
	  {
		 StartTrace = ComputeProjectileStart(X,Y,Z);
		 StartTrace = StartTrace + (numSlugs/2 - i) * SwingOffset;
	  }

	  EndTrace = StartTrace + Accuracy * (FRand()-0.5)*Y*1000 + Accuracy * (FRand()-0.5)*Z*1000 ;
	  EndTrace += (FMax(1024.0, MaxRange) * vector(AdjustedAim));

	  Other = Pawn(Owner).TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);

		// randomly draw a tracer for relevant ammo types
		// don't draw tracers if we're zoomed in with a scope - looks stupid
	  // DEUS_EX AMSD In multiplayer, draw tracers all the time.
		if ( ((Level.NetMode == NM_Standalone) && (!bZoomed && (numSlugs >= 1) && (FRand() < 0.5))) ||
		   ((Level.NetMode != NM_Standalone) && (Role == ROLE_Authority)) )
		{
			if ((AmmoName == Class'Ammo10mm') || (AmmoName == Class'Ammo3006') ||
				(AmmoName == Class'Ammo762mm') || (AmmoName == Class'AmmoShell')) //CyberP: shotguns have tracers
			{
				if (VSize(HitLocation - StartTrace) > 250)
				{
					rot = Rotator(EndTrace - StartTrace);
			   //if (Owner.IsA('DeusExPlayer') && ((AmmoName == Class'Ammo762mm') || AmmoName == Class'Ammo3006'))
			//	  Spawn(class'Tracer',,, Owner.Location+FireOffset, rot);
			  // else
				  Spawn(class'Tracer',,, StartTrace + 96 * Vector(rot), rot);   //StartTrace + 96 * Vector(rot)
				}
			}
		}

		// check our range
		dist = Abs(VSize(HitLocation - Owner.Location));

		if (dist <= AccurateRange)		// we hit just fine
			ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
		else if (dist <= MaxRange)
		{
			// simulate gravity by lowering the bullet's hit point
			// based on the owner's distance from the ground
			alpha = (dist - AccurateRange) / (MaxRange - AccurateRange);
			degrade = 0.5 * Square(alpha);
			HitLocation.Z += degrade * (Owner.Location.Z - Owner.CollisionHeight);
			ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
		}
	}

	// otherwise we don't hit the target at all
}

simulated function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local float        mult;
	local name         damageType;
	local DeusExPlayer dxPlayer;
	local vector offset, offy; //CyberP
    local Tracer tra;
    local BloodMeleeHit spoofer;
    local GMDXSparkFade faded;

    if (bHandToHand && Owner != None)
    {
      if (Owner.IsInState('Dying'))
           return;             //CyberP: death cancels melee attacks
      else if (Owner.IsA('ScriptedPawn'))
      {
        if (Owner.IsInState('TakingHit')) //CyberP: Pain animation cancels melee attacks
           return;
      }
      else if (Owner.IsA('DeusExPlayer') && AccurateRange < 200)
         DeusExPlayer(Owner).ShakeView(0.1,156+(FRand()*(HitDamage*2)),4);
    }

	if (Other != None)
	{
		// AugCombat increases our damage if hand to hand
		mult = 1.0;
		if (bHandToHand && (DeusExPlayer(Owner) != None))
		{
			mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
			if (mult == -1.0)
				mult = 1.0;
		}

		// skill also affects our damage
		// GetWeaponSkill returns 0.0 to -0.7 (max skill/aug)
		mult += -2.0 * GetWeaponSkill() + ModDamage;   //CyberP: damage mod

		// Determine damage type
		damageType = WeaponDamageType();

        if (Owner.IsA('DeusExPlayer'))
        {
         if (!bHandToHand && !AmmoType.IsA('AmmoShell') && !bZoomed)
         {
          GetAxes(DeusExPlayer(Owner).ViewRotation,X,Y,Z);
		  offset = Owner.Location;
		  offset += X * Owner.CollisionRadius * 1.75;
		  if (DeusExPlayer(Owner).bIsCrouching)
		  offset.Z += Owner.CollisionHeight * 0.25;
          else
		  offset.Z += Owner.CollisionHeight * 0.7;
		  offset += Y * Owner.CollisionRadius * 0.65;
          tra= Spawn(class'Tracer',,, offset, (Rotator(HitLocation - offset)));
		  }
		}

		if (Other != None)
		{
			if (Other.bOwned)
			{
				dxPlayer = DeusExPlayer(Owner);
				if (dxPlayer != None)
					dxPlayer.AISendEvent('Futz', EAITYPE_Visual);
			}
		}
		if ((Other == Level) || (Other.IsA('Mover')))
		{
			if ( Role == ROLE_Authority )
				Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, 1000.0*X, damageType);

			SelectiveSpawnEffects( HitLocation, HitNormal, Other, HitDamage * mult);
		}
		else if ((Other != self) && (Other != Owner))
		{
			if ( Role == ROLE_Authority )
				Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, 1000.0*X, damageType);
			if (bHandToHand)
				SelectiveSpawnEffects( HitLocation, HitNormal, Other, HitDamage * mult);
            //if (Owner.IsA('DeusExPlayer') && Other.IsA('ScriptedPawn'))
                 //if (DeusExPlayer(Owner).bHitmarkerOn)
                    //DeusExPlayer(Owner).hitmarkerTime = 0.2;
            if (bPenetrating && !bHandToHand && Other.IsA('DeusExDecoration'))
                 SpawnGMDXEffects(HitLocation, HitNormal);

			if ((bPenetrating || bHandToHand) && Other.IsA('ScriptedPawn') && !Other.IsA('Robot'))
				{
				offy = Other.Location;
				offy.Z += (Other.CollisionHeight * 0.93);
				if (HitLocation.Z > offy.Z && ScriptedPawn(Other).bHasHelmet == True)
                {
                //faded = spawn(class'GMDXSparkFade',,,HitLocation);
                //if (faded != None)
                //   faded.DrawScale *= 0.4;
                }
                else
                {
				if (!bHandToHand && !Pawn(Other).IsA('DeusExPlayer') && !Pawn(Other).IsInState('Dying'))
                {SpawnBlood(HitLocation, HitNormal);  spoofer = Spawn(class'BloodMeleeHit',,,HitLocation);
                if (spoofer != none) spoofer.DrawScale= 0.14;}
                else if (bHandToHand)
                   if (IsA('WeaponNanoSword') || IsA('WeaponCombatKnife') || IsA('WeaponSword') || IsA('WeaponCrowbar'))
				     spoofer = Spawn(class'BloodMeleeHit',,,HitLocation);
				  //if (spoofer != none)
				  //spoofer.bMeleeSpawn = True;  //spoofer.DrawScale+=10.000000;}
				}
				}
			else if (Other.IsA('DeusExCarcass') && DamageType == 'shot')
            	{
            	spoofer = Spawn(class'BloodMeleeHit',,,HitLocation+vect(0,0,1));
            	if (spoofer != none) spoofer.DrawScale= 0.14;
            	}
		}
	}
	if (DeusExMPGame(Level.Game) != None)
	{
	  if (DeusExPlayer(Other) != None)
		 DeusExMPGame(Level.Game).TrackWeapon(self,HitDamage * mult);
	  else
		 DeusExMPGame(Level.Game).TrackWeapon(self,0);
	}
}

simulated function IdleFunction()
{
	PlayIdleAnim();
	bInProcess = False;
	if ( bFlameOn )
	{
		StopFlame();
		bFlameOn = False;
	}
}

simulated function SimFinish()
{
	ServerGotoFinishFire();

	bInProcess = False;
	bFiring = False;

	if ( bFlameOn )
	{
		StopFlame();
		bFlameOn = False;
	}

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	if ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bAutoReload )
	{
		if ( (SimClipCount >= ReloadCount) && CanReload() )
		{
			SimClipCount = 0;
			bClientReadyToFire = False;
			bInProcess = False;
			if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
				CycleAmmo();
			ReloadAmmo();
		}
	}

	if (Pawn(Owner) == None)
	{
		GotoState('SimIdle');
		return;
	}
	if ( PlayerPawn(Owner) == None )
	{
		if ( (Pawn(Owner).bFire != 0) && (FRand() < RefireRate) )
			ClientReFire(0);
		else
			GotoState('SimIdle');
		return;
	}
	if ( Pawn(Owner).bFire != 0 )
		ClientReFire(0);
	else
		GotoState('SimIdle');
}

// Finish a firing sequence (ripped off and modified from Engine\Weapon.uc)
function Finish()
{
	if ( Level.NetMode != NM_Standalone )
		ReadyClientToFire( True );

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

    if (bBeginQuickMelee)
    {
            bFiring = False;
            if (Owner != None && Owner.IsA('DeusExPlayer'))
            {
               DeusExPlayer(Owner).StopFiring();
               if (quickMeleeCombo > 0)
               {
                 PlaySelect();
                 return;
               }
               if (DeusExPlayer(Owner).primaryWeapon != None)
               {
				  if (AccurateRange > 200)
                      Buoyancy=5.123456;
                  if (bHandToHand && (ReloadCount > 0) && (AmmoType.AmmoAmount <= 0))
                  {
                     bBeginQuickMelee = False;
                     DeusExPlayer(Owner).assignedWeapon = None;
				     Destroy();
				  }
                  if (DeusExPlayer(Owner).CarriedDecoration == None)
                     DeusExPlayer(Owner).inHandPending = DeusExPlayer(Owner).primaryWeapon;

                  GotoState('idle');
                  return;
               }
            }
    }

	if ( bChangeWeapon )
	{
		GotoState('DownWeapon');
		return;
	}

	if (( Level.NetMode != NM_Standalone ) && IsInState('Active'))
	{
		GotoState('Idle');
		return;
	}

	if (Pawn(Owner) == None)
	{
		GotoState('Idle');
		return;
	}
	if ( PlayerPawn(Owner) == None )
	{
		//bFireMem = false;
		//bAltFireMem = false;
		if ( ((AmmoType==None) || (AmmoType.AmmoAmount<=0)) && ReloadCount!=0 )
		{
			Pawn(Owner).StopFiring();
			Pawn(Owner).SwitchToBestWeapon();
		}
		else if ( (Pawn(Owner).bFire != 0) && (FRand() < RefireRate) )
			Global.Fire(0);
		else if ( (Pawn(Owner).bAltFire != 0) && (FRand() < AltRefireRate) )
			Global.AltFire(0);
		else
		{
			Pawn(Owner).StopFiring();
			GotoState('Idle');
		}
		return;
	}

	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
	{
		GotoState('Idle');
		return;
	}

	if ( ((AmmoType==None) || (AmmoType.AmmoAmount<=0)) || (Pawn(Owner).Weapon != self) )
		GotoState('Idle');
	else if ( /*bFireMem ||*/ Pawn(Owner).bFire!=0 )
	{
	  //if (DeusExPlayer(Owner)!=none) damn can 'other', not player/scripted fire!?
	  if (DeusExPlayer(Owner)!=None && bFullAuto)  //CyberP: full auto
	  Global.Fire(0);
	  else
	  GotoState('Idle'); //GMDX you got no semi-auto biatch >:) click to stab satisfaction
	  //   else Global.Fire(0);
	}
	else if ( /*bAltFireMem ||*/ Pawn(Owner).bAltFire!=0 )
		GotoState('Idle'); //GMDX you got no semi-auto biatch >:)
	  //Global.AltFire(0);
	else
		GotoState('Idle');
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInventoryInfoWindow winInfo;
	local string str;
	local int i, dmg, numMods;
	local float mod, stamDrain;
	local bool bHasAmmo;
	local bool bAmmoAvailable;
	local class<DeusExAmmo> ammoClass;
	local Pawn P;
	local Ammo weaponAmmo;
	local int  ammoAmount;
	local float hh;
    local string msgSemi, msgFull, msgMultiplier, noiseLev, msgNoise;
    local DeusExPlayer player;

	P = Pawn(Owner);
	if (P == None)
		return False;

	winInfo = PersonaInventoryInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.SetTitle(itemName);
	if (bHandToHand)
	{
	   if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkNamesArray[25] != 1 && IsA('WeaponNanoSword'))
	   {
	   }
	   else
	   winInfo.AddSecondaryButton(self);
	}
	winInfo.SetText(msgInfoWeaponStats);
	winInfo.AddLine();

	// Create the ammo buttons.  Start with the AmmoNames[] array,
	// which is used for weapons that can use more than one
	// type of ammo.

	if (AmmoNames[0] != None)
	{
		for (i=0; i<ArrayCount(AmmoNames); i++)
		{
			if (AmmoNames[i] != None)
			{
				// Check to make sure the player has this ammo type
				// *and* that the ammo isn't empty
				weaponAmmo = Ammo(P.FindInventoryType(AmmoNames[i]));

				if (weaponAmmo != None)
				{
					ammoAmount = weaponAmmo.AmmoAmount;
					bHasAmmo = (weaponAmmo.AmmoAmount > 0);
				}
				else
				{
					ammoAmount = 0;
					bHasAmmo = False;
				}

				winInfo.AddAmmo(AmmoNames[i], bHasAmmo, ammoAmount);
				bAmmoAvailable = True;

				if (AmmoNames[i] == AmmoName)
				{
					winInfo.SetLoaded(AmmoName);
					ammoClass = class<DeusExAmmo>(AmmoName);
				}
			}
		}
	}
	else
	{
		// Now peer at the AmmoName variable, but only if the AmmoNames[]
		// array is empty
		if ((AmmoName != class'AmmoNone') && (!bHandToHand) && (ReloadCount != 0))
		{
			weaponAmmo = Ammo(P.FindInventoryType(AmmoName));

			if (weaponAmmo != None)
			{
				ammoAmount = weaponAmmo.AmmoAmount;
				bHasAmmo = (weaponAmmo.AmmoAmount > 0);
			}
			else
			{
				ammoAmount = 0;
				bHasAmmo = False;
			}

			winInfo.AddAmmo(AmmoName, bHasAmmo, ammoAmount);
			winInfo.SetLoaded(AmmoName);
			ammoClass = class<DeusExAmmo>(AmmoName);
			bAmmoAvailable = True;
		}
	}

	// Only draw another line if we actually displayed ammo.
	if (bAmmoAvailable)
		winInfo.AddLine();

	// Ammo loaded
	if ((AmmoName != class'AmmoNone') && (!bHandToHand) && (ReloadCount != 0))
		winInfo.AddAmmoLoadedItem(msgInfoAmmoLoaded, AmmoType.itemName);

	// ammo info
	if ((AmmoName == class'AmmoNone') || (ReloadCount == 0))
		str = msgInfoNA;
	else
		str = AmmoName.Default.ItemName;
	for (i=0; i<ArrayCount(AmmoNames); i++)
		if ((AmmoNames[i] != None) && (AmmoNames[i] != AmmoName))
			str = str $ "|n" $ AmmoNames[i].Default.ItemName;
    if (!bHandToHand || IsA('WeaponProd'))
	winInfo.AddAmmoTypesItem(msgInfoAmmo, str);

	// base damage
	if (AreaOfEffect == AOE_Cone)
	{
		if (bInstantHit)
		{
			if (Level.NetMode != NM_Standalone)
				dmg = Default.mpHitDamage * 5;
			else
				dmg = Default.HitDamage;
		}
		else
		{
			if (Level.NetMode != NM_Standalone)
				dmg = Default.mpHitDamage * 3;
			else
				dmg = Default.HitDamage;
		}
	}
	else
	{
		if (Level.NetMode != NM_Standalone)
			dmg = Default.mpHitDamage;
		else
			dmg = Default.HitDamage;
	}
    hh = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
	str = String(dmg);
	 if (hh < 1.0)
    hh = 0.0;
    else if (hh == 1.400000)
    hh = 0.4;
    else if (hh == 1.600000)
    hh = 0.6;
    else if (hh == 1.800000)
    hh = 0.8;
    else if (hh == 2.000000)
    hh = 1.0;

	//G-Flex: display the correct damage bonus
	mod = 1.0 - (2.0 * GetWeaponSkill()) + ModDamage;  //CyberP: damage mods
	if (bHandToHand)
    {
    mod = 1.0 - (2.0 * GetWeaponSkill()) + hh;
    }
	if (mod != 1.0 || HasDAMMod())
	{
		str = str @ BuildPercentString(mod - 1.0);
		str = str @ "=" @ FormatFloatString(dmg * mod, 1.0);
	}

    winInfo.AddInfoItem(msgInfoDamage, str, (mod != 1.0));

    //Headshot multiplier
    str = "x8";
    msgMultiplier = "Head Multiplier:";
    if (ItemName == "USP.10" || IsA('WeaponSawedOffShotgun'))
    str = "x9";
    else if (IsA('WeaponProd') || IsA('WeaponBaton'))
    str = "x5";
    else if (IsA('WeaponNanoSword') || IsA('WeaponCrowbar'))
    str = "x6";

    if (!IsA('WeaponPepperGun'))
    winInfo.AddInfoItem(msgMultiplier, str);
	// clip size
	if ((Default.ReloadCount == 0) || bHandToHand)
		str = msgInfoNA;
	else
	{
		if ( Level.NetMode != NM_Standalone )
			str = Default.mpReloadCount @ msgInfoRounds;
		else
			str = Default.ReloadCount @ msgInfoRounds;
	}

	if (HasClipMod())
	{
		str = str @ BuildPercentString(ModReloadCount);
		str = str @ "=" @ ReloadCount @ msgInfoRounds;
	}
    if (!bHandToHand || IsA('WeaponProd') || IsA('WeaponPepperGun'))
	winInfo.AddInfoItem(msgInfoClip, str, HasClipMod());

	// rate of fire
	if ((Default.ReloadCount == 0) || bHandToHand)
	{
		str = msgInfoNA;
	}
	else
	{
		if (bAutomatic)
			str = msgInfoAuto;
		else
			str = msgInfoSingle;

		str = str $ "," @ FormatFloatString(1.0/Default.ShotTime, 0.1) @ msgInfoRoundsPerSec;
		if(HasROFMod())
		{
			str = str @ BuildPercentString(ModShotTime);
			str = str @ "=" @ FormatFloatString(1.0/ShotTime, 0.1) @ msgInfoRoundsPerSec;
		}
	}
	if (!bHandToHand || IsA('WeaponProd'))
	winInfo.AddInfoItem(msgInfoROF, str, HasROFMod());

	// reload time
	if ((Default.ReloadCount == 0) || bHandToHand)
		str = msgInfoNA;
	else
	{
		if (Level.NetMode != NM_Standalone )
			str = FormatFloatString(Default.mpReloadTime, 0.1) @ msgTimeUnit;
		else
			str = FormatFloatString(Default.ReloadTime, 0.1) @ msgTimeUnit;
	}

	if (HasReloadMod())
	{
		str = str @ BuildPercentString(ModReloadTime);
		str = str @ "=" @ FormatFloatString(ReloadTime, 0.1) @ msgTimeUnit;
	}
    if (!bHandToHand || IsA('WeaponPepperGun') || IsA('WeaponProd'))
	winInfo.AddInfoItem(msgInfoReload, str, HasReloadMod());

	// recoil
	str = FormatFloatString(Default.recoilStrength, 0.01);
	if (HasRecoilMod())
	{
		str = str @ BuildPercentString(ModRecoilStrength);
		str = str @ "=" @ FormatFloatString(recoilStrength, 0.01);
	}
    if (!bHandToHand)
	winInfo.AddInfoItem(msgInfoRecoil, str, HasRecoilMod());

	// base accuracy (2.0 = 0%, 0.0 = 100%)
	if ( Level.NetMode != NM_Standalone )
	{
		str = Int((2.0 - Default.mpBaseAccuracy)*50.0) $ "%";
		mod = (Default.mpBaseAccuracy - (BaseAccuracy + GetWeaponSkill())) * 0.5;
		if (mod != 0.0)
		{
			str = str @ BuildPercentString(mod);
			str = str @ "=" @ Min(100, Int(100.0*mod+(2.0 - Default.mpBaseAccuracy)*50.0)) $ "%";
		}
	}
	else
	{
		str = Int((2.0 - Default.BaseAccuracy)*50.0) $ "%";
		mod = (Default.BaseAccuracy - (BaseAccuracy + GetWeaponSkill())) * 0.5;
		if (mod != 0.0)
		{
			str = str @ BuildPercentString(mod);
			str = str @ "=" @ Min(100, Int(100.0*mod+(2.0 - Default.BaseAccuracy)*50.0)) $ "%";
		}
	}
	if (!bHandToHand || IsA('WeaponProd') || IsA('WeaponShuriken'))
	winInfo.AddInfoItem(msgInfoAccuracy, str, (mod != 0.0));

	// accurate range
	//if (bHandToHand)
	//	str = msgInfoNA;
	//else
	//{
		if ( Level.NetMode != NM_Standalone )
			str = FormatFloatString(Default.mpAccurateRange/16.0, 1.0) @ msgRangeUnit;
		else
			str = FormatFloatString(Default.AccurateRange/16.0, 1.0) @ msgRangeUnit;
	//}

	if (HasRangeMod())
	{
		str = str @ BuildPercentString(ModAccurateRange);
		str = str @ "=" @ FormatFloatString(AccurateRange/16.0, 1.0) @ msgRangeUnit;
	}
	if (!bHandToHand || IsA('WeaponShuriken'))
	winInfo.AddInfoItem(msgInfoAccRange, str, HasRangeMod());

	// max range
	//if (bHandToHand)
	//	str = msgInfoNA;
	//else
	//{
		if ( Level.NetMode != NM_Standalone )
			str = FormatFloatString(Default.mpMaxRange/16.0, 1.0) @ msgRangeUnit;
		else
			str = FormatFloatString(Default.MaxRange/16.0, 1.0) @ msgRangeUnit;
	//}
	winInfo.AddInfoItem(msgInfoMaxRange, str);

	//Noise level
	if (!bHandToHand || IsA('WeaponProd') || IsA('WeaponHideAGun') || IsA('WeaponPepperGun'))
	{
	noiseLev="dB";
	msgNoise="Noise Level:";
	  if (bHasSilencer)
      {
         str = "0.5";
         winInfo.AddInfoItem(msgNoise,str @ noiseLev);
      }
      else
	winInfo.AddInfoItem(msgNoise,FormatFloatString(NoiseLevel,1.0) @ noiseLev);
    }

    if (meleeStaminaDrain != 0 && !IsA('WeaponShuriken'))  //CyberP: display special, speed rating & stamina drain
    {
    player = DeusExPlayer(GetPlayerPawn());
		mod = player.SkillSystem.GetSkillLevel(class'SkillWeaponLowTech');
        if (mod < 3)
          mod = 1;
        else
          mod = 0.5;

    msgNoise="Special:";
    noiseLev="Speed Rating:";
    msgInfoNA="Stamina Drain:";
    if (IsA('WeaponSword'))
    {
      str = "3% chance to block bullets";
      if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0)
         msgMultiplier = "Moderate";
      else
         msgMultiplier = "Fast";
      stamDrain = meleeStaminaDrain*mod;
    }
    else if (IsA('WeaponCrowbar'))
    {
      str = "+200% damage when thrown";
      if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0)
         msgMultiplier = "Fast";
      else
         msgMultiplier = "Very Fast";
      stamDrain = meleeStaminaDrain*mod;
    }
    else if (IsA('WeaponBaton'))
    {
      str = "Silent attack";
      if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0)
         msgMultiplier = "Slow";
      else
         msgMultiplier = "Moderate";
      stamDrain = meleeStaminaDrain*mod;
    }
    else if (IsA('WeaponCombatKnife'))
    {
      str = "N/A";
      if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0)
         msgMultiplier = "Fast";
      else
         msgMultiplier = "Very Fast";
      stamDrain = meleeStaminaDrain*mod;
    }
    else if (IsA('WeaponNanoSword'))
    {
      str = "Emits light";
      if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0)
         msgMultiplier = "Medium";
      else
         msgMultiplier = "Fast";
      stamDrain = meleeStaminaDrain*mod;
    }
    if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0)
         winInfo.AddInfoItem(noiseLev,msgMultiplier,false);
    else
         winInfo.AddInfoItem(noiseLev,msgMultiplier,true);
    if (mod != 1)
        winInfo.AddInfoItem(msgInfoNA, FormatFloatString(stamDrain,0.01), true);
    else
        winInfo.AddInfoItem(msgInfoNA, FormatFloatString(stamDrain,0.01), false);
    winInfo.AddInfoItem(msgNoise,str);
    }

	// mass
	winInfo.AddInfoItem(msgInfoMass, FormatFloatString(Default.Mass, 1.0) @ msgMassUnit);

	// laser mod
	if (bCanHaveLaser)
	{
		if (bHasLaser)
			str = msgInfoYes;
		else
			str = msgInfoNo;
	}
	else
	{
		str = msgInfoNA;
	}
	if (!bHandToHand)
	winInfo.AddInfoItem(msgInfoLaser, str, bCanHaveLaser && bHasLaser && (Default.bHasLaser != bHasLaser));

	// scope mod
	if (bCanHaveScope)
	{
		if (bHasScope)
			str = msgInfoYes;
		else
			str = msgInfoNo;
	}
	else
	{
		str = msgInfoNA;
	}
	if (!bHandToHand)
	winInfo.AddInfoItem(msgInfoScope, str, bCanHaveScope && bHasScope && (Default.bHasScope != bHasScope));

	// silencer mod
	if (bCanHaveSilencer)
	{
		if (bHasSilencer)
			str = msgInfoYes;
		else
			str = msgInfoNo;
	}
	else
	{
		str = msgInfoNA;
	}
	if (!bHandToHand)
	winInfo.AddInfoItem(msgInfoSilencer, str, bCanHaveSilencer && bHasSilencer && (Default.bHasSilencer != bHasSilencer));

    //CyberP: full-auto mod
    if (!bHandToHand)
    {
    if (IsA('WeaponLAW'))
    {
       msgFull="Single Shot";
			str = msgFull;
    }
    else if (IsA('WeaponSawedOffShotgun'))
    {
       msgFull="Pump-Action";
			str = msgFull;
    }
	else if (bFullAuto || bAutomatic)
	{
		msgFull="Fully-Automatic";
			str = msgFull;
	}
	else
	{
	    msgSemi="Semi-Automatic";
	       str = msgSemi;
	}
	winInfo.AddInfoItem(msgInfoFullAuto, str, bCanHaveModFullAuto && bFullAuto && (Default.bFullAuto != bFullAuto));
    }
    //Lethality
    if (IsA('WeaponHideAGun') || IsA('WeaponMiniCrossbow') || IsA('WeaponSawedOffShotgun') || IsA('WeaponAssaultShotgun'))
    str= "Variable";
    else if (bPenetrating || IsA('WeaponCrowbar'))
    str= "Lethal";
    else
    str= "Non-lethal";
    msgFull="Lethality:";
    winInfo.AddInfoItem(msgFull, str);

    //secondary weapon
    if (bHandToHand && !IsA('WeaponNanoSword'))
       str = msgInfoYes;
    else if (IsA('WeaponNanoSword') && player.PerkNamesArray[25] == 1)
       str = msgInfoYes;
    else
       str = msgInfoNo;
    msgFull = "Secondary:";
    winInfo.AddInfoItem(msgFull, str);

	// Governing Skill
	winInfo.AddInfoItem(msgInfoSkill, GoverningSkill.default.SkillName);

    if (bCanHaveModBaseAccuracy || bCanHaveModReloadCount || bCanHaveModAccurateRange || bCanHaveModReloadTime || bCanHaveModRecoilStrength || bCanHaveModShotTime || bCanHaveModDamage)
        {
                winInfo.AddLine();
                winInfo.SetText("Installed Modifications:");
                winInfo.AddLine();

                if (bCanHaveModReloadCount)
                {
                        numMods = Int(Abs(ModReloadCount) * 10);
                        winInfo.AddModInfo("Clip:", numMods, (numMods == 5));//winInfo.AddInfoItem("Clip:", numMods $ "/5", (numMods == 5));
                        //if (numMods >=0)
                        //winInfo.CreateWin();   //CyberP: fuck UI code!
                }

                if (bCanHaveModShotTime)
                {
                        numMods = Int(Abs(ModShotTime) * 10);
                        //winInfo.AddInfoItem("Rate of Fire:", numMods $ "/5", (numMods == 5));
                        winInfo.AddModInfo("Rate of Fire:", numMods, (numMods == 5));
                }

                if (bCanHaveModReloadTime)
                {
                        numMods = Int(Abs(ModReloadTime) * 10);
                        //winInfo.AddInfoItem("Reload:", numMods $ "/5", (numMods == 5));
                        winInfo.AddModInfo("Reload:", numMods, (numMods == 5));
                }

                if (bCanHaveModDamage)
                {
                        numMods = Int(Abs(ModDamage) * 10);
                        //winInfo.AddInfoItem("Damage:", numMods $ "/5", (numMods == 5));
                        winInfo.AddModInfo("Damage:", numMods, (numMods == 5));
                }

                if (bCanHaveModRecoilStrength)
                {
                        numMods = Int(Abs(ModRecoilStrength) * 10);
                        //winInfo.AddInfoItem("Recoil:", numMods $ "/5", (numMods == 5));
                        winInfo.AddModInfo("Recoil:", numMods, (numMods == 5));
                }

                if (bCanHaveModBaseAccuracy)
                {
                        numMods = Int(Abs(ModBaseAccuracy) * 10);
                        //winInfo.AddInfoItem("Accuracy:", numMods $ "/5", (numMods == 5));
                        winInfo.AddModInfo("Accuracy:", numMods, (numMods == 5));
                }

                if (bCanHaveModAccurateRange)
                {
                        numMods = Int(Abs(ModAccurateRange) * 10);
                        //winInfo.AddInfoItem("Range:", numMods $ "/5", (numMods == 5));
                        winInfo.AddModInfo("Range:", numMods, (numMods == 5));
                }
                /*if (bCanHaveScope) //CyberP: uncomment to add scope, laser, silencer and full-auto for extra fun
                {
                if (bHasScope)
                str = msgInfoYes;
                else
                str = msgInfoNo;
                winInfo.AddInfoItem(msgInfoScope, str);
                }
                if (bCanHaveLaser)
                {
	            if (bHasLaser)
	         	str = msgInfoYes;
	            else
            	str = msgInfoNo;
            	winInfo.AddInfoItem(msgInfoLaser, str);
                }
                if (bCanHaveSilencer)
                {
	            if (bHasSilencer)
	         	str = msgInfoYes;
	            else
            	str = msgInfoNo;
            	winInfo.AddInfoItem(msgInfoSilencer, str);
                }
                if (bCanHaveModFullAuto)
                {
	            if (bFullAuto)
	         	str = msgInfoYes;
	            else
            	str = msgInfoNo;
            	winInfo.AddInfoItem(msgInfoFullAuto, str);
                }  */
         }
	winInfo.AddLine();
	winInfo.SetText(Description);

	// If this weapon has ammo info, display it here
	if (ammoClass != None)
	{
		winInfo.AddLine();
		winInfo.AddAmmoDescription(ammoClass.Default.ItemName $ "|n" $ ammoClass.Default.description);
	}

	return True;
}

// ----------------------------------------------------------------------
// UpdateAmmoInfo()
// ----------------------------------------------------------------------

simulated function UpdateAmmoInfo(Object winObject, Class<DeusExAmmo> ammoClass)
{
	local PersonaInventoryInfoWindow winInfo;
	local string str;
	local int i;

	winInfo = PersonaInventoryInfoWindow(winObject);
	if (winInfo == None)
		return;

	// Ammo loaded
	if ((AmmoName != class'AmmoNone') && (!bHandToHand) && (ReloadCount != 0))
		winInfo.UpdateAmmoLoaded(AmmoType.itemName);

	// ammo info
	if ((AmmoName == class'AmmoNone') || bHandToHand || (ReloadCount == 0))
		str = msgInfoNA;
	else
		str = AmmoName.Default.ItemName;
	for (i=0; i<ArrayCount(AmmoNames); i++)
		if ((AmmoNames[i] != None) && (AmmoNames[i] != AmmoName))
			str = str $ "|n" $ AmmoNames[i].Default.ItemName;

	winInfo.UpdateAmmoTypes(str);

	// If this weapon has ammo info, display it here
	if (ammoClass != None)
		winInfo.UpdateAmmoDescription(ammoClass.Default.ItemName $ "|n" $ ammoClass.Default.description);
}

// ----------------------------------------------------------------------
// BuildPercentString()
// ----------------------------------------------------------------------

simulated final function String BuildPercentString(Float value)
{
	local string str;

	str = String(Int(Abs(value * 100.0)));
	if (value < 0.0)
		str = "-" $ str;
	else
		str = "+" $ str;

	return ("(" $ str $ "%)");
}

// ----------------------------------------------------------------------
// FormatFloatString()
// ----------------------------------------------------------------------

simulated function String FormatFloatString(float value, float precision)
{
	local string str;

	if (precision == 0.0)
		return "ERR";

	// build integer part
	str = String(Int(value));

	// build decimal part
	if (precision < 1.0)
	{
		value -= Int(value);
		str = str $ "." $ String(Int((0.5 * precision) + value * (1.0 / precision)));
	}

	return str;
}

// ----------------------------------------------------------------------
// CR()
// ----------------------------------------------------------------------

simulated function String CR()
{
	return Chr(13) $ Chr(10);
}

// ----------------------------------------------------------------------
// HasReloadMod()
// ----------------------------------------------------------------------

simulated function bool HasReloadMod()
{
	return (ModReloadTime != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxReloadMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxReloadMod()
{
	return (ModReloadTime == -0.5);
}

// ----------------------------------------------------------------------
// HasClipMod()
// ----------------------------------------------------------------------

simulated function bool HasClipMod()
{
	return (ModReloadCount != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxClipMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxClipMod()
{
	return (ModReloadCount == 0.5);
}

// ----------------------------------------------------------------------
// HasRangeMod()
// ----------------------------------------------------------------------

simulated function bool HasRangeMod()
{
	return (ModAccurateRange != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxRangeMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxRangeMod()
{
	return (ModAccurateRange == 0.5);
}

// ----------------------------------------------------------------------
// HasAccuracyMod()
// ----------------------------------------------------------------------

simulated function bool HasAccuracyMod()
{
	return (ModBaseAccuracy != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxAccuracyMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxAccuracyMod()
{
	return (ModBaseAccuracy == 0.5);
}

// ----------------------------------------------------------------------
// HasRecoilMod()
// ----------------------------------------------------------------------

simulated function bool HasRecoilMod()
{
	return (ModRecoilStrength != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxRecoilMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxRecoilMod()
{
	return (ModRecoilStrength == -0.5);
}

// ----------------------------------------------------------------------
// HasROFMod()
// ----------------------------------------------------------------------

simulated function bool HasROFMod()
{
	return (ModShotTime != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxROFMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxROFMod()
{
	return (ModShotTime == -0.5);
}

// ----------------------------------------------------------------------
// HasDAMMod()
// ----------------------------------------------------------------------

simulated function bool HasDAMMod()
{
	return (ModDamage != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxDAMMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxDAMMod()
{
	return (ModDamage == 0.5);
}
// ----------------------------------------------------------------------
// ClientDownWeapon()
// ----------------------------------------------------------------------

simulated function ClientDownWeapon()
{
	bWasInFiring = IsInState('ClientFiring') || IsInState('SimFinishFire');
	bClientReadyToFire = False;
	GotoState('SimDownWeapon');
}

simulated function ClientActive()
{
	bWasInFiring = IsInState('ClientFiring') || IsInState('SimFinishFire');
	bClientReadyToFire = False;
	GotoState('SimActive');
}

simulated function ClientReload()
{
	bWasInFiring = IsInState('ClientFiring') || IsInState('SimFinishFire');
	bClientReadyToFire = False;
	GotoState('SimReload');
}

//
// weapon states
//

state NormalFire
{
	function AnimEnd()
	{
		if (bAutomatic)
		{
			if ((Pawn(Owner).bFire != 0) && (AmmoType.AmmoAmount > 0))
			{
				if (PlayerPawn(Owner) != None)
					Global.Fire(0);
				else
					GotoState('FinishFire');
			}
			else
				GotoState('FinishFire');
		}
		else
		{
			// if we are a thrown weapon and we run out of ammo, destroy the weapon
			if (bHandToHand && (ReloadCount > 0) && (AmmoType.AmmoAmount <= 0))
			{
			   if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).assignedWeapon != None && DeusExPlayer(Owner).assignedWeapon == self)
			      DeusExPlayer(Owner).assignedWeapon = None;
				Destroy();
			}
		}
	}
	function float GetShotTime()
	{
		local float mult, sTime;

		if (ScriptedPawn(Owner) != None)
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
			}
			sTime = ShotTime * mult;
			return (sTime);
		}
	}

Begin:
	if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
	{
		if (!bAutomatic)
		{
			//bFiring = False; //CyberP: put this after finishanim() so last bullet has recoil.
			FinishAnim();
			bFiring = False;
		}

		if (Owner != None)
		{
			if (Owner.IsA('DeusExPlayer'))
			{
				bFiring = False;

				// should we autoreload?
				if ((DeusExPlayer(Owner).bAutoReload)&&(DeusExPlayer(Owner).aGEPProjectile==none)) //GMDX: no reload if inflight
				{
					// auto switch ammo if we're out of ammo and
					// we're not using the primary ammo
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();
					ReloadAmmo();
				}
				else
				if (!DeusExPlayer(Owner).bAutoReload)
				{
					if (bHasMuzzleFlash)
						EraseMuzzleFlashTexture();
					GotoState('Idle');
				} else
				  GotoState('Idle');
			}
			else if (Owner.IsA('ScriptedPawn'))
			{
				bFiring = False;
				ReloadAmmo();
			}
		}
		else
		{
			if (bHasMuzzleFlash)
				EraseMuzzleFlashTexture();
			GotoState('Idle');
		}
	}
	if ( bAutomatic && (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient())))
		GotoState('Idle');

	Sleep(GetShotTime());
	if (bAutomatic)
	{
		GenerateBullet();	// In multiplayer bullets are generated by the client which will let the server know when
		Goto('Begin');
	}
	bFiring = False;
	if ((IsA('WeaponPistol') || IsA('WeaponMiniCrossbow')) && Owner.IsA('DeusExPlayer'))
	{
	}
	else
	{
	    FinishAnim();
    }
	// if ReloadCount is 0 and we're not hand to hand, then this is a
	// single-use weapon so destroy it after firing once
	if ((ReloadCount == 0) && !bHandToHand)
	{
		if (DeusExPlayer(Owner) != None)
			DeusExPlayer(Owner).RemoveItemFromSlot(Self);   // remove it from the inventory grid
		Destroy();
	}
	ReadyToFire();
Done:
	bFiring = False;
	Finish();
}

state FinishFire
{
Begin:
	bFiring = False;
	if ( bDestroyOnFinish )
		Destroy();
	else
		Finish();
}

state Pickup
{
	function BeginState()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);

		Super.BeginState();
	}
}

state Reload
{
ignores Fire, AltFire;

	function float GetReloadTime()
	{
		local float val;

		val = ReloadTime;

		if (ScriptedPawn(Owner) != None)
		{
			val = ReloadTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
			if (IsA('WeaponAssaultShotgun') || IsA('WeaponSawedOffShotgun'))
			val*=0.22;
			else
			val*=0.52; //GMDX: give them some chance
		}
		else if (DeusExPlayer(Owner) != None)
		{
			// check for skill use if we are the player
			val = GetWeaponSkill();
			val = ReloadTime + (val*ReloadTime);
			if (AmmoType.IsA('AmmoRubber'))
			   val *= 0.75;
		}

		return val;
	}

	function NotifyOwner(bool bStart)
	{
		local DeusExPlayer player;
		local ScriptedPawn pawn;

		player = DeusExPlayer(Owner);
		pawn   = ScriptedPawn(Owner);

		if (player != None)
		{
			if (bStart)
				player.Reloading(self, GetReloadTime()+(1.0/AnimRate));
			else
			{
				player.DoneReloading(self);
			}
		}
		else if (pawn != None)
		{
			if (bStart)
				pawn.Reloading(self, GetReloadTime()+(1.0/AnimRate));
			else
				pawn.DoneReloading(self);
		}
	}

	function LoadShells()
	{
	local float getIt, rnd;

	rnd = FRand();

    if (Owner.IsA('DeusExPlayer'))
       DeusExPlayer(Owner).ShakeView(0.1, 28+28, 0);

	if (rnd < 0.2)
	Owner.PlaySound(sound'GMDXSFX.Weapons.ShellSGLoaded1', SLOT_None,,, 1024);
	else if (rnd < 0.4)
	Owner.PlaySound(sound'GMDXSFX.Weapons.ShellSGLoaded2', SLOT_None,,, 1024);
	else if (rnd < 0.6)
	Owner.PlaySound(sound'GMDXSFX.Weapons.ShellSGLoaded3', SLOT_None,,, 1024);
	else if (rnd < 0.8)
	Owner.PlaySound(sound'GMDXSFX.Weapons.ShellSGLoaded4', SLOT_None,,, 1024);
	else
	Owner.PlaySound(sound'GMDXSFX.Weapons.ShellSGLoaded5', SLOT_None,,, 1024);
	}

Begin:
	FinishAnim();
	// only reload if we have ammo left
	if (AmmoType.AmmoAmount > 0)
	{
		if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
		{
			ClientReload();
			Sleep(GetReloadTime());
			ReadyClientToFire( True );
		}
		else
		{
			bWasZoomed = bZoomed;
			if (bWasZoomed)
				ScopeOff();

			Owner.PlaySound(CockingSound, SLOT_None,,, 1024);		// CockingSound is reloadbegin
//HDTP pistol and rifle (sigh) //CyberP: updated.
if ((DeusExPlayer(Owner) != None) && (IsA('WeaponRifle') || IsA('WeaponPistol')))
{
    PlayAnim('Reload',default.ReloadTime/ReloadTime);
    Sleep(ReloadTime);
    Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);
    FinishAnim();
}
else
    {
            PlayAnim('ReloadBegin');
			NotifyOwner(True);
			FinishAnim();
			LoopAnim('Reload');
			Owner.PlaySound(ReloadMidSound, SLOT_None,,, 1024);   //CyberP: ReloadMidSound is middle of a reload
			if (IsA('WeaponSawedOffShotgun') || IsA('WeaponAssaultShotgun')) //CyberP: load shells one at a time
			{
            while (ClipCount != 0 && AmmoType.AmmoAmount > 0)
			{
			     LoadShells();
			     Sleep(GetReloadTime());
			     ClipCount--;
			     LoadedShells++;
			     if (AmmoType.AmmoAmount < ReloadCount)
			     {
			      if (LoadedShells == AmmoType.AmmoAmount)
                     break;
			     }
			     if (bCancelLoading)
			      break;
			}
            }
            else
			   Sleep(GetReloadTime());
			Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);		// AltFireSound is reloadend
			if(hasAnim('ReloadEnd'))
				PlayAnim('ReloadEnd');
			FinishAnim();
			NotifyOwner(False);
         }
//			if (bWasZoomed)
//				ScopeOn();
            bCancelLoading = False;
            LoadedShells = 0;
            if (!IsA('WeaponSawedOffShotgun') && !IsA('WeaponAssaultShotgun'))
			ClipCount = 0;
		}
	}
	GotoState('Idle');
}

simulated state ClientFiring
{
	simulated function AnimEnd()
	{
		bInProcess = False;

		if (bAutomatic)
		{
			if ((Pawn(Owner).bFire != 0) && (AmmoType.AmmoAmount > 0))
			{
				if (PlayerPawn(Owner) != None)
					ClientReFire(0);
				else
					GotoState('SimFinishFire');
			}
			else
				GotoState('SimFinishFire');
		}
	}
	simulated function float GetSimShotTime()
	{
		local float mult, sTime;

		if (ScriptedPawn(Owner) != None)
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
			}
			sTime = ShotTime * mult;
			return (sTime);
		}
	}
Begin:
	if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
	{
		if (!bAutomatic)
		{
			bFiring = False;
			FinishAnim();
		}
		if (Owner != None)
		{
			if (Owner.IsA('DeusExPlayer'))
			{
				bFiring = False;
				if (DeusExPlayer(Owner).bAutoReload)
				{
					bClientReadyToFire = False;
					bInProcess = False;
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();
					ReloadAmmo();
					GotoState('SimQuickFinish');
				}
				else
				{
					if (bHasMuzzleFlash)
						EraseMuzzleFlashTexture();
					IdleFunction();
					GotoState('SimQuickFinish');
				}
			}
			else if (Owner.IsA('ScriptedPawn'))
			{
				bFiring = False;
			}
		}
		else
		{
			if (bHasMuzzleFlash)
				EraseMuzzleFlashTexture();
			IdleFunction();
			GotoState('SimQuickFinish');
		}
	}
	Sleep(GetSimShotTime());
	if (bAutomatic)
	{
		SimGenerateBullet();
		Goto('Begin');
	}
	bFiring = False;
	FinishAnim();
	bInProcess = False;
Done:
	bInProcess = False;
	bFiring = False;
	SimFinish();
}

simulated state SimQuickFinish
{
Begin:
	if ( IsAnimating() && (AnimSequence == FireAnim[0] || AnimSequence == FireAnim[1]) )
		FinishAnim();

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	bInProcess = False;
	bFiring=False;
}

simulated state SimIdle
{
	function Timer()
	{
		PlayIdleAnim();
	}
Begin:
	bInProcess = False;
	bFiring = False;
	if (!bNearWall)
		PlayAnim('Idle1',,0.1);
	SetTimer(3.0, True);
}


simulated state SimFinishFire
{
Begin:
	FinishAnim();

	if ( PlayerPawn(Owner) != None )
		PlayerPawn(Owner).FinishAnim();

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	bInProcess = False;
	bFiring=False;
	SimFinish();
}

simulated state SimDownweapon
{
ignores Fire, AltFire, ClientFire, ClientReFire;

Begin:
	if ( bWasInFiring )
	{
		if (bHasMuzzleFlash)
			EraseMuzzleFlashTexture();
		FinishAnim();
	}
	bInProcess = False;
	bFiring=False;
	TweenDown();
	FinishAnim();
}

simulated state SimActive
{
Begin:
	if ( bWasInFiring )
	{
		if (bHasMuzzleFlash)
			EraseMuzzleFlashTexture();
		FinishAnim();
	}
	bInProcess = False;
	bFiring=False;
	PlayAnim('Select',1.0,0.0);
	FinishAnim();
	SimFinish();
}

simulated state SimReload
{
ignores Fire, AltFire, ClientFire, ClientReFire;

	simulated function float GetSimReloadTime()
	{
		local float val;

		val = ReloadTime;

		if (ScriptedPawn(Owner) != None)
		{
			val = ReloadTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		}
		else if (DeusExPlayer(Owner) != None)
		{
			// check for skill use if we are the player
			val = GetWeaponSkill();
			val = ReloadTime + (val*ReloadTime);
		}
		return val;
	}
Begin:
	if ( bWasInFiring )
	{
		if (bHasMuzzleFlash)
			EraseMuzzleFlashTexture();
		FinishAnim();
	}
	bInProcess = False;
	bFiring=False;

	bWasZoomed = bZoomed;
	if (bWasZoomed)
		ScopeOff();

	Owner.PlaySound(CockingSound, SLOT_None,,, 1024);		// CockingSound is reloadbegin

    if(hasAnim('ReloadBegin'))
		PlayAnim('ReloadBegin');
	FinishAnim();
	LoopAnim('Reload');
	Sleep(GetSimReloadTime());
	Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);		// AltFireSound is reloadend
	ServerDoneReloading();
	if(HasAnim('ReloadEnd'))
		PlayAnim('ReloadEnd');
	FinishAnim();

	if (bWasZoomed)
		ScopeOn();

	GotoState('SimIdle');
}


state Idle
{
	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);

		return Super.PutDown();
	}

	function AnimEnd()
	{
	}

	function Timer()
	{
		PlayIdleAnim();
	}

Begin:
	bFiring = False;
	ReadyToFire();

	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
	{
	}
	else
	{
		if (!bNearWall && (IsA('WeaponAssaultShotgun') || IsA('WeaponSawedOffShotgun')))
        	PlayAnim('Idle2',,0.1);
        else if (!bNearWall && IsA('WeaponPistol'))
        {
           if (FRand() < 0.5)
              PlayAnim('Idle2',,0.1);
           else
              PlayAnim('Idle1',,0.1);
        }
        else if (!bNearWall)
			PlayAnim('Idle1',,0.1);
		SetTimer(3.0, True);
	}
}

state FlameThrowerOn
{
	function float GetShotTime()
	{
		local float mult, sTime;

		if (ScriptedPawn(Owner) != None)
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
			}
			sTime = ShotTime * mult;
			return (sTime);
		}
	}
Begin:
	if ( (DeusExPlayer(Owner).Health > 0) && bFlameOn && (ClipCount < ReloadCount))
	{
		if (( flameShotCount == 0 ) && (Owner != None))
		{
			PlayerPawn(Owner).PlayFiring();
			PlaySelectiveFiring();
			PlayFiringSound();
			flameShotCount = 6;
		}
		else
			flameShotCount--;

		Sleep( GetShotTime() );
		GenerateBullet();
		goto('Begin');
	}
Done:
	bFlameOn = False;
	GotoState('FinishFire');
}

state Active
{
	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);
		return Super.PutDown();
	}

Begin:
	// Rely on client to fire if we are a multiplayer client

	if ( (Level.NetMode==NM_Standalone) || (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient()) )
		bClientReady = True;
	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
	{
		ClientActive();
		bClientReady = False;
	}

	SetCloak(class'DeusExPlayer'.default.bCloakEnabled,true);//GMDX force cloak

	if (!Owner.IsA('ScriptedPawn'))
		FinishAnim();
	if ( bChangeWeapon )
		GotoState('DownWeapon');

	bWeaponUp = True;
	PlayPostSelect();
	if (!Owner.IsA('ScriptedPawn'))
		FinishAnim();
	// reload the weapon if it's empty and autoreload is true
	if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
	{
		if (Owner.IsA('ScriptedPawn') || ((DeusExPlayer(Owner) != None) && DeusExPlayer(Owner).bAutoReload))
			ReloadAmmo();
	}
	Finish();
}


state DownWeapon
{
ignores Fire, AltFire;

	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);
		return Super.PutDown();
	}

    //CyberP begin
simulated function TweenDown()
{
local DeusExPlayer player;
local float p;

     player = DeusExPlayer(Owner);

     if (player != None)
     p = player.AugmentationSystem.GetAugLevelValue(class'AugCombat');

     if (p < 1.3)
     p = 1.3;
     if (p > 1.3)
     p *= 1.15;

    if (IsA('WeaponNanoSword'))
            PlaySound(sound'GMDXSFX.Weapons.energybladeunequip2',SLOT_None);
        else if (IsA('WeaponProd'))
            PlaySound(sound'GMDXSFX.Weapons.produnequip',SLOT_None);
        else if (IsA('WeaponCombatKnife') || IsA('WeaponSword'))
            PlaySound(sound'GMDXSFX.Weapons.knifeunequip',SLOT_None);

	if ( (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * 0.4 );
	else
	{
		// Have the put away animation play twice as fast in multiplayer
		if ( Level.NetMode != NM_Standalone )
			PlayAnim('Down', 2.0, 0.05);
		else
			PlayAnim('Down', p, 0.02);  //CyberP: 1.0, 0.05
	}
}
 //CyberP end
Begin:
	ScopeOff();

	LaserOff();
    if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bCrosshairVisible && !bLasing)
    DeusExPlayer(Owner).SetCrosshair(true,false); //CyberP:
	if (!class'DeusExPlayer'.default.bRadarTran == True)
    SetCloak(false); //GMDX

	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
		ClientDownWeapon();

    if (Buoyancy==5.123456) //CyberP: dumb hack/avoiding use of global vars
    {
        Buoyancy = 5.000000;
    }
    else
    {
	   TweenDown();
	   FinishAnim();
	}
    bBeginQuickMelee = False;
	if ( Level.NetMode != NM_Standalone )
	{
		ClipCount = 0;	// Auto-reload in multiplayer (when putting away)
	}
	bOnlyOwnerSee = false;
	if (Pawn(Owner) != None)
		Pawn(Owner).ChangedWeapon();
}

// ----------------------------------------------------------------------
// TestMPBeltSpot()
// Returns true if the suggested belt location is ok for the object in mp.
// ----------------------------------------------------------------------

simulated function bool TestMPBeltSpot(int BeltSpot)
{
	return ((BeltSpot <= 3) && (BeltSpot >= 1));
}

defaultproperties
{
     bReadyToFire=True
     LowAmmoWaterMark=10
     FireAnim(0)=Shoot
     FireAnim(1)=Shoot
     NoiseLevel=1.000000
     ShotTime=0.500000
     reloadTime=1.000000
     HitDamage=10
     maxRange=9600
     AccurateRange=4800
     BaseAccuracy=0.500000
     ScopeFOV=20
     MaintainLockTimer=1.000000
     bPenetrating=True
     bHasMuzzleFlash=True
     bEmitWeaponDrawn=True
     bUseWhileCrouched=True
     bUseAsDrawnWeapon=True
     MinSpreadAcc=0.200000
     MinProjSpreadAcc=0.250000
     bNeedToSetMPPickupAmmo=True
     msgCannotBeReloaded="This weapon can't be reloaded"
     msgOutOf="Out of %s"
     msgNowHas="%s now has %s loaded"
     msgAlreadyHas="%s already has %s loaded"
     msgNone="NONE"
     msgLockInvalid="INVALID"
     msgLockRange="RANGE"
     msgLockAcquire="ACQUIRE"
     msgLockLocked="LOCKED"
     msgRangeUnit="FT"
     msgTimeUnit="SEC"
     msgMassUnit="LBS"
     msgNotWorking="This weapon doesn't work underwater"
     msgInfoAmmoLoaded="Ammo loaded:"
     msgInfoAmmo="Ammo type(s):"
     msgInfoDamage="Base damage:"
     msgInfoClip="Clip size:"
     msgInfoReload="Reload time:"
     msgInfoRecoil="Recoil:"
     msgInfoAccuracy="Base Accuracy:"
     msgInfoAccRange="Acc. range:"
     msgInfoMaxRange="Max. range:"
     msgInfoMass="Mass:"
     msgInfoLaser="Laser sight:"
     msgInfoScope="Scope:"
     msgInfoSilencer="Silencer:"
     msgInfoNA="N/A"
     msgInfoYes="YES"
     msgInfoNo="NO"
     msgInfoAuto="AUTO"
     msgInfoSingle="SINGLE"
     msgInfoRounds="RDS"
     msgInfoRoundsPerSec="RDS/SEC"
     msgInfoSkill="Skill:"
     msgInfoWeaponStats="Weapon Stats:"
     FireSilentSound=Sound'DeusExSounds.Weapons.StealthPistolFire'
     RecoilShaker=(X=2.000000,Y=0.500000,Z=0.500000)
     msgInfoROF="Rate of fire:"
     msgInfoFullAuto="Firing Type:"
     negTime=0.765000
     ReloadCount=10
     shakevert=10.000000
     Misc1Sound=Sound'DeusExSounds.Generic.DryFire'
     MuzzleScale=6.000000
     AutoSwitchPriority=0
     bRotatingPickup=False
     PickupMessage="You found"
     ItemName="DEFAULT WEAPON NAME - REPORT THIS AS A BUG"
     BobDamping=0.840000
     LandSound=Sound'DeusExSounds.Generic.DropSmallWeapon'
     bNoSmooth=False
     bCollideWorld=True
     bProjTarget=True
     Mass=10.000000
     Buoyancy=5.000000
}
