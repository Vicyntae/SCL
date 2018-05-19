ScriptName SCLWFSolidDebuffSpell01 Extends ActiveMagicEffect
SCLibrary Property SCLib Auto
SCLSettings Property SCLSet Auto
Actor _MyActor
Actor Property MyActor
  Actor Function Get()
    Return _MyActor
  EndFunction
  Function Set(Actor a_val)
    _MyActor = a_val
    ActorData = SCLib.getTargetData(a_val)
    MyActorName = a_val.GetLeveledActorBase().GetName()
  EndFunction
EndProperty
Int ActorData
String MyActorName

Float Property UpdateInterval
  Float Function Get()
    Float ReturnValue = 2
    Int Illness = JMap.getInt(ActorData, "WF_SolidIllnessLevel")
    If Illness > 0
      ReturnValue -= Illness / 5
      If ReturnValue <= 0
        ReturnValue = 0.1
      EndIf
    EndIf
    Return ReturnValue
  EndFunction
EndProperty

Int Property AppliedLevel
  Int Function Get()
    Return JMap.getInt(ActorData, "WF_AppliedSolidDebuffLevel")
  EndFunction

  Function Set(Int a_val)
    If a_val < 0
      a_val = 0
    EndIf

    SCLSet.WF_SolidDebuffSpells[a_val].Cast(MyActor)
    JMap.setInt(ActorData, "WF_AppliedSolidDebuffLevel", a_val)
  EndFunction
EndProperty


Event OnEffectStart(Actor akTarget, Actor akCaster)
  MyActor = akTarget
  Int a_Level = AppliedLevel
  If !a_Level
    a_Level = 1
  EndIf
  AppliedLevel = a_Level

  RegisterForSingleUpdateGameTime(UpdateInterval)
EndEvent

Event OnUpdateGameTime()
  AppliedLevel += 1
  RegisterForSingleUpdateGameTime(UpdateInterval)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  AppliedLevel = 0
EndEvent
