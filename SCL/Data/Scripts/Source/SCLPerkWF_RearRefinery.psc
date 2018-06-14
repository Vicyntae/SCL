ScriptName SCLPerkWF_RearRefinery Extends SCLPerkBase

Formlist Property SCL_WF_RefineFoodList Auto
Formlist Property SCL_WF_RefinePotionList Auto

Formlist Property SCL_WF_RefineDaedricArmorList Auto
Keyword Property ArmorMaterialDaedric Auto

Formlist Property SCL_WF_RefineDragonArmorList Auto
Keyword Property ArmorMaterialDragonplate Auto
Keyword Property ArmorMaterialDragonscale Auto

Formlist Property SCL_WF_RefineDwarvenArmorList Auto
Keyword Property ArmorMaterialDwarven Auto

Formlist Property SCL_WF_RefineEbonyArmorList Auto
Keyword Property ArmorMaterialEbony Auto

Formlist Property SCL_WF_RefineElvenArmorList Auto
Keyword Property ArmorMaterialElven Auto
Keyword Property ArmorMaterialElvenGilded Auto

Formlist Property SCL_WF_RefineFalmerArmorList Auto
Keyword Property ArmorMaterialFalmer Auto

Formlist Property SCL_WF_RefineGlassArmorList Auto
Keyword Property ArmorMaterialGlass Auto

Formlist Property SCL_WF_RefineIronArmorList Auto
Keyword Property ArmorMaterialIron Auto
Keyword Property ArmorMaterialIronBanded Auto

Formlist Property SCL_WF_RefineOrcishArmorList Auto
Keyword Property ArmorMaterialOrcish Auto

Formlist Property SCL_WF_RefineSteelArmorList Auto
Keyword Property ArmorMaterialScaled Auto
Keyword Property ArmorMaterialSteel Auto
Keyword Property ArmorMaterialSteelPlate Auto
Keyword Property ArmorMaterialBlades Auto

Formlist Property SCL_WF_RefineLeatherArmorList Auto
Keyword Property ArmorMaterialPenitus Auto
Keyword Property ArmorMaterialImperialHeavy Auto
Keyword Property ArmorMaterialImperialLight Auto
Keyword Property ArmorMaterialImperialStudded Auto
Keyword Property ArmorMaterialMS02Forsworn Auto
Keyword Property ArmorMaterialBearStormcloak Auto
Keyword Property ArmorMaterialForsworn Auto
Keyword Property ArmorMaterialLeather Auto
Keyword Property ArmorMaterialStormcloak Auto
Keyword Property ArmorMaterialStudded Auto
Keyword Property ArmorMaterialHide Auto
Keyword Property ArmorMaterialThievesGuild Auto
Keyword Property ArmorMaterialThievesGuildLeader Auto
Keyword Property ArmorMaterialNightingale Auto

Formlist Property SCL_WF_RefineJeweleryList Auto
Keyword Property ClothingCirclet Auto
Keyword Property ClothingNecklace Auto
Keyword Property ClothingRing Auto

Formlist Property SCL_WF_RefineClothingList Auto
Keyword Property ClothingBody Auto
Keyword Property ClothingFeet Auto
Keyword Property ClothingHands Auto
Keyword Property ClothingHead Auto

Formlist Property SCL_WF_RefineMiscArmorList Auto

Formlist Property SCL_WF_RefineDaedricWeaponList Auto
Keyword Property WeapMaterialDaedric Auto

Formlist Property SCL_WF_RefineDraugrWeaponList Auto
Keyword Property WeapMaterialDraugr Auto
Keyword Property WeapMaterialDraugrHoned Auto

Formlist Property SCL_WF_RefineDwarvenWeaponList Auto
Keyword Property WeapMaterialDwarven Auto

Formlist Property SCL_WF_RefineEbonyWeaponList Auto
Keyword Property WeapMaterialEbony Auto

Formlist Property SCL_WF_RefineElvenWeaponList Auto
Keyword Property WeapMaterialElven Auto

Formlist Property SCL_WF_RefineFalmerWeaponList Auto
Keyword Property WeapMaterialFalmer Auto
Keyword Property WeapMaterialFalmerHoned Auto

Formlist Property SCL_WF_RefineGlassWeaponList Auto
Keyword Property WeapMaterialGlass Auto

Formlist Property SCL_WF_RefineIronWeaponList Auto
Keyword Property WeapMaterialIron Auto

Formlist Property SCL_WF_RefineOrcishWeaponList Auto
Keyword Property WeapMaterialOrcish Auto

Formlist Property SCL_WF_RefineSilverWeaponList Auto
Keyword Property WeapMaterialSilver Auto

