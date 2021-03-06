ScriptName SCLSettings Extends Quest
{Holds settings and properties}

Quest Property SCLStartUpQuest Auto

;Settings **********************************************************************
Bool Property EnableFollowerTracking Auto
Bool Property EnableUniqueTracking Auto
Bool Property EnableNPCTracking Auto
Int Property MaxActorTracking Auto
Formlist Property SCL_RejectList Auto
Faction Property PotentialFollowerFaction Auto
Faction Property CurrentFollowerFaction Auto
;Interface Settings ------------------------------------------------------------
GlobalVariable Property SCL_SET_PlayerMessagePOV Auto ;Default 0
Int Property PlayerMessagePOV
  Int Function Get()
    Return SCL_SET_PlayerMessagePOV.GetValueInt()
  EndFunction
  Function Set(Int a_val)
    If a_val >= 0 && a_val <= 3
      SCL_SET_PlayerMessagePOV.SetValueInt(a_val)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCL_SET_ActionKey Auto ;Default 24
Int _ActionKey = 24
Int Property ActionKey
  Int Function Get()
    Int iKey = SCL_SET_ActionKey.GetValueInt()
    If _ActionKey != iKey  ;In case someone changes the global when we aren't looking
      Int KeyModChange = ModEvent.Create("SCLActionKeyChange")
      ModEvent.Send(KeyModChange)
      _ActionKey = iKey
    EndIf
    Return iKey
  EndFunction
  Function Set(Int a_val)
    SCL_SET_ActionKey.SetValueInt(a_val)
    _ActionKey = a_val
    Int KeyModChange = ModEvent.Create("SCLActionKeyChange")
    ModEvent.Send(KeyModChange)
  EndFunction
EndProperty

GlobalVariable Property SCL_SET_StatusKey Auto ;Default 0
Int _StatusKey = 24
Int Property StatusKey
  Int Function Get()
    Int iKey = SCL_SET_StatusKey.GetValueInt()
    If _StatusKey != iKey  ;In case someone changes the global when we aren't looking
      Int KeyModChange = ModEvent.Create("SCLActionKeyChange")
      ModEvent.Send(KeyModChange)
      _StatusKey = iKey
    EndIf
    Return iKey
  EndFunction
  Function Set(Int a_val)
    SCL_SET_StatusKey.SetValueInt(a_val)
    _StatusKey = a_val
    Int KeyModChange = ModEvent.Create("SCLActionKeyChange")
    ModEvent.Send(KeyModChange)
  EndFunction
EndProperty

GlobalVariable Property SCL_SET_PlayerAutoDestination Auto
Bool Property PlayerAutoDestination
  Bool Function Get()
    Return SCL_SET_PlayerAutoDestination.GetValueInt() as Bool
  EndFunction
  Function Set(Bool a_value)
    If a_value
      SCL_SET_PlayerAutoDestination.SetValueInt(1)
    Else
      SCL_SET_PlayerAutoDestination.SetValueInt(0)
    EndIf
  EndFunction
EndProperty
;Debug Modes -------------------------------------------------------------------
GlobalVariable Property SCL_SET_DebugEnable Auto  ;Default 0 (False)
Bool Property DebugEnable
  Bool Function Get()
    Return SCL_SET_DebugEnable.GetValueInt() as Bool
  EndFunction
  Function Set(Bool a_value)
    If a_value
      SCL_SET_DebugEnable.SetValueInt(1)
    Else
      SCL_SET_DebugEnable.SetValueInt(0)
    EndIf
  EndFunction
EndProperty

Bool [] _DMEnableArray
Bool[] Property DMEnableArray
  Bool[] Function Get()
    If !_DMEnableArray
      _DMEnableArray = new Bool[128]
    EndIf
    Return _DMEnableArray
  EndFunction
  Function Set(Bool[] a_val)
    _DMEnableArray = a_val
  EndFunction
EndProperty

