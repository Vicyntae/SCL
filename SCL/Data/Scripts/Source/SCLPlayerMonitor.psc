ScriptName SCLPlayerMonitor Extends SCLMonitor

Function Setup()
  Parent.Setup()
  RegisterForModEvent("SCLActionKeyChange", "OnActionKeyChange")
  RegisterForKey(SCLSet.ActionKey)
  RegisterForKey(SCLSet.WF_ActionKey)
  UnregisterForMenu("Console")
  RegisterForMenu("Console")
EndFunction

Function reloadMaintenence()
  Parent.reloadMaintenence()
  RegisterForModEvent("SCLActionKeyChange", "OnActionKeyChange")
  UnregisterForMenu("Console")
  RegisterForMenu("Console")
EndFunction

Event OnActionKeyChange()
  Notice("Action key changed")
  UnregisterForAllKeys()
  RegisterForKey(SCLSet.ActionKey)
  RegisterForKey(SCLSet.WF_ActionKey)
EndEvent

Event OnMenuOpen(string menuName)
  If menuName == "Console"
    RegisterForKey(28)
    RegisterForKey(156)
  EndIf
EndEvent

Event OnMenuClose(string menuName)
  If menuName == "Console"
    UnregisterForKey(28)
    UnregisterForKey(156)
  EndIf
EndEvent

Event OnKeyDown(int keyCode)
  If keyCode == SCLSet.ActionKey
    If Utility.IsInMenuMode()
      Return
    EndIf
    Notice("Action Key Pressed")
    ObjectReference CurrentRef = Game.GetCurrentCrosshairRef()
    If !LockEX()
      Return
    EndIf
    If !CurrentRef
      Notice("Sending menu open event for " + SCLib.nameGet(MyActor))
      SCLib.sendActorMainMenuOpenEvent(MyActor, 0)
    ElseIf CurrentRef as Actor
      If SCLSet.UIExtensionsInstalled
        Notice("Sending menu open event for " + SCLib.nameGet(CurrentRef))
        SCLib.sendActorMainMenuOpenEvent(CurrentRef as Actor, 0)
      Else
        Notice("Opening transfer menu for " + SCLib.nameGet(CurrentRef))
        Int Option = 1
        Bool Dest = SCLSet.PlayerAutoDestination
        If SCLib.getCurrentPerkLevel(CurrentRef as Actor, "WF_BasementStorage") >= 1
          If Dest && CurrentRef == PlayerRef
            Option = 2
          Else
            Option = SCLSet.SCL_MES_WF_StorageChoice.Show()
          EndIf
        EndIf
        If Option == 1
          SCLib.openTransferMenu(CurrentRef as Actor)
        ElseIf Option == 2
          SCLib.openTransferMenu(CurrentRef as Actor, "Colon")
        EndIf
      EndIf
    Else
      Form CurrentBase = CurrentRef.GetBaseObject()
      If CurrentBase as Potion || CurrentBase as Ingredient || CurrentBase as Ammo || CurrentBase as Armor || CurrentBase as Book || CurrentBase as LeveledItem || CurrentBase as MiscObject || CurrentBase as SoulGem || CurrentBase as Scroll || CurrentBase as Weapon
        ;Later: make it so that potions/ingredients not in containers are eaten?
        Int Option = 1
        Bool Dest = SCLSet.PlayerAutoDestination
        If SCLib.getCurrentPerkLevel(MyActor, "WF_BasementStorage") >= 1
          If Dest
            Option = 2
          Else
            Option = SCLSet.SCL_MES_WF_StorageChoice.Show()
          EndIf
        EndIf
        If Option == 1
          Float CurrentWeight = JMap.getFlt(ActorData, "STFullness")
          Float DigestValue = SCLib.genDigestValue(CurrentBase)
          Float MaxWeight = SCLib.getMax(MyActor, ActorData)
          If MaxWeight >= CurrentWeight + DigestValue
            Notice("Adding " + SCLib.nameGet(CurrentRef) + " to stomach")
            SCLib.addItem(MyActor, CurrentRef, CurrentBase, aiItemType = 2)
            SCLib.updateSingleContents(MyActor, 2)
            SCLib.quickUpdate(MyActor)
          Else
            PlayerThought(MyActor, "I can't swallow that! I'm too full!", "You can't swallow that! You're too full!", MyActorName + " can't swallow that! They're too full!")
          EndIf
        ElseIf Option == 2
          Float MaxWeight = SCLib.WF_getSolidMaxInsert(MyActor, ActorData)
          Int NumItems = SCLib.countItemTypes(MyActor, 4, True) + SCLib.countItemTypes(MyActor, 3, True)
          Int MaxNumItems = SCLib.WF_getSolidMaxNumItems(MyActor, ActorData)
          Float DigestValue = SCLib.genDigestValue(CurrentBase)
          If DigestValue <= MaxWeight && NumItems < MaxNumItems
            Notice("Adding " + SCLib.nameGet(CurrentRef) + " to colon")
            SCLib.addItem(MyActor, CurrentRef, CurrentBase, aiItemType = 4)
            SCLib.updateSingleContents(MyActor, 4)
            SCLib.quickUpdate(MyActor)
          Else
            PlayerThought(MyActor, "I can't store that! It's too big!", "You can't store that! It's too big!", MyActorName + " can't store that! It's too big!")
          EndIf
        EndIf
      EndIf
    EndIf
    UnlockEX()
  ElseIf keyCode == SCLSet.WF_ActionKey
    If Utility.IsInMenuMode()
      Return
    EndIf
    If !LockEX()
      Return
    EndIf
    If MyActor.IsSneaking()
      SCLib.WF_SolidRemove(MyActor, ActorData)
    Else
      If MyActor.GetLeveledActorBase().GetSex() == 1
        MyActor.StartSneaking()
      EndIf
      SCLib.WF_LiquidRemove(MyActor, ActorData)
      ;Play animation here
    EndIf
    UnlockEX()
  ElseIf keyCode == 28 || keyCode == 156
    ;Console Interface ---------------------------------------------------------
    ;Taken from post by milzschnitte
    ;https://www.loverslab.com/topic/58600-skyrim-custom-console-commands-using-papyrus/

    ;NEXT: provide console interface for setting options
    ;Cannot currently view stomach contents

    Int cmdCount = UI.GetInt("Console", "_global.Console.ConsoleInstance.Commands.length")
    If cmdCount > 0
      cmdCount -= 1
      String cmdLine = UI.GetString("Console","_global.Console.ConsoleInstance.Commands."+cmdCount)
      If cmdLine != ""
        Actor akTarget = Game.GetCurrentConsoleRef() as Actor
        If akTarget == None
          akTarget = PlayerRef
        EndIf
        Int TargetData = SCLib.getTargetData(akTarget)
        String[] cmd = StringUtil.Split(cmdLine, " ")
        SCLib.processConsoleInput(akTarget, cmd)
      EndIf
    EndIf
  EndIf
EndEvent

;Update Functions **************************************************************
Function performDailyUpdate(Actor akTarget)
  {Performs functions that should be done daily.}
  If SCLib.canTakeAnyPerk(akTarget)
    SCLib.sendTakePerkMessage(akTarget)
  EndIf
EndFunction
