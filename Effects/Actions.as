namespace Effects
{
    bool IsEffectApplied(CTrackManiaGameTerminal@ playerControl, EffectType effectType)
    {
        auto controlledPlayer = cast<CTrackManiaPlayer>(playerControl.ControlledPlayer);
        switch(effectType)
        {
            case EffectType::LowGravity:
                return controlledPlayer.ScriptAPI.GravityCoef == 0.5;
            default:
                warn("This effect has no duration: " + tostring(effectType));
                return false;
        }
    }

    void OnEffectReceived(CTrackManiaGameTerminal@ playerControl, EffectType effectType)
    {
        switch(effectType)
        {
            case EffectType::LowGravity:
                SetTimedEffectTimer(effectType, 30000);
                ArmEffect(playerControl, effectType);
                break;
            case EffectType::ForceRestart:
                playerControl.ScriptedInputs_RequestGiveUp = true;
                break;
            case EffectType::ForceRespawn:
                playerControl.ScriptedInputs_RequestRespawn = true;
                break;
            default:
                // should only happen if _Count is used
                warn("Unknown effect: " + tostring(effectType));
        }
        Log::Log("Effect " + tostring(effectType) + " has been handled for player " + playerControl.ControlledPlayer.User.Login);
    }

    void ArmEffect(CTrackManiaGameTerminal@ playerControl, EffectType effectType)
    {
        switch(effectType)
        {
            case EffectType::LowGravity:
                if(!IsEffectApplied(playerControl, effectType))
                {
                    SendEffectEvent({tostring(effectType), "on"});
                }
                break;
            default:
                warn("This effect should not be armed: " + tostring(effectType));
        }
        // Log::Log("Armed " + tostring(effectType) + " effect to player " + playerControl.ControlledPlayer.User.Login);
    }
    void UnarmEffect(CTrackManiaGameTerminal@ playerControl, EffectType effectType)
    {
        switch(effectType)
        {
            case EffectType::LowGravity:
                SendEffectEvent({tostring(effectType), "off"});
                break;
            default:
                warn("This effect should not be unarmed: " + tostring(effectType));
        }
        // Log::Log("Unarmed " + tostring(effectType) + " effect to player " + playerControl.ControlledPlayer.User.Login);
    }
}