Bool Property ShowDebugMessages
  Bool Function Get()
    Return DMEnableArray[0]
  EndFunction
  Function Set(Bool a_value)
    DMEnableArray[0] = a_value
  EndFunction
EndProperty

GlobalVariable Property SCL_SET_GodMode1 Auto ;Default 0 (False)
Bool Property GodMode1
  Bool Function Get()
    Return SCL_SET_GodMode1.GetValueInt() as Bool
  EndFunction
  Function Set(Bool a_value)
    If a_value
      SCL_SET_GodMode1.SetValueInt(1)
    Else
      SCL_SET_GodMode1.SetValueInt(0)
    EndIf
  EndFunction
EndProperty

;Item Process Settings ---------------------------------------------------------
GlobalVariable Property SCL_SET_GlobalDigestMulti Auto ;Default = 1.0
Float Property GlobalDigestMulti
  Float Function Get()
    Return SCL_SET_GlobalDigestMulti.GetValue()
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      SCL_SET_GlobalDigestMulti.SetValue(a_val)
    EndIf
  EndFunction
EndProperty


GlobalVariable Property  SCL_SET_AdjBaseMulti Auto  ;Default 1.0
Float Property AdjBaseMulti
  Float Function Get()
    Return SCL_SET_AdjBaseMulti.GetValue()
  EndFunction
  Function Set(Float a_val)
    If a_val > 0
      SCL_SET_AdjBaseMulti.SetValue(a_val)
    EndIf
  EndFunction
EndProperty

;Expansion Settings ------------------------------------------------------------
GlobalVariable Property SCL_SET_DefaultExpandTimer Auto ;Default 2
Float Property DefaultExpandTimer
  Float Function Get()
    Return SCL_SET_DefaultExpandTimer.GetValue()
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      SCL_SET_DefaultExpandTimer.SetValue(a_val)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCL_SET_DefaultExpandBonus Auto ;Default 0.5
Float Property DefaultExpandBonus
  Float Function Get()
    Return SCL_SET_DefaultExpandBonus.GetValue()
  EndFunction
  Function Set(Float a_val)
    SCL_SET_DefaultExpandBonus.SetValue(a_val)
  EndFunction
EndProperty

;Update Timing Settings --------------------------------------------------------
GlobalVariable Property SCL_SET_UpdateRate Auto ;Default 10
Float Property UpdateRate
  Float Function Get()
    Return SCL_SET_UpdateRate.GetValue()
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      SCL_SET_UpdateRate.SetValue(a_val)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCL_SET_UpdateDelay Auto ;Default 0.5
Float Property UpdateDelay
  Float Function Get()
    Return SCL_SET_UpdateDelay.GetValue()
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      SCL_SET_UpdateDelay.SetValue(a_val)
    EndIf
  EndFunction
EndProperty

;Inflation Settings ------------------------------------------------------------
String[] Property InflateMethodArray Auto

GlobalVariable Property SCL_SET_BellyInflateMethod Auto ;Default 0
Int Property BellyInflateMethod
  Int Function Get()
    Return SCL_SET_BellyInflateMethod.GetValueInt()
  EndFunction
  Function Set(Int a_val)
    SCL_SET_BellyInflateMethod.SetValueInt(a_val)
  EndFunction
EndProperty

Float Property BellyMax
  Float Function Get()
    Return JDB.solveFlt(".SCLExtraData.SCLBellyInflateData.Maximum")
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      If a_val < BellyMin
        BellyMin = a_val
      EndIf
      JDB.solveFltSetter(".SCLExtraData.SCLBellyInflateData.Maximum", a_val, True)
    EndIf
  EndFunction
EndProperty

Float Property BellyMin
  Float Function Get()
    Return JDB.solveFlt(".SCLExtraData.SCLBellyInflateData.Minimum")
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      If a_val > BellyMax
        BellyMax = a_val
      EndIf
      JDB.solveFltSetter(".SCLExtraData.SCLBellyInflateData.Minimum", a_val, True)
    EndIf
  EndFunction
