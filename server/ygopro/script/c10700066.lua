--春巫 蓝莓
local m=10700066
local cm=_G["c"..m]

function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.lfcheck,1,1)
	c:EnableReviveLimit()
    --splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.regcon)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
    local e1=e0:Clone()
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(cm.regop2)
	c:RegisterEffect(e1)
    --effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCode(EFFECT_ADD_TYPE)
	e4:SetTarget(cm.eftg)
	e4:SetValue(TYPE_TUNER)
	c:RegisterEffect(e4)
end

function cm.lfcheck(c)
	return not c:IsType(TYPE_LINK) and c:IsRace(RACE_SPELLCASTER)
end

function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSummonLocation,tp,0x04,0x04,nil,LOCATION_EXTRA)
    if Duel.GetFlagEffect(tp,m)==0 and #g>0 then
        Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
        Duel.Hint(HINT_CARD,0,m)
        Duel.Recover(tp,#g*100,REASON_EFFECT)
    end
end

function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(m) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.eftg(e,c)
    local g=e:GetHandler():GetLinkedGroup()
    if g then
	    return e:GetHandler():GetLinkedGroup():IsContains(c) and not c:IsType(TYPE_TOKEN) and not c:IsLevel(0)
    else
        return false
    end
end