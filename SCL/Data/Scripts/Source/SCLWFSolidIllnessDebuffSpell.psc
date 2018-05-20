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
  If SCLSet.WF_Active && SCLSet.WF_SolidActive
    JMap.setFlt(ActorData, "WF_SolidCapMulti", JMap.getFlt(ActorData, "WF_SolidCapMulti") + Magnitude)
    AppliedValue = Magnitude
  EndIf
  RegisterForSingleUpdateGameTime(0.5)
EndEvent

Event OnUpdateGameTime()
  Float Chance = Utility.RandomFloat()
  If Chance < GetMagnitude()
    Float Fullness = JMap.getFlt(ActorData, "STFullness")
    If Fullness == 0
      SCLib.addVomitAcidDamageEffect(MyActor, ActorData)
    EndIf
    SCLib.vomitAmount(MyActor, 20, True, 10, True, 5)
    Int Illness = JMap.getInt(ActorData, "IllnessLevel")
    Illness -= 1
    If Illness < 0
      Illness = 0
    EndIf
    SCLib.WF_addSolidIllnessEffect(MyActor, Illness)
  EndIf
  RegisterForSingleUpdateGameTime(0.5)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  JMap.setFlt(ActorData, "WF_SolidCapMulti", JMap.getFlt(ActorData, "WF_SolidCapMulti") - AppliedValue)
EndEvent
