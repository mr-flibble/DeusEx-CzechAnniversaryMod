//=============================================================================
// HumanMilitary.
//=============================================================================
class HumanMilitary extends ScriptedPawn
	abstract;

function PostBeginPlay()
{
local DeusExPlayer player;

	Super.PostBeginPlay();

    if (Style != STY_Translucent)
       bReactCarcass = True;  //CyberP: all except holograms react to carc now
    else if (Style == STY_Translucent || IsA('WaltonSimons')) //CyberP/|Totalitarian|: Holograms don't run away from projectiles, neither does Walt
       bAvoidHarm = False;
    //player = DeusExPlayer(GetPlayerPawn());

    if (FRand() < 0.4 && !IsA('MIB') && !IsA('MJ12Commando') && !IsA('AnnaNavarre'))
      bDefensiveStyle = True; //CyberP: many pawns play a more defensive combat role when in close proximity

    if (bCanStrafe && !bDefendHome)  //CyberP: get them to move more.
    bAvoidAim = True;

   /* if (player != none)
    {
    if (!player.bHardCoreMode && player.CombatDifficulty > 2)
    {
    if (HearingThreshold < 0.135000) //CyberP: Lazy scale based on difficulty
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
    if (HearingThreshold < 0.150000) //CyberP:
    HearingThreshold = 0.150000;
    if (EnemyTimeout > 7.000000)
    EnemyTimeout = 7.000000;
    if (SurprisePeriod < 2.000000)
    SurprisePeriod = 2.0;
    BaseAccuracy+=0.200000;
    }
    }
    if (player != none && player.bHardCoreMode)
    {
      if (BaseAccuracy != 0.000000 && BaseAccuracy > 0.080000) //CyberP: all Human Military are more accurate on hardcore mode.
       BaseAccuracy=0.010000;
        if (bDefendHome && HomeExtent < 64)
       EnemyTimeOut = 22.000000;  //CyberP: camp for longer
       if (SurprisePeriod > 0.75)
        SurprisePeriod = 0.75;
    } */

    if (RotationRate.Yaw != 90000)
    RotationRate.Yaw = 90000; //CyberP: turn faster

	// change the sounds for chicks
	/*if (bIsFemale)
	{
		HitSound1 = Sound'FemalePainMedium';
		HitSound2 = Sound'FemalePainLarge';
		Die = Sound'FemaleDeath';
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
     BaseAccuracy=0.100000
     maxRange=2000.000000
     MinHealth=20.000000
     bPlayIdle=True
     bCanCrouch=True
     bSprint=True
     CrouchRate=0.750000
     SprintRate=1.000000
     CloseCombatMult=0.550000
     bReactAlarm=True
     EnemyTimeout=14.000000
     bCanTurnHead=True
     WaterSpeed=80.000000
     AirSpeed=160.000000
     AccelRate=500.000000
     BaseEyeHeight=40.000000
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'GMDXSFX.Human.PainSmall04'
     Die=Sound'DeusExSounds.Player.MaleDeath'
     VisibilityThreshold=0.003000
     DrawType=DT_Mesh
     Mass=150.000000
     Buoyancy=155.000000
     BindName="HumanMilitary"
}
