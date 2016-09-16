//=============================================================================
// TearGas.
//=============================================================================
class TearGas extends Cloud;

function PostBeginPlay()
{
PlaySound(sound'PepperGunFire', SLOT_None,,,96);
super.PostBeginPlay();
}

defaultproperties
{
     DamageType=TearGas
     maxDrawScale=1.100000
     speed=160.000000
     LifeSpan=2.300000
     Texture=WetTexture'Effects.Smoke.Gas_Tear_A'
     DrawScale=0.300000
}