EndProperty

Float Property BellyMulti
  Float Function Get()
    Return JDB.solveFlt(".SCLExtraData.SCLBellyInflateData.Multiplier")
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      JDB.solveFltSetter(".SCLExtraData.SCLBellyInflateData.Multiplier", a_val, True)
    EndIf
  EndFunction
EndProperty

Float Property BellyIncr
  Float Function Get()
    Return JDB.solveFlt(".SCLExtraData.SCLBellyInflateData.Increment")
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      JDB.solveFltSetter(".SCLExtraData.SCLBellyInflateData.Increment", a_val, True)
    EndIf
  EndFunction
EndProperty

Float Property BellyHighScale
  Float Function Get()
    Return JDB.solveFlt(".SCLExtraData.SCLBellyInflateData.HighScale")
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      JDB.solveFltSetter(".SCLExtraData.SCLBellyInflateData.HighScale", a_val, True)
    EndIf
  EndFunction
EndProperty

Float Property BellyCurve
  Float Function Get()
    Return JDB.solveFlt(".SCLExtraData.SCLBellyInflateData.Curve")
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      JDB.solveFltSetter(".SCLExtraData.SCLBellyInflateData.Curve", a_val, True)
    EndIf
  EndFunction
EndProperty

Float Property DynEquipModifier
  Float Function Get()
    Return JDB.solveFlt(".SCLExtraData.SCLBellyInflateData.DynEquipMultiplier")
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      JDB.solveFltSetter(".SCLExtraData.SCLBellyInflateData.DynEquipMultiplier", a_val, True)
    EndIf
  EndFunction
EndProperty

Float Property DynMinSize
  Float Function Get()
    Return JDB.solveFlt(".SCLExtraData.SCLBellyInflateData.DynMinSize")
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      JDB.solveFltSetter(".SCLExtraData.SCLBellyInflateData.DynMinSize", a_val, True)
    EndIf
  EndFunction
EndProperty


;Mod Checks --------------------------------------------------------------------
Bool Property UIExtensionsInstalled Auto
Bool Property HideUIEWarning Auto

Bool Property NiOverrideInstalled Auto
Bool Property HideNiOverrideWarning Auto

Bool Property FNIS_Initialized Auto

;Dummy Items -------------------------------------------------------------------
;Marked as "Not Food"
Potion Property SCL_DummyNotFoodSmall Auto
Potion Property SCL_DummyNotFoodMedium Auto
Potion Property SCL_DummyNotFoodLarge Auto

;Others ************************************************************************
Container Property SCL_TransferBase Auto

;Vomit Properties
Container Property SCL_VomitBase Auto
Container Property SCL_VomitLeveledBase Auto
Spell Property SCL_VomitDamageSpell Auto
MagicEffect Property SCL_VomitDamageEffect Auto

;Cell References
ObjectReference Property SCL_HoldingCell Auto
Actor Property ActorMenuTarget Auto
Keyword Property SCL_DynEquip Auto
FormList Property SCL_EquipmentSetKeywords Auto

String Property ContainerTrashKey = "SCLContainerCleanup" Auto

Spell[] Property SCL_OverfullSpellArray Auto

Spell[] Property SCL_HeavySpeedArray Auto

Spell[] Property SCL_StoredDamageArray Auto
MiscObject Property SCL_ItemBundle Auto

ObjectReference Property SCL_TransferChest Auto
;Perks

Formlist Property TrackingSpellList Auto
FormList Property TrackingDispelList Auto
FormList Property SCL_ItemFormlistSearch Auto
FormList Property SCL_ItemKeywordSearch Auto

Quest Property SCL_MonitorManagerQuest Auto
Quest Property SCL_MonitorFinderQuest Auto
Quest Property SCL_MonitorCycleQuest Auto

Form[] Property LoadedActors Auto
Form[] Property TeammatesList Auto

