--aoffghvlrbdddfqp3()
local m=91480001
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(cm.settg)
    e1:SetOperation(cm.setop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,m+1)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetTarget(cm.dtg)
    e2:SetOperation(cm.dop)
    c:RegisterEffect(e2)
end
function cm.setfilter(c)
    return c:IsSetCard(0x1551) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.setfilter2(c)
    return c:IsFaceup() and c:IsSetCard(0x1551) and c:IsDestructable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil)
        and Duel.IsExistingMatchingCard(cm.setfilter2,tp,LOCATION_PZONE,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0):Filter(cm.setfilter2,nil)
    if tg and Duel.Destroy(tg,REASON_EFFECT)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
        end
    end
end
function cm.dfilter(c)
    return c:IsType(TYPE_LINK) and c:IsSetCard(0x1551)
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tc=eg:Filter(cm.dfilter,nil):GetFirst()
    if chkc then return cm.dfilter(chkc) end
    if chk==0 then return eg:Filter(cm.dfilter,nil):GetCount()==1 and tc:IsOnField() and tc:IsCanBeEffectTarget(e)
    and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
    Duel.SetTargetCard(tc)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) then
        local tc2=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
        if tc2 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
            Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
        end
    end
end
