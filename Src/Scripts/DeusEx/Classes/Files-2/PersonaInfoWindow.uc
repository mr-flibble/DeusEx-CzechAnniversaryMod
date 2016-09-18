//=============================================================================
// PersonaInfoWindow
//=============================================================================

class PersonaInfoWindow expands PersonaBaseWindow;

var PersonaScrollAreaWindow      winScroll;
var TileWindow                   winTile;
var PersonaHeaderTextWindow      winTitle;
var PersonaNormalLargeTextWindow winText;			// Last text

var int textVerticalOffset;

var PersonaActionButtonWindow buttonUpgrade; //CyberP: perks
var PersonaActionButtonWindow buttonUpgrade2; //CyberP: perks
var PersonaActionButtonWindow buttonUpgrade3; //CyberP: perks
var localized String UpgradeButtonLabel; //CyberP:
var PersonaButtonBarWindow winActionButtons;
var PersonaButtonBarWindow winActionButtons2;
var PersonaButtonBarWindow winActionButtons3;
var localized String PassedSkillName;
// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateControls();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winTitle = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winTitle.SetTextMargins(2, 1);

	winScroll = PersonaScrollAreaWindow(NewChild(Class'PersonaScrollAreaWindow'));

	winTile = TileWindow(winScroll.ClipWindow.NewChild(Class'TileWindow'));
	winTile.SetOrder(ORDER_Down);
	winTile.SetChildAlignments(HALIGN_Full, VALIGN_Top);
	winTile.MakeWidthsEqual(True);
	winTile.MakeHeightsEqual(False);
	winTile.SetMargins(4, 1);
	winTile.SetMinorSpacing(0);
	winTile.SetWindowAlignments(HALIGN_Full, VALIGN_Top);
}

