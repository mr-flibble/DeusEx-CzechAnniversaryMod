//=============================================================================
// AirBubbleLarge.
//=============================================================================
class AirBubbleLarge expands Effects;

auto state Flying
{
	simulated function Tick(float deltaTime)
	{
	local DeusExPlayer player;
    local vector p;

    player = DeusExPlayer(GetPlayerPawn());
	p = player.Location;
	}

}

defaultproperties
{
     Physics=PHYS_Projectile
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'DeusExItems.Skins.FlatFXTex45'
     DrawScale=10.050000
}
