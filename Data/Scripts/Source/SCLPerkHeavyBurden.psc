ScriptName SCLPerkHeavyBurden Extends SCLPerkBase
MagicEffect Property SCL_HeavyBurdenReqTrackerEffect Auto ;goes on a spell attached to reference alias, conditioned to recognize heavy effects

Function Setup()
  Description = New String[6]
  Description[0] = "Allows actor to move freely when their weight is high."
  Description[1] = "Allows actor to move freely when their weight exceeds " + (100 * (1 + 1)) + "."
  Description[2] = "Allows actor to move freely when their weight exceeds " + (100 * (2 + 1)) + "."
  Description[3] = "Allows actor to move freely when their weight exceeds " + (100 * (3 + 1)) + "."
  Description[4] = "Allows actor to move freely when their weight exceeds " + (100 * (4 + 1)) + "."
  Description[5] = "Allows actor to move freely when their weight exceeds " + (100 * (5 + 1)) + "."

  Requirements = New String[6]
  Requirements[0] = "No Requirements."
  Requirements[1] = "Have " + (150 * (1 + 1)) + " units in your stomach at some point and reach level " + (150 * (1 + 1)) / 10 + "."
  Requirements[2] = "Have " + (150 * (2 + 1)) + " units in your stomach at some point and reach level " + (150 * (2 + 1)) / 10 + "."
  Requirements[3] = "Have " + (150 * (3 + 1)) + " units in your stomach at some point and reach level " + (150 * (3 + 1)) / 10 + "."
  Requirements[4] = "Have " + (150 * (4 + 1)) + " units in your stomach at some point and reach level " + (150 * (4 + 1)) / 10 + "."
  Requirements[5] = "Have " + (150 * (5 + 1)) + " units in your stomach at some point and reach level " + (150 * (5 + 1)) / 10 + "."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Int MaxWeight = 150 * (aiPerkLevel + 1)
  Int Level = akTarget.GetLevel()
  If aiPerkLevel <= 5 && (abOverride || (akTarget.HasMagicEffect(SCL_HeavyBurdenReqTrackerEffect) && Level >= MaxWeight / 10))
    Return True
  Else
    Return False
  EndIf
EndFunction
