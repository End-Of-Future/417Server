--激流之蓝精灵
function c27822015.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27822015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,27822015)
	e1:SetCondition(c27822015.spcon1)
	e1:SetTarget(c27822015.sptg1)
	e1:SetOperation(c27822015.spop1)
	c:RegisterEffect(e1)  
	--
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,17822015) 
	e2:SetTarget(c27822015.tdtg) 
	e2:SetOperation(c27822015.tdop) 
	c:RegisterEffect(e2)   
end 
c27822015.XXSplash=true 
function c27822015.cfilter(c)
	return c:IsFaceup() and c.XXSplash 
end
function c27822015.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27822015.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c27822015.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c27822015.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end 
function c27822015.tdfil(c) 
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)  
end 
function c27822015.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27822015.tdfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end 
function c27822015.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c27822015.tdfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT) 
	end 
end 