//////////////////////////////////////////////////
//  //CyberP: CreatePerkButtons
//////////////////////////////////////////////////
function CreatePerkButtons(string PerkInfo, string PerkInfo2, string PerkInfo3, int Costs, int Costs2, int Costs3,
string pName, string pName2, string pName3)
{
    local string LineBreaker;
    local string RequiredPoints;
    local string PerkTitle;
    local string ob;
    local int i;

    RequiredPoints="Points Needed: ";
    LineBreaker="------------------------------------------";
    PerkTitle="PERKS";
    ob="OBTAINED PERKS";

    AddLine();
    SetText(PerkTitle);
    AddLine();

    if (Costs != 0)
    {
    SetText(pName);
    SetText(PerkInfo);
    SetText(RequiredPoints $ Costs);
	winActionButtons = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetWidth(32); //149
	winActionButtons.FillAllSpace(False);
	buttonUpgrade = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	buttonUpgrade.SetButtonText(UpgradeButtonLabel);
	buttonUpgrade.PerkNamed=pName;
	buttonUpgrade.PerkSkillCost=Costs;
	if (Player.SkillPointsAvail < Costs)
	buttonUpgrade.SetSensitivity(False);
    AddLine();
    }

    if (Costs2 != 0)
    {
    SetText(pName2);
    SetText(PerkInfo2);
    SetText(RequiredPoints $ Costs2);
	winActionButtons2 = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons2.SetWidth(32); //149
	winActionButtons2.FillAllSpace(False);
	buttonUpgrade2 = PersonaActionButtonWindow(winActionButtons2.NewChild(Class'PersonaActionButtonWindow'));
	buttonUpgrade2.SetButtonText(UpgradeButtonLabel);
	buttonUpgrade2.PerkNamed2=pName2;
	buttonUpgrade2.PerkSkillCost2=Costs2;
	if (Player.SkillPointsAvail < Costs2)
	buttonUpgrade2.SetSensitivity(False);
    AddLine();
    }
    if (Costs3 != 0)
    {
    SetText(pName3);
    SetText(PerkInfo3);
    SetText(RequiredPoints $ Costs3);
	winActionButtons3 = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons3.SetWidth(32); //149
	winActionButtons3.FillAllSpace(False);
	buttonUpgrade3 = PersonaActionButtonWindow(winActionButtons3.NewChild(Class'PersonaActionButtonWindow'));
	buttonUpgrade3.SetButtonText(UpgradeButtonLabel);
	buttonUpgrade3.PerkNamed3=pName3;
	buttonUpgrade3.PerkSkillCost3=Costs3;
	if (Player.SkillPointsAvail < Costs3)
	buttonUpgrade3.SetSensitivity(False);
	AddLine();
	}

	switch(PassedSkillName)
	{
            case "Stealth":
			    if ((Player.SkillSystem.GetSkillLevel(class'SkillStealth') < 1 || Player.PerkNamesArray[9] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillStealth') < 2 || Player.PerkNamesArray[18] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillStealth') < 3 || Player.PerkNamesArray[29] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

            case "Athletics":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillSwimming') < 1 || Player.PerkNamesArray[5] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillSwimming') < 2 || Player.PerkNamesArray[17] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillSwimming') < 3 || Player.PerkNamesArray[27] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "Electronics":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillTech') < 1  || Player.PerkNamesArray[10] == 1)&& Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillTech') < 2 || Player.PerkNamesArray[16] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillTech') < 3 || Player.PerkNamesArray[31] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "Weapons: Heavy":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponHeavy') < 1 || Player.PerkNamesArray[3] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponHeavy') < 2 || Player.PerkNamesArray[13] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponHeavy') < 3 || Player.PerkNamesArray[24] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "Weapons: Low-Tech":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponLowTech') < 1 || Player.PerkNamesArray[4] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponLowTech') < 2 || Player.PerkNamesArray[14] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponLowTech') < 3 || Player.PerkNamesArray[25] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "Weapons: Pistol":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponPistol') < 1 || Player.PerkNamesArray[1] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponPistol') < 2 || Player.PerkNamesArray[11] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponPistol') < 3 || Player.PerkNamesArray[22] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "Weapons: Rifle":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponRifle') < 1 || Player.PerkNamesArray[2] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponRifle') < 2 || Player.PerkNamesArray[12] == 1)&& Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponRifle') < 3 || Player.PerkNamesArray[23] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "Weapons: Demolition":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillDemolition') < 1 || Player.PerkNamesArray[0] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillDemolition') < 2 || Player.PerkNamesArray[15] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillDemolition') < 3 || Player.PerkNamesArray[26] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

            case "Lockpicking":
                if (Player.SkillSystem.GetSkillLevel(class'SkillLockpicking') < 1 && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if (Player.SkillSystem.GetSkillLevel(class'SkillLockpicking') < 2 && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillLockpicking') < 3 || Player.PerkNamesArray[32] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

            case "Environmental Training":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillEnviro') < 1 || Player.PerkNamesArray[6] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillEnviro') < 2 || Player.PerkNamesArray[20] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillEnviro') < 3 || Player.PerkNamesArray[28] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

            case "Medicine":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillMedicine') < 1 || Player.PerkNamesArray[8] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillMedicine') < 2 || Player.PerkNamesArray[19] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillMedicine') < 3 || Player.PerkNamesArray[30] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "Hacking":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillComputer') < 1 || Player.PerkNamesArray[7] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillComputer') < 2 || Player.PerkNamesArray[21] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillComputer') < 3 || Player.PerkNamesArray[33] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

            default:
                buttonUpgrade.SetSensitivity(False);
                buttonUpgrade2.SetSensitivity(False);
                buttonUpgrade3.SetSensitivity(False);
                break;
     }
     SetText(ob);
     AddLine();
     for (i=0;i<ArrayCount(Player.BoughtPerks);i++)
    {
     if (Player.BoughtPerks[i] != "")
     SetText(Player.BoughtPerks[i]);
    }
}

  // ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
    local DeusExBaseWindow TopWin;
    local int i;

	if (Super.ButtonActivated(buttonPressed))
		return True;

	bHandled   = True;

    topWin = DeusExRootWindow(GetRootWindow()).GetTopWindow();
	// Check if this is one of our Skills buttons
	/*if (buttonPressed.IsA('PersonaActionButtonWindow'))
	{
		SelectSkillButton(PersonaSkillButtonWindow(buttonPressed));
	}
	else
	{*/
		switch(buttonPressed)
		{
			case buttonUpgrade:
			    if (Player.SkillPointsAvail >= buttonUpgrade.PerkSkillCost)
			    {
			    Player.PlaySound(Sound'GMDXSFX.Generic.codelearned',SLOT_None,,,,0.8);
				Player.SkillPointsAvail-= buttonUpgrade.PerkSkillCost;
				buttonUpgrade.SetSensitivity(False);
				Player.perksManager(buttonUpgrade.PerkNamed,1);
				SetText(buttonUpgrade.PerkNamed);
				if ( TopWin!=None )
                   TopWin.RefreshWindow( 0.0 );
				}
				else
				buttonUpgrade.SetSensitivity(False);
				for (i=0;i<ArrayCount(Player.BoughtPerks);i++)
				{
				 if (Player.BoughtPerks[i] == "")
				 {
				 Player.BoughtPerks[i] = buttonUpgrade.PerkNamed;
				 break;
				 }
				}
				break;

            case buttonUpgrade2:
                if (Player.SkillPointsAvail >= buttonUpgrade2.PerkSkillCost2)
                {
                Player.PlaySound(Sound'GMDXSFX.Generic.codelearned',SLOT_None,,,,0.8);
				Player.SkillPointsAvail-= buttonUpgrade2.PerkSkillCost2;
				buttonUpgrade2.SetSensitivity(False);
				Player.perksManager(buttonUpgrade2.PerkNamed2,2);
				SetText(buttonUpgrade2.PerkNamed2);
				if ( TopWin!=None )
                   TopWin.RefreshWindow( 0.0 );
				}
				else
				buttonUpgrade2.SetSensitivity(False);
				for (i=0;i<ArrayCount(Player.BoughtPerks);i++)
				{
				 if (Player.BoughtPerks[i] == "")
				 {
				 Player.BoughtPerks[i] = buttonUpgrade2.PerkNamed2;
				 break;
				 }
				}
                break;

            case buttonUpgrade3:
                if (Player.SkillPointsAvail >= buttonUpgrade3.PerkSkillCost3)
                {
                Player.PlaySound(Sound'GMDXSFX.Generic.codelearned',SLOT_None,,,,0.8);
				Player.SkillPointsAvail-= buttonUpgrade3.PerkSkillCost3;
				buttonUpgrade3.SetSensitivity(False);
				Player.perksManager(buttonUpgrade3.PerkNamed3,3);
				SetText(buttonUpgrade3.PerkNamed3);
				if ( TopWin!=None )
                   TopWin.RefreshWindow( 0.0 );
				}
				else
				buttonUpgrade3.SetSensitivity(False);
				for (i=0;i<ArrayCount(Player.BoughtPerks);i++)
				{
				 if (Player.BoughtPerks[i] == "")
				 {
				 Player.BoughtPerks[i] = buttonUpgrade3.PerkNamed3;
				 break;
				 }
				}
                break;

			default:
				bHandled = False;
				break;
		}

    return bHandled;
}

