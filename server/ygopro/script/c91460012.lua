--后遂无问津者
local m=91460012
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,91460001)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetCost(cm.ncost)
    e1:SetTarget(cm.ntg)
    e1:SetOperation(cm.nop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,m)
    e2:SetCost(cm.ncost)
    e2:SetTarget(cm.stg)
    e2:SetOperation(cm.sop)
    c:RegisterEffect(e2)
end
function cm.nfilter(c)
 return c:IsCode(91460001) and c:IsReleasable()
end
function cm.ncost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.nfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local tc=Duel.SelectMatchingCard(tp,cm.nfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Release(tc,REASON_COST)
end
function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
         return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
    if tc then
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
    end
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SSet(tp,c)
    end
end
