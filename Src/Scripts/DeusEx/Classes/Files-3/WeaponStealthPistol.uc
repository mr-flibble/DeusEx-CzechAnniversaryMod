//=============================================================================
// WeaponStealthPistol.
//=============================================================================
class WeaponStealthPistol extends DeusExWeapon;

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
	}
}

simulated function renderoverlays(Canvas canvas)
{
    local rotator rfs;
	local vector dx;
	local vector dy;
	local vector dz;
	local vector		DrawOffset, WeaponBob;
	local vector unX,unY,unZ;

	Multiskins[0] = getweaponhandtex();
	Multiskins[1] = none;

	if(bHasScope)
		multiskins[4] = none;
	else
		multiskins[4] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[2] = none;
	else
		multiskins[2] = texture'pinkmasktex';
	if(bLasing)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';

	super.renderoverlays(canvas); //(weapon)

	multiskins[0] = none;

	if(bHasScope)
		multiskins[1] = none;
	else
		multiskins[1] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[2] = none;
	else
		multiskins[2] = texture'pinkmasktex';
	if(bLasing)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	multiskins[4]=none;

	if (activateAn == True)
    {
	if(!bGEPout)
	{
		if (GEPinout<1) GEPinout=Fmin(1.0,GEPinout+0.04);
	} else
		if (GEPinout<1) GEPinout=Fmax(0,GEPinout-0.04);//do Fmax(0,n) @ >0<=1

	rfs.Yaw=2912*Fmin(1.0,GEPinout);
	rfs.Pitch=-62912*sin(Fmin(1.0,GEPinout)*Pi);
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

function CheckWeaponSkins()
{
	multiskins[0]=none;
	if(bHasScope)
		multiskins[1] = none;
	else
		multiskins[1] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[2] = none;
	else
		multiskins[2] = texture'pinkmasktex';

	multiskins[3] = texture'pinkmasktex';
	multiskins[4]=none;
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
     MountedViewOffset=(X=4.000000,Y=3.500000,Z=-45.500000)
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=0.010000
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_All
     bAutomatic=True
     ShotTime=0.586000
     reloadTime=4.000000
     HitDamage=8
     maxRange=4800
     AccurateRange=2400
     BaseAccuracy=0.750000
     bCanHaveScope=True
     ScopeFOV=30
     bCanHaveLaser=True
     AmmoNames(0)=Class'DeusEx.Ammo10mm'
     AmmoNames(1)=Class'DeusEx.Ammo10mmAP'
     recoilStrength=0.215000
     mpReloadTime=1.500000
     mpHitDamage=12
     mpBaseAccuracy=0.200000
     mpAccurateRange=1200
     mpMaxRange=1200
     mpReloadCount=12
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     RecoilShaker=(X=1.500000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     ReloadMidSound=Sound'GMDXSFX.Weapons.9mmBoltOpened1'
     negTime=0.565000
     AmmoName=Class'DeusEx.Ammo10mm'
     ReloadCount=15
     PickupAmmoCount=10
     bInstantHit=True
     FireOffset=(X=-24.000000,Y=10.000000,Z=14.000000)
     shakemag=96.000000
     FireSound=Sound'GMDXSFX.Weapons.USPSilencedFireB'
     AltFireSound=Sound'DeusExSounds.Weapons.StealthPistolReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.StealthPistolReload'
     SelectSound=Sound'DeusExSounds.Weapons.StealthPistolSelect'
     InventoryGroup=3
     ItemName="Stealth Pistol"
     PlayerViewOffset=(X=24.000000,Y=-10.000000,Z=-14.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPStealthPistol'
     BobDamping=0.760000
     PickupViewMesh=LodMesh'HDTPItems.HDTPstealthpistolPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPstealthpistol3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconStealthPistol'
     largeIcon=Texture'DeusExUI.Icons.LargeIconStealthPistol'
     largeIconWidth=47
     largeIconHeight=37
     Description="Designed for wet work, the stealth pistol is manufactured to boast a notably large clip, integrated silencer and recoil compensator. Excels performance-wise in all except raw stopping power."
     beltDescription="STEALTH"
     Mesh=LodMesh'HDTPItems.HDTPstealthpistolPickup'
     CollisionRadius=8.000000
     CollisionHeight=0.800000
}
