--激流-后浪奔逐
function c27822003.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCondition(c27822003.accon) 
	e1:SetTarget(c27822003.actg) 
	e1:SetOperation(c27822003.acop) 
	c:RegisterEffect(e1) 
end
c27822003.XXSplash=true   
function c27822003.ckfil(c) 
	return c:IsFaceup() and c.XXSplash  
end 
function c27822003.accon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(c27822003.ckfil,tp,LOCATION_MZONE,0,1,nil)  
end 
function c27822003.thfil(c) 
	return c:IsType(TYPE_MONSTER) and c.XXSplash and c:IsAbleToHand()  
end 
function c27822003.spfil(c,e,tp) 
	return c:IsType(TYPE_MONSTER) and c.XXSplash and c:IsCanBeSpecialSummoned(e,0,tp,false,false)   
end 
function c27822003.actg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local b1=Duel.GetFlagEffect(tp,27822003)==0 and Duel.IsExistingMatchingCard(c27822003.thfil,tp,LOCATION_DECK,0,1,nil) 
	local b2=Duel.GetFlagEffect(tp,17822003)==0 and Duel.IsExistingMatchingCard(c27822003.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 end 
	local op=0 
	if b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(27822003,1),aux.Stringid(27822003,2)) 
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(27822003,1)) 
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(27822003,2))+1 
	end 
	if op==0 then 
	Duel.RegisterFlagEffect(tp,27822003,RESET_PHASE+PHASE_END,0,1)
	elseif op==1 then 
	Duel.RegisterFlagEffect(tp,17822003,RESET_PHASE+PHASE_END,0,1)
	end 
	e:SetLabel(op) 
end 
function c27822003.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local op=e:GetLabel() 
	local g1=Duel.GetMatchingGroup(c27822003.thfil,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c27822003.spfil,tp,LOCATION_DECK,0,nil,e,tp)
	if op==0 and g1:GetCount()>0 then 
	local sg=g1:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg)  
	elseif op==1 and g2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local sc=g2:Select(tp,1,1,nil):GetFirst() 
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2) 
	end 
end  





