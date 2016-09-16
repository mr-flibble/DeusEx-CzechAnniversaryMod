//=============================================================================
// ChargedPickup.
// modded by dasraiser for GMDX : Stackable upto Environ Skill Level
//=============================================================================
class ChargedPickup extends DeusExPickup
	abstract;

var() class<Skill> skillNeeded;
var() bool bOneUseOnly;
var() sound ActivateSound;
var() sound DeactivateSound;
var() sound LoopSound;
var Texture ChargedIcon;
var travel bool bIsActive;
var localized String ChargeRemainingLabel;
var localized String DurabilityRemainingLabel;

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local DeusExPlayer player;
	local String outText;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	player = DeusExPlayer(Owner);

	if (player != None)
	{
		winInfo.SetTitle(itemName);
		winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());
        if (IsA('HazMatSuit') || IsA('BallisticArmor'))
        outText = DurabilityRemainingLabel @ Int(GetCurrentCharge()) $ "%";
        else
		outText = ChargeRemainingLabel @ Int(GetCurrentCharge()) $ "%";
		if (IsA('HazMatSuit'))
		outText = outText $ winInfo.CR() $ "Environmental Protection: 60%";
		else if (IsA('BallisticArmor'))
		outText = outText $ winInfo.CR() $ "Ballistic Protection: 35%";
		if (IsA('AdaptiveArmor') || IsA('Rebreather'))
		outText = outText $ winInfo.CR() $ "Biocell Recharge Amount: 30%";
		else
		outText = outText $ winInfo.CR() $ "Biocell Recharge Amount: 50%";  //CyberP: lazy programming, I know.
		winInfo.AppendText(outText);
	}
	return True;
}

// ----------------------------------------------------------------------
// GetCurrentCharge()
// ----------------------------------------------------------------------

simulated function Float GetCurrentCharge()
{
	return (Float(Charge) / Float(Default.Charge)) * 100.0;
}

// ----------------------------------------------------------------------
// ChargedPickupBegin()
// ----------------------------------------------------------------------

function ChargedPickupBegin(DeusExPlayer Player)
{
	local int DisplayCount;

	Player.AddChargedDisplay(Self);
	PlaySound(ActivateSound, SLOT_None);
	if (LoopSound != None)
		AmbientSound = LoopSound;

	//DEUS_EX AMSD In multiplayer, remove it from the belt if the belt
	//is the only inventory.
	if ((Level.NetMode != NM_Standalone) && (Player.bBeltIsMPInventory))
	{
		if (DeusExRootWindow(Player.rootWindow) != None)
			DeusExRootWindow(Player.rootWindow).DeleteInventory(self);

		bInObjectBelt=False;
		BeltPos=default.BeltPos;
	}
    if (IsA('AdaptiveArmor'))
    class'DeusExPlayer'.default.bCloakEnabled=true;

	bIsActive = True;
}

// ----------------------------------------------------------------------
// ChargedPickupEnd()
// ----------------------------------------------------------------------

function ChargedPickupEnd(DeusExPlayer Player)
{
	Player.RemoveChargedDisplay(Self);
	PlaySound(DeactivateSound, SLOT_None);
	if (LoopSound != None)
		AmbientSound = None;

	// remove it from our inventory if none left
	if (NumCopies<=0)
		Player.DeleteInventory(Self);
	/*else
	{//remove from hands, should really never get here!
		if (player.inHand == Self)
			player.PutInHand(None);
	}  */
    if (IsA('AdaptiveArmor'))
    {
    class'DeusExPlayer'.default.bCloakEnabled=False;
    class'DeusExPlayer'.default.bRadarTran=False;
    }
	bIsActive = False;
}

// ----------------------------------------------------------------------
// IsActive()
// ----------------------------------------------------------------------

simulated function bool IsActive()
{
	return bIsActive;
}

// ----------------------------------------------------------------------
// ChargedPickupUpdate()
// ----------------------------------------------------------------------

function ChargedPickupUpdate(DeusExPlayer Player)
{
}

// ----------------------------------------------------------------------
// CalcChargeDrain()
// ----------------------------------------------------------------------

simulated function int CalcChargeDrain(DeusExPlayer Player)
{
	local float skillValue;
	local float drain;

	drain = 4.0;
	skillValue = 1.0;
	if (skillNeeded != None)
		skillValue = Player.SkillSystem.GetSkillLevelValue(skillNeeded);
	drain *= skillValue;

	return Max(1,Int(drain));
}

