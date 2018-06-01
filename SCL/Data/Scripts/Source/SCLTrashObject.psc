ScriptName SCLTrashObject Extends ObjectReference

Event OnActivate(ObjectReference akActionRef)
  If akActionRef == Game.GetPlayer()
    RegisterForMenu("ContainerMenu")
  EndIf
EndEvent

Event OnMenuClose(string menuName)
  If GetNumItems() == 0
    Disable(True)
    DeleteWhenAble()
    SCLibrary.removeFromObjectTrashList(Self)
  EndIf
  UnregisterForMenu("ContainerMenu")
EndEvent