// ----------------------------------------------------------------------
// SetTitle()
//
// Assume that if we're setting the title we're looking at another
// item and to clear the existing contents.
// ----------------------------------------------------------------------

function SetTitle(String newTitle)
{
	Clear();
	winTitle.SetText(newTitle);
	PassedSkillName = newTitle; //CyberP: perks
}

// ----------------------------------------------------------------------
// SetText()
// ----------------------------------------------------------------------

function PersonaNormalLargeTextWindow SetText(String newText)
{
	winText = PersonaNormalLargeTextWindow(winTile.NewChild(Class'PersonaNormalLargeTextWindow'));

	winText.SetTextMargins(0, 0);
	winText.SetWordWrap(True);
	winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winText.SetText(newText);

	return winText;
}

// ----------------------------------------------------------------------
// AppendText()
// ----------------------------------------------------------------------

function AppendText(String newText)
{
	if (winText != None)
		winText.AppendText(newText);
	else
		SetText(newText);
}

// ----------------------------------------------------------------------
// AddInfoItem()
// ----------------------------------------------------------------------

function PersonaInfoItemWindow AddInfoItem(coerce String newLabel, coerce String newText, optional bool bHighlight)
{
	local PersonaInfoItemWindow winItem;

	winItem = PersonaInfoItemWindow(winTile.NewChild(Class'PersonaInfoItemWindow'));
	winItem.SetItemInfo(newLabel, newText, bHighlight);

	return winItem;
}

function PersonaInfoItemWindow AddModInfo(coerce String newLabel, int count, optional bool bHighlight)
{
        local PersonaInfoItemWindow winItem;

        //a: we create an instance of an InfoItem as a child to winTile,
        //which actually makes the winItem var the new row we want to create in DeusExWeapon.uc
        winItem = PersonaInfoItemWindow(winTile.NewChild(Class'PersonaInfoItemWindow'));

        //And since InfoItem on init event creates instances of left and right columns of our new row, let's populate them with our custom function
        winItem.SetModInfo(newLabel, count, bHighlight);

}
// ----------------------------------------------------------------------
// AddLine()
// ----------------------------------------------------------------------

function AddLine()
{
	winTile.NewChild(Class'PersonaInfoLineWindow');
}

// ----------------------------------------------------------------------
// Clear()
// ----------------------------------------------------------------------

function Clear()
{
	winTitle.SetText("");
	winTile.DestroyAllChildren();

	//CyberP: destroy perk upgrade buttons
	/*if (winActionButtons != None)
	    winActionButtons.DestroyAllChildren();
	if (winActionButtons2 != None)
	    winActionButtons2.DestroyAllChildren();
    if (winActionButtons3 != None)
	    winActionButtons3.DestroyAllChildren();      */
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float qWidth, qHeight;

	if (winTitle != None)
	{
		winTitle.QueryPreferredSize(qWidth, qHeight);
		winTitle.ConfigureChild(0, 0, width, qHeight);
	}

	if (winScroll != None)
	{
		winScroll.QueryPreferredSize(qWidth, qHeight);
		winScroll.ConfigureChild(0, textVerticalOffset, width, height - textVerticalOffset);
	}
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

function bool ChildRequestedReconfiguration(window child)
{
	ConfigurationChanged();

	return True;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     textVerticalOffset=20
     UpgradeButtonLabel="|&Upgrade"
}
