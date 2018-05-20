ScriptName SCLDatabase Extends Quest

;*******************************************************************************
;Variables and Properties
;*******************************************************************************
String ScriptID = "SCLData"
SCLibrary Property SCLib Auto
SCLSettings Property SCLSet Auto
Bool Property Dawnguard_Initialized Auto
Bool Property HearthFires_Initialized Auto
Bool Property Dragonborn_Initialized Auto
Bool Property iNeed_Initialized Auto
Bool Property Hunterborn_Initialized Auto
Bool Property Frostfall_Initialized Auto
Bool SCLResetted = False

Event OnSCLReset()
  SCLResetted = True
  resetLibraryData()
EndEvent

Function resetLibraryData()
  SCLSet.JI_WM_Actor = 0
  SCLSet.JI_ItemTypes = 0
  SCLSet.JM_TotalValueList = 0
  SCLSet.JA_BellyValuesList = 0
  SCLSet.JM_Messages = 0
  SCLSet.JA_ReloadList = 0
EndFunction

Bool Property DatabaseInitialized Auto
Event OnInit()
  SCLibrary.addToReloadList(Self)
  setDatabase()
EndEvent

Int ScriptVersion = 1
Int Function GetStage()
  Int StoredVersion = JDB.solveInt(".SCLExtraData.VersionRecords.SCLItemDatabase")
  If SCLResetted
    setDatabase()
    SCLResetted = False
  ElseIf ScriptVersion != StoredVersion
    setDatabase()
    JDB.solveIntSetter(".SCLExtraData.VersionRecords.SCLItemDatabase", ScriptVersion, True)
  Else
    setupInstalledMods()
  EndIf
  RegisterForModEvent("SCLReset", "OnSCLReset")
  Return Parent.GetStage()
EndFunction

Function setDatabase()
  DatabaseInitialized = False
  setupReloadSystems()
  setupActorData()
  setupLibraryList()
  setupActorMainMenus()
  setupItemTypes()
  setupPerksList()
  setupBellyValues()
  setupTotalValues()
  setupAggregateValues()
  ;setupDynMorphList()
  setupEditBodyEntries()
  setupMessages()
  setupItemDatabase()
  setupInstalledMods()
  RegisterForModEvent("SCLReset", "OnSCLReset")
  Int SetDatabaseEvent = ModEvent.create("SCLDatabaseSetup")  ;Sends out an event for other scripts to modify database as needed
  ModEvent.Send(SetDatabaseEvent)
  DatabaseInitialized = True
EndFunction

Function setupReloadSystems()
  If !SCLSet.JA_ReloadList
    SCLSet.JA_ReloadList = JArray.object()
    JDB.solveObjSetter(".SCLExtraData.ReloadList", SCLSet.JA_ReloadList, True)
    SCLibrary.addToReloadList(Self)
  EndIf
EndFunction

Function setupActorData()
  If !JDB.solveObj(".SCLActorData")
    JDB.setObj("SCLActorData", JFormMap.object())
  EndIf
EndFunction

Function setupLibraryList()
  If !SCLSet.JA_LibraryList
    SCLSet.JA_LibraryList = JArray.object()
    JDB.solveObjSetter(".SCLExtraData.LibraryList", SCLSet.JA_LibraryList, True)
  EndIf
EndFunction

Function setupActorMainMenus()
  If !SCLSet.JI_WM_Actor
    SCLSet.JI_WM_Actor = JIntMap.object()
    JDB.solveObjSetter(".SCLExtraData.ActorMainMenus", SCLSet.JI_WM_Actor, True)
    SCLibrary.addActorMainMenu(0, "SCL Main Menu", True)
  EndIf
EndFunction

Function setupItemTypes()
  If !SCLSet.JI_ItemTypes
    SCLSet.JI_ItemTypes = JIntMap.object()
    JDB.solveObjSetter(".SCLExtraData.ItemTypeMap", SCLSet.JI_ItemTypes, True)
    SCLibrary.addItemType(1, "Digesting", "Food digesting in actor's stomach.", "ContentsFullness1", True)
    SCLibrary.addItemType(2, "Stored", "Items held within the actor's stomach.", "ContentsFullness2", True)
    SCLibrary.addItemType(3, "Breaking Down", "Items breaking down within the actor's colon.", "ContentsFullness3", False)
    SCLibrary.addItemType(4, "Stowed Away", "Items held within the actor's colon.", "ContentsFullness4", False)
  EndIf
EndFunction

Function setupPerksList()
  If !SCLSet.JM_PerkIDs
    SCLSet.JM_PerkIDs = JMap.object()
    JDB.solveObjSetter(".SCLExtraData.PerkIDList", SCLSet.JM_PerkIDs, True)
