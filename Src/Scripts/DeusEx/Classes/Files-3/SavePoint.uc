//=============================================================================
// SavePoint.
//=============================================================================
class SavePoint extends BoxLarge;

var bool bUsedSavePoint; //stop double trigger if destroy takes its time
var int Tcount;
var DeusExPlayer DxPlayer;
var localized String msgDeducted;
var localized String msgNotEnough;

#exec OBJ LOAD FILE=Extras

function Timer()
{
   Tcount--;
   if (Tcount<0)
      Destroy();
   DrawScale-=0.01;
}

singular function Touch(Actor Other)
{
   local DeusExLevelInfo info;

   DxPlayer=DeusExPlayer(Other);
   info=DxPlayer.GetLevelInfo();

   if ((DxPlayer != none) && (Pawn(Other)!=None) && (Pawn(Other).bIsPlayer) && (DxPlayer.Credits < 100) && (DxPlayer.bExtraHardcore))
   DxPlayer.ClientMessage(msgNotEnough);

   if (DxPlayer != None && DxPlayer.Credits < 100 && DxPlayer.bExtraHardcore)
   {
   return;
   }
   else
   {
   if ((Pawn(Other)!=None) && (Pawn(Other).bIsPlayer) && (!bUsedSavePoint))
   {
   	if (((info != None) && (info.MissionNumber < 0)) ||
	   ((DxPlayer.IsInState('Dying')) || (DxPlayer.IsInState('Paralyzed')) || (DxPlayer.IsInState('Interpolating'))) ||
	   (DxPlayer.dataLinkPlay != None) || (DxPlayer.Level.Netmode != NM_Standalone))
	     {
	        return;
	     }

      GotoState('QuickSaver');

//      log("Save Game touched by player "@Other);
//      bUsedSavePoint=true;
//      DeusExPlayer(Other).bPendingHardCoreSave=true;
//      DeusExPlayer(Other).QuickSave();
//      PlaySound(sound'CloakDown', SLOT_None,,,,0.5);
     }
   }
}

State QuickSaver
{
   function Timer()
   {
      local DeusExLevelInfo dxInfo;
      dxInfo=DxPlayer.GetLevelInfo();

      if (dxInfo != None && !(DxPlayer.IsInState('Dying')) && !(DxPlayer.IsInState('Paralyzed')) && !(DxPlayer.IsInState('Interpolating')) &&
      DxPlayer.dataLinkPlay == None && Level.Netmode == NM_Standalone)
      {
         if (DxPlayer.bExtraHardcore)
         {
         DxPlayer.Credits -= 100;
         DxPlayer.ClientMessage(msgDeducted);
         }
         bUsedSavePoint=true;
         DxPlayer.bPendingHardCoreSave=true;
         DxPlayer.QuickSave();
         PlaySound(sound'CloakDown', SLOT_None,,,,0.5);
         GotoState('');
         Global.SetTimer(0.02,true);
      } else
         GotoState('');
   }

Begin:
   SetTimer(0.1,false);
}

defaultproperties
{
     Tcount=100
     msgDeducted="100 credits deducted from your account"
     msgNotEnough="100 credits required"
     numThings=0
     bFlammable=False
     bHighlight=False
     bCanBeBase=False
     ItemName="SavePoint"
     bPushable=False
     bOnlyTriggerable=True
     bBlockSight=False
     Physics=PHYS_None
     Style=STY_Translucent
     MultiSkins(1)=Texture'Extras.Eggs.Matrix_A00'
     MultiSkins(2)=Texture'Extras.Eggs.Matrix_A00'
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
}
