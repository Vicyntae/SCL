ScriptName SCLPerkExtractionExpert Extends SCLPerkBase

Function Setup()
  Name = "Extraction Expert"
  Description = New String[4]
  Description[0] = "Allows you to digest non-digestible items and obtain benefits."
  Description[1] = "Allows you to digest armor and gain a small boost to damage resist."
  Description[2] = "Allows you to digest weapons and gain a small boost to melee damage."
  Description[3] = "Allows you to digest enchanted weapons and armor and gain a small boost to magic skills."

  Requirements = New String[4]
  Requirements[0] = "No Requirements."
  Requirements[1] = "Have at least 25 Smithing, 20 Light Armor, and 20 Heavy Armor."
  Requirements[2] = "Have at least 45 Smithing, 30 One-Handed, and 30 Two-Handed."
  Requirements[3] = "Have at least 60 Smithing, 40 Light Armor, 40 One-Handed, 40 Heavy Armor, 40 Two-Handed, and 50 Enchanting."
  RegisterForModEvent("SCLDigestItemFinishEvent", "OnItemDigestFinish")
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= 3
    Return True
  EndIf
  Int Smithing = akTarget.GetActorValue("Smithing") as Int
  Int LArmor = akTarget.GetActorValue("LightArmor") as Int
  Int HArmor = akTarget.GetActorValue("HeavyArmor") as Int
  Int OneHanded = akTarget.GetActorValue("OneHanded") as Int
  Int TwoHanded = akTarget.GetActorValue("TwoHanded") as Int
  Int Enchant = akTarget.GetActorValue("Enchanting") as Int
  If aiPerkLevel == 1 && Smithing >= 25 && LArmor >= 20 && HArmor >= 20
    Return True
  ElseIf aiPerkLevel == 2 && Smithing >= 45 && OneHanded >= 30 && TwoHanded >= 30
    Return True
  ElseIf aiPerkLevel == 3 && Smithing >= 60 && LArmor >= 40 && HArmor >= 40 && OneHanded >= 40 && TwoHanded >= 40 && Enchant >= 50
    Return True
  Else
    Return False
  EndIf
EndFunction

Event OnItemDigestFinish(Form akEater, Form akFood, Float afDigestValue)
  If akEater as Actor
    Actor Target = akEater as Actor
    If akFood as Weapon || akFood as Armor
      Int PerkLevel = getFirstPerkLevel(Target)
      Enchantment Ench
      If akFood as ObjectReference
        Ench = (akFood as ObjectReference).GetEnchantment()
      ElseIf akFood as Weapon
        Ench = (akFood as Weapon).GetEnchantment()
      ElseIf akFood as Armor
        Ench = (akFood as Armor).GetEnchantment()
      EndIf
      If Ench && PerkLevel >= 3
        Int EffectIndex = Ench.GetCostliestEffectIndex()
        Float AV
        Int i

        Float MAG = Ench.GetNthEffectMagnitude(EffectIndex)
        If MAG
          AV += MAG
          i += 1
        EndIf

        Int DUR = Ench.GetNthEffectDuration(EffectIndex)
        If DUR
          AV += DUR
          i += 1
        EndIf

        Int AREA = Ench.GetNthEffectArea(EffectIndex)
        If AREA
          AV += AREA
          i += 1
        EndIf
        AV /= i

        If AV > 0
          MagicEffect ME = Ench.GetNthEffectMagicEffect(EffectIndex)
          String Skill = ME.GetAssociatedSkill()
          Game.AdvanceSkill(Skill, AV)
        EndIf
      EndIf

      If akFood as Armor && PerkLevel >= 1
        Float AR = (akFood as Armor).GetArmorRating() / 500
        If AR
          Target.ModActorValue("ArmorPerks", AR)
        EndIf
      ElseIf akFood as Weapon && PerkLevel >= 2
        Float BD = (akFood as Weapon).GetBaseDamage() / 500
        If BD
          Target.ModActorValue("MeleeDamage", BD)
        EndIf
      EndIf
    EndIf
  EndIf
EndEvent

Function reloadMaintenence()
  Setup()
EndFunction
