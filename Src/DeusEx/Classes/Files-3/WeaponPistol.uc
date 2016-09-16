//=============================================================================
// WeaponPistol.
//=============================================================================
class WeaponPistol extends DeusExWeapon;

var vector axesX;//fucking weapon rotation fix
var vector axesY;
var vector axesZ;
var DeusExPlayer player;
var bool bFlipFlopCanvas;
var bool bGEPjit;
var float GEPinout;
var bool bGEPout;
var vector MountedViewOffset;
var float scopeTime;

simulated function renderoverlays(Canvas canvas)
{
    local rotator rfs;
	local vector dx;
	local vector dy;
	local vector dz;
	local vector		DrawOffset, WeaponBob;
	local vector unX,unY,unZ;

	if(bHasSilencer)
	  multiskins[6] = none;
	else
	  multiskins[6] = texture'pinkmasktex';
	if(bHasLaser)
	  multiskins[5] = none;
	else
	  multiskins[5] = texture'pinkmasktex';
	if(bHasScope)
	  multiskins[4] = none;
	else
	  multiskins[4] = texture'pinkmasktex';

	multiskins[2] = Getweaponhandtex();

	super.renderoverlays(canvas);

	multiskins[2] = none;

	if (activateAn == True)
    {
	if(!bGEPout)
	{
		if (GEPinout<1) GEPinout=Fmin(1.0,GEPinout+0.04);
	} else
		if (GEPinout<1) GEPinout=Fmax(0,GEPinout-0.04);//do Fmax(0,n) @ >0<=1

	rfs.Yaw=-6912*Fmin(1.0,GEPinout);
	rfs.Pitch=-2912*sin(Fmin(1.0,GEPinout)*Pi);
	GetAxes(rfs,axesX,axesY,axesZ);
/*
	if(!bStaticFreeze)
	{
*/
    player = DeusExPlayer(Owner);

	dx=axesX>>player.ViewRotation;
	dy=axesY>>player.ViewRotation;
	dz=axesZ>>player.ViewRotation;
	rfs=OrthoRotation(dx,dy,dz);

	SetRotation(rfs);

	PlayerViewOffset=Default.PlayerViewOffset*100;//meh
	SetHand(player.Handedness); //meh meh

    //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkNamesArray[12]== 1)
    //{
	PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
	PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
	PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout*1.25)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
	//}
	//else
	//{
	//PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
	//PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
	//PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
	//}
    //PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);

	//FireOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.X,-MountedViewOffset.X);
	//FireOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.Y,-MountedViewOffset.Y);
	//FireOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.Z,-cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z);

	SetLocation(player.Location+ CalcDrawOffset());
	scopeTime+=1;

	//IsInState('DownWeapon')
    /*
    if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkNamesArray[12]== 1)
    {
	if (scopeTime>=17)
	{
        activateAn = False;
        scopeTime = 0;
        ScopeToggle();
        GEPinout = 0;
        axesX = vect(0,0,0);
        axesY = vect(0,0,0);
        axesZ = vect(0,0,0);
        PlayerViewOffset=Default.PlayerViewOffset*100;
        SetHand(PlayerPawn(Owner).Handedness);
    }
    }  */
    if (scopeTime>=18)
    {
        activateAn = False;
        scopeTime = 0;
        ScopeToggle();
        GEPinout = 0;
        axesX = vect(0,0,0);
        axesY = vect(0,0,0);
        axesZ = vect(0,0,0);
        PlayerViewOffset=Default.PlayerViewOffset*100;
        SetHand(player.Handedness);
    }
    }

}

function BecomePickup()
{
	activateAn = False;
        scopeTime = 0;
        GEPinout = 0;
        axesX = vect(0,0,0);
        axesY = vect(0,0,0);
        axesZ = vect(0,0,0);
        PlayerViewOffset=Default.PlayerViewOffset*100;

	super.BecomePickup();
}

simulated function ScopeToggle()
{
	if (bHasScope)
	{
	ScopeFOV=40;
	super.ScopeToggle();
	}
	else if (ScopeFOV==41)
	{
    ScopeFOV=40;
    }
    else
    {
    ScopeFOV=41;
    }
}

function CheckWeaponSkins()
{
	if(bHasSilencer)
	  multiskins[6] = none;
	else
	  multiskins[6] = texture'pinkmasktex';
	if(bHasLaser)
	  multiskins[5] = none;
	else
	  multiskins[5] = texture'pinkmasktex';
	if(bHasScope)
	  multiskins[4] = none;
	else
	  multiskins[4] = texture'pinkmasktex';
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		HitDamage = mpHitDamage;
		BaseAccuracy = mpBaseAccuracy;
		ReloadTime = mpReloadTime;
		AccurateRange = mpAccurateRange;
		MaxRange = mpMaxRange;
		ReloadCount = mpReloadCount;
	}
}

