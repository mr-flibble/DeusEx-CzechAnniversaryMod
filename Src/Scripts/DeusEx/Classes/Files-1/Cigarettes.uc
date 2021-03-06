//=============================================================================
// Cigarettes.
//=============================================================================
class Cigarettes extends DeusExPickup;

//enum ECigType
//{
//	SC_Default,
//	SC_BigTop
//};


//var() ECigType Cig;

var bool bDontUse;

function SetSkin()
{
	switch(textureSet)
	{
			case 0:		Skin = default.skin; description = default.description; icon = default.icon; largeicon = default.largeicon; break;
			case 1:		Skin = Texture'HDTPitems.Skins.HDTPcigarettesTex2'; Description = "Big Top Cigarettes -- Elephant tested, Lion Approved!"; icon = texture'HDTPitems.skins.belticonCigarettes2'; largeicon = texture'HDTPitems.skins.largeiconCigarettes2'; break;
			default:	Skin = default.skin; description = default.description; icon = default.icon; largeicon = default.largeicon; break;
	}
	super.SetSkin();
}





state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local Pawn P;
		local vector loc;
		local rotator rot;
		local SmokeTrail puff;
		local DeusExPlayer playa;

		Super.BeginState();


      if (bDontUse)
      {
        playa = DeusExPlayer(GetPlayerPawn());
        if (playa!=none)
        {
        loc = playa.Location;
		rot = playa.Rotation;
        playa.TakeDamage(5, playa, loc, vect(0,0,0), 'PoisonGas');
        PlaySound(sound'MaleCough');
        loc += 2.0 * playa.CollisionRadius * vector(playa.ViewRotation);
		loc.Z += playa.CollisionHeight * 0.9;
        puff = Spawn(class'SmokeTrail', playa,, loc, rot);
			if (puff != None)
			{
				puff.DrawScale = 1.2;
				puff.origScale = puff.DrawScale;
			}
			bDontUse=false;
			Destroy();
		  }
		}

        P = Pawn(Owner);
		if (P != None)
		{
			P.TakeDamage(5, P, P.Location, vect(0,0,0), 'PoisonGas');
			loc = Owner.Location;
			rot = Owner.Rotation;
			loc += 2.0 * Owner.CollisionRadius * vector(P.ViewRotation);
			loc.Z += Owner.CollisionHeight * 0.9;
			puff = Spawn(class'SmokeTrail', Owner,, loc, rot);
			if (puff != None)
			{
				puff.DrawScale = 1.0;
				puff.origScale = puff.DrawScale;
			}
			PlaySound(sound'MaleCough');
		}
		UseOnce();
	}
Begin:
}

defaultproperties
{
     bHasMultipleSkins=True
     bBreakable=True
     FragType=Class'DeusEx.PaperFragment'
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Cigarettes"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Cigarettes'
     PickupViewMesh=LodMesh'DeusExItems.Cigarettes'
     ThirdPersonMesh=LodMesh'DeusExItems.Cigarettes'
     Icon=Texture'DeusExUI.Icons.BeltIconCigarettes'
     largeIcon=Texture'DeusExUI.Icons.LargeIconCigarettes'
     largeIconWidth=29
     largeIconHeight=43
     Description="'COUGHING NAILS -- when you've just got to have a cigarette.'"
     beltDescription="CIGS"
     Skin=Texture'HDTPItems.Skins.HDTPCigarettestex1'
     Mesh=LodMesh'DeusExItems.Cigarettes'
     CollisionRadius=5.200000
     CollisionHeight=1.320000
     Mass=2.000000
     Buoyancy=3.000000
}
