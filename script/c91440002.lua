--NaN·Max
local m=91440002
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddSynchroMixProcedure(c,cm.matfilter,nil,nil,aux.NonTuner(nil),1,99)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,m)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,m+1)
    e2:SetTarget(cm.stg)
    e2:SetOperation(cm.sop)
    c:RegisterEffect(e2)
end
function cm.matfilter(c)
    return c:IsSynchroType(TYPE_TUNER) or c:IsRace(RACE_MACHINE)
end
function cm.thfilter(c)
    return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if tc then
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end
function cm.sfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsSetCard(0x46) and c:IsAbleToHand()
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
        Duel.ConfirmCards(1-tp,tc)
    end
end
