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
  Requirements[1] = "Digest a total of at least 10 units food."
  Requirements[2] = "Digest a total of at least 25 units food."
  Requirements[3] = "Digest a total of at least 45 units food."
  Requirements[4] = "Digest a total of at least 60 units food."
  Requirements[5] = "Digest a total of at least 90 units food."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Int Req
  If aiPerkLevel == 1
    Req = 10
  ElseIf aiPerkLevel == 2
    Req = 25
  ElseIf aiPerkLevel == 3
    Req = 45
  ElseIf aiPerkLevel == 4
    Req = 60
  ElseIf aiPerkLevel == 5
    Req = 90
  ElseIf aiPerkLevel >= 6
    Return False
  EndIf
  Float DigestFood = JMap.getFlt(TargetData, "STTotalDigestedFood")
  If (DigestFood >= Req || abOverride)
    ;Notice("Returning true")
    Return True
  Else
    ;Notice("Returning false")
    Return False
  EndIf
EndFunction