// Muzzle Flash Stuff
simulated function SwapMuzzleFlashTexture()
{
	if (!bHasMuzzleFlash || bHasSilencer)
	{
		if(bLasing)
		{
			MultiSkins[3] = texture'HDTPGlockTex4';
			setTimer(0.1, false);
		}
		return;
	}



	//if (FRand() < 0.5)
		MultiSkins[3] = GetMuzzleTex();
	//else
	//	MultiSkins[3] = Texture'FlatFXTex37';

	 MuzzleFlashLight();
	 SetTimer(0.1, False);
}

simulated function EraseMuzzleFlashTexture()
{
	if(!bLasing)
		MultiSkins[3] = none;
	else
		MultiSkins[3] = texture'HDTPGlockTex4';

}

simulated function Timer()
{
	 EraseMuzzleFlashTexture();
}

function PistolLaserOn()
{
	if (bHasLaser && !bLasing)
	{
		// if we don't have an emitter, then spawn one
		// otherwise, just turn it on
		if (Emitter == None)
		{
			Emitter = Spawn(class'LaserEmitter', Self, , Location, Pawn(Owner).ViewRotation);
			if (Emitter != None)
			{
				Emitter.SetHiddenBeam(True);
				Emitter.AmbientSound = None;
				Emitter.TurnOn();
			}
		}
		else
			Emitter.TurnOn();
			Owner.PlaySound(sound'KeyboardClick3', SLOT_None,,, 1024,1.5);

		Multiskins[3] = texture'HDTPGlockTex4';

		bLasing = True;
	}
}

function PistolLaserOff()
{
	if (bHasLaser && bLasing)
	{
		if (Emitter != None)
			Emitter.TurnOff();
            Owner.PlaySound(sound'KeyboardClick2', SLOT_Misc,,, 1024,1.5);
		Multiskins[3] = none;

		bLasing = False;
	}
}


simulated function MuzzleFlashLight()
{
	 local Vector offset, X, Y, Z;
	 local Effects flash;

	  if (!bHasMuzzleFlash || bHasSilencer)
		  return;

	 if ((flash != None) && !flash.bDeleteMe)
		  flash.LifeSpan = flash.Default.LifeSpan;
	 else
	 {
		  GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
		  offset = Owner.Location;
		  offset += X * Owner.CollisionRadius * 2;
		  flash = spawn(class'Muzzleflash',,, offset);
		  if (flash != None)
			   flash.SetBase(Owner);
	 }
}

state DownWeapon
{
	function EndState()
	{
	    Super.EndState();
	    activateAn = False;
        scopeTime = 0;
        GEPinout = 0;
        axesX = vect(0,0,0);
        axesY = vect(0,0,0);
        axesZ = vect(0,0,0);
        PlayerViewOffset=Default.PlayerViewOffset*100;
        if (Owner.IsA('DeusExPlayer'))
        SetHand(DeusExPlayer(Owner).Handedness);
	}
}

defaultproperties
{
     MountedViewOffset=(X=0.500000,Y=-8.100000,Z=-110.500000)
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=6.000000
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=0.320000
     reloadTime=2.000000
     HitDamage=11
     maxRange=4000
     AccurateRange=2000
     BaseAccuracy=0.700000
     bCanHaveScope=True
     ScopeFOV=40
     bCanHaveLaser=True
     bCanHaveSilencer=True
     AmmoNames(0)=Class'DeusEx.Ammo10mm'
     AmmoNames(1)=Class'DeusEx.Ammo10mmAP'
     recoilStrength=0.625000
     mpReloadTime=2.000000
     mpHitDamage=20
     mpBaseAccuracy=0.200000
     mpAccurateRange=1200
     mpMaxRange=1200
     mpReloadCount=9
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     FireSilentSound=Sound'GMDXSFX.Weapons.USPSilencedFireB'
     RecoilShaker=(X=2.500000,Y=1.000000,Z=1.500000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     negTime=0.565000
     AmmoName=Class'DeusEx.Ammo10mm'
     ReloadCount=8
     PickupAmmoCount=8
     bInstantHit=True
     FireOffset=(X=-22.000000,Y=10.000000,Z=14.000000)
     shakemag=440.000000
     FireSound=Sound'GMDXSFX.Weapons.GlockFire'
     AltFireSound=Sound'GMDXSFX.Weapons.M4ClipOut'
     CockingSound=Sound'DeusExSounds.Weapons.PistolReload'
     SelectSound=Sound'DeusExSounds.Weapons.PistolSelect'
     InventoryGroup=2
     ItemName="Pistol"
     PlayerViewOffset=(X=22.000000,Y=-10.000000,Z=-14.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPWeaponPistol'
     BobDamping=0.640000
     PickupViewMesh=LodMesh'HDTPItems.HDTPGlockPickUp'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPGlock3rd'
     Icon=Texture'HDTPItems.HDTPBeltIconPistol'
     largeIcon=Texture'HDTPItems.HDTPLargeIconPistol'
     largeIconWidth=46
     largeIconHeight=28
     Description="A standard 10mm pistol."
     beltDescription="PISTOL"
     Mesh=LodMesh'HDTPItems.HDTPGlockPickUp'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(6)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=7.000000
     CollisionHeight=1.000000
}
