//=============================================================================
// DeusExPickup.
//=============================================================================
class DeusExPickup extends Pickup
	abstract;


//struct SSkinProps
//{
//	var texture showskin;
//	var texture smallIconSkin;
//	var texture largeIconSkin;
//	var string description;
//};

var travel int PickUpList[50];
var bool bHasMultipleSkins;

var() travel int textureSet;




var bool            bBreakable;		// true if we can destroy this item
var class<Fragment> fragType;		// fragments created when pickup is destroyed
var int				maxCopies;		// 0 means unlimited copies

var localized String CountLabel;
var localized String msgTooMany;

//gmdx
var transient bool bIsCloaked;


// ----------------------------------------------------------------------
// Networking Replication
// ----------------------------------------------------------------------

replication
{
	//client to server function
	reliable if ((Role < ROLE_Authority) && (bNetOwner))
		UseOnce;
}

//GMDX cloak weapon
function SetCloak(bool bEnableCloak,optional bool bForce)
{
	if ((Owner==none)||(!Owner.IsA('DeusExPlayer'))) return;
	if (Owner!=none && Owner.IsA('DeusExPlayer'))
	{
	if (bEnableCloak && class'DeusExPlayer'.default.bRadarTran == True &&(!bIsCloaked||bForce))
	{
	  bIsCloaked=true;
	  AmbientGlow=255;
      //Style=STY_Translucent;
	  //ScaleGlow=0.040000;
	}
    else if (bEnableCloak&&(!bIsCloaked||bForce))
	{
		bIsCloaked=true;
		Style=STY_Translucent;
		ScaleGlow=0.040000;
	} else
	if(!bEnableCloak&&(bIsCloaked||bForce))
	{
		bIsCloaked=false;
		class'DeusExPlayer'.default.bRadarTran=false;
		AmbientGlow=default.AmbientGlow;
		Style=default.Style;
		ScaleGlow=default.ScaleGlow;
	}
	}
}

function DropFrom(vector StartLocation)
{
	SetCloak(false,true);
	super.DropFrom(StartLocation);
}

//=============================================================================
// Weapon rendering
// Draw first person view of inventory
simulated event RenderOverlays( canvas Canvas )
{
	if (class'DeusExPlayer'.default.bCloakEnabled&&!bIsCloaked)
	{
		SetCloak(true);
	} else
	if (!class'DeusExPlayer'.default.bCloakEnabled&&bIsCloaked)
	{
		SetCloak(false);
	}

	super.RenderOverlays(Canvas);
}


function HandleMultipleSkins(inventory item, int startcopies)
{
	local int i;

	if(DeusexPickup(item).bHasMultipleSkins)
	{
		while(startcopies < numcopies) //spool through
		{
			i = findnextposition();

			PickUplist[i] = DeusexPickup(item).textureSet;
			textureset = DeusexPickup(item).textureSet;
			SetSkin();
			startcopies++;
		}

	}
}

function UpdateSkinStatus()
{
	if(bHasMultipleSkins)
	{
		if(NumCopies > 0)
			updatecurrentskin();
	}
}

function SupportActor( actor StandingActor )
{
   if (!standingActor.IsA('RubberBullet')) //CyberP:
	StandingActor.SetBase( self );
}

// ----------------------------------------------------------------------
// by dasraiser for GMDX, replace all ref to maxCopies with this :)
// ----------------------------------------------------------------------
function int RetMaxCopies()
{
	return maxCopies;
}
// ----------------------------------------------------------------------
// HandlePickupQuery()
//
// If the bCanHaveMultipleCopies variable is set to True, then we want
// to stack items of this type in the player's inventory.
// ----------------------------------------------------------------------

