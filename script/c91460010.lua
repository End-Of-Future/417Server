--太守
local m=91460010
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,91460001)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(cm.scon)
    e1:SetTarget(cm.stg)
    e1:SetOperation(cm.sop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,m)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(function (c)return c:IsFaceup() and c:IsCode(91460001) end,tp,LOCATION_MZONE,0,1,nil)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.spfilter(c)
    return c:IsCode(91460001) and c:IsFaceup()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil)
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP) then
	    local e2=Effect.CreateEffect(c)
	    e2:SetType(EFFECT_TYPE_SINGLE)
	    e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	    e2:SetValue(LOCATION_REMOVED)
	    c:RegisterEffect(e2)
    end
end
