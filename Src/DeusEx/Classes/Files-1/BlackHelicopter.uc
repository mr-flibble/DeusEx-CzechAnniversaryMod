//=============================================================================
// BlackHelicopter.
//=============================================================================
class BlackHelicopter extends Vehicles;

var SpoofedCorona cor;
var bool bTickedOff;

auto state Flying
{
	function BeginState()
	{
		Super.BeginState();
		LoopAnim('Fly');
	}
}

///////
// CyberP: helicopter cloaking upon take off. Needs more work to look good.
///////
/*function Timer()
{
Skin=default.Skin;
Style=STY_Translucent;
ScaleGlow=0.05;
AmbientGlow=0;
SoundVolume=48;
bUnlit=True;
}

simulated function Tick(float deltaTime)
{
local float point;

super.Tick(deltaTime);

if (Physics == PHYS_Interpolating)
{
if (bTickedOff)
{
if (FRand() <0.01)
{
            bTickedOff=false;
            AmbientGlow=254;
            bUnlit=True;
            ScaleGlow=2;
			PlaySound(Sound'CloakUp', SLOT_None, 0.6, ,2048,0.9);
			Skin=Texture'Effects.Corona.Corona_E';//Texture'HDTPDecos.Skins.HDTPAlarmLightTex6';
            SetTimer(0.3,false);
	        /*if (cor != none)
            {
            cor.DrawScale=26.000000;
            cor.RotationRate.Yaw = 65536*3;
            }*/  //CyberP: hmm, sprite wont face camera. I guess it only faces player


}
}
}
}
*/
singular function SupportActor(Actor standingActor)
{
	// kill whatever lands on the blades
	if (standingActor != None)
		standingActor.TakeDamage(10000, None, standingActor.Location, vect(0,0,0), 'Exploded');
}

defaultproperties
{
     bTickedOff=True
     ItemName="Black Helicopter"
     Mesh=LodMesh'DeusExDeco.BlackHelicopter'
     SoundRadius=160
     SoundVolume=192
     AmbientSound=Sound'Ambient.Ambient.Helicopter2'
     CollisionRadius=461.230011
     CollisionHeight=87.839996
     Mass=6000.000000
     Buoyancy=1000.000000
}
