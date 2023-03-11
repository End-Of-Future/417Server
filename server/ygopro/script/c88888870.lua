--虔信狂徒
function c88888870.initial_effect(c)
	--copy 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetTarget(c88888870.cptg) 
	e1:SetOperation(c88888870.cpop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e2) 
	--SpecialSummon  
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,88888870) 
	e3:SetCondition(c88888870.spcon)
	e3:SetTarget(c88888870.sptg) 
	e3:SetOperation(c88888870.spop) 
	c:RegisterEffect(e3)
end 
function c88888870.cpfil(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c.SetCard_A_jlcl and c:IsType(TYPE_FIELD)) then return false end
	local te=c.field_effect 
	if not te then return false end
	local tg=te:GetTarget() 
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c88888870.cptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c88888870.cpfil,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end  
end  
function c88888870.cpop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88888870.cpfil,tp,LOCATION_DECK,0,nil,e,tp,eg,ep,ev,re,r,rp) 
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	Duel.ConfirmCards(1-tp,tc) 
	Duel.BreakEffect() 
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te=tc.field_effect 
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end 
	local op=te:GetOperation() 
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end 
end 
function c88888870.ackfil(c) 
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) 
end 
function c88888870.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c88888870.ackfil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)   
end  
function c88888870.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)  
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888870,5))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888870,5))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end  
function c88888870.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 and tc:IsRelateToEffect(e) then  
	Duel.CalculateDamage(c,tc) 
	end 
end  








