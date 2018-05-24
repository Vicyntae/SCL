ScriptName SCLPerkRoomForMore Extends SCLPerkBase

Function Setup()
  Description = New String[6]
  Description[0] = "Increases base capacity."
  Description[1] = "Increases base capacity by 2.5."
  Description[2] = "Increases base capacity by 5."
  Description[3] = "Increases base capacity by 10."
  Description[4] = "Increases base capacity by 15."
  Description[5] = "Increases base capacity by 10%."

  Requirements = New String[6]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Digest a total of at least 15 units food."
  Requirements[2] = "Digest a total of at least 50 units food."
  Requirements[3] = "Digest a total of at least 150 units food."
  Requirements[4] = "Digest a total of at least 400 units food."
  Requirements[5] = "Digest a total of at least 1000 units food."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel < AbilityArray.Length
    Return True
  EndIf
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Int Req
  If aiPerkLevel == 1
    Req = 15
  ElseIf aiPerkLevel == 2
    Req = 50
  ElseIf aiPerkLevel == 3
    Req = 150
  ElseIf aiPerkLevel == 4
    Req = 400
  ElseIf aiPerkLevel == 5
    Req = 1000
  ElseIf aiPerkLevel >= 6
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
    EndIf
    JMap.setFlt(TargetData, "STBase", JMap.getFlt(TargetData, "STBase") + AddAmount)
    akTarget.AddSpell(AbilityArray[i], True)
    Return True
  Else
    Notice("Actor ineligible for perk")
    Return False
  EndIf
EndFunction
