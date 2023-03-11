--超高校级的剧情反转
function c88882115.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,88882115+EFFECT_COUNT_CODE_OATH)  
	e1:SetTarget(c88882115.sptg) 
	e1:SetOperation(c88882115.spop) 
	c:RegisterEffect(e1) 
end 
c88882115.ACGXJre=true 
function c88882115.ckfil(c,e,tp) 
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c88882115.spfil,tp,LOCATION_GRAVE,0,1,c,e,tp)  
end  
function c88882115.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.ACGXJre   
end 
function c88882115.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c88882115.ckfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c88882115.ckfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) 
end 
function c88882115.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c88882115.spfil,tp,LOCATION_GRAVE,0,tc,e,tp) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 








	
