//=============================================================================
// WeaponMiniCrossbow.
//=============================================================================
class WeaponMiniCrossbow extends DeusExWeapon;

var vector axesX;//fucking weapon rotation fix
var vector axesY;
var vector axesZ;
var DeusExPlayer player;
var bool bFlipFlopCanvas;
var bool bGEPjit;
var float GEPinout;
var bool bGEPout;
var vector MountedViewOffset;
var float scopeTime;

function texture GetWeaponHandTex()
{
	local deusexplayer p;
	local texture tex;

	tex = texture'MiniCrossbowTex1';

	p = deusexplayer(owner);
	if(p != none)
	{
		switch(p.PlayerSkin)
		{
			//default, black, latino, ginger, albino, respectively
			case 0: tex = texture'MiniCrossbowTex1'; break;
			case 1: tex = texture'HDTPItems.skins.crossbowhandstexblack'; break;
			case 2: tex = texture'HDTPItems.skins.crossbowhandstexlatino'; break;
			case 3: tex = texture'HDTPItems.skins.crossbowhandstexginger'; break;
			case 4: tex = texture'HDTPItems.skins.crossbowhandstexalbino'; break;
		}
	}

	return tex;
}

simulated function renderoverlays(Canvas canvas)
{
    local rotator rfs;
	local vector dx;
	local vector dy;
	local vector dz;
	local vector		DrawOffset, WeaponBob;
	local vector unX,unY,unZ;

	Multiskins[0] = getweaponhandtex();
	Multiskins[1] = none;

	if ((AmmoType != None) && (AmmoType.AmmoAmount > 0) && (ClipCount < ReloadCount))
	{
		if(AmmoType.isA('AmmoDartPoison'))
			Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex2';
		else if(Ammotype.isA('AmmoDartFlare'))
			Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex3';
		else if(Ammotype.isA('AmmoDartTaser'))
		    Multiskins[2] = texture'HDTPItems.Skins.HDTPAmmoProdTex1';
		else
			Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex1';
	}
	else
		Multiskins[2] = texture'pinkmasktex';
	if(bHasScope)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[4] = none;
	else
		multiskins[4] = texture'pinkmasktex';
	if(bLasing)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';

	super.renderoverlays(canvas); //(weapon)

	multiskins[0] = none;

	if ((AmmoType != None) && (AmmoType.AmmoAmount > 0) && (ClipCount < ReloadCount))
	{
		if(AmmoType.isA('AmmoDartPoison'))
			Multiskins[1] = texture'HDTPItems.skins.HDTPminicrossbowtex2';
		else if(Ammotype.isA('AmmoDartFlare'))
			Multiskins[1] = texture'HDTPItems.skins.HDTPminicrossbowtex3';
		else
			Multiskins[1] = texture'HDTPItems.skins.HDTPminicrossbowtex1';
	}
	else
		Multiskins[1] = texture'pinkmasktex';
   if(bHasScope)
      multiskins[2] = none;
   else
      multiskins[2] = texture'pinkmasktex';
   if(bHasLaser)
      multiskins[3] = none;
   else
      multiskins[3] = texture'pinkmasktex';
   if(bLasing)
      multiskins[4] = none;
   else
      multiskins[4] = texture'pinkmasktex';

    if (activateAn == True)
    {
	if(!bGEPout)
	{
		if (GEPinout<1) GEPinout=Fmin(1.0,GEPinout+0.04);
	} else
		if (GEPinout<1) GEPinout=Fmax(0,GEPinout-0.04);//do Fmax(0,n) @ >0<=1

	rfs.Yaw=2912*Fmin(1.0,GEPinout);
	rfs.Pitch=-62912*sin(Fmin(1.0,GEPinout)*Pi);
	GetAxes(rfs,axesX,axesY,axesZ);
/*
	if(!bStaticFreeze)
	{
*/
    player = DeusExPlayer(Owner);

	dx=axesX>>player.ViewRotation;
	dy=axesY>>player.ViewRotation;
	dz=axesZ>>player.ViewRotation;
	rfs=OrthoRotation(dx,dy,dz);

	SetRotation(rfs);

	PlayerViewOffset=Default.PlayerViewOffset*100;//meh
	SetHand(player.Handedness); //meh meh

    //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkNamesArray[12]== 1)
    //{
	PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
	PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
	PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout*1.25)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
	//}
	//else
	//{
	//PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
	//PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
	//PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
	//}
    //PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);

	//FireOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.X,-MountedViewOffset.X);
	//FireOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.Y,-MountedViewOffset.Y);
	//FireOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.Z,-cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z);

	SetLocation(player.Location+ CalcDrawOffset());
	scopeTime+=1;

	//IsInState('DownWeapon')
    /*
    if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkNamesArray[12]== 1)
    {
	if (scopeTime>=17)
	{
        activateAn = False;
        scopeTime = 0;
        ScopeToggle();
        GEPinout = 0;
        axesX = vect(0,0,0);
        axesY = vect(0,0,0);
        axesZ = vect(0,0,0);
        PlayerViewOffset=Default.PlayerViewOffset*100;
        SetHand(PlayerPawn(Owner).Handedness);
    }
    }  */
    if (scopeTime>=18)
    {
        activateAn = False;
        scopeTime = 0;
        ScopeToggle();
        GEPinout = 0;
        axesX = vect(0,0,0);
        axesY = vect(0,0,0);
        axesZ = vect(0,0,0);
        PlayerViewOffset=Default.PlayerViewOffset*100;
        SetHand(player.Handedness);
    }
    }

}

function BecomePickup()
{
	activateAn = False;
        scopeTime = 0;
        GEPinout = 0;
        axesX = vect(0,0,0);
        axesY = vect(0,0,0);
        axesZ = vect(0,0,0);
        PlayerViewOffset=Default.PlayerViewOffset*100;

	super.BecomePickup();
}

