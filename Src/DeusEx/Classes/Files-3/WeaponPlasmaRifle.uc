//=============================================================================
// WeaponPlasmaRifle.
//=============================================================================
class WeaponPlasmaRifle extends DeusExWeapon;

simulated function Tick(float deltaTime)
{
super.Tick(deltaTime);

    if (Owner == None || !Owner.IsA('DeusExPlayer'))
    return;
    else if (Owner.IsA('DeusExPlayer'))
	{
	  if (largeIconHeight!=34 && DeusExPlayer(Owner).PerkNamesArray[24]==1)
	    {
        invSlotsX=3;
        invSlotsY=1;
        largeIconWidth=101;
        largeIconHeight=34;
        largeIcon=Texture'GMDXSFX.Icons.Plasma';
        }
	}
}

simulated function renderoverlays(Canvas canvas)
{
	if(bHasScope)
		multiskins[6] = none;
	else
		multiskins[6] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[4] = none;
	else
		multiskins[4] = texture'pinkmasktex';
	if(bLasing)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';

	//hah! Multiskins 3 wasn't autoresetting, of course, so you only got green when a laser was installed -_-
	multiskins[3]=none;

	super.renderoverlays(canvas);

	if(bHasScope)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	if(bLasing)
		multiskins[4] = none;
	else
		multiskins[4] = texture'pinkmasktex';

}

function CheckWeaponSkins()
{
	if(bHasScope)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	if(bLasing)
		multiskins[4] = none;
	else
		multiskins[4] = texture'pinkmasktex';
}

defaultproperties
{
     LowAmmoWaterMark=12
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     NoiseLevel=8.000000
     EnviroEffective=ENVEFF_AirVacuum
     reloadTime=3.000000
     HitDamage=20
     maxRange=24000
     AccurateRange=14400
     BaseAccuracy=0.700000
     bCanHaveScope=True
     ScopeFOV=30
     bCanHaveLaser=True
     AmmoNames(0)=Class'DeusEx.AmmoPlasma'
     ProjectileNames(0)=Class'DeusEx.PlasmaBolt'
     AreaOfEffect=AOE_Cone
     bHasMuzzleFlash=False
     recoilStrength=0.800000
     mpReloadTime=0.500000
     mpHitDamage=20
     mpBaseAccuracy=0.500000
     mpAccurateRange=8000
     mpMaxRange=8000
     mpReloadCount=12
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     RecoilShaker=(X=1.500000,Y=0.000000,Z=1.000000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     bCanHaveModFullAuto=True
     bExtraShaker=True
     ReloadMidSound=Sound'GMDXSFX.Weapons.Optiwand_ScreenExtended1'
     negTime=0.465000
     AmmoName=Class'DeusEx.AmmoPlasma'
     ReloadCount=12
     PickupAmmoCount=12
     ProjectileClass=Class'DeusEx.PlasmaBolt'
     shakemag=800.000000
     AltFireSound=Sound'DeusExSounds.Weapons.PlasmaRifleReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.PlasmaRifleReload'
     SelectSound=Sound'DeusExSounds.Weapons.PlasmaRifleSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.PlasmaRifleReloadEnd'
     InventoryGroup=8
     ItemName="Plasma Rifle"
     PlayerViewOffset=(X=18.000000,Z=-7.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPPlasmaRifle'
     PickupViewMesh=LodMesh'HDTPItems.HDTPplasmariflePickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPplasmarifle3rd'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconPlasmaRifle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconPlasmaRifle'
     largeIconWidth=203
     largeIconHeight=66
     invSlotsX=4
     invSlotsY=2
     Description="An experimental weapon that is currently being produced as a series of one-off prototypes, the plasma gun superheats slugs of magnetically-doped plastic and accelerates the resulting gas-liquid mix using an array of linear magnets. The resulting plasma stream is deadly when used against slow-moving targets."
     beltDescription="PLASMA"
     Mesh=LodMesh'HDTPItems.HDTPplasmariflePickup'
     CollisionRadius=15.600000
     CollisionHeight=5.200000
     Mass=50.000000
}
