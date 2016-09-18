//=============================================================================
// WeaponAssaultGun.
//=============================================================================
class WeaponAssaultGun extends DeusExWeapon;

var float	mpRecoilStrength;
var int muznum; //loop through muzzleflashes
var texture muztex; //sigh

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

		// Tuned for advanced -> master skill system (Monte & Ricardo's number) client-side
		recoilStrength = 0.75;
	}
}

/*simulated function ScopeToggle()
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
}*/

simulated function renderoverlays(Canvas canvas)
{
    local rotator rfs;
	local vector dx;
	local vector dy;
	local vector dz;
	local vector		DrawOffset, WeaponBob;
	local vector unX,unY,unZ;

	if(bHasScope)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	if(bHasSilencer)
		multiskins[4] = none;
	else
		multiskins[4] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[1] = none;
	else
		multiskins[1] = texture'pinkmasktex';
	if(bLasing)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';
	//assault gun uses so many differently assigned multiskins we need to keep flicking back between em or we get invisible gunz
	multiskins[0]=none;
	if(muztex != none && multiskins[2] != muztex) //don't overwrite the muzzleflash..this is fucking ugly, but I think we can spare some comp cycles for shit like this
		multiskins[2]=muztex;
	else
		multiskins[2]=none;

	multiskins[6]=none;
	multiskins[7]=Getweaponhandtex();

	super.renderoverlays(canvas); //(weapon)

	if(bHasScope)
		multiskins[6] = none;
	else
		multiskins[6] = texture'pinkmasktex';
	if(bHasSilencer)
		multiskins[2] = none;
	else
		multiskins[2] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';
	if(bLasing)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';

	multiskins[0]=none;
	multiskins[1]=none;
	if(muztex != none && multiskins[4] != muztex) //and here too! Ghaaa
		multiskins[4]=muztex;
	else
		multiskins[4]=none;
	multiskins[7]=none;

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
	PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.2*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
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
  if (Owner != None && Owner.IsA('AnnaNavarre'))
	    bHasSilencer = True;

	if(bHasScope)
		multiskins[6] = none;
	else
		multiskins[6] = texture'pinkmasktex';
	if(bHasSilencer)
		multiskins[2] = none;
	else
		multiskins[2] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';
	if(bLasing)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	multiskins[0]=none;
	multiskins[1]=none;
	multiskins[4]=none;
	multiskins[7]=none;
}

simulated function SwapMuzzleFlashTexture()
{
	local int i;

	if (!bHasMuzzleFlash || bHasSilencer)
		return;

	if(playerpawn(owner) != none)      //diff meshes, see
		i=2;
	else
		i=4;
	Muztex = GetMuzzleTex();
	Multiskins[i] = Muztex;
	MuzzleFlashLight();
	SetTimer(0.1, False);
}

simulated function texture GetMuzzleTex()
{
	local int i;
	local texture tex;

	//i = muznum;
	muznum++;
	if(muznum > 7)
		muznum = 0;
	switch(muznum)
	{
		case 0: tex = texture'ef_HitMuzzle001'; break;//tex = texture'HDTPMuzzleflashlarge1'; break;
		case 1: tex = texture'ef_HitMuzzle002'; break;//tex = texture'HDTPMuzzleflashlarge2'; break;
		case 2: tex = texture'ef_HitMuzzle003'; break;//tex = texture'HDTPMuzzleflashlarge3'; break;
		case 3: tex = texture'ef_HitMuzzle001'; break;//tex = texture'HDTPMuzzleflashlarge4'; break;
		case 4: tex = texture'ef_HitMuzzle002'; break;//tex = texture'HDTPMuzzleflashlarge5'; break;
		case 5: tex = texture'ef_HitMuzzle003'; break;//tex = texture'HDTPMuzzleflashlarge6'; break;
		case 6: tex = texture'ef_HitMuzzle001'; break;//tex = texture'HDTPMuzzleflashlarge7'; break;
		case 7: tex = texture'ef_HitMuzzle002'; break;//tex = texture'HDTPMuzzleflashlarge8'; break;
	}
	return tex;
}

