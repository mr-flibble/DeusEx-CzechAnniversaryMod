//=============================================================================
// HumanThug.
//=============================================================================
class HumanThug extends ScriptedPawn
	abstract;

function PostBeginPlay()
{
local DeusExPlayer player;

	Super.PostBeginPlay();

    bReactCarcass = True;  //CyberP: all react to carc now
	// change the sounds for chicks
	if (bIsFemale)
	{
		HitSound1 = Sound'FemalePainMedium';
		HitSound2 = Sound'FemalePainLarge';
		Die = Sound'FemaleDeath';
	}

    if (FRand() < 0.6)
      bDefensiveStyle = True; //CyberP: most pawns play a more defensive combat role when in close proximity

    player = DeusExPlayer(GetPlayerPawn());

 	/*if (player != none)
    {
    if (!player.bHardCoreMode && player.CombatDifficulty > 2)
    {
    if (HearingThreshold < 0.135000) //CyberP: Realistic is harder, but hardcore is hardest.
    HearingThreshold = 0.135000;
    if (SurprisePeriod < 1.500000)
    SurprisePeriod = 1.500000;
    if (VisibilityThreshold < 0.007500)
    VisibilityThreshold = 0.007500;
    if (EnemyTimeout > 10.000000)
    EnemyTimeout = 10.000000;
    }
    else if (player.CombatDifficulty <= 2)
    {
    if (VisibilityThreshold < 0.010000)
    VisibilityThreshold = 0.010000;
    if (HearingThreshold < 0.150000) //CyberP: Easier stealth on easier difficulties.
    HearingThreshold = 0.150000;
    if (EnemyTimeout > 7.000000)
    EnemyTimeout = 7.000000;
    if (SurprisePeriod < 2)
    SurprisePeriod = 2;
    BaseAccuracy+=0.200000;
    }
    } */
}

function bool WillTakeStompDamage(actor stomper)
{
	// This blows chunks!
	if (stomper.IsA('PlayerPawn') && (GetPawnAllianceType(Pawn(stomper)) != ALLIANCE_Hostile))
		return false;
	else
		return true;
}

defaultproperties
{
     BaseAccuracy=0.200000
     maxRange=1200.000000
     bPlayIdle=True
     bAvoidAim=False
     bCanCrouch=True
     bSprint=True
     CrouchRate=0.200000
     SprintRate=0.500000
     bReactAlarm=True
     EnemyTimeout=10.000000
     bCanTurnHead=True
     WaterSpeed=80.000000
     AirSpeed=160.000000
     AccelRate=500.000000
     BaseEyeHeight=40.000000
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'GMDXSFX.Human.PainSmall03'
     Die=Sound'DeusExSounds.Player.MaleDeath'
     VisibilityThreshold=0.005000
     DrawType=DT_Mesh
     Mass=150.000000
     Buoyancy=155.000000
     BindName="HumanThug"
}
