ScriptName SCLWFSolidIllnessDebuffSpell Extends ActiveMagicEffect
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
Float AppliedValue

Event OnEffectStart(Actor akTarget, Actor akCaster)
  MyActor = akTarget
  Float Magnitude = GetMagnitude()
  JMap.setFlt(ActorData, "WF_SolidCapMulti", JMap.getFlt(ActorData, "WF_SolidCapMulti") + Magnitude)
  AppliedValue = Magnitude
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  JMap.setFlt(ActorData, "WF_SolidCapMulti", JMap.getFlt(ActorData, "WF_SolidCapMulti") - AppliedValue)
EndEvent
