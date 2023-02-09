--不足为外人道也
local m=91460009
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,91460001)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetOperation(cm.op)
    c:RegisterEffect(e1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,PLAYER_ALL,m)
    local c=e:GetHandler()
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.efftg)
	e3:SetOperation(cm.effop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.efffilter(c)
    return aux.IsCodeListed(c,91460001) and c:IsSSetable()
end
function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanSSet(tp) and Duel.IsExistingMatchingCard(cm.efffilter,tp,LOCATION_GRAVE,0,3,nil) end
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local tg=Duel.SelectMatchingCard(tp,cm.efffilter,tp,LOCATION_GRAVE,0,3,3,nil)
    if tg and #tg==3 then
        local tc=tg:RandomSelect(1-tp,1)
        if tc then
            Duel.SSet(tp,tc)
        end
    end
end
