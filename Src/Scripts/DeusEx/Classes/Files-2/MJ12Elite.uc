//=============================================================================
// MJ12Elite.
//=============================================================================
class MJ12Elite extends HumanMilitary;

var float burnAmount;

function PostBeginPlay()
{
    super.PostBeginPlay();

    BurnPeriod = 0.000000;

    if (MultiSkins[6]==Texture'DeusExCharacters.Skins.MJ12TroopTex4')// && Player != None && Player.bDecap && Player.bHDTP_ALL == -1)
         bHasHelmet = True;
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
    super.TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, true);

	if (damageType == 'Flamed') //CyberP: can be set on fire after continual flamed damage.
	{
	burnAmount+=Damage;
	if (burnAmount > 25)
	{
	BurnPeriod = 120.000000;
	super.TakeDamageBase(2, instigatedBy, hitlocation, momentum, 'Flamed', true);
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
      CloakThreshold = 260;
      EnableCloak(True);
      }
      super.BeginState();
	}
   function EndState()
   {
	if (bHasCloak && bCloakOn && Orders != 'Attacking')
	{
      EnableCloak(false);
      CloakThreshold = 80;
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
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if ((damageType == 'TearGas') || (damageType == 'HalonGas'))
	{
	  if (UnfamiliarName == "MJ12 Elite" || bHasCloak)
	     GotoState('RubbingEyes');
	  else
		 GotoNextState();
	}
	else if (damageType == 'Stunned')
		GotoState('Stunned');
	else if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

defaultproperties
{
     maxRange=4096.000000
     MinHealth=0.000000
     WalkingSpeed=0.296000
     SurprisePeriod=0.700000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=24)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     BurnPeriod=120.000000
     bHasCloak=True
     walkAnimMult=0.780000
     runAnimMult=1.100000
     bGrenadier=True
     disturbanceCount=1
     bCanPop=True
     GroundSpeed=250.000000
     Health=350
     HealthHead=350
     HealthTorso=350
     HealthLegLeft=350
     HealthLegRight=350
     HealthArmLeft=350
     HealthArmRight=350
     VisibilityThreshold=0.002000
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_Jumpsuit'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.SkinTex1'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.MJ12TroopTex1'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.MJ12TroopTex2'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.MiscTex1'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.MJ12TroopTex3'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.MJ12TroopTex3'
     MultiSkins(7)=Texture'DeusExCharacters.Skins.MJ12TroopTex3'
     CollisionRadius=20.000000
     CollisionHeight=49.000000
     BindName="MJ12Troop"
     FamiliarName="MJ12 Elite"
     UnfamiliarName="MJ12 Elite"
}
