//-----------------------------------------------------------
//CyberP: Enable Disable double click holstering
//-----------------------------------------------------------
class MenuChoice_NoConsole extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bNoConsole));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bNoConsole = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bNoConsole));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="If enabled, you cannot access the console. Note: hardcore mode disables console use by default."
     actionText="|&No Console Commands"
}
