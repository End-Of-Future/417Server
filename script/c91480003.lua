--aoffghvlrbdddfqp3.ToString()
local m=91480003
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.tg)
    e1:SetOperation(cm.op)
    c:RegisterEffect(e1)
end
function cm.filter(c,code)
    return c:IsSetCard(0x1551) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(code)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local tc=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
    Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
    e:SetLabelObject(tc)
    e:SetLabel(tc:GetCode())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if (e:GetLabelObject():IsSetCard(0x1550) or e:GetLabelObject():IsSetCard(0x1551))
    and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e:GetLabel()) then
        e:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
    else
        e:SetCategory(0)
    end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    if (e:GetLabelObject():IsSetCard(0x1550) or e:GetLabelObject():IsSetCard(0x1551))
    and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e:GetLabel()) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetLabel())
        if tc then
            Duel.SendtoHand(tc,tp,REASON_EFFECT)
        end
    end
end
