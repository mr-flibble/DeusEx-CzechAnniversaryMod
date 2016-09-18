//=============================================================================
// ExplosionLarge.
//=============================================================================
class ExplosionLarge extends AnimatedSprite;

simulated function PostBeginPlay()
{
	local int i;
	local float shakeTime, shakeRoll, shakeVert;
	local float size;
	local DeusExPlayer player;
	local float dist;
    local SFXExp exp;
    local vector offs;

	Super.PostBeginPlay();

	exp = Spawn(class'SFXExp');
	if (exp != none)
	exp.scaleFactor = 14;

	for (i=0; i<4; i++) //CyberP: was 6
		{
        Spawn(class'FireComet', None);
        Spawn(class'RockchipLarge',None);
        }

        offs = Location;
        offs.Z += 10;
        offs.X += 15;
        //Spawn(class'RockchipXL',None);
        //Spawn(class'RockchipXL',None,,offs);

		player = DeusExPlayer(GetPlayerPawn());
        size = FRand();
        shakeTime = 0.6;
        shakeRoll = 320.0 + 448.0 * size;
        shakeVert = 8.0 + 16.0 * size;

        if (player!=none)
        {
   		dist = Abs(VSize(player.Location - Location));
   		if (dist < 672)
   		     {
                player.ShakeView(shakeTime, shakeRoll, shakeVert);
             }
        }
}

defaultproperties
{
     animSpeed=0.085000
     numFrames=8
     frames(0)=Texture'DeusExItems.Skins.FlatFXTex20'
     frames(1)=Texture'DeusExItems.Skins.FlatFXTex21'
     frames(2)=Texture'DeusExItems.Skins.FlatFXTex22'
     frames(3)=Texture'DeusExItems.Skins.FlatFXTex23'
     frames(4)=Texture'DeusExItems.Skins.FlatFXTex24'
     frames(5)=Texture'DeusExItems.Skins.FlatFXTex25'
     frames(6)=Texture'DeusExItems.Skins.FlatFXTex26'
     frames(7)=Texture'DeusExItems.Skins.FlatFXTex27'
     Texture=Texture'DeusExItems.Skins.FlatFXTex20'
     DrawScale=8.000000
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=32
     LightHue=40
     LightSaturation=192
     LightRadius=32
}
