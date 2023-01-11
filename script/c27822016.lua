--激流幻灵
function c27822016.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(27822016,0))
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,27822016) 
	e1:SetCost(c27822016.cost)
	e1:SetTarget(c27822016.sptg)
	e1:SetOperation(c27822016.spop)
	c:RegisterEffect(e1) 
	--to grave 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1,17822016) 
	e2:SetCondition(c27822016.tgcon) 
	e2:SetTarget(c27822016.tgtg) 
	e2:SetOperation(c27822016.tgop) 
	c:RegisterEffect(e2) 
end 
c27822016.XXSplash=true 
function c27822016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c27822016.spfilter(c,e,tp)
	return c.XXSplash and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c27822016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27822016.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c27822016.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27822016.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then 
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c27822016.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c27822016.splimit(e,c)
	return not c.XXSplash 
end
function c27822016.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():IsReason(REASON_LINK) and e:GetHandler():IsReason(REASON_MATERIAL) 
end 
function c27822016.tgfil(c) 
	return c:IsAbleToGrave() and c.XXSplash and c:IsType(TYPE_MONSTER)  
end  
function c27822016.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c27822016.tgfil,tp,LOCATION_REMOVED,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c27822016.tgfil,tp,LOCATION_REMOVED,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
end  
function c27822016.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	Duel.SendtoGrave(tc,REASON_EFFECT) 
	end 
end 






