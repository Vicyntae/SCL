ScriptName SCLPerkWF_BottomsUp Extends SCLPerkBase

Formlist Property SCL_WF_BreakdownPotionTempBuffList Auto
Formlist Property SCL_WF_BreakdownArmorTempBuffList Auto
Formlist Property SCL_WF_BreakdownWeaponTempBuffList Auto
Formlist Property SCL_WF_BreakdownSoulGemTempBuffList Auto

Function Setup()
  Name = "Bottoms Up!"
  Description = New String[6]
  Description[0] = "Allows actor to break down items in the colon."
  Description[1] = "Allows actor to break down items in the colon. Broken down items give temporary benefits."
  Description[2] = "Increases breakdown speed by 1 unit/hour."
  Description[3] = "Increases breakdown speed by 1 unit/hour, and an additional unit when there are 15 or more items breaking down."
  Description[4] = "Increases breakdown speed by 1 unit/hour. Small chance to get a permanent benefit. Potions increase Magicka Regeneration, Armor increases Health Regeneration, Weapons increase Stamina Regeneration, Soulgems increase Magic Resist."
  Description[5] = "Increases breakdown speed by 1 unit/hour, and an additional 2 units when there are 10 or more items breaking down. Doubles permanent benefits gained."

  Requirements = New String[6]
  Requirements[0] = "No Requirements."
  Requirements[1] = "Possess the Basement Storage 1 perk, digest at least 1000 units of items in your stomach, and be at level 10."
  Requirements[2] = "Possess the Basement Storage 1 perk, digest at least 500 units of items in your colon, and be at level 20."
  Requirements[3] = "Possess the Basement Storage 2 perk, digest at least 1000 units of items in your colon, and be at level 30."
  Requirements[4] = "Possess the Basement Storage 2 perk, digest at least 3000 units of items in your colon, and be at level 40."
  Requirements[5] = "Possess the Basement Storage 3 perk, digest at least 7000 units of items in your colon, be at level 50, and gain permanent benefits from breaking down items 10 times."
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
  Int Basement = SCLib.getCurrentPerkLevel(akTarget, "WF_BasementStorage")
  Float TotalDigested = JMap.getFlt(TargetData, "STTotalDigestedFood")
  Float TotalBrokenDown = JMap.getFlt(TargetData, "WF_TotalBrokenDown")
  Int Level = akTarget.GetLevel()
  Int Boosts = JMap.getInt(TargetData, "WF_TotalPermBoostsGained")
  If aiPerkLevel == 1 && Basement >= 1 && TotalDigested >= 1000 && Level >= 10
    Return True
  ElseIf aiPerkLevel == 2 && Basement >= 1 && TotalBrokenDown >= 500 && Level >= 20
    Return True
  ElseIf aiPerkLevel == 3 && Basement >= 2 && TotalBrokenDown >= 1000 && Level >= 30
    Return True
  ElseIf aiPerkLevel == 4 && Basement >= 2 && TotalBrokenDown >= 3000 && Level >= 40
    Return True
  ElseIf aiPerkLevel == 5 && Basement >= 3 && TotalBrokenDown >= 7000 && Level >= 50 && Boosts >= 10
    Return True
  Else
    Return 0
  EndIf
EndFunction

