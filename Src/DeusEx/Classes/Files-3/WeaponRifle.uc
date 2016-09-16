//=============================================================================
// WeaponRifle.
//=============================================================================
class WeaponRifle extends DeusExWeapon;

var float	mpNoScopeMult;
var DeusExPlayer player;
var vector axesX;//fucking weapon rotation fix
var vector axesY;
var vector axesZ;
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
	  multiskins[4] = none;
	else
	  multiskins[4] = texture'pinkmasktex';
	if(bHasLaser)
	  multiskins[3] = none;
	else
	  multiskins[3] = texture'pinkmasktex';

	multiskins[6] = Getweaponhandtex();

	super.renderoverlays(canvas);

	if(bHasSilencer)
	  multiskins[3] = none;
	else
	  multiskins[3] = texture'pinkmasktex';
	if(bHasLaser)
	  multiskins[4] = none;
	else
	  multiskins[4] = texture'pinkmasktex';

	multiskins[6] = none;

    if (activateAn == True)
    {
	if(!bGEPout)
	{
		if (GEPinout<1) GEPinout=Fmin(1.0,GEPinout+0.04);
	} else
		if (GEPinout<1) GEPinout=Fmax(0,GEPinout-0.04);//do Fmax(0,n) @ >0<=1

	rfs.Yaw=6912*Fmin(1.0,GEPinout);
	rfs.Pitch=2912*sin(Fmin(1.0,GEPinout)*Pi);
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

    if (player.PerkNamesArray[12]== 1)
    {
	PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
	PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
	PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout*1.25)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
	}
	else
	{
	PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
	PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
	PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
	}
    //PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);

	//FireOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.X,-MountedViewOffset.X);
	//FireOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.Y,-MountedViewOffset.Y);
	//FireOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.Z,-cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z);

	SetLocation(player.Location+ CalcDrawOffset());
	scopeTime+=1;

	//IsInState('DownWeapon')

    if (player.PerkNamesArray[12]== 1)
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
        SetHand(player.Handedness);
    }
    }
    else if (scopeTime>=25)
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

function CheckWeaponSkins()
{

	if(bHasSilencer)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[4] = none;
	else
		multiskins[4] = texture'pinkmasktex';

}


// Muzzle Flash Stuff
simulated function SwapMuzzleFlashTexture()
{
	 if (!bHasMuzzleFlash)
	 return;
	//if(frand() > 0.5)
		MultiSkins[7] = GetMuzzleTex();
	//else
	//	MultiSkins[7] = Texture'DeusExItems.Skins.FlatFXTex37';

	 MuzzleFlashLight();
	 SetTimer(0.1, False);
}

simulated function texture GetMuzzleTex()
{
	local int i;
	local texture tex;

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
	return tex;
}

simulated function EraseMuzzleFlashTexture()
{
	 MultiSkins[7] = None;
}

simulated function Timer()
{
	 EraseMuzzleFlashTexture();
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Owner != none && Owner.IsA('ScriptedPawn') && !Owner.IsA('PaulDenton'))
    {
    maxRange=48000;
    AccurateRange=24000;
    ShotTime=1.000000;
    BaseAccuracy=0.750000;
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
     mpNoScopeMult=0.350000
     MountedViewOffset=(X=7.000000,Y=-6.800000,Z=-2.500000)
     LowAmmoWaterMark=3
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=10.000000
     EnviroEffective=ENVEFF_Air
     ShotTime=0.700000
     reloadTime=2.000000
     HitDamage=28
     maxRange=10000
     AccurateRange=5000
     BaseAccuracy=0.800000
     bCanHaveScope=True
     bHasScope=True
     ScopeFOV=16
     bCanHaveLaser=True
     bCanHaveSilencer=True
     bHasMuzzleFlash=False
     recoilStrength=1.170000
     bUseWhileCrouched=False
     mpReloadTime=2.000000
     mpHitDamage=25
     mpAccurateRange=28800
     mpMaxRange=28800
     mpReloadCount=6
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     FireSilentSound=Sound'DeusExSounds.Weapons.RifleFire'
     RecoilShaker=(X=3.500000,Y=1.000000,Z=2.000000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     bCanHaveModFullAuto=True
     bExtraShaker=True
     negTime=0.285000
     AmmoName=Class'DeusEx.Ammo3006'
     ReloadCount=5
     PickupAmmoCount=5
     bInstantHit=True
     FireOffset=(X=-20.000000,Y=2.000000,Z=30.000000)
     shakemag=450.000000
     FireSound=Sound'GMDXSFX.Weapons.REV2FIRE'
     AltFireSound=Sound'DeusExSounds.Weapons.RifleReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.RifleReload'
     SelectSound=Sound'DeusExSounds.Weapons.RifleSelect'
     Misc1Sound=Sound'GMDXSFX.Weapons.SniperDryFire'
     InventoryGroup=5
     ItemName="Sniper Rifle"
     PlayerViewOffset=(X=18.000000,Y=-2.000000,Z=-29.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPWeaponRifle'
     PickupViewMesh=LodMesh'HDTPItems.HDTPSniperPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPSniper3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'HDTPItems.HDTPBeltIconRifle'
     largeIcon=Texture'HDTPItems.HDTPLargeIconRifle'
     largeIconWidth=159
     largeIconHeight=47
     invSlotsX=3
     Description="The military sniper rifle is the superior tool for the interdiction of long-range targets. When coupled with the proven 30.06 round, a marksman can achieve tight groupings at better than 1 MOA (minute of angle) depending on environmental conditions."
     beltDescription="SNIPER"
     Texture=Texture'HDTPItems.Skins.HDTPWeaponRifleShine'
     Mesh=LodMesh'HDTPItems.HDTPSniperPickup'
     MultiSkins(3)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=26.000000
     CollisionHeight=2.000000
     Mass=30.000000
}