function bool HandlePickupQuery( inventory Item )
{
	local DeusExPlayer player;
	local Inventory anItem;
	local Bool bAlreadyHas;
	local Bool bResult;
	local int i, startcopies;

	if ( Item.Class == Class )
	{
		player = DeusExPlayer(Owner);
		bResult = False;

		// Check to see if the player already has one of these in
		// his inventory
		anItem = player.FindInventoryType(Item.Class);

		if ((anItem != None) && (bCanHaveMultipleCopies))
		{
			startcopies = NumCopies;
			// don't actually put it in the hand, just add it to the count
			NumCopies += DeusExPickup(item).NumCopies;

			if ((RetMaxCopies()> 0) && (NumCopies > RetMaxCopies()))
			{
				NumCopies = RetMaxCopies();
				player.ClientMessage(msgTooMany);

				// abort the pickup
				return True;
			}

			HandleMultipleSkins(item,startcopies);
			bResult = True;
		}

		if (bResult)
		{
			player.ClientMessage(Item.PickupMessage @ Item.itemArticle @ Item.itemName, 'Pickup');

			// Destroy me!
			// DEUS_EX AMSD In multiplayer, we don't want to destroy the item, we want it to set to respawn
			if (Level.NetMode != NM_Standalone)
				Item.SetRespawn();
			else
				Item.Destroy();
		}
		else
		{
			bResult = Super.HandlePickupQuery(Item);
		}

		// Update object belt text
		if (bResult)
			UpdateBeltText();

		return bResult;
	}

	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

// ----------------------------------------------------------------------
// UseOnce()
//
// Subtract a use, then destroy if out of uses
// ----------------------------------------------------------------------

function UseOnce()
{
	local DeusExPlayer player;

	player = DeusExPlayer(Owner);
	NumCopies--;
	UpdateSkinStatus();

    if (IsA('SoyFood') || IsA('Candybar') || IsA('Sodacan') || IsA('WineBottle') || IsA('VialCrack') || IsA('Liquor40oz') || IsA('LiquorBottle'))
    player.fullUp++;

	if (!IsA('SkilledTool'))
		GotoState('DeActivated');

	if (NumCopies <= 0)
	{
		if (player.inHand == Self)
			player.PutInHand(None);
		Destroy();
	}
	else
	{
		UpdateBeltText();
	}
}

event Bump( Actor Other )
{
local float speed2, mult;
local DeusExPlayer player;

if (Physics == PHYS_None)
return;

player = DeusExPlayer(GetPlayerPawn());

mult = player.AugmentationSystem.GetAugLevelValue(class'AugMuscle');
if (mult == -1.0)
mult = 1.0;

speed2 = VSize(Velocity);

if (speed2 > 900 && !IsA('Flare'))
  if (Other.IsA('Pawn') || Other.IsA('DeusExDecoration') || Other.IsA('DeusExPickup'))
    Other.TakeDamage((2+Mass)*mult,player,Other.Location,0.5*Velocity,'KnockedOut');
}

// ----------------------------------------------------------------------
// UpdateBeltText()
// ----------------------------------------------------------------------

function UpdateBeltText()
{
	local DeusExRootWindow root;

	if (DeusExPlayer(Owner) != None)
	{
		root = DeusExRootWindow(DeusExPlayer(Owner).rootWindow);

		// Update object belt text
		if ((bInObjectBelt) && (root != None) && (root.hud != None) && (root.hud.belt != None))
			root.hud.belt.UpdateObjectText(beltPos);
	}
}

// ----------------------------------------------------------------------
// BreakItSmashIt()
// ----------------------------------------------------------------------

simulated function BreakItSmashIt(class<fragment> FragType, float size)
{
	local int i;
	local DeusExFragment s;
	local DeusExPlayer player;   //CyberP: for screenflash if near extinguisher
    local float dist;            //CyberP: for screenflash if near extinguisher
    local Vector loc;             //CyberP: for extinguisher explode
    local Vector HitLocation, HitNormal, EndTrace;
	local Actor hit;
	local WaterPool pool;

    player = DeusExPlayer(GetPlayerPawn());

    if ((!Region.Zone.bWaterZone) && (IsA('Sodacan') || IsA('WineBottle') || IsA('Liquor40oz') || IsA('LiquorBottle')))
	{
		EndTrace = Location - vect(0,0,20);
		hit = Trace(HitLocation, HitNormal, EndTrace, Location, False);
		pool = spawn(class'WaterPool',,, HitLocation+HitNormal, Rotator(HitNormal));
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        PlaySound(sound'SplashSmall', SLOT_None,3.0,, 1280);
        if (pool != None)
        {
			pool.maxDrawScale = CollisionRadius / 16.0;
            pool.spreadTime = 0.5;
        }
	}

	for (i=0; i<Int(size)+8; i++)
	{
		s = DeusExFragment(Spawn(FragType, Owner));

		if (s != None)
		{
			s.Instigator = Instigator;
			s.CalcVelocity(Velocity,0);
			s.DrawScale = ((FRand() * 0.025) + 0.025) * size; //CyberP: both 0.5
			s.Skin = GetMeshTexture();
		if (IsA('FireExtinguisher') && !Region.Zone.bWaterZone)
			{
			loc = Location;
			loc.X += FRand() * 64;
			loc.Y += FRand() * 64;
			loc.Z += FRand() * 8;
			if (i==0)
            spawn(class'HalonGasLarge');
            if (i==1)
			    AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 756);
			if (i < 3)
			{
            spawn(class'HalonGasLarge', None,, loc);
            }
                if (player!=none && i == 0)
                {
   		        dist = Abs(VSize(player.Location - Location));
                PlaySound(sound'SmallExplosion2', SLOT_None,,, 2048);
                if (dist < 128)
                player.ClientFlash(8, vect(224,224,192));
   		        if (dist < 512)
                player.ClientFlash(1, vect(224,224,192));

            }
			}
			if ((IsA('WineBottle') || IsA('Liquor40oz') || IsA('LiquorBottle')) && (!Region.Zone.bWaterZone))
			{
			spawn(class'WaterSplash2');
			spawn(class'WaterSplash');
            spawn(class'WaterSplash2');
			spawn(class'WaterSplash');
			if (i==1)
			    AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 756);
            }
            // play a good breaking sound for the first fragment
            if (i == 0 && !IsA('Candybar') && !IsA('SoyFood') && !IsA('Sodacan') && !IsA('Cigarettes') && !IsA('FireExtinguisher'))
				s.PlaySound(sound'GlassBreakSmall', SLOT_None,,, 768);
		}
	}

	Destroy();
}

