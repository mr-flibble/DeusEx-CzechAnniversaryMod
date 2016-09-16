//=============================================================================
// WeaponFlamethrower.
//=============================================================================
class WeaponFlamethrower extends DeusExWeapon;

var int BurnTime, BurnDamage;

var int		mpBurnTime;
var int		mpBurnDamage;
var bool usedammo, genusedammo;

function PostBeginPlay()
{
  super.PostBeginPlay();

  if (!Owner.IsA('DeusExPlayer'))
    FireOffset=vect(30,9,4);
}

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
        largeIcon=Texture'GMDXSFX.Icons.Napalm';
        }
        if (FireSound == None)
        FireSound = Sound'DeusExSounds.Weapons.FlamethrowerFire';
	}
}

simulated function renderoverlays(Canvas canvas)
{
	multiskins[0] = Getweaponhandtex();

	super.renderoverlays(canvas);

	multiskins[0] = none;
}

defaultproperties
{
     burnTime=40
     BurnDamage=10
     mpBurnTime=15
     mpBurnDamage=2
     LowAmmoWaterMark=50
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     EnviroEffective=ENVEFF_Air
     bAutomatic=True
     ShotTime=0.100000
     reloadTime=5.500000
     HitDamage=3
     maxRange=640
     AccurateRange=640
     BaseAccuracy=0.900000
     bHasMuzzleFlash=False
     recoilStrength=0.100000
     mpReloadTime=0.500000
     mpHitDamage=5
     mpBaseAccuracy=0.900000
     mpAccurateRange=320
     mpMaxRange=320
     mpReloadCount=100
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     RecoilShaker=(X=1.000000)
     bCanHaveModDamage=True
     negTime=0.000000
     AmmoName=Class'DeusEx.AmmoNapalm'
     ReloadCount=50
     PickupAmmoCount=50
     FireOffset=(X=60.000000,Y=9.000000,Z=4.000000)
     ProjectileClass=Class'DeusEx.Fireball'
     shakemag=10.000000
     FireSound=Sound'DeusExSounds.Weapons.FlamethrowerFire'
     AltFireSound=Sound'DeusExSounds.Weapons.FlamethrowerReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.FlamethrowerReload'
     SelectSound=Sound'DeusExSounds.Weapons.FlamethrowerSelect'
     InventoryGroup=15
     ItemName="Flamethrower"
     PlayerViewOffset=(X=20.000000,Y=-16.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPFlamethrower'
     PickupViewMesh=LodMesh'HDTPItems.HDTPflamethrowerPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPflamethrower3rd'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconFlamethrower'
     largeIcon=Texture'DeusExUI.Icons.LargeIconFlamethrower'
     largeIconWidth=203
     largeIconHeight=69
     invSlotsX=4
     invSlotsY=2
     Description="A portable flamethrower that discards the old and highly dangerous backpack fuel delivery system in favor of pressurized canisters of napalm. Inexperienced agents will find that a flamethrower can be difficult to maneuver, however."
     beltDescription="FLAMETHWR"
     Mesh=LodMesh'HDTPItems.HDTPflamethrowerPickup'
     CollisionRadius=20.500000
     CollisionHeight=4.400000
     Mass=40.000000
}
