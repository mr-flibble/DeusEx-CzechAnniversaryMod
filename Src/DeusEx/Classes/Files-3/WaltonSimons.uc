//=============================================================================
// WaltonSimons.
//=============================================================================
class WaltonSimons extends HumanMilitary;

//
// Damage type table for Walton Simons:
//
// Shot			- 100%
// Sabot		- 100%
// Exploded		- 100%
// TearGas		- 10%
// PoisonGas	- 10%
// Poison		- 10%
// PoisonEffect	- 10%
// HalonGas		- 10%
// Radiation	- 10%
// Shocked		- 10%
// Stunned		- 0%
// KnockedOut   - 0%
// Flamed		- 0%
// Burned		- 0%
// NanoVirus	- 0%
// EMP			- 0%
//

var bool bBeginCounter;
var float lpa;
var ParticleGenerator whizzBang; //GMDX: special MIB have effect

function float ShieldDamage(name damageType)
{
    if (Health > 400)
        Spawn(class'SphereEffectShield2');
	// handle special damage types
	if ((damageType == 'Flamed') || (damageType == 'Burned') || (damageType == 'Stunned') ||
	    (damageType == 'KnockedOut'))
		return 0.0;
	else if ((damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'HalonGas') ||
			(damageType == 'Radiation') || (damageType == 'Shocked') || (damageType == 'Poison') ||
	        (damageType == 'PoisonEffect'))
		return 0.1;
	else if (damageType == 'Exploded')
        return 0.4;
	else
		return Super.ShieldDamage(damageType);
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}
function ParticleGenState(bool bShow)
{
   if (WhizzBang!=none)
   {
      if(bShow)
      {
         WhizzBang.bSpewing = true; //was true
		   WhizzBang.proxy.bHidden = false;
		   WhizzBang.particleDrawScale = 0.400000;
		   WhizzBang.LifeSpan = WhizzBang.spewTime;
		   if (WhizzBang.bAmbientSound && (WhizzBang.AmbientSound != None))
			   WhizzBang.SoundVolume = 255;
      } else
      {
         WhizzBang.bSpewing = False;
         WhizzBang.proxy.bHidden = True;
         if (WhizzBang.bAmbientSound && (WhizzBang.AmbientSound != None))
            WhizzBang.SoundVolume = 0;
      }
   }
}

event GainedChild(Actor Other)
{
   if(Other.IsA('ParticleGenerator'))
   {
      whizzBang=ParticleGenerator(Other);
      ParticleGenState(false);
   }
   super.GainedChild(Other);
}

event LostChild(Actor Other)
{
   if(Other.IsA('ParticleGenerator'))
   {
      ParticleGenState(false);
      whizzBang=none;
   }
   super.LostChild(Other);
}

State Attacking
{
	function EndState()
	{
	  if (HasEnemyTimedOut())
	  {
	  CloakThreshold = 0;
      EnableCloak(false);
      ParticleGenState(False);
      lpa = 0;
      runAnimMult=default.runAnimMult;
      }
      super.EndState();
	}

	function Tick(float deltaSeconds)
	{
	  super.Tick(deltaSeconds);

	  if (FRand() < 0.001 && bBeginCounter == False)
	  {
	       if (!bCloakOn)
	       {
	          CloakThreshold = Health*2;
	          EnableCloak(True);
	       }
	       else if (CloakThreshold != 0)
	       {
	          CloakThreshold = 0;
              EnableCloak(false);
           }
	  }
	  if (FRand() < 0.001 && !bCloakOn)
	  {
	     GroundSpeed = 1000.000000;
	     bBeginCounter = True;
	     ParticleGenState(true);
	     runAnimMult=1.350000;
	  }
	  else if (bBeginCounter)
	  {
	     lpa +=1;
	     if (lpa > 500)
	     {
	         GroundSpeed = default.GroundSpeed;
	         bBeginCounter = False;
	         ParticleGenState(False);
	         runAnimMult=default.runAnimMult;
	         lpa = 0;
	     }
	  }
	}
}

defaultproperties
{
     CarcassType=Class'DeusEx.WaltonSimonsCarcass'
     WalkingSpeed=0.333333
     bImportant=True
     bInvincible=True
     CloseCombatMult=0.500000
     BaseAssHeight=-23.000000
     BurnPeriod=0.000000
     bHasCloak=True
     CloakThreshold=100
     walkAnimMult=1.400000
     runAnimMult=1.200000
     HDTPMeshName="HDTPCharacters.HDTPWaltonSimons"
     HDTPMeshTex(0)="HDTPCharacters.skins.HDTPSimonsTex0"
     HDTPMeshTex(1)="HDTPCharacters.skins.HDTPSimonsTex1"
     HDTPMeshTex(2)="HDTPCharacters.skins.HDTPSimonsTex2"
     HDTPMeshTex(3)="HDTPCharacters.skins.HDTPSimonsTex3"
     HDTPMeshTex(4)="HDTPCharacters.skins.HDTPSimonsTex4"
     HDTPMeshTex(5)="Deusexitems.skins.pinkmasktex"
     HDTPMeshTex(6)="Deusexitems.skins.pinkmasktex"
     HDTPMeshTex(7)="Deusexitems.skins.pinkmasktex"
     GroundSpeed=330.000000
     Health=1600
     HealthHead=2000
     HealthTorso=1600
     HealthLegLeft=1600
     HealthLegRight=1600
     HealthArmLeft=1600
     HealthArmRight=1600
     Mesh=LodMesh'DeusExCharacters.GM_Trench'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.WaltonSimonsTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.WaltonSimonsTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.PantsTex5'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.WaltonSimonsTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.WaltonSimonsTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.WaltonSimonsTex2'
     MultiSkins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="WaltonSimons"
     FamiliarName="Walton Simons"
     UnfamiliarName="Walton Simons"
}
