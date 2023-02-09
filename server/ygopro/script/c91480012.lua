--镚壞鍺-恉針
local m=91480012
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_MSET)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCost(cm.spcost)
    e3:SetTarget(cm.sptg)
    e3:SetOperation(cm.spop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_LVCHANGE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,m)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetTarget(cm.ltg)
    e4:SetOperation(cm.lop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCountLimit(1,m+1)
    e5:SetTarget(cm.tg)
    e5:SetOperation(cm.op)
    c:RegisterEffect(e5)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local tg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_MZONE,0,2,2,nil)
    Duel.Destroy(tg,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0  then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)>0 then
	    local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetCode(EFFECT_UPDATE_ATTACK)
	    e1:SetValue(cm.atkval)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	    c:RegisterEffect(e1)
    end
end
function cm.atkval(e,c)
    return e:GetHandler():GetLevel()*300
end
function cm.lfilter(c)
    return c:IsSetCard(0x1551) and c:IsType(TYPE_MONSTER)
        and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
end
function cm.ltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return cm.lfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.lfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
    local tc=Duel.SelectTarget(tp,cm.lfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    if tc:GetLevel()>4 then
        local i=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
        e:SetLabel(i)
    else
        local i=Duel.SelectOption(tp,aux.Stringid(m,0))
        e:SetLabel(i)
    end
    Duel.SetOperationInfo(0,CATEGORY_LVCHANGE,tc,1,0,0)
end
function cm.lop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_LEVEL)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        local i=e:GetLabel()
        if i==0 then
            e1:SetValue(4)
        elseif i==1 and tc:GetLevel()>4 then
            e1:SetValue(-4)
        end
        tc:RegisterEffect(e1)
    end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,e:GetHandler():GetLocation())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)
    end
end