;/
    ;Room For More ***************************************************************
    Int JA_Desc = JArray.object()
    JArray.addStr(JA_Desc, "Increases base capacity.")
    JArray.addStr(JA_Desc, "Increases base capacity by 2.5.")
    JArray.addStr(JA_Desc, "Increases base capacity by 5.")
    JArray.addStr(JA_Desc, "Increases base capacity by 10.")
    JArray.addStr(JA_Desc, "Increases base capacity by 15.")
    JArray.addStr(JA_Desc, "Increases base capacity by 10%.")

    Int JA_Reqs = JArray.object()
    JArray.addStr(JA_Reqs, "No Requirements")
    JArray.addStr(JA_Reqs, "Digest a total of at least 10 units food.")
    JArray.addStr(JA_Reqs, "Digest a total of at least 25 units food.")
    JArray.addStr(JA_Reqs, "Digest a total of at least 45 units food.")
    JArray.addStr(JA_Reqs, "Digest a total of at least 60 units food.")
    JArray.addStr(JA_Reqs, "Digest a total of at least 90 units food.")

    SCLibrary.addPerkID("SCLRoomForMore", JA_Desc, JA_Reqs)

    ;Storage Limit Up ************************************************************
    JA_Desc = JArray.object()
    JArray.addStr(JA_Desc, "Allows you to store items in your stomach.")
    JArray.addStr(JA_Desc, "Increases item storage by 2.")
    JArray.addStr(JA_Desc, "Increases item storage by 2.")
    JArray.addStr(JA_Desc, "Increases item storage by 2.")
    JArray.addStr(JA_Desc, "Increases item storage by 2.")
    JArray.addStr(JA_Desc, "Increases item storage by 2.")

    JA_Reqs = JArray.object()
    JArray.addStr(JA_Reqs, "No Requirements.")
    JArray.addStr(JA_Reqs, "Have a stomach capacity greater than 25.")
    JArray.addStr(JA_Reqs, "Have a stomach capacity greater than 50.")
    JArray.addStr(JA_Reqs, "Have a stomach capacity greater than 75.")
    JArray.addStr(JA_Reqs, "Have a stomach capacity greater than 115.")
    JArray.addStr(JA_Reqs, "Have a stomach capacity greater than 150.")

    SCLibrary.addPerkID("SCLStoredLimitUp", JA_Desc, JA_Reqs)

    ;Heavy Burden ****************************************************************
    JA_Desc = JArray.object()
    JArray.addStr(JA_Desc, "Allows actor to move freely when their weight is high.")
    JArray.addStr(JA_Desc, "Allows actor to move freely when their weight exceeds " + (100 * (1 + 1)) + ".")
    JArray.addStr(JA_Desc, "Allows actor to move freely when their weight exceeds " + (100 * (2 + 1)) + ".")
    JArray.addStr(JA_Desc, "Allows actor to move freely when their weight exceeds " + (100 * (3 + 1)) + ".")
    JArray.addStr(JA_Desc, "Allows actor to move freely when their weight exceeds " + (100 * (4 + 1)) + ".")
    JArray.addStr(JA_Desc, "Allows actor to move freely when their weight exceeds " + (100 * (5 + 1)) + ".")

    JA_Reqs = JArray.object()
    JArray.addStr(JA_Reqs, "No Requirements.")
    JArray.addStr(JA_Reqs, "Have " + (150 * (1 + 1)) + " units in your stomach at some point and reach level " + (150 * (1 + 1)) / 10 + ".")
    JArray.addStr(JA_Reqs, "Have " + (150 * (2 + 1)) + " units in your stomach at some point and reach level " + (150 * (2 + 1)) / 10 + ".")
    JArray.addStr(JA_Reqs, "Have " + (150 * (3 + 1)) + " units in your stomach at some point and reach level " + (150 * (3 + 1)) / 10 + ".")
    JArray.addStr(JA_Reqs, "Have " + (150 * (4 + 1)) + " units in your stomach at some point and reach level " + (150 * (4 + 1)) / 10 + ".")
    JArray.addStr(JA_Reqs, "Have " + (150 * (5 + 1)) + " units in your stomach at some point and reach level " + (150 * (5 + 1)) / 10 + ".")

    SCLibrary.addPerkID("SCLHeavyBurden", JA_Desc, JA_Reqs)

    ;Allow Overflow ****************************************************************
    JA_Desc = JArray.object()
    JArray.addStr(JA_Desc, "Allows actor to eat above the maximum without vomiting (other effects may apply).")
    JArray.addStr(JA_Desc, "Allows actor to eat above the maximum without vomiting (other effects may apply).")

    JA_Reqs = JArray.object()
    JArray.addStr(JA_Reqs, "No Requirements.")
    JArray.addStr(JA_Reqs, "Overeat and vomit at least 30 times, and reach level 30.")

    SCLibrary.addPerkID("SCLAllowOverflow", JA_Desc, JA_Reqs)

    ;Basement Storage **********************************************************
    JA_Desc = JArray.object()
    Jarray.addStr(JA_Desc, "Allows actor to store items in colon.")
    Jarray.addStr(JA_Desc, "Allows actor to store items in colon.")

    JA_Reqs = JArray.object()
    JArray.addStr(JA_Reqs, "No Requirements.")
    JArray.addStr(JA_Reqs, "Reach Level 5.")

    SCLibrary.addPerkID("WF_BasementStorage", JA_Desc, JA_Reqs)/;
  EndIf
EndFunction

Function setupAggregateValues()
  If !SCLSet.JM_AggregateValues
    SCLSet.JM_AggregateValues = JMap.object()
    JDB.solveObjSetter(".SCLExtraData.AggregateValues", SCLSet.JM_AggregateValues, True)

    Int JA_AggValues = JArray.object()
    JArray.addStr(JA_AggValues, "ContentsFullness1")
    JArray.addStr(JA_AggValues, "ContentsFullness2")
    SCLibrary.addAggregateValue("STFullness", JA_AggValues)

    JA_AggValues = JArray.object()
    JArray.addStr(JA_AggValues, "ContentsFullness3")
    JArray.addStr(JA_AggValues, "ContentsFullness4")
    JArray.addStr(JA_AggValues, "WF_CurrentSolidAmount")

    SCLibrary.addAggregateValue("WF_SolidTotalFullness", JA_AggValues)
  EndIf
EndFunction

Function setupBellyValues()
  If !SCLSet.JA_BellyValuesList
    SCLSet.JA_BellyValuesList = JArray.object()
    JDB.solveObjSetter(".SCLExtraData.BellyValueList", SCLSet.JA_BellyValuesList, True)
    SCLibrary.addBellyValue("STFullness")
    SCLibrary.addBellyValue("WF_SolidTotalFullness")
  EndIf
EndFunction

Function setupTotalValues()
  If !SCLSet.JM_TotalValueList
    SCLSet.JM_TotalValueList = JMap.object()
    JDB.solveObjSetter(".SCLExtraData.TotalValuesList", SCLSet.JM_TotalValueList, True)
    If !SCLSet.JA_BellyValuesList
      setupBellyValues()
    EndIf
    SCLibrary.addTotalValue("SCLStomach", SCLSet.JA_BellyValuesList)
  EndIf
EndFunction

