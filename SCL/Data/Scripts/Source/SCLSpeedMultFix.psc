ScriptName SCLSpeedMultFix Extends ActiveMagicEffect

Event OnEffectStart(Actor akTarget, Actor akCaster)
  akTarget.ModActorValue("CarryWeight", 0.1)
  akTarget.ModActorValue("CarryWeight", -0.1)
EndEvent