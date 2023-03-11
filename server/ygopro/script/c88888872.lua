--迦拉克隆之盾
function c88888872.initial_effect(c)
	--SpecialSummon  
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,88888872) 
	e1:SetCost(c88888872.spcost)
	e1:SetTarget(c88888872.sptg)   
	e1:SetOperation(c88888872.spop) 
	c:RegisterEffect(e1) 
	--copy 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,18888872) 
	e1:SetTarget(c88888872.cptg) 
	e1:SetOperation(c88888872.cpop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e2) 
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(function(e,c)
	return not c:IsCode(88888872) end)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--atk limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e4:SetValue(function(e,c)
	return not c:IsCode(88888872) end) 
	c:RegisterEffect(e4)
end
function c88888872.pbfil(c) 
	return c.SetCard_A_jlcl and c:IsType(TYPE_FIELD) and not c:IsPublic()  
end 
function c88888872.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.IsExistingMatchingCard(c88888872.pbfil,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c88888872.pbfil,tp,LOCATION_HAND,0,1,1,nil) 
	g:AddCard(e:GetHandler()) 
	Duel.ConfirmCards(1-tp,g) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888872,5))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888872,5))
end 
function c88888872.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end   
function c88888872.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 
function c88888872.cpfil(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c.SetCard_A_jlcl and c:IsType(TYPE_FIELD)) then return false end
	local te=c.field_effect 
	if not te then return false end
	local tg=te:GetTarget() 
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c88888872.cptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c88888872.cpfil,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end  
end  
function c88888872.cpop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88888872.cpfil,tp,LOCATION_DECK,0,nil,e,tp,eg,ep,ev,re,r,rp) 
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	Duel.ConfirmCards(1-tp,tc) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888872,6))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888872,6))
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