Function setupEditBodyEntries()
  If !SCLSet.JM_BellyInflateData
    ;Debug.Notification("Setting Edit body Entries")
    Int BellyEntry = JMap.object()
    JDB.solveObjSetter(".SCLExtraData.SCLBellyInflateData", BellyEntry, True)
    SCLSet.JM_BellyInflateData = BellyEntry
    JMap.setFlt(BellyEntry, "Multiplier", 1)
    JMap.setFlt(BellyEntry, "HighScale", 0)
    JMap.setFlt(BellyEntry, "Minimum", 1)
    JMap.setFlt(BellyEntry, "Maximum", 10)
    JMap.setFlt(BellyEntry, "Curve", 1.75)
    JMap.setFlt(BellyEntry, "DynEquipMultiplier", 0.3)

    Int JI_DynEquipSetList = JIntMap.object()
    JMap.setObj(BellyEntry, "DynEquipSetList", JI_DynEquipSetList)

    Int DynEntry = JMap.object()
    JIntMap.setObj(JI_DynEquipSetList, 1, DynEntry)
    Int JA_MorphList = JArray.object()
    JMap.setObj(DynEntry, "MorphMap", JA_MorphList)

    Int Morph1 = JMap.object()
    JArray.addObj(JA_MorphList, Morph1)
    JMap.setStr(Morph1, "MorphName", "SCLBigBelly")
    JMap.setFlt(Morph1, "MorphThreshold", -1)

    Armor BellyMesh = Game.GetFormFromFile(0x0200F068, "SCL.esp") as Armor
    JMap.setForm(DynEntry, "DynEquipment", BellyMesh)
    JMap.setObj(DynEntry, "MorphMap", JA_MorphList)

    Int JI_EquipSetList = JIntMap.object()
    JMap.setObj(BellyEntry, "EquipSetList", JI_EquipSetList)

    ;/Int EquipEntry01 = JFormMap.object()
    Armor Armor1 = Game.GetFormFromFile(int aiFormID, "SCL.esp") as Armor
    JFormMap.setFlt(EquipEntry01, Armor1, 10)
    JIntMap.setObj(JI_EquipSetList, 1, EquipEntry01)/;
    ;Debug.Notification("Done setting edit body entries.")
  EndIf
EndFunction

;/Function setupDynMorphList()
  If !SCLSet.JM_DynMorphList
    SCLSet.JM_DynMorphList = JMap.object()
    JDB.solveObjSetter(".SCLExtraData.DynMorphList", SCLSet.JM_DynMorphList, True)
    JMap.setObj(SCLSet.JM_DynMorphList, "Belly", JIntMap.object())

    Int JM_MorphList = JMap.object()
    JMap.setFlt(JM_MorphList, "SCLBigBelly", -1)
    Armor BellyMesh = Game.GetFormFromFile(0x0200F068, "SCL.esp") as Armor
    SCLibrary.addDynMorph(1, "Belly", BellyMesh, JM_MorphList)
  EndIf
EndFunction/;

Function setupMessages()
  If !SCLSet.JM_Messages
    SCLSet.JM_Messages = JMap.object()
    JDB.solveObjSetter(".SCLExtraData.Messages", SCLSet.JM_Messages, True)
    SCLibrary.addMessage("SCLOverfullMessage1", "I think I ate too much.")
    SCLibrary.addMessage("SCLOverfullMessage1", "Too much food...")
    SCLibrary.addMessage("SCLOverfullMessage1", "I think I need to rest for a little while.")
    SCLibrary.addMessage("SCLOverfullMessage1", "It's getting hard to move...")
    ;SCLibrary.addMessage("SCLStarvingMessage1", "")
  EndIf
EndFunction

Function setupItemDatabase()
  ;Input base information here
;Formlists *********************************************************************
  ;SCLSystem.AddSearchFormlist(Formlist Here)
;Keywords ********************************************************************
  Int PotionEntry = SCLibrary.AddSearchKeyword(Game.GetFormFromFile(0x0008cdec, "Skyrim.esm") as Keyword) ;VendorItemPotion
  JMap.setFlt(PotionEntry, "WeightModifier", 0.7)
  JMap.setFlt(PotionEntry, "Durablity", 1.1)
  JMap.setInt(PotionEntry, "IsInContainer", 1)
  JMap.setFlt(PotionEntry, "LiquidRatio", 1)
  JMap.setInt(PotionEntry, "IsDrink", 1)


  Int PoisonEntry = SCLibrary.AddSearchKeyword(Game.GetFormFromFile(0x0008cded, "Skyrim.esm") as Keyword) ;VendorItemPoison
  JMap.setInt(PoisonEntry, "IsNotFood", 1)
  JMap.setInt(PoisonEntry, "IsInContainer", 1)

  ;Generic Entries -------------------------------------------------------------
  Int JM_AlcoholProfile = JMap.object()
  ;"WeightOverride"
  JMap.setFlt(JM_AlcoholProfile, "WeightModifier", 0.8)
  JMap.setFlt(JM_AlcoholProfile, "Durablity", 1.2)
  JMap.setInt(JM_AlcoholProfile, "IsInContainer", 1)
  JMap.setFlt(JM_AlcoholProfile, "LiquidRatio", 1)
  JMap.setInt(JM_AlcoholProfile, "Alcoholic", 1)
  JMap.setInt(JM_AlcoholProfile, "IsDrink", 1)

  ;FirebrandWine
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x0001895F, "Skyrim.esm"), JM_AlcoholProfile)

  ;FoodBlackBriarMead
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x0002c65A, "Skyrim.esm"), JM_AlcoholProfile)

  ;FoodWineAlto
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x0003133b, "Skyrim.esm"), JM_AlcoholProfile)

  ;FoodWineBottle02
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x0003133c, "Skyrim.esm"), JM_AlcoholProfile)

  ;FoodMead
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x00034c5d, "Skyrim.esm"), JM_AlcoholProfile)

  ;Ale
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x00034c5e, "Skyrim.esm"), JM_AlcoholProfile)

  ;MQ201Drink, Colovian Brandy
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x00035d53, "Skyrim.esm"), JM_AlcoholProfile)

  ;FoodHonningbrewMead
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x000508CA, "Skyrim.esm"), JM_AlcoholProfile)

  ;FreeformDragonBridgeMead
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x000555e8, "Skyrim.esm"), JM_AlcoholProfile)

  ;RiftenSpecial01, Velvet LeChance
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x00065c37, "Skyrim.esm"), JM_AlcoholProfile)

  ;RiftenSpecial02, White-Gold Tower
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x00065c38, "Skyrim.esm"), JM_AlcoholProfile)

  ;RiftenSpecial03, Cliff Racer
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x00065c39, "Skyrim.esm"), JM_AlcoholProfile)

  ;FoodSolitudeSpicedWine
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x00085368, "Skyrim.esm"), JM_AlcoholProfile)

  ;AleWhiterunQuest, Argonian Ale
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x0009380d, "Skyrim.esm"), JM_AlcoholProfile)

  ;WEDLO3CyrodilicBrandy
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x000b91d7, "Skyrim.esm"), JM_AlcoholProfile)

  ;FoodWineBottle02A
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x000c5348, "Skyrim.esm"), JM_AlcoholProfile)

  ;FoodWineAltoA
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x000c5349, "Skyrim.esm"), JM_AlcoholProfile)

  ;FavorSorexRum, StrosM'Kai Rum
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x000d055e, "Skyrim.esm"), JM_AlcoholProfile)

  ;MQ101JuniperMead
  JFormDB.setEntry("SCLItemDatabase", Game.GetFormFromFile(0x00107A8A, "Skyrim.esm"), JM_AlcoholProfile)