Message Property SCL_ContentsMenuMessage Auto
Message Property SCL_MES_TakePerk Auto
SCLAddItemThreadManager Property ItemThreadManager Auto
SCLEditBodyThreadManager Property EditBodyThreadManager Auto
SCLDigestThreadManager Property DigestThreadManager Auto
SCLActorEatThreadManager Property ActorEatThreadManager Auto

Keyword Property LocTypeInn Auto
Keyword Property LocTypeHabitationHasInn Auto
Package Property Eat Auto
MagicEffect Property  AlchRestoreHealth Auto
MagicEffect Property  AlchRestoreHealthAll Auto

MagicEffect Property  AlchRestoreMagicka Auto
MagicEffect Property  AlchRestoreMagickaAll Auto

MagicEffect Property  AlchRestoreStamina Auto
MagicEffect Property  AlchRestoreStaminaAll Auto

Idle Property IdleEatSoup Auto
Idle Property IdleDrink Auto
Idle Property IdleDrinkPotion Auto
Perk Property Haggling80 Auto
Perk Property Haggling60 Auto
Perk Property Haggling40 Auto
Perk Property Haggling20 Auto
Perk Property Haggling00 Auto
Perk Property Allure Auto

;AI Package Spells
Spell Property SCL_AIFindFoodSpell01a Auto  ;Causes actor to search for food nearby
Spell Property SCL_AIFindFoodSpell01b Auto  ;Will allow actor to steal food
Spell Property SCL_AIFindFoodSpellStop01 Auto ;Dispels the above two

Spell Property SCL_AIEatFoodAnim01 Auto     ;Actor will perform eat animation
Spell Property SCL_AIDrinkAnim01 Auto       ;Actor will perform drink animation
Spell Property SCL_AIDrinkPotionAnim01 Auto ;Actor will perform drink potion animation
Spell Property SCL_AIEatDrinkStop01 Auto    ;Stops the above

Package Property SCL_HoldPackage Auto
;/ChairEatingSoupStart
IdleBarDrinkingStart
IdleCannibalFeedCrouching_Loose
IdleCannibalFeedStanding_Loose
IdleDrink
IdleDrinkPotion
IdleEatSoup
IdleMQ201Drink
IdleSearchBody
IdleSearchingChest
IdleSearchingTable
IdleTableDrinkAndMugEnterLoose
IdleTableDrinkEnterLoose
IdleTableMugEnterLoose
IdleTablePassOutEnterLoose
LooseFullBodyStagger
VampireFeedingBedLeft_Loose
VampireFeedingBedRight_Loose
VampireFeedingBedRollLeft_Loose
VampireFeedingBedRollRight_Loose/;
;Reference JObjects ************************************************************
Int Property JI_WM_Actor Auto
Int Property JI_ItemTypes Auto
Int Property JM_TotalValueList Auto
Int Property JA_BellyValuesList Auto
Int Property JM_Messages Auto
Int Property JA_ReloadList Auto
Int Property JA_LibraryList Auto
Int Property JM_PerkIDs Auto
Int Property JM_DynMorphList Auto
Int Property JM_BellyInflateData Auto
Int Property JM_AggregateValues Auto
Int Property JM_BaseArchetypes
  Int Function Get()
    Int J = JDB.solveObj(".SCLExtraData.ItemArchetypes")
    If !J
      J = JMap.object()
      JDB.solveObjSetter(".SCLExtraData.ItemArchetypes", J, True)
    EndIf
    Return J
  EndFunction
EndProperty

;AutoEat Properties ************************************************************
GlobalVariable Property SCL_SET_AutoEat_Active Auto
Bool Property AutoEatActive
  Bool Function Get()
    Return SCL_SET_AutoEat_Active.GetValueInt() as Bool
  EndFunction

  Function Set(Bool a_val)
    If a_val
      SCL_SET_AutoEat_Active.SetValueInt(1)
    Else
      SCL_SET_AutoEat_Active.SetValueInt(0)
    EndIf
  EndFunction
