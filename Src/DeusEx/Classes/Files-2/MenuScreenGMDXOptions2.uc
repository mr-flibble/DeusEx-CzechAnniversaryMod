//=============================================================================
// MenuScreenOptions
//=============================================================================

class MenuScreenGMDXOptions2 expands MenuUIScreenWindow;



event InitWindow()
{
	Super.InitWindow();

	actionButtons[3].btn.colButtonFace.R = 255;
	actionButtons[3].btn.colButtonFace.G = 255;
	actionButtons[3].btn.colButtonFace.B = 255;
	actionButtons[3].btn.colText[0].R = 128;
	actionButtons[3].btn.colText[0].G = 0;
	actionButtons[3].btn.colText[0].B = 0;
}

function SaveSettings()
{
   Super.SaveSettings();
	player.SaveConfigOverride();
}

function ProcessAction(String actionKey)
{
	if (actionKey == "TIPS")
	{
	CreateTips();
    }
    Super.ProcessAction(actionKey);
}

function CreateTips()
{
    local string s1;
    local float rnd;

    rnd = FRand();

    if (rnd < 0.05)
    s1 = "TIP: You can rebind augmentation activation keys in the 'Keyboard/Mouse' settings menu.";
    else if (rnd < 0.1)
    s1 = "TIP: A sneak attack from behind grants you a damage multiplier of twelve with any weapon.";
    else if (rnd < 0.15)
    s1 = "TIP: A headshot with a poison dart is an instant non-lethal takedown to any unarmoured human NPC.";
    else if (rnd < 0.2)
    s1 = "TIP: Standing still for a variable period of time grants an accuracy bonus.";
    else if (rnd < 0.25)
    s1 = "TIP: Some surfaces when stepped on are louder than others. Metal is the loudest.";
    else if (rnd < 0.3)
    s1 = "TIP: Assign weapons to use as secondary weapons via the inventory. The default keybind to use secondary weapons is 'F'";
    else if (rnd < 0.35)
    s1 = "ADVANCED TIP: When hacking, press ESC immediately if detected to disconnect without consequence.";
    else if (rnd < 0.4)
    s1 = "ADVANCED TIP: Variations of mouse clicking on items in the inventory acts as shortcuts. Right click to equip or use, middle mouse to drop.";
    else if (rnd < 0.45)
    s1 = "ADVANCED TIP: Out of ammo? Throw your held weapon at the enemy (DEFAULT: Middle Mouse Button). Especially effective if you have the Microfibral Muscle augmentation installed.";
    else if (rnd < 0.5)
    s1 = "TIP: Only drop combat knives when your inventory is full.";
    else if (rnd < 0.55)
    s1 = "TIP: Double press interact (DEFAULT: Right Mouse Button) to pick up a corpse regardless of inventory limitations.";
    else if (rnd < 0.6)
    s1 = "TIP: Press jump whilst airbourne to mantle onto nearby objects.";
    else if (rnd < 0.65)
    s1 = "ADVANCED TIP: Press interact (DEFAULT: Right Mouse Button) when controlling the spy drone to emit noise and distract NPCs.";
    else if (rnd < 0.7)
    s1 = "ADVANCED TIP: Next Belt Item/Prev Belt Item (DEFAULT: Mousewheel) can be used to zoom in/out when looking through scopes.";
    else if (rnd < 0.75)
    s1 = "ADVANCED TIP: With two hands free, press fire (DEFAULT: Left Mouse Button) whilst looking at objects to use them where they stand.";
    else if (rnd < 0.8)
    s1 = "TIP: Choose an easier difficulty if you have any doubts.";
    else if (rnd < 0.85)
    s1 = "ADVANCED TIP: CTRL + C/V applies when highlighting datavault notes. Useful to copy & paste computer passwords.";
    else if (rnd < 0.9)
    s1 = "ADVANCED TIP: Leaning is better than strafing under certain circumstances as whilst leaning your standing accuracy bonus is retained.";
    else if (rnd < 0.95)
    s1 = "TIP: There are many ways in which you can distract the enemy.";
    else
    s1 = "Your Deus Ex is Augmented.";

    ShowHelp(s1);
}

defaultproperties
{
     choices(0)=Class'DeusEx.MenuChoice_AlternBelt'
     choices(1)=Class'DeusEx.MenuChoice_RealTimeUI'
     choices(3)=Class'DeusEx.MenuChoice_ObjectTranslucency'
     choices(4)=Class'DeusEx.MenuChoice_AnimatedBar1'
     choices(5)=Class'DeusEx.MenuChoice_AnimatedBar2'
     choices(6)=Class'DeusEx.MenuChoice_NewGameIntro'
     choices(7)=Class'DeusEx.MenuChoice_ExtraDetails'
     choices(8)=Class'DeusEx.MenuChoice_AutoSaving'
     choices(9)=Class'DeusEx.MenuChoice_AutoSaveSlots'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     actionButtons(3)=(Align=HALIGN_Right,Action=AB_Other,Text="Show Tips",Key="TIPS")
     Title="GMDX Advanced Options"
     ClientWidth=537
     ClientHeight=406
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_6'
     bHelpAlwaysOn=True
     helpPosY=354
}