Formlist Property SCL_WF_RefineSteelWeaponList Auto
Keyword Property WeapMaterialSteel Auto
Keyword Property WeapMaterialImperial Auto

Formlist Property SCL_WF_RefineMiscWeaponList Auto

Formlist Property SCL_SoulGemSmallList Auto
Formlist Property SCL_SoulGemMediumList Auto
Formlist Property SCL_SoulGemLargeList Auto

Formlist Property SCL_WF_RefineSoulGemSmallList Auto
Formlist Property SCL_WF_RefineSoulGemMediumList Auto
Formlist Property SCL_WF_RefineSoulGemLargeList Auto

Function Setup()
  Name = "Rear Refinery"
  Description = New String[6]
  Description[0] = "Allows creation of special items when breaking down items in the colon."
  Description[1] = "Allows for a small chance of creating special items when breaking down food in the colon"
  Description[2] = "Allows for a small chance of creating special items when breaking down potions in the colon"
  Description[3] = "Allows for a small chance of creating special items when breaking down armor in the colon"
  Description[4] = "Allows for a small chance of creating special items when breaking down weaponry in the colon"
  Description[5] = "Allows for a small chance of creating special items when breaking down soulgems in the colon"

  Requirements = New String[6]
  Requirements[0] = "No Requirements."
  Requirements[1] = "Have the Bottoms Up! 1 perk, and gain temporary benefits from breaking down items 30 times."
  Requirements[2] = "Have the Bottoms Up! 2 perk, gain temporary benefits from breaking down items 50 times, and successfully refine 5 items."
  Requirements[3] = "Have the Extraction Expert 1 perk, gain temporary benefits from breaking down items 80 times, and successfully refine 15 items."
  Requirements[4] = "Have the Extraction Expert 2 perk, and successfully refine 30 items."
  Requirements[5] = "Have the Extraction Expert 3 perk, and successfully refine 50 items."
  RegisterForModEvent("SCLBreakDownItemFinishEvent", "OnItemBreakdownFinish")
EndFunction

Function reloadMaintenence()
  Setup()
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= AbilityArray.Length - 1
    Return True
  EndIf
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Int Bottom = SCLib.getCurrentPerkLevel(akTarget, "WF_BottomsUp")
  Int NumBoosts = JMap.getInt(TargetData, "WF_TotalTempBoostsGained")
  Int Refine = JMap.getInt(TargetData, "WF_TotalRefinedItems")
  Int Extract = SCLib.getCurrentPerkLevel(akTarget, "SCLExtractionExpert")
  If aiPerkLevel == 1 && Bottom >= 1 && NumBoosts >= 30
    Return True
  ElseIf aiPerkLevel == 2 && Bottom >= 2 && NumBoosts >= 50 && Refine >= 5
    Return True
  ElseIf aiPerkLevel == 3 && Extract >= 1 && NumBoosts >= 80 && Refine >= 15
    Return True
  ElseIf aiPerkLevel == 4 && Extract >= 2 && Refine >= 30
    Return True
  ElseIf aiPerkLevel == 5 && Extract >= 3 && Refine >= 50
    Return True
  Else
    Return False
  EndIf
EndFunction

