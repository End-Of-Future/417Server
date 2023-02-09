--镚壞-滁○
local m=91480008
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCondition(cm.dcon)
    e1:SetTarget(cm.dtg)
    e1:SetOperation(cm.dop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,m)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetTarget(cm.tftg)
    e2:SetOperation(cm.tfop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
    e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetTarget(cm.sptg)
    e4:SetOperation(cm.spop)
    c:RegisterEffect(e4)
end
function cm.dfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1551) and c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.dfilter,1,nil,tp)
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable() end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetTargetCard(e:GetHandler())
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.Destroy(c,REASON_EFFECT)
    end
end
function cm.tffilter(c)
    return c:IsSetCard(0x1551) and c:IsType(TYPE_PENDULUM) and c:IsAttack(0) and not c:IsForbidden()
end
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK,0,1,nil)
        and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local tc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end
function cm.spfilter(c,e,tp)
    return c:IsRace(RACE_PSYCHO) and c:IsAttack(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)>0 then
        local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e1:SetTargetRange(1,0)
	    e1:SetTarget(cm.splimit)
	    e1:SetReset(RESET_PHASE+PHASE_END)
	    Duel.RegisterEffect(e1,tp)
    end
end
function cm.splimit(e,c)
	return not c:IsSetCard(0x1551)
end
