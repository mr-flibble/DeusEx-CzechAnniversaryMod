//=============================================================================
// MenuSettings
//=============================================================================

class MenuSettings expands MenuUIMenuWindow;

var localized string NewButtonNames[10]; //because the localizations were fucking us

function CreateMenuButtons()
{
	local int buttonIndex;
   /* local TextWindow winText;
    local string s1;
    local string s2;
    local string s3;
    local string s4;
    local string s5;
    local string s6;
    local string s7;
    local string s8;
    local string s9;
    local string s10;
    local string s11;
    local float rnd;

	winText = TextWindow(NewChild(Class'TextWindow'));
	winText.SetPos(0,0);
	winText.SetWidth(294);
	winText.SetTextMargins(0,0);
	winText.SetFont(Font'FontMenuSmall');
	winText.SetBackground(Texture'MaskTexture');
	winText.SetBackgroundStyle(DSTY_Masked);
	//winText.SetTextMargins(0, 0);
	//winText.SetWidth(512);
	//winText.SetTextAlignments(HALIGN_Center, VALIGN_Top);

    rnd = FRand();

    if (rnd < 0.1)
    { s1 = "TIP: You can rebind augmentation activation keys in 'Keyboard/Mouse'."; winText.SetText(s1); }
    else if (rnd < 0.2)
    { s2 = "TIP: Attacking an enemy from behind grants you a damage multiplier of eight with ANY weapon."; winText.SetText(s2);}
    else if (rnd < 0.3)
    { s3 = "TIP: A headshot with a poison dart is an instant non-lethal takedown to any unarmoured human NPC."; winText.SetText(s3); }
    else if (rnd < 0.4)
    { s4 = "TIP: Standing still for variable period of time grants an accuracy bonus."; winText.SetText(s4); }
    else if (rnd < 0.5)
    { s5 = "TIP: Some surfaces when stepped on are louder than others. Metal is the loudest."; winText.SetText(s5); }
    else if (rnd < 0.6)
    { s6 = "TIP: Toggle between lethal and non-lethal firing modes with the PS20 by pressing the Reload key."; winText.SetText(s6); }
    else if (rnd < 0.7)
    { s7 = "ADVANCED TIP: When hacking, press ESC immediately if detected to disconnect without consequence."; winText.SetText(s7); }
    else if (rnd < 0.8)
    { s8 = "ADVANCED TIP: Variations of mouse clicking on items in the inventory acts as shortcuts. Right click to equip or use, middle mouse to drop."; winText.SetText(s8); }
    else if (rnd < 0.9)
    { s9 = "ADVANCED TIP: Out of ammo? Press the middle mouse button to throw your weapon at the enemy. Especially effective if you have the Microfibral Muscle augmentation installed."; winText.SetText(s9); }
    else if (rnd < 0.95)
    { s10 = "ADVANCED TIP: Only drop combat knives when your inventory is full."; winText.SetText(s10); }
    else
    {s11 = "TIP: Double Right Click to pick up a corpse regardless of inventory limitations."; winText.SetText(s11);}
    */
	for(buttonIndex=0; buttonIndex<arrayCount(buttonDefaults); buttonIndex++)
	{
		if (NewButtonNames[buttonIndex] != "")
		{
			winButtons[buttonIndex] = MenuUIMenuButtonWindow(winClient.NewChild(Class'MenuUIMenuButtonWindow'));

			winButtons[buttonIndex].SetButtonText(NewButtonNames[buttonIndex]);
			winButtons[buttonIndex].SetPos(buttonXPos, buttonDefaults[buttonIndex].y);
			winButtons[buttonIndex].SetWidth(buttonWidth);
		}
		else
		{
			break;
		}
	}
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     NewButtonNames(0)="Keyboard/Mouse"
     NewButtonNames(1)="Controls"
     NewButtonNames(2)="Game Options"
     NewButtonNames(3)="GMDX Options"
     NewButtonNames(4)="Display"
     NewButtonNames(5)="Colors"
     NewButtonNames(6)="Sound"
     NewButtonNames(7)="Previous Menu"
     buttonXPos=7
     buttonWidth=282
     buttonDefaults(0)=(Y=13,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenCustomizeKeys')
     buttonDefaults(1)=(Y=49,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenControls')
     buttonDefaults(2)=(Y=85,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenOptions')
     buttonDefaults(3)=(Y=121,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenGMDXOptions')
     buttonDefaults(4)=(Y=157,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenDisplay')
     buttonDefaults(5)=(Y=193,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenAdjustColors')
     buttonDefaults(6)=(Y=229,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenSound')
     buttonDefaults(7)=(Y=302,Action=MA_Previous)
     Title="Settings"
     ClientWidth=294
     ClientHeight=335
     clientTextures(0)=Texture'HDTPDecos.UserInterface.HDTPMenuOptionsBackground_1'
     clientTextures(1)=Texture'HDTPDecos.UserInterface.HDTPMenuOptionsBackground_2'
     clientTextures(2)=Texture'HDTPDecos.UserInterface.HDTPMenuOptionsBackground_3'
     clientTextures(3)=Texture'HDTPDecos.UserInterface.HDTPMenuOptionsBackground_4'
     textureCols=2
}
