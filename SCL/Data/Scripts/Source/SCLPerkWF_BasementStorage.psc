ScriptName SCLPerkWF_BasementStorage Extends SCLPerkBase

Function Setup()
  Description = New String[2]
  Description[0] = "Allows actor to store items in colon."
  Description[1] = "Allows actor to store items in colon."

  Requirements = New String[2]
  Requirements[0] = "No Requirements."
  Requirements[1] = "Reach Level 5."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  If aiPerkLevel == 1 && (akTarget.GetLevel() >= 5 || abOverride)
    Return True
  Else
    Return False
  EndIf
EndFunction
