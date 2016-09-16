//-----------------------------------------------------------
//CyberP: Enable Disable double click holstering
//-----------------------------------------------------------
class MenuChoice_HardcoreAI3 extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bHardcoreAI3));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bHardcoreAI3= !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bHardcoreAI3));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="Certain vigilant NPCs will by angered by theft. Break line of sight or use tech to conceal yourself when stealing around these NPCs."
     actionText="|&AI Choice B"
}
