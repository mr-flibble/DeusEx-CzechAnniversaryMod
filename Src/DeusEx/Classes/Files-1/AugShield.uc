//=============================================================================
// AugShield.
//=============================================================================
class AugShield extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
}

function Deactivate()
{
	Super.Deactivate();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
      AugmentationLocation = LOC_Arm;
	}
}

defaultproperties
{
     mpAugValue=0.500000
     mpEnergyDrain=25.000000
     EnergyRate=0.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconShield'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconShield_Small'
     bAlwaysActive=True
     AugmentationName="Energy Shield (Passive)"
     Description="Polyanilene capacitors below the skin absorb heat and electricity, reducing the damage received from flame, electrical, and plasma attacks.|n|nTECH ONE: Damage from energy attacks is reduced slightly.|n|nTECH TWO: Damage from energy attacks is reduced moderately.|n|nTECH THREE: Damage from energy attacks is reduced significantly.|n|nTECH FOUR: Nanobots assemble a charged plasma shield around the body rendering an agent nearly invulnerable to damage from energy attacks."
     MPInfo="When active, you only take 50% damage from flame and plasma attacks.  Energy Drain: Low"
     LevelValues(0)=0.900000
     LevelValues(1)=0.800000
     LevelValues(2)=0.700000
     LevelValues(3)=0.300000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=1
}