;Raw Meats *********************************************************************

  ;Chicken Breast
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000f2011, "Skyrim.esm"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000f2011, "Skyrim.esm"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000f2011, "Skyrim.esm"), ".SCLItemDatabase.IllnessAmount", 0.75, True)

  ;Clam Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000eba03, "Skyrim.esm"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000eba03, "Skyrim.esm"), ".SCLItemDatabase.LiquidRatio", 0.3, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000eba03, "Skyrim.esm"), ".SCLItemDatabase.IllnessAmount", 0.1, True)

  ;Dog Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000edb2e, "Skyrim.esm"), ".SCLItemDatabase.Durability", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000edb2e, "Skyrim.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000edb2e, "Skyrim.esm"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000edb2e, "Skyrim.esm"), ".SCLItemDatabase.IllnessAmount", 0.75, True)

  ;Horker Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9b, "Skyrim.esm"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9b, "Skyrim.esm"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9b, "Skyrim.esm"), ".SCLItemDatabase.IllnessAmount", 0.5, True)

  ;Horse Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9c, "Skyrim.esm"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9c, "Skyrim.esm"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9c, "Skyrim.esm"), ".SCLItemDatabase.IllnessAmount", 1.5, True)

  ;Leg of Goat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9a, "Skyrim.esm"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9a, "Skyrim.esm"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9a, "Skyrim.esm"), ".SCLItemDatabase.IllnessAmount", 0.75, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9a, "Skyrim.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)

  ;Mammoth Snout
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000669a4, "Skyrim.esm"), ".SCLItemDatabase.Durability", 0.6, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000669a4, "Skyrim.esm"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000669a4, "Skyrim.esm"), ".SCLItemDatabase.IllnessAmount", 0.1, True)

  ;Pheasant Breast
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9d, "Skyrim.esm"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9d, "Skyrim.esm"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9d, "Skyrim.esm"), ".SCLItemDatabase.IllnessAmount", 0.75, True)

  ;Raw Beef
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c99, "Skyrim.esm"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c99, "Skyrim.esm"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c99, "Skyrim.esm"), ".SCLItemDatabase.IllnessAmount", 0.75, True)

  ;Raw Rabbit Leg
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9e, "Skyrim.esm"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9e, "Skyrim.esm"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x00065c9e, "Skyrim.esm"), ".SCLItemDatabase.IllnessAmount", 0.5, True)

  ;Venison
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000669a2, "Skyrim.esm"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000669a2, "Skyrim.esm"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x000669a2, "Skyrim.esm"), ".SCLItemDatabase.IllnessAmount", 0.5, True)

  ;ALL OF THIS INFORMATION WENT UNUSED!
  ;FOR WHEN I ACTUALLY HAVE STUFF TO PUT IN HERE
  ;All races are going to be integrated into the SCLItemDatabase
  ;Searching for races directly will now return results
  ;/RaceData
  JI_VB_NPCActor = JIntMap.object()

  ;ArgonianRace
  JFormDB.setInt(Game.GetFormFromFile(0x00013740, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00013740, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)
  ;ArgonianRaceVampire
  JFormDB.setInt(Game.GetFormFromFile(0x0008883A, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x0008883A, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)

  ;BretonRace
  JFormDB.setInt(Game.GetFormFromFile(0x00013741, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00013741, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)
  ;BretonRaceVampire
  JFormDB.setInt(Game.GetFormFromFile(0x0005553C, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x0005553C, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)

  ;DarkElfRace
  JFormDB.setInt(Game.GetFormFromFile(0x00013742, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00013742, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)
  ;DarkElfRaceVampire
  JFormDB.setInt(Game.GetFormFromFile(0x0008883D, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x0008883D, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)

  ;ElderRace
  JFormDB.setInt(Game.GetFormFromFile(0x00067CD8, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00067CD8, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)
  ;ElderRaceVampire
  JFormDB.setInt(Game.GetFormFromFile(0x000A82BA, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x000A82BA, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)

  ;ImperialRace
  JFormDB.setInt(Game.GetFormFromFile(0x00013744, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00013744, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)
  ;ImperialRaceVampire
  JFormDB.setInt(Game.GetFormFromFile(0x00088844, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00088844, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)

  ;KhajiitRace
  JFormDB.setInt(Game.GetFormFromFile(0x00013745, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00013745, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)
  ;KhajiitRaceVampire
  JFormDB.setInt(Game.GetFormFromFile(0x00088845, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00088845, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)

  ;NordRace
  JFormDB.setInt(Game.GetFormFromFile(0x00013746, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00013746, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)
  ;NordRaceVampire
  JFormDB.setInt(Game.GetFormFromFile(0x00088794, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00088794, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)

  ;OrcRace
  JFormDB.setInt(Game.GetFormFromFile(0x00013747, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00013747, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)
  ;OrcRaceVampire
  JFormDB.setInt(Game.GetFormFromFile(0x000A82B9, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x000A82B9, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)

  ;RedguardRace
  JFormDB.setInt(Game.GetFormFromFile(0x00013748, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00013748, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)
  ;RedguardRaceVampire
  JFormDB.setInt(Game.GetFormFromFile(0x00088846, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00088846, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)

  ;WoodElfRace
  JFormDB.setInt(Game.GetFormFromFile(0x00013749, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00013749, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)
  ;WoodElfRaceVampire
  JFormDB.setInt(Game.GetFormFromFile(0x00088884, "Skyrim.esm") as Race, ".SCLRaceList.STValidRace", 1)
  JFormDB.setObj(Game.GetFormFromFile(0x00088884, "Skyrim.esm") as Race, ".SCLRaceList.VBEquipment1", JI_VB_NPCActor)/;
EndFunction

String[] Function setupInstalledMods()
  {Searches for specific mods and changes database based on whats there
  Returns string array of mods added or removed}
  Int JA_ModsChanged = JValue.retain(JArray.object())
  Int JFD_Items = JDB.solveObj(".SCLItemDatabase")
;Dawnguard ---------------------------------------------------------------------
  If SCLibrary.isModInstalled("Dawnguard.esm") && !Dawnguard_Initialized
    setupDawnguard(JFD_Items)
    Dawnguard_Initialized = True
    JArray.addStr(JA_ModsChanged, "Added Dawnguard.esm")
  ElseIf !SCLibrary.isModInstalled("Dawnguard.esm") && Dawnguard_Initialized
    removeDawnguard(JFD_Items)
    Dawnguard_Initialized = False
    JArray.addStr(JA_ModsChanged, "Removed Dawnguard.esm")
  EndIf

;HearthFire --------------------------------------------------------------------
  If SCLibrary.isModInstalled("HearthFires.esm") && !HearthFires_Initialized
    setupHearthfires(JFD_Items)
    HearthFires_Initialized = True
    JArray.addStr(JA_ModsChanged, "Added HearthFires.esm")
  ElseIf !SCLibrary.isModInstalled("HearthFires.esm") && HearthFires_Initialized
    removeHearthfires(JFD_Items)
    HearthFires_Initialized = False
    JArray.addStr(JA_ModsChanged, "Removed HearthFires.esm")
  EndIf

;Dragonborn --------------------------------------------------------------------
  If SCLibrary.isModInstalled("Dragonborn.esm") && !Dragonborn_Initialized
    setupDragonborn(JFD_Items)
    Dragonborn_Initialized = True
    JArray.addStr(JA_ModsChanged, "Added Dragonborn.esm")
  ElseIf !SCLibrary.isModInstalled("Dragonborn.esm") && Dragonborn_Initialized
    removeDragonborn(JFD_Items)
    Dragonborn_Initialized = False
    JArray.addStr(JA_ModsChanged, "Removed Dragonborn.esm")
  EndIf

;iNeed -------------------------------------------------------------------------
  If SCLibrary.isModInstalled("iNeed.esp") && !iNeed_Initialized
    setupiNeed(JFD_Items)
    iNeed_Initialized = True
    JArray.addStr(JA_ModsChanged, "Added iNeed.esp")
  ElseIf !SCLibrary.isModInstalled("iNeed.esp") && iNeed_Initialized
    removeiNeed(JFD_Items)
    iNeed_Initialized = False
    JArray.addStr(JA_ModsChanged, "Removed iNeed.esp")
  EndIf

;Hunterborn --------------------------------------------------------------------
  If SCLibrary.isModInstalled("Hunterborn.esp") && !Hunterborn_Initialized
    setupHunterborn(JFD_Items)
    Hunterborn_Initialized = True
    JArray.addStr(JA_ModsChanged, "Added Hunterborn.esp")
  ElseIf !SCLibrary.isModInstalled("Hunterborn.esp") && Hunterborn_Initialized
    removeHunterborn(JFD_Items)
    Hunterborn_Initialized = False
    JArray.addStr(JA_ModsChanged, "Removed Hunterborn.esp")
  EndIf

;Frostfall ---------------------------------------------------------------------
If SCLibrary.isModInstalled("FrostFall.esp") && !Frostfall_Initialized
  setupFrostfall(JFD_Items)
  Frostfall_Initialized = True
  JArray.addStr(JA_ModsChanged, "Added FrostFall.esp")
ElseIf !SCLibrary.isModInstalled("FrostFall.esp") && Frostfall_Initialized
  removeFrostfall(JFD_Items)
  Frostfall_Initialized = False
  JArray.addStr(JA_ModsChanged, "Removed FrostFall.esp")
EndIf
;*******************************************************************************
  String[] Results = Utility.CreateStringArray(JArray.count(JA_ModsChanged), "")
  JArray.writeToStringPArray(JA_ModsChanged, Results)
  JValue.release(JA_ModsChanged)
  Return Results
EndFunction

Function setupDawnguard(Int JFD_Items)
  ;DLC1RedwaterDenSkooma
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0201391D, "Dawnguard.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0201391D, "Dawnguard.esm"), ".SCLItemDatabase.Durability", 1.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0201391D, "Dawnguard.esm"), ".SCLItemDatabase.LiquidRatio", 1, True)

  ;DLC1BloodPotion
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02018EF3, "Dawnguard.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02018EF3, "Dawnguard.esm"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02018EF3, "Dawnguard.esm"), ".SCLItemDatabase.LiquidRatio", 1, True)

EndFunction

Function removeDawnguard(Int JFD_Items)
  ;DLC1RedwaterDenSkooma
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0201391D, "Dawnguard.esm"))
  ;DLC1BloodPotion
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x02018EF3, "Dawnguard.esm"))
EndFunction

Function setupHearthfires(Int JFD_Items)
  ;BYOHFoodMilk
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003534, "HearthFires.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003534, "HearthFires.esm"), ".SCLItemDatabase.Durability", 1.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003534, "HearthFires.esm"), ".SCLItemDatabase.LiquidRatio", 0.95, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003534, "HearthFires.esm"), ".SCLItemDatabase.IsDrink", 1, True)

  ;BYOHFoodWineBottle04, Argonian Bloodwine
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003535, "HearthFires.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003535, "HearthFires.esm"), ".SCLItemDatabase.Durability", 1.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003535, "HearthFires.esm"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003535, "HearthFires.esm"), ".SCLItemDatabase.IsDrink", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003535, "HearthFires.esm"), ".SCLItemDatabase.Alcoholic", 1, True)


  ;BYOHFoodWineBottle03, Surilie Brothers Wine
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003536, "HearthFires.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003536, "HearthFires.esm"), ".SCLItemDatabase.Durability", 1.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003536, "HearthFires.esm"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003536, "HearthFires.esm"), ".SCLItemDatabase.IsDrink", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003536, "HearthFires.esm"), ".SCLItemDatabase.Alcoholic", 1, True)

  ;MudCrabLegs
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003540, "HearthFires.esm"), ".SCLItemDatabase.WeightModifier", 0.5, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003540, "HearthFires.esm"), ".SCLItemDatabase.Durability", 1.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003540, "HearthFires.esm"), ".SCLItemDatabase.LiquidRatio", 0.4, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02003540, "HearthFires.esm"), ".SCLItemDatabase.IllnessAmount", 0.2, True)
EndFunction

Function removeHearthfires(Int JFD_Items)
  ;BYOHFoodMilk
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x02003534, "HearthFires.esm"))

  ;BYOHFoodWineBottle04, Argonian Bloodwine
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x02003535, "HearthFires.esm"))

  ;BYOHFoodWineBottle03, Surilie Brothers Wine
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x02003536, "HearthFires.esm"))

  ;MudCrabLegs
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x02003540, "HearthFires.esm"))

EndFunction

Function setupDragonborn(Int JFD_Items)
  ;DLC2Flin
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020207e5, "Dragonborn.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020207e5, "Dragonborn.esm"), ".SCLItemDatabase.Durability", 1.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020207e5, "Dragonborn.esm"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020207e5, "Dragonborn.esm"), ".SCLItemDatabase.IsDrink", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020207e5, "Dragonborn.esm"), ".SCLItemDatabase.Alcoholic", 1, True)

  ;DLC2Sujamma
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020207e6, "Dragonborn.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020207e6, "Dragonborn.esm"), ".SCLItemDatabase.Durability", 1.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020207e6, "Dragonborn.esm"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020207e6, "Dragonborn.esm"), ".SCLItemDatabase.IsDrink", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020207e6, "Dragonborn.esm"), ".SCLItemDatabase.Alcoholic", 1, True)


  ;DLC2Shein
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020248CC, "Dragonborn.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020248CC, "Dragonborn.esm"), ".SCLItemDatabase.Durability", 1.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020248CC, "Dragonborn.esm"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020248CC, "Dragonborn.esm"), ".SCLItemDatabase.IsDrink", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020248CC, "Dragonborn.esm"), ".SCLItemDatabase.Alcoholic", 1, True)


  ;DLC2Matze
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020248CE, "Dragonborn.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020248CE, "Dragonborn.esm"), ".SCLItemDatabase.Durability", 1.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020248CE, "Dragonborn.esm"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020248CE, "Dragonborn.esm"), ".SCLItemDatabase.IsDrink", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020248CE, "Dragonborn.esm"), ".SCLItemDatabase.Alcoholic", 1, True)


  ;DLC2RRF04Sujamma
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02024E0B, "Dragonborn.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02024E0B, "Dragonborn.esm"), ".SCLItemDatabase.Durability", 1.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02024E0B, "Dragonborn.esm"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02024E0B, "Dragonborn.esm"), ".SCLItemDatabase.IsDrink", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02024E0B, "Dragonborn.esm"), ".SCLItemDatabase.Alcoholic", 1, True)


  ;DLC2RRFavor01EmberbrandWine
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020320DF, "Dragonborn.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020320DF, "Dragonborn.esm"), ".SCLItemDatabase.Durability", 1.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020320DF, "Dragonborn.esm"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020320DF, "Dragonborn.esm"), ".SCLItemDatabase.IsDrink", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020320DF, "Dragonborn.esm"), ".SCLItemDatabase.Alcoholic", 1, True)


  ;DLC2FoodAshfireMead
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203572f, "Dragonborn.esm"), ".SCLItemDatabase.WeightModifier", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203572f, "Dragonborn.esm"), ".SCLItemDatabase.Durability", 1.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203572f, "Dragonborn.esm"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203572f, "Dragonborn.esm"), ".SCLItemDatabase.IsDrink", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203572f, "Dragonborn.esm"), ".SCLItemDatabase.Alcoholic", 1, True)

  ;Ash Hopper Leg
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203d125, "Dragonborn.esm"), ".SCLItemDatabase.WeightModifier", 0.5, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203d125, "Dragonborn.esm"), ".SCLItemDatabase.Durability", 1.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203d125, "Dragonborn.esm"), ".SCLItemDatabase.LiquidRatio", 0.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203d125, "Dragonborn.esm"), ".SCLItemDatabase.IllnessAmount", 0.2, True)

  ;Ash Hopper Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203bd15, "Dragonborn.esm"), ".SCLItemDatabase.WeightModifier", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203bd15, "Dragonborn.esm"), ".SCLItemDatabase.Durability", 1.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203bd15, "Dragonborn.esm"), ".SCLItemDatabase.LiquidRatio", 0.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203bd15, "Dragonborn.esm"), ".SCLItemDatabase.IllnessAmount", 0.2, True)

  ;Boar Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203bd14, "Dragonborn.esm"), ".SCLItemDatabase.Durability", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203bd14, "Dragonborn.esm"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203bd14, "Dragonborn.esm"), ".SCLItemDatabase.IllnessAmount", 1.2, True)
