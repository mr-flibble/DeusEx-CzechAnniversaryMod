//=============================================================================
// WeaponRobotPlasmaGun.
//=============================================================================
class WeaponRobotPlasmaGun extends WeaponNPCRanged;

 //fire weapons out of alternating sides
function Fire(float Value)
{
	PlayerViewOffset.Y = -PlayerViewOffset.Y;
	Super.Fire(Value);
}

defaultproperties
{
     ShotTime=0.180000
     HitDamage=20
     AIMinRange=200.000000
     AIMaxRange=4000.000000
     AmmoName=Class'DeusEx.AmmoPlasma'
     PickupAmmoCount=20
     ProjectileClass=Class'DeusEx.PlasmaRobot'
     FireSound=Sound'DeusExSounds.Weapons.HideAGunFire'
     SelectSound=Sound'MoverSFX.door.MachineDoor6'
     PlayerViewOffset=(Y=-46.000000,Z=36.000000)
}
