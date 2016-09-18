//=============================================================================
// MJ12Troop.
//=============================================================================
class MJ12Troop extends HumanMilitary;

var float burnAmount;
//GMDX inline hack  //cyberp: it's a big hack, beware!
function PostBeginPlay()
{
    BurnPeriod=0.000000;

    if (Multiskins[6]==Texture'DeusExCharacters.Skins.MJ12TroopTex4')
         bHasHelmet = True;

    if (UnfamiliarName == "MJ12 Elite" || bHasCloak)
    {
        bHasCloak=true;
        runAnimMult=1.100000;
        EnemyTimeout=14.000000;
        SurprisePeriod=0.400000;
    }

    Super.PostBeginPlay();
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
    super.TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, true);

	if (damageType == 'Flamed') //CyberP: can be set on fire after continual flamed damage.
	{
	burnAmount+=Damage;
	if (burnAmount > 8)
	{
	if (UnfamiliarName == "MJ12 Elite" && burnAmount < 25)
	{
	}
	else
	{
	BurnPeriod = 120.000000;
	super.TakeDamageBase(1, instigatedBy, hitlocation, momentum, 'Flamed', true);
	}
	}
	}
}

//CyberP: fairly rarely, upon entering combat an enemy cloaks immediately.
State Attacking
{
   function BeginState()
	{
      if (bHasCloak && FRand() < 0.2 && !bCloakOn)
      {
      bCloakOn = False;
      CloakThreshold = 400;
      EnableCloak(True);
      }
      super.BeginState();
	}
   function EndState()
   {
	if (bHasCloak && bCloakOn && Orders != 'Attacking')
	{
      CloakThreshold = Health*0.4;
      EnableCloak(false);
    }
      super.EndState();
   }
}

function PopHead()
{
MultiSkins[3] = Texture'GMDXSFX.Skins.DoctorTexBeheaded';
MultiSkins[5] = Texture'DeusExItems.Skins.PinkMaskTex';
MultiSkins[6] = Texture'DeusExItems.Skins.PinkMaskTex';
CarcassType = Class'DeusEx.MJ12TroopCarcassBeheaded';
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
if (UnfamiliarName != "MJ12 Elite" || !bHasCloak)
{
 super.GotoDisabledState(damageType,hitPos);
}
else  //MJ12 Elite are immune to halon gas & tear gas
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if ((damageType == 'TearGas') || (damageType == 'HalonGas'))
	{
	  if (UnfamiliarName == "MJ12 Elite" || bHasCloak)
	     GotoNextState();
	  else
		 GotoState('RubbingEyes');
	}
	else if (damageType == 'Stunned')
		GotoState('Stunned');
	else if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}
}

defaultproperties
{
     CarcassType=Class'DeusEx.MJ12TroopCarcass'
     WalkingSpeed=0.296000
     SurprisePeriod=0.700000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=24)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     BurnPeriod=0.000000
     walkAnimMult=0.780000
     bGrenadier=True
     disturbanceCount=1
     bCanPop=True
     GroundSpeed=240.000000
     Health=130
     HealthHead=130
     HealthTorso=130
     HealthLegLeft=130
     HealthLegRight=130
     HealthArmLeft=130
     HealthArmRight=130
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_Jumpsuit'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.SkinTex1'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.MJ12TroopTex1'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.MJ12TroopTex2'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.SkinTex1'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.MJ12TroopTex3'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.MJ12TroopTex4'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=49.000000
     BindName="MJ12Troop"
     FamiliarName="MJ12 Troop"
     UnfamiliarName="MJ12 Troop"
}
