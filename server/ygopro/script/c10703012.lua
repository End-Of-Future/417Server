--战华大苟-神荀彧
local m=10703012
local cm=_G["c"..m]

function cm.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_BEASTWARRIOR),4,5)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,m)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e8:SetValue(1)
    e8:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e8)
    local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_UPDATE_ATTACK)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
	e7:SetValue(cm.qjval)
	c:RegisterEffect(e7)
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.drcon1)
	e3:SetOperation(cm.drop1)
	c:RegisterEffect(e3)
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    local i=1
    while i<=8 do
	    local tc=Duel.CreateToken(tp,10703015)
        Duel.DisableShuffleCheck()
        if i<=4 then
            Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)
        else
            Duel.SendtoDeck(tc,1-tp,2,REASON_EFFECT)
        end
        i=i+1
    end
    Duel.ShuffleDeck(tp)
    Duel.ShuffleDeck(1-tp)
    Duel.Draw(tp,1,REASON_EFFECT)
    Duel.Draw(1-tp,1,REASON_EFFECT)
end

function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.CheckLPCost(tp,2000) and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(10703000,0))
end

function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,2000)
end

function cm.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end

function cm.qjval(e,tp,eg,ep,ev,re,r,rp)
    return 500*Duel.GetFieldGroupCount(tp,LOCATION_SZONE,LOCATION_SZONE)
end

function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end

function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Draw(tp,1,REASON_EFFECT)
end