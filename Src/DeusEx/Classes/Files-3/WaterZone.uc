//=============================================================================
// WaterZone
//=============================================================================
class WaterZone expands ZoneInfo;

// When an actor enters this zone.
event ActorEntered( actor Other )
{
	local actor A;
	local vector AddVelocity, offset;
    local int i;
    local WaterRing ring;

    offset = Other.Location;

    if (Other.IsA('Fireball'))
        return;

    if (Other.IsA('Tracer') || (Other.IsA('DeusExProjectile') && Other.Owner != None && !Other.Owner.Region.Zone.bWaterZone)) //CyberP: Ha! No need to go to Yuki lengths.
    {
       offset.Z += 13;
       ring = spawn(class'WaterRing',,,offset);
       if (ring != none)
       {
         if (FRand() < 0.1)
         ring.PlaySound(sound'Bulletwater1',SLOT_None,1.5,,1024);
         else
         {
         ring.PlaySound(sound'Bulletwater4',SLOT_None,1.5,,1024);
         ring.bScaleOnce=True;
         }
       }
         spawn(class'WaterSplash',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
    }

	if ( bNoInventory && Other.IsA('Inventory') && (Other.Owner == None) )
	{
		Other.LifeSpan = 1.5;
		return;
	}

	if( Pawn(Other)!=None && Pawn(Other).bIsPlayer )
		if( ++ZonePlayerCount==1 && ZonePlayerEvent!='' )
			foreach AllActors( class 'Actor', A, ZonePlayerEvent )
				A.Trigger( Self, Pawn(Other) );

	if ( bMoveProjectiles && (ZoneVelocity != vect(0,0,0)) )
	{
		if ( Other.Physics == PHYS_Projectile )
			Other.Velocity += ZoneVelocity;
		else if ( Other.IsA('Effects') && (Other.Physics == PHYS_None) )
		{
			Other.SetPhysics(PHYS_Projectile);
			Other.Velocity += ZoneVelocity;
		}
	}
}

defaultproperties
{
     EntrySound=Sound'DeusExSounds.Generic.SplashMedium'
     ExitSound=Sound'DeusExSounds.Generic.WaterOut'
     EntryActor=Class'DeusEx.WaterRing'
     ExitActor=Class'DeusEx.WaterRing'
     bWaterZone=True
     ViewFog=(Y=0.050000,Z=0.100000)
     SoundRadius=0
     AmbientSound=Sound'Ambient.Ambient.Underwater'
}
