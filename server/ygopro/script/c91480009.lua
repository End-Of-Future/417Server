--镚壞-冋歔
local m=91480009
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.dtg)
    e1:SetOperation(cm.dop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,m+1)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetTarget(cm.stg)
    e2:SetOperation(cm.sop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetTarget(cm.thtg)
    e4:SetOperation(cm.thop)
    c:RegisterEffect(e4)
end
function cm.dfilter(c)
    return (c:IsSetCard(0x1550) or c:IsSetCard(0x1551)) and c:IsAbleToDeck()
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK+CATEGORY_GRAVE_ACTION,nil,1,tp,LOCATION_GRAVE)
    Duel.SetTargetCard(e:GetHandler())
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_GRAVE,0,1,nil) then
        local tc=Duel.SelectMatchingCard(tp,cm.dfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        if tc then
            Duel.SendtoDeck(tc,tp,nil,REASON_EFFECT)
        end
    end
end
function cm.sfilter(c)
    return c:IsSetCard(0x1551) and c:IsFaceup() and not c:GetCurrentScale()~=9
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return cm.sfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.sfilter,tp,LOCATION_PZONE,0,1,nil) end
    Duel.SelectTarget(tp,cm.sfilter,tp,LOCATION_PZONE,0,1,1,nil)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(9)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		tc:RegisterEffect(e2)
    end
end
function cm.thfilter(c)
    return c:IsSetCard(0x1551) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if tc then
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end
