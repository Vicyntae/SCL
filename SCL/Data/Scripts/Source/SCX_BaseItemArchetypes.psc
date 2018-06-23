ScriptName SCX_BaseItemArchetypes Extends ReferenceAlias Hidden
{AKA different "containers" that items can reside in that get removed in similar ways.
EX. Stomach, Colon, Vagina, etc.
ID = name of alias}

String Property DebugName
  String Function Get()
    Return "[SCLArch " + GetName() + "] "
  EndFunction
EndProperty

Int Property DMID = 2 Auto

Event OnInit()
  Utility.Wait(5)
  Int J = JDB.solveObj(".SCLExtraData.ItemArchetypes")
  If !J
    J = JMap.object()
    JDB.solveObjSetter(".SCLExtraData.ItemArchetypes", J, True)
  EndIf
  JMap.setForm(J, GetName(), GetOwningQuest())
  Setup()
EndEvent
Actor Property PlayerRef Auto
Int[] Property ItemTypes Auto
Int[] Property ItemStoredTypes Auto ;Any items with the key "StoredItemType" will be searched for and obtained in these JFormMaps

Int Property MainStorageType = 0 Auto ;Where are items stored?
Int Property MainBreakdownType = 0 Auto ;Where are they broken down?
Int Property MainBuildupType = 0 Auto   ;Where are the built up?

Function Setup()
EndFunction

Function removeAllActorItems(Actor akTarget, Bool ReturnItems = False)
EndFunction

Function removeAmountActorItems(Actor akTarget, Float afRemoveAmount, Bool abRemoveStored = False, Int aiStoredRemoveChance = 0, Bool abRemoveOtherItems = False, Int aiOtherRemoveChance = 0)
EndFunction

Function removeSpecificActorItems(Actor akTarget, Int aiItemType, ObjectReference akReference = None, Form akBaseObject = None, Int aiItemCount = 1, Bool abDestroyDigestItems = True)
EndFunction

ObjectReference Function performRemove(Actor akTarget, Bool abLeveled)
EndFunction