Event OnItemBreakdownFinish(Form akEater, Form akFood, Float afDigestValue)
  If akEater as Actor
    Actor Target = akEater as Actor
    Int PerkLevel = getFirstPerkLevel(Target)
    If !PerkLevel
      Return
    EndIf
    Form BaseForm
    If akFood as Actor
      BaseForm = (akFood as Actor).GetLeveledActorBase()
    ElseIf akFood as ObjectReference
      BaseForm = (akFood as ObjectReference).GetBaseObject()
    Else
      BaseForm = akFood
    EndIf
    If BaseForm as Potion || BaseForm as Armor || BaseForm as Weapon || BaseForm as Soulgem
      Int TargetData = SCLib.getTargetData(Target)
      If (BaseForm as Potion).IsFood() && PerkLevel >= 1
        Int Cost = BaseForm.GetGoldValue()
        If Cost
          Float Chance = Cost / 250
          Chance *= (JMap.getInt(TargetData, "WF_RefineItemBonus") / 100) + 1
          Float Success = Utility.RandomFloat()
          If Success < Chance
            Int Index = Utility.RandomInt(0, SCL_WF_RefineFoodList.GetSize() - 1)
            Form NewItem = SCL_WF_RefineFoodList.GetAt(Index)
            SCLib.addItem(Target, None, NewItem, 4)
            PlayerThoughtDB(Target, "SCLWFRRRefineSuccess")
            JMap.setInt(TargetData, "WF_TotalRefinedItems", JMap.getInt(TargetData, "WF_TotalRefinedItems") + 1)
          EndIf
        EndIf
      ElseIf BaseForm as Potion && PerkLevel >= 2
        Int Cost = BaseForm.GetGoldValue()
        If Cost
          Float Chance = Cost / 250
          Chance *= (JMap.getInt(TargetData, "WF_RefineItemBonus") / 100) + 1
          Float Success = Utility.RandomFloat()
          If Success < Chance
            Int Index = Utility.RandomInt(0, SCL_WF_RefinePotionList.GetSize() - 1)
            Form NewItem = SCL_WF_RefinePotionList.GetAt(Index)
            SCLib.addItem(Target, None, NewItem, 4)
            PlayerThoughtDB(Target, "SCLWFRRRefineSuccess")
            JMap.setInt(TargetData, "WF_TotalRefinedItems", JMap.getInt(TargetData, "WF_TotalRefinedItems") + 1)
          EndIf
        EndIf
      ElseIf BaseForm as Armor && PerkLevel >= 3
        Int Cost = BaseForm.GetGoldValue()
        If Cost
          Float Chance = Cost / 250
          Chance *= (JMap.getInt(TargetData, "WF_RefineItemBonus") / 100) + 1
          Float Success = Utility.RandomFloat()
          If Success < Chance
            Formlist RefineList
            If BaseForm.HasKeyword(ArmorMaterialDaedric)
              RefineList = SCL_WF_RefineDaedricArmorList
            ElseIf BaseForm.HasKeyword(ArmorMaterialDragonplate) || BaseForm.HasKeyword(ArmorMaterialDragonscale)
              RefineList = SCL_WF_RefineDragonArmorList
            ElseIf BaseForm.HasKeyword(ArmorMaterialDwarven)
              RefineList = SCL_WF_RefineDwarvenArmorList
            ElseIf BaseForm.HasKeyword(ArmorMaterialEbony)
              RefineList = SCL_WF_RefineEbonyArmorList
            ElseIf BaseForm.HasKeyword(ArmorMaterialElven) || BaseForm.HasKeyword(ArmorMaterialElvenGilded)
              RefineList = SCL_WF_RefineElvenArmorList
            ElseIf BaseForm.HasKeyword(ArmorMaterialFalmer)
              RefineList = SCL_WF_RefineFalmerArmorList
            ElseIf BaseForm.HasKeyword(ArmorMaterialGlass)
              RefineList = SCL_WF_RefineGlassArmorList
            ElseIf BaseForm.HasKeyword(ArmorMaterialIron) || BaseForm.HasKeyword(ArmorMaterialIronBanded)
              RefineList = SCL_WF_RefineIronArmorList
            ElseIf BaseForm.HasKeyword(ArmorMaterialOrcish)
              RefineList = SCL_WF_RefineOrcishArmorList
            ElseIf BaseForm.HasKeyword(ArmorMaterialScaled) || BaseForm.HasKeyword(ArmorMaterialSteel) || BaseForm.HasKeyword(ArmorMaterialSteelPlate) || BaseForm.HasKeyword(ArmorMaterialBlades)
              RefineList = SCL_WF_RefineSteelArmorList
            ElseIf BaseForm.HasKeyword(ArmorMaterialPenitus) || BaseForm.HasKeyword(ArmorMaterialImperialHeavy) \
              || BaseForm.HasKeyword(ArmorMaterialImperialLight)  || BaseForm.HasKeyword(ArmorMaterialImperialStudded) \
              || BaseForm.HasKeyword(ArmorMaterialMS02Forsworn)  || BaseForm.HasKeyword(ArmorMaterialBearStormcloak) \
              || BaseForm.HasKeyword(ArmorMaterialForsworn)  || BaseForm.HasKeyword(ArmorMaterialLeather) \
              || BaseForm.HasKeyword(ArmorMaterialStormcloak)  || BaseForm.HasKeyword(ArmorMaterialStudded) \
              || BaseForm.HasKeyword(ArmorMaterialHide)  || BaseForm.HasKeyword(ArmorMaterialThievesGuild) \
              || BaseForm.HasKeyword(ArmorMaterialThievesGuildLeader)  || BaseForm.HasKeyword(ArmorMaterialNightingale)
              RefineList = SCL_WF_RefineLeatherArmorList
            ElseIf BaseForm.HasKeyword(ClothingCirclet) || BaseForm.HasKeyword(ClothingNecklace) || BaseForm.HasKeyword(ClothingRing)
              RefineList = SCL_WF_RefineJeweleryList
            ElseIf BaseForm.HasKeyword(ClothingBody) || BaseForm.HasKeyword(ClothingFeet) || BaseForm.HasKeyword(ClothingHands) || BaseForm.HasKeyword(ClothingHead)
              RefineList = SCL_WF_RefineClothingList
            Else
              RefineList = SCL_WF_RefineMiscArmorList
            EndIf
            If RefineList
              Int Index = Utility.RandomInt(0, RefineList.GetSize() - 1)
              Form NewItem = RefineList.GetAt(Index)
              SCLib.addItem(Target, None, NewItem, 4)
              PlayerThoughtDB(Target, "SCLWFRRRefineSuccess")
              JMap.setInt(TargetData, "WF_TotalRefinedItems", JMap.getInt(TargetData, "WF_TotalRefinedItems") + 1)
            EndIf
          EndIf
        EndIf
      ElseIf BaseForm as Weapon && PerkLevel >= 4
        Int Cost = BaseForm.GetGoldValue()
        If Cost
          Float Chance = Cost / 250
          Chance *= (JMap.getInt(TargetData, "WF_RefineItemBonus") / 100) + 1
          Float Success = Utility.RandomFloat()
          If Success < Chance
            Formlist RefineList
            If BaseForm.HasKeyword(WeapMaterialDaedric)
              RefineList = SCL_WF_RefineDaedricWeaponList
            ElseIf BaseForm.HasKeyword(WeapMaterialDraugr) || BaseForm.HasKeyword(WeapMaterialDraugrHoned)
              RefineList = SCL_WF_RefineDraugrWeaponList
            ElseIf BaseForm.HasKeyword(WeapMaterialDwarven)
              RefineList = SCL_WF_RefineDwarvenWeaponList
            ElseIf BaseForm.HasKeyword(WeapMaterialEbony)
              RefineList = SCL_WF_RefineEbonyWeaponList
            ElseIf BaseForm.HasKeyword(WeapMaterialElven)
              RefineList = SCL_WF_RefineElvenWeaponList
            ElseIf BaseForm.HasKeyword(WeapMaterialFalmer) || BaseForm.HasKeyword(WeapMaterialFalmerHoned)
              RefineList = SCL_WF_RefineFalmerWeaponList
            ElseIf BaseForm.HasKeyword(WeapMaterialGlass)
              RefineList = SCL_WF_RefineGlassWeaponList
            ElseIf BaseForm.HasKeyword(WeapMaterialIron)
              RefineList = SCL_WF_RefineIronWeaponList
            ElseIf BaseForm.HasKeyword(WeapMaterialOrcish)
              RefineList = SCL_WF_RefineOrcishWeaponList
            ElseIf BaseForm.HasKeyword(WeapMaterialSilver)
              RefineList = SCL_WF_RefineSilverWeaponList
            ElseIf BaseForm.HasKeyword(WeapMaterialSteel) || BaseForm.HasKeyword(WeapMaterialImperial)
              RefineList = SCL_WF_RefineSteelWeaponList
            Else
              RefineList = SCL_WF_RefineMiscWeaponList
            EndIf
            Int Index = Utility.RandomInt(0, RefineList.GetSize() - 1)
            Form NewItem = RefineList.GetAt(Index)
            SCLib.addItem(Target, None, NewItem, 4)
            PlayerThoughtDB(Target, "SCLWFRRRefineSuccess")
            JMap.setInt(TargetData, "WF_TotalRefinedItems", JMap.getInt(TargetData, "WF_TotalRefinedItems") + 1)
          EndIf
        EndIf
      ElseIf BaseForm as Soulgem && PerkLevel >= 5
        Float Chance = 0.05
        Chance *= (JMap.getInt(TargetData, "WF_RefineItemBonus") / 100) + 1
        Float Success = Utility.RandomFloat()
        If Success < Chance
          Formlist RefineList
          If SCL_SoulGemLargeList.HasForm(BaseForm)
            RefineList = SCL_WF_RefineSoulGemLargeList
          ElseIf SCL_SoulGemMediumList.HasForm(BaseForm)
            RefineList = SCL_WF_RefineSoulGemMediumList
          ElseIf SCL_SoulGemSmallList.HasForm(BaseForm)
            RefineList = SCL_WF_RefineSoulGemSmallList
          EndIf
          Int Index = Utility.RandomInt(0, RefineList.GetSize() - 1)
          Form NewItem = RefineList.GetAt(Index)
          SCLib.addItem(Target, None, NewItem, 4)
          PlayerThoughtDB(Target, "SCLWFRRRefineSuccess")
          JMap.setInt(TargetData, "WF_TotalRefinedItems", JMap.getInt(TargetData, "WF_TotalRefinedItems") + 1)
        EndIf
      EndIf
    EndIf
  EndIf
EndEvent
