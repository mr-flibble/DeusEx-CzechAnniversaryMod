//=============================================================================
// FleshFragment.
//=============================================================================
class FleshFragment expands DeusExFragment;

var float TwitchyS;
var float TwitchyE;
var bool bWasUnconscious;


auto state Flying                      //CyberP: modified to be more gory
{
	function BeginState()
	{
		local rotator      randRot;
        local float        rand;

		Super.BeginState();

		Velocity = VRand() * 300; //300
		DrawScale = FRand() + 1.3;
		rand = FRand();
		SetRotation(Rotator(Velocity));
        //randRot=Rotation;
		//randRot.Yaw=FRand()*30000;
        //SetRotation(randRot);

		if (rand < 0.03)
			spawn(class'BoneFemurLessBloody',,,,randRot);
        else if (rand <0.15)
                    Skin=Texture'HDTPItems.Skins.HDTPFleshFragTex1';
		else if (rand < 0.19)
                    spawn(class'BoneFemurBloody',,,,randRot);
        else
                    Skin=None;
	}
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if (!IsInState('Dying') && Speed != 0)
			Spawn(class'BloodDrop',,, Location);
}

function Landed(vector HitNormal)
{
bFirstHit=False;
}

defaultproperties
{
     Fragments(0)=LodMesh'DeusExItems.FleshFragment1'
     Fragments(1)=LodMesh'DeusExItems.FleshFragment2'
     Fragments(2)=LodMesh'DeusExItems.FleshFragment3'
     Fragments(3)=LodMesh'DeusExItems.FleshFragment4'
     numFragmentTypes=4
     elasticity=0.300000
     ImpactSound=Sound'DeusExSounds.Generic.FleshHit1'
     MiscSound=Sound'DeusExSounds.Generic.FleshHit2'
     LifeSpan=60.000000
     Mesh=LodMesh'DeusExItems.FleshFragment1'
     CollisionRadius=0.010000
     CollisionHeight=1.220000
     Mass=5.000000
     Buoyancy=5.500000
}
