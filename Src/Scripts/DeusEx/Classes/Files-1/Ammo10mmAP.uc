//=============================================================================
// Ammo10mm.
//=============================================================================
class Ammo10mmAP extends DeusExAmmo;

function PostBeginPlay()
{
local DeusExPlayer player;

        super.PostBeginPlay();

        player=DeusExPlayer(GetPlayerPawn());

   if ((player != None) && (player.bHardCoreMode == True))
   	{
   	    if (Owner == None)
    	AmmoAmount = 4;  //CyberP: less ammo on hardcore
   	}
}

function bool UseAmmo(int AmountNeeded)
{
	local vector offset, tempvec, X, Y, Z;
	local ShellCasing shell;
	local DeusExWeapon W;

	if (Super.UseAmmo(AmountNeeded))
	{
		GetAxes(Pawn(Owner).ViewRotation, X, Y, Z);
		offset = Owner.CollisionRadius * X + 0.3 * Owner.CollisionRadius * Y;
		tempvec = 0.82 * Owner.CollisionHeight * Z;
		offset.Z += tempvec.Z;
        W = DeusExWeapon(Pawn(Owner).Weapon);
        if (W.Owner.IsA('DeusExPlayer') && DeusExPlayer(W.Owner).bIsCrouching)
        offset.Z -= 4;
       /* if (W.IsA('WeaponPistol'))
        {
        offset.X += 2.5;
        offset.Z += 2.4;
        offset.Y += 4;
        }    */

		// use silent shells if the weapon has been silenced
      if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
      {
         shell = None;
      }
      else
      {
         if ((W != None) && ((W.NoiseLevel < 0.1) || W.bHasSilencer))
            shell = spawn(class'ShellCasingSilent',,, Owner.Location + offset,Pawn(Owner).viewrotation);
         else
            shell = spawn(class'ShellCasing',,, Owner.Location + offset,Pawn(Owner).viewrotation);
      }

		if (shell != None)
		{
			shell.Velocity = (FRand()*90+60) * Y + (20-FRand()*40) * X;
			shell.Velocity.Z = 13 + frand()*10;
		}
		return True;
	}

	return False;
}

defaultproperties
{
     bShowInfo=True
     AmmoAmount=5
     MaxAmmo=160
     ItemName="10mm AP Ammo"
     ItemArticle="some"
     PickupViewMesh=LodMesh'DeusExItems.Ammo10mm'
     Icon=Texture'ShifterEX.Icons.BeltIconAmmo10mmEX'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmo10mm'
     largeIconWidth=44
     largeIconHeight=31
     Description="10mm armour piercing ammo designed to penetrate armour. 10mm AP ammo withstands the shock of attempting to punch through thin armor only due to the very small ammo calibre."
     beltDescription="AP AMMO"
     Skin=Texture'GMDXSFX.Skins.GMDXAmmo10mmAPTex1'
     Mesh=LodMesh'DeusExItems.Ammo10mm'
     CollisionRadius=8.500000
     CollisionHeight=3.770000
     bCollideActors=True
}
