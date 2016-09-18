//=============================================================================
// DeusExTextParser
//=============================================================================
class DeusExTextParser extends Object
	native
	noexport;

// DeusEx Text Tags
enum EDeusExTextTags
{
	TT_Text,
	TT_File,
	TT_Email,
	TT_Note,			
	TT_EndNote,		
	TT_Goal,			
	TT_EndGoal,		
	TT_Comment,		
	TT_EndComment,	
	TT_PlayerName,
	TT_PlayerFirstName,
	TT_NewPage,		
    TT_CenterText,	
	TT_LeftJustify,	
	TT_RightJustify,	
	TT_DefaultColor,
	TT_TextColor,	
	TT_RevertColor,	
	TT_NewParagraph,	
	TT_Bold,			
	TT_EndBold,		
	TT_Underline,	
	TT_EndUnderilne,	
	TT_Italics,		
	TT_EndItalics,	
	TT_Graphic,		
	TT_Font,			
	TT_Label,		
	TT_OpenBracket,	
	TT_CloseBracket,	
	TT_None			
};

// ----------------------------------------------------------------------
// Variables

var const native int text;	
var const native int textPos;
var const native int tagEndPos;

var const native String lastText;
var const native EDeusExTextTags lastTag;
var const native Name lastName;
var const native Color lastColor;
var const native Color defaultColor;
var const native Bool bParagraphStarted;
var const native String playerName;				
var const native String playerFirstName;

var const native String lastEmailName;
var const native String lastEmailSubject;
var const native String lastEmailFrom;
var const native String lastEmailTo;
var const native String lastEmailCC;
var const native String lastFileName;
var const native String lastFileDescription;

// ----------------------------------------------------------------------
// natives

native(2210) final function Bool OpenText(Name textName, optional string TextPackage);
native(2211) final function CloseText();
native(2212) final function Bool ProcessText();
native(2213) final function Bool IsEOF();
native(2214) final function String GetText();
native(2215) final function GotoLabel(String label);
//native(2216) final function EDeusExTextTags GetTag();
native(2216) final function byte GetTag();
native(2217) final function Name GetName();
native(2218) final function Color GetColor();
native(2219) final function GetEmailInfo(
	out String emailName, 
	out String emailSubject,
	out String emailFrom,
	out String emailTo,
	out String emailCC);
native(2220) final function	GetFileInfo(
	out String fileName,
	out String fileDescription);
native(2221) final function SetPlayerName(String newPlayerName);

defaultproperties
{
}