Bool Function takePerk(Actor akTarget, Bool abOverride = False, Int aiTargetData = 0)
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Int i = getFirstPerkLevel(akTarget) + 1
  If canTake(akTarget, i, abOverride)
    Float AddAmount1
    Float AddAmount2
    If i == 1
      JMap.setFlt(TargetData, "WF_SolidBreakDownRate", 0.5)
    ElseIf i == 2
      AddAmount1 = 1
    ElseIf i == 3
      AddAmount1 = 1
      AddAmount2 = 1
    ElseIf i == 4
      AddAmount1 = 1
    ElseIf i == 5
      AddAmount1 = 1
      AddAmount2 = 2
    EndIf
    If AddAmount1
      JMap.setFlt(TargetData, "WF_SolidBreakDownRate", JMap.getFlt(TargetData, "WF_SolidBreakDownRate") + AddAmount1)
    EndIf
    If AddAmount2
      JMap.setFlt(TargetData, "WF_SolidBreakDownBonusRate", JMap.getFlt(TargetData, "WF_SolidBreakDownBonusRate") + AddAmount1)
    EndIf
    akTarget.AddSpell(AbilityArray[i], True)
    Return True
  Else
    Notice("Actor ineligible for perk")
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
      If BaseForm as Potion
        Int Index = Utility.RandomInt(0, SCL_WF_BreakdownPotionTempBuffList.GetSize() - 1)
        Form Buff = SCL_WF_BreakdownPotionTempBuffList.GetAt(Index)
        If Buff as Spell
          (Buff as Spell).Cast(Target)
        EndIf
        Debug.Notification("Gained buff " + Buff.GetName() + " from breaking down " + BaseForm.GetName())
        JMap.setInt(TargetData, "WF_TotalTempBoostsGained", JMap.getInt(TargetData, "WF_TotalTempBoostsGained") + 1)
        If PerkLevel >= 4
          Float Success = Utility.RandomFloat()
          If Success <= 0.01
            If PerkLevel >= 5
              Target.ModActorValue("MagickaRate", 0.2)
            Else
              Target.ModActorValue("MagickaRate", 0.1)
            EndIf
            If Target == PlayerRef
              Debug.Notification("Magicka Regeneration increased from breaking down " + BaseForm.GetName())
            EndIf
            JMap.setInt(TargetData, "WF_TotalPermBoostsGained", JMap.getInt(TargetData, "WF_TotalPermBoostsGained") + 1)
          EndIf
        EndIf
      ElseIf BaseForm as Armor
        Int Index = Utility.RandomInt(0, SCL_WF_BreakdownArmorTempBuffList.GetSize() - 1)
        Form Buff = SCL_WF_BreakdownArmorTempBuffList.GetAt(Index)
        If Buff as Spell
          (Buff as Spell).Cast(Target)
        EndIf
        Debug.Notification("Gained buff " + Buff.GetName() + " from breaking down " + BaseForm.GetName())
        JMap.setInt(TargetData, "WF_TotalTempBoostsGained", JMap.getInt(TargetData, "WF_TotalTempBoostsGained") + 1)
        If PerkLevel >= 4
          Float Success = Utility.RandomFloat()
          If Success <= 0.01
            If PerkLevel >= 5
              Target.ModActorValue("HealRate", 0.2)
            Else
              Target.ModActorValue("HealRate", 0.1)
            EndIf
            If Target == PlayerRef
              Debug.Notification("Health Regeneration increased from breaking down " + BaseForm.GetName())
            EndIf
            JMap.setInt(TargetData, "WF_TotalPermBoostsGained", JMap.getInt(TargetData, "WF_TotalPermBoostsGained") + 1)
          EndIf
        EndIf
      ElseIf BaseForm as Weapon
        Int Index = Utility.RandomInt(0, SCL_WF_BreakdownWeaponTempBuffList.GetSize() - 1)
        Form Buff = SCL_WF_BreakdownWeaponTempBuffList.GetAt(Index)
        If Buff as Spell
          (Buff as Spell).Cast(Target)
        EndIf
        Debug.Notification("Gained buff " + Buff.GetName() + " from breaking down " + BaseForm.GetName())
        JMap.setInt(TargetData, "WF_TotalTempBoostsGained", JMap.getInt(TargetData, "WF_TotalTempBoostsGained") + 1)
        If PerkLevel >= 4
          Float Success = Utility.RandomFloat()
          If Success <= 0.01
            If PerkLevel >= 5
              Target.ModActorValue("StaminaRate", 0.2)
            Else
              Target.ModActorValue("StaminaRate", 0.1)
            EndIf
            If Target == PlayerRef
              Debug.Notification("Stamina Regeneration increased from breaking down " + BaseForm.GetName())
            EndIf
            JMap.setInt(TargetData, "WF_TotalPermBoostsGained", JMap.getInt(TargetData, "WF_TotalPermBoostsGained") + 1)
          EndIf
        EndIf
      ElseIf BaseForm as SoulGem
        Int Index = Utility.RandomInt(0, SCL_WF_BreakdownSoulGemTempBuffList.GetSize() - 1)
        Form Buff = SCL_WF_BreakdownSoulGemTempBuffList.GetAt(Index)
        If Buff as Spell
          (Buff as Spell).Cast(Target)
        EndIf
        Debug.Notification("Gained buff " + Buff.GetName() + " from breaking down " + BaseForm.GetName())
        JMap.setInt(TargetData, "WF_TotalSoulgemTempBoostsGained", JMap.getInt(TargetData, "WF_TotalTempBoostsGained") + 1)
        If PerkLevel >= 4
          Float Success = Utility.RandomFloat()
          If Success <= 0.01
            If PerkLevel >= 5
              Target.ModActorValue("MagicResist", 0.2)
            Else
              Target.ModActorValue("MagicResist", 0.1)
            EndIf
            If Target == PlayerRef
              Debug.Notification("Magic Resist increased from breaking down " + BaseForm.GetName())
            EndIf
            JMap.setInt(TargetData, "WF_TotalPermBoostsGained", JMap.getInt(TargetData, "WF_TotalPermBoostsGained") + 1)
          EndIf
        EndIf
      EndIf
    EndIf
  EndIf
EndEvent
