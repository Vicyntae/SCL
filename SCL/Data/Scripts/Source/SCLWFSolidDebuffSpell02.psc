ScriptName SCLWFSolidDebuffSpell02 Extends ActiveMagicEffect
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
Event OnEffectStart(Actor akTarget, Actor akCaster)
  MyActor = akTarget
  OnUpdateGameTime()
EndEvent

Event OnUpdate()
  Float Chance = Utility.RandomFloat()
  Chance += JMap.getInt(ActorData, "WF_SolidIllnessLevel") / 20
  Float Success = 0.8
  If Chance > Success
    SCLib.WF_SolidRemove(MyActor)
  endIf
  RegisterForSingleUpdateGameTime(0.5)
EndEvent
