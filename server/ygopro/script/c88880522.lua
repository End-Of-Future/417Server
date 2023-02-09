--关键时刻！就别开玩笑了！
function c88880522.initial_effect(c) 
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetTarget(c88880522.sptg) 
	e1:SetOperation(c88880522.spop) 
	c:RegisterEffect(e1) 
	--disable
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)   
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCondition(c88880522.discon)
	e2:SetTarget(c88880522.distg)
	e2:SetOperation(c88880522.disop)
	c:RegisterEffect(e2)
end
function c88880522.ckfil(c,e,tp) 
	return c:IsFaceup() and c:IsSetCard(0xd88) and Duel.IsExistingMatchingCard(c88880522.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,c) 
end 
function c88880522.spfil(c,e,tp,sc) 
	local code=sc:GetCode() 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code) and c:IsSetCard(0xd88)  
end 
function c88880522.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c88880522.ckfil,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,c88880522.ckfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c88880522.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()   
	local g=Duel.GetMatchingGroup(c88880522.spfil,tp,LOCATION_DECK,0,nil,e,tp,c)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c88880522.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c88880522.splimit(e,c)
	return not c:IsSetCard(0xd88) 
end
function c88880522.discon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xd88) end,tp,LOCATION_MZONE,0,1,nil)  
end 
function c88880522.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end 
function c88880522.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end 











