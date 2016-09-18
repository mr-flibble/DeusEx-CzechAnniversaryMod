//=============================================================================
// MJ12Commando.
//=============================================================================
class MJ12Commando extends HumanMilitary;

function BeginPlay()
{
local DeusExPlayer player;
if (player !=none && player.bHardCoreMode)
{
   VisibilityThreshold=0.002000;
   Health=default.Health;
   HealthHead=default.HealthHead;
   HealthTorso=default.HealthTorso;
   HealthLegLeft=default.HealthLegLeft;
   HealthLegRight=default.HealthLegRight;
   HealthArmLeft=default.HealthArmLeft;
   HealthArmRight=default.HealthArmRight;
 }
 else
 {
 VisibilityThreshold=0.002000;
 default.Health=350;
 default.HealthHead=350;
 default.HealthTorso=350;
 default.HealthLegLeft=350;
 default.HealthLegRight=350;
 default.HealthArmLeft=350;
 default.HealthArmRight=350;
 Health=350;
 HealthHead=350;
 HealthTorso=350;
 HealthLegLeft=350;
 HealthLegRight=350;
 HealthArmLeft=350;
 HealthArmRight=350;
 }
   Super.BeginPlay();
}

function PostBeginPlay()
{
   local DeusExPlayer player;
if (player !=none && player.bHardCoreMode)
{
   VisibilityThreshold=0.002000;
   Health=default.Health;
   HealthHead=default.HealthHead;
   HealthTorso=default.HealthTorso;
   HealthLegLeft=default.HealthLegLeft;
   HealthLegRight=default.HealthLegRight;
   HealthArmLeft=default.HealthArmLeft;
   HealthArmRight=default.HealthArmRight;
 }
 else
 {
 VisibilityThreshold=0.002000;
 default.Health=350;
 default.HealthHead=350;
 default.HealthTorso=350;
 default.HealthLegLeft=350;
 default.HealthLegRight=350;
 default.HealthArmLeft=350;
 default.HealthArmRight=350;
 Health=350;
 HealthHead=350;
 HealthTorso=350;
 HealthLegLeft=350;
 HealthLegRight=350;
 HealthArmLeft=350;
 HealthArmRight=350;
 }
   Super.PostBeginPlay();
}

function Bool HasTwoHandedWeapon()
{
	return False;
}

function PlayReloadBegin()
{
	TweenAnimPivot('Shoot', 0.1);
}

function PlayReload()
{
}

function PlayReloadEnd()
{
}

function PlayIdle()
{
}

function TweenToShoot(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('TreadShoot', tweentime, GetSwimPivot());
	else if (!bCrouching)
		TweenAnimPivot('Shoot2', tweentime);
}

function PlayShoot()
{
	if (Region.Zone.bWaterZone)
		PlayAnimPivot('TreadShoot', , 0, GetSwimPivot());
	else
		PlayAnimPivot('Shoot2', , 0);
}

function bool IgnoreDamageType(Name damageType)
{
	if ((damageType == 'TearGas') || (damageType == 'PoisonGas'))
		return True;
	else
		return False;
}

function float ShieldDamage(Name damageType)
{
	if (IgnoreDamageType(damageType))
		return 0.0;
	else if ((damageType == 'Burned') || (damageType == 'Flamed'))
		return 0.5;
	else if ((damageType == 'Poison') || (damageType == 'PoisonEffect'))
		return 0.5;
	else
		return Super.ShieldDamage(damageType);
}


function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if (!IgnoreDamageType(damageType) && CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

defaultproperties
{
     MinHealth=0.000000
     CarcassType=Class'DeusEx.MJ12CommandoCarcass'
     WalkingSpeed=0.296000
     bCanCrouch=False
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponMJ12Commando')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=24)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponMJ12Rocket')
     InitialInventory(3)=(Inventory=Class'DeusEx.AmmoRocketMini',Count=10)
     BurnPeriod=0.000000
     GroundSpeed=240.000000
     Health=450
     HealthHead=450
     HealthTorso=450
     HealthLegLeft=450
     HealthLegRight=450
     HealthArmLeft=450
     HealthArmRight=450
     Mesh=LodMesh'DeusExCharacters.GM_ScaryTroop'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.MJ12CommandoTex1'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.MJ12CommandoTex1'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.MJ12CommandoTex0'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.MJ12CommandoTex1'
     CollisionRadius=28.000000
     CollisionHeight=49.880001
     BindName="MJ12Commando"
     FamiliarName="MJ12 Commando"
     UnfamiliarName="MJ12 Commando"
}
