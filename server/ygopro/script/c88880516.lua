--王牌竞赛 小丑
function c88880516.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88880516) 
	e1:SetCost(c88880516.sptcost)
	e1:SetTarget(c88880516.spttg) 
	e1:SetOperation(c88880516.sptop) 
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,18880516)
	e2:SetTarget(c88880516.tktg)
	e2:SetOperation(c88880516.tkop)
	c:RegisterEffect(e2)
end 
function c88880516.sptcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return not e:GetHandler():IsPublic() end 
	Duel.ConfirmCards(1-tp,e:GetHandler()) 
end 
function c88880516.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0xd88) and not c:IsCode(88880516)  
end 
function c88880516.spttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c88880516.thfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,c88880516.thfil,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c88880516.sptop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT) 
	end 
end  
function c88880516.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,88880517,nil,TYPES_TOKEN_MONSTER,2100,0,4,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c88880516.tkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,88880517,nil,TYPES_TOKEN_MONSTER,2100,0,4,RACE_WARRIOR,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,88880517)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c88880516.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c88880516.splimit(e,c)
	return not c:IsSetCard(0xd88) 
end








