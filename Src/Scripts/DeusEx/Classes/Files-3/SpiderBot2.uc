//=============================================================================
// SpiderBot2.
//=============================================================================
class SpiderBot2 extends Robot;

defaultproperties
{
     EMPHitPoints=25
     maxRange=1040.000000
     MinRange=200.000000
     WalkingSpeed=1.000000
     bEmitDistress=True
     InitialAlliances(7)=(AllianceName=Player,AllianceLevel=-1.000000)
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponSpiderBot2')
     InitialInventory(1)=(Inventory=Class'DeusEx.AmmoBattery',Count=99)
     WalkSound=Sound'DeusExSounds.Robot.SpiderBot2Walk'
     GroundSpeed=300.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=120
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'GMDXSFX.Generic.bouncemetal'
     DrawType=DT_Mesh
     Mesh=LodMesh'HDTPCharacters.HDTPspiderbot2'
     CollisionRadius=33.580002
     CollisionHeight=15.240000
     Mass=200.000000
     Buoyancy=50.000000
     BindName="MiniSpiderBot"
     FamiliarName="Mini-SpiderBot"
     UnfamiliarName="Mini-SpiderBot"
}
