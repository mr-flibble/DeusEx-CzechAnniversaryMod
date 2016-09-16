//=============================================================================
// FleshFragmentWall.             //CyberP: guts up the wall
//=============================================================================
class FleshFragmentWallSliding expands DeusExFragment;

auto state Flying

{
	function BeginState()
	{
       if (Level.Game.bLowGore || Level.Game.bVeryLowGore || Region.Zone.bWaterZone)
		{
			Destroy();
			return;
		}
       Destroy();
	   return;  //CyberP: destroy for now until I figure out how to check if it should
                //slide or not and also spawn blood decal as it slides down.

       DrawScale = FRand();
       SetPhysics(PHYS_Flying);
       Mass = 0.100000;
       if (FRand() < 0.6)
       Skin=None;
    }
}



function Tick(float deltaSeconds)
{

	Super.Tick(deltaSeconds);

        Velocity = vect(0,0,-1);
            Velocity.Z = -1;

        if (FRand() < 0.01)
            {
            SetPhysics(PHYS_Falling);
            Mass = 4.000000;
            }
}

defaultproperties
{
     Fragments(0)=LodMesh'DeusExItems.FleshFragment1'
     Fragments(1)=LodMesh'DeusExItems.FleshFragment2'
     Fragments(2)=LodMesh'DeusExItems.FleshFragment3'
     Fragments(3)=LodMesh'DeusExItems.FleshFragment4'
     numFragmentTypes=4
     Physics=PHYS_Flying
     LifeSpan=50.000000
     Skin=Texture'HDTPItems.Skins.HDTPFleshFragTex1'
     Mesh=LodMesh'DeusExItems.FleshFragment1'
     CollisionRadius=0.010000
     CollisionHeight=0.010000
     bBounce=False
     Mass=0.000000
     Buoyancy=5.500000
     bVisionImportant=True
}