singular function BaseChange()
{
	Super.BaseChange();

	// Make sure we fall if we don't have a base
	if ((base == None) && (Owner == None))
		{
        SetPhysics(PHYS_Falling);
        }
}

// ----------------------------------------------------------------------
// state Pickup
// ----------------------------------------------------------------------

auto state Pickup
{

    function HitWall(vector HitNormal, actor Wall)
	{
		if (VSize(Velocity) > 1200 && bBreakable)
			    TakeDamage((25+Mass),Pawn(Owner),Location,0.5*Velocity,'Shot');
        else if (bBreakable && !IsA('FireExtinguisher') && !IsA('Binoculars') && !IsA('SoyFood') && !IsA('Candybar') && !IsA('Sodacan') && !IsA('Cigarettes'))
			if (VSize(Velocity) > 350 && !IsA('SoftwareStop') && !IsA('SoftwareNuke'))
				BreakItSmashIt(fragType, (CollisionRadius + CollisionHeight) / 2);
	}
	// if we hit the ground fast enough, break it, smash it!!!
	function Landed(Vector HitNormal)
	{
	local rotator newRot;
		Super.Landed(HitNormal);

        if (VSize(Velocity) > 1200 && bBreakable)
			    TakeDamage((25+Mass),Pawn(Owner),Location,0.5*Velocity,'Shot');
        else if (bBreakable && !IsA('FireExtinguisher') && !IsA('Binoculars') && !IsA('SoyFood') && !IsA('Candybar') && !IsA('Sodacan') && !IsA('Cigarettes'))
			if (VSize(Velocity) > 350 && !IsA('SoftwareStop') && !IsA('SoftwareNuke'))
				BreakItSmashIt(fragType, (CollisionRadius + CollisionHeight) / 2);

	}

	function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
        local float dammult, massmult;

		if ((DamageType == 'TearGas') || (DamageType == 'PoisonGas') || (DamageType == 'Radiation'))
			return;

		if ((DamageType == 'EMP') || (DamageType == 'NanoVirus') || (DamageType == 'Shocked'))
			return;

		if (DamageType == 'HalonGas')
			return;

		if (DamageType == 'KnockedOut' && Damage < 11)
            return;

        //if (IsA('VialCrack') || IsA('VialAmbrosia'))
        //{
        //PlaySound(sound'GlassBreakSmall', SLOT_None,,, 768);
        //Destroy();
        //}

        if (bBreakable == False && !IsA('NanoKey'))
    {
    dammult = damage*0.1;
    if (dammult < 1.1)
    dammult = 1.1;
    else if (dammult > 15)
    dammult = 15;  //capped so objects do not fly about at light speed.


    if (mass < 10)
    massmult = 1.2;
    else if (mass < 20)
    massmult = 1.1;
    else if (mass < 30)
    massmult = 1;
    else if (mass < 50)
    massmult = 0.7;
    else if (mass < 80)
    massmult = 0.4;
    else
    massmult = 0.2;

    SetPhysics(PHYS_Falling);
    Velocity = (Momentum*0.25)*dammult*massmult;
    if (Velocity.Z < 0)
    Velocity.Z = 120;
    bFixedRotationDir = True;
	RotationRate.Pitch = (32768 - Rand(65536)) * 4.0;
	RotationRate.Yaw = (32768 - Rand(65536)) * 4.0;
    }

		if (bBreakable)
		{
   	        BreakItSmashIt(fragType, (CollisionRadius + CollisionHeight) / 2);
        }
        else
        return;
    }

	function Frob(Actor Other, Inventory frobWith)
	{
		pickuplist[0] = textureset;    //doublecheck

		super.Frob(other, frobwith);
	}
}

