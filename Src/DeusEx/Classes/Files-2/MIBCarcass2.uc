//=============================================================================
// MIBCarcass2.
//=============================================================================
class MIBCarcass2 extends DeusExCarcass;

function ChunkUp(int Damage)
{
   Explode();
   Destroy();
}

//gmdx: taken from wib pawn
function Explode()
{
	local SphereEffect sphere;
	local ScorchMark s;
	local ExplosionLight light;
	local int i;
	local float explosionDamage;
	local float explosionRadius;
	local vector loc;
    local FleshFragment chunk;

	explosionDamage = 110;
	explosionRadius = 288;

	// alert NPCs that I'm exploding
	AISendEvent('LoudNoise', EAITYPE_Audio, , explosionRadius*16);
	PlaySound(Sound'LargeExplosion1', SLOT_None,,, explosionRadius*16);

	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, Location);
	if (light != None)
		light.size = 4;

	Spawn(class'ExplosionSmall',,, Location + 2*VRand()*CollisionRadius);
	Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);
	Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);
	Spawn(class'ExplosionLarge',,, Location + 2*VRand()*CollisionRadius);

	sphere = Spawn(class'SphereEffect',,, Location);
	if (sphere != None)
		sphere.size = explosionRadius / 32.0;

	// spawn a mark
	s = spawn(class'ScorchMark', Base,, Location-vect(0,0,1)*CollisionHeight, Rotation+rot(16384,0,0));
	if (s != None)
	{
		s.DrawScale *= FClamp(explosionDamage/30, 0.1, 3.0);
		s.ReattachDecal();
	}

    loc.X = (1-2*FRand()) * CollisionRadius;
    loc.Y = (1-2*FRand()) * CollisionRadius;
    loc.Z = (1-2*FRand()) * CollisionHeight;
    loc += Location;
	//CyberP: messy gore
	for (i=0; i<22; i++)
	{
				spawn(class'BloodDropFlying');
				chunk = spawn(class'FleshFragment', None,, loc);
                if (chunk != None)
				{
				    if (FRand() < 0.85)
                    chunk.Velocity.Z = FRand() * 410 + 410;

					chunk.bFixedRotationDir = False;
					chunk.RotationRate = RotRand();
				}
    }
    HurtRadius(explosionDamage, explosionRadius, 'Exploded', explosionDamage*100, Location);
}

defaultproperties
{
     Mesh2=LodMesh'DeusExCharacters.GM_Suit_CarcassB'
     Mesh3=LodMesh'DeusExCharacters.GM_Suit_CarcassC'
     Mesh=LodMesh'DeusExCharacters.GM_Suit_Carcass'
     DrawScale=1.100000
     MultiSkins(0)=Texture'DeusExCharacters.Skins.GuntherHermannTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.PantsTex5'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.MIBTex0'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.MIBTex1'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.MIBTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.FramesTex2'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.LensesTex3'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=44.000000
     CollisionHeight=7.700000
}
