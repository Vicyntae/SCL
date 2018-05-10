ScriptName SCLStartQuestScript Extends ReferenceAlias

Bool Done
SCLModConfig Property SCLMCM Auto
Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
  If !Done
    If akBaseObject as Potion
      If (akBaseObject as Potion).IsFood() || !(akBaseObject as Potion).IsPoison()
        SCLMCM.initializeMCM()
        Done = True
        Debug.Notification("SCL Started!")
      EndIf
    EndIf
  EndIf
EndEvent
