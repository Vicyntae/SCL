ScriptName SCLPerkBase Extends ReferenceAlias Hidden

SCLibrary Property SCLib Auto
SCLSettings Property SCLSet Auto
;String Property PerkID Auto
String Property Name Auto
String[] Property Description Auto
String[] Property Requirements Auto
Spell[] Property AbilityArray Auto
Actor Property PlayerRef Auto
String Property DebugName
  String Function Get()
    Return "[SCLPerk " + GetName() + "] "
  EndFunction
EndProperty
Int DMID = 1

Event OnInit()
  ;Note("Setting up perk " + GetName())
  Utility.Wait(10)
  Setup()
  SCLibrary.addPerkID(GetName(), GetOwningQuest())
EndEvent

Function reloadMaintenence()
EndFunction

Function Setup()
EndFunction

String Function getPerkName(Int aiPerkLevel)
  If aiPerkLevel
    Return AbilityArray[aiPerkLevel].GetName()
  Else
    Return Name
  EndIf
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  Return False
EndFunction

Bool Function takePerk(Actor akTarget, Bool abOverride = False, Int aiTargetData = 0)
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Int i = getFirstPerkLevel(akTarget) + 1
  If canTake(akTarget, i, abOverride)
    akTarget.AddSpell(AbilityArray[i], True)
    Return True
  Else
    Notice("Actor ineligible for perk")
    Return False
  EndIf
EndFunction

String Function getDescription(Int aiPerkLevel = 0)
  If aiPerkLevel >= 0 && aiPerkLevel <= Description.Length - 1
    Return Description[aiPerkLevel]
  Else
    Return "Invalid Perk Level"
  EndIf
EndFunction

String Function getRequirements(Int aiPerkLevel = 0)
  If aiPerkLevel >= 0 && aiPerkLevel <= Requirements.Length - 1
    Return Requirements[aiPerkLevel]
  Else
    Return "Invalid Perk Level"
  EndIf
EndFunction

Int Function getFirstPerkLevel(Actor akTarget, Int aiTargetData = 0)
  Int i = AbilityArray.Length
  While i > 1
    i -= 1
    If akTarget.HasSpell(AbilityArray[i])
      Return i
    EndIf
  EndWhile
  Return 0
EndFunction

Bool Function isKnown(Actor akTarget)
  Return True
EndFunction

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Debug Functions
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Bool Function PlayerThought(Actor akTarget, String sMessage1 = "", String sMessage2 = "", String sMessage3 = "", Int iOverride = 0)
  {Use this to display player information. Returns whether the passed actor is
  the player.
  Make sure sMessage1 is 1st person, sMessage2 is 2nd person, sMessage3 is 3rd person
  Make sure at least one is filled: it will default to it regardless of setting
  Use iOverride to force a particular message}

  If akTarget == PlayerRef
    Int Setting = SCLSet.PlayerMessagePOV
    If Setting == -1
      Return True
    EndIf
    If (sMessage1 && Setting == 1) || iOverride == 1
      Debug.Notification(sMessage1)
    ElseIf (sMessage2 && Setting == 2) || iOverride == 2
      Debug.Notification(sMessage3)
    ElseIf (sMessage3 && Setting == 3) || iOverride == 3
      Debug.Notification(sMessage3)
    ElseIf sMessage3
      Debug.Notification(sMessage3)
    ElseIf sMessage1
      Debug.Notification(sMessage1)
    ElseIf sMessage2
      Debug.Notification(sMessage2)
    Else
      Issue("Empty player thought. Skipping...", 1)
    EndIf
    Return True
  Else
    Return False
  EndIf
EndFunction

Bool Function PlayerThoughtDB(Actor akTarget, String sKey, Int iOverride = 0, Int JA_Actors = 0, Int aiActorIndex = -1)
  {Use this to display player information. Returns whether the passed actor is
  the player.
  Pulls message from database; make sure sKey is valid.
  Will add POV int to end of key, so omit it in the parameter}
  Return SCLib.ShowPlayerThoughtDB(akTarget, sKey, iOverride, JA_Actors, aiActorIndex)
EndFunction

Function Popup(String sMessage)
  SCLib.ShowPopup(sMessage, DebugName)
EndFunction

Function Note(String sMessage)
  SCLib.ShowNote(sMessage, DebugName)
EndFunction

Function Notice(String sMessage, Int aiID = 0)
  Int ID
  If aiID > 0
    ID = aiID
  Else
    ID = DMID
  EndIf
  SCLib.showNotice(sMessage, ID, DebugName)
EndFunction

Function Issue(String sMessage, Int iSeverity = 0, Int aiID = 0, Bool bOverride = False)
  Int ID
  If aiID > 0
    ID = aiID
  Else
    ID = DMID
  EndIf
  SCLib.ShowIssue(sMessage, iSeverity, ID, bOverride, DebugName)
EndFunction