EndFunction

Function removeDragonborn(Int JFD_Items)
  ;DLC2Flin
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x020207e5, "Dragonborn.esm"))

  ;DLC2Sujamma
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x020207e6, "Dragonborn.esm"))

  ;DLC2Shein
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x020248CC, "Dragonborn.esm"))

  ;DLC2Matze
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x020248CE, "Dragonborn.esm"))

  ;DLC2RRF04Sujamma
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x02024E0B, "Dragonborn.esm"))

  ;DLC2RRFavor01EmberbrandWine
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x020320DF, "Dragonborn.esm"))

  ;DLC2FoodAshfireMead
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0203572f, "Dragonborn.esm"))

  ;Ash Hopper Leg
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0203d125, "Dragonborn.esm"))

  ;Ash Hopper Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0203bd15, "Dragonborn.esm"))

  ;Boar Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0203bd14, "Dragonborn.esm"))
EndFunction

Function setupiNeed(Int JFD_Items)
  ;Water Skin 1/3
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0200437F, "iNeed.esp"), ".SCLItemDatabase.WeightOverride", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0200437F, "iNeed.esp"), ".SCLItemDatabase.Durability", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0200437F, "iNeed.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0200437F, "iNeed.esp"), ".SCLItemDatabase.IllnessAmount", 0, True)

  ;Water Skin 1/3 (Unknown)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203b2c5, "iNeed.esp"), ".SCLItemDatabase.WeightOverride", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203b2c5, "iNeed.esp"), ".SCLItemDatabase.Durability", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203b2c5, "iNeed.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203b2c5, "iNeed.esp"), ".SCLItemDatabase.IllnessAmount", 0.5, True)

  ;Water Skin 2/3
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0200437d, "iNeed.esp"), ".SCLItemDatabase.WeightOverride", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0200437d, "iNeed.esp"), ".SCLItemDatabase.Durability", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0200437d, "iNeed.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0200437d, "iNeed.esp"), ".SCLItemDatabase.IllnessAmount", 0, True)

  ;Water Skin 2/3 (Unknown)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203b2c8, "iNeed.esp"), ".SCLItemDatabase.WeightOverride", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203b2c8, "iNeed.esp"), ".SCLItemDatabase.Durability", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203b2c8, "iNeed.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203b2c8, "iNeed.esp"), ".SCLItemDatabase.IllnessAmount", 0.5, True)

  ;Water Skin 3/3
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02004376, "iNeed.esp"), ".SCLItemDatabase.WeightOverride", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02004376, "iNeed.esp"), ".SCLItemDatabase.Durability", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02004376, "iNeed.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x02004376, "iNeed.esp"), ".SCLItemDatabase.IllnessAmount", 0, True)

  ;Water Skin 3/3 (Unknown)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203b2cc, "iNeed.esp"), ".SCLItemDatabase.WeightOverride", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203b2cc, "iNeed.esp"), ".SCLItemDatabase.Durability", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203b2cc, "iNeed.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0203b2cc, "iNeed.esp"), ".SCLItemDatabase.IllnessAmount", 0.5, True)

  ;Snow
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020387ad, "iNeed.esp"), ".SCLItemDatabase.WeightModifier", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020387ad, "iNeed.esp"), ".SCLItemDatabase.Durability", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020387ad, "iNeed.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x020387ad, "iNeed.esp"), ".SCLItemDatabase.IllnessAmount", 0.2, True)
EndFunction

