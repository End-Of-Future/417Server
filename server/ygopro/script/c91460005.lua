--村舍
local m=91460005
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,91460001)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(1463360080)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.scon)
    e1:SetTarget(cm.stg)
    e1:SetOperation(cm.sop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(1463360081)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.thcon)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
end
function cm.schk(c)
    return c:IsCode(91460001) and c:IsFaceup()
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.schk,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sfilter(c)
    return c:IsAbleToHand() and c:IsCode(91460006,91460007,91460008)
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
function cm.thchk(c,seq)
    return c:IsCode(91460001) and c:IsFaceup() and c:GetSequence()==seq
end
function cm.thfilter(c)
    if c:IsLocation(LOCATION_GRAVE) then return aux.IsCodeListed(c,91460001) and c:IsAbleToHand()
    else if c:IsLocation(LOCATION_REMOVED) then return aux.IsCodeListed(c,91460001) and c:IsAbleToHand() and c:IsFaceup() end
    end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.thchk,tp,LOCATION_MZONE,0,1,nil,aux.GetColumn(e:GetHandler(),tp))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if tc then
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
    end
end
