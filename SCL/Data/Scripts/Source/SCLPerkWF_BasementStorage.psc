ScriptName SCLPerkWF_BasementStorage Extends SCLPerkBase

Function Setup()
  Name = "Basement Storage"
  Description = New String[6]
  Description[0] = "Allows actor to store items in colon."
  Description[1] = "Allows actor to store items in colon."
  Description[2] = "Increases colon capacity by 1. Increases max insert size."
  Description[3] = "Increases colon capacity by 1. Increases max insert size."
  Description[4] = "Increases colon capacity by 2. Increases max insert size."
  Description[5] = "Increases colon capacity by 3. Increases max insert size."


  Requirements = New String[6]
  Requirements[0] = "No Requirements."
  Requirements[1] = "Reach Level 5."
  Requirements[2] = "Reach Level 10 and have at least 5 units of stuff in your colon at some point."
  Requirements[3] = "Reach Level 25 and have at least 10 units of stuff in your colon at some point."
  Requirements[4] = "Reach Level 40 and have at least 20 units of stuff in your colon at some point."
  Requirements[5] = "Reach Level 60 and have at least 30 units of stuff in your colon at some point."

EndFunction

Function reloadMaintenence()
  Setup()
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= AbilityArray.Length - 1
    Return True
  EndIf
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Bool ReqPerk = JMap.getInt(TargetData, "SCLWF_BasementStorageReq") as Bool
  Int Level = akTarget.getLevel()
  If aiPerkLevel == 1 && Level >= 5
    Return True
  ElseIf aiPerkLevel == 2 && Level >= 10 && ReqPerk
    Return True
  ElseIf aiPerkLevel == 3 && Level >= 25 && ReqPerk
    Return True
  ElseIf aiPerkLevel == 4 && Level >= 40 && ReqPerk
    Return True
  ElseIf aiPerkLevel == 5 && Level >= 60 && ReqPerk
    Return True
  Else
    Return False
  EndIf
EndFunction

Bool Function takePerk(Actor akTarget, Bool abOverride = False, Int aiTargetData = 0)
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Int i = getFirstPerkLevel(akTarget) + 1
  If canTake(akTarget, i, abOverride)
    Int AddAmount
    If i == 1
      AddAmount = 0
    ElseIf i == 2
      AddAmount = 1
    ElseIf i == 3
      AddAmount = 1
    ElseIf i == 4
      AddAmount = 2
    ElseIf i == 5
      AddAmount = 3
    EndIf
    If AddAmount
      JMap.setInt(TargetData, "WF_BasementStorage", JMap.getInt(TargetData, "WF_BasementStorage") + AddAmount)
    EndIf
    akTarget.AddSpell(AbilityArray[i], True)
    Return True
  Else
    Notice("Actor ineligible for perk")
    Return False
  EndIf
EndFunction
