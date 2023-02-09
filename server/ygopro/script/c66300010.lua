--小猫突击
function c66300010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,66300010)
	e1:SetCost(c66300010.accost)
	e1:SetTarget(c66300010.actg) 
	e1:SetOperation(c66300010.acop)
	c:RegisterEffect(e1)  
	--to hand and des 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,66300010) 
	e2:SetCost(aux.bfgcost) 
	e2:SetTarget(c66300010.thdtg) 
	e2:SetOperation(c66300010.thdop) 
	c:RegisterEffect(e2) 
	if not c66300010.global_check then
		c66300010.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c66300010.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MSET)
		ge1:SetOperation(c66300010.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	Duel.AddCustomActivityCounter(66300010,ACTIVITY_SPSUMMON,c66300010.counterfilter)
end
function c66300010.counterfilter(c)
	return not c:IsLocation(LOCATION_EXTRA) 
end
function c66300010.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,66300010,RESET_PHASE+PHASE_END,0,1)
end
function c66300010.accost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetCustomActivityCount(703897,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetFlagEffect(tp,66300010)==0 end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c66300010.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c66300010.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c66300010.thgck(g) 
	return g:FilterCount(Card.IsCode,nil,10000009)==1 
	   and g:FilterCount(Card.IsCode,nil,10000008)==1   
end 
function c66300010.actg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(c66300010.thgck,2,2) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK) 
end 
function c66300010.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil) 
	if g:CheckSubGroup(c66300010.thgck,2,2) then 
		local sg=g:SelectSubGroup(tp,c66300010.thgck,false,2,2) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)  
	end 
end 
function c66300010.thfil(c) 
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()   
end 
function c66300010.thdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c66300010.thfil,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)  
end 
function c66300010.thdop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c66300010.thfil,tp,LOCATION_SZONE,0,nil) 
	if g:GetCount()>0 then  
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) then 
			local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst() 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			Duel.Destroy(tc,REASON_EFFECT) 
		end 
	end 
end  







