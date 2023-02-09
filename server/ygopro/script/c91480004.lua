--class aoffghvlrbdddfqp3 : IDisposeable
local m=91480004
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.atg)
    e1:SetOperation(cm.aop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCountLimit(1,m+1)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(cm.tgcon)
    e2:SetTarget(cm.tgtg)
    e2:SetOperation(cm.tgop)
    c:RegisterEffect(e2)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.desreptg)
	e2:SetValue(cm.desrepval)
	e2:SetOperation(cm.desrepop)
	c:RegisterEffect(e2)
end
function cm.afilter(c)
    return c:IsSetCard(0x1551) and c:IsDestructable()
end
function cm.atg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.afilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function cm.aop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local tc=Duel.SelectMatchingCard(tp,cm.afilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
    if tc then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function cm.tgfilter1(c,tp)
    return c:IsSetCard(0x1551) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.tgfilter2(c)
    return c:IsSetCard(0x1551) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:Filter(cm.tgfilter1,nil,tp):GetCount()>=1
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tc=Duel.SelectMatchingCard(tp,cm.tgfilter2,tp,LOCATION_DECK,0,1,1,nil)
    if tc then
        Duel.SendtoGrave(tc,REASON_EFFECT)
    end
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0x1551)
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