// ----------------------------------------------------------------------
// function UsedUp()
//
// copied from Pickup, but modified to keep items from
// automatically switching
// ----------------------------------------------------------------------

function UsedUp()
{
	local DeusExPlayer Player;

	NumCopies--;   //GMDX

	if ( Pawn(Owner) != None )
	{
	    //bActivatable = false;
		Pawn(Owner).ClientMessage(ExpireMessage);
	}
	Owner.PlaySound(DeactivateSound);
	Player = DeusExPlayer(Owner);

	if (Player != None)
	{
		if (Player.inHand == Self)
		{
			ChargedPickupEnd(Player);
		}
	}
	if (NumCopies<=0)
	{

		bActivatable = false;
		Destroy();  //GMDX
	}
	else
	{

		GotoState('DeActivated');
		UpdateBeltText();
		Charge=default.Charge;  //give back charge and make activatable
	}
}

// ----------------------------------------------------------------------
// state DeActivated
// ----------------------------------------------------------------------

state DeActivated
{
}

// ----------------------------------------------------------------------
// state Activated
// ----------------------------------------------------------------------

state Activated
{
	function Timer()
	{
		local DeusExPlayer Player;

		Player = DeusExPlayer(Owner);
		if (Player != None)
		{
			ChargedPickupUpdate(Player);
			if (!IsA('HazMatSuit') && !IsA('BallisticArmor')) //CyberP: start to make new armor system
			Charge -= CalcChargeDrain(Player);
            if (IsA('AdaptiveArmor'))
            class'DeusExPlayer'.default.bCloakEnabled=true;

			if (Charge <= 0)
			{
				UsedUp();
				if (IsA('AdaptiveArmor'))
                 class'DeusExPlayer'.default.bCloakEnabled=False;
			}
		}
	}

	function BeginState()
	{
		local DeusExPlayer Player;
        local ChargedPickup char;
        local int i;
        local string CanOnlyBeOne;

        ForEach AllActors(class'ChargedPickup',char)
           if (char.IsInState('Activated') && (char.IsA('BallisticArmor') || char.IsA('HazMatSuit') || char.IsA('AdaptiveArmor')))
              i++;

        if (i > 1)
        {
           CanOnlyBeOne = "You cannot equip more than one torso armor piece";
           Player = DeusExPlayer(Owner);
          DeusExPlayer(Owner).ClientMessage(CanOnlyBeOne);
          bActive=False;
          ChargedPickupEnd(Player);
          GotoState('DeActivated');
          return;
        }

		Super.BeginState();

		Player = DeusExPlayer(Owner);
		if (Player != None)
		{

			if (player.inHand == Self)
			   player.PutInHand(None);

			//SetOwner(Player);  //CyberP: did I comment this out, and if so, why? :/

			ChargedPickupBegin(Player);
			SetTimer(0.1, True);
		}
	}

	function EndState()
	{
		local DeusExPlayer Player;

		Super.EndState();

		Player = DeusExPlayer(Owner);
		if (Player != None)
		{
			ChargedPickupEnd(Player);
			SetTimer(0.1, False);
		}
	}

	function Activate()
	{
		//do not allow re-activation if no copies or one is active
		//if ((NumCopies<=0)||(bIsActive))
		if (bOneUseOnly)
            return;

		Super.Activate();
	}
}


// --------------------------------------------------------------------
// maxCopies
// by dasraiser for GMDX: return maxcopies and promote var in script to call funcion :)
// ----------------------------------------------------------------------
function int RetMaxCopies()
{
	local DeusExPlayer player;
	local int skval;
	player = DeusExPlayer(Owner);
	skval = Player.SkillSystem.GetSkillLevel(skillNeeded)+1;

	return skval;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
//Charge=2000

defaultproperties
{
     ActivateSound=Sound'DeusExSounds.Pickup.PickupActivate'
     DeActivateSound=Sound'DeusExSounds.Pickup.PickupDeactivate'
     ChargeRemainingLabel="Charge remaining:"
     DurabilityRemainingLabel="Durability:"
     CountLabel="Uses:"
     bCanHaveMultipleCopies=True
     bActivatable=True
     Charge=2000
}
