//=============================================================================
// WeaponSawedOffShotgun.
//=============================================================================
class WeaponSawedOffShotgun extends DeusExWeapon;

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
		PickupAmmoCount = 12; //to match assaultshotgun
	}
}

simulated function renderoverlays(Canvas canvas)
{
	multiskins[0] = Getweaponhandtex();

	super.renderoverlays(canvas);

	multiskins[0] = none;
}

//
// called from the MESH NOTIFY
//
simulated function SwapMuzzleFlashTexture()
{
	local int i;

	if (!bHasMuzzleFlash)
		return;
	if(playerpawn(owner) != none)      //currently diff meshes, see
		i=2;
	else
		i=1;

	MultiSkins[i] = GetMuzzleTex();

	MuzzleFlashLight();
	SetTimer(0.1, False);
}


simulated function EraseMuzzleFlashTexture()
{
	local int i;

	if(playerpawn(owner) != none)      //currently diff meshes, see
		i=2;
	else
		i=1;
	if(bHasMuzzleflash)
		MultiSkins[i] = None;
}

defaultproperties
{
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=8.000000
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=0.800000
     reloadTime=1.200000
     HitDamage=3
     maxRange=4800
     AccurateRange=2400
     BaseAccuracy=0.600000
     AmmoNames(0)=Class'DeusEx.AmmoShell'
     AmmoNames(1)=Class'DeusEx.AmmoSabot'
     AmmoNames(2)=Class'DeusEx.AmmoRubber'
     ProjectileNames(2)=Class'DeusEx.RubberBullet'
     AreaOfEffect=AOE_Cone
     recoilStrength=1.230000
     mpReloadTime=0.500000
     mpHitDamage=9
     mpBaseAccuracy=0.200000
     mpAccurateRange=1200
     mpMaxRange=1200
     mpReloadCount=6
     mpPickupAmmoCount=12
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     RecoilShaker=(X=3.000000,Y=0.000000,Z=2.000000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     bExtraShaker=True
     negTime=0.325000
     AmmoName=Class'DeusEx.AmmoShell'
     ReloadCount=4
     PickupAmmoCount=4
     bInstantHit=True
     FireOffset=(X=-11.000000,Y=4.000000,Z=13.000000)
     shakemag=600.000000
     FireSound=Sound'GMDXSFX.Weapons.RANGER'
     AltFireSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReload'
     SelectSound=Sound'GMDXSFX.Weapons.ShotgunCock'
     Misc1Sound=Sound'GMDXSFX.Weapons.weapempty'
     InventoryGroup=6
     ItemName="Sawed-off Shotgun"
     PlayerViewOffset=(X=6.000000,Y=2.500000,Z=-8.500000)
     PlayerViewMesh=LodMesh'DeusExItems.Shotgun'
     PickupViewMesh=LodMesh'DeusExItems.ShotgunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Shotgun3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconShotgun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconShotgun'
     largeIconWidth=131
     largeIconHeight=45
     invSlotsX=3
     Description="The sawed-off, pump-action shotgun features a truncated barrel resulting in a wide spread at close range and will accept either buckshot, rubber or sabot shells."
     beltDescription="SAWED-OFF"
     Mesh=LodMesh'DeusExItems.ShotgunPickup'
     CollisionRadius=12.000000
     CollisionHeight=0.900000
     Mass=15.000000
}
