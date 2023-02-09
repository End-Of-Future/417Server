--五王的救赎
function c27819064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,27819064+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c27819064.cost)
	e1:SetTarget(c27819064.target) 
	e1:SetOperation(c27819064.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(27819064,ACTIVITY_SPSUMMON,c27819064.counterfilter)
end 
c27819064.SetCard_fiveking=true 
function c27819064.counterfilter(c)
	return c.SetCard_fiveking  
end 
function c27819064.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(27819064,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	e:SetLabelObject(g)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c27819064.splimit)
	Duel.RegisterEffect(e1,tp) 
end
function c27819064.splimit(e,c)
	return not c.SetCard_fiveking  
end
function c27819064.filter(c,e,tp)
	return c.SetCard_fiveking and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27819064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27819064.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c27819064.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c27819064.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsType(TYPE_XYZ) and e:GetLabelObject():IsCanOverlay() and Duel.SelectYesNo(tp,aux.Stringid(27819064,0)) then   
	Duel.Overlay(tc,e:GetLabelObject())  
	end
end