function CheckWeaponSkins()
{
	if(bHasScope)
      multiskins[2] = none;
   else
      multiskins[2] = texture'pinkmasktex';
   if(bHasLaser)
      multiskins[3] = none;
   else
      multiskins[3] = texture'pinkmasktex';
   if(bLasing)
      multiskins[4] = none;
   else
      multiskins[4] = texture'pinkmasktex';
}


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Owner != none && Owner.IsA('ScriptedPawn'))
	{
    ScriptedPawn(Owner).MaxRange = 1300;
	ScriptedPawn(Owner).BaseAccuracy = 0.000000;
	}
}

// pinkmask out the arrow when we're out of ammo or the clip is empty
state NormalFire
{
	function BeginState()
	{
		if(playerpawn(owner) != none) //just in case :)
		{
			if (ClipCount >= ReloadCount)
				MultiSkins[2] = Texture'PinkMaskTex';

			if ((AmmoType != None) && (AmmoType.AmmoAmount <= 0))
				MultiSkins[2] = Texture'PinkMaskTex';
		}
		else //fuck me, A)does this get called by NPCs, and B)would anyone even notice? Fuck it: we do insano-detail here
		{
			if (ClipCount >= ReloadCount)
				MultiSkins[1] = Texture'PinkMaskTex';

			if ((AmmoType != None) && (AmmoType.AmmoAmount <= 0))
				MultiSkins[1] = Texture'PinkMaskTex';
		}
		Super.BeginState();
	}
}

// unpinkmask the arrow when we reload...handled better in renderoverlays? probably yes.
/*
function Tick(float deltaTime)
{
	if(playerpawn(owner) != none)
	{
		if (MultiSkins[2] == texture'pinkmasktex')
			if ((AmmoType != None) && (AmmoType.AmmoAmount > 0) && (ClipCount < ReloadCount))
			{
				if(AmmoType.isA('AmmoDartPoison'))
					Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex2';
				else if(Ammotype.isA('AmmoDartFlare'))
					Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex3';
				else
					Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex1';
			}
	}

	Super.Tick(deltaTime);
}
*/

state DownWeapon
{
	function EndState()
	{
	    Super.EndState();
	    activateAn = False;
        scopeTime = 0;
        GEPinout = 0;
        axesX = vect(0,0,0);
        axesY = vect(0,0,0);
        axesZ = vect(0,0,0);
        PlayerViewOffset=Default.PlayerViewOffset*100;
        if (Owner.IsA('DeusExPlayer'))
        SetHand(DeusExPlayer(Owner).Handedness);
	}
}

defaultproperties
{
     MountedViewOffset=(X=12.000000,Y=0.100000,Z=-65.500000)
     LowAmmoWaterMark=3
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     Concealability=CONC_All
     ShotTime=0.465000
     reloadTime=3.000000
     HitDamage=24
     maxRange=3200
     AccurateRange=1600
     BaseAccuracy=0.800000
     bCanHaveScope=True
     ScopeFOV=30
     bCanHaveLaser=True
     bHasSilencer=True
     AmmoNames(0)=Class'DeusEx.AmmoDartPoison'
     AmmoNames(1)=Class'DeusEx.AmmoDart'
     AmmoNames(2)=Class'DeusEx.AmmoDartFlare'
     AmmoNames(3)=Class'DeusEx.AmmoDartTaser'
     ProjectileNames(0)=Class'DeusEx.DartPoison'
     ProjectileNames(1)=Class'DeusEx.Dart'
     ProjectileNames(2)=Class'DeusEx.DartFlare'
     ProjectileNames(3)=Class'DeusEx.DartTaser'
     StunDuration=10.000000
     bHasMuzzleFlash=False
     recoilStrength=0.630000
     mpReloadTime=0.500000
     mpHitDamage=30
     mpBaseAccuracy=0.100000
     mpAccurateRange=2000
     mpMaxRange=2000
     mpReloadCount=6
     mpPickupAmmoCount=6
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     FireSilentSound=Sound'DeusExSounds.Weapons.MiniCrossbowFire'
     RecoilShaker=(X=2.500000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     bCanHaveModFullAuto=True
     negTime=0.565000
     AmmoName=Class'DeusEx.AmmoDartPoison'
     ReloadCount=4
     PickupAmmoCount=4
     FireOffset=(X=-25.000000,Y=8.000000,Z=14.000000)
     ProjectileClass=Class'DeusEx.DartPoison'
     shakemag=200.000000
     FireSound=Sound'DeusExSounds.Weapons.MiniCrossbowFire'
     AltFireSound=Sound'DeusExSounds.Weapons.MiniCrossbowReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.MiniCrossbowReload'
     SelectSound=Sound'DeusExSounds.Weapons.MiniCrossbowSelect'
     Misc1Sound=Sound'DeusExSounds.Special.Switch1Click'
     InventoryGroup=9
     ItemName="Mini-Crossbow"
     PlayerViewOffset=(X=25.000000,Y=-8.000000,Z=-14.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPMiniCrossbow'
     PickupViewMesh=LodMesh'HDTPItems.HDTPminicrossbowPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPminicrossbow3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconCrossbow'
     largeIcon=Texture'DeusExUI.Icons.LargeIconCrossbow'
     largeIconWidth=47
     largeIconHeight=46
     Description="The mini-crossbow was specifically developed for espionage work, and accepts a range of dart types (normal, tranquilizer, or flare) that can be changed depending upon the mission requirements."
     beltDescription="CROSSBOW"
     Mesh=LodMesh'HDTPItems.HDTPminicrossbowPickup'
     MultiSkins(2)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(3)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=8.000000
     CollisionHeight=1.000000
     Mass=15.000000
}
