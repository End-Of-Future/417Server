--aoffghvlrbdddfqp3.Dispose()
local m=91480002
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(cm.tg)
    e1:SetOperation(cm.op)
    c:RegisterEffect(e1)
end
function cm.filter1(c)
    return c:IsSetCard(0x1551) and c:IsDestructable()
		and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
		and (c:IsType(TYPE_MONSTER) or c:IsLocation(LOCATION_PZONE))
end
function cm.filter2(c)
    return (c:IsSetCard(0x1550) or c:IsSetCard(0x1551)) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_PZONE,0,2,nil)
    and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_PZONE,0,nil)
    if #tg<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg=tg:Select(tp,2,2,nil)
    if dg and #dg==2 and Duel.Destroy(dg,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local tc=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)
        if tc then
            Duel.SendtoHand(tc,tp,REASON_EFFECT)
        end
    end
end
