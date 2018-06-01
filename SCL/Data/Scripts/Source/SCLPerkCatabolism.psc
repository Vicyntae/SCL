ScriptName SCLPerkCatabolism Extends SCLPerkBase
Perk Property Poisoner Auto
Perk Property ConcentratedPoison Auto
Perk Property Snakeblood Auto
Perk Property Purity Auto

Function Setup()
  Description = New String[6]
  Description[0] = "Increases digestion rate."
  Description[1] = "Increases digestion rate by 0.5."
  Description[2] = "Increases digestion rate by 1."
  Description[3] = "Increases digestion rate by 3."
  Description[4] = "Increases digestion rate by 5."
  Description[5] = "Increases digestion rate by 10."


  Requirements = New String[6]
  Requirements[0] = "No Requirements."
  Requirements[1] = "Have at least 20 Alchemy, and be at least level 10."
  Requirements[2] = "Have at least 30 Alchemy, be at least level 20, and have the perk 'Poisoner'."
  Requirements[3] = "Have at least 50 Alchemy, be at least level 30, and have the perk 'Concentrated Poison'."
  Requirements[4] = "Have at least 70 Alchemy, be at least level 40, and have the perk 'Snakeblood'."
  Requirements[5] = "Have at least 90 Alchemy, be at least level 50, and have the perk 'Purity'."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= AbilityArray.Length - 1
    Return True
  EndIf
  Int Alchemy = PlayerRef.GetActorValue("Alchemy") as Int
  Int Level = akTarget.getLevel()
  If aiPerkLevel == 1 && Alchemy >= 20 && Level >= 10
    Return True
  ElseIf aiPerkLevel == 2 && Alchemy >= 30 && Level >= 20 && PlayerRef.HasPerk(Poisoner)
    Return True
  ElseIf aiPerkLevel == 3 && Alchemy >= 50 && Level >= 30 && PlayerRef.HasPerk(ConcentratedPoison)
    Return True
  ElseIf aiPerkLevel == 4 && Alchemy >= 70 && Level >= 40 && PlayerRef.HasPerk(Snakeblood)
    Return True
  ElseIf aiPerkLevel == 5 && Alchemy >= 90 && Level >= 50 && PlayerRef.HasPerk(Purity)
    Return True
  EndIf
  Return False
EndFunction

Bool Function takePerk(Actor akTarget, Bool abOverride = False, Int aiTargetData = 0)
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Int i = getFirstPerkLevel(akTarget) + 1
  If canTake(akTarget, i, abOverride)
    Float AddAmount
    If i == 1
      AddAmount = 0.5
    ElseIf i == 2
      AddAmount = 1
    ElseIf i == 3
      AddAmount = 3
    ElseIf i == 4
      AddAmount = 5
    ElseIf i == 5
      AddAmount = 10
    EndIf
    JMap.setFlt(TargetData, "STDigestionRate", JMap.getFlt(TargetData, "STDigestionRate", 0.5) + AddAmount)
    akTarget.AddSpell(AbilityArray[i], True)
    Return True
  Else
    Notice("Actor ineligible for perk")
    Return False
  EndIf
EndFunction
