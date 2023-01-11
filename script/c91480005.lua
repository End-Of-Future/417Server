--镚壞■笹堺
local m=91480005
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(cm.con)
    e1:SetTarget(cm.tg)
    e1:SetOperation(cm.op)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.stg)
    e2:SetOperation(cm.sop)
    c:RegisterEffect(e2)
end
function cm.afilter(c,tp)
    return c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.afilter,1,nil,tp)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,0,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    for tc in aux.Next(g) do
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
    end
end
function cm.sfilter(c)
    return c:IsSetCard(0x1550) and c:IsAbleToHand()
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tc=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil)
    if tc then
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
    end
end
