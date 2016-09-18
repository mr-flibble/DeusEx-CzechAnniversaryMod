//=============================================================================
// ExplosionMedium.
//=============================================================================
class ExplosionMedium extends AnimatedSprite;

simulated function PostBeginPlay()
{
	local int i;
	local float shakeTime, shakeRoll, shakeVert;
	local float size;
	local DeusExPlayer player;
	local float dist;
    local SFXExp exp;

	Super.PostBeginPlay();

	exp = Spawn(class'SFXExp');
	if (exp != none)
	exp.scaleFactor = 9;

        Spawn(class'FireComet', None);
        Spawn(class'FireComet', None);
        //Spawn(class'RockchipXL',None);

        player = DeusExPlayer(GetPlayerPawn());
        size = FRand();
        shakeTime = 0.3;
        shakeRoll = 320.0 + 448.0 * size;
        shakeVert = 8.0 + 16.0 * size;

        Spawn(class'RockchipLarge',None);

        if (player!=none)
        {
   		dist = Abs(VSize(player.Location - Location));
   		if (dist < 512)
   		     {
                player.ShakeView(shakeTime, shakeRoll, shakeVert);
             }
        }
}

defaultproperties
{
     animSpeed=0.085000
     numFrames=6
     frames(0)=Texture'DeusExItems.Skins.FlatFXTex14'
     frames(1)=Texture'DeusExItems.Skins.FlatFXTex15'
     frames(2)=Texture'DeusExItems.Skins.FlatFXTex16'
     frames(3)=Texture'DeusExItems.Skins.FlatFXTex17'
     frames(4)=Texture'DeusExItems.Skins.FlatFXTex18'
     frames(5)=Texture'DeusExItems.Skins.FlatFXTex19'
     Texture=Texture'DeusExItems.Skins.FlatFXTex14'
     DrawScale=5.500000
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=32
     LightHue=40
     LightSaturation=192
     LightRadius=24
}
