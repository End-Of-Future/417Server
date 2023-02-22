--蚀暗兽 六翼鹿
--script by -k/3
local m=88881690
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,m)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,m+1)
    e2:SetCondition(cm.tgcon)
    e2:SetTarget(cm.tgtg)
    e2:SetOperation(cm.tgop)
    c:RegisterEffect(e2)
end
function cm.spfilter(c,tp)
    return (c:IsFaceup() or (c:IsLocation(LOCATION_GRAVE) and not c:IsHasEffect(EFFECT_NECRO_VALLEY))) and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:IsSetCard(0x891)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and cm.spfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)>0 and tc:IsRelateToEffect(e) and Duel.Equip(tp,tc,c) then
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(c)
		e1:SetValue(cm.eqlimit)
		tc:RegisterEffect(e1)
    end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.tgfilter(c)
    return c:IsSetCard(0x891) and c:IsAbleToGrave() and not c:IsCode(m)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipTarget()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_SZONE)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)>0
        and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
            local tc=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
            if tc then
                Duel.SendtoGrave(tc,REASON_EFFECT)
            end
        end
end