state DeActivated
{
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local string str;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.SetTitle(itemName);
	winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());

	if (bCanHaveMultipleCopies)
	{
		// Print the number of copies
		str = CountLabel @ String(NumCopies);
		winInfo.AppendText(str);
	}

	return True;
}

// ----------------------------------------------------------------------
// PlayLandingSound()
// ----------------------------------------------------------------------

function PlayLandingSound()
{
	if (LandSound != None)
	{
		if (Velocity.Z <= -170)
		{
			PlaySound(LandSound, SLOT_None, TransientSoundVolume,, 768);
			AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 512+(Mass*3)); //CyberP: mass factors into radi
		}
	}
}


//function prebeginplay()
//{
//	local int i;
//	//initialise our list
//	if(bhasMultipleSkins)
//	{
//		pickupList[0] = textureset;
//		for(i=1;i<arraycount(pickuplist);i++)
//		{
//			pickuplist[i] = -1;
//		}
//
//	}
//
//
//	super.prebeginplay();
//}


//function AddtoPickupList(deusexpickup item, int startnum)
//{
//	local int i;
//
//	for(i=startnum;i<numcopies;i++)
//	{
//		pickupList[i] = item.Textureset;
//	}
//	textureset = pickupList[i];
//	//dumptexturelist();
//	SetSkin();
//}

function UpdateCurrentSkin()
{
	textureset = pickuplist[numcopies-1];
	pickuplist[numcopies] = -1;
	SetSkin();
}

function int findNextPosition()
{
	local int i;

	for(i=0;i<arraycount(pickuplist);i++)
	{
		if(pickuplist[i] == -1)
			return i;
	}
	log("failed to find valid postion");
	return 0;
}


function dumptexturelist() //testing function coz I is teh STOOPID today. Or something. I blame stress :)   -DDL
{
	local int i;

	log("dumping list!",name);
	for(i=0;i<arraycount(pickuplist);i++)
	{
		if(pickuplist[i] != -1)
			log("My pickuplist"@i@"setting is"@pickuplist[i],name);
	}
}

function BeginPlay()
{
	Super.BeginPlay();

	setSkin();
}

function SetSkin()
{
//	if(bHasMultipleSkins)
//		dumptexturelist();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     PickUpList(0)=-1
     PickUpList(1)=-1
     PickUpList(2)=-1
     PickUpList(3)=-1
     PickUpList(4)=-1
     PickUpList(5)=-1
     PickUpList(6)=-1
     PickUpList(7)=-1
     PickUpList(8)=-1
     PickUpList(9)=-1
     PickUpList(10)=-1
     PickUpList(11)=-1
     PickUpList(12)=-1
     PickUpList(13)=-1
     PickUpList(14)=-1
     PickUpList(15)=-1
     PickUpList(16)=-1
     PickUpList(17)=-1
     PickUpList(18)=-1
     PickUpList(19)=-1
     PickUpList(20)=-1
     PickUpList(21)=-1
     PickUpList(22)=-1
     PickUpList(23)=-1
     PickUpList(24)=-1
     PickUpList(25)=-1
     PickUpList(26)=-1
     PickUpList(27)=-1
     PickUpList(28)=-1
     PickUpList(29)=-1
     PickUpList(30)=-1
     PickUpList(31)=-1
     PickUpList(32)=-1
     PickUpList(33)=-1
     PickUpList(34)=-1
     PickUpList(35)=-1
     PickUpList(36)=-1
     PickUpList(37)=-1
     PickUpList(38)=-1
     PickUpList(39)=-1
     PickUpList(40)=-1
     PickUpList(41)=-1
     PickUpList(42)=-1
     PickUpList(43)=-1
     PickUpList(44)=-1
     PickUpList(45)=-1
     PickUpList(46)=-1
     PickUpList(47)=-1
     PickUpList(48)=-1
     PickUpList(49)=-1
     FragType=Class'DeusEx.GlassFragment'
     CountLabel="x"
     msgTooMany="You can't carry any more of those"
     NumCopies=1
     PickupMessage="You found"
     ItemName="DEFAULT PICKUP NAME - REPORT THIS AS A BUG"
     RespawnTime=30.000000
     LandSound=Sound'DeusExSounds.Generic.PaperHit1'
     bProjTarget=True
}
