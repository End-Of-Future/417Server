--激流之共鸣灵
function c27822010.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27822010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DRAW) 
	e1:SetCountLimit(1,27822010)
	e1:SetCost(c27822010.spcost)
	e1:SetTarget(c27822010.sptg)
	e1:SetOperation(c27822010.spop)
	c:RegisterEffect(e1)	 
	--to deck 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,27822010+EFFECT_COUNT_CODE_OATH) 
	e2:SetTarget(c27822010.tdtg) 
	e2:SetOperation(c27822010.tdop) 
	c:RegisterEffect(e2) 
end 
c27822010.XXSplash=true 
function c27822010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c27822010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c27822010.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c.XXSplash 
end
function c27822010.spfilter(c,e,tp)
	return c.XXSplash and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27822010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27822010.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c27822010.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(27822010,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c27822010.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c27822010.dckfil(c)   
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c.XXSplash  
end 
function c27822010.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c27822010.dckfil,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0) 
end 
function c27822010.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT) 
	end
end 



