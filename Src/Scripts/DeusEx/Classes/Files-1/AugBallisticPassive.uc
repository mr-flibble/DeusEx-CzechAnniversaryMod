//=============================================================================
// AugBallisticPassive.
//=============================================================================
class AugBallisticPassive extends AugBallistic;

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
	}
}

defaultproperties
{
     mpAugValue=0.600000
     mpEnergyDrain=90.000000
     EnergyRate=0.000000
     bAlwaysActive=True
     EnergyRateLabel="Energy Rate: 1/8th of Ballistic Damage Recieved"
     AugmentationName="BPN-021 (Passive)"
     Description="Ballistic Protection Nanomachine Prototype 021.|n|nMonomolecular plates permanently reinforce the skin's epithelial membrane, reducing the damage an agent receives from projectiles, blunt weapons and bladed weapons. |n|nThe BPN-021 is the latest development in sub-dermal nanoarmor augmentation research, providing moderate ballistic protection without any user input providing the user has sufficient bioelectical charge. If the user has no bioelectrical charge the BPN-021 is ineffective. |n|nTECH ONE: Damage from projectiles and bladed weapons is reduced slightly (20%). Bioelectric energy is drained by 1/8th of ballistic damage recieved. |n|nTECH TWO: Damage from projectiles and bladed weapons is reduced slightly more (25%).|n|nTECH THREE: Damage from projectiles and bladed weapons is reduced further still (30%).|n|nTECH FOUR: An agent recieves significant passive protection from projectiles and bladed weapons (35%)."
     LevelValues(0)=0.800000
     LevelValues(1)=0.750000
     LevelValues(2)=0.700000
     LevelValues(3)=0.650000
}