Function removeiNeed(Int JFD_Items)
  ;Water Skin 1/3
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0200437F, "iNeed.esp"))

  ;Water Skin 1/3 (Unknown)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0203b2c5, "iNeed.esp"))

  ;Water Skin 2/3
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0200437d, "iNeed.esp"))

  ;Water Skin 2/3 (Unknown)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0203b2c8, "iNeed.esp"))

  ;Water Skin 3/3
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x02004376, "iNeed.esp"))

  ;Water Skin 3/3 (Unknown)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0203b2cc, "iNeed.esp"))

  ;Snow
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x020387ad, "iNeed.esp"))
EndFunction

Function setupHunterborn(Int JFD_Items)
  ;Raw Bear Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014795, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.7, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014795, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014795, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 1, True)

  ;Raw Bear Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b41, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Raw Chaurus Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04027783, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04027783, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04027783, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 0.4, True)

  ;Raw Chaurus Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b46, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Raw Dragon Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04029849, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.4, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04029849, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04029849, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 0.1, True)

  ;Raw Elk Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014d21, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014d21, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014d21, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 0.8, True)

  ;Raw Elk Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b48, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)


  ;Raw Fox Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014795, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014795, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014795, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 0.8, True)

  ;Raw Fox Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b4a, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Raw Goat Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0401479a, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0401479a, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0401479a, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 0.8, True)

  ;Raw Goat Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b4c, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Raw Hare Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040147a2, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040147a2, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040147a2, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 0.8, True)

  ;Raw Hare Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b4e, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Raw Mammoth Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0401479e, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0401479e, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0401479e, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 0.8, True)

  ;Raw Mammoth Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b50, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Raw Mudcrab Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014d22, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 1.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014d22, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014d22, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 0.5, True)

  ;Raw Mudcrab Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b52, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Raw Sabrecat Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040147a0, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040147a0, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040147a0, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 0.8, True)

  ;Raw Sabrecat Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b54, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Raw Skeever Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014796, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014796, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.2, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014796, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 1.5, True)

  ;Raw Skeever Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b56, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Raw Slaughterfish Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014d24, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014d24, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.4, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04014d24, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 0.2, True)

  ;Raw Slaughterfish Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b58, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Raw Spider Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04029846, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04029846, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.4, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04029846, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 1, True)

  ;Raw Spider Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b5a, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Raw Troll Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04029847, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.5, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04029847, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04029847, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 1, True)

  ;Raw Troll Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b5c, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Raw Wolf Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0401479c, "Hunterborn.esp"), ".SCLItemDatabase.Durability", 0.5, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0401479c, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.1, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0401479c, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 0.7, True)

  ;Raw Wolf Meat Frozen
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b5e, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Ash Hopper Meat(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b62, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Boar Meat(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b64, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Beef(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b70, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Chicken(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b72, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Clam Meat(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b66, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Dog Meat(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b68, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Leg of Goat(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b6a, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Horker Meat(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b6c, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Horse Meat(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b6e, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Mammoth Meat(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b74, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Pheasant Meat(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b76, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Rabbit Leg(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b78, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Salmon Meat(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b7a, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Venison(Frozen)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x04152b60, "Hunterborn.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Bear Carrot Stew
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e08, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e08, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Boar Leek Stew
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04078eab, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04078eab, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Boar Potato Stew
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04078ea9, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04078ea9, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Fox Apple Stew
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e0b, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e0b, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Mammoth Tomato Stew
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e11, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e11, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Mudcrab Chowder
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e13, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e13, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Smelly Meat
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04152b62, "Hunterborn.esp"), ".SCLItemDatabase.IllnessAmount", 0.8, True)

  ;Poisoner's Stew
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040314c9, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040314c9, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Rabbit Mushroom Stew
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e0f, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e0f, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Salty Sabred Stew
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e15, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e15, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Skeevender Stew
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e17, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04017e17, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Spider Soup
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04029db9, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x04029db9, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Bear and Beer Cheese Chowder
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040f278f, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040f278f, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Beggar's Broth
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040ed66c, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040ed66c, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Flaming Dragon
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040f2785, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040f2785, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Fox in a Hole
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040f2789, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040f2789, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;High King's Stew
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040ed667, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040ed667, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Predator's Price
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040f278b, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040f278b, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Reachmen Soup
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040f2791, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.9, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040f2791, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 0.5, True)

  ;Juniper Tea
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402d7, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402d7, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)

  ;Lavender Tea
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402da, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402da, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)

  ;Moon Dance Tea
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402de, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402de, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)

  ;Mountain Flower Tea
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402dc, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402dc, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)

  ;Nirn Spring Tea
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402e0, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402e0, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)

  ;Snowberry Tea
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402e2, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402e2, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)

  ;10 Dragons Tea
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0403fd68, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0403fd68, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)

  ;Wheat Boon Tea
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402e4, "Hunterborn.esp"), ".SCLItemDatabase.WeightOverride", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x040402e4, "Hunterborn.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)

EndFunction

Function removeHunterborn(Int JFD_Items)

  ;Raw Bear Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04014795, "Hunterborn.esp"))

  ;Raw Bear Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b41, "Hunterborn.esp"))

  ;Raw Chaurus Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04027783, "Hunterborn.esp"))

  ;Raw Chaurus Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b46, "Hunterborn.esp"))

  ;Raw Dragon Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04029849, "Hunterborn.esp"))

  ;Raw Elk Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04014d21, "Hunterborn.esp"))

  ;Raw Elk Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b48, "Hunterborn.esp"))

  ;Raw Fox Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04014795, "Hunterborn.esp"))

  ;Raw Fox Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b4a, "Hunterborn.esp"))

  ;Raw Goat Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0401479a, "Hunterborn.esp"))

  ;Raw Goat Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b4c, "Hunterborn.esp"))

  ;Raw Hare Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040147a2, "Hunterborn.esp"))

  ;Raw Hare Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b4e, "Hunterborn.esp"))

  ;Raw Mammoth Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0401479e, "Hunterborn.esp"))

  ;Raw Mammoth Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b50, "Hunterborn.esp"))

  ;Raw Mudcrab Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04014d22, "Hunterborn.esp"))

  ;Raw Mudcrab Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b52, "Hunterborn.esp"))

  ;Raw Sabrecat Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040147a0, "Hunterborn.esp"))

  ;Raw Sabrecat Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b54, "Hunterborn.esp"))

  ;Raw Skeever Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04014796, "Hunterborn.esp"))

  ;Raw Skeever Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b56, "Hunterborn.esp"))

  ;Raw Slaughterfish Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04014d24, "Hunterborn.esp"))

  ;Raw Slaughterfish Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b58, "Hunterborn.esp"))

  ;Raw Spider Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04029846, "Hunterborn.esp"))

  ;Raw Spider Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b5a, "Hunterborn.esp"))

  ;Raw Troll Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04029847, "Hunterborn.esp"))

  ;Raw Troll Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b5c, "Hunterborn.esp"))

  ;Raw Wolf Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0401479c, "Hunterborn.esp"))

  ;Raw Wolf Meat Frozen
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b5e, "Hunterborn.esp"))

  ;Ash Hopper Meat(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b62, "Hunterborn.esp"))

  ;Boar Meat(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b64, "Hunterborn.esp"))

  ;Beef(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b70, "Hunterborn.esp"))

  ;Chicken(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b72, "Hunterborn.esp"))

  ;Clam Meat(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b66, "Hunterborn.esp"))

  ;Dog Meat(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b68, "Hunterborn.esp"))

  ;Leg of Goat(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b6a, "Hunterborn.esp"))

  ;Horker Meat(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b6c, "Hunterborn.esp"))

  ;Horse Meat(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b6e, "Hunterborn.esp"))

  ;Mammoth Meat(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b74, "Hunterborn.esp"))

  ;Pheasant Meat(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b76, "Hunterborn.esp"))

  ;Rabbit Leg(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b78, "Hunterborn.esp"))

  ;Salmon Meat(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b7a, "Hunterborn.esp"))

  ;Venison(Frozen)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b60, "Hunterborn.esp"))

  ;Bear Carrot Stew
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04017e08, "Hunterborn.esp"))

  ;Boar Leek Stew
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04078eab, "Hunterborn.esp"))

  ;Boar Potato Stew
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04078ea9, "Hunterborn.esp"))

  ;Fox Apple Stew
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04017e0b, "Hunterborn.esp"))

  ;Mammoth Tomato Stew
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04017e11, "Hunterborn.esp"))

  ;Mudcrab Chowder
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04017e13, "Hunterborn.esp"))

  ;Smelly Meat
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04152b62, "Hunterborn.esp"))

  ;Poisoner's Stew
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040314c9, "Hunterborn.esp"))

  ;Rabbit Mushroom Stew
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04017e0f, "Hunterborn.esp"))

  ;Salty Sabred Stew
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04017e15, "Hunterborn.esp"))

  ;Skeevender Stew
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04017e17, "Hunterborn.esp"))

  ;Spider Soup
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x04029db9, "Hunterborn.esp"))

  ;Bear and Beer Cheese Chowder
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040f278f, "Hunterborn.esp"))

  ;Beggar's Broth
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040ed66c, "Hunterborn.esp"))

  ;Flaming Dragon
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040f2785, "Hunterborn.esp"))

  ;Fox in a Hole
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040f2789, "Hunterborn.esp"))

  ;High King's Stew
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040ed667, "Hunterborn.esp"))

  ;Predator's Price
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040f278b, "Hunterborn.esp"))

  ;Reachmen Soup
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040f2791, "Hunterborn.esp"))

  ;Juniper Tea
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040402d7, "Hunterborn.esp"))

  ;Lavender Tea
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040402da, "Hunterborn.esp"))

  ;Moon Dance Tea
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040402de, "Hunterborn.esp"))

  ;Mountain Flower Tea
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040402dc, "Hunterborn.esp"))

  ;Nirn Spring Tea
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040402e0, "Hunterborn.esp"))

  ;Snowberry Tea
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040402e2, "Hunterborn.esp"))

  ;10 Dragons Tea
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0403fd68, "Hunterborn.esp"))

  ;Wheat Boon Tea
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x040402e4, "Hunterborn.esp"))
EndFunction

