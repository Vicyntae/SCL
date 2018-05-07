ScriptName SCLPerkBase Extends ReferenceAlias Hidden

SCLibrary Property SCLib Auto
SCLSettings Property SCLSet Auto
;String Property PerkID Auto
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
  Utility.Wait(2)
  Setup()
  SCLibrary.addPerkID(GetName(), GetOwningQuest())
EndEvent

Function Setup()
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  Return False
EndFunction

Bool Function takePerk(Actor akTarget, Int aiTargetData = 0)
  Int TargetData = SCLib.getData(akTarget, aiTargetData)
  Int i = getFirstPerkLevel(akTarget) + 1
  If canTake(akTarget, i, SCLSet.DebugEnable)
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
