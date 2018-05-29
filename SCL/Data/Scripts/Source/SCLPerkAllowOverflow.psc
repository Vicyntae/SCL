ScriptName SCLPerkAllowOverflow Extends SCLPerkBase


Function Setup()
  Description = New String[2]
  Name = "Allow Overflow"
  Description[0] = "Allows actor to eat above the maximum without vomiting (other effects may apply)."
  Description[1] = "Allows actor to eat above the maximum without vomiting (other effects may apply)."

  Requirements = New String[2]
  Requirements[0] = "No Requirements."
  Requirements[1] = "Overeat and vomit at least 30 times, and reach level 30."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  If aiPerkLevel == 1 && (abOverride || JMap.getInt(TargetData, "SCLAllowOverflowTracking") >= 30)
    Return True
  Else
    Return False
  EndIf
EndFunction