Function setupFrostfall(Int JFD_Items)
  ;Drink Effect Potion 1 (Strong Brew)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x0301cebd, "Frostfall.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Drink Effect Potion 2 (Strong Brew)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x0301cebf, "Frostfall.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Drink Effect Potion 3 (Strong Brew)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x0301cec1, "Frostfall.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Food Effect Potion (Hearty Meal)
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x03066b5F, "Frostfall.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Frostbitten Effect Potion Body
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x03062fec, "Frostfall.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Frostbitten Effect Potion Feet
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x03068125, "Frostfall.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Frostbitten Effect Potion Hands
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x03068121, "Frostfall.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Frostbitten Effect Potion Head
  JFormDB.solveIntSetter(Game.GetFormFromFile(0x03068123, "Frostfall.esp"), ".SCLItemDatabase.isNotFood", 1, True)

  ;Snowberry Extract
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0301d430, "Frostfall.esp"), ".SCLItemDatabase.WeightModifier", 0.8, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0301d430, "Frostfall.esp"), ".SCLItemDatabase.Durablity", 1.3, True)
  JFormDB.solveFltSetter(Game.GetFormFromFile(0x0301d430, "Frostfall.esp"), ".SCLItemDatabase.LiquidRatio", 1, True)

EndFunction

Function removeFrostfall(Int JFD_Items)
  ;Drink Effect Potion 1 (Strong Brew)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0301cebd, "Frostfall.esp"))

  ;Drink Effect Potion 2 (Strong Brew)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0301cebf, "Frostfall.esp"))

  ;Drink Effect Potion 3 (Strong Brew)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0301cec1, "Frostfall.esp"))

  ;Food Effect Potion (Hearty Meal)
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x03066b5F, "Frostfall.esp"))

  ;Frostbitten Effect Potion Body
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x03062fec, "Frostfall.esp"))

  ;Frostbitten Effect Potion Feet
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x03068125, "Frostfall.esp"))

  ;Frostbitten Effect Potion Hands
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x03068121, "Frostfall.esp"))

  ;Frostbitten Effect Potion Head
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x03068123, "Frostfall.esp"))

  ;Snowberry Extract
  JFormMap.removeKey(JFD_Items, Game.GetFormFromFile(0x0301d430, "Frostfall.esp"))
EndFunction
