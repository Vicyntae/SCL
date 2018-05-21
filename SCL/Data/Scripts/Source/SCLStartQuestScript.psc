ScriptName SCLStartQuestScript Extends ReferenceAlias

SCLModConfig Property SCLMCM Auto
Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
  If !SCLMCM.MCMInitialized
    If akBaseObject as Potion
      If (akBaseObject as Potion).IsFood() || !(akBaseObject as Potion).IsPoison()
        SCLMCM.initializeMCM()
        Debug.Notification("SCL Started!")
        GoToState("Inactive")
      EndIf
    EndIf
  Else
    GoToState("Inactive")
  EndIf
EndEvent

State Inactive
EndState