simulated function EraseMuzzleFlashTexture()
{
	local int i;

	Muztex = none; //put this before the silencer check just in case we somehow add a silencer while mid shooting (it could happen!)
	if(!bHasMuzzleflash || bHasSilencer)
		return;

	if(playerpawn(owner) != none)      //diff meshes, see
		i=2;
	else
		i=4;

	MultiSkins[i] = None;
}
/*
//uses actual 5-shot silencer sound now, so as to be less stupid
simulated function PlayFiringSound()
{
	if (bHasSilencer)
		PlaySimSound( Sound'HDTPItems.weapons.AssaultSilenced', SLOT_None, TransientSoundVolume, 2048 );
	else
	{
		// The sniper rifle sound is heard to it's range in multiplayer
		if ( ( Level.NetMode != NM_Standalone ) &&  Self.IsA('WeaponRifle') )
			PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, class'WeaponRifle'.Default.mpMaxRange );
		else
			PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, 2048 );
	}
	UpdateRecoilShaker();
}
*/

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
     MountedViewOffset=(X=2.000000,Y=-2.100000,Z=10.500000)
     LowAmmoWaterMark=16
     FireAnim(1)=None
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=7.000000
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     bAutomatic=True
     ShotTime=0.100000
     reloadTime=3.500000
     HitDamage=3
     BaseAccuracy=0.700000
     bCanHaveScope=True
     ScopeFOV=40
     bCanHaveLaser=True
     bCanHaveSilencer=True
     AmmoNames(0)=Class'DeusEx.Ammo762mm'
     AmmoNames(1)=Class'DeusEx.Ammo20mm'
     AmmoNames(2)=Class'DeusEx.Ammo20mmEMP'
     ProjectileNames(1)=Class'DeusEx.HECannister20mm'
     ProjectileNames(2)=Class'DeusEx.SpiderConstructorLaunched2'
     recoilStrength=0.164000
     MinWeaponAcc=0.200000
     mpReloadTime=0.500000
     mpHitDamage=9
     mpBaseAccuracy=1.000000
     mpAccurateRange=2400
     mpMaxRange=2400
     mpReloadCount=30
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     FireSilentSound=Sound'GMDXSFX.Weapons.MP5FireSil'
     RecoilShaker=(X=1.250000,Y=0.000000,Z=0.250000)
     bCanHaveModDamage=True
     ReloadMidSound=Sound'GMDXSFX.Weapons.MP5_MagIn1'
     negTime=0.000000
     ironSightLoc=(X=12.500000,Y=3.300000,Z=-10.900000)
     AmmoName=Class'DeusEx.Ammo762mm'
     ReloadCount=35
     PickupAmmoCount=35
     bInstantHit=True
     FireOffset=(X=-16.000000,Y=5.000000,Z=11.500000)
     shakemag=240.000000
     FireSound=Sound'GMDXSFX.Weapons.MP5Fire2burst'
     AltFireSound=Sound'GMDXSFX.Weapons.M4ClipIn'
     CockingSound=Sound'GMDXSFX.Weapons.M4ClipOut'
     SelectSound=Sound'GMDXSFX.Weapons.famasselect'
     Misc1Sound=Sound'GMDXSFX.Weapons.G36DryFire'
     InventoryGroup=4
     ItemName="Assault Rifle"
     ItemArticle="an"
     PlayerViewOffset=(X=12.500000,Y=-5.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPAssaultGun'
     PickupViewMesh=LodMesh'HDTPItems.HDTPassaultGunPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPassaultGun3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconAssaultGun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAssaultGun'
     largeIconWidth=94
     largeIconHeight=65
     invSlotsX=2
     invSlotsY=2
     Description="The 7.62x51mm assault rifle is designed for close-quarters combat, utilizing a shortened barrel and 'bullpup' design for increased maneuverability. An additional underhand 20mm HE launcher increases the rifle's effectiveness against a variety of targets."
     beltDescription="ASSAULT"
     Mesh=LodMesh'HDTPItems.HDTPassaultGunPickup'
     CollisionRadius=15.000000
     CollisionHeight=1.100000
     Mass=30.000000
}
