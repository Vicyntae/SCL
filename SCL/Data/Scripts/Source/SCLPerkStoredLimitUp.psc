ScriptName SCLPerkStoredLimitUp Extends SCLPerkBase

Function Setup()
  Description = New String[6]
  Description[0] = "Allows you to store items in your stomach."
  Description[1] = "Increases item storage by 2."
  Description[2] = "Increases item storage by 2."
  Description[3] = "Increases item storage by 2."
  Description[4] = "Increases item storage by 2."
  Description[5] = "Increases item storage by 2."

  Requirements = New String[6]
  Requirements[0] = "No Requirements."
  Requirements[1] = "Have a stomach capacity greater than 25."
  Requirements[2] = "Have a stomach capacity greater than 50."
  Requirements[3] = "Have a stomach capacity greater than 75."
  Requirements[4] = "Have a stomach capacity greater than 115."
  Requirements[5] = "Have a stomach capacity greater than 150."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Int Req
  If aiPerkLevel == 1
    Req = 25
  ElseIf aiPerkLevel == 2
    Req == 50
  ElseIf aiPerkLevel == 3
    Req = 75
  ElseIf aiPerkLevel == 4
    Req = 115
  ElseIf aiPerkLevel == 5
    Req = 150
  EndIf
  If aiPerkLevel <= 5 && (abOverride || JMap.getFlt(TargetData, "STBase") >= Req)
    Return True
  Else
    Return False
  EndIf
EndFunction
