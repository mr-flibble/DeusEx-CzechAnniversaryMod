//=============================================================================
// MedKit.
//=============================================================================
class SoftwareNuke extends DeusExPickup;

// ----------------------------------------------------------------------



// ----------------------------------------------------------------------

defaultproperties
{
     bBreakable=True
     FragType=Class'DeusEx.PlasticFragment'
     maxCopies=15
     bCanHaveMultipleCopies=True
     ItemName="NUKE Virus Software"
     PlayerViewOffset=(X=26.000000,Z=-12.000000)
     PickupViewMesh=LodMesh'DeusExDeco.Keypad3'
     PickupViewScale=0.400000
     ThirdPersonMesh=LodMesh'DeusExDeco.Keypad3'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Icon=Texture'GMDXSFX.Skins.NukeBelt'
     largeIcon=Texture'GMDXSFX.Skins.NukeLarge'
     largeIconWidth=32
     largeIconHeight=32
     Description="Hacking Software. A virus that shuts down the local network firewall, enabling the user to attempt to hack systems above their skill level. The firewall will become active again once the user logs out."
     beltDescription="NUKEVIRUS"
     Physics=PHYS_None
     Rotation=(Pitch=16400)
     Skin=Texture'GMDXSFX.2027Misc.MinidiskTex1'
     Mesh=LodMesh'DeusExDeco.Keypad3'
     DrawScale=0.400000
     CollisionRadius=3.000000
     CollisionHeight=0.500000
     Mass=4.000000
     Buoyancy=8.000000
     DesiredRotation=(Pitch=16400)
}