EndProperty


;WF Properties *****************************************************************
GlobalVariable Property SCL_SET_WF_Active Auto
Bool Property WF_NeedsActive
  Bool Function Get()
    Return SCL_SET_WF_Active.GetValueInt() as Bool
  EndFunction

  Function Set(Bool a_val)
    If a_val
      SCL_SET_WF_Active.SetValueInt(1)
    Else
      SCL_SET_WF_Active.SetValueInt(0)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCL_SET_WF_ActionKey Auto ;Default 24
Int _WF_ActionKey = 24
Int Property WF_ActionKey
  Int Function Get()
    Int iKey = SCL_SET_WF_ActionKey.GetValueInt()
    If _WF_ActionKey != iKey  ;In case someone changes the global when we aren't looking
      Int KeyModChange = ModEvent.Create("SCLActionKeyChange")
      ModEvent.Send(KeyModChange)
      _WF_ActionKey = iKey
    EndIf
    Return iKey
  EndFunction
  Function Set(Int a_val)
    SCL_SET_WF_ActionKey.SetValueInt(a_val)
    _WF_ActionKey = a_val
    Int KeyModChange = ModEvent.Create("SCLActionKeyChange")
    ModEvent.Send(KeyModChange)
  EndFunction
EndProperty
Message Property SCL_MES_WF_StorageChoice Auto


;Solids ------------------------------------------------------------------------
GlobalVariable Property SCL_SET_WF_SolidActive Auto
Bool Property WF_SolidActive
  Bool Function Get()
    Return SCL_SET_WF_SolidActive.GetValueInt() as Bool
  EndFunction

  Function Set(Bool a_val)
    If a_val
      SCL_SET_WF_SolidActive.SetValueInt(1)
    Else
      SCL_SET_WF_SolidActive.SetValueInt(0)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCL_SET_WF_SolidAdjBaseMulti Auto ;Default: 1
Float Property WF_SolidAdjBaseMulti
  Float Function Get()
    Return SCL_SET_WF_SolidAdjBaseMulti.GetValue()
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      SCL_SET_WF_SolidAdjBaseMulti.SetValue(a_val)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCL_SET_WF_SolidIllnessBuildUpDecrease Auto
Float Property IllnessBuildUpDecrease
  Float Function Get()
    Return SCL_SET_WF_SolidIllnessBuildUpDecrease.GetValue()
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      SCL_SET_WF_SolidIllnessBuildUpDecrease.SetValue(a_val)
    EndIf
  EndFunction
EndProperty
Spell Property WF_SolidDebuffSpell Auto
Spell[] Property WF_SolidDebuffSpells Auto
Spell[] Property WF_SolidIllnessDebuffSpells Auto
Container Property SCL_WF_RefuseBase Auto
;Liquids -----------------------------------------------------------------------
GlobalVariable Property SCL_SET_WF_LiquidActive Auto
Bool Property WF_LiquidActive
  Bool Function Get()
    Return SCL_SET_WF_LiquidActive.GetValueInt() as Bool
  EndFunction

  Function Set(Bool a_val)
    If a_val
      SCL_SET_WF_LiquidActive.SetValueInt(1)
    Else
      SCL_SET_WF_LiquidActive.SetValueInt(0)
    EndIf
  EndFunction
EndProperty

GlobalVariable Property SCL_SET_WF_LiquidAdjBaseMulti Auto ;Default: 1
Float Property WF_LiquidAdjBaseMulti
  Float Function Get()
    Return SCL_SET_WF_LiquidAdjBaseMulti.GetValue()
  EndFunction
  Function Set(Float a_val)
    If a_val >= 0
      SCL_SET_WF_LiquidAdjBaseMulti.SetValue(a_val)
    EndIf
  EndFunction
EndProperty

Spell Property WF_LiquidDebuffSpell Auto
