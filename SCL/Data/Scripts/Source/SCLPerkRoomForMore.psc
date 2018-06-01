ScriptName SCLPerkRoomForMore Extends SCLPerkBase

Function Setup()
  Name = "Room for More"
  Description = New String[9]
  Description[0] = "Increases base capacity."
  Description[1] = "Increases base capacity by 2.5."
  Description[2] = "Increases base capacity by 5."
  Description[3] = "Increases base capacity by 10."
  Description[4] = "Increases base capacity by 15."
  Description[5] = "Increases base capacity by 10%."
  Description[6] = "Increases base capacity by 20%."
  Description[7] = "Increases base capacity by 30%."
  Description[8] = "Increases base capacity by 50%."


  Requirements = New String[9]
  Requirements[0] = "No Requirements."
  Requirements[1] = "Digest a total of at least 50 units of food."
  Requirements[2] = "Digest a total of at least 150 units of food."
  Requirements[3] = "Digest a total of at least 500 units of food."
  Requirements[4] = "Digest a total of at least 1000 units of food."
  Requirements[5] = "Digest a total of at least 3000 units of food."
  Requirements[6] = "Digest a total of at least 7500 units of food."
  Requirements[7] = "Digest a total of at least 10000 units of food."
  Requirements[8] = "Digest a total of at least 100000 units of food."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= AbilityArray.Length - 1
    Return True
  EndIf
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Int Req
  If aiPerkLevel == 1
    Req = 50
  ElseIf aiPerkLevel == 2
    Req = 150
  ElseIf aiPerkLevel == 3
    Req = 500
  ElseIf aiPerkLevel == 4
    Req = 1000
  ElseIf aiPerkLevel == 5
    Req = 3000
  ElseIf aiPerkLevel == 6
    Req = 7500
  ElseIf aiPerkLevel == 7
    Req = 10000
  ElseIf aiPerkLevel == 8
    Req = 100000
  ElseIf aiPerkLevel >= 9
    Return False
  EndIf
  Float DigestFood = JMap.getFlt(TargetData, "STTotalDigestedFood")
  If DigestFood >= Req
    ;Notice("Returning true")
    Return True
  Else
    ;Notice("Returning false")
    Return False
  EndIf
EndFunction

Bool Function takePerk(Actor akTarget, Bool abOverride = False, Int aiTargetData = 0)
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Int i = getFirstPerkLevel(akTarget) + 1
  If canTake(akTarget, i, abOverride)
    Float AddAmount
    If i == 1
      AddAmount = 2.5
    ElseIf i == 2
      AddAmount = 5
    ElseIf i == 3
      AddAmount = 10
    ElseIf i == 4
      AddAmount = 15
    ElseIf i == 5
      AddAmount = JMap.getFlt(TargetData, "STBase") * 0.1
    ElseIf i == 6
      AddAmount = JMap.getFlt(TargetData, "STBase") * 0.2
    ElseIf i == 7
      AddAmount = JMap.getFlt(TargetData, "STBase") * 0.3
    ElseIf i == 8
      AddAmount = JMap.getFlt(TargetData, "STBase") * 0.5
    EndIf
    JMap.setFlt(TargetData, "STBase", JMap.getFlt(TargetData, "STBase") + AddAmount)
    akTarget.AddSpell(AbilityArray[i], True)
    Return True
  Else
    Notice("Actor ineligible for perk")
    Return False
  EndIf
EndFunction
